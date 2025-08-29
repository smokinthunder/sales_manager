"""
Outstanding domain model.

Represents outstanding balances for shops.
"""

from datetime import datetime, date
from typing import Optional, List
from sqlalchemy import String, Integer, ForeignKey, Float, Date
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class Outstanding(BaseEntity):
    """Outstanding entity model."""
    
    __tablename__ = "outstandings"
    
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    amount: Mapped[float] = mapped_column(Float, nullable=False)
    due_date: Mapped[date] = mapped_column(Date, nullable=False)
    overdue_days: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    notes: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    shop: Mapped["Shop"] = relationship(
        "Shop",
        back_populates="outstandings",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_outstandings",
        foreign_keys="Outstanding.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_outstandings",
        foreign_keys="Outstanding.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class OutstandingBase(BasePydanticModel):
    """Base outstanding model with common fields."""
    
    shop_id: int = Field(..., description="Shop ID")
    amount: float = Field(..., description="Outstanding amount")
    due_date: date = Field(..., description="Due date")
    overdue_days: int = Field(default=0, description="Days overdue")
    notes: Optional[str] = Field(None, description="Outstanding notes")
    tenant_id: str = Field(..., description="Tenant identifier")


class OutstandingCreate(OutstandingBase):
    """Model for creating new outstandings."""
    pass


class OutstandingUpdate(BasePydanticModel):
    """Model for updating existing outstandings."""
    
    amount: Optional[float] = None
    due_date: Optional[date] = None
    overdue_days: Optional[int] = None
    notes: Optional[str] = None


class OutstandingRead(OutstandingBase):
    """Model for reading outstanding data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
