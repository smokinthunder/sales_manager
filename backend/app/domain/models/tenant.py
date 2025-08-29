"""
Tenant domain model.

Represents multi-tenant organizations in the system.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class TenantStatus(str, Enum):
    """Tenant status in the system."""
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    PENDING_APPROVAL = "pending_approval"


class Tenant(BaseEntity):
    """Tenant entity model."""
    
    __tablename__ = "tenants"
    
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    code: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    status: Mapped[TenantStatus] = mapped_column(SQLEnum(TenantStatus), default=TenantStatus.PENDING_APPROVAL)
    address: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    email: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    contact_person: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    
    # Relationships
    users: Mapped[List["User"]] = relationship(
        "User",
        back_populates="tenant",
        lazy="selectin"
    )
    territories: Mapped[List["Territory"]] = relationship(
        "Territory",
        back_populates="tenant",
        lazy="selectin"
    )
    shops: Mapped[List["Shop"]] = relationship(
        "Shop",
        back_populates="tenant",
        lazy="selectin"
    )
    routes: Mapped[List["Route"]] = relationship(
        "Route",
        back_populates="tenant",
        lazy="selectin"
    )
    visits: Mapped[List["Visit"]] = relationship(
        "Visit",
        back_populates="tenant",
        lazy="selectin"
    )
    products: Mapped[List["Product"]] = relationship(
        "Product",
        back_populates="tenant",
        lazy="selectin"
    )
    orders: Mapped[List["Order"]] = relationship(
        "Order",
        back_populates="tenant",
        lazy="selectin"
    )
    payments: Mapped[List["Payment"]] = relationship(
        "Payment",
        back_populates="tenant",
        lazy="selectin"
    )
    outstandings: Mapped[List["Outstanding"]] = relationship(
        "Outstanding",
        back_populates="tenant",
        lazy="selectin"
    )
    approvals: Mapped[List["Approval"]] = relationship(
        "Approval",
        back_populates="tenant",
        lazy="selectin"
    )


# Pydantic models for API
class TenantBase(BasePydanticModel):
    """Base tenant model with common fields."""
    
    name: str = Field(..., description="Tenant organization name")
    code: str = Field(..., description="Unique tenant code")
    status: TenantStatus = Field(default=TenantStatus.PENDING_APPROVAL, description="Tenant status")
    address: Optional[str] = Field(None, description="Tenant address")
    phone: Optional[str] = Field(None, description="Contact phone number")
    email: Optional[str] = Field(None, description="Contact email")
    contact_person: Optional[str] = Field(None, description="Primary contact person")


class TenantCreate(TenantBase):
    """Model for creating new tenants."""
    pass


class TenantUpdate(BasePydanticModel):
    """Model for updating existing tenants."""
    
    name: Optional[str] = None
    code: Optional[str] = None
    status: Optional[TenantStatus] = None
    address: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    contact_person: Optional[str] = None


class TenantRead(TenantBase):
    """Model for reading tenant data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
