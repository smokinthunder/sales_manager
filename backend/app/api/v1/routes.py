"""
Routes API endpoints.

Provides CRUD operations for sales routes with proper authentication,
authorization, and tenant isolation.
"""

from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query, Path
from app.api.deps import get_current_user
from app.core.errors import (
    RouteNotFoundError, 
    RouteAlreadyExistsError, 
    InvalidRouteDataError,
    InsufficientPermissionsError
)
from app.services.route_service import get_route_service, RouteService
from app.domain.models.route import RouteCreate, RouteUpdate, RouteRead, RouteAssignmentRead, RouteAssignmentCreate, RouteWithAssignments
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/", response_model=RouteRead, status_code=201)
async def create_route(
    route_data: RouteCreate,
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Create a new route for the specified tenant.
    
    **Business Logic:**
    - Routes are collections of shops with planned visits
    - Each route belongs to a specific territory and week
    - Route ID is auto-generated if not provided (format: RT-001, RT-002, etc.)
    - Only client_admin and superadmin can create routes
    
    **Required Fields:**
    - name: Route name (e.g., "Morning Route", "Weekend Route")
    - territory_id: Territory code (e.g., "KL007", "KL001")
    - week_start_date: Week start date (YYYY-MM-DD format)
    
    **Optional Fields:**
    - route_id: Custom route identifier (auto-generated if not provided)
    - status: Route status (defaults to "planned")
    
    **Security:**
    - Requires authentication
    - User must have client_admin or superadmin role
    - Route is automatically assigned to user's tenant
    """
    try:
        created_route = await route_service.create_route(route_data, tenant_id, current_user)
        return created_route
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except RouteAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=e.message
        )
    except InvalidRouteDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/", response_model=List[RouteRead])
async def get_routes(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    executive_id: Optional[int] = Query(None, description="Filter by sales executive ID"),
    week_start: Optional[str] = Query(None, description="Filter by week start date (YYYY-MM-DD)"),
    route_status: Optional[str] = Query(None, description="Filter by route status"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Get all routes for the specified tenant with optional filtering.
    
    **Filters Available:**
    - executive_id: Filter routes by assigned sales executive
    - week_start: Filter routes by week start date (YYYY-MM-DD)
    - route_status: Filter by status (planned, in_progress, completed)
    
    **Security:**
    - Requires authentication
    - Users can only see routes from their assigned tenant
    - Superadmin can see routes from all tenants
    """
    try:
        # Build filter parameters
        params = {}
        if executive_id:
            params["executive_id"] = executive_id
        if week_start:
            params["week_start"] = week_start
        if route_status:
            params["status"] = route_status
        
        routes = await route_service.get_routes(tenant_id, current_user, **params)
        return routes
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidRouteDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/{route_id}", response_model=RouteRead)
async def get_route(
    route_id: str = Path(..., description="Business-friendly route identifier (e.g., RT-001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Get a specific route by its business identifier.
    
    **Security:**
    - Requires authentication
    - Users can only see routes from their assigned tenant
    - Superadmin can see routes from all tenants
    """
    try:
        return await route_service.get_route_by_route_id(route_id, tenant_id, current_user)
    except RouteNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.put("/{route_id}", response_model=RouteRead)
async def update_route(
    route_data: RouteUpdate,
    route_id: str = Path(..., description="Business-friendly route identifier (e.g., RT-001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Update an existing route.
    
    **Update Behavior:**
    - Only provided fields will be updated
    - Partial updates are supported
    - All updates are tracked with updated_by and updated_at
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can update routes
    - Users can only update routes from their assigned tenant
    """
    try:
        updated_route = await route_service.update_route_by_route_id(route_id, route_data, tenant_id, current_user)
        return updated_route
    except RouteNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidRouteDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.delete("/{route_id}", status_code=204)
async def delete_route(
    route_id: str = Path(..., description="Business-friendly route identifier (e.g., RT-001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Delete a route (hard delete - completely removes from database).
    
    **Delete Behavior:**
    - Route is completely removed from the database
    - All associated route assignments (shops) are also deleted
    - This action cannot be undone
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can delete routes
    - Users can only delete routes from their assigned tenant
    """
    try:
        await route_service.delete_route_by_route_id(route_id, tenant_id, current_user)
        return None
    except RouteNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidRouteDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.post("/{route_id}/assignments", response_model=RouteAssignmentRead, status_code=201)
async def add_shop_to_route(
    assignment_data: RouteAssignmentCreate,
    route_id: str = Path(..., description="Business-friendly route identifier (e.g., RT-001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Add a shop to a route (create route assignment).
    
    **Business Logic:**
    - Links a shop to a route with visit details
    - Includes planned date, time, and sequence order
    - Assigns a sales executive to the visit
    
    **Required Fields:**
    - shop_id: Shop identifier
    - sales_executive_id: Sales executive identifier
    - planned_date: Planned visit date (YYYY-MM-DD)
    
    **Optional Fields:**
    - planned_time: Planned visit time (HH:MM:SS)
    - sequence_order: Visit sequence within the route
    - status: Assignment status (defaults to "planned")
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can manage route assignments
    - Users can only manage assignments within their assigned tenant
    """
    try:
        return await route_service.add_shop_to_route_by_route_id(route_id, assignment_data, tenant_id, current_user)
    except RouteNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.delete("/{route_id}/assignments/{assignment_id}", status_code=204)
async def remove_shop_from_route(
    route_id: str = Path(..., description="Business-friendly route identifier (e.g., RT-001)"),
    assignment_id: int = Path(..., description="Route assignment database ID"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Remove a shop from a route (delete route assignment).
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can manage route assignments
    - Users can only manage assignments within their assigned tenant
    """
    try:
        await route_service.remove_shop_from_route_by_route_id(route_id, assignment_id, tenant_id, current_user)
        return None
    except RouteNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{route_id}/assignments", response_model=RouteWithAssignments)
async def get_route_with_assignments(
    route_id: str = Path(..., description="Business-friendly route identifier (e.g., RT-001)"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    route_service: RouteService = Depends(get_route_service)
):
    """
    Get a route with all its shop assignments.
    
    **Response Includes:**
    - Complete route information
    - List of all assigned shops with visit details
    - Assignment status and timing information
    
    **Security:**
    - Requires authentication
    - Users can only see routes from their assigned tenant
    - Superadmin can see routes from all tenants
    """
    try:
        return await route_service.get_route_with_assignments_by_route_id(route_id, tenant_id, current_user)
    except RouteNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
