"""
User Management API endpoints.

Provides CRUD operations for users with proper authentication
and authorization checks.
"""

from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query
from app.api.deps import get_current_user, get_current_active_user
from app.core.errors import (
    UserNotFoundError, 
    UserAlreadyExistsError, 
    InvalidUserDataError,
    InsufficientPermissionsError,
    ProfileUpdatePendingApprovalError,
    ApprovalRequiredError,
    InvalidApproverError
)
from app.services.user_service import get_user_service, UserService
from app.services.approval_service import get_approval_service, ApprovalService
from app.domain.models.user import UserCreate, UserUpdate, UserRead, ProfileUpdateResponse
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post("/", response_model=UserRead, status_code=status.HTTP_201_CREATED)
async def create_user(
    user_data: UserCreate,
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Create a new user.
    
    Only client_admin and superadmin users can create new users.
    tenant_id is mandatory and enforced for tenant isolation.
    """
    try:
        created_user = await user_service.create_user(user_data, tenant_id, current_user)
        return created_user
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except UserAlreadyExistsError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=e.message
        )
    except InvalidUserDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/", response_model=List[UserRead])
async def get_users(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    role: Optional[str] = Query(None, description="Filter by user role"),
    user_status: Optional[str] = Query(None, description="Filter by user status"),
    search: Optional[str] = Query(None, description="Search by name or phone"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Get users with optional filtering.
    
    Only admin roles (client_admin, superadmin, area_manager) can list users.
    tenant_id is mandatory for all users.
    """
    try:
        users = await user_service.get_users(
            tenant_id, 
            current_user, 
            role=role, 
            status=user_status, 
            search=search
        )
        return users
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/{user_id}", response_model=UserRead)
async def get_user(
    user_id: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Get user by ID.
    
    Users can view their own profile or admin roles can view any user.
    """
    try:
        user = await user_service.get_user(user_id, tenant_id, current_user)
        return user
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.put("/{user_id}", response_model=ProfileUpdateResponse)
async def update_user(
    user_id: str,
    user_data: UserUpdate,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Update user data.
    
    Users can update their own profile or admin roles can update any user.
    """
    try:
        updated_user = await user_service.update_user(
            user_id, user_data, tenant_id, current_user
        )
        return updated_user
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidUserDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.delete("/{user_id}", status_code=204)
async def delete_user(
    user_id: int = Path(..., description="User ID to delete"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Delete a user (hard delete - completely removes from database).
    
    **Delete Behavior:**
    - User is completely removed from the database
    - Cannot delete users who have created routes or territories
    - This action cannot be undone
    
    **Security:**
    - Requires authentication
    - Only client_admin and superadmin can delete users
    - Users can only delete users from their assigned tenant
    """
    try:
        result = await user_service.delete_user(user_id, tenant_id, current_user)
        return result
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidUserDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/profile/me", response_model=UserRead)
async def get_user_profile(
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Get current user's profile.
    """
    return await user_service.get_user_profile(current_user)


@router.put("/profile/me", response_model=ProfileUpdateResponse)
async def update_user_profile(
    user_data: UserUpdate,
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Update current user's profile.
    
    Users can only update certain fields in their own profile.
    """
    try:
        updated_profile = await user_service.update_user_profile(user_data, current_user)
        return updated_profile
    except InvalidUserDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get("/by-phone/{phone}", response_model=UserRead)
async def get_user_by_phone(
    phone: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Get user by phone number.
    
    Only admin roles can search users by phone.
    """
    try:
        # This endpoint requires admin permissions
        if current_user.get("role") not in ["client_admin", "superadmin", "area_manager"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to search users by phone"
            )
        
        user_service_instance = await get_user_service()
        data_layer = await user_service_instance._get_data_layer()
        user = await data_layer.get_user_by_phone(phone, tenant_id)
        
        if not user:
            raise UserNotFoundError(
                message=f"User with phone {phone} not found"
            )
        
        return user
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except UserNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )


@router.post("/bulk-status-update", status_code=status.HTTP_200_OK)
async def bulk_update_user_status(
    user_ids: List[str],
    new_status: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    user_service: UserService = Depends(get_user_service)
):
    """
    Bulk update user statuses.
    
    Only client_admin and superadmin users can perform bulk operations.
    """
    try:
        # Check permissions
        if current_user.get("role") not in ["client_admin", "superadmin"]:
            raise InsufficientPermissionsError(
                message="Insufficient permissions to perform bulk operations"
            )
        
        # Validate status
        valid_statuses = ["active", "inactive", "suspended"]
        if new_status not in valid_statuses:
            raise InvalidUserDataError(
                message=f"Invalid status. Must be one of: {', '.join(valid_statuses)}"
            )
        
        # Update each user
        updated_count = 0
        for user_id in user_ids:
            try:
                user_data = UserUpdate(status=new_status)
                await user_service.update_user(
                    user_id, user_data, tenant_id, current_user
                )
                updated_count += 1
            except Exception as e:
                # Log error but continue with other users
                logger.warning(f"Failed to update user {user_id}: {str(e)}")
        
        return {
            "message": f"Successfully updated {updated_count} out of {len(user_ids)} users",
            "updated_count": updated_count,
            "total_count": len(user_ids)
        }
        
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidUserDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


# Approval Workflow Endpoints
@router.get("/approvals/pending", status_code=status.HTTP_200_OK)
async def get_pending_approvals(
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    approval_service: ApprovalService = Depends(get_approval_service)
):
    """
    Get pending approval requests for the current user.
    
    Only users with approval permissions can see pending requests.
    """
    try:
        pending_approvals = await approval_service.get_pending_approvals(
            current_user, tenant_id
        )
        return {
            "pending_approvals": pending_approvals,
            "count": len(pending_approvals)
        }
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.post("/approvals/{request_id}/approve", status_code=status.HTTP_200_OK)
async def approve_profile_update(
    request_id: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    approval_service: ApprovalService = Depends(get_approval_service)
):
    """
    Approve a profile update request.
    
    Only authorized approvers can approve requests.
    """
    try:
        result = await approval_service.approve_profile_update(
            request_id, current_user, tenant_id
        )
        return result
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidApproverError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.post("/approvals/{request_id}/reject", status_code=status.HTTP_200_OK)
async def reject_profile_update(
    request_id: str,
    reason: str = Query(..., description="Reason for rejection"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    approval_service: ApprovalService = Depends(get_approval_service)
):
    """
    Reject a profile update request.
    
    Only authorized approvers can reject requests.
    """
    try:
        result = await approval_service.reject_profile_update(
            request_id, current_user, reason, tenant_id
        )
        return result
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidApproverError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get("/approvals/history/{user_id}", status_code=status.HTTP_200_OK)
async def get_user_approval_history(
    user_id: str,
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    approval_service: ApprovalService = Depends(get_approval_service)
):
    """
    Get approval history for a specific user.
    
    Users can see their own history or admins can see any user's history.
    """
    try:
        history = await approval_service.get_user_approval_history(
            user_id, current_user, tenant_id
        )
        return {
            "approval_history": history,
            "count": len(history)
        }
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
