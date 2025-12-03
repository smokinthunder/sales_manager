"""
Shop Assignment domain model.

Represents the assignment of shops to sales executives.
"""

from datetime import datetime, date
from typing import Optional
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Date, DateTime, Enum as SQLEnum, UniqueConstraint
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field, ConfigDict
from .base import Base, BaseEntity, BasePydanticModel


class AssignmentStatus(str, Enum):
    """Assignment status in the system."""
    ACTIVE = "active"
    INACTIVE = "inactive"
    SUSPENDED = "suspended"
    TRANSFERRED = "transferred"


class ShopAssignment(BaseEntity):
    """Shop Assignment entity model."""
    
    __tablename__ = "shop_assignments"
    __table_args__ = (
        UniqueConstraint('shop_id', 'executive_id', 'tenant_id', name='uq_shop_executive_tenant'),
    )
    
    shop_id: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    executive_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    territory_id: Mapped[Optional[str]] = mapped_column(String(20), nullable=True, index=True)
    assigned_date: Mapped[date] = mapped_column(Date, nullable=False, index=True)
    status: Mapped[AssignmentStatus] = mapped_column(SQLEnum(AssignmentStatus), default=AssignmentStatus.ACTIVE, index=True)
    notes: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    end_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    shop: Mapped[Optional["Shop"]] = relationship(
        "Shop",
        primaryjoin="ShopAssignment.shop_id == foreign(Shop.shop_id)",
        lazy="joined",
        viewonly=True
    )
    executive: Mapped["User"] = relationship(
        "User",
        foreign_keys=[executive_id],
        lazy="joined"
    )
    territory: Mapped[Optional["Territory"]] = relationship(
        "Territory",
        primaryjoin="ShopAssignment.territory_id == foreign(Territory.territory_id)",
        lazy="selectin",
        viewonly=True
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="ShopAssignment.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="ShopAssignment.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class ShopAssignmentBase(BasePydanticModel):
    """Base shop assignment model with common fields."""
    
    shop_id: str = Field(..., description="Shop ID")
    executive_id: int = Field(..., description="Sales executive ID")
    territory_id: Optional[str] = Field(None, description="Territory ID")
    assigned_date: date = Field(..., description="Assignment date")
    status: AssignmentStatus = Field(default=AssignmentStatus.ACTIVE, description="Assignment status")
    notes: Optional[str] = Field(None, description="Assignment notes")
    end_date: Optional[date] = Field(None, description="Assignment end date")


class ShopAssignmentCreate(ShopAssignmentBase):
    """Schema for creating a shop assignment."""
    pass


class ShopAssignmentUpdate(BasePydanticModel):
    """Schema for updating a shop assignment."""
    
    territory_id: Optional[str] = None
    status: Optional[AssignmentStatus] = None
    notes: Optional[str] = None
    end_date: Optional[date] = None


class ShopAssignmentRead(ShopAssignmentBase):
    """Schema for reading a shop assignment."""
    
    id: int
    shop_name: Optional[str] = Field(None, description="Shop name")
    shop_location: Optional[str] = Field(None, description="Shop location/address")
    executive_name: str = Field(..., description="Executive name")
    executive_phone: str = Field(..., description="Executive phone")
    executive_email: Optional[str] = Field(None, description="Executive email")
    territory_name: Optional[str] = Field(None, description="Territory name")
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)


class ShopAssignmentListItem(BasePydanticModel):
    """Schema for shop assignment list view."""
    
    id: int
    shop_id: str
    shop_name: Optional[str] = None
    shop_location: Optional[str] = None
    executive_id: int
    executive_name: str
    executive_phone: str
    assigned_date: date
    status: AssignmentStatus
    territory_id: Optional[str] = None
    territory_name: Optional[str] = None
    tenant_id: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)
