"""
Product domain model.

Represents products that can be sold to shops.
"""

from datetime import datetime
from typing import Optional, List
from sqlalchemy import String, Integer, ForeignKey, Float, Text
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class Product(BaseEntity):
    """Product entity model."""
    
    __tablename__ = "products"
    
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    sku: Mapped[str] = mapped_column(String(50), unique=True, nullable=False, index=True)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    category: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    unit_price: Mapped[float] = mapped_column(Float, nullable=False)
    unit_of_measure: Mapped[str] = mapped_column(String(20), nullable=False, default="piece")
    is_active: Mapped[bool] = mapped_column(Integer, nullable=False, default=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    order_lines: Mapped[List["OrderLine"]] = relationship(
        "OrderLine",
        back_populates="product",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_products",
        foreign_keys="Product.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_products",
        foreign_keys="Product.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class ProductBase(BasePydanticModel):
    """Base product model with common fields."""
    
    name: str = Field(..., description="Product name")
    sku: str = Field(..., description="Stock keeping unit (unique identifier)")
    description: Optional[str] = Field(None, description="Product description")
    category: Optional[str] = Field(None, description="Product category")
    unit_price: float = Field(..., description="Unit price")
    unit_of_measure: str = Field(default="piece", description="Unit of measure")
    is_active: bool = Field(default=True, description="Product active status")
    tenant_id: str = Field(..., description="Tenant identifier")


class ProductCreate(ProductBase):
    """Model for creating new products."""
    pass


class ProductUpdate(BasePydanticModel):
    """Model for updating existing products."""
    
    name: Optional[str] = None
    sku: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    unit_price: Optional[float] = None
    unit_of_measure: Optional[str] = None
    is_active: Optional[bool] = None


class ProductRead(ProductBase):
    """Model for reading product data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
