"""
API v1 package for the Sales Manager Backend.

This package contains version 1 of the API endpoints.
"""

from .users import router as users_router

__all__ = ["users_router"]
