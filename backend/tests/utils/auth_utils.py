"""
Authentication utilities for testing.

Provides helper functions for creating test tokens and managing authentication in tests.
"""

import jwt
from datetime import datetime, timedelta
from typing import Dict, Any


def create_test_jwt_token(
    user_id: str = "1",
    role: str = "sales_executive",
    tenant_id: str = "test_tenant",
    expires_in: int = 1800
) -> str:
    """
    Create a test JWT token for testing purposes.
    
    Args:
        user_id: User ID to include in token
        role: User role to include in token
        tenant_id: Tenant ID to include in token
        expires_in: Token expiration time in seconds
        
    Returns:
        JWT token string
    """
    payload = {
        "sub": user_id,
        "role": role,
        "tenant_id": tenant_id,
        "exp": datetime.utcnow() + timedelta(seconds=expires_in),
        "iat": datetime.utcnow()
    }
    
    # Use a test secret key
    secret_key = "test_secret_key_for_testing_only"
    
    return jwt.encode(payload, secret_key, algorithm="HS256")


def create_test_refresh_token(
    user_id: str = "1",
    tenant_id: str = "test_tenant",
    expires_in: int = 604800
) -> str:
    """
    Create a test refresh token for testing purposes.
    
    Args:
        user_id: User ID to include in token
        tenant_id: Tenant ID to include in token
        expires_in: Token expiration time in seconds
        
    Returns:
        JWT refresh token string
    """
    payload = {
        "sub": user_id,
        "type": "refresh",
        "tenant_id": tenant_id,
        "exp": datetime.utcnow() + timedelta(seconds=expires_in),
        "iat": datetime.utcnow()
    }
    
    # Use a test secret key
    secret_key = "test_secret_key_for_testing_only"
    
    return jwt.encode(payload, secret_key, algorithm="HS256")


def get_auth_headers(token: str) -> Dict[str, str]:
    """
    Get authorization headers for API requests.
    
    Args:
        token: JWT token to include in headers
        
    Returns:
        Dictionary with authorization headers
    """
    return {"Authorization": f"Bearer {token}"}


def create_test_user_payload(
    phone: str = "+919876543210",
    name: str = "Test User",
    email: str = "test@example.com",
    role: str = "sales_executive",
    tenant_id: str = "test_tenant"
) -> Dict[str, Any]:
    """
    Create test user payload for API requests.
    
    Args:
        phone: User phone number
        name: User name
        email: User email
        role: User role
        tenant_id: Tenant ID
        
    Returns:
        Dictionary with user data
    """
    return {
        "phone": phone,
        "name": name,
        "email": email,
        "role": role,
        "tenant_id": tenant_id
    }


def create_test_user_update_payload(
    name: str = None,
    email: str = None,
    role: str = None,
    status: str = None
) -> Dict[str, Any]:
    """
    Create test user update payload for API requests.
    
    Args:
        name: New name (optional)
        email: New email (optional)
        role: New role (optional)
        status: New status (optional)
        
    Returns:
        Dictionary with update data
    """
    payload = {}
    
    if name is not None:
        payload["name"] = name
    if email is not None:
        payload["email"] = email
    if role is not None:
        payload["role"] = role
    if status is not None:
        payload["status"] = status
        
    return payload
