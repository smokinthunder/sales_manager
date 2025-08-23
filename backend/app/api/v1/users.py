"""
Users API endpoints.

This demonstrates the three-layer architecture where the backend
communicates with the Data Layer service instead of directly with the database.
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List, Optional
from app.services import get_data_layer_client, DataLayerClient

router = APIRouter()


@router.get("/{tenant_id}", response_model=List[dict])
async def get_users(
    tenant_id: str,
    data_layer: DataLayerClient = Depends(get_data_layer_client)
):
    """
    Get users for a specific tenant.
    
    This endpoint demonstrates the three-layer architecture:
    - Backend (Server C) receives the request
    - Backend calls Data Layer (Server B) 
    - Data Layer queries Database (Server A)
    - Results flow back through the layers
    
    Args:
        tenant_id: Tenant identifier
        data_layer: Data Layer client dependency
        
    Returns:
        List of users for the tenant
    """
    try:
        users = await data_layer.get_users(tenant_id)
        return users
    except HTTPException:
        # Re-raise HTTP exceptions from the data layer
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to retrieve users: {str(e)}"
        )


@router.get("/{tenant_id}/shops", response_model=List[dict])
async def get_tenant_shops(
    tenant_id: str,
    territory_id: Optional[str] = Query(None, description="Filter by territory"),
    data_layer: DataLayerClient = Depends(get_data_layer_client)
):
    """
    Get shops for a specific tenant.
    
    Args:
        tenant_id: Tenant identifier
        territory_id: Optional territory filter
        data_layer: Data Layer client dependency
        
    Returns:
        List of shops for the tenant
    """
    try:
        shops = await data_layer.get_shops(tenant_id, territory_id)
        return shops
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to retrieve shops: {str(e)}"
        )


@router.get("/{tenant_id}/analytics", response_model=List[dict])
async def get_tenant_analytics(
    tenant_id: str,
    data_layer: DataLayerClient = Depends(get_data_layer_client)
):
    """
    Get analytics for a specific tenant.
    
    Args:
        tenant_id: Tenant identifier
        data_layer: Data Layer client dependency
        
    Returns:
        Analytics data for the tenant
    """
    try:
        analytics = await data_layer.get_shop_analytics(tenant_id)
        return analytics
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to retrieve analytics: {str(e)}"
        )
