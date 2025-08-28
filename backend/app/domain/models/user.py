"""
User domain model.

Represents users in the system with role-based access control
and multi-tenant support.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field, validator
from .base import Base, BaseEntity, BasePydanticModel


class UserRole(str, Enum):
    """User roles in the system."""
    SUPERADMIN = "superadmin"
    CLIENT_ADMIN = "client_admin"
    AREA_MANAGER = "area_manager"
    SALES_EXECUTIVE = "sales_executive"


class UserStatus(str, Enum):
    """User account status."""
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    PENDING_APPROVAL = "pending_approval"


class User(BaseEntity):
    """User entity model."""
    
    __tablename__ = "users"
    
    phone: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    email: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    role: Mapped[UserRole] = mapped_column(SQLEnum(UserRole), nullable=False)
    status: Mapped[UserStatus] = mapped_column(SQLEnum(UserStatus), default=UserStatus.PENDING_APPROVAL)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    created_users: Mapped[List["User"]] = relationship(
        "User",
        back_populates="creator",
        foreign_keys="User.created_by",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_users",
        foreign_keys="User.created_by",
        lazy="selectin"
    )
    updated_users: Mapped[List["User"]] = relationship(
        "User",
        back_populates="updater",
        foreign_keys="User.updated_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_users",
        foreign_keys="User.updated_by",
        lazy="selectin"
    )
    
    # Territory management
    managed_territories: Mapped[List["Territory"]] = relationship(
        "Territory",
        back_populates="area_manager",
        foreign_keys="Territory.area_manager_id",
        lazy="selectin"
    )
    
    # Route management
    assigned_routes: Mapped[List["Route"]] = relationship(
        "Route",
        back_populates="sales_executive",
        foreign_keys="Route.sales_executive_id",
        lazy="selectin"
    )
    
    # Visit tracking
    visits: Mapped[List["Visit"]] = relationship(
        "Visit",
        back_populates="sales_executive",
        foreign_keys="Visit.sales_executive_id",
        lazy="selectin"
    )
    
    # Created entities
    created_territories: Mapped[List["Territory"]] = relationship(
        "Territory",
        back_populates="creator",
        foreign_keys="Territory.created_by",
        lazy="selectin"
    )
    updated_territories: Mapped[List["Territory"]] = relationship(
        "Territory",
        back_populates="updater",
        foreign_keys="Territory.updated_by",
        lazy="selectin"
    )
    created_shops: Mapped[List["Shop"]] = relationship(
        "Shop",
        back_populates="creator",
        foreign_keys="Shop.created_by",
        lazy="selectin"
    )
    updated_shops: Mapped[List["Shop"]] = relationship(
        "Shop",
        back_populates="updater",
        foreign_keys="Shop.updated_by",
        lazy="selectin"
    )
    created_routes: Mapped[List["Route"]] = relationship(
        "Route",
        back_populates="creator",
        foreign_keys="Route.created_by",
        lazy="selectin"
    )
    updated_routes: Mapped[List["Route"]] = relationship(
        "Route",
        back_populates="updater",
        foreign_keys="Route.updated_by",
        lazy="selectin"
    )
    created_visits: Mapped[List["Visit"]] = relationship(
        "Visit",
        back_populates="creator",
        foreign_keys="Visit.created_by",
        lazy="selectin"
    )
    updated_visits: Mapped[List["Visit"]] = relationship(
        "Visit",
        back_populates="updater",
        foreign_keys="Visit.updated_by",
        lazy="selectin"
    )
    created_products: Mapped[List["Product"]] = relationship(
        "Product",
        back_populates="creator",
        foreign_keys="Product.created_by",
        lazy="selectin"
    )
    updated_products: Mapped[List["Product"]] = relationship(
        "Product",
        back_populates="updater",
        foreign_keys="Product.updated_by",
        lazy="selectin"
    )
    created_orders: Mapped[List["Order"]] = relationship(
        "Order",
        back_populates="creator",
        foreign_keys="Order.created_by",
        lazy="selectin"
    )
    updated_orders: Mapped[List["Order"]] = relationship(
        "Order",
        back_populates="updater",
        foreign_keys="Order.updated_by",
        lazy="selectin"
    )
    created_payments: Mapped[List["Payment"]] = relationship(
        "Payment",
        back_populates="creator",
        foreign_keys="Payment.created_by",
        lazy="selectin"
    )
    updated_payments: Mapped[List["Payment"]] = relationship(
        "Payment",
        back_populates="updater",
        foreign_keys="Payment.updated_by",
        lazy="selectin"
    )
    created_outstandings: Mapped[List["Outstanding"]] = relationship(
        "Outstanding",
        back_populates="creator",
        foreign_keys="Outstanding.created_by",
        lazy="selectin"
    )
    updated_outstandings: Mapped[List["Outstanding"]] = relationship(
        "Outstanding",
        back_populates="updater",
        foreign_keys="Outstanding.updated_by",
        lazy="selectin"
    )
    
    # Approval workflows
    approval_requests: Mapped[List["Approval"]] = relationship(
        "Approval",
        back_populates="requester",
        foreign_keys="Approval.requester_id",
        lazy="selectin"
    )
    approval_decisions: Mapped[List["Approval"]] = relationship(
        "Approval",
        back_populates="approver",
        foreign_keys="Approval.approver_id",
        lazy="selectin"
    )
    created_approvals: Mapped[List["Approval"]] = relationship(
        "Approval",
        back_populates="creator",
        foreign_keys="Approval.created_by",
        lazy="selectin"
    )
    updated_approvals: Mapped[List["Approval"]] = relationship(
        "Approval",
        back_populates="updater",
        foreign_keys="Approval.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class UserBase(BasePydanticModel):
    """Base user model with common fields."""
    
    phone: str = Field(..., description="Phone number as primary identifier")
    name: str = Field(..., description="Full name of the user")
    email: Optional[str] = Field(None, description="Email address")
    role: UserRole = Field(..., description="User role in the system")
    status: UserStatus = Field(default=UserStatus.PENDING_APPROVAL, description="Account status")
    tenant_id: str = Field(..., description="Tenant identifier for multi-tenancy")
    
    @validator("phone")
    def validate_phone(cls, v):
        """Validate phone number format."""
        if not v or len(v) < 10:
            raise ValueError("Phone number must be at least 10 digits")
        return v


class UserCreate(UserBase):
    """Model for creating new users."""
    pass


class UserUpdate(BasePydanticModel):
    """Model for updating existing users."""
    
    name: Optional[str] = None
    email: Optional[str] = None
    role: Optional[UserRole] = None
    status: Optional[UserStatus] = None


class UserRead(UserBase):
    """Model for reading user data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None


class UserLogin(BasePydanticModel):
    """Model for user login."""
    
    phone: str = Field(..., description="Phone number")
    otp: str = Field(..., description="One-time password")


class UserOTP(BasePydanticModel):
    """Model for OTP verification."""
    
    phone: str = Field(..., description="Phone number")
    otp: str = Field(..., description="One-time password")
    expires_at: datetime = Field(..., description="OTP expiration time")


class ProfileUpdateResponse(BasePydanticModel):
    """Response model for profile update operations."""
    
    status: str = Field(..., description="Update status")
    message: str = Field(..., description="Status message")
    request_id: Optional[str] = Field(None, description="Approval request ID")
    approval_required: bool = Field(False, description="Whether approval is required")
    user: Optional[UserRead] = Field(None, description="Updated user data if no approval required")
