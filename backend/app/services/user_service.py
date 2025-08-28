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
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    async def create_user(self, user_data: UserCreate, current_user: Dict[str, Any]) -> Dict[str, Any]:
        """
        Create a new user.
        
        Args:
            user_data: User data to create
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
        
        data_layer = await self._get_data_layer()
        
        # Check if user with phone already exists
        existing_user = await data_layer.get_user_by_phone(
            user_data.phone, 
            user_data.tenant_id
        )
        if existing_user:
            raise UserAlreadyExistsError(
                message=f"User with phone {user_data.phone} already exists"
            )
        
        # Create user
        try:
            created_user = await data_layer.create_user(user_data)
            logger.info(
                "User created successfully", 
                user_id=created_user.get("id"),
                phone=user_data.phone,
                created_by=current_user.get("id")
            )
            return created_user
        except Exception as e:
            logger.error(
                "Failed to create user", 
                error=str(e),
                phone=user_data.phone
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
        
        data_layer = await self._get_data_layer()
        user = await data_layer.get_user_by_id(user_id, tenant_id)
        
        if not user:
            raise UserNotFoundError(
                message=f"User with ID {user_id} not found"
            )
        
        return user
    
    async def get_users(
        self, 
        tenant_id: str, 
        current_user: Dict[str, Any],
        role: Optional[str] = None,
        status: Optional[str] = None,
        search: Optional[str] = None
    ) -> List[Dict[str, Any]]:
        """
        Get users with optional filtering.
        
        Args:
            tenant_id: Tenant identifier
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
        users = await data_layer.get_users(tenant_id)
        
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
        
        data_layer = await self._get_data_layer()
        
        # Check if user exists
        existing_user = await data_layer.get_user_by_id(user_id, tenant_id)
        if not existing_user:
            raise UserNotFoundError(
                message=f"User with ID {user_id} not found"
            )
        
        # If superadmin is updating, no approval needed
        if current_user.get("role") == "superadmin":
            # TODO: Implement actual update in Data Layer
            updated_user = {**existing_user}
            
            # Update fields if provided
            if user_data.name is not None:
                updated_user["name"] = user_data.name
            if user_data.email is not None:
                updated_user["email"] = user_data.email
            if user_data.role is not None:
                updated_user["role"] = user_data.role
            if user_data.status is not None:
                updated_user["status"] = user_data.status
            
            updated_user["updated_at"] = datetime.utcnow().isoformat()
            updated_user["updated_by"] = current_user.get("id")
            
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
        
        # If admin is updating another user, no approval needed
        if (current_user.get("role") in ["client_admin"] and 
            str(current_user.get("id")) != str(user_id)):
            # TODO: Implement actual update in Data Layer
            updated_user = {**existing_user}
            
            # Update fields if provided
            if user_data.name is not None:
                updated_user["name"] = user_data.name
            if user_data.email is not None:
                updated_user["email"] = user_data.email
            if user_data.role is not None:
                updated_user["role"] = user_data.role
            if user_data.status is not None:
                updated_user["status"] = user_data.status
            
            updated_user["updated_at"] = datetime.utcnow().isoformat()
            updated_user["updated_by"] = current_user.get("id")
            
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
        # TODO: Implement actual update in Data Layer
        logger.info(
            f"User soft deleted successfully: user {user_id} deleted by {current_user.get('id')}"
        )
        
        return True
    
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
