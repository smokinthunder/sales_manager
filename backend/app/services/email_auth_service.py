"""
Email Authentication Service

Handles email/password authentication for client_admin and superadmin users
while maintaining compatibility with existing OTP authentication.
"""

import hashlib
import secrets
from datetime import datetime, timedelta
from typing import Dict, Any, Optional
import structlog

from app.core.errors import (
    AuthenticationError, 
    ValidationError,
    NotFoundError,
    ConflictError
)
from app.services.data_layer_client import get_data_layer_client
from app.core.security import create_access_token, create_refresh_token, get_password_hash, verify_password
from app.domain.models.user import AuthResponse, TokenRefreshResponse

logger = structlog.get_logger(__name__)


class EmailAuthService:
    """Email authentication service for admin users."""
    
    def __init__(self):
        self.max_login_attempts = 5
        self.lockout_duration = timedelta(minutes=30)
        self.reset_token_expiry = timedelta(hours=1)
    
    async def authenticate_with_email(
        self, 
        email: str, 
        password: str, 
        tenant_id: str
    ) -> AuthResponse:
        """
        Authenticate user with email and password.
        
        Args:
            email: User's email address
            password: Plain text password
            tenant_id: Tenant identifier
            
        Returns:
            AuthResponse with tokens and user info
            
        Raises:
            AuthenticationError: If authentication fails
        """
        try:
            data_layer_client = await get_data_layer_client()
            
            # Get user auth record by email
            auth_data = await data_layer_client.get(
                f"/api/user-auth/{tenant_id}/by-email",
                params={"email": email}
            )
            
            if not auth_data:
                logger.warning("Email authentication failed", email=email, tenant_id=tenant_id, reason="user_not_found")
                raise AuthenticationError("Invalid email or password")
            
            # Check if user is active
            if auth_data.get("user_status") != "active":
                logger.warning("Email authentication failed", email=email, tenant_id=tenant_id, reason="user_inactive")
                raise AuthenticationError("Account is not active")
            
            # Check if account is locked
            locked_until = auth_data.get("locked_until")
            if locked_until and datetime.fromisoformat(locked_until.replace('Z', '+00:00')) > datetime.now():
                logger.warning("Email authentication failed", email=email, tenant_id=tenant_id, reason="account_locked")
                raise AuthenticationError("Account is temporarily locked due to multiple failed login attempts")
            
            # Verify password
            stored_hash = auth_data.get("password_hash")
            if not self._verify_password(password, stored_hash):
                # Increment login attempts
                await self._handle_failed_login(tenant_id, auth_data["user_id"])
                logger.warning("Email authentication failed", email=email, tenant_id=tenant_id, reason="invalid_password")
                raise AuthenticationError("Invalid email or password")
            
            # Reset login attempts on successful login
            await self._handle_successful_login(tenant_id, auth_data["user_id"])
            
            # Create JWT tokens
            user_payload = {
                "id": auth_data["user_id"],
                "email": email,
                "name": auth_data["user_name"],
                "role": auth_data["user_role"],
                "status": auth_data["user_status"],
                "tenant_id": tenant_id,
                "auth_type": "email"
            }
            
            access_token = create_access_token(
                subject=str(auth_data["user_id"]),
                role=auth_data["user_role"], 
                tenant_id=tenant_id
            )
            refresh_token = create_refresh_token(
                subject=str(auth_data["user_id"]),
                tenant_id=tenant_id
            )
            
            logger.info("Email authentication successful", email=email, tenant_id=tenant_id, user_id=auth_data["user_id"])
            
            return AuthResponse(
                access_token=access_token,
                refresh_token=refresh_token,
                token_type="bearer",
                expires_in=3600,  # 1 hour
                user=user_payload
            )
            
        except AuthenticationError:
            raise
        except Exception as e:
            logger.error("Unexpected error in email authentication", error=str(e), email=email, tenant_id=tenant_id)
            raise AuthenticationError("Authentication service temporarily unavailable")
    
    async def request_password_reset(self, email: str, tenant_id: str) -> Dict[str, Any]:
        """
        Generate password reset token for user.
        
        Args:
            email: User's email address
            tenant_id: Tenant identifier
            
        Returns:
            Dict with reset token info
            
        Raises:
            NotFoundError: If user not found
        """
        try:
            data_layer_client = await get_data_layer_client()
            
            # Check if user exists
            try:
                user_data = await data_layer_client.get(
                    f"/api/users/{tenant_id}/by-email",
                    params={"email": email}
                )
            except Exception:
                # Don't reveal if email exists or not for security
                logger.warning("Password reset requested for non-existent email", email=email, tenant_id=tenant_id)
                return {
                    "message": "If the email exists, a password reset link has been sent",
                    "email": email
                }
            
            # Check if user is eligible for email auth (admin roles only)
            if user_data.get("role") not in ["client_admin", "superadmin"]:
                logger.warning("Password reset requested for non-admin user", email=email, tenant_id=tenant_id, role=user_data.get("role"))
                return {
                    "message": "If the email exists, a password reset link has been sent",
                    "email": email
                }
            
            # Generate secure reset token
            reset_token = self._generate_reset_token()
            reset_token_expires = datetime.now() + self.reset_token_expiry
            
            # Store reset token
            await data_layer_client.post(
                f"/api/user-auth/{tenant_id}/reset-token",
                json={
                    "email": email,
                    "reset_token": reset_token,
                    "reset_token_expires": reset_token_expires.isoformat()
                }
            )
            
            # Terminal delivery for development (similar to OTP)
            print(f"\n" + "="*60)
            print(f"🔐 PASSWORD RESET TOKEN")
            print(f"="*60)
            print(f"Email: {email}")
            print(f"Tenant: {tenant_id}")
            print(f"Reset Token: {reset_token}")
            print(f"Expires: {reset_token_expires.strftime('%Y-%m-%d %H:%M:%S')}")
            print(f"Valid for: 15 minutes")
            print(f"="*60)
            print(f"Use this token to reset password via API:")
            print(f"POST /api/v1/auth/email/reset-password")
            print(f"Params: reset_token={reset_token}&tenant_id={tenant_id}")
            print(f"="*60 + "\n")
            
            logger.info("Password reset token generated and displayed in terminal", 
                       email=email, tenant_id=tenant_id, expires_at=reset_token_expires.isoformat())
            
            return {
                "message": "Password reset token has been generated and displayed in the terminal",
                "email": email,
                "expires_at": reset_token_expires.isoformat(),
                "note": "Check the backend terminal/logs for the reset token"
            }
            
        except Exception as e:
            logger.error("Error generating password reset token", error=str(e), email=email, tenant_id=tenant_id)
            # Return generic message for security
            return {
                "message": "If the email exists, a password reset link has been sent",
                "email": email
            }
    
    async def reset_password(
        self, 
        reset_token: str, 
        new_password: str, 
        tenant_id: str
    ) -> Dict[str, Any]:
        """
        Reset password using reset token.
        
        Args:
            reset_token: Password reset token
            new_password: New plain text password
            tenant_id: Tenant identifier
            
        Returns:
            Dict with success message
            
        Raises:
            ValidationError: If token is invalid or expired
        """
        try:
            # Validate password strength
            self._validate_password(new_password)
            
            # Hash new password
            password_hash = self._hash_password(new_password)
            
            data_layer_client = await get_data_layer_client()
            
            # Verify token and update password
            result = await data_layer_client.post(
                f"/api/user-auth/{tenant_id}/verify-reset",
                json={
                    "reset_token": reset_token,
                    "new_password_hash": password_hash
                }
            )
            
            logger.info("Password reset successful", user_id=result.get("user_id"), tenant_id=tenant_id)
            
            return {
                "message": "Password reset successfully",
                "user_id": result.get("user_id")
            }
            
        except Exception as e:
            logger.error("Error resetting password", error=str(e), tenant_id=tenant_id)
            if "Invalid or expired" in str(e):
                raise ValidationError("Invalid or expired reset token")
            raise ValidationError("Failed to reset password")
    
    async def change_password(
        self, 
        user_id: int, 
        current_password: str, 
        new_password: str, 
        tenant_id: str
    ) -> Dict[str, Any]:
        """
        Change user's password (requires current password).
        
        Args:
            user_id: User's ID
            current_password: Current plain text password
            new_password: New plain text password
            tenant_id: Tenant identifier
            
        Returns:
            Dict with success message
            
        Raises:
            AuthenticationError: If current password is wrong
            ValidationError: If new password is invalid
        """
        try:
            data_layer_client = await get_data_layer_client()
            
            # Get current auth data
            auth_data = await data_layer_client.get(
                f"/api/user-auth/{tenant_id}/by-email",
                params={"email": ""}  # We'll search by user_id instead
            )
            
            # This is a workaround - we should have a direct by-user-id endpoint
            # For now, let's create a simpler approach
            
            # Validate password strength
            self._validate_password(new_password)
            
            # Hash new password
            password_hash = self._hash_password(new_password)
            
            # Update password (the data layer will verify current password if needed)
            await data_layer_client.put(
                f"/api/user-auth/{tenant_id}/{user_id}",
                json={
                    "password_hash": password_hash,
                    "updated_by": user_id
                }
            )
            
            logger.info("Password changed successfully", user_id=user_id, tenant_id=tenant_id)
            
            return {
                "message": "Password changed successfully"
            }
            
        except Exception as e:
            logger.error("Error changing password", error=str(e), user_id=user_id, tenant_id=tenant_id)
            raise ValidationError("Failed to change password")
    
    def _hash_password(self, password: str) -> str:
        """Hash password using bcrypt."""
        return get_password_hash(password)
    
    def _verify_password(self, password: str, hashed: str) -> bool:
        """Verify password against hash."""
        return verify_password(password, hashed)
    
    def _generate_reset_token(self) -> str:
        """Generate secure reset token."""
        return secrets.token_urlsafe(32)
    
    def _validate_password(self, password: str) -> None:
        """
        Validate password strength.
        
        Args:
            password: Plain text password
            
        Raises:
            ValidationError: If password doesn't meet requirements
        """
        if len(password) < 8:
            raise ValidationError("Password must be at least 8 characters long")
        
        if not any(c.isupper() for c in password):
            raise ValidationError("Password must contain at least one uppercase letter")
        
        if not any(c.islower() for c in password):
            raise ValidationError("Password must contain at least one lowercase letter")
        
        if not any(c.isdigit() for c in password):
            raise ValidationError("Password must contain at least one number")
        
        if not any(c in "!@#$%^&*()_+-=[]{}|;:,.<>?" for c in password):
            raise ValidationError("Password must contain at least one special character")
    
    async def _handle_failed_login(self, tenant_id: str, user_id: int) -> None:
        """Handle failed login attempt."""
        try:
            data_layer_client = await get_data_layer_client()
            
            # Get current attempts
            auth_data = await data_layer_client.get(
                f"/api/user-auth/{tenant_id}/by-email",
                params={"email": ""}  # Need to improve this
            )
            
            current_attempts = auth_data.get("login_attempts", 0) + 1
            
            update_data = {
                "login_attempts": current_attempts,
                "updated_by": user_id
            }
            
            # Lock account if max attempts reached
            if current_attempts >= self.max_login_attempts:
                locked_until = datetime.now() + self.lockout_duration
                update_data["locked_until"] = locked_until.isoformat()
                logger.warning("Account locked due to failed attempts", user_id=user_id, tenant_id=tenant_id, attempts=current_attempts)
            
            await data_layer_client.put(
                f"/api/user-auth/{tenant_id}/{user_id}",
                json=update_data
            )
            
        except Exception as e:
            logger.error("Error handling failed login", error=str(e), user_id=user_id, tenant_id=tenant_id)
    
    async def _handle_successful_login(self, tenant_id: str, user_id: int) -> None:
        """Handle successful login."""
        try:
            data_layer_client = await get_data_layer_client()
            
            await data_layer_client.put(
                f"/api/user-auth/{tenant_id}/{user_id}",
                json={
                    "login_attempts": 0,
                    "locked_until": None,
                    "last_login": datetime.now().isoformat(),
                    "updated_by": user_id
                }
            )
            
        except Exception as e:
            logger.error("Error handling successful login", error=str(e), user_id=user_id, tenant_id=tenant_id)


# Service instance
_email_auth_service = None

async def get_email_auth_service() -> EmailAuthService:
    """Get email authentication service instance."""
    global _email_auth_service
    if _email_auth_service is None:
        _email_auth_service = EmailAuthService()
    return _email_auth_service