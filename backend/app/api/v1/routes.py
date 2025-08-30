# backend/app/api/v1/routes.py
from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List, Optional, Dict, Any
from app.services.route_service import RouteService

router = APIRouter()

# Dependency to inject RouteService
def get_route_service():
    return RouteService()

# -------------------- ROUTES --------------------

@router.get("/", response_model=List[Dict[str, Any]])
async def list_routes(
    tenant_id: str,
    page: int = Query(1, ge=1),
    size: int = Query(10, le=100),
    route_service: RouteService = Depends(get_route_service),
):
    """List routes with pagination"""
    params = {"page": page, "size": size}
    return await route_service.list_routes(tenant_id, params)


@router.get("/{route_id}", response_model=Dict[str, Any])
async def get_route(
    tenant_id: str,
    route_id: str,
    route_service: RouteService = Depends(get_route_service),
):
    """Get details of a specific route"""
    route = await route_service.get_route(tenant_id, route_id)
    if not route:
        raise HTTPException(status_code=404, detail="Route not found")
    return route
