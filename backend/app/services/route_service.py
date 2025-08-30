# backend/app/services/route_service.py
from typing import Any, Dict, List, Optional
from app.services.data_layer_client import get_data_layer_client

class RouteService:
    def __init__(self, data_layer_client=None):
        # Reuse the data-layer client used elsewhere in the repo
        self.client = data_layer_client or get_data_layer_client()

    async def list_routes(self, tenant_id: str, params: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        params = params or {}
        resp = await self.client.get(f"/api/routes/{tenant_id}", params=params)
        resp.raise_for_status()
        return resp.json()

    async def get_route(self, tenant_id: str, route_id: str) -> Optional[Dict[str, Any]]:
        resp = await self.client.get(f"/api/routes/{tenant_id}/{route_id}")
        if resp.status_code == 404:
            return None
        resp.raise_for_status()
        return resp.json()
