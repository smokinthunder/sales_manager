"""
Analytics domain models.

Represents analytics and reporting data for performance tracking
and business intelligence with 30-day payment policy integration.
"""

from datetime import datetime, date, timedelta
from typing import Optional, List, Dict, Any
from enum import Enum
from sqlalchemy import String, Integer, ForeignKey, Float, Date, DateTime, JSON, Enum as SQLEnum, Text
from sqlalchemy.orm import relationship, Mapped, mapped_column
from pydantic import Field, field_validator
from .base import Base, BaseEntity, BasePydanticModel


class PerformanceLevel(str, Enum):
    """Performance level enumeration."""
    EXCELLENT = "excellent"
    GOOD = "good"
    AVERAGE = "average"
    POOR = "poor"
    CRITICAL = "critical"


class PaymentTrend(str, Enum):
    """Payment trend enumeration."""
    IMPROVING = "improving"
    STABLE = "stable"
    DECLINING = "declining"
    CRITICAL = "critical"


class SalesPerformance(BaseEntity):
    """Executive performance analytics with payment metrics."""
    
    __tablename__ = "sales_performance"
    
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Performance period
    period_start: Mapped[date] = mapped_column(Date, nullable=False)
    period_end: Mapped[date] = mapped_column(Date, nullable=False)
    
    # Sales metrics
    total_orders: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    total_order_value: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    average_order_value: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # Payment metrics (30-day policy)
    current_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    upcoming_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    overdue_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    payment_collection_rate: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # Performance indicators
    performance_level: Mapped[PerformanceLevel] = mapped_column(SQLEnum(PerformanceLevel), nullable=False)
    payment_trend: Mapped[PaymentTrend] = mapped_column(SQLEnum(PaymentTrend), nullable=False)
    
    # Shop metrics
    shops_managed: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    active_shops: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    
    # Visit metrics
    total_visits: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    completed_visits: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    visit_completion_rate: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # Additional metrics (JSON for flexibility)
    additional_metrics: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    
    # Relationships
    user: Mapped["User"] = relationship("User", lazy="selectin")


class ShopAnalytics(BaseEntity):
    """Shop-specific analytics and performance tracking."""
    
    __tablename__ = "shop_analytics"
    
    shop_id: Mapped[int] = mapped_column(Integer, ForeignKey("shops.id"), nullable=False)
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Analytics period
    period_start: Mapped[date] = mapped_column(Date, nullable=False)
    period_end: Mapped[date] = mapped_column(Date, nullable=False)
    
    # Order analytics
    total_orders: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    total_order_value: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    average_order_value: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    order_frequency: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)  # orders per week
    
    # Payment analytics (30-day policy)
    current_payment: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    upcoming_payment: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    overdue_payment: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    payment_collection_rate: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    average_payment_delay: Mapped[int] = mapped_column(Integer, nullable=False, default=0)  # days
    
    # Visit analytics
    total_visits: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    completed_visits: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    visit_frequency: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)  # visits per week
    
    # Performance indicators
    performance_level: Mapped[PerformanceLevel] = mapped_column(SQLEnum(PerformanceLevel), nullable=False)
    payment_trend: Mapped[PaymentTrend] = mapped_column(SQLEnum(PaymentTrend), nullable=False)
    
    # Product analytics
    top_products: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    product_diversity: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    
    # Additional analytics (JSON for flexibility)
    additional_analytics: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)
    
    # Relationships
    shop: Mapped["Shop"] = relationship("Shop", lazy="selectin")


class PaymentAnalytics(BaseEntity):
    """Payment analytics with 30-day policy tracking."""
    
    __tablename__ = "payment_analytics"
    
    tenant_id: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    
    # Analytics period
    period_start: Mapped[date] = mapped_column(Date, nullable=False)
    period_end: Mapped[date] = mapped_column(Date, nullable=False)
    
    # Payment summary
    total_current_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    total_upcoming_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    total_overdue_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    total_payments: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # Payment metrics
    average_payment_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    payment_collection_rate: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    overdue_rate: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # 30-day policy compliance
    orders_within_30_days: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    orders_overdue: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    compliance_rate: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    
    # Payment trends
    payment_trend: Mapped[PaymentTrend] = mapped_column(SQLEnum(PaymentTrend), nullable=False)
    days_to_payment_improvement: Mapped[int] = mapped_column(Integer, nullable=True)
    
    # Shop-level metrics
    total_shops: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    shops_with_overdue: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    shops_with_upcoming: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    
    # Additional payment analytics (JSON for flexibility)
    additional_payment_metrics: Mapped[Optional[Dict[str, Any]]] = mapped_column(JSON, nullable=True)


