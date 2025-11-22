"""
Notification Service Layer

Handles all notification-related business logic including creation, 
retrieval, and confirmation of profile update and customer creation notifications.
"""

import logging
from typing import List, Optional, Dict, Any
from datetime import datetime
from fastapi import HTTPException, status
from app.core.errors import (
    NotificationNotFoundError,
    InsufficientPermissionsError,
    InvalidNotificationDataError
)
from app.services.data_layer_client import get_data_layer_client
from app.domain.models.notification import (
    NotificationCreate, NotificationUpdate, NotificationRead, 
    NotificationConfirm, NotificationType
)
from app.domain.models.user import UserRole

logger = logging.getLogger(__name__)


class NotificationService:
    """Service for managing notifications."""
    
    def __init__(self):
        self.data_layer = None
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    def _get_notification_receivers(self, sender_role: str, tenant_id: str) -> List[str]:
        """
        Get the list of user roles that should receive notifications from the sender.
        
        Args:
            sender_role: Role of the user sending the notification
            tenant_id: Tenant identifier
            
        Returns:
            List of user roles that should receive the notification
        """
        # Sales executives need approval from area managers
        if sender_role == UserRole.SALES_EXECUTIVE:
            return [UserRole.AREA_MANAGER, UserRole.CLIENT_ADMIN, UserRole.SUPERADMIN]
        
        # Area managers, client admins, and superadmins don't need approval
        return []
    
    async def _find_notification_receivers(self, sender_user: Dict[str, Any], tenant_id: str) -> List[Dict[str, Any]]:
        """
        Find actual users who should receive the notification.
        
        Args:
            sender_user: User sending the notification
            tenant_id: Tenant identifier
            
        Returns:
            List of users who should receive the notification
        """
        sender_role = sender_user.get("role")
        receiver_roles = self._get_notification_receivers(sender_role, tenant_id)
        
        if not receiver_roles:
            return []
        
        data_layer = await self._get_data_layer()
        
        # For sales executives, find area managers in the same territory first
        if sender_role == UserRole.SALES_EXECUTIVE and sender_user.get("territory_id"):
            # Try to find area managers in the same territory
            try:
                users = await data_layer.get_users(tenant_id)
                
                # First priority: Area managers in the same territory
                territory_managers = [
                    user for user in users 
                    if user.get("role") == UserRole.AREA_MANAGER 
                    and user.get("territory_id") == sender_user.get("territory_id")
                    and user.get("status") == "active"
                ]
                
                if territory_managers:
                    return territory_managers[:1]  # Return the first active area manager
                
                # Fallback: Any area manager in the tenant
                any_managers = [
                    user for user in users 
                    if user.get("role") == UserRole.AREA_MANAGER 
                    and user.get("status") == "active"
                ]
                
                if any_managers:
                    return any_managers[:1]  # Return the first active area manager
                
                # Final fallback: Client admin
                client_admins = [
                    user for user in users 
                    if user.get("role") == UserRole.CLIENT_ADMIN 
                    and user.get("status") == "active"
                ]
                
                if client_admins:
                    return client_admins[:1]  # Return the first active client admin
                
            except Exception as e:
                logger.error(f"Error finding notification receivers: {e}")
        
        return []
    
    async def create_profile_update_notification(
        self,
        user_id: int,
        update_data: Dict[str, Any],
        current_user: Dict[str, Any],
        tenant_id: str
    ) -> Optional[Dict[str, Any]]:
        """
        Create a notification for profile update approval.
        
        Args:
            user_id: ID of the user requesting profile update
            update_data: Data to be updated
            current_user: Current authenticated user
            tenant_id: Tenant identifier
            
        Returns:
            Created notification data or None if no approval needed
        """
        # Check if approval is needed
        user_role = current_user.get("role")
        
        # Area managers, client admins, and superadmins don't need approval
        if user_role in [UserRole.AREA_MANAGER, UserRole.CLIENT_ADMIN, UserRole.SUPERADMIN]:
            return None
        
        # Only sales executives need approval for profile updates
        if user_role != UserRole.SALES_EXECUTIVE:
            return None
        
        # Find notification receivers
        receivers = await self._find_notification_receivers(current_user, tenant_id)
        
        if not receivers:
            raise InvalidNotificationDataError(
                message="No appropriate managers found to approve the profile update"
            )
        
        receiver = receivers[0]  # Use the first available receiver
        
        # Create notification
        notification_data = NotificationCreate(
            sender_id=current_user.get("id"),
            receiver_id=receiver.get("id"),
            subject=f"Profile Update Request from {current_user.get('name')}",
            notification_type=NotificationType.PROFILE_UPDATE,
            related_data={
                "user_id": user_id,
                "update_data": update_data,
                "sender_name": current_user.get("name"),
                "sender_role": current_user.get("role")
            },
            is_confirmed=False
        )
        
        data_layer = await self._get_data_layer()
        try:
            response = await data_layer.post(
                f"/api/notifications/{tenant_id}",
                json=notification_data.model_dump()
            )
            return response
        except Exception as e:
            logger.error(f"Error creating profile update notification: {e}")
            raise InvalidNotificationDataError(
                message=f"Failed to create notification: {str(e)}"
            )
    
    async def create_customer_creation_notification(
        self,
        shop_data: Dict[str, Any],
        current_user: Dict[str, Any],
        tenant_id: str
    ) -> Optional[Dict[str, Any]]:
        """
        Create a notification for customer creation approval.
        
        Args:
            shop_data: Shop data to be created
            current_user: Current authenticated user
            tenant_id: Tenant identifier
            
        Returns:
            Created notification data or None if no approval needed
        """
        # Check if approval is needed
        user_role = current_user.get("role")
        
        # Area managers, client admins, and superadmins don't need approval
        if user_role in [UserRole.AREA_MANAGER, UserRole.CLIENT_ADMIN, UserRole.SUPERADMIN]:
            return None
        
        # Only sales executives need approval for customer creation
        if user_role != UserRole.SALES_EXECUTIVE:
            return None
        
        # Find notification receivers
        receivers = await self._find_notification_receivers(current_user, tenant_id)
        
        if not receivers:
            raise InvalidNotificationDataError(
                message="No appropriate managers found to approve the customer creation"
            )
        
        receiver = receivers[0]  # Use the first available receiver
        
        # Create notification
        notification_data = NotificationCreate(
            sender_id=current_user.get("id"),
            receiver_id=receiver.get("id"),
            subject=f"New Customer Creation Request from {current_user.get('name')}",
            notification_type=NotificationType.CUSTOMER_CREATION,
            related_data={
                "shop_data": shop_data,
                "sender_name": current_user.get("name"),
                "sender_role": current_user.get("role")
            },
            is_confirmed=False
        )
        
        data_layer = await self._get_data_layer()
        try:
            response = await data_layer.post(
                f"/api/notifications/{tenant_id}",
                json=notification_data.model_dump()
            )
            return response
        except Exception as e:
            logger.error(f"Error creating customer creation notification: {e}")
            raise InvalidNotificationDataError(
                message=f"Failed to create notification: {str(e)}"
            )
    
    async def get_notifications(
        self,
        tenant_id: str,
        current_user: Dict[str, Any],
        notification_type: Optional[str] = None,
        is_confirmed: Optional[bool] = None
    ) -> List[Dict[str, Any]]:
        """
        Get notifications for the current user.
        
        Args:
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            notification_type: Optional filter by notification type
            is_confirmed: Optional filter by confirmation status
            
        Returns:
            List of notifications
        """
        data_layer = await self._get_data_layer()
        
        try:
            # Use the specific get_notifications method
            response = await data_layer.get_notifications(
                tenant_id=tenant_id,
                receiver_id=current_user.get("id"),
                notification_type=notification_type,
                is_confirmed=is_confirmed
            )
            
            return response if isinstance(response, list) else response.get("data", [])
        
        except Exception as e:
            logger.error(f"Error getting notifications: {e}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to retrieve notifications: {str(e)}"
            )
    
    async def get_notification(
        self,
        notification_id: str,
        tenant_id: str,
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Get a specific notification.
        
        Args:
            notification_id: Notification identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Notification data
        """
        data_layer = await self._get_data_layer()
        
        try:
            notification = await data_layer.get_notification(tenant_id, notification_id)
            
            if not notification:
                raise NotificationNotFoundError(message="Notification not found")
            
            # Check if user has permission to view this notification
            if (notification.get("receiver_id") != current_user.get("id") and 
                notification.get("sender_id") != current_user.get("id")):
                raise InsufficientPermissionsError(
                    message="You don't have permission to view this notification"
                )
            
            return notification
        
        except HTTPException:
            raise
        except Exception as e:
            logger.error(f"Error getting notification: {e}")
            if "404" in str(e):
                raise NotificationNotFoundError(message="Notification not found")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to retrieve notification: {str(e)}"
            )
    
    async def confirm_notification(
        self,
        notification_id: str,
        confirmation_data: NotificationConfirm,
        tenant_id: str,
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Confirm/approve a notification and execute the related action.
        
        Args:
            notification_id: Notification identifier
            confirmation_data: Confirmation data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Result of the confirmation action
        """
        # Get the notification
        notification = await self.get_notification(notification_id, tenant_id, current_user)
        
        # Check if user can confirm this notification
        current_user_id = current_user.get("id")
        receiver_id = notification.get("receiver_id")
        
        # Convert both to int for comparison since database stores as int
        try:
            current_user_id_int = int(current_user_id)
            receiver_id_int = int(receiver_id) if receiver_id else None
        except (ValueError, TypeError):
            raise InsufficientPermissionsError(
                message="Invalid user ID format"
            )
        
        if receiver_id_int != current_user_id_int:
            raise InsufficientPermissionsError(
                message="You don't have permission to confirm this notification"
            )
        
        # Check if already confirmed
        if notification.get("is_confirmed"):
            raise InvalidNotificationDataError(
                message="Notification has already been confirmed"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # Mark notification as confirmed
            update_data = NotificationUpdate(
                is_confirmed=True,
                updated_by=current_user.get("id")
            )
            
            await data_layer.put(
                f"/api/notifications/{tenant_id}/{notification_id}",
                json=update_data.model_dump(exclude_unset=True)
            )
            
            # Execute the related action if approved
            if confirmation_data.action == "approve":
                result = await self._execute_notification_action(
                    notification, tenant_id, current_user
                )
                return {
                    "status": "approved",
                    "message": "Notification approved and action executed successfully",
                    "action_result": result
                }
            else:
                return {
                    "status": "rejected",
                    "message": "Notification has been rejected",
                    "remarks": confirmation_data.remarks
                }
        
        except Exception as e:
            logger.error(f"Error confirming notification: {e}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to confirm notification: {str(e)}"
            )
    
    async def _execute_notification_action(
        self,
        notification: Dict[str, Any],
        tenant_id: str,
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Execute the action associated with a notification.
        
        Args:
            notification: Notification data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Result of the action execution
        """
        notification_type = notification.get("notification_type")
        related_data = notification.get("related_data", {})
        
        data_layer = await self._get_data_layer()
        
        if notification_type == NotificationType.PROFILE_UPDATE:
            # Execute profile update
            user_id = related_data.get("user_id")
            update_data = related_data.get("update_data")
            
            if not user_id or not update_data:
                raise InvalidNotificationDataError(
                    message="Invalid profile update data in notification"
                )
            
            # Add audit information
            update_data["updated_by"] = current_user.get("id")
            
            response = await data_layer.put(
                f"/api/users/{tenant_id}/{user_id}",
                json=update_data
            )
            
            return {
                "type": "profile_update",
                "user_id": user_id,
                "updated_data": update_data,
                "result": response
            }
        
        elif notification_type == NotificationType.CUSTOMER_CREATION:
            # Execute customer creation
            shop_data = related_data.get("shop_data")
            
            if not shop_data:
                raise InvalidNotificationDataError(
                    message="Invalid customer creation data in notification"
                )
            
            # Add audit information
            shop_data["created_by"] = current_user.get("id")
            shop_data["updated_by"] = current_user.get("id")
            shop_data["created_at"] = datetime.now().isoformat()
            shop_data["updated_at"] = datetime.now().isoformat()
            
            response = await data_layer.post(
                f"/api/shops/{tenant_id}",
                json=shop_data
            )
            
            return {
                "type": "customer_creation",
                "shop_data": shop_data,
                "result": response
            }
        
        else:
            raise InvalidNotificationDataError(
                message=f"Unknown notification type: {notification_type}"
            )


# Service instance
_notification_service = None


async def get_notification_service() -> NotificationService:
    """Get the notification service instance."""
    global _notification_service
    if _notification_service is None:
        _notification_service = NotificationService()
    return _notification_service