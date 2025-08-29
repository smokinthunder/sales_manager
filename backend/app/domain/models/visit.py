"""
Visit domain model.

Represents actual shop visits by sales executives.
"""

from datetime import datetime, date
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Float, Date, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class VisitStatus(str, Enum):
    """Visit status in the system."""
    PLANNED = "planned"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    NO_SHOW = "no_show"


class Visit(BaseEntity):
    """Visit entity model."""
    
    __tablename__ = "visits"
    
    visit_id: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    planned_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)
    status: Mapped[VisitStatus] = mapped_column(SQLEnum(VisitStatus), default=VisitStatus.PLANNED)
    check_in_time: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    check_in_latitude: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    check_in_longitude: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    check_in_accuracy: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    check_out_time: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    check_out_latitude: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    check_out_longitude: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    check_out_accuracy: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    duration_minutes: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    remarks: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    next_visit_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)
    photos: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)  # JSON string of photo URLs
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    sales_executive_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False)
    route_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("routes.id"), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    shop: Mapped["Shop"] = relationship(
        "Shop",
        back_populates="visits",
        lazy="selectin"
    )
    sales_executive: Mapped["User"] = relationship(
        "User",
        back_populates="visits",
        foreign_keys="Visit.sales_executive_id",
        lazy="selectin"
    )
    route: Mapped[Optional["Route"]] = relationship(
        "Route",
        back_populates="visits",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_visits",
        foreign_keys="Visit.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_visits",
        foreign_keys="Visit.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class VisitBase(BasePydanticModel):
    """Base visit model with common fields."""
    
    visit_id: str = Field(..., description="Unique visit identifier")
    planned_date: Optional[date] = Field(None, description="Planned visit date")
    status: VisitStatus = Field(default=VisitStatus.PLANNED, description="Visit status")
    check_in_time: Optional[datetime] = Field(None, description="Check-in timestamp")
    check_in_latitude: Optional[float] = Field(None, description="Check-in latitude")
    check_in_longitude: Optional[float] = Field(None, description="Check-in longitude")
    check_in_accuracy: Optional[float] = Field(None, description="GPS accuracy at check-in")
    check_out_time: Optional[datetime] = Field(None, description="Check-out timestamp")
    check_out_latitude: Optional[float] = Field(None, description="Check-out latitude")
    check_out_longitude: Optional[float] = Field(None, description="Check-out longitude")
    check_out_accuracy: Optional[float] = Field(None, description="GPS accuracy at check-out")
    duration_minutes: Optional[int] = Field(None, description="Visit duration in minutes")
    remarks: Optional[str] = Field(None, description="Visit remarks")
    next_visit_date: Optional[date] = Field(None, description="Next planned visit date")
    photos: Optional[str] = Field(None, description="Photo URLs (JSON string)")
    shop_id: int = Field(..., description="Shop ID")
    sales_executive_id: int = Field(..., description="Sales executive ID")
    route_id: Optional[int] = Field(None, description="Route ID")
    tenant_id: str = Field(..., description="Tenant identifier")


class VisitCreate(VisitBase):
    """Model for creating new visits."""
    pass


class VisitUpdate(BasePydanticModel):
    """Model for updating existing visits."""
    
    planned_date: Optional[date] = None
    status: Optional[VisitStatus] = None
    check_in_time: Optional[datetime] = None
    check_in_latitude: Optional[float] = None
    check_in_longitude: Optional[float] = None
    check_in_accuracy: Optional[float] = None
    check_out_time: Optional[datetime] = None
    check_out_latitude: Optional[float] = None
    check_out_longitude: Optional[float] = None
    check_out_accuracy: Optional[float] = None
    duration_minutes: Optional[int] = None
    remarks: Optional[str] = None
    next_visit_date: Optional[date] = None
    photos: Optional[str] = None


class VisitRead(VisitBase):
    """Model for reading visit data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
