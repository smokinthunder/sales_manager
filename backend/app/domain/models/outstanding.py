"""
Outstanding domain model.

Represents outstanding payments and dues for shops with proper
tenant isolation and authorization controls.
"""

from datetime import datetime, date
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Text, Enum as SQLEnum, DateTime, Date, Float, Index
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class OutstandingStatus(str, Enum):
    """Outstanding status enumeration."""
    CURRENT = "current"
    UPCOMING = "upcoming"
    OVERDUE = "overdue"


class DueData(BaseEntity):
    """Due data entity model for outstanding payments."""
    
    __tablename__ = "due_data"
    
    shop_id: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    shop_name: Mapped[str] = mapped_column(String(100), nullable=False)
    amount: Mapped[float] = mapped_column(Float, nullable=False)
    due_date: Mapped[date] = mapped_column(Date, nullable=False, index=True)
    status: Mapped[OutstandingStatus] = mapped_column(SQLEnum(OutstandingStatus), nullable=False, index=True)
    sales_executive_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    territory_id: Mapped[Optional[str]] = mapped_column(String(20), nullable=True, index=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Additional fields for tracking
    original_amount: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    days_overdue: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    last_payment_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    
    # Sync fields for client data synchronization
    last_sync_date: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    sync_status: Mapped[Optional[str]] = mapped_column(String(20), nullable=True, default="pending")
    sync_error: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    
    # Relationships
    sales_executive: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="outstanding_dues",
        foreign_keys="DueData.sales_executive_id",
        lazy="selectin"
    )
    shop: Mapped[Optional["Shop"]] = relationship(
        "Shop",
        back_populates="outstanding_dues",
        primaryjoin="DueData.shop_id == Shop.shop_id",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_due_data",
        foreign_keys="DueData.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_due_data",
        foreign_keys="DueData.updated_by",
        lazy="selectin"
    )
    
    # Indexes for performance
    __table_args__ = (
        Index('idx_tenant_shop', 'tenant_id', 'shop_id'),
        Index('idx_tenant_executive', 'tenant_id', 'sales_executive_id'),
        Index('idx_tenant_status', 'tenant_id', 'status'),
        Index('idx_tenant_due_date', 'tenant_id', 'due_date'),
        Index('idx_tenant_territory', 'tenant_id', 'territory_id'),
    )


# Pydantic models for API
class DueDataBase(BasePydanticModel):
    """Base due data model with common fields."""
    
    shop_id: str = Field(..., description="Shop identifier")
    shop_name: str = Field(..., description="Shop name")
    amount: float = Field(..., description="Outstanding amount")
    due_date: date = Field(..., description="Due date for payment")
    status: OutstandingStatus = Field(..., description="Outstanding status")
    sales_executive_id: Optional[int] = Field(None, description="Sales executive ID")
    territory_id: Optional[str] = Field(None, description="Territory identifier")
    tenant_id: str = Field(..., description="Tenant identifier")
    original_amount: Optional[float] = Field(None, description="Original amount before any adjustments")
    days_overdue: Optional[int] = Field(None, description="Number of days overdue")
    last_payment_date: Optional[date] = Field(None, description="Last payment date")
    notes: Optional[str] = Field(None, description="Additional notes")


class DueDataCreate(BasePydanticModel):
    """Model for creating new due data."""
    
    shop_id: str = Field(..., description="Shop identifier")
    shop_name: str = Field(..., description="Shop name")
    amount: float = Field(..., description="Outstanding amount")
    due_date: date = Field(..., description="Due date for payment")
    status: OutstandingStatus = Field(..., description="Outstanding status")
    sales_executive_id: Optional[int] = Field(None, description="Sales executive ID")
    territory_id: Optional[str] = Field(None, description="Territory identifier")
    original_amount: Optional[float] = Field(None, description="Original amount before any adjustments")
    days_overdue: Optional[int] = Field(None, description="Number of days overdue")
    last_payment_date: Optional[date] = Field(None, description="Last payment date")
    notes: Optional[str] = Field(None, description="Additional notes")
    # Note: tenant_id is not included here as it's taken from the URL path parameter


class DueDataUpdate(BasePydanticModel):
    """Model for updating existing due data."""
    
    shop_name: Optional[str] = None
    amount: Optional[float] = None
    due_date: Optional[date] = None
    status: Optional[OutstandingStatus] = None
    sales_executive_id: Optional[int] = None
    territory_id: Optional[str] = None
    original_amount: Optional[float] = None
    days_overdue: Optional[int] = None
    last_payment_date: Optional[date] = None
    notes: Optional[str] = None


class DueDataRead(DueDataBase):
    """Model for reading due data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None


class OutstandingSummary(BasePydanticModel):
    """Summary model for outstanding data."""
    
    due_date: date = Field(..., description="Due date")
    shop_name: str = Field(..., description="Shop name")
    amount: float = Field(..., description="Outstanding amount")
    status: OutstandingStatus = Field(..., description="Current status")
    sales_executive_name: Optional[str] = Field(None, description="Sales executive name")
    territory_name: Optional[str] = Field(None, description="Territory name")
    days_overdue: Optional[int] = Field(None, description="Days overdue if applicable")


class OutstandingFilters(BasePydanticModel):
    """Model for outstanding data filters."""
    
    sales_executive_id: Optional[int] = Field(None, description="Filter by sales executive ID")
    territory_id: Optional[str] = Field(None, description="Filter by territory ID")
    status: Optional[OutstandingStatus] = Field(None, description="Filter by status")
    start_date: Optional[date] = Field(None, description="Filter by start date")
    end_date: Optional[date] = Field(None, description="Filter by end date")
    shop_search: Optional[str] = Field(None, description="Search by shop name")
    min_amount: Optional[float] = Field(None, description="Minimum amount filter")
    max_amount: Optional[float] = Field(None, description="Maximum amount filter")
