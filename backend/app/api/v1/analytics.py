"""
Analytics API endpoints.

Handles analytics and reporting with 30-day payment policy integration.
"""

from datetime import datetime, date, timedelta
from typing import Dict, Any, List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query, Path
from sqlalchemy.orm import Session
from sqlalchemy import and_
from pydantic import BaseModel, Field

from ...core.database import get_db
from ...api.deps import get_current_user
from ...core.logging import get_logger
from ...domain.models.user import User
from ...services.analytics_service import AnalyticsService

logger = get_logger(__name__)
router = APIRouter(prefix="/analytics", tags=["analytics"])


class AnalyticsPeriod(BaseModel):
    """Request model for analytics period."""
    
    period_start: Optional[date] = Field(None, description="Start date for analytics period")
    period_end: Optional[date] = Field(None, description="End date for analytics period")


@router.get("/executive/{user_id}/performance")
async def get_executive_performance(
    user_id: int = Path(..., description="User ID"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get executive performance analytics.
    
    This endpoint provides comprehensive performance metrics for sales executives
    including sales data, payment metrics, and performance indicators based on
    the 30-day payment policy.
    
    Args:
        user_id: User ID to get performance for
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing executive performance metrics
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view performance for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view performance for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get executive performance
        performance = await analytics_service.get_executive_performance(
            user_id, tenant_id, period_start, period_end
        )
        
        if "error" in performance:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=performance["error"]
            )
        
        return performance
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executive_performance: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executive performance: {str(e)}"
        )


@router.get("/shop/{shop_id}/analytics")
async def get_shop_analytics(
    shop_id: int = Path(..., description="Shop ID"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get shop-specific analytics.
    
    This endpoint provides detailed analytics for individual shops including
    order patterns, payment behavior, and performance metrics based on the
    30-day payment policy.
    
    Args:
        shop_id: Shop ID to get analytics for
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing shop analytics
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view shop analytics for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view shop analytics for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get shop analytics
        analytics = await analytics_service.get_shop_analytics(
            shop_id, tenant_id, period_start, period_end
        )
        
        if "error" in analytics:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=analytics["error"]
            )
        
        return analytics
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_analytics: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop analytics: {str(e)}"
        )


@router.get("/payments/analytics")
async def get_payment_analytics(
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get payment analytics for a tenant.
    
    This endpoint provides comprehensive payment analytics including current,
    upcoming, and overdue payments based on the 30-day payment policy.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing payment analytics
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view payment analytics for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view payment analytics for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get payment analytics
        analytics = await analytics_service.get_payment_analytics(
            tenant_id, period_start, period_end
        )
        
        if "error" in analytics:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=analytics["error"]
            )
        
        return analytics
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_payment_analytics: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get payment analytics: {str(e)}"
        )


@router.get("/payments/overdue")
async def get_overdue_analysis(
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get overdue payments analysis.
    
    This endpoint provides detailed analysis of overdue payments including
    shop-level breakdown and payment trends based on the 30-day payment policy.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing overdue analysis
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view overdue analysis for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view overdue analysis for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get overdue analysis
        analysis = await analytics_service.get_overdue_analysis(tenant_id)
        
        if "error" in analysis:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=analysis["error"]
            )
        
        return analysis
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_overdue_analysis: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get overdue analysis: {str(e)}"
        )


@router.get("/products/best-selling")
async def get_best_selling_products(
    tenant_id: str = Query(..., description="Tenant identifier"),
    limit: int = Query(10, description="Maximum number of products to return", ge=1, le=50),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get best selling products analysis.
    
    This endpoint provides analysis of best selling products based on
    total sales amount and order frequency.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        limit: Maximum number of products to return (1-50)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing best selling products analysis
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view product analytics for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view product analytics for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get best selling products
        products = await analytics_service.get_best_selling_products(tenant_id, limit)
        
        if "error" in products:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=products["error"]
            )
        
        return products
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_best_selling_products: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get best selling products: {str(e)}"
        )


