"""
Pytest configuration and fixtures for Sales Manager Backend tests.

This file contains shared fixtures and configuration for all tests.
"""

import pytest
import asyncio
from typing import Dict, Any, Generator
from fastapi.testclient import TestClient
from unittest.mock import AsyncMock, MagicMock

from app.main import app
from app.core.config import settings
from app.services.data_layer_client import get_data_layer_client
from app.services.auth_service import get_auth_service
from app.services.user_service import get_user_service
from app.services.approval_service import get_approval_service


@pytest.fixture(scope="session")
def event_loop():
    """Create an instance of the default event loop for the test session."""
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture
def client() -> TestClient:
    """Create a test client for the FastAPI application."""
    return TestClient(app)


@pytest.fixture
def mock_data_layer() -> AsyncMock:
    """Mock Data Layer client for testing."""
    mock = AsyncMock()
    
    # Mock user data
    mock_user = {
        "id": "1",
        "phone": "+919876543210",
        "name": "Test User",
        "email": "test@example.com",
        "role": "sales_executive",
        "status": "active",
        "tenant_id": "test_tenant",
        "created_at": "2025-08-28T10:00:00",
        "updated_at": "2025-08-28T10:00:00",
        "created_by": None,
        "updated_by": None
    }
    
    mock_admin_user = {
        "id": "2",
        "phone": "+919876543211",
        "name": "Admin User",
        "email": "admin@example.com",
        "role": "client_admin",
        "status": "active",
        "tenant_id": "test_tenant",
        "created_at": "2025-08-28T10:00:00",
        "updated_at": "2025-08-28T10:00:00",
        "created_by": None,
        "updated_by": None
    }
    
    mock_superadmin_user = {
        "id": "3",
        "phone": "+919876543212",
        "name": "Super Admin",
        "email": "superadmin@example.com",
        "role": "superadmin",
        "status": "active",
        "tenant_id": "test_tenant",
        "created_at": "2025-08-28T10:00:00",
        "updated_at": "2025-08-28T10:00:00",
        "created_by": None,
        "updated_by": None
    }
    
    # Mock methods
    mock.get_user_by_phone.return_value = mock_user
    mock.get_user_by_id.return_value = mock_user
    mock.get_users.return_value = [mock_user, mock_admin_user, mock_superadmin_user]
    mock.create_user.return_value = mock_user
    
    return mock


@pytest.fixture
def mock_auth_service() -> AsyncMock:
    """Mock Auth Service for testing."""
    mock = AsyncMock()
    
    # Mock OTP generation
    mock.generate_otp.return_value = {
        "message": "OTP sent successfully",
        "phone": "+919876543210",
        "expires_in_minutes": 10,
        "is_new_user": False
    }
    
    # Mock OTP verification
    mock.verify_otp.return_value = {
        "access_token": "test_access_token",
        "refresh_token": "test_refresh_token",
        "token_type": "bearer",
        "expires_in": 1800,
        "user": {
            "id": "1",
            "phone": "+919876543210",
            "name": "Test User",
            "role": "sales_executive",
            "status": "active",
            "tenant_id": "test_tenant"
        }
    }
    
    return mock


@pytest.fixture
def mock_user_service() -> AsyncMock:
    """Mock User Service for testing."""
    mock = AsyncMock()
    
    mock_user = {
        "id": "1",
        "phone": "+919876543210",
        "name": "Test User",
        "email": "test@example.com",
        "role": "sales_executive",
        "status": "active",
        "tenant_id": "test_tenant",
        "created_at": "2025-08-28T10:00:00",
        "updated_at": "2025-08-28T10:00:00",
        "created_by": None,
        "updated_by": None
    }
    
    # Mock methods
    mock.create_user.return_value = mock_user
    mock.get_user.return_value = mock_user
    mock.get_users.return_value = [mock_user]
    mock.update_user.return_value = mock_user
    mock.delete_user.return_value = True
    mock.get_user_profile.return_value = mock_user
    mock.update_user_profile.return_value = {
        "status": "pending_approval",
        "message": "Profile update request submitted and pending approval",
        "request_id": "req_123",
        "approval_required": True,
        "user": None
    }
    
    return mock


@pytest.fixture
def mock_approval_service() -> AsyncMock:
    """Mock Approval Service for testing."""
    mock = AsyncMock()
    
    # Mock approval request creation
    mock.create_profile_update_request.return_value = {
        "id": "req_123",
        "user_id": "1",
        "requested_by": "1",
        "update_data": {"name": "New Name"},
        "status": "pending",
        "created_at": "2025-08-28T10:00:00",
        "tenant_id": "test_tenant"
    }
    
    # Mock approval methods
    mock.approve_profile_update.return_value = {
        "status": "approved",
        "message": "Profile update approved successfully",
        "approved_by": "2",
        "approved_at": "2025-08-28T10:00:00"
    }
    
    mock.reject_profile_update.return_value = {
        "status": "rejected",
        "message": "Profile update rejected",
        "rejected_by": "2",
        "rejected_at": "2025-08-28T10:00:00",
        "reason": "Invalid data"
    }
    
    mock.get_pending_approvals.return_value = []
    mock.get_user_approval_history.return_value = []
    
    return mock


@pytest.fixture
def test_user_data() -> Dict[str, Any]:
    """Test user data for creating users."""
    return {
        "phone": "+919876543210",
        "name": "Test User",
        "email": "test@example.com",
        "role": "sales_executive",
        "tenant_id": "test_tenant"
    }


@pytest.fixture
def test_user_update_data() -> Dict[str, Any]:
    """Test user update data."""
    return {
        "name": "Updated Name",
        "email": "updated@example.com"
    }


@pytest.fixture
def sales_executive_user() -> Dict[str, Any]:
    """Sales executive user for testing."""
    return {
        "id": "1",
        "phone": "+919876543210",
        "name": "Sales Executive",
        "email": "sales@example.com",
        "role": "sales_executive",
        "status": "active",
        "tenant_id": "test_tenant"
    }


@pytest.fixture
def client_admin_user() -> Dict[str, Any]:
    """Client admin user for testing."""
    return {
        "id": "2",
        "phone": "+919876543211",
        "name": "Client Admin",
        "email": "admin@example.com",
        "role": "client_admin",
        "status": "active",
        "tenant_id": "test_tenant"
    }


@pytest.fixture
def superadmin_user() -> Dict[str, Any]:
    """Superadmin user for testing."""
    return {
        "id": "3",
        "phone": "+919876543212",
        "name": "Super Admin",
        "email": "superadmin@example.com",
        "role": "superadmin",
        "status": "active",
        "tenant_id": "test_tenant"
    }


@pytest.fixture
def mock_jwt_token() -> str:
    """Mock JWT token for testing."""
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test_token"


# Override dependencies for testing
def override_get_data_layer_client():
    """Override Data Layer client dependency for testing."""
    return mock_data_layer()


def override_get_auth_service():
    """Override Auth Service dependency for testing."""
    return mock_auth_service()


def override_get_user_service():
    """Override User Service dependency for testing."""
    return mock_user_service()


def override_get_approval_service():
    """Override Approval Service dependency for testing."""
    return mock_approval_service()


# Apply dependency overrides
app.dependency_overrides[get_data_layer_client] = override_get_data_layer_client
app.dependency_overrides[get_auth_service] = override_get_auth_service
app.dependency_overrides[get_user_service] = override_get_user_service
app.dependency_overrides[get_approval_service] = override_get_approval_service
