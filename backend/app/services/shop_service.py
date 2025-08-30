# backend/app/services/shop_service.py
from typing import Any, Dict, List, Optional
from datetime import datetime
from fastapi import HTTPException, status
from pydantic import BaseModel, Field
from app.services.data_layer_client import get_data_layer_client

# ------------------ Custom Exceptions ------------------

class ShopError(Exception):
    """Base class for shop-related errors."""
    pass

class ShopNotFoundError(ShopError):
    """Raised when a shop is not found."""
    def __init__(self, shop_id: str):
        self.shop_id = shop_id
        super().__init__(f"Shop with ID {shop_id} not found")

class InsufficientShopPermissionsError(ShopError):
    """Raised when a user cannot perform an action on a shop due to role/tenant."""
    def __init__(self, detail: str = "Insufficient permissions"):
        super().__init__(detail)

# ------------------ Pydantic Models ------------------

class ShopCreate(BaseModel):
    name: str = Field(..., min_length=1)
    location: Optional[str] = None
    description: Optional[str] = None

class ShopUpdate(BaseModel):
    name: Optional[str] = None
    location: Optional[str] = None
    description: Optional[str] = None

class ShopRead(BaseModel):
    id: str
    tenant_id: str
    name: str
    location: Optional[str] = None
    description: Optional[str] = None
    created_at: str
    updated_at: str
    created_by: str
    updated_by: str

# ------------------ Shop Service ------------------

class ShopService:
    def __init__(self, data_layer_client=None):
        self.client = data_layer_client or get_data_layer_client()

    # ------------------ CRUD Methods ------------------

    async def list_shops(self, tenant_id: str, current_user: Dict[str, Any]) -> List[ShopRead]:
        self._check_tenant_access(tenant_id, current_user)
        resp = await self.client.get(f"/api/shops/{tenant_id}")
        resp.raise_for_status()
        return [ShopRead(**shop) for shop in resp.json()]

    async def get_shop(self, tenant_id: str, shop_id: str, current_user: Dict[str, Any]) -> ShopRead:
        self._check_tenant_access(tenant_id, current_user)
        resp = await self.client.get(f"/api/shops/{tenant_id}/{shop_id}")
        if resp.status_code == 404:
            raise ShopNotFoundError(shop_id)
        resp.raise_for_status()
        return ShopRead(**resp.json())

    async def create_shop(self, tenant_id: str, shop_data: ShopCreate, current_user: Dict[str, Any]) -> ShopRead:
        self._check_tenant_access(tenant_id, current_user, allowed_roles=["client_admin", "superadmin"])
        payload = shop_data.model_dump()
        payload.update({
            "created_at": datetime.utcnow().isoformat(),
            "updated_at": datetime.utcnow().isoformat(),
            "created_by": current_user.get("id"),
            "updated_by": current_user.get("id"),
        })
        resp = await self.client.post(f"/api/shops/{tenant_id}", json=payload)
        resp.raise_for_status()
        return ShopRead(**resp.json())

    async def update_shop(self, tenant_id: str, shop_id: str, shop_data: ShopUpdate, current_user: Dict[str, Any]) -> ShopRead:
        self._check_tenant_access(tenant_id, current_user, allowed_roles=["client_admin", "superadmin"])
        payload = shop_data.model_dump(exclude_unset=True)
        payload["updated_at"] = datetime.utcnow().isoformat()
        payload["updated_by"] = current_user.get("id")
        resp = await self.client.put(f"/api/shops/{tenant_id}/{shop_id}", json=payload)
        if resp.status_code == 404:
            raise ShopNotFoundError(shop_id)
        resp.raise_for_status()
        return ShopRead(**resp.json())

    async def delete_shop(self, tenant_id: str, shop_id: str, current_user: Dict[str, Any]) -> bool:
        self._check_tenant_access(tenant_id, current_user, allowed_roles=["client_admin", "superadmin"])
        resp = await self.client.delete(f"/api/shops/{tenant_id}/{shop_id}")
        if resp.status_code == 404:
            raise ShopNotFoundError(shop_id)
        resp.raise_for_status()
        return True

    # ------------------ Helper Methods ------------------

    def _check_tenant_access(
        self,
        tenant_id: str,
        current_user: Dict[str, Any],
        allowed_roles: Optional[List[str]] = None
    ):
        """Enforce tenant isolation and role-based permissions."""
        # Role check
        if allowed_roles and current_user.get("role") not in allowed_roles:
            raise InsufficientShopPermissionsError()
        # Tenant check
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientShopPermissionsError("You can only access shops within your tenant.")

# ------------------ Global Instance ------------------

shop_service = ShopService()

async def get_shop_service() -> ShopService:
    return shop_service