"""
Core application modules.

This package contains the core infrastructure components:
- Configuration management
- Database connections
- Security utilities
- Logging setup
- Error handling
- Rate limiting
- Redis client
"""

from .config import settings
from .database import get_db, get_db_context, init_db, close_db
from .security import (
    create_access_token, create_refresh_token, verify_token,
    verify_password, get_password_hash, generate_otp, generate_secure_token
)
from .logging import setup_logging, get_logger, log_request_info, log_security_event, log_performance
from .errors import (
    SalesManagerException, AuthenticationError, AuthorizationError,
    ValidationError, NotFoundError, ConflictError, RateLimitError,
    DataLayerError, OTPError, TenantError,
    create_error_response, handle_validation_error, log_error,
    raise_not_found_if_none, raise_unauthorized_if_false, raise_forbidden_if_false
)
from .rate_limit import RateLimiter, rate_limit_middleware, create_rate_limit_dependency
from .redis_client import RedisClient, get_redis_client, close_redis_client

__all__ = [
    # Configuration
    "settings",
    
    # Database
    "get_db", "get_db_context", "init_db", "close_db",
    
    # Security
    "create_access_token", "create_refresh_token", "verify_token",
    "verify_password", "get_password_hash", "generate_otp", "generate_secure_token",
    
    # Logging
    "setup_logging", "get_logger", "log_request_info", "log_security_event", "log_performance",
    
    # Error handling
    "SalesManagerException", "AuthenticationError", "AuthorizationError",
    "ValidationError", "NotFoundError", "ConflictError", "RateLimitError",
    "DataLayerError", "OTPError", "TenantError",
    "create_error_response", "handle_validation_error", "log_error",
    "raise_not_found_if_none", "raise_unauthorized_if_false", "raise_forbidden_if_false",
    
    # Rate limiting
    "RateLimiter", "rate_limit_middleware", "create_rate_limit_dependency",
    
    # Redis
    "RedisClient", "get_redis_client", "close_redis_client",
]
