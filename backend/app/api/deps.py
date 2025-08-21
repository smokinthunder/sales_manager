"""
API dependencies for FastAPI routes.

Provides common dependencies like database sessions,
authentication, and authorization checks.
"""

from typing import Generator, Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import verify_token
from app.domain.models.user import User, UserRole
from app.core.logging import get_logger

logger = get_logger(__name__)

# Security scheme for JWT tokens
security = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """
    Get current authenticated user from JWT token.
    
    Args:
        credentials: HTTP authorization credentials
        db: Database session
        
    Returns:
        User: Authenticated user instance
        
    Raises:
        HTTPException: If token is invalid or user not found
    """
    token = credentials.credentials
    payload = verify_token(token)
    
    if not payload:
        logger.warning("Invalid authentication token")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    user_id = payload.get("sub")
    if not user_id:
        logger.warning("Token missing user ID")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token missing user ID",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    user = db.get(User, int(user_id))
    if not user:
        logger.warning("User not found", user_id=user_id)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if user.status != "active":
        logger.warning("User account not active", user_id=user_id, status=user.status)
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User account not active",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    logger.info("User authenticated", user_id=user.id, role=user.role)
    return user


def get_current_active_user(current_user: User = Depends(get_current_user)) -> User:
    """
    Get current active user.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        User: Active user instance
        
    Raises:
        HTTPException: If user is not active
    """
    if current_user.status != "active":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Inactive user"
        )
    return current_user


def require_role(required_role: UserRole):
    """
    Dependency factory for role-based access control.
    
    Args:
        required_role: Minimum required role level
        
    Returns:
        Dependency function that checks user role
    """
    def check_role(current_user: User = Depends(get_current_user)) -> User:
        """
        Check if current user has required role.
        
        Args:
            current_user: Current authenticated user
            
        Returns:
            User: User if role check passes
            
        Raises:
            HTTPException: If user lacks required role
        """
        role_hierarchy = {
            UserRole.SALES_EXECUTIVE: 1,
            UserRole.AREA_MANAGER: 2,
            UserRole.CLIENT_ADMIN: 3,
            UserRole.SUPERADMIN: 4
        }
        
        user_level = role_hierarchy.get(current_user.role, 0)
        required_level = role_hierarchy.get(required_role, 0)
        
        if user_level < required_level:
            logger.warning(
                "Insufficient role access",
                user_id=current_user.id,
                user_role=current_user.role,
                required_role=required_role
            )
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions"
            )
        
        return current_user
    
    return check_role


def require_superadmin(current_user: User = Depends(get_current_user)) -> User:
    """
    Require superadmin role for access.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        User: User if superadmin
        
    Raises:
        HTTPException: If user is not superadmin
    """
    if current_user.role != UserRole.SUPERADMIN:
        logger.warning(
            "Superadmin access required",
            user_id=current_user.id,
            user_role=current_user.role
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Superadmin access required"
        )
    return current_user


def require_client_admin(current_user: User = Depends(get_current_user)) -> User:
    """
    Require client admin or higher role for access.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        User: User if client admin or higher
        
    Raises:
        HTTPException: If user lacks required role
    """
    if current_user.role not in [UserRole.CLIENT_ADMIN, UserRole.SUPERADMIN]:
        logger.warning(
            "Client admin access required",
            user_id=current_user.id,
            user_role=current_user.role
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Client admin access required"
        )
    return current_user


def require_area_manager(current_user: User = Depends(get_current_user)) -> User:
    """
    Require area manager or higher role for access.
    
    Args:
        current_user: Current authenticated user
        
    Returns:
        User: User if area manager or higher
        
    Raises:
        HTTPException: If user lacks required role
    """
    if current_user.role not in [UserRole.AREA_MANAGER, UserRole.CLIENT_ADMIN, UserRole.SUPERADMIN]:
        logger.warning(
            "Area manager access required",
            user_id=current_user.id,
            user_role=current_user.role
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Area manager access required"
        )
    return current_user
