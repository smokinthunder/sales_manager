"""
Tenant domain model.

Represents client organizations in the multi-tenant system
with configurable branding and feature flags.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from sqlmodel import SQLModel, Field, Relationship
from pydantic import validator


class TenantStatus(str, Enum):
    """Tenant account status."""
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    TRIAL = "trial"


class TenantBase(SQLModel):
    """Base tenant model with common fields."""
    
    name: str = Field(..., description="Organization name")
    code: str = Field(..., description="Unique tenant code")
    status: TenantStatus = Field(default=TenantStatus.TRIAL, description="Account status")
    max_users: int = Field(default=10, description="Maximum number of users")
    branding_logo_url: Optional[str] = Field(None, description="Custom logo URL")
    primary_color: Optional[str] = Field(None, description="Primary brand color")
    secondary_color: Optional[str] = Field(None, description="Secondary brand color")
    
    @validator("code")
    def validate_code(cls, v):
        """Validate tenant code format."""
        if not v or len(v) < 3:
            raise ValueError("Tenant code must be at least 3 characters")
        if not v.isalnum():
            raise ValueError("Tenant code must be alphanumeric")
        return v.upper()


class Tenant(TenantBase, table=True):
    """Tenant entity model."""
    
    __tablename__ = "tenants"
    
    id: Optional[int] = Field(default=None, primary_key=True)
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
    created_by: Optional[int] = Field(default=None, foreign_key="users.id")
    updated_by: Optional[int] = Field(default=None, foreign_key="users.id")
    
    # Feature flags
    enable_analytics: bool = Field(default=True, description="Enable analytics module")
    enable_file_uploads: bool = Field(default=True, description="Enable file uploads")
    enable_sync: bool = Field(default=True, description="Enable data synchronization")
    enable_approvals: bool = Field(default=True, description="Enable approval workflows")
    
    # Relationships
    users: List["User"] = Relationship(back_populates="tenant")
    territories: List["Territory"] = Relationship(back_populates="tenant")
    shops: List["Shop"] = Relationship(back_populates="tenant")


class TenantCreate(TenantBase):
    """Model for creating new tenants."""
    pass


class TenantUpdate(SQLModel):
    """Model for updating existing tenants."""
    
    name: Optional[str] = None
    status: Optional[TenantStatus] = None
    max_users: Optional[int] = None
    branding_logo_url: Optional[str] = None
    primary_color: Optional[str] = None
    secondary_color: Optional[str] = None
    enable_analytics: Optional[bool] = None
    enable_file_uploads: Optional[bool] = None
    enable_sync: Optional[bool] = None
    enable_approvals: Optional[bool] = None


class TenantRead(TenantBase):
    """Model for reading tenant data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
    enable_analytics: bool
    enable_file_uploads: bool
    enable_sync: bool
    enable_approvals: bool
