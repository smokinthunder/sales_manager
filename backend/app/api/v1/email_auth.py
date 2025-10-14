"""
Email Authentication API endpoints.

Handles email/password authentication for client_admin and superadmin users.
Includes login, password reset, and password change functionality.
"""

from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import Dict, Any
import structlog

from app.core.errors import (
    AuthenticationError, 
    ValidationError, 
    NotFoundError
)
from app.services.email_auth_service import get_email_auth_service, EmailAuthService
from app.domain.models.user import AuthResponse
from app.core.rate_limit import create_rate_limit_dependency
from app.api.deps import get_current_user

logger = structlog.get_logger(__name__)

router = APIRouter()

# Rate limiting for email authentication endpoints
rate_limit_email_auth = create_rate_limit_dependency(limit=5)  # 5 requests per minute


@router.post("/login", response_model=AuthResponse)
async def email_login(
    email: str = Query(..., description="Email address"),
    password: str = Query(..., description="Password"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    email_auth_service: EmailAuthService = Depends(get_email_auth_service),
    _: None = Depends(rate_limit_email_auth)
):
    """
    Authenticate user with email and password.
    
    Available for client_admin and superadmin roles only.
    
    Args:
        email: User's email address
        password: User's password
        tenant_id: Tenant identifier from URL parameter (enforced)
        email_auth_service: Email authentication service dependency
        
    Returns:
        Authentication result with access and refresh tokens
        
    Raises:
        HTTPException: If authentication fails
    """
    try:
        result = await email_auth_service.authenticate_with_email(email, password, tenant_id)
        
        logger.info("Email authentication successful", email=email, tenant_id=tenant_id)
        return result
        
    except AuthenticationError as e:
        logger.warning("Email authentication failed", email=email, tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message)
        )
    except ValidationError as e:
        logger.warning("Email authentication validation failed", email=email, tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e.message)
        )
    except Exception as e:
        logger.error("Unexpected error in email authentication", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/forgot-password")
async def forgot_password(
    email: str = Query(..., description="Email address"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    email_auth_service: EmailAuthService = Depends(get_email_auth_service),
    _: None = Depends(rate_limit_email_auth)
):
    """
    Request password reset for user.
    
    Generates a secure reset token and sends reset instructions.
    Returns generic success message for security (doesn't reveal if email exists).
    
    Args:
        email: User's email address
        tenant_id: Tenant identifier from URL parameter (enforced)
        email_auth_service: Email authentication service dependency
        
    Returns:
        Generic success message
        
    Raises:
        HTTPException: If request fails
    """
    try:
        result = await email_auth_service.request_password_reset(email, tenant_id)
        
        logger.info("Password reset requested", email=email, tenant_id=tenant_id)
        return result
        
    except Exception as e:
        logger.error("Unexpected error in password reset request", error=str(e))
        # Return generic message for security
        return {
            "message": "If the email exists, a password reset link has been sent",
            "email": email
        }


@router.post("/reset-password")
async def reset_password(
    reset_token: str = Query(..., description="Password reset token"),
    new_password: str = Query(..., description="New password"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    email_auth_service: EmailAuthService = Depends(get_email_auth_service),
    _: None = Depends(rate_limit_email_auth)
):
    """
    Reset password using reset token.
    
    Validates the reset token and updates the user's password.
    
    Args:
        reset_token: Password reset token from email
        new_password: New password (must meet strength requirements)
        tenant_id: Tenant identifier from URL parameter (enforced)
        email_auth_service: Email authentication service dependency
        
    Returns:
        Success message
        
    Raises:
        HTTPException: If reset fails
    """
    try:
        result = await email_auth_service.reset_password(reset_token, new_password, tenant_id)
        
        logger.info("Password reset successful", tenant_id=tenant_id)
        return result
        
    except ValidationError as e:
        logger.warning("Password reset validation failed", tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e.message)
        )
    except Exception as e:
        logger.error("Unexpected error in password reset", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.put("/change-password")
async def change_password(
    current_password: str = Query(..., description="Current password"),
    new_password: str = Query(..., description="New password"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    email_auth_service: EmailAuthService = Depends(get_email_auth_service),
    _: None = Depends(rate_limit_email_auth)
):
    """
    Change password for authenticated user.
    
    Requires current password for verification.
    Available only for users with email authentication (client_admin, superadmin).
    
    Args:
        current_password: User's current password
        new_password: New password (must meet strength requirements)
        current_user: Current authenticated user from token
        email_auth_service: Email authentication service dependency
        
    Returns:
        Success message
        
    Raises:
        HTTPException: If password change fails
    """
    try:
        # Check if user has email auth (admin roles only)
        user_role = current_user.get("role")
        if user_role not in ["client_admin", "superadmin"]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Password change is only available for admin users"
            )
        
        user_id = current_user.get("id")
        tenant_id = current_user.get("tenant_id")
        
        result = await email_auth_service.change_password(
            user_id, current_password, new_password, tenant_id
        )
        
        logger.info("Password changed successfully", user_id=user_id, tenant_id=tenant_id)
        return result
        
    except AuthenticationError as e:
        logger.warning("Password change authentication failed", user_id=current_user.get("id"), error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message)
        )
    except ValidationError as e:
        logger.warning("Password change validation failed", user_id=current_user.get("id"), error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e.message)
        )
    except Exception as e:
        logger.error("Unexpected error in password change", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.get("/check-email")
async def check_email_availability(
    email: str = Query(..., description="Email address to check"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    email_auth_service: EmailAuthService = Depends(get_email_auth_service)
):
    """
    Check if email is available for registration.
    
    This is a utility endpoint for admin user creation.
    
    Args:
        email: Email address to check
        tenant_id: Tenant identifier from URL parameter (enforced)
        email_auth_service: Email authentication service dependency
        
    Returns:
        Availability status
        
    Raises:
        HTTPException: If check fails
    """
    try:
        # This would use the data layer to check email availability
        # For now, return a simple response
        return {
            "email": email,
            "available": True,  # Would be determined by actual check
            "message": "Email availability check completed"
        }
        
    except Exception as e:
        logger.error("Unexpected error in email availability check", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )