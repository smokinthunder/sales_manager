"""
Order domain model.

Represents sales orders from shops.
"""

from datetime import datetime, date
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Float, Date, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class OrderStatus(str, Enum):
    """Order status in the system."""
    DRAFT = "draft"
    CONFIRMED = "confirmed"
    IN_PROGRESS = "in_progress"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    CANCELLED = "cancelled"


class Order(BaseEntity):
    """Order entity model."""
    
    __tablename__ = "orders"
    
    order_number: Mapped[str] = mapped_column(String(50), unique=True, nullable=False, index=True)
    order_date: Mapped[date] = mapped_column(Date, nullable=False)
    status: Mapped[OrderStatus] = mapped_column(SQLEnum(OrderStatus), default=OrderStatus.DRAFT)
    total_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    discount_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    tax_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    grand_total: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    delivery_date: Mapped[Optional[date]] = mapped_column(Date, nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    shop: Mapped["Shop"] = relationship(
        "Shop",
        back_populates="orders",
        lazy="selectin"
    )
    order_lines: Mapped[List["OrderLine"]] = relationship(
        "OrderLine",
        back_populates="order",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_orders",
        foreign_keys="Order.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_orders",
        foreign_keys="Order.updated_by",
        lazy="selectin"
    )


class OrderLine(Base):
    """Order line item model."""
    
    __tablename__ = "order_lines"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    order_id: Mapped[int] = mapped_column(Integer, ForeignKey("orders.id"), nullable=False)
    product_id: Mapped[int] = mapped_column(Integer, ForeignKey("products.id"), nullable=False)
    quantity: Mapped[int] = mapped_column(Integer, nullable=False)
    unit_price: Mapped[float] = mapped_column(Float, nullable=False)
    total_price: Mapped[float] = mapped_column(Float, nullable=False)
    
    # Relationships
    order: Mapped["Order"] = relationship("Order", back_populates="order_lines")
    product: Mapped["Product"] = relationship("Product", back_populates="order_lines")


# Pydantic models for API
class OrderLineBase(BasePydanticModel):
    """Base order line model with common fields."""
    
    product_id: int = Field(..., description="Product ID")
    quantity: int = Field(..., description="Quantity ordered")
    unit_price: float = Field(..., description="Unit price")
    total_price: float = Field(..., description="Total price for this line")


class OrderLineCreate(OrderLineBase):
    """Model for creating new order lines."""
    pass


class OrderLineUpdate(BasePydanticModel):
    """Model for updating existing order lines."""
    
    quantity: Optional[int] = None
    unit_price: Optional[float] = None
    total_price: Optional[float] = None


class OrderLineRead(OrderLineBase):
    """Model for reading order line data."""
    
    id: int
    order_id: int


class OrderBase(BasePydanticModel):
    """Base order model with common fields."""
    
    order_number: str = Field(..., description="Unique order number")
    order_date: date = Field(..., description="Order date")
    status: OrderStatus = Field(default=OrderStatus.DRAFT, description="Order status")
    total_amount: float = Field(default=0.0, description="Subtotal amount")
    discount_amount: float = Field(default=0.0, description="Discount amount")
    tax_amount: float = Field(default=0.0, description="Tax amount")
    grand_total: float = Field(default=0.0, description="Grand total")
    delivery_date: Optional[date] = Field(None, description="Expected delivery date")
    notes: Optional[str] = Field(None, description="Order notes")
    shop_id: int = Field(..., description="Shop ID")
    tenant_id: str = Field(..., description="Tenant identifier")


class OrderCreate(OrderBase):
    """Model for creating new orders."""
    pass


class OrderUpdate(BasePydanticModel):
    """Model for updating existing orders."""
    
    order_number: Optional[str] = None
    order_date: Optional[date] = None
    status: Optional[OrderStatus] = None
    total_amount: Optional[float] = None
    discount_amount: Optional[float] = None
    tax_amount: Optional[float] = None
    grand_total: Optional[float] = None
    delivery_date: Optional[date] = None
    notes: Optional[str] = None


class OrderRead(OrderBase):
    """Model for reading order data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
