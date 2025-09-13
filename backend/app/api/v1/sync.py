"""
Sync API endpoints.

Handles data synchronization from client systems with 30-day payment policy.
"""

from datetime import datetime
from typing import Dict, Any, List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from ...core.database import get_db
from ...api.deps import get_current_user
from ...core.logging import get_logger
from ...domain.models.user import User
from ...services.sync_service import SyncService
from ...core.config import settings

logger = get_logger(__name__)
router = APIRouter(prefix="/sync", tags=["sync"])


class SyncRequest(BaseModel):
    """Request model for triggering sync."""
    
    client_api_url: str = Field(..., description="Client API URL for data fetching")
    force_sync: bool = Field(default=False, description="Force sync even if recently synced")


class SyncResponse(BaseModel):
    """Response model for sync operations."""
    
    status: str = Field(..., description="Sync status")
    message: str = Field(..., description="Status message")
    shops_processed: int = Field(..., description="Number of shops processed")
    orders_processed: int = Field(..., description="Number of orders processed")
    products_processed: int = Field(..., description="Number of products processed")
    sync_timestamp: str = Field(..., description="Sync timestamp")


class SyncStatusResponse(BaseModel):
    """Response model for sync status."""
    
    status: str = Field(..., description="Sync status")
    message: str = Field(..., description="Status message")
    last_sync_date: str = Field(None, description="Last sync date")
    shops_count: int = Field(..., description="Number of shops")
    orders_count: int = Field(..., description="Number of orders")
    products_count: int = Field(..., description="Number of products")


class PaymentSummaryResponse(BaseModel):
    """Response model for payment summary."""
    
    total_current_payment: float = Field(..., description="Total current payment")
    total_upcoming_payment: float = Field(..., description="Total upcoming payment")
    total_overdue_payment: float = Field(..., description="Total overdue payment")
    total_payment: float = Field(..., description="Total payment amount")
    shops_count: int = Field(..., description="Number of shops")
    summary_date: str = Field(..., description="Summary date")


@router.post("/client-data", response_model=SyncResponse)
async def sync_client_data(
    tenant_id: str,
    request: SyncRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> SyncResponse:
    """
    Trigger synchronization of data from client API.
    
    This endpoint fetches data from the client's API and processes it with
    the 30-day payment policy. It calculates due dates, payment statuses,
    and overdue amounts for all orders.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        request: Sync request with client API URL
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        SyncResponse with processing results
        
    Raises:
        HTTPException: If sync fails or user lacks permission
    """
    try:
        # Verify user has permission to sync for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to sync data for this tenant"
            )
        
        # Initialize sync service
        sync_service = SyncService(db)
        
        # Perform sync
        result = await sync_service.sync_client_data(tenant_id, request.client_api_url)
        
        # Log sync operation
        logger.info(f"Sync completed for tenant {tenant_id} by user {current_user.id}: {result}")
        
        return SyncResponse(
            status=result["status"],
            message=result["message"],
            shops_processed=result["shops_processed"],
            orders_processed=result["orders_processed"],
            products_processed=result["products_processed"],
            sync_timestamp=result.get("sync_timestamp", datetime.utcnow().isoformat())
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in sync_client_data: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Sync failed: {str(e)}"
        )


@router.get("/status", response_model=SyncStatusResponse)
async def get_sync_status(
    tenant_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> SyncStatusResponse:
    """
    Get synchronization status for a tenant.
    
    This endpoint returns the current sync status, last sync date,
    and counts of synchronized data.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        SyncStatusResponse with sync status information
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view sync status for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view sync status for this tenant"
            )
        
        # Initialize sync service
        sync_service = SyncService(db)
        
        # Get sync status
        status_info = await sync_service.get_sync_status(tenant_id)
        
        return SyncStatusResponse(
            status=status_info["status"],
            message=status_info["message"],
            last_sync_date=status_info["last_sync_date"],
            shops_count=status_info["shops_count"],
            orders_count=status_info["orders_count"],
            products_count=status_info["products_count"]
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_sync_status: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get sync status: {str(e)}"
        )


@router.get("/payment-summary", response_model=PaymentSummaryResponse)
async def get_payment_summary(
    tenant_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> PaymentSummaryResponse:
    """
    Get payment summary for a tenant based on 30-day policy.
    
    This endpoint returns payment summaries including current, upcoming,
    and overdue payments calculated using the 30-day payment policy.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        PaymentSummaryResponse with payment summary information
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view payment summary for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view payment summary for this tenant"
            )
        
        # Initialize sync service
        sync_service = SyncService(db)
        
        # Get payment summary
        summary = await sync_service.get_payment_summary(tenant_id)
        
        return PaymentSummaryResponse(
            total_current_payment=summary["total_current_payment"],
            total_upcoming_payment=summary["total_upcoming_payment"],
            total_overdue_payment=summary["total_overdue_payment"],
            total_payment=summary["total_payment"],
            shops_count=summary["shops_count"],
            summary_date=summary["summary_date"]
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_payment_summary: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get payment summary: {str(e)}"
        )


