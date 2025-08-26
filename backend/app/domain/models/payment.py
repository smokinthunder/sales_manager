"""
Payment domain model.

Represents payments made by shops.
"""

from datetime import datetime, date
from typing import Optional, List
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Float, Date, DateTime, Enum as SQLEnum
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field
from .base import Base, BaseEntity, BasePydanticModel


class PaymentMethod(str, Enum):
    """Payment method enumeration."""
    CASH = "cash"
    BANK_TRANSFER = "bank_transfer"
    CHEQUE = "cheque"
    CARD = "card"
    UPI = "upi"
    OTHER = "other"


class PaymentStatus(str, Enum):
    """Payment status enumeration."""
    PENDING = "pending"
    PROCESSING = "processing"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"
    REFUNDED = "refunded"


class Payment(BaseEntity):
    """Payment entity model."""
    
    __tablename__ = "payments"
    
    payment_number: Mapped[str] = mapped_column(String(50), unique=True, nullable=False, index=True)
    payment_date: Mapped[date] = mapped_column(Date, nullable=False)
    amount: Mapped[float] = mapped_column(Float, nullable=False)
    method: Mapped[PaymentMethod] = mapped_column(SQLEnum(PaymentMethod), nullable=False)
    status: Mapped[PaymentStatus] = mapped_column(SQLEnum(PaymentStatus), default=PaymentStatus.PENDING)
    reference_number: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Relationships
    shop: Mapped["Shop"] = relationship(
        "Shop",
        back_populates="payments",
        lazy="selectin"
    )
    creator: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="created_payments",
        foreign_keys="Payment.created_by",
        lazy="selectin"
    )
    updater: Mapped[Optional["User"]] = relationship(
        "User",
        back_populates="updated_payments",
        foreign_keys="Payment.updated_by",
        lazy="selectin"
    )


# Pydantic models for API
class PaymentBase(BasePydanticModel):
    """Base payment model with common fields."""
    
    payment_number: str = Field(..., description="Unique payment number")
    payment_date: date = Field(..., description="Payment date")
    amount: float = Field(..., description="Payment amount")
    method: PaymentMethod = Field(..., description="Payment method")
    status: PaymentStatus = Field(default=PaymentStatus.PENDING, description="Payment status")
    reference_number: Optional[str] = Field(None, description="External reference number")
    notes: Optional[str] = Field(None, description="Payment notes")
    shop_id: int = Field(..., description="Shop ID")
    tenant_id: str = Field(..., description="Tenant identifier")


class PaymentCreate(PaymentBase):
    """Model for creating new payments."""
    pass


class PaymentUpdate(BasePydanticModel):
    """Model for updating existing payments."""
    
    payment_number: Optional[str] = None
    payment_date: Optional[date] = None
    amount: Optional[float] = None
    method: Optional[PaymentMethod] = None
    status: Optional[PaymentStatus] = None
    reference_number: Optional[str] = None
    notes: Optional[str] = None


class PaymentRead(PaymentBase):
    """Model for reading payment data."""
    
    id: int
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
