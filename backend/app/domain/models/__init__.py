"""
Domain models for the Sales Manager application.

This module contains all the domain entities and value objects
that represent the core business logic of the system.
"""

from .user import (
    User, UserCreate, UserUpdate, UserRead, UserLogin, UserOTP,
    UserRole, UserStatus
)
from .tenant import (
    Tenant, TenantCreate, TenantUpdate, TenantRead,
    TenantStatus
)
from .territory import (
    Territory, TerritoryCreate, TerritoryUpdate, TerritoryRead
)
from .shop import (
    Shop, ShopCreate, ShopUpdate, ShopRead, ShopStatus
)
from .route import (
    Route, RouteCreate, RouteUpdate, RouteRead, RouteStatus
)
from .visit import (
    Visit, VisitCreate, VisitUpdate, VisitRead, VisitStatus
)
from .order import (
    OrderRead, OrderItemRead
)
from .shop_assignment import (
    ShopAssignmentRead
)
from .approval import (
    Approval, ApprovalCreate, ApprovalUpdate, ApprovalRead, ApprovalStatus
)
from .outstanding import (
    DueData, DueDataCreate, DueDataUpdate, DueDataRead, OutstandingSummary, OutstandingFilters,
    OutstandingStatus
)
from .notification import (
    Notification, NotificationCreate, NotificationUpdate, NotificationRead, 
    NotificationConfirm, NotificationType
)
from .sync_data import (
    SyncedShopData, SyncedShopDataCreate, SyncedShopDataUpdate, SyncedShopDataRead,
    SyncedOrder, SyncedOrderCreate, SyncedOrderUpdate, SyncedOrderRead,
    SyncedProduct, SyncedProductCreate, SyncedProductUpdate, SyncedProductRead,
    SyncStatus, PaymentStatus,
    calculate_due_date, calculate_payment_status, calculate_shop_payment_summary
)
from .analytics import (
    SalesPerformance, SalesPerformanceCreate, SalesPerformanceUpdate, SalesPerformanceRead,
    ShopAnalytics, ShopAnalyticsCreate, ShopAnalyticsUpdate, ShopAnalyticsRead,
    PaymentAnalytics, PaymentAnalyticsCreate, PaymentAnalyticsUpdate, PaymentAnalyticsRead,
    PerformanceLevel, PaymentTrend,
    TopCustomerResponse, BestSellingProductResponse, SalesReportResponse,
    PurchaseAnalysisResponse, ShopBestSellingProductResponse, ShopSalesReportResponse,
    calculate_performance_level, calculate_payment_trend, calculate_payment_collection_rate, calculate_compliance_rate
)

__all__ = [
    # User management
    "User", "UserCreate", "UserUpdate", "UserRead", "UserLogin", "UserOTP",
    "UserRole", "UserStatus",
    
    # Tenant management
    "Tenant", "TenantCreate", "TenantUpdate", "TenantRead", "TenantStatus",
    
    # Territory management
    "Territory", "TerritoryCreate", "TerritoryUpdate", "TerritoryRead",
    
    # Shop management
    "Shop", "ShopCreate", "ShopUpdate", "ShopRead", "ShopStatus",
    
    # Route management
    "Route", "RouteCreate", "RouteUpdate", "RouteRead", "RouteStatus",
    
    # Visit tracking
    "Visit", "VisitCreate", "VisitUpdate", "VisitRead", "VisitStatus",
    
    # Order management
    "OrderRead", "OrderItemRead",
    
    # Shop Assignment management
    "ShopAssignmentRead",
    
    # Approval workflows
    "Approval", "ApprovalCreate", "ApprovalUpdate", "ApprovalRead", "ApprovalStatus",
    
    # Outstanding management
    "DueData", "DueDataCreate", "DueDataUpdate", "DueDataRead", "OutstandingSummary", "OutstandingFilters",
    "OutstandingStatus",
    
    # Notification management
    "Notification", "NotificationCreate", "NotificationUpdate", "NotificationRead", 
    "NotificationConfirm", "NotificationType",
    
    # Sync data management
    "SyncedShopData", "SyncedShopDataCreate", "SyncedShopDataUpdate", "SyncedShopDataRead",
    "SyncedOrder", "SyncedOrderCreate", "SyncedOrderUpdate", "SyncedOrderRead",
    "SyncedProduct", "SyncedProductCreate", "SyncedProductUpdate", "SyncedProductRead",
    "SyncStatus", "PaymentStatus",
    "calculate_due_date", "calculate_payment_status", "calculate_shop_payment_summary",
    
    # Analytics and reporting
    "SalesPerformance", "SalesPerformanceCreate", "SalesPerformanceUpdate", "SalesPerformanceRead",
    "ShopAnalytics", "ShopAnalyticsCreate", "ShopAnalyticsUpdate", "ShopAnalyticsRead",
    "PaymentAnalytics", "PaymentAnalyticsCreate", "PaymentAnalyticsUpdate", "PaymentAnalyticsRead",
    "PerformanceLevel", "PaymentTrend",
    "TopCustomerResponse", "BestSellingProductResponse", "SalesReportResponse",
    "PurchaseAnalysisResponse", "ShopBestSellingProductResponse", "ShopSalesReportResponse",
    "calculate_performance_level", "calculate_payment_trend", "calculate_payment_collection_rate", "calculate_compliance_rate",
]
