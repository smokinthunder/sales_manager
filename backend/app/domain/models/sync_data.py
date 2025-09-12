"""
Sync data domain models.

Represents data synchronized from client systems with 30-day payment policy.
"""

from datetime import datetime, date, timedelta
from typing import Optional, List, Dict, Any
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Float, Date, DateTime, JSON, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field, field_validator
from .base import Base, BaseEntity, BasePydanticModel


class SyncStatus(str, Enum):
    """Sync status enumeration."""
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"
    NOT_SYNCED = "not_synced"


class PaymentStatus(str, Enum):
    """Payment status based on 30-day policy."""
    CURRENT = "current"
    UPCOMING = "upcoming"
    OVERDUE = "overdue"


class SyncedShopData(BaseEntity):
    """Synced shop financial data from client system."""
    
    __tablename__ = "synced_shop_data"
    
    shop_id: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    shop_name: Mapped[str] = mapped_column(String(100), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Financial data from client
    current_payment: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    upcoming_payment: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    overdue_payment: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # Sync metadata
    sync_date: Mapped[datetime] = mapped_column(DateTime, nullable=False, default=datetime.utcnow)
    sync_status: Mapped[SyncStatus] = mapped_column(SQLEnum(SyncStatus), default=SyncStatus.COMPLETED)
    sync_error: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    
    # Raw client data (JSON)
    raw_client_data: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    
    # Relationships
    synced_orders: Mapped[List["SyncedOrder"]] = relationship(
        "SyncedOrder",
        back_populates="shop_data",
        lazy="selectin",
        cascade="all, delete-orphan"
    )
    synced_products: Mapped[List["SyncedProduct"]] = relationship(
        "SyncedProduct",
        back_populates="shop_data",
        lazy="selectin",
        cascade="all, delete-orphan"
    )


class SyncedOrder(BaseEntity):
    """Individual order from client system with 30-day payment policy."""
    
    __tablename__ = "synced_orders"
    
    order_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    order_date: Mapped[date] = mapped_column(Date, nullable=False)
    order_amount: Mapped[float] = mapped_column(Float, nullable=False)
    
    # 30-day payment policy calculations
    due_date: Mapped[date] = mapped_column(Date, nullable=False)
    payment_status: Mapped[PaymentStatus] = mapped_column(SQLEnum(PaymentStatus), nullable=False)
    days_overdue: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    
    # Shop and tenant references
    shop_data_id: Mapped[int] = mapped_column(Integer, ForeignKey("synced_shop_data.id"), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Sync metadata
    sync_date: Mapped[datetime] = mapped_column(DateTime, nullable=False, default=datetime.utcnow)
    
    # Raw order data (JSON)
    raw_order_data: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    
    # Relationships
    shop_data: Mapped["SyncedShopData"] = relationship(
        "SyncedShopData",
        back_populates="synced_orders",
        lazy="selectin"
    )
    order_products: Mapped[List["SyncedProduct"]] = relationship(
        "SyncedProduct",
        back_populates="order",
        lazy="selectin",
        cascade="all, delete-orphan"
    )


class SyncedProduct(BaseEntity):
    """Product data from client system."""
    
    __tablename__ = "synced_products"
    
    product_name: Mapped[str] = mapped_column(String(100), nullable=False)
    product_amount: Mapped[float] = mapped_column(Float, nullable=False)
    sku: Mapped[Optional[str]] = mapped_column(String(50), nullable=True, index=True)
    category: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    
    # References
    shop_data_id: Mapped[int] = mapped_column(Integer, ForeignKey("synced_shop_data.id"), nullable=False)
    order_id: Mapped[Optional[int]] = mapped_column(Integer, ForeignKey("synced_orders.id"), nullable=True)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Sync metadata
    sync_date: Mapped[datetime] = mapped_column(DateTime, nullable=False, default=datetime.utcnow)
    
    # Raw product data (JSON)
    raw_product_data: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    
    # Relationships
    shop_data: Mapped["SyncedShopData"] = relationship(
        "SyncedShopData",
        back_populates="synced_products",
        lazy="selectin"
    )
    order: Mapped[Optional["SyncedOrder"]] = relationship(
        "SyncedOrder",
        back_populates="order_products",
        lazy="selectin"
    )


# Pydantic models for API
class SyncedShopDataBase(BasePydanticModel):
    """Base synced shop data model."""
    
    shop_id: str = Field(..., description="Shop identifier from client system")
    shop_name: str = Field(..., description="Shop name from client system")
    current_payment: float = Field(default=0.0, description="Current payment amount")
    upcoming_payment: float = Field(default=0.0, description="Upcoming payment amount")
    overdue_payment: float = Field(default=0.0, description="Overdue payment amount")
    sync_status: SyncStatus = Field(default=SyncStatus.COMPLETED, description="Sync status")
    sync_error: Optional[str] = Field(None, description="Sync error message if any")


class SyncedShopDataCreate(SyncedShopDataBase):
    """Model for creating synced shop data."""
    pass


class SyncedShopDataUpdate(BasePydanticModel):
    """Model for updating synced shop data."""
    
    current_payment: Optional[float] = None
    upcoming_payment: Optional[float] = None
    overdue_payment: Optional[float] = None
    sync_status: Optional[SyncStatus] = None
    sync_error: Optional[str] = None


class SyncedShopDataRead(SyncedShopDataBase):
    """Model for reading synced shop data."""
    
    id: int = Field(..., description="Database ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    sync_date: datetime = Field(..., description="Sync timestamp")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")


class SyncedOrderBase(BasePydanticModel):
    """Base synced order model."""
    
    order_id: str = Field(..., description="Order identifier from client system")
    order_date: date = Field(..., description="Order date")
    order_amount: float = Field(..., description="Order amount")
    due_date: date = Field(..., description="Payment due date (30 days from order date)")
    payment_status: PaymentStatus = Field(..., description="Payment status based on 30-day policy")
    days_overdue: int = Field(default=0, description="Days overdue if payment is overdue")


class SyncedOrderCreate(SyncedOrderBase):
    """Model for creating synced orders."""
    pass


class SyncedOrderUpdate(BasePydanticModel):
    """Model for updating synced orders."""
    
    order_amount: Optional[float] = None
    payment_status: Optional[PaymentStatus] = None
    days_overdue: Optional[int] = None


class SyncedOrderRead(SyncedOrderBase):
    """Model for reading synced orders."""
    
    id: int = Field(..., description="Database ID")
    shop_data_id: int = Field(..., description="Shop data ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    sync_date: datetime = Field(..., description="Sync timestamp")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")


class SyncedProductBase(BasePydanticModel):
    """Base synced product model."""
    
    product_name: str = Field(..., description="Product name from client system")
    product_amount: float = Field(..., description="Product amount")
    sku: Optional[str] = Field(None, description="Product SKU")
    category: Optional[str] = Field(None, description="Product category")


class SyncedProductCreate(SyncedProductBase):
    """Model for creating synced products."""
    pass


class SyncedProductUpdate(BasePydanticModel):
    """Model for updating synced products."""
    
    product_name: Optional[str] = None
    product_amount: Optional[float] = None
    sku: Optional[str] = None
    category: Optional[str] = None


class SyncedProductRead(SyncedProductBase):
    """Model for reading synced products."""
    
    id: int = Field(..., description="Database ID")
    shop_data_id: int = Field(..., description="Shop data ID")
    order_id: Optional[int] = Field(None, description="Order ID if part of an order")
    tenant_id: str = Field(..., description="Tenant identifier")
    sync_date: datetime = Field(..., description="Sync timestamp")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")


# Utility functions for 30-day payment policy
def calculate_due_date(order_date: date) -> date:
    """Calculate due date based on 30-day policy."""
    return order_date + timedelta(days=30)


def calculate_payment_status(due_date: date) -> tuple[PaymentStatus, int]:
    """Calculate payment status and days overdue based on 30-day policy."""
    today = date.today()
    if today > due_date:
        days_overdue = (today - due_date).days
        return PaymentStatus.OVERDUE, days_overdue
    elif today <= due_date and (due_date - today).days <= 7:
        return PaymentStatus.UPCOMING, 0
    else:
        return PaymentStatus.CURRENT, 0


def calculate_shop_payment_summary(orders: List[SyncedOrder]) -> tuple[float, float, float]:
    """Calculate shop payment summary from orders."""
    current = sum(order.order_amount for order in orders if order.payment_status == PaymentStatus.CURRENT)
    upcoming = sum(order.order_amount for order in orders if order.payment_status == PaymentStatus.UPCOMING)
    overdue = sum(order.order_amount for order in orders if order.payment_status == PaymentStatus.OVERDUE)
    
    return current, upcoming, overdue
