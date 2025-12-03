"""Order domain models."""

from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime


class OrderRead(BaseModel):
    """Order response model."""
    id: int
    order_id: str
    bill_number: Optional[str] = None
    shop_id: str
    executive_id: int
    order_date: date
    delivery_date: Optional[date] = None
    total_amount: float
    discount_amount: Optional[float] = None
    tax_amount: Optional[float] = None
    final_amount: float
    status: str
    payment_status: str
    payment_method: Optional[str] = None
    items_count: int
    notes: Optional[str] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class OrderItemRead(BaseModel):
    """Order item response model."""
    id: int
    order_id: int
    product_code: str
    product_name: str
    quantity: int
    unit_price: float
    discount_percent: Optional[float] = None
    discount_amount: Optional[float] = None
    tax_percent: Optional[float] = None
    tax_amount: Optional[float] = None
    total_amount: float
    created_at: datetime

    class Config:
        from_attributes = True
