"""
Authentication service for user management.

Handles user registration, OTP generation/validation,
JWT token management, and session handling.
"""

from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from fastapi import HTTPException, status
import structlog

from app.core.security import (
    create_access_token, create_refresh_token, verify_token,
    get_password_hash, generate_otp
)
from app.core.errors import (
    AuthenticationError, OTPExpiredError, OTPInvalidError, NotFoundError
)
from app.core.redis_client import get_redis_client
from app.core.config import settings
from app.domain.models.user import User, UserCreate, UserLogin, UserOTP, UserRole, UserStatus
from app.services.data_layer_client import get_data_layer_client

logger = structlog.get_logger(__name__)


class AuthService:
    """Authentication service for user management."""
    
    def __init__(self):
        """Initialize authentication service."""
        self.otp_expiry_minutes = 10
        self.max_otp_attempts = 3
        self.otp_lockout_minutes = 15
    
    async def generate_otp(self, phone: str, tenant_id: str) -> Dict[str, Any]:
        """
        Generate OTP for user authentication.
        
        Args:
            phone: User's phone number
            tenant_id: Tenant identifier
            
        Returns:
            Dictionary with OTP details
            
        Raises:
            NotFoundError: If user is not registered
            OTPExpiredError: If OTP generation fails
        """
        try:
            # Check if user exists
            data_layer = await get_data_layer_client()
            user = await data_layer.get_user_by_phone(phone, tenant_id)
            
            if not user:
                raise NotFoundError(message="User not registered. Please contact your administrator.")
            
            # Generate OTP
            otp = generate_otp()
            expires_at = datetime.utcnow() + timedelta(minutes=self.otp_expiry_minutes)
            
            # Store OTP in Redis with expiry
            redis_client = await get_redis_client()
            otp_key = f"otp:{phone}:{tenant_id}"
            
            # Check OTP attempt limits
            attempts_key = f"otp_attempts:{phone}:{tenant_id}"
            current_attempts = await redis_client.get(attempts_key) or 0
            
            if current_attempts >= self.max_otp_attempts:
                # Check if lockout period has passed
                lockout_key = f"otp_lockout:{phone}:{tenant_id}"
                lockout_until = await redis_client.get(lockout_key)
                
                if lockout_until and datetime.fromisoformat(lockout_until) > datetime.utcnow():
                    raise OTPExpiredError(
                        message="Too many OTP attempts. Please try again later.",
                        details={"lockout_until": lockout_until}
                    )
                else:
                    # Reset attempts after lockout period
                    await redis_client.delete(attempts_key)
                    current_attempts = 0
            
            # Store OTP
            otp_data = {
                "otp": otp,
                "expires_at": expires_at.isoformat(),
                "attempts": current_attempts
            }
            
            await redis_client.set(otp_key, otp_data, expire=self.otp_expiry_minutes * 60)
            
            # Send OTP via SMS (in production) or log to console (development)
            if settings.is_development:
                logger.info("Development OTP", phone=phone, otp=otp, tenant_id=tenant_id)
            else:
                # TODO: Implement SMS sending
                pass
            
            return {
                "message": "OTP sent successfully",
                "phone": phone,
                "expires_in_minutes": self.otp_expiry_minutes,
                "is_new_user": user.get("status") == UserStatus.PENDING_APPROVAL.value
            }
            
        except Exception as e:
            logger.error("Failed to generate OTP", error=str(e), phone=phone)
            if isinstance(e, (OTPExpiredError, NotFoundError)):
                raise
            raise OTPExpiredError(message="Failed to generate OTP", details={"error": str(e)})
    
    async def verify_otp(self, phone: str, otp: str, tenant_id: str) -> Dict[str, Any]:
        """
        Verify OTP and authenticate user.
        
        Args:
            phone: User's phone number
            otp: One-time password
            tenant_id: Tenant identifier
            
        Returns:
            Dictionary with authentication tokens and user info
            
        Raises:
            OTPExpiredError: If OTP verification fails
            AuthenticationError: If authentication fails
        """
        try:
            # Get OTP from Redis
            redis_client = await get_redis_client()
            otp_key = f"otp:{phone}:{tenant_id}"
            stored_otp_data = await redis_client.get(otp_key)
            
            if not stored_otp_data:
                raise OTPExpiredError(message="OTP expired or not found")
            
            # Check OTP attempts
            attempts_key = f"otp_attempts:{phone}:{tenant_id}"
            current_attempts = await redis_client.get(attempts_key) or 0
            
            if current_attempts >= self.max_otp_attempts:
                # Set lockout
                lockout_until = datetime.utcnow() + timedelta(minutes=self.otp_lockout_minutes)
                lockout_key = f"otp_lockout:{phone}:{tenant_id}"
                await redis_client.set(lockout_key, lockout_until.isoformat(), expire=self.otp_lockout_minutes * 60)
                
                raise OTPExpiredError(
                    message="Too many OTP attempts. Account temporarily locked.",
                    details={"lockout_until": lockout_until.isoformat()}
                )
            
            # Verify OTP
            if stored_otp_data["otp"] != otp:
                # Increment attempts
                await redis_client.increment(attempts_key, 1)
                await redis_client.expire(attempts_key, 60 * 60)  # 1 hour expiry
                
                raise OTPExpiredError(message="Invalid OTP")
            
            # OTP is valid - get user
            data_layer = await get_data_layer_client()
            user = await data_layer.get_user_by_phone(phone, tenant_id)
            
            if not user:
                raise NotFoundError(message="User not found")
            
            # Check user status
            if user["status"] == UserStatus.SUSPENDED:
                raise AuthenticationError(message="Account is suspended")
            
            if user["status"] == UserStatus.INACTIVE:
                raise AuthenticationError(message="Account is inactive")
            
            # Clear OTP and attempts
            await redis_client.delete(otp_key)
            await redis_client.delete(attempts_key)
            
            # Generate tokens
            access_token = create_access_token(
                subject=user["id"],
                expires_delta=timedelta(minutes=settings.access_token_expire_minutes),
                role=user["role"],
                tenant_id=user["tenant_id"]
            )
            
            refresh_token = create_refresh_token(
                subject=user["id"],
                expires_delta=timedelta(days=settings.refresh_token_expire_days),
                tenant_id=user["tenant_id"]
            )
            
            # Store refresh token in Redis
            refresh_key = f"refresh_token:{user['id']}:{tenant_id}"
            await redis_client.set(
                refresh_key, 
                refresh_token, 
                expire=settings.refresh_token_expire_days * 24 * 60 * 60
            )
            
            logger.info(f"User authenticated successfully: user {user['id']}, phone {phone}")
            
            return {
                "access_token": access_token,
                "refresh_token": refresh_token,
                "token_type": "bearer",
                "expires_in": settings.access_token_expire_minutes * 60,
                "user": {
                    "id": user["id"],
                    "phone": user["phone"],
                    "name": user["name"],
                    "role": user["role"],
                    "status": user["status"],
                    "tenant_id": user["tenant_id"]
                }
            }
            
        except Exception as e:
            logger.error("Authentication failed", error=str(e), phone=phone, tenant_id=tenant_id)
            if isinstance(e, (OTPExpiredError, AuthenticationError, NotFoundError)):
                raise
            raise AuthenticationError(message="Authentication failed", details={"error": str(e)})
    
    async def refresh_token(self, refresh_token: str) -> Dict[str, Any]:
        """
        Refresh access token using refresh token.
        
        Args:
            refresh_token: Valid refresh token
            
        Returns:
            Dictionary with new access token
            
        Raises:
            AuthenticationError: If refresh fails
        """
        try:
            # Verify refresh token
            payload = verify_token(refresh_token)
            if not payload or payload.get("type") != "refresh":
                raise AuthenticationError(message="Invalid refresh token")
            
            user_id = payload.get("sub")
            if not user_id:
                raise AuthenticationError(message="Invalid refresh token")
            
            # Check if refresh token exists in Redis
            redis_client = await get_redis_client()
            refresh_key = f"refresh_token:{user_id}:{payload.get('tenant_id', 'unknown')}"
            stored_refresh = await redis_client.get(refresh_key)
            
            if not stored_refresh or stored_refresh != refresh_token:
                raise AuthenticationError(message="Invalid refresh token")
            
            # Get user from Data Layer
            data_layer = await get_data_layer_client()
            user = await data_layer.get_user_by_id(user_id, payload.get("tenant_id", "unknown"))
            
            if not user:
                raise AuthenticationError(message="User not found")
            
            if user["status"] != "active":
                raise AuthenticationError(message="User account not active")
            
            # Generate new access token
            new_access_token = create_access_token(
                subject=user["id"],
                expires_delta=timedelta(minutes=settings.access_token_expire_minutes),
                role=user["role"],
                tenant_id=user["tenant_id"]
            )
            
            logger.info(f"Access token refreshed: user {user['id']}")
            
            return {
                "access_token": new_access_token,
                "token_type": "bearer",
                "expires_in": settings.access_token_expire_minutes * 60
            }
            
        except Exception as e:
            logger.error("Token refresh failed", error=str(e), context={"refresh_token": refresh_token[:10] + "..."})
            if isinstance(e, AuthenticationError):
                raise
            raise AuthenticationError(message="Token refresh failed", details={"error": str(e)})
    
    async def logout(self, user_id: int, tenant_id: str) -> Dict[str, str]:
        """
        Logout user by invalidating refresh token.
        
        Args:
            user_id: User ID to logout
            tenant_id: Tenant ID for the user
            
        Returns:
            Success message
        """
        try:
            redis_client = await get_redis_client()
            refresh_key = f"refresh_token:{user_id}:{tenant_id}"
            
            # Remove refresh token
            await redis_client.delete(refresh_key)
            
            logger.info(f"User logged out: user {user_id}, tenant {tenant_id}")
            
            return {"message": "Logged out successfully"}
            
        except Exception as e:
            logger.error("Logout failed", error=str(e), context={"user_id": user_id})
            # Don't raise error for logout failures
            return {"message": "Logged out successfully"}
    
    async def validate_token(self, token: str) -> Dict[str, Any]:
        """
        Validate access token and return user info.
        
        Args:
            token: JWT access token
            
        Returns:
            Token payload with user information
            
        Raises:
            AuthenticationError: If token is invalid
        """
        try:
            payload = verify_token(token)
            if not payload or payload.get("type") != "access":
                raise AuthenticationError(message="Invalid access token")
            
            user_id = payload.get("sub")
            if not user_id:
                raise AuthenticationError(message="Invalid access token")
            
            # Get user from Data Layer
            data_layer = await get_data_layer_client()
            user = await data_layer.get_user_by_id(user_id, payload.get("tenant_id", "unknown"))
            
            if not user:
                raise AuthenticationError(message="User not found")
            
            if user["status"] != "active":
                raise AuthenticationError(message="User account not active")
            
            return {
                "user_id": user["id"],
                "phone": user["phone"],
                "role": user["role"],
                "tenant_id": user["tenant_id"],
                "exp": payload.get("exp"),
                "iat": payload.get("iat")
            }
            
        except Exception as e:
            logger.error("Token validation failed", error=str(e), context={"token": token[:10] + "..."})
            if isinstance(e, AuthenticationError):
                raise
            raise AuthenticationError(message="Token validation failed", details={"error": str(e)})


# Global auth service instance
auth_service = AuthService()


async def get_auth_service() -> AuthService:
    """
    Get authentication service instance.
    
    Returns:
        AuthService instance
    """
    return auth_service
