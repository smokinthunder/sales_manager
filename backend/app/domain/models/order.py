"""
Order domain model.

Represents orders placed by shops through sales executives.
"""

from datetime import datetime
from typing import Optional, List
from enum import Enum
from decimal import Decimal
from sqlalchemy import String, Integer, ForeignKey, Numeric, DateTime, Enum as SQLEnum, Text
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field, ConfigDict
from .base import Base, BaseEntity, BasePydanticModel


class OrderStatus(str, Enum):
    """Order status in the system."""
    PENDING = "pending"
    CONFIRMED = "confirmed"
    PROCESSING = "processing"
    SHIPPED = "shipped"
    DELIVERED = "delivered"
    COMPLETED = "completed"
    CANCELLED = "cancelled"
    RETURNED = "returned"


class Order(BaseEntity):
    """Order entity model."""
    
    __tablename__ = "orders"
    
    order_id: Mapped[str] = mapped_column(String(50), unique=True, nullable=False, index=True)
    bill_number: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    shop_id: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    executive_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    order_date: Mapped[datetime] = mapped_column(DateTime, nullable=False, index=True)
    total_amount: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False, default=0)
    status: Mapped[OrderStatus] = mapped_column(SQLEnum(OrderStatus), default=OrderStatus.PENDING, index=True)
    items_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    delivery_date: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    payment_status: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    payment_method: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    shop: Mapped[Optional["Shop"]] = relationship(
        "Shop",
        primaryjoin="Order.shop_id == foreign(Shop.shop_id)",
        lazy="joined",
        viewonly=True
    )
    executive: Mapped["User"] = relationship(
        "User",
        foreign_keys=[executive_id],
        lazy="joined"
    )
    items: Mapped[List["OrderItem"]] = relationship(
        "OrderItem",
        back_populates="order",
        cascade="all, delete-orphan",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="Order.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        foreign_keys="Order.updated_by",
        lazy="selectin"
    )


class OrderItem(BaseEntity):
    """Order item entity model."""
    
    __tablename__ = "order_items"
    
    order_id: Mapped[int] = mapped_column(Integer, ForeignKey("orders.id"), nullable=False, index=True)
    product_code: Mapped[str] = mapped_column(String(50), nullable=False)
    product_name: Mapped[str] = mapped_column(String(200), nullable=False)
    quantity: Mapped[Decimal] = mapped_column(Numeric(12, 3), nullable=False)
    unit: Mapped[str] = mapped_column(String(20), nullable=False, default="PCS")
    unit_price: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    total_price: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False)
    discount: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False, default=0)
    tax_amount: Mapped[Decimal] = mapped_column(Numeric(12, 2), nullable=False, default=0)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    order: Mapped["Order"] = relationship(
        "Order",
        back_populates="items"
    )


# Pydantic models for API
class OrderItemBase(BasePydanticModel):
    """Base order item model with common fields."""
    
    product_code: str = Field(..., description="Product code")
    product_name: str = Field(..., description="Product name")
    quantity: Decimal = Field(..., description="Quantity ordered", ge=0)
    unit: str = Field(default="PCS", description="Unit of measurement")
    unit_price: Decimal = Field(..., description="Unit price", ge=0)
    total_price: Decimal = Field(..., description="Total price for this item", ge=0)
    discount: Decimal = Field(default=0, description="Discount amount", ge=0)
    tax_amount: Decimal = Field(default=0, description="Tax amount", ge=0)


class OrderItemCreate(OrderItemBase):
    """Schema for creating an order item."""
    pass


class OrderItemUpdate(BasePydanticModel):
    """Schema for updating an order item."""
    
    product_code: Optional[str] = None
    product_name: Optional[str] = None
    quantity: Optional[Decimal] = Field(None, ge=0)
    unit: Optional[str] = None
    unit_price: Optional[Decimal] = Field(None, ge=0)
    total_price: Optional[Decimal] = Field(None, ge=0)
    discount: Optional[Decimal] = Field(None, ge=0)
    tax_amount: Optional[Decimal] = Field(None, ge=0)


class OrderItemRead(OrderItemBase):
    """Schema for reading an order item."""
    
    id: int
    order_id: int
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)


class OrderBase(BasePydanticModel):
    """Base order model with common fields."""
    
    order_id: str = Field(..., description="Unique order identifier")
    bill_number: str = Field(..., description="Bill number")
    shop_id: str = Field(..., description="Shop ID")
    executive_id: int = Field(..., description="Sales executive ID")
    order_date: datetime = Field(..., description="Order date and time")
    total_amount: Decimal = Field(..., description="Total order amount", ge=0)
    status: OrderStatus = Field(default=OrderStatus.PENDING, description="Order status")
    items_count: int = Field(default=0, description="Number of items in order", ge=0)
    notes: Optional[str] = Field(None, description="Order notes")
    delivery_date: Optional[datetime] = Field(None, description="Expected delivery date")
    payment_status: Optional[str] = Field(None, description="Payment status")
    payment_method: Optional[str] = Field(None, description="Payment method")


class OrderCreate(OrderBase):
    """Schema for creating an order."""
    
    items: List[OrderItemCreate] = Field(default_factory=list, description="Order items")


class OrderUpdate(BasePydanticModel):
    """Schema for updating an order."""
    
    bill_number: Optional[str] = None
    order_date: Optional[datetime] = None
    total_amount: Optional[Decimal] = Field(None, ge=0)
    status: Optional[OrderStatus] = None
    items_count: Optional[int] = Field(None, ge=0)
    notes: Optional[str] = None
    delivery_date: Optional[datetime] = None
    payment_status: Optional[str] = None
    payment_method: Optional[str] = None


class OrderRead(OrderBase):
    """Schema for reading an order."""
    
    id: int
    shop_name: Optional[str] = Field(None, description="Shop name")
    shop_location: Optional[str] = Field(None, description="Shop location")
    executive_name: str = Field(..., description="Executive name")
    executive_phone: str = Field(..., description="Executive phone")
    items: List[OrderItemRead] = Field(default_factory=list, description="Order items")
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)


class OrderListItem(BasePydanticModel):
    """Schema for order list view (without items)."""
    
    id: int
    order_id: str
    bill_number: str
    shop_id: str
    shop_name: Optional[str] = None
    shop_location: Optional[str] = None
    executive_id: int
    executive_name: str
    executive_phone: str
    total_amount: Decimal
    status: OrderStatus
    order_date: datetime
    items_count: int
    tenant_id: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = ConfigDict(from_attributes=True)
