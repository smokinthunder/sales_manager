"""
Route domain model.

Represents planned routes for sales executives as collections of shops.
"""

from datetime import datetime, date, time
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


class RouteAssignmentStatus(str, Enum):
    """Route assignment status in the system."""
    PLANNED = "planned"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    SKIPPED = "skipped"


class Route(BaseEntity):
    """Route entity model - represents a collection of shops."""
    
    __tablename__ = "routes"
    
    route_id: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    territory_id: Mapped[str] = mapped_column(String(20), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    week_start_date: Mapped[date] = mapped_column(Date, nullable=False)
    status: Mapped[RouteStatus] = mapped_column(SQLEnum(RouteStatus), default=RouteStatus.PLANNED)
    
    # Relationships
    route_assignments: Mapped[List["RouteAssignment"]] = relationship(
        "RouteAssignment",
        back_populates="route",
        lazy="selectin"
    )
    territory: Mapped[Optional["Territory"]] = relationship(
        "Territory",
        back_populates="routes",
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


class RouteAssignment(Base):
    """Many-to-many relationship between routes and shops with additional metadata."""
    
    __tablename__ = "route_assignments"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    route_id: Mapped[int] = mapped_column(Integer, ForeignKey("routes.id"), nullable=False)
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    sales_executive_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False)
    planned_date: Mapped[date] = mapped_column(Date, nullable=False)
    planned_time: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    sequence_order: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="planned")
    
    # Relationships
    route: Mapped["Route"] = relationship("Route", back_populates="route_assignments")
    shop: Mapped["Shop"] = relationship("Shop", back_populates="route_assignments")
    sales_executive: Mapped["User"] = relationship("User", back_populates="assigned_routes")
    visits: Mapped[List["Visit"]] = relationship("Visit", back_populates="route_assignment")


# Pydantic models for API
class RouteBase(BasePydanticModel):
    """Base route model with common fields."""
    
    route_id: Optional[str] = Field(
        None, 
        description="Business-friendly route identifier (auto-generated if not provided)",
        examples=["RT-001", "RT-002", "RT-003"],
        pattern=r"^RT-\d{3,}$"
    )
    name: str = Field(
        ..., 
        description="Route name",
        examples=["Morning Route", "Evening Route", "Weekend Route"],
        min_length=1,
        max_length=255
    )
    territory_id: str = Field(
        ..., 
        description="Territory identifier",
        examples=["KL007", "KL001", "TN001"],
        min_length=1,
        max_length=20
    )
    week_start_date: date = Field(
        ..., 
        description="Week start date for the route (YYYY-MM-DD)",
        examples=["2025-08-30", "2025-09-06", "2025-09-13"]
    )
    status: RouteStatus = Field(
        default=RouteStatus.PLANNED, 
        description="Route status",
        examples=["planned", "in_progress", "completed"]
    )


class RouteCreate(RouteBase):
    """Model for creating new routes."""
    route_id: Optional[str] = Field(
        None, 
        description="Business-friendly route identifier (auto-generated if not provided)",
        examples=["RT-001", "RT-002", "RT-003"],
        pattern=r"^RT-\d{3,}$"
    )


class RouteUpdate(BasePydanticModel):
    """Model for updating existing routes."""
    
    route_id: Optional[str] = Field(
        None, 
        description="Business-friendly route identifier",
        examples=["RT-001", "RT-002", "RT-003"],
        pattern=r"^RT-\d{3,}$"
    )
    name: Optional[str] = Field(
        None, 
        description="Route name",
        examples=["Morning Route", "Evening Route", "Weekend Route"],
        min_length=1,
        max_length=255
    )
    territory_id: Optional[str] = Field(
        None, 
        description="Territory identifier",
        examples=["KL007", "KL001", "TN001"],
        min_length=1,
        max_length=20
    )
    week_start_date: Optional[date] = Field(
        None, 
        description="Week start date for the route (YYYY-MM-DD)",
        examples=["2025-08-30", "2025-09-06", "2025-09-13"]
    )
    status: Optional[RouteStatus] = Field(
        None, 
        description="Route status",
        examples=["planned", "in_progress", "completed"]
    )


