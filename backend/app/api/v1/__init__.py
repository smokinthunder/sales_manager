"""
API v1 module.

Contains all API endpoints for version 1 of the API.
"""

from .auth import router as auth_router
from .users import router as users_router
from .territories import router as territories_router
from .routes import router as routes_router
from .shops import router as shops_router
from .outstanding import router as outstanding_router
from .orders import router as orders_router
from .sync import router as sync_router
from .analytics import router as analytics_router
from .notifications import router as notifications_router

__all__ = [
    "auth_router",
    "users_router",
    "territories_router",
    "routes_router",
    "shops_router",
    "outstanding_router",
    "orders_router",
    "sync_router",
    "analytics_router",
    "notifications_router"
]
