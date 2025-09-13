"""
Sync service for client data synchronization.

Handles daily synchronization of data from client systems with 30-day payment policy.
"""

import asyncio
import httpx
from datetime import datetime, date, timedelta
from typing import Dict, List, Optional, Tuple, Any
from sqlalchemy.orm import Session
from sqlalchemy import and_, desc
import logging

from ..core.config import settings
from ..core.logging import get_logger
from ..domain.models.sync_data import (
    SyncedShopData, SyncedOrder, SyncedProduct,
    SyncStatus, PaymentStatus,
    calculate_due_date, calculate_payment_status, calculate_shop_payment_summary
)
from ..domain.models.shop import Shop

logger = get_logger(__name__)


class SyncService:
    """Service for synchronizing data from client systems."""
    
    def __init__(self, db: Session):
        """Initialize sync service with database session."""
        self.db = db
        self.settings = settings
    
    async def sync_client_data(self, tenant_id: str, client_api_url: str) -> Dict[str, Any]:
        """
        Sync data from client's API with 30-day payment policy.
        
        Args:
            tenant_id: Tenant identifier
            client_api_url: Client API URL for data fetching
            
        Returns:
            Dict containing sync results and statistics
        """
        logger.info(f"Starting sync for tenant {tenant_id}")
        
        try:
            # Fetch data from client API
            client_data = await self._fetch_client_data(tenant_id, client_api_url)
            
            if not client_data or client_data.get("status") != "success":
                error_msg = f"Failed to fetch data from client API: {client_data.get('message', 'Unknown error')}"
                logger.error(error_msg)
                return {
                    "status": "failed",
                    "message": error_msg,
                    "shops_processed": 0,
                    "orders_processed": 0,
                    "products_processed": 0
                }
            
            # Process sync data
            result = await self._process_sync_data(tenant_id, client_data)
            
            logger.info(f"Sync completed for tenant {tenant_id}: {result}")
            return result
            
        except Exception as e:
            error_msg = f"Sync failed for tenant {tenant_id}: {str(e)}"
            logger.error(error_msg, exc_info=True)
            return {
                "status": "failed",
                "message": error_msg,
                "shops_processed": 0,
                "orders_processed": 0,
                "products_processed": 0
            }
    
    async def _fetch_client_data(self, tenant_id: str, client_api_url: str) -> Dict[str, Any]:
        """
        Fetch data from client API.
        
        Args:
            tenant_id: Tenant identifier
            client_api_url: Client API URL
            
        Returns:
            Client data response
        """
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(
                    f"{client_api_url}?tenant_id={tenant_id}",
                    headers={"Accept": "application/json"}
                )
                response.raise_for_status()
                return response.json()
                
        except httpx.TimeoutException:
            logger.error(f"Timeout while fetching data from client API for tenant {tenant_id}")
            raise Exception("Client API timeout")
        except httpx.HTTPStatusError as e:
            logger.error(f"HTTP error while fetching data from client API: {e.response.status_code}")
            raise Exception(f"Client API HTTP error: {e.response.status_code}")
        except Exception as e:
            logger.error(f"Error fetching data from client API: {str(e)}")
            raise
    
    async def _process_sync_data(self, tenant_id: str, client_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Process client data and store in database with 30-day payment policy.
        
        Args:
            tenant_id: Tenant identifier
            client_data: Client data response
            
        Returns:
            Processing results
        """
        shops_data = client_data.get("shops", [])
        shops_processed = 0
        orders_processed = 0
        products_processed = 0
        
        for shop_data in shops_data:
            try:
                # Process shop data
                synced_shop = await self._process_shop_data(tenant_id, shop_data)
                if synced_shop:
                    shops_processed += 1
                    
                    # Process orders for this shop
                    orders = shop_data.get("orders", [])
                    for order_data in orders:
                        synced_order = await self._process_order_data(tenant_id, synced_shop.id, order_data)
                        if synced_order:
                            orders_processed += 1
                            
                            # Process products for this order
                            products = order_data.get("products", [])
                            for product_data in products:
                                synced_product = await self._process_product_data(
                                    tenant_id, synced_shop.id, synced_order.id, product_data
                                )
                                if synced_product:
                                    products_processed += 1
                
            except Exception as e:
                logger.error(f"Error processing shop data for shop {shop_data.get('shop_id')}: {str(e)}")
                continue
        
        # Update shop sync status
        await self._update_shop_sync_status(tenant_id, SyncStatus.COMPLETED)
        
        return {
            "status": "success",
            "message": "Data synchronized successfully",
            "shops_processed": shops_processed,
            "orders_processed": orders_processed,
            "products_processed": products_processed,
            "sync_timestamp": datetime.utcnow().isoformat()
        }
    
    async def _process_shop_data(self, tenant_id: str, shop_data: Dict[str, Any]) -> Optional[SyncedShopData]:
        """
        Process individual shop data with 30-day payment policy.
        
        Args:
            tenant_id: Tenant identifier
            shop_data: Shop data from client
            
        Returns:
            SyncedShopData instance or None
        """
        try:
            shop_id = shop_data.get("shop_id")
            shop_name = shop_data.get("shop_name")
            
            if not shop_id or not shop_name:
                logger.warning(f"Invalid shop data: missing shop_id or shop_name")
                return None
            
            # Calculate payment summary from orders
            orders = shop_data.get("orders", [])
            current_payment, upcoming_payment, overdue_payment = self._calculate_payment_summary(orders)
            
            # Check if shop data already exists
            existing_shop = self.db.query(SyncedShopData).filter(
                and_(
                    SyncedShopData.shop_id == str(shop_id),
                    SyncedShopData.tenant_id == tenant_id
                )
            ).first()
            
            if existing_shop:
                # Update existing shop data
                existing_shop.shop_name = shop_name
                existing_shop.current_payment = current_payment
                existing_shop.upcoming_payment = upcoming_payment
                existing_shop.overdue_payment = overdue_payment
                existing_shop.sync_date = datetime.utcnow()
                existing_shop.sync_status = SyncStatus.COMPLETED
                existing_shop.sync_error = None
                existing_shop.raw_client_data = shop_data
                existing_shop.updated_at = datetime.utcnow()
                
                self.db.commit()
                return existing_shop
            else:
                # Create new shop data
                new_shop = SyncedShopData(
                    shop_id=str(shop_id),
                    shop_name=shop_name,
                    tenant_id=tenant_id,
                    current_payment=current_payment,
                    upcoming_payment=upcoming_payment,
                    overdue_payment=overdue_payment,
                    sync_date=datetime.utcnow(),
                    sync_status=SyncStatus.COMPLETED,
                    raw_client_data=shop_data
                )
                
                self.db.add(new_shop)
                self.db.commit()
                self.db.refresh(new_shop)
                return new_shop
                
        except Exception as e:
            logger.error(f"Error processing shop data: {str(e)}")
            self.db.rollback()
            return None
    
    async def _process_order_data(self, tenant_id: str, shop_data_id: int, order_data: Dict[str, Any]) -> Optional[SyncedOrder]:
        """
        Process individual order data with 30-day payment policy.
        
        Args:
            tenant_id: Tenant identifier
            shop_data_id: Shop data ID
            order_data: Order data from client
            
        Returns:
            SyncedOrder instance or None
        """
        try:
            order_id = order_data.get("order_id")
            order_date_str = order_data.get("order_date")
            order_amount = order_data.get("order_amount", 0.0)
            
            if not order_id or not order_date_str:
                logger.warning(f"Invalid order data: missing order_id or order_date")
                return None
            
            # Parse order date
            order_date = datetime.strptime(order_date_str, "%Y-%m-%d").date()
            
            # Calculate 30-day payment policy
            due_date = calculate_due_date(order_date)
            payment_status, days_overdue = calculate_payment_status(due_date)
            
            # Check if order already exists
            existing_order = self.db.query(SyncedOrder).filter(
                and_(
                    SyncedOrder.order_id == str(order_id),
                    SyncedOrder.tenant_id == tenant_id
                )
            ).first()
            
            if existing_order:
                # Update existing order
                existing_order.order_date = order_date
                existing_order.order_amount = order_amount
                existing_order.due_date = due_date
                existing_order.payment_status = payment_status
                existing_order.days_overdue = days_overdue
                existing_order.sync_date = datetime.utcnow()
                existing_order.raw_order_data = order_data
                existing_order.updated_at = datetime.utcnow()
                
                self.db.commit()
                return existing_order
            else:
                # Create new order
                new_order = SyncedOrder(
                    order_id=str(order_id),
                    order_date=order_date,
                    order_amount=order_amount,
                    due_date=due_date,
                    payment_status=payment_status,
                    days_overdue=days_overdue,
                    shop_data_id=shop_data_id,
                    tenant_id=tenant_id,
                    sync_date=datetime.utcnow(),
                    raw_order_data=order_data
                )
                
                self.db.add(new_order)
                self.db.commit()
                self.db.refresh(new_order)
                return new_order
                
        except Exception as e:
            logger.error(f"Error processing order data: {str(e)}")
            self.db.rollback()
            return None
    
    async def _process_product_data(self, tenant_id: str, shop_data_id: int, order_id: int, product_data: Dict[str, Any]) -> Optional[SyncedProduct]:
        """
        Process individual product data.
        
        Args:
            tenant_id: Tenant identifier
            shop_data_id: Shop data ID
            order_id: Order ID
            product_data: Product data from client
            
        Returns:
            SyncedProduct instance or None
        """
        try:
            product_name = product_data.get("product_name")
            product_amount = product_data.get("product_amount", 0.0)
            
            if not product_name:
                logger.warning(f"Invalid product data: missing product_name")
                return None
            
            # Create new product
            new_product = SyncedProduct(
                product_name=product_name,
                product_amount=product_amount,
                shop_data_id=shop_data_id,
                order_id=order_id,
                tenant_id=tenant_id,
                sync_date=datetime.utcnow(),
                raw_product_data=product_data
            )
            
            self.db.add(new_product)
            self.db.commit()
            self.db.refresh(new_product)
            return new_product
            
        except Exception as e:
            logger.error(f"Error processing product data: {str(e)}")
            self.db.rollback()
            return None
    
    def _calculate_payment_summary(self, orders: List[Dict[str, Any]]) -> Tuple[float, float, float]:
        """
        Calculate payment summary from orders using 30-day policy.
        
        Args:
            orders: List of order data
            
        Returns:
            Tuple of (current_payment, upcoming_payment, overdue_payment)
        """
        current = 0.0
        upcoming = 0.0
        overdue = 0.0
        
        for order in orders:
            try:
                order_date_str = order.get("order_date")
                order_amount = order.get("order_amount", 0.0)
                
                if not order_date_str:
                    continue
                
                order_date = datetime.strptime(order_date_str, "%Y-%m-%d").date()
                due_date = calculate_due_date(order_date)
                payment_status, _ = calculate_payment_status(due_date)
                
                if payment_status == PaymentStatus.CURRENT:
                    current += order_amount
                elif payment_status == PaymentStatus.UPCOMING:
                    upcoming += order_amount
                elif payment_status == PaymentStatus.OVERDUE:
                    overdue += order_amount
                    
            except Exception as e:
                logger.warning(f"Error calculating payment for order: {str(e)}")
                continue
        
        return current, upcoming, overdue
    
    async def _update_shop_sync_status(self, tenant_id: str, status: SyncStatus):
        """
        Update shop sync status in the main shops table.
        
        Args:
            tenant_id: Tenant identifier
            status: Sync status
        """
        try:
            shops = self.db.query(Shop).filter(Shop.tenant_id == tenant_id).all()
            for shop in shops:
                shop.last_sync_date = datetime.utcnow()
                shop.sync_status = status.value
                shop.sync_error = None
            
            self.db.commit()
            logger.info(f"Updated sync status for {len(shops)} shops in tenant {tenant_id}")
            
        except Exception as e:
            logger.error(f"Error updating shop sync status: {str(e)}")
            self.db.rollback()
    
    async def get_sync_status(self, tenant_id: str) -> Dict[str, Any]:
        """
        Get sync status for a tenant.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            Sync status information
        """
        try:
            # Get latest sync data
            latest_sync = self.db.query(SyncedShopData).filter(
                SyncedShopData.tenant_id == tenant_id
            ).order_by(desc(SyncedShopData.sync_date)).first()
            
            if not latest_sync:
                return {
                    "status": "not_synced",
                    "message": "No sync data found",
                    "last_sync_date": None,
                    "shops_count": 0,
                    "orders_count": 0,
                    "products_count": 0
                }
            
            # Get counts
            shops_count = self.db.query(SyncedShopData).filter(
                SyncedShopData.tenant_id == tenant_id
            ).count()
            
            orders_count = self.db.query(SyncedOrder).filter(
                SyncedOrder.tenant_id == tenant_id
            ).count()
            
            products_count = self.db.query(SyncedProduct).filter(
                SyncedProduct.tenant_id == tenant_id
            ).count()
            
            return {
                "status": latest_sync.sync_status.value,
                "message": "Sync data available",
                "last_sync_date": latest_sync.sync_date.isoformat(),
                "shops_count": shops_count,
                "orders_count": orders_count,
                "products_count": products_count
            }
            
        except Exception as e:
            logger.error(f"Error getting sync status: {str(e)}")
            return {
                "status": "error",
                "message": f"Error getting sync status: {str(e)}",
                "last_sync_date": None,
                "shops_count": 0,
                "orders_count": 0,
                "products_count": 0
            }
    
    async def get_payment_summary(self, tenant_id: str) -> Dict[str, Any]:
        """
        Get payment summary for a tenant.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            Payment summary information
        """
        try:
            # Get all synced shop data
            shops_data = self.db.query(SyncedShopData).filter(
                SyncedShopData.tenant_id == tenant_id
            ).all()
            
            total_current = sum(shop.current_payment for shop in shops_data)
            total_upcoming = sum(shop.upcoming_payment for shop in shops_data)
            total_overdue = sum(shop.overdue_payment for shop in shops_data)
            
            return {
                "total_current_payment": total_current,
                "total_upcoming_payment": total_upcoming,
                "total_overdue_payment": total_overdue,
                "total_payment": total_current + total_upcoming + total_overdue,
                "shops_count": len(shops_data),
                "summary_date": datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error getting payment summary: {str(e)}")
            return {
                "total_current_payment": 0.0,
                "total_upcoming_payment": 0.0,
                "total_overdue_payment": 0.0,
                "total_payment": 0.0,
                "shops_count": 0,
                "summary_date": datetime.utcnow().isoformat()
            }
