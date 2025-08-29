"""
Approval Service for User Profile Updates

Handles the approval workflow where profile updates need to be approved
by higher authorities based on role hierarchy.
"""

import logging
from typing import Dict, Any, Optional, List
from datetime import datetime
from app.core.errors import (
    InsufficientPermissionsError,
    InvalidApproverError,
    ApprovalRequiredError
)
from app.services.data_layer_client import get_data_layer_client

logger = logging.getLogger(__name__)


class ApprovalService:
    """Service for managing approval workflows."""
    
    def __init__(self):
        self.data_layer = None
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    def _get_approval_hierarchy(self, user_role: str) -> List[str]:
        """
        Get the approval hierarchy for a user role.
        
        Args:
            user_role: Role of the user requesting update
            
        Returns:
            List of roles that can approve updates for this user
        """
        hierarchy = {
            "sales_executive": ["area_manager", "client_admin", "superadmin"],
            "area_manager": ["client_admin", "superadmin"],
            "client_admin": ["superadmin"],
            "superadmin": []  # Superadmin doesn't need approval
        }
        return hierarchy.get(user_role, [])
    
    def _can_approve(self, approver_role: str, user_role: str) -> bool:
        """
        Check if an approver can approve updates for a user.
        
        Args:
            approver_role: Role of the person trying to approve
            user_role: Role of the user being updated
            
        Returns:
            True if approver can approve, False otherwise
        """
        if approver_role == "superadmin":
            return True
        
        approval_hierarchy = self._get_approval_hierarchy(user_role)
        return approver_role in approval_hierarchy
    
    async def create_profile_update_request(
        self,
        user_id: str,
        update_data: Dict[str, Any],
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Create a profile update request that requires approval.
        
        Args:
            user_id: ID of the user requesting update
            update_data: Data to be updated
            current_user: Current authenticated user
            
        Returns:
            Created update request data
        """
        # Check if user is updating their own profile
        if str(current_user.get("id")) != str(user_id):
            raise InsufficientPermissionsError(
                message="Users can only request updates for their own profile"
            )
        
        # Superadmin doesn't need approval
        if current_user.get("role") == "superadmin":
            return {
                "status": "auto_approved",
                "message": "Superadmin updates are auto-approved"
            }
        
        # Create approval request
        request_data = {
            "user_id": user_id,
            "requested_by": current_user.get("id"),
            "update_data": update_data,
            "status": "pending",
            "created_at": datetime.utcnow().isoformat(),
            "tenant_id": current_user.get("tenant_id")
        }
        
        # TODO: Store approval request in Data Layer
        # For now, return the request data
        logger.info(
            f"Profile update request created for user {user_id} by {current_user.get('id')} with role {current_user.get('role')}"
        )
        
        return request_data
    
    async def approve_profile_update(
        self,
        request_id: str,
        approver: Dict[str, Any],
        tenant_id: str
    ) -> Dict[str, Any]:
        """
        Approve a profile update request.
        
        Args:
            request_id: ID of the update request
            approver: User approving the request
            tenant_id: Tenant identifier
            
        Returns:
            Approval result
        """
        # TODO: Get actual request from Data Layer
        # For now, simulate the request
        request = {
            "id": request_id,
            "user_id": "123",
            "requested_by": "456",
            "update_data": {"name": "New Name"},
            "status": "pending",
            "tenant_id": tenant_id
        }
        
        # Get the user being updated
        data_layer = await self._get_data_layer()
        user = await data_layer.get_user_by_id(request["user_id"], tenant_id)
        if not user:
            raise InsufficientPermissionsError(
                message="User not found"
            )
        
        # Check if approver can approve this request
        if not self._can_approve(approver.get("role"), user.get("role")):
            raise InvalidApproverError(
                message=f"{approver.get('role')} cannot approve updates for {user.get('role')}"
            )
        
        # Approve the request
        # TODO: Update request status in Data Layer
        # TODO: Apply the actual update to user profile
        
        logger.info(
            f"Profile update approved for request {request_id} by approver {approver.get('id')} with role {approver.get('role')} for user {user.get('id')}"
        )
        
        return {
            "status": "approved",
            "message": "Profile update approved successfully",
            "approved_by": approver.get("id"),
            "approved_at": datetime.utcnow().isoformat()
        }
    
    async def reject_profile_update(
        self,
        request_id: str,
        approver: Dict[str, Any],
        reason: str,
        tenant_id: str
    ) -> Dict[str, Any]:
        """
        Reject a profile update request.
        
        Args:
            request_id: ID of the update request
            approver: User rejecting the request
            reason: Reason for rejection
            tenant_id: Tenant identifier
            
        Returns:
            Rejection result
        """
        # TODO: Get actual request from Data Layer
        # For now, simulate the request
        request = {
            "id": request_id,
            "user_id": "123",
            "requested_by": "456",
            "update_data": {"name": "New Name"},
            "status": "pending",
            "tenant_id": tenant_id
        }
        
        # Get the user being updated
        data_layer = await self._get_data_layer()
        user = await data_layer.get_user_by_id(request["user_id"], tenant_id)
        if not user:
            raise InsufficientPermissionsError(
                message="User not found"
            )
        
        # Check if approver can reject this request
        if not self._can_approve(approver.get("role"), user.get("role")):
            raise InvalidApproverError(
                message=f"{approver.get('role')} cannot reject updates for {user.get('role')}"
            )
        
        # Reject the request
        # TODO: Update request status in Data Layer
        
        logger.info(
            f"Profile update rejected for request {request_id} by approver {approver.get('id')} with role {approver.get('role')} for user {user.get('id')}, reason: {reason}"
        )
        
        return {
            "status": "rejected",
            "message": "Profile update rejected",
            "rejected_by": approver.get("id"),
            "rejected_at": datetime.utcnow().isoformat(),
            "reason": reason
        }
    
    async def get_pending_approvals(
        self,
        approver: Dict[str, Any],
        tenant_id: str
    ) -> List[Dict[str, Any]]:
        """
        Get pending approval requests for an approver.
        
        Args:
            approver: User requesting pending approvals
            tenant_id: Tenant identifier
            
        Returns:
            List of pending approval requests
        """
        # TODO: Get actual pending requests from Data Layer
        # For now, return empty list
        return []
    
    async def get_user_approval_history(
        self,
        user_id: str,
        current_user: Dict[str, Any],
        tenant_id: str
    ) -> List[Dict[str, Any]]:
        """
        Get approval history for a user.
        
        Args:
            user_id: ID of the user
            current_user: Current authenticated user
            tenant_id: Tenant identifier
            
        Returns:
            List of approval history
        """
        # Check permissions - users can only see their own history or if they have admin role
        if (str(current_user.get("id")) != str(user_id) and 
            current_user.get("role") not in ["client_admin", "superadmin", "area_manager"]):
            raise InsufficientPermissionsError(
                message="Insufficient permissions to view approval history"
            )
        
        # TODO: Get actual approval history from Data Layer
        # For now, return empty list
        return []


# Global instance
approval_service = ApprovalService()


async def get_approval_service() -> ApprovalService:
    """Get the global approval service instance."""
    return approval_service
