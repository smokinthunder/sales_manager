"""
Approval domain model.

Represents workflow approvals for various entities.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Text, Enum as SQLEnum, DateTime
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class ApprovalType(str, Enum):
    """Approval type enumeration."""
    ORDER = "order"
    PAYMENT = "payment"
    USER = "user"
    SHOP = "shop"
    TERRITORY = "territory"
    OTHER = "other"


class ApprovalStatus(str, Enum):
    """Approval status enumeration."""
    PENDING = "pending"
    APPROVED = "approved"
    REJECTED = "rejected"
    CANCELLED = "cancelled"


class Approval(BaseEntity):
    """Approval entity model."""
    
    __tablename__ = "approvals"
    
    approval_type: Mapped[ApprovalType] = mapped_column(SQLEnum(ApprovalType), nullable=False)
    entity_type: Mapped[str] = mapped_column(String(50), nullable=False)
    entity_id: Mapped[int] = mapped_column(Integer, nullable=False)
    status: Mapped[ApprovalStatus] = mapped_column(SQLEnum(ApprovalStatus), default=ApprovalStatus.PENDING)
    requester_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False)
    approver_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    request_date: Mapped[datetime] = mapped_column(DateTime, nullable=False, default=datetime.utcnow)
    approval_date: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    comments: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    requester: Mapped["User"] = relationship(
        "User",
        back_populates="approval_requests",
        foreign_keys="Approval.requester_id",
        lazy="selectin"
    )
    approver: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="approval_decisions",
        foreign_keys="Approval.approver_id",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_approvals",
        foreign_keys="Approval.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_approvals",
        foreign_keys="Approval.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class ApprovalBase(BasePydanticModel):
    """Base approval model with common fields."""
    
    approval_type: ApprovalType = Field(..., description="Type of approval")
    entity_type: str = Field(..., description="Entity type being approved")
    entity_id: int = Field(..., description="Entity ID being approved")
    status: ApprovalStatus = Field(default=ApprovalStatus.PENDING, description="Approval status")
    requester_id: int = Field(..., description="User ID requesting approval")
    approver_id: Optional[int] = Field(None, description="User ID approving/rejecting")
    request_date: datetime = Field(default_factory=datetime.utcnow, description="Request date")
    approval_date: Optional[datetime] = Field(None, description="Approval date")
    comments: Optional[str] = Field(None, description="Approval comments")
    tenant_id: str = Field(..., description="Tenant identifier")


class ApprovalCreate(ApprovalBase):
    """Model for creating new approvals."""
    pass


class ApprovalUpdate(BasePydanticModel):
    """Model for updating existing approvals."""
    
    status: Optional[ApprovalStatus] = None
    approver_id: Optional[int] = None
    approval_date: Optional[datetime] = None
    comments: Optional[str] = None


class ApprovalRead(ApprovalBase):
    """Model for reading approval data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None


