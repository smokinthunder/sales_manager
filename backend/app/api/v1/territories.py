"""
Territory Management API endpoints.

Provides CRUD operations for territories with proper authentication
and authorization checks.
"""

from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query
from app.api.deps import get_current_user
from app.core.errors import (
    TerritoryNotFoundError, 
    TerritoryAlreadyExistsError, 
    InvalidTerritoryDataError,
    InsufficientPermissionsError
)
from app.services.territory_service import get_territory_service, TerritoryService
from app.domain.models.territory import TerritoryCreate, TerritoryUpdate, TerritoryRead
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/", response_model=TerritoryRead, status_code=status.HTTP_201_CREATED)
async def create_territory(
    territory_data: TerritoryCreate,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    territory_service: TerritoryService = Depends(get_territory_service)
):
    """
    Create a new territory.
    
    Only client_admin and superadmin users can create territories.
    """
    try:
        created_territory = await territory_service.create_territory(territory_data, tenant_id, current_user)
        return created_territory
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except TerritoryAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=e.message
        )
    except InvalidTerritoryDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/", response_model=List[TerritoryRead])
async def get_territories(
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    territory_service: TerritoryService = Depends(get_territory_service)
):
    """
    Get territories for a specific tenant.
    
    All authenticated users can view territories.
    """
    try:
        territories = await territory_service.get_territories(tenant_id, current_user)
        return territories
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{territory_id}", response_model=TerritoryRead)
async def get_territory(
    territory_id: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    territory_service: TerritoryService = Depends(get_territory_service)
):
    """
    Get territory by ID.
    
    All authenticated users can view territories.
    """
    try:
        territory = await territory_service.get_territory(territory_id, tenant_id, current_user)
        return territory
    except TerritoryNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.put("/{territory_id}", response_model=TerritoryRead)
async def update_territory(
    territory_id: str,
    territory_data: TerritoryUpdate,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    territory_service: TerritoryService = Depends(get_territory_service)
):
    """
    Update territory data.
    
    Only client_admin and superadmin users can update territories.
    """
    try:
        updated_territory = await territory_service.update_territory(
            territory_id, territory_data, tenant_id, current_user
        )
        return updated_territory
    except TerritoryNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidTerritoryDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.delete("/{territory_id}", status_code=status.HTTP_200_OK)
async def delete_territory(
    territory_id: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    territory_service: TerritoryService = Depends(get_territory_service)
):
    """
    Delete territory.
    
    Only client_admin and superadmin users can delete territories.
    Territory cannot be deleted if it has associated shops or routes.
    """
    try:
        result = await territory_service.delete_territory(territory_id, tenant_id, current_user)
        return result
    except TerritoryNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidTerritoryDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )

