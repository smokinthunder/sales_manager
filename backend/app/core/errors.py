"""
Error handling and custom exceptions for the application.

Provides standardized error responses and custom exceptions
for different types of business logic errors.
"""

from typing import Any, Dict, Optional
from fastapi import HTTPException, status
from pydantic import ValidationError
import structlog

logger = structlog.get_logger(__name__)


class SalesManagerException(Exception):
    """Base exception for Sales Manager application."""
    
    def __init__(
        self,
        message: str,
        error_code: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None,
        status_code: int = status.HTTP_500_INTERNAL_SERVER_ERROR
    ):
        self.message = message
        self.error_code = error_code
        self.details = details or {}
        self.status_code = status_code
        super().__init__(self.message)


class AuthenticationError(SalesManagerException):
    """Authentication related errors."""
    
    def __init__(self, message: str = "Authentication failed", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="AUTH_ERROR",
            details=details,
            status_code=status.HTTP_401_UNAUTHORIZED
        )


class AuthorizationError(SalesManagerException):
    """Authorization related errors."""
    
    def __init__(self, message: str = "Insufficient permissions", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="AUTHZ_ERROR",
            details=details,
            status_code=status.HTTP_403_FORBIDDEN
        )


class ValidationError(SalesManagerException):
    """Data validation errors."""
    
    def __init__(self, message: str = "Validation failed", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="VALIDATION_ERROR",
            details=details,
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY
        )


class NotFoundError(SalesManagerException):
    """Resource not found errors."""
    
    def __init__(self, message: str = "Resource not found", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="NOT_FOUND",
            details=details,
            status_code=status.HTTP_404_NOT_FOUND
        )


class ConflictError(SalesManagerException):
    """Resource conflict errors."""
    
    def __init__(self, message: str = "Resource conflict", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="CONFLICT",
            details=details,
            status_code=status.HTTP_409_CONFLICT
        )


class RateLimitError(SalesManagerException):
    """Rate limiting errors."""
    
    def __init__(self, message: str = "Rate limit exceeded", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="RATE_LIMIT",
            details=details,
            status_code=status.HTTP_429_TOO_MANY_REQUESTS
        )


class DataLayerError(SalesManagerException):
    """Data Layer service errors."""
    
    def __init__(self, message: str = "Data Layer service error", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="DATA_LAYER_ERROR",
            details=details,
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE
        )


class OTPError(SalesManagerException):
    """OTP related errors."""
    
    def __init__(self, message: str = "OTP error", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="OTP_ERROR",
            details=details,
            status_code=status.HTTP_400_BAD_REQUEST
        )


class TenantError(SalesManagerException):
    """Tenant related errors."""
    
    def __init__(self, message: str = "Tenant error", details: Optional[Dict[str, Any]] = None):
        super().__init__(
            message=message,
            error_code="TENANT_ERROR",
            details=details,
            status_code=status.HTTP_400_BAD_REQUEST
        )


def create_error_response(
    error: SalesManagerException,
    include_details: bool = True
) -> Dict[str, Any]:
    """
    Create standardized error response.
    
    Args:
        error: SalesManagerException instance
        include_details: Whether to include error details
        
    Returns:
        Standardized error response dictionary
    """
    response = {
        "error": {
            "message": error.message,
            "code": error.error_code,
            "type": error.__class__.__name__
        }
    }
    
    if include_details and error.details:
        response["error"]["details"] = error.details
    
    return response


def handle_validation_error(exc: ValidationError) -> Dict[str, Any]:
    """
    Handle Pydantic validation errors.
    
    Args:
        exc: ValidationError instance
        
    Returns:
        Standardized validation error response
    """
    error_details = []
    for error in exc.errors():
        error_details.append({
            "field": " -> ".join(str(loc) for loc in error["loc"]),
            "message": error["msg"],
            "type": error["type"]
        })
    
    return create_error_response(
        ValidationError(
            message="Validation failed",
            details={"validation_errors": error_details}
        )
    )


def log_error(error: Exception, context: Optional[Dict[str, Any]] = None) -> None:
    """
    Log error with context information.
    
    Args:
        error: Exception to log
        context: Additional context information
    """
    if isinstance(error, SalesManagerException):
        logger.error(
            "Business logic error",
            error_type=error.__class__.__name__,
            error_code=error.error_code,
            message=error.message,
            details=error.details,
            status_code=error.status_code,
            context=context or {}
        )
    else:
        logger.error(
            "Unexpected error",
            error_type=error.__class__.__name__,
            message=str(error),
            context=context or {},
            exc_info=True
        )


def raise_not_found_if_none(
    obj: Any,
    message: str = "Resource not found",
    details: Optional[Dict[str, Any]] = None
) -> Any:
    """
    Raise NotFoundError if object is None.
    
    Args:
        obj: Object to check
        message: Error message
        details: Error details
        
    Returns:
        Object if not None
        
    Raises:
        NotFoundError: If object is None
    """
    if obj is None:
        raise NotFoundError(message=message, details=details)
    return obj


def raise_unauthorized_if_false(
    condition: bool,
    message: str = "Unauthorized access",
    details: Optional[Dict[str, Any]] = None
) -> None:
    """
    Raise AuthenticationError if condition is False.
    
    Args:
        condition: Boolean condition to check
        message: Error message
        details: Error details
        
    Raises:
        AuthenticationError: If condition is False
    """
    if not condition:
        raise AuthenticationError(message=message, details=details)


def raise_forbidden_if_false(
    condition: bool,
    message: str = "Insufficient permissions",
    details: Optional[Dict[str, Any]] = None
) -> None:
    """
    Raise AuthorizationError if condition is False.
    
    Args:
        condition: Boolean condition to check
        message: Error message
        details: Error details
        
    Raises:
        AuthorizationError: If condition is False
    """
    if not condition:
        raise AuthorizationError(message=message, details=details)
