"""
Security utilities for authentication and authorization.

Handles JWT token creation/validation, password hashing,
and OTP generation for the application.
"""

from datetime import datetime, timedelta
from typing import Optional, Union, Any, Dict
from jose import JWTError, jwt
import bcrypt
import secrets
import structlog

from app.core.config import settings
from app.core.errors import AuthenticationError

logger = structlog.get_logger(__name__)


def create_access_token(
    subject: Union[str, Any], 
    expires_delta: Optional[timedelta] = None,
    role: Optional[str] = None,
    tenant_id: Optional[str] = None
) -> str:
    """Create JWT access token."""
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.access_token_expire_minutes
        )
    
    to_encode = {"exp": expire, "sub": str(subject)}
    if role:
        to_encode["role"] = role
    if tenant_id:
        to_encode["tenant_id"] = tenant_id
    
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.secret_key,
        algorithm=settings.algorithm
    )
    return encoded_jwt


def create_refresh_token(
    subject: Union[str, Any], 
    expires_delta: Optional[timedelta] = None,
    tenant_id: Optional[str] = None
) -> str:
    """Create JWT refresh token."""
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            days=settings.refresh_token_expire_days
        )
    
    to_encode = {"exp": expire, "sub": str(subject), "type": "refresh"}
    if tenant_id:
        to_encode["tenant_id"] = tenant_id
    
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.secret_key,
        algorithm=settings.algorithm
    )
    return encoded_jwt


def verify_token(token: str) -> Dict[str, Any]:
    """Verify JWT token and return payload."""
    try:
        payload = jwt.decode(
            token, 
            settings.secret_key,
            algorithms=[settings.algorithm]
        )
        return payload
    except JWTError:
        raise AuthenticationError(message="Invalid token")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify plain password against hash.
    
    Args:
        plain_password: Plain text password
        hashed_password: Hashed password from database
        
    Returns:
        bool: True if password matches, False otherwise
    """
    try:
        # Ensure password is under 72 bytes for bcrypt
        if len(plain_password.encode('utf-8')) > 72:
            plain_password = plain_password[:72]
        return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))
    except Exception as e:
        logger.warning("Password verification failed", error=str(e))
        return False


def get_password_hash(password: str) -> str:
    """
    Hash password using bcrypt.
    
    Args:
        password: Plain text password
        
    Returns:
        str: Hashed password
    """
    try:
        # Ensure password is under 72 bytes for bcrypt
        if len(password.encode('utf-8')) > 72:
            password = password[:72]
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
        return hashed.decode('utf-8')
    except Exception as e:
        logger.error("Password hashing failed", error=str(e))
        raise


def generate_otp(length: int = 6) -> str:
    """
    Generate numeric OTP.
    
    Args:
        length: Length of OTP (default: 6)
        
    Returns:
        str: Generated OTP string
    """
    return ''.join(secrets.choice('0123456789') for _ in range(length))


def generate_secure_token(length: int = 32) -> str:
    """
    Generate cryptographically secure random token.
    
    Args:
        length: Length of token in bytes (default: 32)
        
    Returns:
        str: Hex-encoded secure token
    """
    return secrets.token_hex(length)
