"""
Shops API endpoints.

Provides shop management with synced data viewing, payment status,
and analytics integration. CRUD operations removed in favor of
data synchronization approach.
"""

from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query, Path
from app.api.deps import get_current_user
from app.core.errors import (
    ShopNotFoundError, 
    ShopAlreadyExistsError, 
    InvalidShopDataError,
    InsufficientPermissionsError
)
from app.services.shop_service import get_shop_service, ShopService
from app.services.analytics_service import AnalyticsService
from app.domain.models.shop import ShopCreate, ShopUpdate, ShopRead, ShopStatus, ShopCreateResponse
from app.domain.models.sync_data import SyncedShopDataRead
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/", response_model=ShopCreateResponse, status_code=201)
async def create_shop(
    shop_data: ShopCreate,
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Create a new shop for the specified tenant.
    
    **Business Logic:**
    - Shops are retail locations within territories
    - Each shop has a unique shop_id and code within the tenant
    - Shops can be assigned to territories for better organization
    - Only client_admin and superadmin can create shops
    
    **Required Fields:**
    - shop_id: Unique shop identifier (e.g., "SH001", "SH002")
    - name: Shop name (e.g., "Downtown Store", "Mall Outlet")
    
    **Note:** tenant_id is automatically set from the URL parameter for security
    
    **Optional Fields:**
    - status: Shop status (defaults to "active")
    - address: Shop address
    - phone: Contact phone number
    - contact_person: Contact person name
    - latitude: Geographic latitude
    - longitude: Geographic longitude
    - territory_id: Territory ID for assignment
    - pin_code: Pin code
    - email: Email address
    - aadhaar_number: Aadhaar number
    - pan_number: PAN number
    - location_name: Location name
    - gst_number: GST number
    
    **Security:**
    - Requires authentication
    - User must have client_admin or superadmin role
    - Shop is automatically assigned to user's tenant
    """
    try:
        created_shop = await shop_service.create_shop(shop_data, tenant_id, current_user)
        return created_shop
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except ShopAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=e.message
        )
    except InvalidShopDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/", response_model=List[ShopRead])
async def get_shops(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    territory_id: Optional[int] = Query(None, description="Filter by territory ID"),
    status: Optional[ShopStatus] = Query(None, description="Filter by shop status"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Get all shops for the specified tenant with optional filtering.
    
    **Filters Available:**
    - territory_id: Filter shops by territory
    - status: Filter by shop status (active, inactive, suspended, closed)
    
    **Security:**
    - Requires authentication
    - Users can only see shops from their assigned tenant
    - Superadmin can see shops from all tenants
    """
    try:
        shops = await shop_service.list_shops(tenant_id, current_user, territory_id, status)
        return shops
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{shop_id}", response_model=ShopRead)
async def get_shop(
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Get a specific shop by its business identifier.
    
    **Security:**
    - Requires authentication
    - Users can only see shops from their assigned tenant
    - Superadmin can see shops from all tenants
    """
    try:
        return await shop_service.get_shop_by_shop_id(shop_id, tenant_id, current_user)
    except ShopNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.put("/{shop_id}", response_model=ShopRead)
async def update_shop(
    shop_data: ShopUpdate,
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Update an existing shop.
    
    **Update Behavior:**
    - Only provided fields will be updated
    - Partial updates are supported
    - All updates are tracked with updated_by and updated_at
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can update shops
    - Users can only update shops from their assigned tenant
    """
    try:
        updated_shop = await shop_service.update_shop_by_shop_id(shop_id, shop_data, tenant_id, current_user)
        return updated_shop
    except ShopNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidShopDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/{shop_id}/synced-data", response_model=SyncedShopDataRead)
async def get_shop_synced_data(
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Get synced financial data for a specific shop.
    
    **Returns:**
    - Current payment amount
    - Upcoming payment amount  
    - Overdue payment amount
    - Sync status and last sync date
    - Raw client data (JSON)
    
    **Security:**
    - Requires authentication
    - Users can only see shops from their assigned tenant
    - Superadmin can see shops from all tenants
    """
    try:
        return await shop_service.get_shop_synced_data(shop_id, tenant_id, current_user)
    except ShopNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{shop_id}/payment-status")
async def get_shop_payment_status(
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Get payment status summary for a specific shop.
    
    **Returns:**
    - Payment status breakdown (current, upcoming, overdue)
    - 30-day policy compliance
    - Days overdue for overdue payments
    - Payment collection rate
    
    **Security:**
    - Requires authentication
    - Users can only see shops from their assigned tenant
    - Superadmin can see shops from all tenants
    """
    try:
        return await shop_service.get_shop_payment_status(shop_id, tenant_id, current_user)
    except ShopNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{shop_id}/orders")
async def get_shop_orders(
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    limit: int = Query(50, description="Maximum number of orders to return", ge=1, le=100),
    offset: int = Query(0, description="Number of orders to skip", ge=0),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Get orders for a specific shop from synced data.
    
    **Returns:**
    - List of orders with payment status
    - Order amounts and due dates
    - 30-day policy compliance status
    - Pagination support
    
    **Security:**
    - Requires authentication
    - Users can only see shops from their assigned tenant
    - Superadmin can see shops from all tenants
    """
    try:
        return await shop_service.get_shop_orders(shop_id, tenant_id, current_user, limit, offset)
    except ShopNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{shop_id}/analytics")
async def get_shop_analytics(
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    period_days: int = Query(30, description="Analytics period in days", ge=1, le=365),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Get analytics for a specific shop.
    
    **Returns:**
    - Performance metrics and trends
    - Order patterns and frequency
    - Payment behavior analysis
    - Product diversity metrics
    
    **Security:**
    - Requires authentication
    - Users can only see shops from their assigned tenant
    - Superadmin can see shops from all tenants
    """
    try:
        return await shop_service.get_shop_analytics(shop_id, tenant_id, current_user, period_days)
    except ShopNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
