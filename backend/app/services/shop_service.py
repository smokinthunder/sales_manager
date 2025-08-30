# backend/app/services/shop_service.py
from typing import Any, Dict, List, Optional
from app.services.data_layer_client import get_data_layer_client

class ShopService:
    def __init__(self, data_layer_client=None):
        # get_data_layer_client should return an httpx.AsyncClient-like client
        self.client = data_layer_client or get_data_layer_client()

    async def list_shops(self, tenant_id: str, params: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        params = params or {}
        # Data Layer endpoint: GET /api/shops/{tenant_id}
        resp = await self.client.get(f"/api/shops/{tenant_id}", params=params)
        resp.raise_for_status()
        return resp.json()

    async def get_shop(self, tenant_id: str, shop_id: str) -> Optional[Dict[str, Any]]:
        # Data Layer may expose /api/shops/{tenant_id}/{shop_id}
        resp = await self.client.get(f"/api/shops/{tenant_id}/{shop_id}")
        if resp.status_code == 404:
            return None
        resp.raise_for_status()
        return resp.json()

# app/services/shop_service.py

class ShopService:
    def __init__(self):
        pass

    def get_all_shops(self):
        # TODO: implement fetching shops
        return []

    def get_shop_by_id(self, shop_id: str):
        # TODO: implement fetching a shop by id
        return None
