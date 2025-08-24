"""
User domain model.

Represents users in the system with role-based access control
and multi-tenant support.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from sqlmodel import SQLModel, Field, Relationship
from pydantic import validator


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


class UserBase(SQLModel):
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


class User(UserBase, table=True):
    """User entity model."""
    
    __tablename__ = "users"
    
    id: Optional[int] = Field(default=None, primary_key=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    created_by: Optional[int] = Field(default=None, foreign_key="users.id")
    updated_by: Optional[int] = Field(default=None, foreign_key="users.id")
    
    # Relationships
    created_users: list["User"] = Relationship(
        back_populates="creator",
        sa_relationship_kwargs={"foreign_keys": "User.created_by"}
    )
    creator: Optional["User"] = Relationship(
        back_populates="created_users",
        sa_relationship_kwargs={"foreign_keys": "User.created_by"}
    )
    updated_users: list["User"] = Relationship(
        back_populates="updater",
        sa_relationship_kwargs={"foreign_keys": "User.updated_by"}
    )
    updater: Optional["User"] = Relationship(
        back_populates="updated_users",
        sa_relationship_kwargs={"foreign_keys": "User.updated_by"}
    )


class UserCreate(UserBase):
    """Model for creating new users."""
    pass


class UserUpdate(SQLModel):
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


class UserLogin(SQLModel):
    """Model for user login."""
    
    phone: str = Field(..., description="Phone number")
    otp: str = Field(..., description="One-time password")


class UserOTP(SQLModel):
    """Model for OTP verification."""
    
    phone: str = Field(..., description="Phone number")
    otp: str = Field(..., description="One-time password")
    expires_at: datetime = Field(..., description="OTP expiration time")
