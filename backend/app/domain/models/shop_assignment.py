"""Shop Assignment domain models."""

from pydantic import BaseModel
from typing import Optional
from datetime import date, datetime


class ShopAssignmentRead(BaseModel):
    """Shop assignment response model."""
    id: int
    shop_id: str
    executive_id: int
    territory_id: Optional[str] = None
    assigned_date: date
    end_date: Optional[date] = None
    status: str
    notes: Optional[str] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
