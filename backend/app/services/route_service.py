"""
Route service for managing sales routes.

Handles CRUD operations for routes with proper authentication,
authorization, and tenant isolation.
"""

from typing import Any, Dict, List, Optional
import logging
from app.services.data_layer_client import get_data_layer_client
from app.core.errors import (
    RouteNotFoundError, 
    RouteAlreadyExistsError, 
    InvalidRouteDataError,
    InsufficientPermissionsError
)
from app.domain.models.route import RouteCreate, RouteUpdate, RouteRead, RouteAssignmentCreate

logger = logging.getLogger(__name__)


class RouteService:
    """Service for managing routes with proper security and validation."""
    
    def __init__(self, data_layer_client=None):
        self.data_layer = data_layer_client
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    async def _generate_route_id(self, tenant_id: str) -> str:
        """
        Generate a unique route ID for the tenant.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            Unique route ID (e.g., RT-001, RT-002)
        """
        data_layer = await self._get_data_layer()
        
        try:
            # Get existing routes for the tenant
            existing_routes = await data_layer.get_routes(tenant_id)
            
            # Find the highest route number
            max_number = 0
            for route in existing_routes:
                if route.get("route_id") and route["route_id"].startswith("RT-"):
                    try:
                        number = int(route["route_id"][3:])  # Extract number after "RT-"
                        max_number = max(max_number, number)
                    except ValueError:
                        continue
            
            # Generate next route ID
            next_number = max_number + 1
            return f"RT-{next_number:03d}"  # Format as RT-001, RT-002, etc.
            
        except Exception as e:
            logger.error(f"Failed to generate route ID: {str(e)}")
            # Fallback: use timestamp-based ID
            import time
            timestamp = int(time.time())
            return f"RT-{timestamp}"
    
    async def create_route(self, route_data: RouteCreate, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new route.
        
        Args:
            route_data: Route data to create
            tenant_id: Tenant identifier from URL parameter (enforced)
            current_user: Current authenticated user
            
        Returns:
            Created route data
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
            RouteAlreadyExistsError: If route with ID/code already exists
        """
        # Check permissions - only client_admin and superadmin can create routes
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to create routes"
            )
        
        # SECURITY: Enforce tenant isolation - users can only create routes in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only create routes in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if route with same route_id already exists
        existing_routes = await data_layer.get_routes(tenant_id)
        for route in existing_routes:
            if route.get("route_id") == route_data.route_id:
                raise RouteAlreadyExistsError(
                    message=f"Route with ID {route_data.route_id} already exists"
                )
        
        # Generate unique route_id if not provided
        if not route_data.route_id:
            route_data.route_id = await self._generate_route_id(tenant_id)
        
        # Create route
        try:
            # Enrich route data with metadata
            route_dict = route_data.model_dump() if hasattr(route_data, 'model_dump') else dict(route_data)
            
            # Convert date objects to ISO format strings for JSON serialization
            if 'week_start_date' in route_dict and route_dict['week_start_date']:
                if hasattr(route_dict['week_start_date'], 'isoformat'):
                    route_dict['week_start_date'] = route_dict['week_start_date'].isoformat()
            
            enriched_route_data = {
                **route_dict,
                "created_by": current_user.get("id"),
                "updated_by": current_user.get("id")
            }
            
            # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
            created_route = await data_layer.create_route(enriched_route_data, tenant_id)
            logger.info(
                f"Route created successfully: route_id {route_data.route_id}, name '{route_data.name}', territory {route_data.territory_id}, week_start {route_data.week_start_date}, created_by {current_user.get('id')}"
            )
            return created_route
        except Exception as e:
            logger.error(
                f"Failed to create route: {str(e)}, route_id {route_data.route_id}, name '{route_data.name}', territory {route_data.territory_id}, week_start {route_data.week_start_date}"
            )
            raise InvalidRouteDataError(
                message="Failed to create route",
                details={"error": str(e)}
            )
    
    async def get_routes(self, tenant_id: str, current_user: Dict[str, Any], params: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """
        Get routes for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            params: Optional query parameters (pagination, filters)
            
        Returns:
            List of routes
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - all authenticated users can view routes
        if not current_user:
            raise InsufficientPermissionsError(
                message="Authentication required to view routes"
            )
        
        # Enforce tenant isolation based on user role
        user_tenant_id = current_user.get("tenant_id")
        
        if current_user.get("role") == "superadmin":
            # Superadmin can view routes from any tenant
            target_tenant = tenant_id
        else:
            # Non-superadmin users can ONLY access their own tenant
            if tenant_id != user_tenant_id:
                raise InsufficientPermissionsError(
                    message="You can only view routes from your own tenant"
                )
            target_tenant = user_tenant_id
        
        data_layer = await self._get_data_layer()
        
        try:
            # Apply filters if provided
            filters = {}
            if params:
                if "executive_id" in params:
                    filters["executive_id"] = params["executive_id"]
                if "week_start" in params:
                    filters["week_start"] = params["week_start"]
                if "status" in params:
                    filters["status"] = params["status"]
            
            routes = await data_layer.get_routes(target_tenant, **filters)
            logger.info(
                f"Retrieved {len(routes)} routes for tenant {target_tenant}, user {current_user.get('id')}"
            )
            return routes
        except Exception as e:
            logger.error(
                f"Failed to retrieve routes: {str(e)}, tenant {target_tenant}"
            )
            raise InvalidRouteDataError(
                message="Failed to retrieve routes",
                details={"error": str(e)}
            )
    
    async def get_route(self, route_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Get a specific route by ID.
        
        Args:
            route_id: Route identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Route data if found, None otherwise
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - all authenticated users can view routes
        if not current_user:
            raise InsufficientPermissionsError(
                message="Authentication required to view routes"
            )
        
        # Enforce tenant isolation based on user role
        user_tenant_id = current_user.get("tenant_id")
        
        if current_user.get("role") == "superadmin":
            # Superadmin can view routes from any tenant
            target_tenant = tenant_id
        else:
            # Non-superadmin users can ONLY access their own tenant
            if tenant_id != user_tenant_id:
                raise InsufficientPermissionsError(
                    message="You can only view routes from your own tenant"
                )
            target_tenant = user_tenant_id
        
        data_layer = await self._get_data_layer()
        
        try:
            route = await data_layer.get_route(route_id, target_tenant)
            if route:
                logger.info(
                    f"Retrieved route {route_id} for tenant {target_tenant}, user {current_user.get('id')}"
                )
            return route
        except Exception as e:
            logger.error(
                f"Failed to retrieve route {route_id}: {str(e)}, tenant {target_tenant}"
            )
            raise InvalidRouteDataError(
                message="Failed to retrieve route",
                details={"error": str(e)}
            )
    
    async def update_route(self, route_id: str, route_data: RouteUpdate, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Update an existing route.
        
        Args:
            route_id: Route identifier
            route_data: Route data to update
            tenant_id: Tenant identifier from URL parameter (enforced)
            current_user: Current authenticated user
            
        Returns:
            Updated route data
            
        Raises:
            RouteNotFoundError: If route doesn't exist
            InsufficientPermissionsError: If user lacks permission
            InvalidRouteDataError: If update fails
        """
        # Check permissions - only client_admin and superadmin can update routes
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to update routes"
            )
        
        # SECURITY: Enforce tenant isolation - users can only update routes in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only update routes in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if route exists
        existing_route = await data_layer.get_route(route_id, tenant_id)
        if not existing_route:
            raise RouteNotFoundError(
                message=f"Route with ID {route_id} not found"
            )
        
        # Update route
        try:
            # Enrich route data with metadata
            route_dict = route_data.model_dump(exclude_unset=True) if hasattr(route_data, 'model_dump') else dict(route_data)
            
            # Convert date objects to ISO format strings for JSON serialization
            if 'week_start_date' in route_dict and route_dict['week_start_date']:
                if hasattr(route_dict['week_start_date'], 'isoformat'):
                    route_dict['week_start_date'] = route_dict['week_start_date'].isoformat()
            
            enriched_route_data = {
                **route_dict,
                "updated_by": current_user.get("id")
            }
            
            # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
            updated_route = await data_layer.update_route(route_id, enriched_route_data, tenant_id)
            logger.info(
                f"Route updated successfully: route {route_id}, updated_by {current_user.get('id')}"
            )
            return updated_route
        except Exception as e:
            logger.error(
                f"Failed to update route {route_id}: {str(e)}"
            )
            raise InvalidRouteDataError(
                message="Failed to update route",
                details={"error": str(e)}
            )
    
    async def delete_route(self, route_id: int, tenant_id: str, current_user: Dict[str, Any]) -> None:
        """
        Delete a route (hard delete - completely removes from database).
        
        Args:
            route_id: Route database ID
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to delete routes"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # Delete route completely from database
            await data_layer.delete_route(route_id, tenant_id)
            
            logger.info(
                f"Route hard deleted successfully: route_id {route_id}, deleted_by {current_user.get('id')}"
            )
            
        except Exception as e:
            logger.error(f"Failed to delete route {route_id}: {str(e)}")
            raise InvalidRouteDataError(
                message="Failed to delete route",
                details={"error": str(e)}
            )
    
    async def add_shop_to_route(self, route_id: str, assignment_data: Dict[str, Any], tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Add a shop to a route (create route assignment).
        
        Args:
            route_id: Route identifier
            assignment_data: Shop assignment data
            tenant_id: Tenant identifier from URL parameter (enforced)
            current_user: Current authenticated user
            
        Returns:
            Created assignment data
            
        Raises:
            RouteNotFoundError: If route doesn't exist
            InsufficientPermissionsError: If user lacks permission
            InvalidRouteDataError: If assignment fails
        """
        # Check permissions - only client_admin and superadmin can manage route assignments
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to manage route assignments"
            )
        
        # SECURITY: Enforce tenant isolation - users can only manage routes in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only manage routes in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if route exists
        existing_route = await data_layer.get_route(route_id, tenant_id)
        if not existing_route:
            raise RouteNotFoundError(
                message=f"Route with ID {route_id} not found"
            )
        
        # Create route assignment
        try:
            # Enrich assignment data with metadata
            enriched_assignment_data = {
                **assignment_data,
                "route_id": route_id,
                "created_by": current_user.get("id"),
                "updated_by": current_user.get("id")
            }
            
            # Convert date objects to ISO format strings for JSON serialization
            if 'planned_date' in enriched_assignment_data and enriched_assignment_data['planned_date']:
                if hasattr(enriched_assignment_data['planned_date'], 'isoformat'):
                    enriched_assignment_data['planned_date'] = enriched_assignment_data['planned_date'].isoformat()
            
            if 'planned_time' in enriched_assignment_data and enriched_assignment_data['planned_time']:
                if hasattr(enriched_assignment_data['planned_time'], 'isoformat'):
                    enriched_assignment_data['planned_time'] = enriched_assignment_data['planned_time'].isoformat()
            
            created_assignment = await data_layer.create_route_assignment(enriched_assignment_data, tenant_id)
            logger.info(
                f"Shop added to route successfully: route {route_id}, shop {assignment_data.get('shop_id')}, created_by {current_user.get('id')}"
            )
            return created_assignment
        except Exception as e:
            logger.error(
                f"Failed to add shop to route {route_id}: {str(e)}"
            )
            raise InvalidRouteDataError(
                message="Failed to add shop to route",
                details={"error": str(e)}
            )
    
    async def remove_shop_from_route(self, route_id: str, assignment_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Remove a shop from a route (delete route assignment).
        
        Args:
            route_id: Route identifier
            assignment_id: Assignment identifier
            tenant_id: Tenant identifier from URL parameter (enforced)
            current_user: Current authenticated user
            
        Returns:
            Deletion result
            
        Raises:
            RouteNotFoundError: If route doesn't exist
            InsufficientPermissionsError: If user lacks permission
            InvalidRouteDataError: If removal fails
        """
        # Check permissions - only client_admin and superadmin can manage route assignments
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to manage route assignments"
            )
        
        # SECURITY: Enforce tenant isolation - users can only manage routes in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only manage routes in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if route exists
        existing_route = await data_layer.get_route(route_id, tenant_id)
        if not existing_route:
            raise RouteNotFoundError(
                message=f"Route with ID {route_id} not found"
            )
        
        # Remove route assignment
        try:
            result = await data_layer.delete_route_assignment(assignment_id, tenant_id)
            logger.info(
                f"Shop removed from route successfully: route {route_id}, assignment {assignment_id}, deleted_by {current_user.get('id')}"
            )
            return result
        except Exception as e:
            logger.error(
                f"Failed to remove shop from route {route_id}: {str(e)}"
            )
            raise InvalidRouteDataError(
                message="Failed to remove shop from route",
                details={"error": str(e)}
            )
    
    async def get_route_with_assignments(self, route_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """
        Get a route with all its shop assignments.
        
        Args:
            route_id: Route identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Route data with assignments if found, None otherwise
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
            InvalidRouteDataError: If retrieval fails
        """
        # Check permissions - all authenticated users can view routes
        if not current_user:
            raise InsufficientPermissionsError(
                message="Authentication required to view routes"
            )
        
        # Enforce tenant isolation based on user role
        user_tenant_id = current_user.get("tenant_id")
        
        if current_user.get("role") == "superadmin":
            # Superadmin can view routes from any tenant
            target_tenant = tenant_id
        else:
            # Non-superadmin users can ONLY access their own tenant
            if tenant_id != user_tenant_id:
                raise InsufficientPermissionsError(
                    message="You can only view routes from your own tenant"
                )
            target_tenant = user_tenant_id
        
        data_layer = await self._get_data_layer()
        
        try:
            route = await data_layer.get_route_with_assignments(route_id, target_tenant)
            if route:
                logger.info(
                    f"Retrieved route with assignments {route_id} for tenant {target_tenant}, user {current_user.get('id')}"
                )
            return route
        except Exception as e:
            logger.error(
                f"Failed to retrieve route with assignments {route_id}: {str(e)}, tenant {target_tenant}"
            )
            raise InvalidRouteDataError(
                message="Failed to retrieve route with assignments",
                details={"error": str(e)}
            )

    async def get_route_by_route_id(self, route_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Get a specific route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Route data dictionary
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to view routes"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # Get route directly by route_id
            return await data_layer.get_route_by_route_id(route_id, tenant_id)
            
        except Exception as e:
            logger.error(f"Failed to get route by route_id {route_id}: {str(e)}")
            raise RouteNotFoundError(
                message="Failed to retrieve route",
                details={"error": str(e)}
            )
    
    async def update_route_by_route_id(self, route_id: str, route_data: RouteUpdate, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Update an existing route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            route_data: Route update data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Updated route data dictionary
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
            InvalidRouteDataError: If update data is invalid
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to update routes"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # Convert date objects to ISO format strings for JSON serialization
            route_dict = route_data.model_dump(exclude_unset=True) if hasattr(route_data, 'model_dump') else dict(route_data)
            
            if 'week_start_date' in route_dict and route_dict['week_start_date']:
                if hasattr(route_dict['week_start_date'], 'isoformat'):
                    route_dict['week_start_date'] = route_dict['week_start_date'].isoformat()
            
            # Add updated_by metadata
            enriched_route_data = {
                **route_dict,
                "updated_by": current_user.get("id")
            }
            
            # Update the route using route_id
            updated_route = await data_layer.update_route_by_route_id(route_id, enriched_route_data, tenant_id)
            
            logger.info(
                f"Route updated successfully: route_id {route_id}, updated_by {current_user.get('id')}"
            )
            return updated_route
            
        except Exception as e:
            logger.error(f"Failed to update route by route_id {route_id}: {str(e)}")
            raise InvalidRouteDataError(
                message="Failed to update route",
                details={"error": str(e)}
            )
    
    async def delete_route_by_route_id(self, route_id: str, tenant_id: str, current_user: Dict[str, Any]) -> None:
        """
        Delete a route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to delete routes"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # Delete using route_id
            await data_layer.delete_route_by_route_id(route_id, tenant_id)
            
            logger.info(
                f"Route deleted successfully: route_id {route_id}, deleted_by {current_user.get('id')}"
            )
            
        except Exception as e:
            logger.error(f"Failed to delete route by route_id {route_id}: {str(e)}")
            raise InvalidRouteDataError(
                message="Failed to delete route",
                details={"error": str(e)}
            )
    
    async def add_shop_to_route_by_route_id(self, route_id: str, assignment_data: RouteAssignmentCreate, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Add a shop to a route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            assignment_data: Route assignment data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Created route assignment data dictionary
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to manage route assignments"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # First get the route to find its database ID
            route = await self.get_route_by_route_id(route_id, tenant_id, current_user)
            if not route:
                raise RouteNotFoundError(
                    message=f"Route with ID {route_id} not found"
                )
            
            # Add shop using the database ID
            assignment_dict = assignment_data.model_dump() if hasattr(assignment_data, 'model_dump') else dict(assignment_data)
            
            # Add the database ID (not the business route_id) to the assignment data
            assignment_dict["route_id"] = route["id"]
            
            # Convert date objects to ISO format strings for JSON serialization
            if 'planned_date' in assignment_dict and assignment_dict['planned_date']:
                if hasattr(assignment_dict['planned_date'], 'isoformat'):
                    assignment_dict['planned_date'] = assignment_dict['planned_date'].isoformat()
            
            if 'planned_time' in assignment_dict and assignment_dict['planned_time']:
                if hasattr(assignment_dict['planned_time'], 'isoformat'):
                    assignment_dict['planned_time'] = assignment_dict['planned_time'].isoformat()
            
            # Create the assignment
            created_assignment = await data_layer.create_route_assignment(assignment_dict, tenant_id)
            
            logger.info(
                f"Shop added to route successfully: route_id {route_id}, shop_id {assignment_data.shop_id}, created_by {current_user.get('id')}"
            )
            return created_assignment
            
        except Exception as e:
            logger.error(f"Failed to add shop to route by route_id {route_id}: {str(e)}")
            raise InvalidRouteDataError(
                message="Failed to add shop to route",
                details={"error": str(e)}
            )
    
    async def remove_shop_from_route_by_route_id(self, route_id: str, assignment_id: int, tenant_id: str, current_user: Dict[str, Any]) -> None:
        """
        Remove a shop from a route by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            assignment_id: Route assignment database ID
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to manage route assignments"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # First get the route to find its database ID
            route = await self.get_route_by_route_id(route_id, tenant_id, current_user)
            if not route:
                raise RouteNotFoundError(
                    message=f"Route with ID {route_id} not found"
                )
            
            # Remove shop using the assignment ID
            await data_layer.delete_route_assignment(assignment_id, tenant_id)
            
            logger.info(
                f"Shop removed from route successfully: route_id {route_id}, assignment_id {assignment_id}, removed_by {current_user.get('id')}"
            )
            
        except Exception as e:
            logger.error(f"Failed to remove shop from route by route_id {route_id}: {str(e)}")
            raise InvalidRouteDataError(
                message="Failed to remove shop from route",
                details={"error": str(e)}
            )
    
    async def get_route_with_assignments_by_route_id(self, route_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Get a route with all its shop assignments by its business identifier (route_id).
        
        Args:
            route_id: Business-friendly route identifier (e.g., RT-001)
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Route data with assignments dictionary
            
        Raises:
            RouteNotFoundError: If route not found
            InsufficientPermissionsError: If user lacks permissions
        """
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to view routes"
            )
        
        # Superadmin can access any tenant, others only their own
        if current_user.get("role") != "superadmin" and current_user.get("tenant_id") != tenant_id:
            raise InsufficientPermissionsError(
                message="Access denied to this tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # First get the route to find its database ID
            route = await self.get_route_by_route_id(route_id, tenant_id, current_user)
            if not route:
                raise RouteNotFoundError(
                    message=f"Route with ID {route_id} not found"
                )
            
            # Get route with assignments using the database ID
            route_with_assignments = await data_layer.get_route_with_assignments(route["id"], tenant_id)
            
            return route_with_assignments
            
        except Exception as e:
            logger.error(f"Failed to get route with assignments by route_id {route_id}: {str(e)}")
            raise RouteNotFoundError(
                message="Failed to retrieve route with assignments",
                details={"error": str(e)}
            )


# Dependency injection
async def get_route_service() -> RouteService:
    """Get RouteService instance."""
    return RouteService()
