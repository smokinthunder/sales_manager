"""
Shops API endpoints.

Provides CRUD operations for shops with proper authentication,
authorization, and tenant isolation.
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
from app.domain.models.shop import ShopCreate, ShopUpdate, ShopRead, ShopStatus
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/", response_model=ShopRead, status_code=201)
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


@router.delete("/{shop_id}", status_code=204)
async def delete_shop(
    shop_id: str = Path(..., description="Business-friendly shop identifier (e.g., SH001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    shop_service: ShopService = Depends(get_shop_service)
):
    """
    Delete a shop (hard delete - completely removes from database).
    
    **Delete Behavior:**
    - Shop is completely removed from the database
    - All associated visits, orders, payments, and outstandings are also deleted
    - This action cannot be undone
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can delete shops
    - Users can only delete shops from their assigned tenant
    """
    try:
        await shop_service.delete_shop_by_shop_id(shop_id, tenant_id, current_user)
        return None
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