# Pydantic models for API
class SalesPerformanceBase(BasePydanticModel):
    """Base sales performance model."""
    
    user_id: int = Field(..., description="User ID")
    period_start: date = Field(..., description="Performance period start date")
    period_end: date = Field(..., description="Performance period end date")
    total_orders: int = Field(default=0, description="Total number of orders")
    total_order_value: float = Field(default=0.0, description="Total order value")
    average_order_value: float = Field(default=0.0, description="Average order value")
    current_payments: float = Field(default=0.0, description="Current payments")
    upcoming_payments: float = Field(default=0.0, description="Upcoming payments")
    overdue_payments: float = Field(default=0.0, description="Overdue payments")
    payment_collection_rate: float = Field(default=0.0, description="Payment collection rate")
    performance_level: PerformanceLevel = Field(..., description="Performance level")
    payment_trend: PaymentTrend = Field(..., description="Payment trend")
    shops_managed: int = Field(default=0, description="Number of shops managed")
    active_shops: int = Field(default=0, description="Number of active shops")
    total_visits: int = Field(default=0, description="Total visits")
    completed_visits: int = Field(default=0, description="Completed visits")
    visit_completion_rate: float = Field(default=0.0, description="Visit completion rate")


class SalesPerformanceCreate(SalesPerformanceBase):
    """Model for creating sales performance records."""
    pass


class SalesPerformanceUpdate(BasePydanticModel):
    """Model for updating sales performance records."""
    
    total_orders: Optional[int] = None
    total_order_value: Optional[float] = None
    average_order_value: Optional[float] = None
    current_payments: Optional[float] = None
    upcoming_payments: Optional[float] = None
    overdue_payments: Optional[float] = None
    payment_collection_rate: Optional[float] = None
    performance_level: Optional[PerformanceLevel] = None
    payment_trend: Optional[PaymentTrend] = None
    shops_managed: Optional[int] = None
    active_shops: Optional[int] = None
    total_visits: Optional[int] = None
    completed_visits: Optional[int] = None
    visit_completion_rate: Optional[float] = None


class SalesPerformanceRead(SalesPerformanceBase):
    """Model for reading sales performance data."""
    
    id: int = Field(..., description="Database ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")


class ShopAnalyticsBase(BasePydanticModel):
    """Base shop analytics model."""
    
    shop_id: int = Field(..., description="Shop ID")
    period_start: date = Field(..., description="Analytics period start date")
    period_end: date = Field(..., description="Analytics period end date")
    total_orders: int = Field(default=0, description="Total number of orders")
    total_order_value: float = Field(default=0.0, description="Total order value")
    average_order_value: float = Field(default=0.0, description="Average order value")
    order_frequency: float = Field(default=0.0, description="Order frequency per week")
    current_payment: float = Field(default=0.0, description="Current payment amount")
    upcoming_payment: float = Field(default=0.0, description="Upcoming payment amount")
    overdue_payment: float = Field(default=0.0, description="Overdue payment amount")
    payment_collection_rate: float = Field(default=0.0, description="Payment collection rate")
    average_payment_delay: int = Field(default=0, description="Average payment delay in days")
    total_visits: int = Field(default=0, description="Total visits")
    completed_visits: int = Field(default=0, description="Completed visits")
    visit_frequency: float = Field(default=0.0, description="Visit frequency per week")
    performance_level: PerformanceLevel = Field(..., description="Performance level")
    payment_trend: PaymentTrend = Field(..., description="Payment trend")
    product_diversity: int = Field(default=0, description="Number of different products")


class ShopAnalyticsCreate(ShopAnalyticsBase):
    """Model for creating shop analytics records."""
    pass


class ShopAnalyticsUpdate(BasePydanticModel):
    """Model for updating shop analytics records."""
    
    total_orders: Optional[int] = None
    total_order_value: Optional[float] = None
    average_order_value: Optional[float] = None
    order_frequency: Optional[float] = None
    current_payment: Optional[float] = None
    upcoming_payment: Optional[float] = None
    overdue_payment: Optional[float] = None
    payment_collection_rate: Optional[float] = None
    average_payment_delay: Optional[int] = None
    total_visits: Optional[int] = None
    completed_visits: Optional[int] = None
    visit_frequency: Optional[float] = None
    performance_level: Optional[PerformanceLevel] = None
    payment_trend: Optional[PaymentTrend] = None
    product_diversity: Optional[int] = None