@router.get("/shops/{shop_id}/synced-data")
async def get_shop_synced_data(
    tenant_id: str,
    shop_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get synchronized data for a specific shop.
    
    This endpoint returns all synchronized data for a specific shop,
    including orders, products, and payment information.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        shop_id: Shop identifier
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing shop synchronized data
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view shop data for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view shop data for this tenant"
            )
        
        # Initialize sync service
        sync_service = SyncService(db)
        
        # Get shop synced data
        from ...domain.models.sync_data import SyncedShopData, SyncedOrder, SyncedProduct
        
        shop_data = db.query(SyncedShopData).filter(
            SyncedShopData.shop_id == shop_id,
            SyncedShopData.tenant_id == tenant_id
        ).first()
        
        if not shop_data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"No synced data found for shop {shop_id}"
            )
        
        # Get orders for this shop
        orders = db.query(SyncedOrder).filter(
            SyncedOrder.shop_data_id == shop_data.id
        ).all()
        
        # Get products for this shop
        products = db.query(SyncedProduct).filter(
            SyncedProduct.shop_data_id == shop_data.id
        ).all()
        
        return {
            "shop_data": {
                "shop_id": shop_data.shop_id,
                "shop_name": shop_data.shop_name,
                "current_payment": shop_data.current_payment,
                "upcoming_payment": shop_data.upcoming_payment,
                "overdue_payment": shop_data.overdue_payment,
                "sync_date": shop_data.sync_date.isoformat(),
                "sync_status": shop_data.sync_status.value
            },
            "orders": [
                {
                    "order_id": order.order_id,
                    "order_date": order.order_date.isoformat(),
                    "order_amount": order.order_amount,
                    "due_date": order.due_date.isoformat(),
                    "payment_status": order.payment_status.value,
                    "days_overdue": order.days_overdue
                }
                for order in orders
            ],
            "products": [
                {
                    "product_name": product.product_name,
                    "product_amount": product.product_amount,
                    "sku": product.sku,
                    "category": product.category
                }
                for product in products
            ]
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_synced_data: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop synced data: {str(e)}"
        )


@router.get("/shops/{shop_id}/payment-status")
async def get_shop_payment_status(
    tenant_id: str,
    shop_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> Dict[str, Any]:
    """
    Get payment status for a specific shop.
    
    This endpoint returns payment status information for a specific shop
    based on the 30-day payment policy.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        shop_id: Shop identifier
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing shop payment status
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view shop payment status for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view shop payment status for this tenant"
            )
        
        # Get shop synced data
        from ...domain.models.sync_data import SyncedShopData
        
        shop_data = db.query(SyncedShopData).filter(
            SyncedShopData.shop_id == shop_id,
            SyncedShopData.tenant_id == tenant_id
        ).first()
        
        if not shop_data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"No synced data found for shop {shop_id}"
            )
        
        return {
            "shop_id": shop_data.shop_id,
            "shop_name": shop_data.shop_name,
            "payment_status": {
                "current": shop_data.current_payment,
                "upcoming": shop_data.upcoming_payment,
                "overdue": shop_data.overdue_payment
            },
            "total_payment": shop_data.current_payment + shop_data.upcoming_payment + shop_data.overdue_payment,
            "last_sync_date": shop_data.sync_date.isoformat(),
            "sync_status": shop_data.sync_status.value
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_payment_status: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop payment status: {str(e)}"
        )
