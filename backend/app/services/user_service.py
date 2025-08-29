"""
User Service Layer

Handles all user-related business logic including CRUD operations,
validation, and authorization checks.
"""

import logging
from typing import List, Optional, Dict, Any
from datetime import datetime
from fastapi import HTTPException, status
from app.core.errors import (
    UserNotFoundError, 
    UserAlreadyExistsError, 
    InvalidUserDataError,
    InsufficientPermissionsError,
    ProfileUpdatePendingApprovalError,
    ApprovalRequiredError
)
from app.services.data_layer_client import get_data_layer_client
from app.services.approval_service import get_approval_service
from app.domain.models.user import UserCreate, UserUpdate, UserRead

logger = logging.getLogger(__name__)


class UserService:
    """Service for managing users."""
    
    def __init__(self):
        self.data_layer = None
        self.approval_service = None
    
    async def _get_approval_service(self):
        """Get Approval Service."""
        if not self.approval_service:
            self.approval_service = await get_approval_service()
        return self.approval_service
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    async def create_user(self, user_data: UserCreate, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new user.
        
        Args:
            user_data: User data to create
            tenant_id: Tenant identifier from URL parameter (enforced)
            current_user: Current authenticated user
            
        Returns:
            Created user data
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
            UserAlreadyExistsError: If user with phone already exists
        """
        # Check permissions - only client_admin and superadmin can create users
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to create users"
            )
        
        # SECURITY: Enforce tenant isolation - users can only be created in their own tenant
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only create users in your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if user with phone already exists
        existing_user = await data_layer.get_user_by_phone(
            user_data.phone, 
            tenant_id  # Use URL parameter, not request body
        )
        if existing_user:
            raise UserAlreadyExistsError(
                message=f"User with phone {user_data.phone} already exists"
            )
        
        # Create user
        try:
            # Enrich user data with metadata
            user_dict = user_data.model_dump() if hasattr(user_data, 'model_dump') else dict(user_data)
            enriched_user_data = {
                **user_dict,
                "created_by": current_user.get("id"),
                "updated_by": current_user.get("id"),
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }
            
            # Ensure email is properly set if provided
            if user_data.email:
                enriched_user_data["email"] = user_data.email
            
            # Debug logging to see what's being sent
            logger.info(f"Sending enriched user data to Data Layer: {enriched_user_data}")
            
            # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
            created_user = await data_layer.create_user(enriched_user_data, tenant_id)
            logger.info(
                f"User created successfully: user {created_user.get('id')}, phone {user_data.phone}, created_by {current_user.get('id')}"
            )
            return created_user
        except Exception as e:
            logger.error(
                f"Failed to create user: {str(e)}, phone {user_data.phone}"
            )
            raise InvalidUserDataError(
                message="Failed to create user",
                details={"error": str(e)}
            )
    
    async def get_user(self, user_id: str, tenant_id: str, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Get user by ID.
        
        Args:
            user_id: User ID to retrieve
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            User data
            
        Raises:
            UserNotFoundError: If user not found
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - users can only view their own profile or if they have admin role
        if (current_user.get("id") != user_id and 
            current_user.get("role") not in ["client_admin", "superadmin", "area_manager"]):
            raise InsufficientPermissionsError(
                message="Insufficient permissions to view this user"
            )
        
        # Enforce tenant isolation
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only access users from your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        user = await data_layer.get_user_by_id(user_id, tenant_id)
        
        if not user:
            raise UserNotFoundError(
                message=f"User with ID {user_id} not found"
            )
        
        return user
    
    async def get_users(
        self, 
        tenant_id: Optional[str], 
        current_user: Dict[str, Any],
        role: Optional[str] = None,
        status: Optional[str] = None,
        search: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get users with optional filtering.
        
        Args:
            tenant_id: Optional tenant identifier for filtering
            current_user: Current authenticated user
            role: Optional role filter
            status: Optional status filter
            search: Optional search term for name/phone
            
        Returns:
            List of users
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - only admin roles can list users
        if current_user.get("role") not in ["client_admin", "superadmin", "area_manager"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to list users"
            )
        
        data_layer = await self._get_data_layer()
        
        # Enforce tenant isolation based on user role
        user_tenant_id = current_user.get("tenant_id")
        
        if current_user.get("role") == "superadmin":
            # Superadmin can view all users across all tenants
            if tenant_id:
                # If specific tenant requested, use that
                target_tenant = tenant_id
            else:
                # If no tenant specified, superadmin can see all
                target_tenant = None
        else:
            # Non-superadmin users can ONLY access their own tenant
            if tenant_id and tenant_id != user_tenant_id:
                raise InsufficientPermissionsError(
                    message="You can only access users from your own tenant"
                )
            target_tenant = user_tenant_id
        
        users = await data_layer.get_users(target_tenant)
        
        # Apply filters
        if role:
            users = [u for u in users if u.get("role") == role]
        
        if status:
            users = [u for u in users if u.get("status") == status]
        
        if search:
            search_lower = search.lower()
            users = [u for u in users if 
                    search_lower in u.get("name", "").lower() or
                    search_lower in u.get("phone", "")]
        
        logger.info(
            f"Retrieved {len(users)} users for tenant {target_tenant}, requested by user {current_user.get('id')}"
        )
        
        return users
    
    async def update_user(
        self, 
        user_id: str, 
        user_data: UserUpdate, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Update user data with approval workflow.
        
        Args:
            user_id: User ID to update
            user_data: Updated user data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Updated user data or approval request status
            
        Raises:
            UserNotFoundError: If user not found
            InsufficientPermissionsError: If user lacks permission
            ApprovalRequiredError: If approval is required
        """
        # Check permissions - users can only update their own profile or if they have admin role
        if (current_user.get("id") != user_id and 
            current_user.get("role") not in ["client_admin", "superadmin"]):
            raise InsufficientPermissionsError(
                message="Insufficient permissions to update this user"
            )
        
        # Enforce tenant isolation
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only update users from your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if user exists
        existing_user = await data_layer.get_user_by_id(user_id, tenant_id)
        if not existing_user:
            raise UserNotFoundError(
                message=f"User with ID {user_id} not found"
            )
        
        # If superadmin is updating, no approval needed
        if current_user.get("role") == "superadmin":
            # Call Data Layer to update user
            updated_user = await data_layer.update_user(user_id, user_data, tenant_id, current_user.get("id"))
            
            logger.info(
                f"User updated successfully by superadmin: user {user_id}, updated by {current_user.get('id')}"
            )
            
            return {
                "status": "completed",
                "message": "Profile updated successfully",
                "request_id": None,
                "approval_required": False,
                "user": updated_user
            }
        
        # If client_admin is updating another user, no approval needed
        if (current_user.get("role") == "client_admin" and 
            str(current_user.get("id")) != str(user_id)):
            # Call Data Layer to update user
            updated_user = await data_layer.update_user(user_id, user_data, tenant_id, current_user.get("id"))
            
            logger.info(
                f"User updated successfully by admin: user {user_id}, updated by {current_user.get('id')}"
            )
            
            return {
                "status": "completed",
                "message": "Profile updated successfully",
                "request_id": None,
                "approval_required": False,
                "user": updated_user
            }
        
        # For sales_executive and area_manager, approval is required
        if current_user.get("role") in ["sales_executive", "area_manager"]:
            # Create approval request instead of direct update
            approval_service = await self._get_approval_service()
            approval_request = await approval_service.create_profile_update_request(
                user_id, user_data, current_user, tenant_id
            )
            
            logger.info(
                f"Profile update approval request created: user {user_id}, requested by {current_user.get('id')}"
            )
            
            return {
                "status": "pending_approval",
                "message": "Profile update request submitted for approval",
                "request_id": approval_request.get("id"),
                "approval_required": True,
                "user": None
            }
        
        # For self-updates, approval is required
        if str(current_user.get("id")) == str(user_id):
            approval_service = await get_approval_service()
            
            # Convert UserUpdate to dict safely
            update_dict = {}
            if user_data.name is not None:
                update_dict["name"] = user_data.name
            if user_data.email is not None:
                update_dict["email"] = user_data.email
            if user_data.role is not None:
                update_dict["role"] = user_data.role
            if user_data.status is not None:
                update_dict["status"] = user_data.status
            
            # Create approval request
            approval_request = await approval_service.create_profile_update_request(
                user_id, update_dict, current_user
            )
            
            if approval_request.get("status") == "auto_approved":
                # Superadmin updates are auto-approved
                # TODO: Implement actual update in Data Layer
                updated_user = {**existing_user}
                
                # Update fields if provided
                if user_data.name is not None:
                    updated_user["name"] = user_data.name
                if user_data.email is not None:
                    updated_user["email"] = user_data.email
                
                updated_user["updated_at"] = datetime.utcnow().isoformat()
                updated_user["updated_by"] = current_user.get("id")
                
                logger.info(
                    f"User profile auto-updated (superadmin): user {user_id}, updated by {current_user.get('id')}"
                )
                
                return {
                    "status": "completed",
                    "message": "Profile updated successfully",
                    "request_id": None,
                    "approval_required": False,
                    "user": updated_user
                }
            else:
                # Approval request created
                logger.info(
                    f"Profile update request created, waiting for approval for user {user_id}, status: {approval_request.get('status')}"
                )
                
                return {
                    "status": "pending_approval",
                    "message": "Profile update request submitted and pending approval",
                    "request_id": approval_request.get("id"),
                    "approval_required": True,
                    "user": None
                }
        
        # This should not happen, but just in case
        raise InsufficientPermissionsError(
            message="Insufficient permissions to update this user"
        )
    
    async def delete_user(self, user_id: str, tenant_id: str, current_user: Dict[str, Any]) -> bool:
        """
        Delete user (soft delete by setting status to inactive).
        
        Args:
            user_id: User ID to delete
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            True if successful
            
        Raises:
            UserNotFoundError: If user not found
            InsufficientPermissionsError: If user lacks permission
        """
        # Check permissions - only client_admin and superadmin can delete users
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to delete users"
            )
        
        # Enforce tenant isolation
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only delete users from your own tenant"
            )
        
        # Prevent self-deletion
        if current_user.get("id") == user_id:
            raise InvalidUserDataError(
                message="Cannot delete your own account"
            )
        
        data_layer = await self._get_data_layer()
        
        # Check if user exists
        existing_user = await data_layer.get_user_by_id(user_id, tenant_id)
        if not existing_user:
            raise UserNotFoundError(
                message=f"User with ID {user_id} not found"
            )
        
        # Soft delete by setting status to inactive
        result = await data_layer.delete_user(user_id, tenant_id)
        
        logger.info(
            f"User soft deleted successfully: user {user_id} deleted by {current_user.get('id')}"
        )
        
        return result
    
    async def get_user_profile(self, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Get current user's profile.
        
        Args:
            current_user: Current authenticated user
            
        Returns:
            User profile data
        """
        return current_user
    
    async def update_user_profile(
        self, 
        user_data: UserUpdate, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Update current user's profile with approval workflow.
        
        Args:
            user_data: Updated profile data
            current_user: Current authenticated user
            
        Returns:
            Updated profile data or approval request status
        """
        # Users can only update certain fields in their profile
        allowed_fields = ["name", "email"]
        
        # Filter out non-allowed fields
        filtered_data = UserUpdate(
            name=user_data.name if user_data.name is not None else current_user.get("name"),
            email=user_data.email if user_data.email is not None else current_user.get("email")
        )
        
        # Use the main update_user method which handles approvals
        return await self.update_user(
            current_user.get("id"),
            filtered_data,
            current_user.get("tenant_id"),
            current_user
        )


# Global instance
user_service = UserService()


async def get_user_service() -> UserService:
    """Get the global user service instance."""
    return user_service
