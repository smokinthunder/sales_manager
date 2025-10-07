"""
Notification domain model.

Represents notifications for profile updates and customer creation approvals.
"""

from datetime import datetime
from typing import Optional, Dict, Any, TYPE_CHECKING
from enum import Enum
from sqlalchemy import String, Integer, Boolean, JSON, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel

if TYPE_CHECKING:
    from .user import User


class NotificationType(str, Enum):
    """Types of notifications in the system."""
    PROFILE_UPDATE = "profile_update"
    CUSTOMER_CREATION = "customer_creation"


class Notification(BaseEntity):
    """Notification entity model."""
    
    __tablename__ = "notifications"
    
    sender_id: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    receiver_id: Mapped[int] = mapped_column(Integer, nullable=False, index=True)
    subject: Mapped[str] = mapped_column(String(255), nullable=False)
    notification_type: Mapped[NotificationType] = mapped_column(
        SQLEnum(NotificationType), 
        nullable=False,
        index=True
    )
    related_data: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    is_confirmed: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    sender: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="Notification.sender_id",
        lazy="selectin"
    )
    receiver: Mapped[Optional["User"]] = relationship(
        "User", 
        foreign_keys="Notification.receiver_id",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="Notification.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="Notification.updated_by", 
        lazy="selectin"
    )


# Pydantic models for API
class NotificationBase(BasePydanticModel):
    """Base notification model with common fields."""
    
    sender_id: int = Field(..., description="ID of the user who sent the notification")
    receiver_id: int = Field(..., description="ID of the user who should receive the notification")
    subject: str = Field(..., description="Subject/description of the notification")
    notification_type: NotificationType = Field(..., description="Type of notification")
    related_data: Optional[Dict[str, Any]] = Field(None, description="Related data for the notification")
    is_confirmed: bool = Field(default=False, description="Whether the notification has been confirmed")


class NotificationCreate(NotificationBase):
    """Model for creating new notifications."""
    pass


class NotificationUpdate(BasePydanticModel):
    """Model for updating existing notifications."""
    
    subject: Optional[str] = Field(None, description="Subject/description of the notification")
    is_confirmed: Optional[bool] = Field(None, description="Whether the notification has been confirmed")
    related_data: Optional[Dict[str, Any]] = Field(None, description="Related data for the notification")


class NotificationRead(NotificationBase):
    """Model for reading notification data."""
    
    id: int = Field(..., description="Database ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")
    created_by: Optional[int] = Field(None, description="User who created the notification")
    updated_by: Optional[int] = Field(None, description="User who last updated the notification")
    
    # Optional sender and receiver details for API responses
    sender_name: Optional[str] = Field(None, description="Name of the sender")
    receiver_name: Optional[str] = Field(None, description="Name of the receiver")


class NotificationConfirm(BasePydanticModel):
    """Model for confirming notifications."""
    
    action: str = Field(..., description="Action to take: 'approve' or 'reject'")
    remarks: Optional[str] = Field(None, description="Optional remarks for the action")