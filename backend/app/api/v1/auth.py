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
    AuthenticationError, OTPExpiredError, OTPInvalidError, NotFoundError
)
from app.services.auth_service import get_auth_service, AuthService
from app.domain.models.user import (
    UserLogin, UserOTP, 
    OTPGenerateRequest, OTPVerifyRequest, TokenRefreshRequest,
    AuthResponse, OTPResponse, TokenRefreshResponse
)
from app.core.rate_limit import create_rate_limit_dependency
from app.api.deps import get_current_user
from app.core.redis_client import get_redis_client

logger = structlog.get_logger(__name__)

router = APIRouter()
security = HTTPBearer()

# Rate limiting for authentication endpoints
rate_limit_auth = create_rate_limit_dependency(limit=5)  # 5 requests per minute


@router.post("/otp/generate", response_model=OTPResponse)
async def generate_otp(
    request: OTPGenerateRequest,
    auth_service: AuthService = Depends(get_auth_service),
    _: None = Depends(rate_limit_auth)
):
    """
    Generate OTP for user authentication.
    
    Args:
        request: OTP generation request with phone and tenant_id
        auth_service: Authentication service dependency
        
    Returns:
        OTP generation result with expiration time
        
    Raises:
        HTTPException: If OTP generation fails
    """
    try:
        result = await auth_service.generate_otp(request.phone, request.tenant_id)
        
        logger.info("OTP generated successfully", phone=request.phone, tenant_id=request.tenant_id)
        return result
        
    except OTPExpiredError as e:
        logger.warning("OTP generation failed", phone=request.phone, tenant_id=request.tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )
    except Exception as e:
        logger.error("Unexpected error in OTP generation", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/otp/verify", response_model=AuthResponse)
async def verify_otp(
    request: OTPVerifyRequest,
    auth_service: AuthService = Depends(get_auth_service),
    _: None = Depends(rate_limit_auth)
):
    """
    Verify OTP and authenticate user.
    
    Args:
        request: OTP verification request with phone, otp, and tenant_id
        auth_service: Authentication service dependency
        
    Returns:
        Authentication result with access and refresh tokens
        
    Raises:
        HTTPException: If OTP verification fails
    """
    try:
        result = await auth_service.verify_otp(request.phone, request.otp, request.tenant_id)
        
        logger.info("OTP verified successfully", phone=request.phone, tenant_id=request.tenant_id)
        return result
        
    except OTPExpiredError as e:
        logger.warning("OTP verification failed", phone=request.phone, tenant_id=request.tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )
    except AuthenticationError as e:
        logger.warning("Authentication failed", phone=request.phone, tenant_id=request.tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message)
        )
    except NotFoundError as e:
        logger.warning("User not found", phone=request.phone, tenant_id=request.tenant_id, error=str(e))
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=str(e.message)
        )
    except Exception as e:
        logger.error("Unexpected error in OTP verification", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/token/refresh", response_model=TokenRefreshResponse)
async def refresh_token(
    request: TokenRefreshRequest,
    auth_service: AuthService = Depends(get_auth_service),
    _: None = Depends(rate_limit_auth)
):
    """
    Refresh access token using refresh token.
    
    Args:
        request: Token refresh request with refresh_token
        auth_service: Authentication service dependency
        
    Returns:
        New access and refresh tokens
        
    Raises:
        HTTPException: If token refresh fails
    """
    try:
        result = await auth_service.refresh_token(request.refresh_token)
        
        logger.info("Token refreshed successfully")
        return result
        
    except AuthenticationError as e:
        logger.warning("Token refresh failed", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=str(e.message)
        )
    except Exception as e:
        logger.error("Unexpected error in token refresh", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.post("/logout")
async def logout(
    current_user: Dict[str, Any] = Depends(get_current_user),
    auth_service: AuthService = Depends(get_auth_service)
):
    """
    Logout user by invalidating refresh token.
    
    Args:
        current_user: Current authenticated user from token
        auth_service: Authentication service dependency
        
    Returns:
        Logout success message
        
    Raises:
        HTTPException: If logout fails
    """
    try:
        user_id = current_user.get("id")
        tenant_id = current_user.get("tenant_id")
        
        result = await auth_service.logout(user_id, tenant_id)
        
        logger.info(f"User logged out successfully: user {user_id}")
        return result
        
    except Exception as e:
        logger.error("Unexpected error in logout", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


@router.get("/me")
async def get_current_user_info(
    current_user: Dict[str, Any] = Depends(get_current_user)
):
    """
    Get current user information from token.
    
    Args:
        current_user: Current authenticated user from token
        
    Returns:
        Current user information
        
    Raises:
        HTTPException: If token validation fails
    """
    try:
        logger.info(f"User info retrieved successfully: user {current_user.get('id')}")
        return {
            "id": current_user.get("id"),
            "phone": current_user.get("phone"),
            "name": current_user.get("name"),
            "role": current_user.get("role"),
            "status": current_user.get("status"),
            "tenant_id": current_user.get("tenant_id"),
            "created_at": current_user.get("created_at"),
            "updated_at": current_user.get("updated_at")
        }
        
    except Exception as e:
        logger.error("Unexpected error getting user info", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )
