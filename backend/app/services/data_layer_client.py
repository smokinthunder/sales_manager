"""
Data Layer Client Service

This service handles all communication between the Backend (Server C) 
and the Data Layer (Server B). The backend never directly accesses the database.
"""

import httpx
import logging
import json
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
    
    def _serialize_json(self, data: Dict[str, Any]) -> str:
        """
        Custom JSON serializer that handles date/datetime objects.
        
        Args:
            data: Data to serialize
            
        Returns:
            JSON string
        """
        def json_serializer(obj):
            """JSON serializer for objects not serializable by default json code"""
            if isinstance(obj, (date, datetime)):
                return obj.isoformat()
            raise TypeError(f"Object {obj} of type {type(obj)} is not JSON serializable")
        
        return json.dumps(data, default=json_serializer)
    
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
        
        # Handle custom JSON serialization for date/datetime objects
        if 'json' in kwargs:
            json_data = kwargs.pop('json')
            kwargs['content'] = self._serialize_json(json_data)
            kwargs['headers'] = kwargs.get('headers', {})
            kwargs['headers']['Content-Type'] = 'application/json'
        
        try:
            logger.debug(f"Making {method} request to Data Layer: {url}")
            logger.debug(f"Request data: {kwargs}")
            response = await self.client.request(method, url, **kwargs)
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            error_details = e.response.text
            try:
                # Try to parse JSON error response for more details
                error_json = e.response.json()
                error_details = error_json
            except:
                pass
                
            logger.error(f"Data Layer HTTP error: {e.response.status_code} - {error_details}")
            logger.error(f"Request URL: {url}")
            logger.error(f"Request method: {method}")
            logger.error(f"Request kwargs: {kwargs}")
            
            raise HTTPException(
                status_code=e.response.status_code,
                detail=f"Data Layer error: {error_details}"
            )
        except httpx.RequestError as e:
            logger.error(f"Data Layer request error: {e}")
            logger.error(f"Request URL: {url}")
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
    
    async def create_user(self, user_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Create a new user.
        
        Args:
            user_data: User data to create (can be Pydantic model or dict)
            tenant_id: Tenant identifier for security isolation
            
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
        
        # SECURITY: Always use the provided tenant_id, ignore any tenant_id in user_data
        user_dict['tenant_id'] = tenant_id
            
        return await self._make_request("POST", f"/api/users/{tenant_id}", json=user_dict)

    async def update_user(self, user_id: str, user_data: Any, tenant_id: str, updated_by: Optional[str] = None) -> Dict[str, Any]:
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
        Delete user (hard delete) in the Data Layer service.
        
        Args:
            user_id: User identifier
            tenant_id: Tenant identifier
            
        Returns:
            Deletion confirmation
        """
        return await self._make_request("DELETE", f"/api/users/{tenant_id}/{user_id}")
    
    async def get_shops(
        self, 
        tenant_id: str, 
        territory_id: Optional[str] = None,
        status: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get shops for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            territory_id: Optional territory filter
            status: Optional status filter
            
        Returns:
            List of shops
        """
        params = {}
        if territory_id:
            params["territory_id"] = territory_id
        if status:
            params["status"] = status
        
        return await self._make_request("GET", f"/api/shops/{tenant_id}", params=params)
    
    async def get_shop(self, tenant_id: str, shop_id: str) -> Dict[str, Any]:
        """
        Get a specific shop by ID.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            
        Returns:
            Shop data
        """
        return await self._make_request("GET", f"/api/shops/{tenant_id}/{shop_id}")
    
    async def create_shop(self, shop_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Create a new shop.
        
        Args:
            shop_data: Shop data to create
            tenant_id: Tenant identifier
            
        Returns:
            Created shop data
        """
        return await self._make_request("POST", f"/api/shops/{tenant_id}", json=shop_data)
    
    async def update_shop(self, shop_id: str, shop_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Update an existing shop.
        
        Args:
            shop_id: Shop identifier
            shop_data: Shop data to update
            tenant_id: Tenant identifier
            
        Returns:
            Updated shop data
        """
        return await self._make_request("PUT", f"/api/shops/{tenant_id}/{shop_id}", json=shop_data)
    
    async def delete_shop(self, shop_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Delete a shop.
        
        Args:
            shop_id: Shop identifier
            tenant_id: Tenant identifier
            
        Returns:
            Deletion confirmation
        """
        return await self._make_request("DELETE", f"/api/shops/{tenant_id}/{shop_id}")
    
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
    
    async def get_route(self, route_id: str, tenant_id: str) -> Optional[Dict[str, Any]]:
        """
        Get a specific route by ID for a specific tenant.
        
        Args:
            route_id: Route identifier
            tenant_id: Tenant identifier
            
        Returns:
            Route data or None if not found
        """
        routes = await self.get_routes(tenant_id)
        for route in routes:
            if route.get("route_id") == route_id:
                return route
        return None
    
    async def create_route(self, route_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Create a new route for a specific tenant.
        
        Args:
            route_data: Route data to create
            tenant_id: Tenant identifier
            
        Returns:
            Created route data
        """
        return await self._make_request("POST", f"/api/routes/{tenant_id}", json=route_data)
    
    async def update_route(self, route_id: str, route_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Update an existing route for a specific tenant.
        
        Args:
            route_id: Route identifier
            route_data: Route data to update
            tenant_id: Tenant identifier
            
        Returns:
            Updated route data
        """
        return await self._make_request("PUT", f"/api/routes/{tenant_id}/{route_id}", json=route_data)
    
    async def delete_route(self, route_id: int, tenant_id: str) -> Dict[str, Any]:
        """
        Delete a route for a specific tenant (hard delete).
        
        Args:
            route_id: Route database ID
            tenant_id: Tenant identifier
            
        Returns:
            Deletion confirmation
        """
        return await self._make_request("DELETE", f"/api/routes/{tenant_id}/{route_id}")
    
    async def create_route_assignment(self, assignment_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Create a new route assignment (add shop to route).
        
        Args:
            assignment_data: Assignment data to create
            tenant_id: Tenant identifier
            
        Returns:
            Created assignment data
        """
        return await self._make_request("POST", f"/api/routes/{tenant_id}/assignments", json=assignment_data)
    
    async def delete_route_assignment(self, assignment_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Delete a route assignment (remove shop from route).
        
        Args:
            assignment_id: Assignment identifier
            tenant_id: Tenant identifier
            
        Returns:
            Deletion result
        """
        return await self._make_request("DELETE", f"/api/routes/{tenant_id}/assignments/{assignment_id}")
    
    async def get_route_with_assignments(self, route_id: str, tenant_id: str) -> Optional[Dict[str, Any]]:
        """
        Get a route with all its shop assignments.
        
        Args:
            route_id: Route identifier
            tenant_id: Tenant identifier
            
        Returns:
            Route data with assignments or None if not found
        """
        try:
            return await self._make_request("GET", f"/api/routes/{tenant_id}/{route_id}/assignments")
        except Exception:
            return None
    
    async def get_all_route_assignments(self, tenant_id: str, filters: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        """
        Get all route assignments for a tenant with optional filtering.
        
        Args:
            tenant_id: Tenant identifier
            filters: Optional filter parameters
            
        Returns:
            List of route assignments
        """
        params = {}
        if filters:
            # Pass all filters as query parameters
            for key, value in filters.items():
                if value is not None:
                    params[key] = value
        
        return await self._make_request("GET", f"/api/route-assignments/{tenant_id}", params=params)
    
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

    async def get_route_by_route_id(self, route_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Get a specific route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            tenant_id: Tenant identifier
            
        Returns:
            Route data dictionary
        """
        return await self._make_request("GET", f"/api/routes/{tenant_id}/{route_id}")
    
    async def update_route_by_route_id(self, route_id: str, route_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Update an existing route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            route_data: Route update data
            tenant_id: Tenant identifier
            
        Returns:
            Updated route data dictionary
        """
        return await self._make_request("PUT", f"/api/routes/{tenant_id}/{route_id}", json=route_data)
    
    async def delete_route_by_route_id(self, route_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Delete a route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            tenant_id: Tenant identifier
            
        Returns:
            Deletion confirmation
        """
        return await self._make_request("DELETE", f"/api/routes/{tenant_id}/{route_id}")

    # ------------------ Synced Data Methods ------------------

    async def get_shop_synced_data(self, shop_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Get synced financial data for a specific shop.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            
        Returns:
            Synced shop data dictionary
        """
        return await self._make_request("GET", f"/api/shops/{tenant_id}/{shop_id}/synced-data")

    async def get_shop_payment_status(self, shop_id: str, tenant_id: str) -> Dict[str, Any]:
        """
        Get payment status summary for a specific shop.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            
        Returns:
            Payment status summary dictionary
        """
        return await self._make_request("GET", f"/api/shops/{tenant_id}/{shop_id}/payment-status")

    async def get_shop_orders(self, shop_id: str, tenant_id: str, limit: int = 50, offset: int = 0) -> Dict[str, Any]:
        """
        Get orders for a specific shop from synced data.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            limit: Maximum number of orders to return
            offset: Number of orders to skip
            
        Returns:
            Orders data with pagination info
        """
        params = {"limit": limit, "offset": offset}
        return await self._make_request("GET", f"/api/shops/{tenant_id}/{shop_id}/orders", params=params)

    async def get_shop_analytics(self, shop_id: str, tenant_id: str, period_days: int = 30) -> Dict[str, Any]:
        """
        Get analytics for a specific shop.
        
        Args:
            shop_id: Business shop identifier
            tenant_id: Tenant identifier
            period_days: Analytics period in days
            
        Returns:
            Shop analytics dictionary
        """
        params = {"period_days": period_days}
        return await self._make_request("GET", f"/api/shops/{tenant_id}/{shop_id}/analytics", params=params)

    # ------------------ Analytics Methods ------------------

    async def get_executive_performance(self, user_id: str, tenant_id: str, period_start: Optional[str] = None, period_end: Optional[str] = None) -> Dict[str, Any]:
        """
        Get executive performance analytics.
        
        Args:
            user_id: User ID
            tenant_id: Tenant identifier
            period_start: Start date for analytics period
            period_end: End date for analytics period
            
        Returns:
            Executive performance data
        """
        params = {}
        if period_start:
            params["period_start"] = period_start
        if period_end:
            params["period_end"] = period_end
        return await self._make_request("GET", f"/api/analytics/executive/{user_id}/performance", params=params)

    async def get_payment_analytics(self, tenant_id: str, period_start: Optional[str] = None, period_end: Optional[str] = None) -> Dict[str, Any]:
        """
        Get payment analytics for a tenant.
        
        Args:
            tenant_id: Tenant identifier
            period_start: Start date for analytics period
            period_end: End date for analytics period
            
        Returns:
            Payment analytics data
        """
        params = {}
        if period_start:
            params["period_start"] = period_start
        if period_end:
            params["period_end"] = period_end
        return await self._make_request("GET", f"/api/analytics/payments/analytics", params=params)

    async def get_overdue_analysis(self, tenant_id: str) -> Dict[str, Any]:
        """
        Get overdue payments analysis.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            Overdue analysis data
        """
        return await self._make_request("GET", f"/api/analytics/payments/overdue", params={"tenant_id": tenant_id})

    async def get_best_selling_products(self, tenant_id: str, limit: int = 10) -> Dict[str, Any]:
        """
        Get best selling products analysis.
        
        Args:
            tenant_id: Tenant identifier
            limit: Maximum number of products to return
            
        Returns:
            Best selling products data
        """
        params = {"tenant_id": tenant_id, "limit": limit}
        return await self._make_request("GET", f"/api/analytics/products/best-selling", params=params)

    # ------------------ Outstanding/Due Data Methods ------------------

    async def create_outstanding(self, outstanding_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new outstanding payment record.
        
        Args:
            outstanding_data: Outstanding payment data to create
            
        Returns:
            Created outstanding record
        """
        tenant_id = outstanding_data.get("tenant_id")
        # Remove tenant_id from the body data since it's passed as URL parameter
        body_data = {k: v for k, v in outstanding_data.items() if k != "tenant_id"}
        

            
        return await self._make_request("POST", f"/api/due-data/{tenant_id}", json=body_data)

    async def get_outstanding(self, tenant_id: str, filters: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        """
        Get outstanding payment records with optional filtering.
        
        Args:
            tenant_id: Tenant identifier
            filters: Optional filters for the query
            
        Returns:
            List of outstanding payment records
        """
        params = filters or {}
        return await self._make_request("GET", f"/api/due-data/{tenant_id}", params=params)

    async def get_outstanding_by_id(self, outstanding_id: int, tenant_id: str) -> Optional[Dict[str, Any]]:
        """
        Get a specific outstanding payment record by ID.
        
        Args:
            outstanding_id: Outstanding record ID
            tenant_id: Tenant identifier
            
        Returns:
            Outstanding record or None if not found
        """
        try:
            return await self._make_request("GET", f"/api/due-data/{tenant_id}/{outstanding_id}")
        except HTTPException as e:
            if e.status_code == 404:
                return None
            raise

    async def update_outstanding(self, outstanding_id: int, update_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Update an outstanding payment record.
        
        Args:
            outstanding_id: Outstanding record ID
            update_data: Data to update
            tenant_id: Tenant identifier
            
        Returns:
            Updated outstanding record
        """
        return await self._make_request("PUT", f"/api/due-data/{tenant_id}/{outstanding_id}", json=update_data)

    async def delete_outstanding(self, outstanding_id: int, tenant_id: str) -> Dict[str, Any]:
        """
        Delete an outstanding payment record.
        
        Args:
            outstanding_id: Outstanding record ID
            tenant_id: Tenant identifier
            
        Returns:
            Deletion result
        """
        return await self._make_request("DELETE", f"/api/due-data/{tenant_id}/{outstanding_id}")

    async def get_outstanding_summary(self, tenant_id: str) -> Dict[str, Any]:
        """
        Get outstanding payment summary statistics.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            Summary statistics
        """
        return await self._make_request("GET", f"/api/due-data/{tenant_id}/summary")
    
    async def get_outstanding(self, tenant_id: str, filters: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """
        Get outstanding payments with optional filtering.
        
        Args:
            tenant_id: Tenant identifier
            filters: Optional filters for the query
            
        Returns:
            List of outstanding payment records
        """
        params = {"tenant_id": tenant_id}
        if filters:
            params.update(filters)
        return await self._make_request("GET", f"/api/due-data/{tenant_id}", params=params)
    
    async def get_products_by_executive(self, tenant_id: str, sales_executive_id: int, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get products sold by a specific sales executive.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of products sold by the executive
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", f"/api/analytics/executive/{sales_executive_id}/best-selling-products", params=params)
    
    async def get_all_products(self, tenant_id: str) -> List[Dict[str, Any]]:
        """
        Get all products across all executives.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            List of all products sold
        """
        # For now, we'll get products from a specific executive to get the structure
        # In a real implementation, you might want a dedicated endpoint for this
        return await self._make_request("GET", f"/api/products/all", params={"tenant_id": tenant_id})
    
    async def get_executive_sales_report(self, tenant_id: str, sales_executive_id: int, start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """
        Get sales report for a sales executive.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID
            start_date: Start date for the report (YYYY-MM-DD format)
            end_date: End date for the report (YYYY-MM-DD format)
            
        Returns:
            List of sales data
        """
        params = {
            "tenant_id": tenant_id,
            "start_date": start_date,
            "end_date": end_date
        }
        return await self._make_request("GET", f"/api/analytics/executive/{sales_executive_id}/sales-report", params=params)
    
    async def get_tenant_top_customers(self, tenant_id: str, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get top customers for entire tenant (aggregated view).
        
        Args:
            tenant_id: Tenant identifier
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of top customers with shop names and points
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", "/api/analytics/tenant/top-customers", params=params)
    
    async def get_territory_top_customers(self, tenant_id: str, territory_id: str, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get top customers for a specific territory (aggregated view).
        
        Args:
            tenant_id: Tenant identifier
            territory_id: Territory identifier
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of top customers with shop names and points
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", f"/api/analytics/territory/{territory_id}/top-customers", params=params)
    
    async def get_area_manager_top_customers(self, tenant_id: str, area_manager_id: int, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get top customers for all territories managed by an area manager.
        
        Args:
            tenant_id: Tenant identifier
            area_manager_id: Area manager ID
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of top customers with shop names and points
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", f"/api/analytics/area-manager/{area_manager_id}/top-customers", params=params)
    
    async def get_tenant_best_selling_products(self, tenant_id: str, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get best selling products for entire tenant (aggregated view).
        
        Args:
            tenant_id: Tenant identifier
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of best selling products with units sold and percentages
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", "/api/analytics/tenant/best-selling-products", params=params)
    
    async def get_territory_best_selling_products(self, tenant_id: str, territory_id: str, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get best selling products for a specific territory (aggregated view).
        
        Args:
            tenant_id: Tenant identifier
            territory_id: Territory identifier
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of best selling products with units sold and percentages
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", f"/api/analytics/territory/{territory_id}/best-selling-products", params=params)
    
    async def get_area_manager_best_selling_products(self, tenant_id: str, area_manager_id: int, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get best selling products for all territories managed by an area manager.
        
        Args:
            tenant_id: Tenant identifier
            area_manager_id: Area manager ID
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of best selling products with units sold and percentages
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", f"/api/analytics/area-manager/{area_manager_id}/best-selling-products", params=params)
    
    async def get_tenant_sales_report(self, tenant_id: str, start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """
        Get sales report for entire tenant (aggregated view).
        
        Args:
            tenant_id: Tenant identifier
            start_date: Start date for the report period
            end_date: End date for the report period
            
        Returns:
            List of monthly sales data
        """
        return await self._make_request("GET", "/api/analytics/tenant/sales-report", params={"tenant_id": tenant_id, "start_date": start_date, "end_date": end_date})
    
    async def get_territory_sales_report(self, tenant_id: str, territory_id: str, start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """
        Get sales report for a specific territory (aggregated view).
        
        Args:
            tenant_id: Tenant identifier
            territory_id: Territory identifier
            start_date: Start date for the report period
            end_date: End date for the report period
            
        Returns:
            List of monthly sales data
        """
        return await self._make_request("GET", f"/api/analytics/territory/{territory_id}/sales-report", params={"tenant_id": tenant_id, "start_date": start_date, "end_date": end_date})
    
    async def get_area_manager_sales_report(self, tenant_id: str, area_manager_id: int, start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """
        Get sales report for all territories managed by an area manager.
        
        Args:
            tenant_id: Tenant identifier
            area_manager_id: Area manager ID
            start_date: Start date for the report period
            end_date: End date for the report period
            
        Returns:
            List of monthly sales data
        """
        return await self._make_request("GET", f"/api/analytics/area-manager/{area_manager_id}/sales-report", params={"tenant_id": tenant_id, "start_date": start_date, "end_date": end_date})
    
    async def get_shop_purchase_analysis(self, tenant_id: str, shop_id: str, year: int) -> List[Dict[str, Any]]:
        """
        Get purchase analysis for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            year: Year for analysis
            
        Returns:
            List of purchase data
        """
        params = {"tenant_id": tenant_id, "year": year}
        return await self._make_request("GET", f"/api/analytics/shops/{shop_id}/purchase-analysis", params=params)
    
    async def get_shop_products(self, tenant_id: str, shop_id: str, year: int) -> List[Dict[str, Any]]:
        """
        Get products sold to a specific shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            year: Year for analysis
            
        Returns:
            List of products sold to the shop
        """
        params = {"tenant_id": tenant_id, "year": year}
        return await self._make_request("GET", f"/api/analytics/shops/{shop_id}/best-selling-products", params=params)
    
    async def get_shop_sales_report(self, tenant_id: str, shop_id: str, year: int) -> List[Dict[str, Any]]:
        """
        Get sales report for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            year: Year for analysis
            
        Returns:
            List of sales data
        """
        params = {"tenant_id": tenant_id, "year": year}
        return await self._make_request("GET", f"/api/analytics/shops/{shop_id}/sales-report", params=params)

    async def get_executive_top_customers(self, tenant_id: str, sales_executive_id: int, start_date: Optional[str] = None, end_date: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get top customers for a sales executive.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID
            start_date: Start date for filtering (YYYY-MM-DD format, optional)
            end_date: End date for filtering (YYYY-MM-DD format, optional)
            
        Returns:
            List of top customers with shop names and points
        """
        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        return await self._make_request("GET", f"/api/analytics/executive/{sales_executive_id}/top-customers", params=params)

    async def get_executive_shop_assignments(self, tenant_id: str, sales_executive_id: int) -> List[Dict[str, Any]]:
        """
        Get all shop assignments for a sales executive.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID
            
        Returns:
            List of shop assignments
        """
        return await self._make_request("GET", f"/api/assignments/executive/{sales_executive_id}/shops", params={"tenant_id": tenant_id})

    async def create_executive_shop_assignment(self, assignment_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new sales executive to shop assignment.
        
        Args:
            assignment_data: Assignment data to create
            
        Returns:
            Assignment creation result
        """
        return await self._make_request("POST", "/api/assignments/executive-shop", json=assignment_data)
    
    # Notification methods
    async def get_notifications(
        self, 
        tenant_id: str, 
        receiver_id: Optional[str] = None,
        notification_type: Optional[str] = None,
        is_confirmed: Optional[bool] = None,
        limit: Optional[int] = None,
        offset: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Get notifications from the Data Layer.
        
        Args:
            tenant_id: Tenant identifier
            receiver_id: Filter by receiver user ID
            notification_type: Filter by notification type
            is_confirmed: Filter by confirmation status
            limit: Maximum number of results
            offset: Number of results to skip
            
        Returns:
            List of notification dictionaries
        """
        params = {}
        if receiver_id:
            params["receiver_id"] = receiver_id
        if notification_type:
            params["notification_type"] = notification_type
        if is_confirmed is not None:
            params["is_confirmed"] = str(is_confirmed).lower()
        if limit:
            params["limit"] = limit
        if offset:
            params["offset"] = offset
            
        return await self._make_request("GET", f"/api/notifications/{tenant_id}", params=params)
    
    async def get_notification(self, tenant_id: str, notification_id: str) -> Optional[Dict[str, Any]]:
        """
        Get a specific notification by ID.
        
        Args:
            tenant_id: Tenant identifier
            notification_id: Notification identifier
            
        Returns:
            Notification dictionary or None if not found
        """
        try:
            return await self._make_request("GET", f"/api/notifications/{tenant_id}/{notification_id}")
        except HTTPException as e:
            if e.status_code == 404:
                return None
            raise
    
    async def create_notification(self, notification_data: Dict[str, Any], tenant_id: str) -> Dict[str, Any]:
        """
        Create a new notification.
        
        Args:
            notification_data: Notification data
            tenant_id: Tenant identifier
            
        Returns:
            Created notification data
        """
        return await self._make_request("POST", f"/api/notifications/{tenant_id}", json=notification_data)
    
    async def update_notification(
        self, 
        notification_id: str, 
        notification_data: Dict[str, Any], 
        tenant_id: str
    ) -> Dict[str, Any]:
        """
        Update a notification.
        
        Args:
            notification_id: Notification identifier
            notification_data: Updated notification data
            tenant_id: Tenant identifier
            
        Returns:
            Updated notification data
        """
        return await self._make_request("PUT", f"/api/notifications/{tenant_id}/{notification_id}", json=notification_data)

    async def get(self, endpoint: str, **kwargs) -> Dict[str, Any]:
        """
        Generic GET method for backward compatibility.
        
        Args:
            endpoint: API endpoint path
            **kwargs: Additional parameters (params, headers, etc.)
            
        Returns:
            Response data from the Data Layer
        """
        return await self._make_request("GET", endpoint, **kwargs)

    async def put(self, endpoint: str, **kwargs) -> Dict[str, Any]:
        """
        Generic PUT method for backward compatibility.
        
        Args:
            endpoint: API endpoint path
            **kwargs: Additional parameters (json, headers, etc.)
            
        Returns:
            Response data from the Data Layer
        """
        return await self._make_request("PUT", endpoint, **kwargs)

    async def post(self, endpoint: str, **kwargs) -> Dict[str, Any]:
        """
        Generic POST method for backward compatibility.
        
        Args:
            endpoint: API endpoint path
            **kwargs: Additional parameters (json, headers, etc.)
            
        Returns:
            Response data from the Data Layer
        """
        return await self._make_request("POST", endpoint, **kwargs)


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
