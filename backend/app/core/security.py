"""
Security utilities for authentication and authorization.

Handles JWT token creation/validation, password hashing,
and OTP generation for the application.
"""

from datetime import datetime, timedelta
from typing import Optional, Union, Any
from jose import JWTError, jwt
from passlib.context import CryptContext
import secrets
import structlog

from app.core.config import settings

logger = structlog.get_logger(__name__)

# Password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def create_access_token(
    subject: Union[str, Any], 
    expires_delta: Optional[timedelta] = None,
    **kwargs
) -> str:
    """
    Create JWT access token.
    
    Args:
        subject: Subject claim (usually user ID)
        expires_delta: Optional custom expiration time
        **kwargs: Additional claims to include in token
        
    Returns:
        str: Encoded JWT token
        
    Note:
        Token includes standard claims: sub, exp, iat, type
        Additional claims can be passed as kwargs.
    """
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.security.access_token_expire_minutes
        )
    
    to_encode = {
        "exp": expire,
        "sub": str(subject),
        "iat": datetime.utcnow(),
        "type": "access",
        **kwargs
    }
    
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.security.secret_key, 
        algorithm=settings.security.algorithm
    )
    
    logger.info("Access token created", subject=subject, expires_at=expire)
    return encoded_jwt


def create_refresh_token(
    subject: Union[str, Any],
    expires_delta: Optional[timedelta] = None
) -> str:
    """
    Create JWT refresh token.
    
    Args:
        subject: Subject claim (usually user ID)
        expires_delta: Optional custom expiration time
        
    Returns:
        str: Encoded JWT refresh token
    """
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            days=settings.security.refresh_token_expire_days
        )
    
    to_encode = {
        "exp": expire,
        "sub": str(subject),
        "iat": datetime.utcnow(),
        "type": "refresh"
    }
    
    encoded_jwt = jwt.encode(
        to_encode, 
        settings.security.secret_key, 
        algorithm=settings.security.algorithm
    )
    
    logger.info("Refresh token created", subject=subject, expires_at=expire)
    return encoded_jwt


def verify_token(token: str) -> Optional[dict]:
    """
    Verify and decode JWT token.
    
    Args:
        token: JWT token to verify
        
    Returns:
        Optional[dict]: Decoded token payload if valid, None otherwise
        
    Note:
        Logs security events for invalid tokens.
    """
    try:
        payload = jwt.decode(
            token, 
            settings.security.secret_key, 
            algorithms=[settings.security.algorithm]
        )
        return payload
    except JWTError as e:
        logger.warning("Invalid JWT token", error=str(e))
        return None


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """
    Verify plain password against hash.
    
    Args:
        plain_password: Plain text password
        hashed_password: Hashed password from database
        
    Returns:
        bool: True if password matches, False otherwise
    """
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """
    Hash password using bcrypt.
    
    Args:
        password: Plain text password
        
    Returns:
        str: Hashed password
    """
    return pwd_context.hash(password)


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
