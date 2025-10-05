"""
Assignment Service for managing sales executive to shop assignments.

Handles the creation, management, and validation of sales executive assignments
to shops for analytics and performance tracking.
"""

from datetime import datetime, date
from typing import Dict, List, Optional, Any
import logging

from ..core.logging import get_logger
from ..services.data_layer_client import get_data_layer_client

logger = get_logger(__name__)


class AssignmentService:
    """Service for managing sales executive to shop assignments."""
    
    def __init__(self):
        """Initialize assignment service."""
        self.data_layer = None
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    async def create_executive_shop_assignment(
        self,
        sales_executive_id: int,
        shop_id: str,
        territory_id: str,
        tenant_id: str,
        assigned_date: Optional[date] = None,
        created_by: Optional[int] = None
    ) -> Dict[str, Any]:
        """
        Create a new sales executive to shop assignment.
        
        Args:
            sales_executive_id: Sales executive ID
            shop_id: Shop identifier
            territory_id: Territory identifier
            tenant_id: Tenant identifier
            assigned_date: Assignment date (defaults to today)
            created_by: User ID creating the assignment
            
        Returns:
            Assignment creation result
            
        Raises:
            ValueError: If assignment already exists or validation fails
        """
        try:
            logger.info(f"Creating assignment: executive {sales_executive_id} -> shop {shop_id} in territory {territory_id}")
            
            # Validate the assignment
            await self._validate_assignment(sales_executive_id, shop_id, territory_id, tenant_id)
            
            # Set default assignment date
            if assigned_date is None:
                assigned_date = date.today()
            
            data_layer = await self._get_data_layer()
            
            # Create the assignment
            assignment_data = {
                "sales_executive_id": sales_executive_id,
                "shop_id": shop_id,
                "territory_id": territory_id,
                "tenant_id": tenant_id,
                "assigned_date": assigned_date.isoformat(),
                "status": "active",
                "created_by": created_by,
                "updated_by": created_by
            }
            
            result = await data_layer.create_executive_shop_assignment(assignment_data)
            
            logger.info(f"Successfully created assignment: executive {sales_executive_id} -> shop {shop_id}")
            return result
            
        except Exception as e:
            logger.error(f"Error creating assignment: {str(e)}", exc_info=True)
            raise
    
    async def get_executive_shop_assignments(
        self,
        sales_executive_id: int,
        tenant_id: str
    ) -> List[Dict[str, Any]]:
        """
        Get all shop assignments for a sales executive.
        
        Args:
            sales_executive_id: Sales executive ID
            tenant_id: Tenant identifier
            
        Returns:
            List of shop assignments
        """
        try:
            logger.info(f"Getting shop assignments for executive {sales_executive_id}")
            
            data_layer = await self._get_data_layer()
            assignments = await data_layer.get_executive_shop_assignments(tenant_id, sales_executive_id)
            
            logger.info(f"Retrieved {len(assignments)} assignments for executive {sales_executive_id}")
            return assignments
            
        except Exception as e:
            logger.error(f"Error getting executive assignments: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_assigned_executive(
        self,
        shop_id: str,
        tenant_id: str
    ) -> Optional[Dict[str, Any]]:
        """
        Get the sales executive assigned to a specific shop.
        
        Args:
            shop_id: Shop identifier
            tenant_id: Tenant identifier
            
        Returns:
            Assignment data or None if no assignment found
        """
        try:
            logger.info(f"Getting assigned executive for shop {shop_id}")
            
            data_layer = await self._get_data_layer()
            
            # Get all assignments and filter by shop_id
            # Note: This is not efficient for large datasets, but works for now
            # In production, you'd want a dedicated endpoint for this
            
            # For now, we'll return None as we don't have a direct endpoint
            # This would need to be implemented in the Data Layer
            logger.info(f"No direct endpoint for shop assignment lookup")
            return None
            
        except Exception as e:
            logger.error(f"Error getting shop assigned executive: {str(e)}", exc_info=True)
            return None
    
    async def sync_assignments_from_client_data(
        self,
        tenant_id: str,
        client_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Sync sales executive assignments from client data.
        
        This method analyzes client data to determine which sales executive
        should be assigned to which shops based on order history and patterns.
        
        Args:
            tenant_id: Tenant identifier
            client_data: Client data from external API
            
        Returns:
            Sync result with statistics
        """
        try:
            logger.info(f"Syncing assignments from client data for tenant {tenant_id}")
            
            data_layer = await self._get_data_layer()
            
            # Get existing assignments
            existing_assignments = []
            # Note: This would need a dedicated endpoint to get all assignments for a tenant
            
            # Analyze client data to determine assignments
            assignments_to_create = []
            assignments_to_update = []
            
            shops_data = client_data.get("shops", [])
            for shop_data in shops_data:
                shop_id = shop_data.get("shop_id")
                shop_name = shop_data.get("shop_name")
                
                if not shop_id:
                    continue
                
                # For now, we'll create a simple assignment logic
                # In a real implementation, you'd analyze order patterns, visit history, etc.
                
                # Get the first sales executive from the tenant as a default
                users = await data_layer.get_users(tenant_id)
                sales_executives = [u for u in users if u.get("role") == "sales_executive"]
                
                if sales_executives:
                    # Simple assignment: assign to first available sales executive
                    sales_executive_id = sales_executives[0].get("id")
                    territory_id = sales_executives[0].get("territory_id")
                    
                    if territory_id:
                        assignment_data = {
                            "sales_executive_id": sales_executive_id,
                            "shop_id": str(shop_id),
                            "territory_id": territory_id,
                            "tenant_id": tenant_id,
                            "assigned_date": date.today().isoformat(),
                            "status": "active"
                        }
                        assignments_to_create.append(assignment_data)
            
            # Create assignments
            created_count = 0
            for assignment_data in assignments_to_create:
                try:
                    await data_layer.create_executive_shop_assignment(assignment_data)
                    created_count += 1
                except Exception as e:
                    logger.warning(f"Failed to create assignment for shop {assignment_data['shop_id']}: {e}")
            
            result = {
                "tenant_id": tenant_id,
                "total_shops": len(shops_data),
                "assignments_created": created_count,
                "assignments_updated": len(assignments_to_update),
                "sync_timestamp": datetime.utcnow().isoformat()
            }
            
            logger.info(f"Assignment sync completed: {result}")
            return result
            
        except Exception as e:
            logger.error(f"Error syncing assignments from client data: {str(e)}", exc_info=True)
            raise
    
    async def _validate_assignment(
        self,
        sales_executive_id: int,
        shop_id: str,
        territory_id: str,
        tenant_id: str
    ) -> None:
        """
        Validate that an assignment is valid.
        
        Args:
            sales_executive_id: Sales executive ID
            shop_id: Shop identifier
            territory_id: Territory identifier
            tenant_id: Tenant identifier
            
        Raises:
            ValueError: If validation fails
        """
        try:
            data_layer = await self._get_data_layer()
            
            # Validate sales executive exists and is in the correct territory
            users = await data_layer.get_users(tenant_id)
            sales_executive = next((u for u in users if u.get("id") == sales_executive_id), None)
            
            if not sales_executive:
                raise ValueError(f"Sales executive {sales_executive_id} not found")
            
            if sales_executive.get("role") != "sales_executive":
                raise ValueError(f"User {sales_executive_id} is not a sales executive")
            
            if sales_executive.get("territory_id") != territory_id:
                raise ValueError(f"Sales executive {sales_executive_id} is not assigned to territory {territory_id}")
            
            # Validate shop exists and is in the correct territory
            shops = await data_layer.get_shops(tenant_id)
            shop = next((s for s in shops if s.get("shop_id") == shop_id), None)
            
            if not shop:
                raise ValueError(f"Shop {shop_id} not found")
            
            if shop.get("territory_id") != territory_id:
                raise ValueError(f"Shop {shop_id} is not in territory {territory_id}")
            
            # Check if assignment already exists
            existing_assignments = await data_layer.get_executive_shop_assignments(tenant_id, sales_executive_id)
            for assignment in existing_assignments:
                if assignment.get("shop_id") == shop_id and assignment.get("status") == "active":
                    raise ValueError(f"Active assignment already exists for executive {sales_executive_id} and shop {shop_id}")
            
            logger.info(f"Assignment validation passed: executive {sales_executive_id} -> shop {shop_id}")
            
        except Exception as e:
            logger.error(f"Assignment validation failed: {str(e)}")
            raise ValueError(f"Assignment validation failed: {str(e)}")
    
    async def get_territory_assignments_summary(
        self,
        territory_id: str,
        tenant_id: str
    ) -> Dict[str, Any]:
        """
        Get assignment summary for a territory.
        
        Args:
            territory_id: Territory identifier
            tenant_id: Tenant identifier
            
        Returns:
            Territory assignment summary
        """
        try:
            logger.info(f"Getting assignment summary for territory {territory_id}")
            
            data_layer = await self._get_data_layer()
            
            # Get all sales executives in the territory
            users = await data_layer.get_users(tenant_id)
            territory_executives = [
                u for u in users 
                if u.get("territory_id") == territory_id and u.get("role") == "sales_executive"
            ]
            
            # Get all shops in the territory
            shops = await data_layer.get_shops(tenant_id, territory_id=territory_id)
            
            # Get assignments for each executive
            assignments_summary = []
            for executive in territory_executives:
                executive_id = executive.get("id")
                assignments = await data_layer.get_executive_shop_assignments(tenant_id, executive_id)
                
                assignments_summary.append({
                    "executive_id": executive_id,
                    "executive_name": executive.get("name"),
                    "assigned_shops": len(assignments),
                    "assignments": assignments
                })
            
            result = {
                "territory_id": territory_id,
                "total_executives": len(territory_executives),
                "total_shops": len(shops),
                "executives": assignments_summary,
                "summary_timestamp": datetime.utcnow().isoformat()
            }
            
            logger.info(f"Territory assignment summary: {len(territory_executives)} executives, {len(shops)} shops")
            return result
            
        except Exception as e:
            logger.error(f"Error getting territory assignments summary: {str(e)}", exc_info=True)
            return {
                "territory_id": territory_id,
                "error": str(e),
                "summary_timestamp": datetime.utcnow().isoformat()
            }
