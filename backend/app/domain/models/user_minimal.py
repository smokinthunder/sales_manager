"""
Minimal User model for testing.
"""

from datetime import datetime
from typing import Optional
from enum import Enum
from sqlmodel import SQLModel, Field


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


class User(UserBase, table=True):
    """User entity model."""
    
    __tablename__ = "users"
    
    id: Optional[int] = Field(default=None, primary_key=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    created_by: Optional[int] = Field(default=None, foreign_key="users.id")
    updated_by: Optional[int] = Field(default=None, foreign_key="users.id")


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
