"""
Scheduled tasks and background jobs.

Handles automated data synchronization, analytics processing,
and other scheduled tasks with proper error handling and monitoring.
"""

import asyncio
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Any
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.interval import IntervalTrigger
from apscheduler.events import EVENT_JOB_EXECUTED, EVENT_JOB_ERROR
import logging

from .config import settings
from .logging import get_logger
from ..services.sync_service import SyncService
from ..services.analytics_service import AnalyticsService
from ..core.database import get_db

logger = get_logger(__name__)


class TaskScheduler:
    """
    Scheduler for automated tasks and background jobs.
    
    Handles data synchronization, analytics processing, and other
    scheduled tasks with comprehensive error handling and monitoring.
    """
    
    def __init__(self):
        """Initialize the task scheduler."""
        self.scheduler = AsyncIOScheduler()
        self.sync_service: Optional[SyncService] = None
        self.analytics_service: Optional[AnalyticsService] = None
        self.is_running = False
        
        # Setup event listeners
        self.scheduler.add_listener(self._job_executed, EVENT_JOB_EXECUTED)
        self.scheduler.add_listener(self._job_error, EVENT_JOB_ERROR)
    
    async def start(self):
        """Start the scheduler and initialize services."""
        try:
            if not settings.sync_enabled:
                logger.info("Sync is disabled in configuration")
                return
            
            # Initialize services
            await self._initialize_services()
            
            # Add scheduled jobs
            self._add_sync_jobs()
            self._add_analytics_jobs()
            self._add_cleanup_jobs()
            
            # Start scheduler
            self.scheduler.start()
            self.is_running = True
            
            logger.info("Task scheduler started successfully")
            
        except Exception as e:
            logger.error(f"Failed to start task scheduler: {str(e)}", exc_info=True)
            raise
    
    async def stop(self):
        """Stop the scheduler gracefully."""
        try:
            if self.scheduler.running:
                self.scheduler.shutdown(wait=True)
            self.is_running = False
            logger.info("Task scheduler stopped successfully")
        except Exception as e:
            logger.error(f"Error stopping task scheduler: {str(e)}", exc_info=True)
    
    async def _initialize_services(self):
        """Initialize required services."""
        try:
            # Get database session
            db = next(get_db())
            
            # Initialize services
            self.sync_service = SyncService(db)
            self.analytics_service = AnalyticsService(db)
            
            logger.info("Services initialized successfully")
            
        except Exception as e:
            logger.error(f"Failed to initialize services: {str(e)}", exc_info=True)
            raise
    
    def _add_sync_jobs(self):
        """Add data synchronization jobs."""
        if not settings.sync_enabled:
            return
        
        # Daily sync job at 2 AM
        self.scheduler.add_job(
            func=self._daily_sync_job,
            trigger=CronTrigger(hour=2, minute=0),
            id="daily_sync",
            name="Daily Data Sync",
            max_instances=1,
            replace_existing=True
        )
        
        # Hourly sync status check
        self.scheduler.add_job(
            func=self._sync_status_check,
            trigger=IntervalTrigger(hours=1),
            id="sync_status_check",
            name="Sync Status Check",
            max_instances=1,
            replace_existing=True
        )
        
        # Retry failed syncs every 6 hours
        self.scheduler.add_job(
            func=self._retry_failed_syncs,
            trigger=IntervalTrigger(hours=6),
            id="retry_failed_syncs",
            name="Retry Failed Syncs",
            max_instances=1,
            replace_existing=True
        )
        
        logger.info("Sync jobs added to scheduler")
    
    def _add_analytics_jobs(self):
        """Add analytics processing jobs."""
        if not settings.analytics_enabled:
            return
        
        # Daily analytics processing at 3 AM
        self.scheduler.add_job(
            func=self._daily_analytics_job,
            trigger=CronTrigger(hour=3, minute=0),
            id="daily_analytics",
            name="Daily Analytics Processing",
            max_instances=1,
            replace_existing=True
        )
        
        # Weekly analytics summary at 4 AM on Mondays
        self.scheduler.add_job(
            func=self._weekly_analytics_summary,
            trigger=CronTrigger(day_of_week=0, hour=4, minute=0),
            id="weekly_analytics_summary",
            name="Weekly Analytics Summary",
            max_instances=1,
            replace_existing=True
        )
        
        logger.info("Analytics jobs added to scheduler")
    
    def _add_cleanup_jobs(self):
        """Add cleanup and maintenance jobs."""
        # Daily cleanup of old data at 5 AM
        self.scheduler.add_job(
            func=self._daily_cleanup_job,
            trigger=CronTrigger(hour=5, minute=0),
            id="daily_cleanup",
            name="Daily Cleanup",
            max_instances=1,
            replace_existing=True
        )
        
        # Weekly database optimization at 6 AM on Sundays
        self.scheduler.add_job(
            func=self._weekly_db_optimization,
            trigger=CronTrigger(day_of_week=6, hour=6, minute=0),
            id="weekly_db_optimization",
            name="Weekly Database Optimization",
            max_instances=1,
            replace_existing=True
        )
        
        logger.info("Cleanup jobs added to scheduler")
    
    async def _daily_sync_job(self):
        """Daily data synchronization job."""
        try:
            logger.info("Starting daily sync job")
            
            if not self.sync_service:
                logger.error("Sync service not initialized")
                return
            
            # Get all active tenants
            tenants = await self._get_active_tenants()
            
            sync_results = []
            for tenant_id in tenants:
                try:
                    result = await self.sync_service.sync_client_data(
                        tenant_id, 
                        settings.client_api_url
                    )
                    sync_results.append({
                        "tenant_id": tenant_id,
                        "status": "success",
                        "result": result
                    })
                    logger.info(f"Sync completed for tenant {tenant_id}")
                    
                except Exception as e:
                    logger.error(f"Sync failed for tenant {tenant_id}: {str(e)}", exc_info=True)
                    sync_results.append({
                        "tenant_id": tenant_id,
                        "status": "error",
                        "error": str(e)
                    })
            
            # Log summary
            successful = len([r for r in sync_results if r["status"] == "success"])
            failed = len([r for r in sync_results if r["status"] == "error"])
            
            logger.info(f"Daily sync completed: {successful} successful, {failed} failed")
            
        except Exception as e:
            logger.error(f"Daily sync job failed: {str(e)}", exc_info=True)
    
    async def _sync_status_check(self):
        """Check sync status and health."""
        try:
            logger.debug("Running sync status check")
            
            # Check sync service health
            if not self.sync_service:
                logger.warning("Sync service not available")
                return
            
            # Check client API connectivity
            # This would be implemented based on your specific needs
            logger.debug("Sync status check completed")
            
        except Exception as e:
            logger.error(f"Sync status check failed: {str(e)}", exc_info=True)
    
    async def _retry_failed_syncs(self):
        """Retry failed synchronization attempts."""
        try:
            logger.info("Starting retry failed syncs job")
            
            # This would implement retry logic for failed syncs
            # based on your specific requirements
            
            logger.info("Retry failed syncs job completed")
            
        except Exception as e:
            logger.error(f"Retry failed syncs job failed: {str(e)}", exc_info=True)
    
    async def _daily_analytics_job(self):
        """Daily analytics processing job."""
        try:
            logger.info("Starting daily analytics job")
            
            if not self.analytics_service:
                logger.error("Analytics service not initialized")
                return
            
            # Get all active tenants
            tenants = await self._get_active_tenants()
            
            for tenant_id in tenants:
                try:
                    # Process analytics for each tenant
                    await self._process_tenant_analytics(tenant_id)
                    logger.info(f"Analytics processed for tenant {tenant_id}")
                    
                except Exception as e:
                    logger.error(f"Analytics processing failed for tenant {tenant_id}: {str(e)}", exc_info=True)
            
            logger.info("Daily analytics job completed")
            
        except Exception as e:
            logger.error(f"Daily analytics job failed: {str(e)}", exc_info=True)
    
    async def _weekly_analytics_summary(self):
        """Weekly analytics summary job."""
        try:
            logger.info("Starting weekly analytics summary job")
            
            # Generate weekly analytics summaries
            # This would implement weekly summary generation
            
            logger.info("Weekly analytics summary job completed")
            
        except Exception as e:
            logger.error(f"Weekly analytics summary job failed: {str(e)}", exc_info=True)
    
    async def _daily_cleanup_job(self):
        """Daily cleanup job."""
        try:
            logger.info("Starting daily cleanup job")
            
            # Clean up old data based on retention policies
            await self._cleanup_old_data()
            
            logger.info("Daily cleanup job completed")
            
        except Exception as e:
            logger.error(f"Daily cleanup job failed: {str(e)}", exc_info=True)
    
    async def _weekly_db_optimization(self):
        """Weekly database optimization job."""
        try:
            logger.info("Starting weekly database optimization job")
            
            # Database optimization tasks
            # This would implement database optimization logic
            
            logger.info("Weekly database optimization job completed")
            
        except Exception as e:
            logger.error(f"Weekly database optimization job failed: {str(e)}", exc_info=True)
    
    async def _get_active_tenants(self) -> List[str]:
        """Get list of active tenants."""
        try:
            # This would query the database for active tenants
            # For now, return a default list
            return ["tenant1", "tenant2"]  # Replace with actual tenant query
            
        except Exception as e:
            logger.error(f"Failed to get active tenants: {str(e)}", exc_info=True)
            return []
    
    async def _process_tenant_analytics(self, tenant_id: str):
        """Process analytics for a specific tenant."""
        try:
            # Process executive performance
            await self.analytics_service.get_executive_performance(
                user_id=1,  # This would be dynamic
                tenant_id=tenant_id
            )
            
            # Process payment analytics
            await self.analytics_service.get_payment_analytics(tenant_id)
            
            # Process overdue analysis
            await self.analytics_service.get_overdue_analysis(tenant_id)
            
        except Exception as e:
            logger.error(f"Failed to process analytics for tenant {tenant_id}: {str(e)}", exc_info=True)
            raise
    
    async def _cleanup_old_data(self):
        """Clean up old data based on retention policies."""
        try:
            # Clean up old analytics data
            retention_days = settings.analytics_retention_days
            cutoff_date = datetime.utcnow() - timedelta(days=retention_days)
            
            # This would implement actual cleanup logic
            logger.info(f"Cleaning up data older than {cutoff_date}")
            
        except Exception as e:
            logger.error(f"Failed to cleanup old data: {str(e)}", exc_info=True)
    
    def _job_executed(self, event):
        """Handle job execution events."""
        logger.info(f"Job {event.job_id} executed successfully")
    
    def _job_error(self, event):
        """Handle job error events."""
        logger.error(f"Job {event.job_id} failed with exception: {event.exception}")
    
    def get_job_status(self) -> Dict[str, Any]:
        """Get current job status."""
        jobs = []
        for job in self.scheduler.get_jobs():
            jobs.append({
                "id": job.id,
                "name": job.name,
                "next_run_time": job.next_run_time.isoformat() if job.next_run_time else None,
                "trigger": str(job.trigger)
            })
        
        return {
            "scheduler_running": self.is_running,
            "total_jobs": len(jobs),
            "jobs": jobs
        }


# Global scheduler instance
scheduler: Optional[TaskScheduler] = None


async def get_scheduler() -> TaskScheduler:
    """Get the global scheduler instance."""
    global scheduler
    if scheduler is None:
        scheduler = TaskScheduler()
    return scheduler


async def start_scheduler():
    """Start the global scheduler."""
    global scheduler
    if scheduler is None:
        scheduler = TaskScheduler()
    await scheduler.start()


async def stop_scheduler():
    """Stop the global scheduler."""
    global scheduler
    if scheduler:
        await scheduler.stop()
        scheduler = None
