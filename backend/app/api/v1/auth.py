"""
Authentication API endpoints.

Handles user authentication, OTP generation/verification,
token refresh, and logout functionality.
"""

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer
from typing import Dict, Any
import structlog

from app.core.errors import (
    AuthenticationError, OTPError, NotFoundError,
    create_error_response
)
from app.services.auth_service import get_auth_service, AuthService
from app.domain.models.user import UserLogin, UserOTP
from app.core.rate_limit import create_rate_limit_dependency

logger = structlog.get_logger(__name__)

router = APIRouter()
security = HTTPBearer()

# Rate limiting for authentication endpoints
rate_limit_auth = create_rate_limit_dependency(limit=5)  # 5 requests per minute


@router.post("/otp/generate")
async def generate_otp(
    request: Dict[str, Any],
    auth_service: AuthService = Depends(get_auth_service),
    _: None = Depends(rate_limit_auth)
):
    """
    Generate OTP for user authentication.
    
    Args:
        request: Dictionary with phone and tenant_id
        auth_service: Authentication service dependency
        
    Returns:
        OTP generation result
        
    Raises:
        HTTPException: If OTP generation fails
    """
    try:
        phone = request.get("phone")
        tenant_id = request.get("tenant_id")
        
        if not phone or not tenant_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Phone and tenant_id are required"
            )
        
        result = await auth_service.generate_otp(phone, tenant_id)
        
        logger.info("OTP generated successfully", phone=phone, tenant_id=tenant_id)
        return result
        
    except OTPError as e:
        logger.warning("OTP generation failed", phone=phone, tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except Exception as e:
        logger.error("Unexpected error in OTP generation", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/otp/verify")
async def verify_otp(
    request: Dict[str, Any],
    auth_service: AuthService = Depends(get_auth_service),
    _: None = Depends(rate_limit_auth)
):
    """
    Verify OTP and authenticate user.
    
    Args:
        request: Dictionary with phone, otp, and tenant_id
        auth_service: Authentication service dependency
        
    Returns:
        Authentication result with tokens
        
    Raises:
        HTTPException: If OTP verification fails
    """
    try:
        phone = request.get("phone")
        otp = request.get("otp")
        tenant_id = request.get("tenant_id")
        
        if not phone or not otp or not tenant_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Phone, OTP, and tenant_id are required"
            )
        
        result = await auth_service.verify_otp(phone, otp, tenant_id)
        
        logger.info("OTP verified successfully", phone=phone, tenant_id=tenant_id)
        return result
        
    except OTPError as e:
        logger.warning("OTP verification failed", phone=phone, tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except AuthenticationError as e:
        logger.warning("Authentication failed", phone=phone, tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except NotFoundError as e:
        logger.warning("User not found", phone=phone, tenant_id=tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except Exception as e:
        logger.error("Unexpected error in OTP verification", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/token/refresh")
async def refresh_token(
    request: Dict[str, Any],
    auth_service: AuthService = Depends(get_auth_service),
    _: None = Depends(rate_limit_auth)
):
    """
    Refresh access token using refresh token.
    
    Args:
        request: Dictionary with refresh_token
        auth_service: Authentication service dependency
        
    Returns:
        New access token
        
    Raises:
        HTTPException: If token refresh fails
    """
    try:
        refresh_token = request.get("refresh_token")
        
        if not refresh_token:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Refresh token is required"
            )
        
        result = await auth_service.refresh_token(refresh_token)
        
        logger.info("Token refreshed successfully")
        return result
        
    except AuthenticationError as e:
        logger.warning("Token refresh failed", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except Exception as e:
        logger.error("Unexpected error in token refresh", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/logout")
async def logout(
    auth_service: AuthService = Depends(get_auth_service),
    current_user: Dict[str, Any] = Depends(security)
):
    """
    Logout user by invalidating refresh token.
    
    Args:
        auth_service: Authentication service dependency
        current_user: Current authenticated user from token
        
    Returns:
        Logout success message
        
    Raises:
        HTTPException: If logout fails
    """
    try:
        # Extract user ID from token
        token = current_user.credentials
        user_info = await auth_service.validate_token(token)
        user_id = user_info["user_id"]
        
        result = await auth_service.logout(user_id)
        
        logger.info("User logged out successfully", user_id=user_id)
        return result
        
    except AuthenticationError as e:
        logger.warning("Logout failed", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except Exception as e:
        logger.error("Unexpected error in logout", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.get("/me")
async def get_current_user_info(
    auth_service: AuthService = Depends(get_auth_service),
    current_user: Dict[str, Any] = Depends(security)
):
    """
    Get current user information from token.
    
    Args:
        auth_service: Authentication service dependency
        current_user: Current authenticated user from token
        
    Returns:
        Current user information
        
    Raises:
        HTTPException: If token validation fails
    """
    try:
        token = current_user.credentials
        user_info = await auth_service.validate_token(token)
        
        logger.info("User info retrieved successfully", user_id=user_info["user_id"])
        return user_info
        
    except AuthenticationError as e:
        logger.warning("Token validation failed", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message),
            headers={"X-Error-Code": e.error_code}
        )
    except Exception as e:
        logger.error("Unexpected error getting user info", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )
