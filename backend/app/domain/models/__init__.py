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
from .product import (
    Product, ProductCreate, ProductUpdate, ProductRead
)
from .order import (
    Order, OrderCreate, OrderUpdate, OrderRead, OrderStatus
)
from .payment import (
    Payment, PaymentCreate, PaymentUpdate, PaymentRead
)
from .outstanding import (
    Outstanding, OutstandingCreate, OutstandingUpdate, OutstandingRead
)
from .approval import (
    Approval, ApprovalCreate, ApprovalUpdate, ApprovalRead, ApprovalStatus
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
    
    # Product management
    "Product", "ProductCreate", "ProductUpdate", "ProductRead",
    
    # Order management
    "Order", "OrderCreate", "OrderUpdate", "OrderRead", "OrderStatus",
    
    # Payment management
    "Payment", "PaymentCreate", "PaymentUpdate", "PaymentRead",
    
    # Outstanding management
    "Outstanding", "OutstandingCreate", "OutstandingUpdate", "OutstandingRead",
    
    # Approval workflows
    "Approval", "ApprovalCreate", "ApprovalUpdate", "ApprovalRead", "ApprovalStatus",
]