class RouteRead(BasePydanticModel):
    """Model for reading route data."""
    
    id: int = Field(..., description="Database primary key")
    route_id: str = Field(..., description="Business-friendly route identifier")
    name: str = Field(..., description="Route name")
    territory_id: str = Field(..., description="Territory identifier")
    week_start_date: date = Field(..., description="Week start date for the route")
    status: RouteStatus = Field(..., description="Route status")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Route creation timestamp")
    updated_at: datetime = Field(..., description="Route last update timestamp")
    created_by: Optional[int] = Field(None, description="User ID who created the route")
    updated_by: Optional[int] = Field(None, description="User ID who last updated the route")


# Route Assignment Models
class RouteAssignmentBase(BasePydanticModel):
    """Base model for route assignments (shops within routes)."""
    
    shop_id: int = Field(..., description="Shop identifier", examples=[1, 2, 3])
    sales_executive_id: int = Field(..., description="Sales executive identifier", examples=[5, 7, 9])
    planned_date: date = Field(..., description="Planned visit date (YYYY-MM-DD)", examples=["2025-08-30", "2025-09-01", "2025-09-02"])
    planned_time: Optional[time] = Field(None, description="Planned visit time (HH:MM:SS)", examples=["09:00:00", "14:30:00", "16:00:00"])
    sequence_order: Optional[int] = Field(None, description="Visit sequence order within the route", examples=[1, 2, 3, 4])
    status: RouteAssignmentStatus = Field(
        default=RouteAssignmentStatus.PLANNED, 
        description="Assignment status",
        examples=["planned", "in_progress", "completed", "skipped"]
    )


class RouteAssignmentCreate(RouteAssignmentBase):
    """Model for creating new route assignments."""
    pass


class RouteAssignmentUpdate(BasePydanticModel):
    """Model for updating existing route assignments."""
    
    shop_id: Optional[int] = Field(None, description="Shop identifier", examples=[1, 2, 3])
    sales_executive_id: Optional[int] = Field(None, description="Sales executive identifier", examples=[5, 7, 9])
    planned_date: Optional[date] = Field(None, description="Planned visit date (YYYY-MM-DD)", examples=["2025-08-30", "2025-09-01", "2025-09-02"])
    planned_time: Optional[time] = Field(None, description="Planned visit time (HH:MM:SS)", examples=["09:00:00", "14:30:00", "16:00:00"])
    sequence_order: Optional[int] = Field(None, description="Visit sequence order within the route", examples=[1, 2, 3, 4])
    status: Optional[RouteAssignmentStatus] = Field(
        None, 
        description="Assignment status",
        examples=["planned", "in_progress", "completed", "skipped"]
    )


class RouteAssignmentRead(BasePydanticModel):
    """Model for reading route assignment data."""
    
    id: int = Field(..., description="Assignment database primary key")
    route_id: int = Field(..., description="Route database primary key")
    shop_id: int = Field(..., description="Shop identifier")
    sales_executive_id: int = Field(..., description="Sales executive identifier")
    planned_date: date = Field(..., description="Planned visit date")
    planned_time: Optional[time] = Field(None, description="Planned visit time")
    sequence_order: Optional[int] = Field(None, description="Visit sequence order within the route")
    status: RouteAssignmentStatus = Field(..., description="Assignment status")
    created_at: datetime = Field(..., description="Assignment creation timestamp")
    updated_at: datetime = Field(..., description="Assignment last update timestamp")


class RouteWithAssignments(BasePydanticModel):
    """Model for reading route data with its assignments."""
    
    id: int = Field(..., description="Route database primary key")
    route_id: str = Field(..., description="Business-friendly route identifier")
    name: str = Field(..., description="Route name")
    territory_id: str = Field(..., description="Territory identifier")
    week_start_date: date = Field(..., description="Week start date for the route")
    status: RouteStatus = Field(..., description="Route status")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Route creation timestamp")
    updated_at: datetime = Field(..., description="Route last update timestamp")
    created_by: Optional[int] = Field(None, description="User ID who created the route")
    updated_by: Optional[int] = Field(None, description="User ID who last updated the route")
    assignments: List[RouteAssignmentRead] = Field(..., description="List of shops assigned to this route")
