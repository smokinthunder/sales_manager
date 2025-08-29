"""
API dependencies for FastAPI routes.

Provides common dependencies like database sessions,
authentication, and authorization checks.
"""

from typing import Generator, Optional, Dict, Any
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from app.core.security import verify_token
from app.services.data_layer_client import get_data_layer_client
from app.core.logging import get_logger

logger = get_logger(__name__)

# Security scheme for JWT tokens
security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> Dict[str, Any]:
    """
    Get current authenticated user from JWT token.
    
    Args:
        credentials: HTTP authorization credentials
        
    Returns:
        Dict: Authenticated user data from Data Layer
        
    Raises:
        HTTPException: If token is invalid or user not found
    """
    token = credentials.credentials
    payload = verify_token(token)
    
    user_id = payload.get("sub")
    if not user_id:
        logger.warning("Token missing user ID")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token missing user ID",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    tenant_id = payload.get("tenant_id")
    if not tenant_id:
        logger.warning("Token missing tenant ID")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token missing tenant ID",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Get user from Data Layer service
    try:
        data_layer = await get_data_layer_client()
        users = await data_layer.get_users(tenant_id)
        
        user = None
        for u in users:
            if str(u.get("id")) == str(user_id):
                user = u
                break
        
        if not user:
            logger.warning("User not found", user_id=user_id, tenant_id=tenant_id)
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        # Check if user is not suspended or inactive
        if user.get("status") != "active":
            logger.warning("User account not active", user_id=user_id, status=user.get("status"))
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User account not active",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        logger.info(f"User authenticated: user {user.get('id')}, role {user.get('role')}")
        return user
        
    except Exception as e:
        logger.error("Error getting user from Data Layer", error=str(e))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )


async def get_current_active_user(current_user: Dict[str, Any] = Depends(get_current_user)) -> Dict[str, Any]:
    """
    Get current active user.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        Dict: Active user data
        
    Raises:
        HTTPException: If user is not active
    """
    if current_user.get("status") != "active":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Inactive user"
        )
    return current_user


def require_role(required_role: str):
    """
    Dependency factory for role-based access control.
    
    Args:
        required_role: Minimum required role level
        
    Returns:
        Dependency function that checks user role
    """
    def check_role(current_user: Dict[str, Any] = Depends(get_current_user)) -> Dict[str, Any]:
        """
        Check if current user has required role.
        
        Args:
            current_user: Current authenticated user
            
        Returns:
            Dict: User if role check passes
            
        Raises:
            HTTPException: If user lacks required role
        """
        role_hierarchy = {
            "sales_executive": 1,
            "area_manager": 2,
            "client_admin": 3,
            "superadmin": 4
        }
        
        user_level = role_hierarchy.get(current_user.get("role"), 0)
        required_level = role_hierarchy.get(required_role, 0)
        
        if user_level < required_level:
            logger.warning(
                "Insufficient role access",
                user_id=current_user.get("id"),
                user_role=current_user.get("role"),
                required_role=required_role
            )
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        
        return current_user
    
    return check_role


def require_superadmin(current_user: Dict[str, Any] = Depends(get_current_user)) -> Dict[str, Any]:
    """
    Require superadmin role for access.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        Dict: User if superadmin
        
    Raises:
        HTTPException: If user is not superadmin
    """
    if current_user.get("role") != "superadmin":
        logger.warning(
            "Superadmin access required",
            user_id=current_user.get("id"),
            user_role=current_user.get("role")
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Superadmin access required"
        )
    return current_user


def require_client_admin(current_user: Dict[str, Any] = Depends(get_current_user)) -> Dict[str, Any]:
    """
    Require client admin or higher role for access.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        Dict: User if client admin or higher
        
    Raises:
        HTTPException: If user lacks required role
    """
    if current_user.get("role") not in ["client_admin", "superadmin"]:
        logger.warning(
            "Client admin access required",
            user_id=current_user.get("id"),
            user_role=current_user.get("role")
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Client admin access required"
        )
    return current_user


def require_area_manager(current_user: Dict[str, Any] = Depends(get_current_user)) -> Dict[str, Any]:
    """
    Require area manager or higher role for access.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        Dict: User if area manager or higher
        
    Raises:
        HTTPException: If user lacks required role
    """
    if current_user.get("role") not in ["area_manager", "client_admin", "superadmin"]:
        logger.warning(
            "Area manager access required",
            user_id=current_user.get("id"),
            user_role=current_user.get("role")
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Area manager access required"
        )
    return current_user
