"""
Shop domain model.

Represents retail locations within territories.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Float, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class ShopStatus(str, Enum):
    """Shop status in the system."""
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    CLOSED = "closed"


class Shop(BaseEntity):
    """Shop entity model."""
    
    __tablename__ = "shops"
    
    shop_id: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    code: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    status: Mapped[ShopStatus] = mapped_column(SQLEnum(ShopStatus), default=ShopStatus.ACTIVE)
    address: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    contact_person: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    latitude: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    longitude: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    territory_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("territories.id"), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Sync fields for client data synchronization
    last_sync_date: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    sync_status: Mapped[Optional[str]] = mapped_column(String(20), nullable=True, default="pending")
    sync_error: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    
    # Relationships
    territory: Mapped[Optional["Territory"]] = relationship(
        "Territory",
        back_populates="shops",
        lazy="selectin"
    )
    visits: Mapped[List["Visit"]] = relationship(
        "Visit",
        back_populates="shop",
        lazy="selectin"
    )
    route_assignments: Mapped[List["RouteShop"]] = relationship(
        "RouteShop",
        back_populates="shop",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_shops",
        foreign_keys="Shop.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_shops",
        foreign_keys="Shop.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class ShopBase(BasePydanticModel):
    """Base shop model with common fields."""
    
    shop_id: str = Field(..., description="Unique shop identifier")
    name: str = Field(..., description="Shop name")
    status: ShopStatus = Field(default=ShopStatus.ACTIVE, description="Shop status")
    address: Optional[str] = Field(None, description="Shop address")
    phone: Optional[str] = Field(None, description="Contact phone number")
    contact_person: Optional[str] = Field(None, description="Contact person name")
    latitude: Optional[float] = Field(None, description="Geographic latitude")
    longitude: Optional[float] = Field(None, description="Geographic longitude")
    territory_id: Optional[str] = Field(None, description="Territory ID")


class ShopCreate(ShopBase):
    """Model for creating new shops."""
    pass


class ShopUpdate(BasePydanticModel):
    """Model for updating existing shops."""
    
    name: Optional[str] = Field(None, description="Shop name")
    status: Optional[ShopStatus] = Field(None, description="Shop status")
    address: Optional[str] = Field(None, description="Shop address")
    phone: Optional[str] = Field(None, description="Contact phone number")
    contact_person: Optional[str] = Field(None, description="Contact person name")
    latitude: Optional[float] = Field(None, description="Geographic latitude")
    longitude: Optional[float] = Field(None, description="Geographic longitude")
    territory_id: Optional[str] = Field(None, description="Territory ID")


class ShopRead(ShopBase):
    """Model for reading shop data."""
    
    id: int = Field(..., description="Database ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")
    created_by: Optional[int] = Field(None, description="User who created the shop")
    updated_by: Optional[int] = Field(None, description="User who last updated the shop")
