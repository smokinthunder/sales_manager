"""
Territory domain model.

Represents geographic areas managed by area managers.
"""

from datetime import datetime
from typing import Optional, List
from sqlalchemy import String, Integer, ForeignKey
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class Territory(BaseEntity):
    """Territory entity model."""
    
    __tablename__ = "territories"
    
    territory_id: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    code: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, index=True)
    description: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    area_manager_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("users.id"), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    area_manager: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="managed_territories",
        foreign_keys="Territory.area_manager_id",
        lazy="selectin"
    )
    shops: Mapped[List["Shop"]] = relationship(
        "Shop",
        back_populates="territory",
        lazy="selectin"
    )
    routes: Mapped[List["Route"]] = relationship(
        "Route",
        back_populates="territory",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_territories",
        foreign_keys="Territory.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_territories",
        foreign_keys="Territory.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class TerritoryBase(BasePydanticModel):
    """Base territory model with common fields."""
    
    territory_id: str = Field(..., description="Unique territory identifier")
    name: str = Field(..., description="Territory name")
    code: str = Field(..., description="Unique territory code")
    description: Optional[str] = Field(None, description="Territory description")
    area_manager_id: Optional[int] = Field(None, description="Area manager user ID")
    tenant_id: str = Field(..., description="Tenant identifier")


class TerritoryCreate(TerritoryBase):
    """Model for creating new territories."""
    pass


class TerritoryUpdate(BasePydanticModel):
    """Model for updating existing territories."""
    
    territory_id: Optional[str] = None
    name: Optional[str] = None
    code: Optional[str] = None
    description: Optional[str] = None
    area_manager_id: Optional[int] = None


class TerritoryRead(TerritoryBase):
    """Model for reading territory data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