class ShopAnalyticsRead(ShopAnalyticsBase):
    """Model for reading shop analytics data."""
    
    id: int = Field(..., description="Database ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")


class PaymentAnalyticsBase(BasePydanticModel):
    """Base payment analytics model."""
    
    period_start: date = Field(..., description="Analytics period start date")
    period_end: date = Field(..., description="Analytics period end date")
    total_current_payments: float = Field(default=0.0, description="Total current payments")
    total_upcoming_payments: float = Field(default=0.0, description="Total upcoming payments")
    total_overdue_payments: float = Field(default=0.0, description="Total overdue payments")
    total_payments: float = Field(default=0.0, description="Total payments")
    average_payment_amount: float = Field(default=0.0, description="Average payment amount")
    payment_collection_rate: float = Field(default=0.0, description="Payment collection rate")
    overdue_rate: float = Field(default=0.0, description="Overdue rate")
    orders_within_30_days: int = Field(default=0, description="Orders within 30 days")
    orders_overdue: int = Field(default=0, description="Overdue orders")
    compliance_rate: float = Field(default=0.0, description="30-day policy compliance rate")
    payment_trend: PaymentTrend = Field(..., description="Payment trend")
    total_shops: int = Field(default=0, description="Total number of shops")
    shops_with_overdue: int = Field(default=0, description="Shops with overdue payments")
    shops_with_upcoming: int = Field(default=0, description="Shops with upcoming payments")


class PaymentAnalyticsCreate(PaymentAnalyticsBase):
    """Model for creating payment analytics records."""
    pass


class PaymentAnalyticsUpdate(BasePydanticModel):
    """Model for updating payment analytics records."""
    
    total_current_payments: Optional[float] = None
    total_upcoming_payments: Optional[float] = None
    total_overdue_payments: Optional[float] = None
    total_payments: Optional[float] = None
    average_payment_amount: Optional[float] = None
    payment_collection_rate: Optional[float] = None
    overdue_rate: Optional[float] = None
    orders_within_30_days: Optional[int] = None
    orders_overdue: Optional[int] = None
    compliance_rate: Optional[float] = None
    payment_trend: Optional[PaymentTrend] = None
    total_shops: Optional[int] = None
    shops_with_overdue: Optional[int] = None
    shops_with_upcoming: Optional[int] = None


class PaymentAnalyticsRead(PaymentAnalyticsBase):
    """Model for reading payment analytics data."""
    
    id: int = Field(..., description="Database ID")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Creation timestamp")
    updated_at: datetime = Field(..., description="Last update timestamp")


# Utility functions for analytics calculations
def calculate_performance_level(
    payment_collection_rate: float,
    visit_completion_rate: float,
    overdue_rate: float
) -> PerformanceLevel:
    """Calculate performance level based on key metrics."""
    if payment_collection_rate >= 90 and visit_completion_rate >= 85 and overdue_rate <= 5:
        return PerformanceLevel.EXCELLENT
    elif payment_collection_rate >= 80 and visit_completion_rate >= 75 and overdue_rate <= 10:
        return PerformanceLevel.GOOD
    elif payment_collection_rate >= 70 and visit_completion_rate >= 65 and overdue_rate <= 20:
        return PerformanceLevel.AVERAGE
    elif payment_collection_rate >= 60 and visit_completion_rate >= 55 and overdue_rate <= 30:
        return PerformanceLevel.POOR
    else:
        return PerformanceLevel.CRITICAL


def calculate_payment_trend(
    current_period_overdue: float,
    previous_period_overdue: float
) -> PaymentTrend:
    """Calculate payment trend based on overdue amounts."""
    if current_period_overdue == 0 and previous_period_overdue > 0:
        return PaymentTrend.IMPROVING
    elif abs(current_period_overdue - previous_period_overdue) <= (previous_period_overdue * 0.1):
        return PaymentTrend.STABLE
    elif current_period_overdue > previous_period_overdue * 1.2:
        return PaymentTrend.CRITICAL
    else:
        return PaymentTrend.DECLINING


def calculate_payment_collection_rate(
    total_payments: float,
    total_orders: float
) -> float:
    """Calculate payment collection rate."""
    if total_orders == 0:
        return 0.0
    return min(100.0, (total_payments / total_orders) * 100)


def calculate_compliance_rate(
    orders_within_30_days: int,
    total_orders: int
) -> float:
    """Calculate 30-day policy compliance rate."""
    if total_orders == 0:
        return 0.0
    return (orders_within_30_days / total_orders) * 100
