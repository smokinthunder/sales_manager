"""
Route domain model.

Represents planned routes for sales executives.
"""

from datetime import datetime, date
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Date, Enum as SQLEnum, DateTime
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class RouteStatus(str, Enum):
    """Route status in the system."""
    PLANNED = "planned"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class Route(BaseEntity):
    """Route entity model."""
    
    __tablename__ = "routes"
    
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    code: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    status: Mapped[RouteStatus] = mapped_column(SQLEnum(RouteStatus), default=RouteStatus.PLANNED)
    planned_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)
    sales_executive_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    territory_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("territories.id"), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    sales_executive: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="assigned_routes",
        foreign_keys="Route.sales_executive_id",
        lazy="selectin"
    )
    territory: Mapped[Optional["Territory"]] = relationship(
        "Territory",
        back_populates="routes",
        lazy="selectin"
    )
    route_shops: Mapped[List["RouteShop"]] = relationship(
        "RouteShop",
        back_populates="route",
        lazy="selectin"
    )
    visits: Mapped[List["Visit"]] = relationship(
        "Visit",
        back_populates="route",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_routes",
        foreign_keys="Route.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_routes",
        foreign_keys="Route.updated_by",
        lazy="selectin"
    )


class RouteShop(Base):
    """Many-to-many relationship between routes and shops."""
    
    __tablename__ = "route_shops"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    route_id: Mapped[int] = mapped_column(Integer, ForeignKey("routes.id"), nullable=False)
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    sequence: Mapped[int] = mapped_column(Integer, default=1)
    planned_time: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    
    # Relationships
    route: Mapped["Route"] = relationship("Route", back_populates="route_shops")
    shop: Mapped["Shop"] = relationship("Shop", back_populates="route_assignments")


# Pydantic models for API
class RouteBase(BasePydanticModel):
    """Base route model with common fields."""
    
    name: str = Field(..., description="Route name")
    code: str = Field(..., description="Unique route code")
    status: RouteStatus = Field(default=RouteStatus.PLANNED, description="Route status")
    planned_date: Optional[date] = Field(None, description="Planned execution date")
    sales_executive_id: Optional[int] = Field(None, description="Assigned sales executive ID")
    territory_id: Optional[int] = Field(None, description="Territory ID")
    tenant_id: str = Field(..., description="Tenant identifier")


class RouteCreate(RouteBase):
    """Model for creating new routes."""
    pass


class RouteUpdate(BasePydanticModel):
    """Model for updating existing routes."""
    
    name: Optional[str] = None
    code: Optional[str] = None
    status: Optional[RouteStatus] = None
    planned_date: Optional[date] = None
    sales_executive_id: Optional[int] = None
    territory_id: Optional[int] = None


class RouteRead(RouteBase):
    """Model for reading route data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
