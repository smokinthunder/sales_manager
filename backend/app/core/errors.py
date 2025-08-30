"""
Custom exception classes for the application.

Provides structured error handling with consistent error messages
and additional context information.
"""

from typing import Optional, Dict, Any


class BaseError(Exception):
    """Base exception class for all custom errors."""
    
    def __init__(self, message: str, details: Optional[Dict[str, Any]] = None, status_code: int = 500):
        self.message = message
        self.details = details or {}
        self.status_code = status_code
        super().__init__(self.message)
    
    def to_response(self) -> Dict[str, Any]:
        """Convert error to response format."""
        response = {
            "error": {
                "message": self.message,
                "type": self.__class__.__name__,
                "details": self.details
            }
        }
        return response


class AuthenticationError(BaseError):
    """Raised when authentication fails."""
    
    def __init__(self, message: str = "Authentication failed", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 401)


class AuthorizationError(BaseError):
    """Raised when authorization fails."""
    
    def __init__(self, message: str = "Insufficient permissions", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 403)


class ValidationError(BaseError):
    """Raised when data validation fails."""
    
    def __init__(self, message: str = "Validation failed", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 422)


class NotFoundError(BaseError):
    """Raised when a requested resource is not found."""
    
    def __init__(self, message: str = "Resource not found", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 404)


class ConflictError(BaseError):
    """Raised when there's a conflict with existing data."""
    
    def __init__(self, message: str = "Resource conflict", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 409)


class RateLimitError(BaseError):
    """Raised when rate limits are exceeded."""
    
    def __init__(self, message: str = "Rate limit exceeded", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 429)


class DatabaseError(BaseError):
    """Raised when database operations fail."""
    
    def __init__(self, message: str = "Database operation failed", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 500)


class ExternalServiceError(BaseError):
    """Raised when external service calls fail."""
    
    def __init__(self, message: str = "External service error", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details, 503)


# User Management Errors
class UserNotFoundError(NotFoundError):
    """Raised when a user is not found."""
    
    def __init__(self, message: str = "User not found", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class UserAlreadyExistsError(ConflictError):
    """Raised when trying to create a user that already exists."""
    
    def __init__(self, message: str = "User already exists", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class TenantAlreadyExistsError(ConflictError):
    """Raised when trying to create a user with a tenant ID that already exists."""
    
    def __init__(self, message: str = "Tenant already exists", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class InvalidUserDataError(ValidationError):
    """Raised when user data is invalid."""
    
    def __init__(self, message: str = "Invalid user data", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class InsufficientPermissionsError(AuthorizationError):
    """Raised when user lacks required permissions."""
    
    def __init__(self, message: str = "Insufficient permissions", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class ProfileUpdatePendingApprovalError(ConflictError):
    """Raised when profile update is pending approval."""
    
    def __init__(self, message: str = "Profile update pending approval", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class ApprovalRequiredError(AuthorizationError):
    """Raised when approval is required for an operation."""
    
    def __init__(self, message: str = "Approval required", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


class InvalidApproverError(AuthorizationError):
    """Raised when the approver is not authorized."""
    
    def __init__(self, message: str = "Invalid approver", details: Optional[Dict[str, Any]] = None):
        super().__init__(message, details)


# Territory Management Errors
class TerritoryNotFoundError(NotFoundError):
    """Raised when a territory is not found."""
    pass


class TerritoryAlreadyExistsError(ConflictError):
    """Raised when trying to create a territory that already exists."""
    pass


class InvalidTerritoryDataError(ValidationError):
    """Raised when territory data is invalid."""
    pass


# Shop Management Errors
class ShopNotFoundError(NotFoundError):
    """Raised when a shop is not found."""
    pass


class ShopAlreadyExistsError(ConflictError):
    """Raised when trying to create a shop that already exists."""
    pass


class InvalidShopDataError(ValidationError):
    """Raised when shop data is invalid."""
    pass


# Route Management Errors
class RouteNotFoundError(NotFoundError):
    """Raised when a route is not found."""
    pass


class RouteAlreadyExistsError(ConflictError):
    """Raised when trying to create a route that already exists."""
    pass


class InvalidRouteDataError(ValidationError):
    """Raised when route data is invalid."""
    pass


# Visit Management Errors
class VisitNotFoundError(NotFoundError):
    """Raised when a visit is not found."""
    pass


class VisitAlreadyExistsError(ConflictError):
    """Raised when trying to create a visit that already exists."""
    pass


class InvalidVisitDataError(ValidationError):
    """Raised when visit data is invalid."""
    pass


# OTP and SMS Errors
class OTPExpiredError(AuthenticationError):
    """Raised when OTP has expired."""
    pass


class OTPInvalidError(AuthenticationError):
    """Raised when OTP is invalid."""
    pass


class SMSSendError(ExternalServiceError):
    """Raised when SMS sending fails."""
    pass


# Data Layer Communication Errors
class DataLayerConnectionError(ExternalServiceError):
    """Raised when Data Layer service is unreachable."""
    pass


class DataLayerResponseError(ExternalServiceError):
    """Raised when Data Layer service returns an error."""
    pass


# Redis Errors
class RedisConnectionError(ExternalServiceError):
    """Raised when Redis connection fails."""
    pass


class RedisOperationError(ExternalServiceError):
    """Raised when Redis operations fail."""
    pass
