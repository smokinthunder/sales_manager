"""
API v1 module.

Contains all API endpoints for version 1 of the API.
"""

from .auth import router as auth_router
from .users import router as users_router

__all__ = [
    "auth_router",
    "users_router"
]