@router.get("/executives/summary")
async def get_executives_summary(
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get summary of all executives' performance.
    
    This endpoint provides a summary view of all sales executives'
    performance metrics for the specified period.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing executives summary
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view executives summary for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view executives summary for this tenant"
            )
        
        # Set default period if not provided
        if not period_end:
            period_end = date.today()
        if not period_start:
            period_start = period_end - timedelta(days=30)
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get all sales executives for the tenant
        from ...domain.models.user import User
        executives = db.query(User).filter(
            and_(
                User.tenant_id == tenant_id,
                User.role.in_(["sales_executive", "area_manager"])
            )
        ).all()
        
        executives_summary = []
        for executive in executives:
            performance = await analytics_service.get_executive_performance(
                executive.id, tenant_id, period_start, period_end
            )
            
            if "error" not in performance:
                executives_summary.append({
                    "user_id": executive.id,
                    "user_name": executive.name,
                    "role": executive.role.value,
                    "performance_level": performance.get("performance_level", "unknown"),
                    "payment_collection_rate": performance.get("performance_metrics", {}).get("payment_collection_rate", 0.0),
                    "total_orders": performance.get("performance_metrics", {}).get("total_orders", 0),
                    "total_order_value": performance.get("performance_metrics", {}).get("total_order_value", 0.0),
                    "overdue_payments": performance.get("performance_metrics", {}).get("overdue_payments", 0.0)
                })
        
        # Sort by performance level and payment collection rate
        executives_summary.sort(
            key=lambda x: (
                ["excellent", "good", "average", "poor", "critical"].index(x["performance_level"]),
                -x["payment_collection_rate"]
            )
        )
        
        return {
            "tenant_id": tenant_id,
            "period_start": period_start.isoformat(),
            "period_end": period_end.isoformat(),
            "total_executives": len(executives_summary),
            "executives": executives_summary,
            "summary_date": datetime.utcnow().isoformat()
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executives_summary: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executives summary: {str(e)}"
        )


@router.get("/shops/summary")
async def get_shops_summary(
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get summary of all shops' analytics.
    
    This endpoint provides a summary view of all shops'
    analytics metrics for the specified period.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing shops summary
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view shops summary for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view shops summary for this tenant"
            )
        
        # Set default period if not provided
        if not period_end:
            period_end = date.today()
        if not period_start:
            period_start = period_end - timedelta(days=30)
        
        # Initialize analytics service
        analytics_service = AnalyticsService(db)
        
        # Get all shops for the tenant
        from ...domain.models.shop import Shop
        shops = db.query(Shop).filter(Shop.tenant_id == tenant_id).all()
        
        shops_summary = []
        for shop in shops:
            analytics = await analytics_service.get_shop_analytics(
                shop.id, tenant_id, period_start, period_end
            )
            
            if "error" not in analytics:
                shops_summary.append({
                    "shop_id": shop.id,
                    "shop_name": shop.name,
                    "shop_code": shop.shop_id,
                    "performance_level": analytics.get("performance_level", "unknown"),
                    "payment_collection_rate": analytics.get("analytics_metrics", {}).get("payment_collection_rate", 0.0),
                    "total_orders": analytics.get("analytics_metrics", {}).get("total_orders", 0),
                    "total_order_value": analytics.get("analytics_metrics", {}).get("total_order_value", 0.0),
                    "overdue_payment": analytics.get("analytics_metrics", {}).get("overdue_payment", 0.0),
                    "product_diversity": analytics.get("analytics_metrics", {}).get("product_diversity", 0)
                })
        
        # Sort by performance level and payment collection rate
        shops_summary.sort(
            key=lambda x: (
                ["excellent", "good", "average", "poor", "critical"].index(x["performance_level"]),
                -x["payment_collection_rate"]
            )
        )
        
        return {
            "tenant_id": tenant_id,
            "period_start": period_start.isoformat(),
            "period_end": period_end.isoformat(),
            "total_shops": len(shops_summary),
            "shops": shops_summary,
            "summary_date": datetime.utcnow().isoformat()
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shops_summary: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shops summary: {str(e)}"
        )
