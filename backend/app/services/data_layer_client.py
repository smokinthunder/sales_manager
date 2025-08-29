"""
Data Layer Client Service

This service handles all communication between the Backend (Server C) 
and the Data Layer (Server B). The backend never directly accesses the database.
"""

import httpx
import logging
from typing import List, Optional, Dict, Any
from datetime import date, datetime
from fastapi import HTTPException

logger = logging.getLogger(__name__)


class DataLayerClient:
    """
    Client for communicating with the Data Layer service.
    
    This implements the three-layer architecture where:
    - Server A: Database (MySQL)
    - Server B: Data Layer Service (this client communicates with this)
    - Server C: Backend API Gateway (this service)
    """
    
    def __init__(self, base_url: str):
        """
        Initialize the Data Layer client.
        
        Args:
            base_url: Base URL of the Data Layer service
        """
        self.base_url = base_url.rstrip('/')
        self.client = httpx.AsyncClient(timeout=30.0)
    
    async def close(self):
        """Close the HTTP client."""
        await self.client.aclose()
    
    async def _make_request(self, method: str, endpoint: str, **kwargs) -> Any:
        """
        Make a request to the Data Layer service.
        
        Args:
            method: HTTP method (GET, POST, etc.)
            endpoint: API endpoint
            **kwargs: Additional arguments for the request
            
        Returns:
            Response data from the Data Layer
            
        Raises:
            HTTPException: If the request fails
        """
        url = f"{self.base_url}{endpoint}"
        
        try:
            logger.debug(f"Making {method} request to Data Layer: {url}")
            response = await self.client.request(method, url, **kwargs)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            logger.error(f"Data Layer HTTP error: {e.response.status_code} - {e.response.text}")
            raise HTTPException(
                status_code=e.response.status_code,
                detail=f"Data Layer error: {e.response.text}"
            )
        except httpx.RequestError as e:
            logger.error(f"Data Layer request error: {e}")
            raise HTTPException(
                status_code=503,
                detail="Data Layer service unavailable"
            )
        except Exception as e:
            logger.error(f"Unexpected error communicating with Data Layer: {e}")
            raise HTTPException(
                status_code=500,
                detail="Internal server error"
            )
    
    async def get_users(self, tenant_id: str) -> List[Dict[str, Any]]:
        """
        Get users for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            List of users
        """
        return await self._make_request("GET", f"/api/users/{tenant_id}")
    
    async def get_user_by_phone(self, phone: str, tenant_id: str) -> Optional[Dict[str, Any]]:
        """
        Get user by phone number for a specific tenant.
        
        Args:
            phone: User's phone number
            tenant_id: Tenant identifier
            
        Returns:
            User data or None if not found
        """
        users = await self.get_users(tenant_id)
        for user in users:
            if user.get("phone") == phone:
                return user
        return None
    
    async def get_user_by_id(self, user_id: str, tenant_id: str) -> Optional[Dict[str, Any]]:
        """
        Get user by ID for a specific tenant.
        
        Args:
            user_id: User ID
            tenant_id: Tenant identifier
            
        Returns:
            User data or None if not found
        """
        users = await self.get_users(tenant_id)
        for user in users:
            if str(user.get("id")) == str(user_id):
                return user
        return None
    
    async def create_user(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new user.
        
        Args:
            user_data: User data to create (can be Pydantic model or dict)
            
        Returns:
            Created user data
        """
        # Convert Pydantic model to dict if needed
        if hasattr(user_data, 'model_dump'):
            user_dict = user_data.model_dump()
        elif hasattr(user_data, 'dict'):
            user_dict = user_data.dict()
        else:
            user_dict = dict(user_data)
            
        return await self._make_request("POST", f"/api/users/{user_dict['tenant_id']}", json=user_dict)

    async def update_user(self, user_id: str, user_data: Any, tenant_id: str, updated_by: Optional[int] = None) -> Dict[str, Any]:
        """
        Update user data in the Data Layer service.
        
        Args:
            user_id: User ID to update
            user_data: User data to update (can be Pydantic model or dict)
            tenant_id: Tenant identifier
            updated_by: ID of user making the update
            
        Returns:
            Updated user data
        """
        # Convert Pydantic model to dict if needed
        if hasattr(user_data, 'model_dump'):
            user_dict = user_data.model_dump(exclude_none=True)
        elif hasattr(user_data, 'dict'):
            user_dict = user_data.dict(exclude_none=True)
        else:
            user_dict = dict(user_data)
        
        # Add updated_by if provided
        if updated_by is not None:
            user_dict["updated_by"] = updated_by
            
        return await self._make_request("PUT", f"/api/users/{tenant_id}/{user_id}", json=user_dict)

    async def delete_user(self, user_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Delete user (soft delete) in the Data Layer service.
        
        Args:
            user_id: User ID to delete
            tenant_id: Tenant identifier
            
        Returns:
            Deletion result
        """
        return await self._make_request("DELETE", f"/api/users/{tenant_id}/{user_id}")
    
    async def get_shops(
        self, 
        tenant_id: str, 
        territory_id: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get shops for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            territory_id: Optional territory filter
            
        Returns:
            List of shops
        """
        params = {}
        if territory_id:
            params["territory_id"] = territory_id
        
        return await self._make_request("GET", f"/api/shops/{tenant_id}", params=params)
    
    async def get_territories(self, tenant_id: str) -> List[Dict[str, Any]]:
        """
        Get territories for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            List of territories
        """
        return await self._make_request("GET", f"/api/territories/{tenant_id}")

    async def create_territory(self, territory_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Create a new territory in the Data Layer service.
        
        Args:
            territory_data: Territory data to create
            tenant_id: Tenant identifier
            
        Returns:
            Created territory data
        """
        return await self._make_request("POST", f"/api/territories/{tenant_id}", json=territory_data)

    async def update_territory(self, territory_id: str, territory_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Update territory data in the Data Layer service.
        
        Args:
            territory_id: Territory ID to update
            territory_data: Territory data to update
            tenant_id: Tenant identifier
            
        Returns:
            Updated territory data
        """
        return await self._make_request("PUT", f"/api/territories/{tenant_id}/{territory_id}", json=territory_data)

    async def delete_territory(self, territory_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Delete territory in the Data Layer service.
        
        Args:
            territory_id: Territory ID to delete
            tenant_id: Tenant identifier
            
        Returns:
            Deletion result
        """
        return await self._make_request("DELETE", f"/api/territories/{tenant_id}/{territory_id}")
    
    async def get_visits(
        self, 
        tenant_id: str,
        shop_id: Optional[str] = None,
        executive_id: Optional[str] = None,
        date_from: Optional[date] = None
    ) -> List[Dict[str, Any]]:
        """
        Get visits for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Optional shop filter
            executive_id: Optional executive filter
            date_from: Optional date filter
            
        Returns:
            List of visits
        """
        params = {}
        if shop_id:
            params["shop_id"] = shop_id
        if executive_id:
            params["executive_id"] = executive_id
        if date_from:
            params["date_from"] = date_from.isoformat()
        
        return await self._make_request("GET", f"/api/visits/{tenant_id}", params=params)
    
    async def get_routes(
        self, 
        tenant_id: str,
        executive_id: Optional[str] = None,
        week_start: Optional[date] = None
    ) -> List[Dict[str, Any]]:
        """
        Get routes for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            executive_id: Optional executive filter
            week_start: Optional week start filter
            
        Returns:
            List of routes
        """
        params = {}
        if executive_id:
            params["executive_id"] = executive_id
        if week_start:
            params["week_start"] = week_start.isoformat()
        
        return await self._make_request("GET", f"/api/routes/{tenant_id}", params=params)
    
    async def get_shop_analytics(self, tenant_id: str) -> List[Dict[str, Any]]:
        """
        Get shop performance analytics for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            List of shop analytics
        """
        return await self._make_request("GET", f"/api/analytics/shop-performance/{tenant_id}")
    
    async def sync_client_data(self, tenant_id: str, sync_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Sync data from client's finance system.
        
        Args:
            tenant_id: Tenant identifier
            sync_data: Data to sync from client system
            
        Returns:
            Sync result
        """
        return await self._make_request("POST", f"/api/sync/client-data", params={"tenant_id": tenant_id}, json=sync_data)
    
    async def health_check(self) -> Dict[str, Any]:
        """
        Check the health of the Data Layer service.
        
        Returns:
            Health status
        """
        return await self._make_request("GET", "/health")


# Global instance
data_layer_client: Optional[DataLayerClient] = None


async def get_data_layer_client() -> DataLayerClient:
    """
    Get the global Data Layer client instance.
    
    Returns:
        DataLayerClient instance
    """
    global data_layer_client
    if data_layer_client is None:
        from app.core.config import settings
        data_layer_url = getattr(settings, 'data_layer_url', 'http://data-layer:8000')
        data_layer_client = DataLayerClient(data_layer_url)
    return data_layer_client


async def close_data_layer_client():
    """Close the global Data Layer client instance."""
    global data_layer_client
    if data_layer_client:
        await data_layer_client.close()
        data_layer_client = None
