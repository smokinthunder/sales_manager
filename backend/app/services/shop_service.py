"""
Shop service layer.

Provides business logic for shop management including CRUD operations,
tenant isolation, and role-based access control.
"""

from typing import Any, Dict, List, Optional
from datetime import datetime
from fastapi import HTTPException, status
from app.services.data_layer_client import get_data_layer_client
from app.services.notification_service import get_notification_service
from app.domain.models.shop import ShopCreate, ShopUpdate, ShopRead, ShopStatus
from app.domain.models.sync_data import SyncedShopDataRead
from app.core.errors import (
    ShopNotFoundError,
    ShopAlreadyExistsError,
    InvalidShopDataError,
    InsufficientPermissionsError
)

class ShopService:
    """
    Shop service for managing shop operations.
    
    Provides comprehensive shop management including CRUD operations,
    tenant isolation, role-based access control, and business logic validation.
    """
    
    def __init__(self, data_layer_client=None):
        """Initialize shop service with data layer client."""
        self.client = data_layer_client
        self.notification_service = None

    async def _get_notification_service(self):
        """Get Notification Service."""
        if not self.notification_service:
            self.notification_service = await get_notification_service()
        return self.notification_service

    # ------------------ CRUD Methods ------------------

    async def list_shops(
        self, 
        tenant_id: str, 
        current_user: Dict[str, Any],
        territory_id: Optional[str] = None,
        status: Optional[ShopStatus] = None
    ) -> List[ShopRead]:
        """
        List all shops for a tenant with optional filtering.
        
        Args:
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            territory_id: Optional territory filter
            status: Optional status filter
            
        Returns:
            List of shop records
            
        Raises:
            InsufficientPermissionsError: If user lacks access
        """
        self._check_tenant_access(tenant_id, current_user)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        # Build query parameters
        params = {}
        if territory_id:
            params["territory_id"] = territory_id
        if status:
            params["status"] = status.value
            
        shops = await client.get_shops(tenant_id, territory_id, status.value if status else None)
        return [ShopRead(**shop) for shop in shops]

    async def get_shop_by_shop_id(
        self, 
        shop_id: str, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> ShopRead:
        """
        Get a specific shop by its business identifier.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Shop record
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks access
        """
        self._check_tenant_access(tenant_id, current_user)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        try:
            shop = await client.get_shop(tenant_id, shop_id)
            return ShopRead(**shop)
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    async def create_shop(
        self, 
        shop_data: ShopCreate, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Create a new shop with approval workflow.
        
        Args:
            shop_data: Shop creation data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Created shop record or notification data for approval
            
        Raises:
            ShopAlreadyExistsError: If shop with same ID/code exists
            InsufficientPermissionsError: If user lacks create permissions
            InvalidShopDataError: If shop data is invalid
        """
        # Check if approval is needed
        user_role = current_user.get("role")
        
        # Area managers, client admins, and superadmins can create shops directly
        if user_role in ["area_manager", "client_admin", "superadmin"]:
            self._check_tenant_access(tenant_id, current_user, allowed_roles=["area_manager", "client_admin", "superadmin"])
            
            # Validate shop data
            self._validate_shop_data(shop_data)
            
            # Get data layer client
            client = self.client or await get_data_layer_client()
            
            # Prepare payload with audit fields (tenant_id comes from URL parameter)
            payload = shop_data.model_dump()
            payload.update({
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
                "created_by": current_user.get("id"),
                "updated_by": current_user.get("id"),
            })
            
            try:
                shop = await client.create_shop(payload, tenant_id)
                return {
                    "status": "completed",
                    "message": "Shop created successfully",
                    "notification_id": None,
                    "approval_required": False,
                    "shop": ShopRead(**shop).model_dump()
                }
            except HTTPException as e:
                if e.status_code == 409:
                    raise ShopAlreadyExistsError(shop_data.shop_id)
                raise
        
        # Sales executives need approval for shop creation
        if user_role == "sales_executive":
            # Validate shop data
            self._validate_shop_data(shop_data)
            
            # Create notification for approval
            notification_service = await self._get_notification_service()
            
            notification = await notification_service.create_customer_creation_notification(
                shop_data.model_dump(), current_user, tenant_id
            )
            
            if notification:
                return {
                    "status": "pending_approval",
                    "message": "Shop creation request submitted for approval",
                    "notification_id": notification.get("id"),
                    "approval_required": True,
                    "shop": None
                }
            else:
                # This shouldn't happen for sales executives
                raise InsufficientPermissionsError(
                    message="Unable to create approval notification for shop creation"
                )
        
        # Default case - insufficient permissions
        raise InsufficientPermissionsError(
            message="Insufficient permissions to create shops"
        )

    async def update_shop_by_shop_id(
        self, 
        shop_id: str, 
        shop_data: ShopUpdate, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> ShopRead:
        """
        Update an existing shop by its business identifier.
        
        Args:
            shop_id: Business shop identifier
            shop_data: Shop update data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Updated shop record
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks update permissions
            InvalidShopDataError: If shop data is invalid
        """
        self._check_tenant_access(tenant_id, current_user, allowed_roles=["client_admin", "superadmin"])
        
        # Validate shop data if provided
        if shop_data.model_dump(exclude_unset=True):
            self._validate_shop_update_data(shop_data)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        # Prepare payload with audit fields
        payload = shop_data.model_dump(exclude_unset=True)
        payload["updated_at"] = datetime.utcnow().isoformat()
        payload["updated_by"] = current_user.get("id")
        
        try:
            shop = await client.update_shop(shop_id, payload, tenant_id)
            return ShopRead(**shop)
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    async def delete_shop_by_shop_id(
        self, 
        shop_id: str, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> bool:
        """
        Delete a shop by its business identifier.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            True if deleted successfully
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks delete permissions
        """
        self._check_tenant_access(tenant_id, current_user, allowed_roles=["client_admin", "superadmin"])
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        try:
            await client.delete_shop(shop_id, tenant_id)
            return True
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    # ------------------ Synced Data Methods ------------------

    async def get_shop_synced_data(
        self,
        shop_id: str,
        tenant_id: str,
        current_user: Dict[str, Any]
    ) -> SyncedShopDataRead:
        """
        Get synced financial data for a specific shop.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            SyncedShopDataRead: Synced shop data
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks access permissions
        """
        self._check_tenant_access(tenant_id, current_user)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        try:
            return await client.get_shop_synced_data(shop_id, tenant_id)
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    async def get_shop_payment_status(
        self,
        shop_id: str,
        tenant_id: str,
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Get payment status summary for a specific shop.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Dict containing payment status summary
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks access permissions
        """
        self._check_tenant_access(tenant_id, current_user)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        try:
            return await client.get_shop_payment_status(shop_id, tenant_id)
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    async def get_shop_orders(
        self,
        shop_id: str,
        tenant_id: str,
        current_user: Dict[str, Any],
        limit: int = 50,
        offset: int = 0
    ) -> Dict[str, Any]:
        """
        Get orders for a specific shop from synced data.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            limit: Maximum number of orders to return
            offset: Number of orders to skip
            
        Returns:
            Dict containing orders and pagination info
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks access permissions
        """
        self._check_tenant_access(tenant_id, current_user)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        try:
            return await client.get_shop_orders(shop_id, tenant_id, limit, offset)
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    async def get_shop_analytics(
        self,
        shop_id: str,
        tenant_id: str,
        current_user: Dict[str, Any],
        period_days: int = 30
    ) -> Dict[str, Any]:
        """
        Get analytics for a specific shop.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            period_days: Analytics period in days
            
        Returns:
            Dict containing shop analytics
            
        Raises:
            ShopNotFoundError: If shop not found
            InsufficientPermissionsError: If user lacks access permissions
        """
        self._check_tenant_access(tenant_id, current_user)
        
        # Get data layer client
        client = self.client or await get_data_layer_client()
        
        try:
            return await client.get_shop_analytics(shop_id, tenant_id, period_days)
        except HTTPException as e:
            if e.status_code == 404:
                raise ShopNotFoundError(shop_id)
            raise

    # ------------------ Helper Methods ------------------

    def _check_tenant_access(
        self,
        tenant_id: str,
        current_user: Dict[str, Any],
        allowed_roles: Optional[List[str]] = None
    ) -> None:
        """
        Enforce tenant isolation and role-based permissions.
        
        Args:
            tenant_id: Target tenant identifier
            current_user: Current authenticated user
            allowed_roles: Optional list of allowed roles
            
        Raises:
            InsufficientPermissionsError: If access is denied
        """
        # Role check
        if allowed_roles and current_user.get("role") not in allowed_roles:
            raise InsufficientPermissionsError(
                f"Access denied. Required roles: {', '.join(allowed_roles)}"
            )
        
        # Tenant check
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                "Access denied. You can only access shops within your tenant."
            )

    def _validate_shop_data(self, shop_data: ShopCreate) -> None:
        """
        Validate shop creation data.
        
        Args:
            shop_data: Shop creation data
            
        Raises:
            InvalidShopDataError: If data is invalid
        """
        if not shop_data.shop_id or len(shop_data.shop_id.strip()) == 0:
            raise InvalidShopDataError("Shop ID is required")
        
        if not shop_data.name or len(shop_data.name.strip()) == 0:
            raise InvalidShopDataError("Shop name is required")

    def _validate_shop_update_data(self, shop_data: ShopUpdate) -> None:
        """
        Validate shop update data.
        
        Args:
            shop_data: Shop update data
            
        Raises:
            InvalidShopDataError: If data is invalid
        """
        if shop_data.name is not None and len(shop_data.name.strip()) == 0:
            raise InvalidShopDataError("Shop name cannot be empty")


# ------------------ Global Instance ------------------

shop_service = ShopService()

async def get_shop_service() -> ShopService:
    """Get shop service instance."""
    return shop_service