"""
Notification API endpoints.

Handles HTTP requests for notification management including fetching
notifications and confirming approval requests.
"""

import logging
from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, Query, status, HTTPException
from app.api.deps import get_current_user, require_area_manager
from app.services.notification_service import get_notification_service
from app.domain.models.notification import (
    NotificationRead, NotificationConfirm, NotificationType
)

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get(
    "/",
    response_model=List[NotificationRead],
    summary="Get notifications for current user",
    tags=["Notification Management"]
)
async def get_notifications(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    notification_type: Optional[str] = Query(None, description="Filter by notification type"),
    is_confirmed: Optional[bool] = Query(None, description="Filter by confirmation status"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    notification_service = Depends(get_notification_service)
):
    """
    Get notifications for the current user.
    
    **Business Logic:**
    - Returns notifications where the current user is the receiver
    - Supports filtering by notification type and confirmation status
    - Only area managers and above can receive notifications
    
    **Query Parameters:**
    - tenant_id: Tenant identifier (required)
    - notification_type: Filter by type (profile_update, customer_creation)
    - is_confirmed: Filter by confirmation status (true/false)
    
    **Example Response:**
    ```json
    [
        {
            "id": 1,
            "sender_id": 123,
            "receiver_id": 456,
            "subject": "Profile Update Request from John Doe",
            "notification_type": "profile_update",
            "related_data": {
                "user_id": 123,
                "update_data": {"name": "John Smith"},
                "sender_name": "John Doe"
            },
            "is_confirmed": false,
            "tenant_id": "AQUASTAR",
            "created_at": "2025-10-07T10:30:00Z",
            "updated_at": "2025-10-07T10:30:00Z",
            "sender_name": "John Doe",
            "receiver_name": "Manager Name"
        }
    ]
    ```
    """
    try:
        return await notification_service.get_notifications(
            tenant_id=tenant_id,
            current_user=current_user,
            notification_type=notification_type,
            is_confirmed=is_confirmed
        )
    except Exception as e:
        logger.error(f"Error getting notifications: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve notifications: {str(e)}"
        )


@router.get(
    "/{notification_id}",
    response_model=NotificationRead,
    summary="Get specific notification",
    tags=["Notification Management"]
)
async def get_notification(
    notification_id: str,
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    notification_service = Depends(get_notification_service)
):
    """
    Get a specific notification by ID.
    
    **Business Logic:**
    - User can only view notifications they sent or received
    - Returns detailed notification information including related data
    
    **Path Parameters:**
    - notification_id: Notification identifier
    
    **Query Parameters:**
    - tenant_id: Tenant identifier (required)
    
    **Example Response:**
    ```json
    {
        "id": 1,
        "sender_id": 123,
        "receiver_id": 456,
        "subject": "Profile Update Request from John Doe",
        "notification_type": "profile_update",
        "related_data": {
            "user_id": 123,
            "update_data": {"name": "John Smith"},
            "sender_name": "John Doe"
        },
        "is_confirmed": false,
        "tenant_id": "AQUASTAR",
        "created_at": "2025-10-07T10:30:00Z",
        "updated_at": "2025-10-07T10:30:00Z",
        "sender_name": "John Doe",
        "receiver_name": "Manager Name"
    }
    ```
    """
    try:
        return await notification_service.get_notification(
            notification_id=notification_id,
            tenant_id=tenant_id,
            current_user=current_user
        )
    except Exception as e:
        logger.error(f"Error getting notification {notification_id}: {e}")
        if "not found" in str(e).lower():
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Notification not found"
            )
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to retrieve notification: {str(e)}"
        )


@router.post(
    "/{notification_id}/confirm",
    summary="Confirm/approve a notification",
    tags=["Notification Management"]
)
async def confirm_notification(
    notification_id: str,
    confirmation_data: NotificationConfirm,
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(require_area_manager),
    notification_service = Depends(get_notification_service)
):
    """
    Confirm/approve a notification and execute the related action.
    
    **Business Logic:**
    - Only area managers and above can confirm notifications
    - Approving executes the related action (profile update or customer creation)
    - Rejecting marks the notification as confirmed but doesn't execute action
    - Cannot confirm already confirmed notifications
    
    **Path Parameters:**
    - notification_id: Notification identifier
    
    **Request Body:**
    ```json
    {
        "action": "approve",  // or "reject"
        "remarks": "Optional remarks for the action"
    }
    ```
    
    **Query Parameters:**
    - tenant_id: Tenant identifier (required)
    
    **Example Response:**
    ```json
    {
        "status": "approved",
        "message": "Notification approved and action executed successfully",
        "action_result": {
            "type": "profile_update",
            "user_id": 123,
            "updated_data": {"name": "John Smith"},
            "result": {...}
        }
    }
    ```
    """
    try:
        return await notification_service.confirm_notification(
            notification_id=notification_id,
            confirmation_data=confirmation_data,
            tenant_id=tenant_id,
            current_user=current_user
        )
    except Exception as e:
        logger.error(f"Error confirming notification {notification_id}: {e}")
        if "not found" in str(e).lower():
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Notification not found"
            )
        elif "permission" in str(e).lower():
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to confirm this notification"
            )
        elif "already confirmed" in str(e).lower():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Notification has already been confirmed"
            )
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to confirm notification: {str(e)}"
        )