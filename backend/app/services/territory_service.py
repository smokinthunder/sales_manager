"""
Territory Service Layer

Handles all territory-related business logic including CRUD operations,
validation, and authorization checks.
"""

import logging
from typing import List, Optional, Dict, Any
from datetime import datetime
from fastapi import HTTPException, status
from app.core.errors import (
    TerritoryNotFoundError, 
    TerritoryAlreadyExistsError, 
    InvalidTerritoryDataError,
    InsufficientPermissionsError
)
from app.services.data_layer_client import get_data_layer_client
from app.domain.models.territory import TerritoryCreate, TerritoryUpdate, TerritoryRead

logger = logging.getLogger(__name__)


class TerritoryService:
    """Service for managing territories."""
    
    def __init__(self):
        self.data_layer = None
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    async def create_territory(self, territory_data: TerritoryCreate, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new territory.
        
        Args:
            territory_data: Territory data to create
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Created territory data
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
            TerritoryAlreadyExistsError: If territory with ID/code already exists
        """
        # Check permissions - only client_admin and superadmin can create territories
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to create territories"
            )
        
        # Enforce tenant isolation - users can only create territories in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only create territories in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if territory with same territory_id or code already exists
        existing_territories = await data_layer.get_territories(tenant_id)
        for territory in existing_territories:
            if (territory.get("territory_id") == territory_data.territory_id or 
                territory.get("code") == territory_data.code):
                raise TerritoryAlreadyExistsError(
                    message=f"Territory with ID {territory_data.territory_id} or code {territory_data.code} already exists"
                )
        
        # Create territory
        try:
            # Enrich territory data with metadata
            territory_dict = territory_data.model_dump() if hasattr(territory_data, 'model_dump') else dict(territory_data)
            enriched_territory_data = {
                **territory_dict,
                "created_by": current_user.get("id"),
                "updated_by": current_user.get("id")
            }
            
            created_territory = await data_layer.create_territory(enriched_territory_data, tenant_id)
            logger.info(
                f"Territory created successfully: territory {created_territory.get('territory_id')}, name {territory_data.name}, created_by {current_user.get('id')}"
            )
            return created_territory
        except Exception as e:
            logger.error(
                f"Failed to create territory: {str(e)}, territory_id {territory_data.territory_id}"
            )
            raise InvalidTerritoryDataError(
                message="Failed to create territory",
                details={"error": str(e)}
            )
    
    async def get_territories(self, tenant_id: str, current_user: Dict[str, Any]) -> List[Dict[str, Any]]:
        """
        Get territories for a specific tenant.
        
        Args:
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            List of territories
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - all authenticated users can view territories
        if not current_user:
            raise InsufficientPermissionsError(
                message="Authentication required to view territories"
            )
        
        # Enforce tenant isolation based on user role
        user_tenant_id = current_user.get("tenant_id")
        
        if current_user.get("role") == "superadmin":
            # Superadmin can view territories from any tenant
            target_tenant = tenant_id
        else:
            # Non-superadmin users can ONLY access their own tenant
            if tenant_id != user_tenant_id:
                raise InsufficientPermissionsError(
                    message="You can only access territories from your own tenant"
                )
            target_tenant = user_tenant_id
        
        data_layer = await self._get_data_layer()
        territories = await data_layer.get_territories(target_tenant)
        
        logger.info(
            f"Retrieved {len(territories)} territories for tenant {target_tenant}, requested by user {current_user.get('id')}"
        )
        return territories
    
    async def get_territory(self, territory_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Get territory by ID.
        
        Args:
            territory_id: Territory ID
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Territory data
            
        Raises:
            TerritoryNotFoundError: If territory not found
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - all authenticated users can view territories
        if not current_user:
            raise InsufficientPermissionsError(
                message="Authentication required to view territories"
            )
        
        # Enforce tenant isolation based on user role
        user_tenant_id = current_user.get("tenant_id")
        
        if current_user.get("role") == "superadmin":
            # Superadmin can view territories from any tenant
            target_tenant = tenant_id
        else:
            # Non-superadmin users can ONLY access their own tenant
            if tenant_id != user_tenant_id:
                raise InsufficientPermissionsError(
                    message="You can only access territories from your own tenant"
                )
            target_tenant = user_tenant_id
        
        data_layer = await self._get_data_layer()
        territories = await data_layer.get_territories(target_tenant)
        
        # Find territory by ID
        territory = None
        for t in territories:
            if t.get("territory_id") == territory_id:
                territory = t
                break
        
        if not territory:
            raise TerritoryNotFoundError(
                message=f"Territory with ID {territory_id} not found"
            )
        
        return territory
    
    async def update_territory(
        self, 
        territory_id: str, 
        territory_data: TerritoryUpdate, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Update territory data.
        
        Args:
            territory_id: Territory ID to update
            territory_data: Updated territory data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Updated territory data
            
        Raises:
            TerritoryNotFoundError: If territory not found
            InsufficientPermissionsError: If user lacks permission
            InvalidTerritoryDataError: If territory data is invalid
        """
        # Check permissions - only client_admin and superadmin can update territories
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to update territories"
            )
        
        # Enforce tenant isolation - users can only update territories in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only update territories in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if territory exists
        existing_territories = await data_layer.get_territories(tenant_id)
        territory_exists = False
        for territory in existing_territories:
            if territory.get("territory_id") == territory_id:
                territory_exists = True
                break
        
        if not territory_exists:
            raise TerritoryNotFoundError(
                message=f"Territory with ID {territory_id} not found"
            )
        
        # Check for conflicts if updating code
        if territory_data.code is not None:
            for territory in existing_territories:
                if (territory.get("code") == territory_data.code and 
                    territory.get("territory_id") != territory_id):
                    raise TerritoryAlreadyExistsError(
                        message=f"Territory with code {territory_data.code} already exists"
                    )
        
        # Update territory
        try:
            # Add updated_by to the data
            territory_dict = territory_data.model_dump(exclude_none=True) if hasattr(territory_data, 'model_dump') else dict(territory_data)
            territory_dict["updated_by"] = current_user.get("id")
            
            updated_territory = await data_layer.update_territory(territory_id, territory_dict, tenant_id)
            
            logger.info(
                f"Territory updated successfully: territory {territory_id}, updated by {current_user.get('id')}"
            )
            
            return updated_territory
        except Exception as e:
            logger.error(
                f"Failed to update territory: {str(e)}, territory_id {territory_id}"
            )
            raise InvalidTerritoryDataError(
                message="Failed to update territory",
                details={"error": str(e)}
            )
    
    async def delete_territory(self, territory_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Delete territory.
        
        Args:
            territory_id: Territory ID to delete
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Deletion result
            
        Raises:
            TerritoryNotFoundError: If territory not found
            InsufficientPermissionsError: If user lacks permission
            InvalidTerritoryDataError: If territory cannot be deleted
        """
        # Check permissions - only client_admin and superadmin can delete territories
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to delete territories"
            )
        
        # Enforce tenant isolation - users can only delete territories in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only delete territories in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if territory exists
        existing_territories = await data_layer.get_territories(tenant_id)
        territory_exists = False
        for territory in existing_territories:
            if territory.get("territory_id") == territory_id:
                territory_exists = True
                break
        
        if not territory_exists:
            raise TerritoryNotFoundError(
                message=f"Territory with ID {territory_id} not found"
            )
        
        # Delete territory
        try:
            result = await data_layer.delete_territory(territory_id, tenant_id)
            
            logger.info(
                f"Territory deleted successfully: territory {territory_id}, deleted by {current_user.get('id')}"
            )
            
            return result
        except Exception as e:
            logger.error(
                f"Failed to delete territory: {str(e)}, territory_id {territory_id}"
            )
            raise InvalidTerritoryDataError(
                message="Failed to delete territory",
                details={"error": str(e)}
            )


# Global instance
territory_service = TerritoryService()


async def get_territory_service() -> TerritoryService:
    """Get the global territory service instance."""
    return territory_service
