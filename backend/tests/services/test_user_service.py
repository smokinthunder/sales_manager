"""
Tests for User Service layer.

Tests business logic, validation, and authorization checks.
"""

import pytest
from unittest.mock import AsyncMock, patch
from app.services.user_service import UserService
from app.core.errors import (
    InsufficientPermissionsError,
    UserNotFoundError,
    UserAlreadyExistsError,
    InvalidUserDataError
)


class TestUserService:
    """Test class for User Service."""
    
    @pytest.fixture
    def user_service(self):
        """Create UserService instance for testing."""
        return UserService()
    
    @pytest.fixture
    def mock_data_layer(self):
        """Mock Data Layer client."""
        mock = AsyncMock()
        
        mock_user = {
            "id": "1",
            "phone": "+919876543210",
            "name": "Test User",
            "email": "test@example.com",
            "role": "sales_executive",
            "status": "active",
            "tenant_id": "test_tenant"
        }
        
        mock.get_user_by_phone.return_value = None  # No existing user
        mock.get_user_by_id.return_value = mock_user
        mock.create_user.return_value = mock_user
        
        return mock
    
    @pytest.fixture
    def sales_executive_user(self):
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
    def client_admin_user(self):
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
    def superadmin_user(self):
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
    
    @pytest.mark.asyncio
    async def test_create_user_success(self, user_service, mock_data_layer, client_admin_user):
        """Test successful user creation by admin."""
        user_service.data_layer = mock_data_layer
        
        from app.domain.models.user import UserCreate
        
        user_data = UserCreate(
            phone="+919876543210",
            name="New User",
            email="new@example.com",
            role="sales_executive",
            tenant_id="test_tenant"
        )
        
        result = await user_service.create_user(user_data, client_admin_user)
        
        assert result["phone"] == user_data.phone
        assert result["name"] == user_data.name
        assert result["role"] == user_data.role
        mock_data_layer.get_user_by_phone.assert_called_once()
        mock_data_layer.create_user.assert_called_once()
    
    @pytest.mark.asyncio
    async def test_create_user_insufficient_permissions(self, user_service, sales_executive_user):
        """Test user creation with insufficient permissions."""
        from app.domain.models.user import UserCreate
        
        user_data = UserCreate(
            phone="+919876543210",
            name="New User",
            email="new@example.com",
            role="sales_executive",
            tenant_id="test_tenant"
        )
        
        with pytest.raises(InsufficientPermissionsError) as exc_info:
            await user_service.create_user(user_data, sales_executive_user)
        
        assert "Insufficient permissions to create users" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_create_user_already_exists(self, user_service, mock_data_layer, client_admin_user):
        """Test user creation when user already exists."""
        user_service.data_layer = mock_data_layer
        
        # Mock existing user
        mock_data_layer.get_user_by_phone.return_value = {"id": "1", "phone": "+919876543210"}
        
        from app.domain.models.user import UserCreate
        
        user_data = UserCreate(
            phone="+919876543210",
            name="New User",
            email="new@example.com",
            role="sales_executive",
            tenant_id="test_tenant"
        )
        
        with pytest.raises(UserAlreadyExistsError) as exc_info:
            await user_service.create_user(user_data, client_admin_user)
        
        assert "already exists" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_get_user_success(self, user_service, mock_data_layer, client_admin_user):
        """Test successful user retrieval."""
        user_service.data_layer = mock_data_layer
        
        result = await user_service.get_user("1", "test_tenant", client_admin_user)
        
        assert result["id"] == "1"
        mock_data_layer.get_user_by_id.assert_called_once_with("1", "test_tenant")
    
    @pytest.mark.asyncio
    async def test_get_user_insufficient_permissions(self, user_service, sales_executive_user):
        """Test user retrieval with insufficient permissions."""
        with pytest.raises(InsufficientPermissionsError) as exc_info:
            await user_service.get_user("2", "test_tenant", sales_executive_user)
        
        assert "Insufficient permissions to view this user" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_get_user_not_found(self, user_service, mock_data_layer, client_admin_user):
        """Test user retrieval when user not found."""
        user_service.data_layer = mock_data_layer
        mock_data_layer.get_user_by_id.return_value = None
        
        with pytest.raises(UserNotFoundError) as exc_info:
            await user_service.get_user("999", "test_tenant", client_admin_user)
        
        assert "not found" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_get_users_success(self, user_service, mock_data_layer, client_admin_user):
        """Test successful user listing."""
        user_service.data_layer = mock_data_layer
        
        result = await user_service.get_users("test_tenant", client_admin_user)
        
        assert isinstance(result, list)
        mock_data_layer.get_users.assert_called_once_with("test_tenant")
    
    @pytest.mark.asyncio
    async def test_get_users_insufficient_permissions(self, user_service, sales_executive_user):
        """Test user listing with insufficient permissions."""
        with pytest.raises(InsufficientPermissionsError) as exc_info:
            await user_service.get_users("test_tenant", sales_executive_user)
        
        assert "Insufficient permissions to list users" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_get_users_with_filters(self, user_service, mock_data_layer, client_admin_user):
        """Test user listing with filters."""
        user_service.data_layer = mock_data_layer
        
        # Mock users with different roles
        mock_data_layer.get_users.return_value = [
            {"id": "1", "role": "sales_executive", "status": "active", "name": "User 1", "phone": "123"},
            {"id": "2", "role": "area_manager", "status": "active", "name": "User 2", "phone": "456"},
            {"id": "3", "role": "sales_executive", "status": "inactive", "name": "User 3", "phone": "789"}
        ]
        
        # Test role filter
        result = await user_service.get_users("test_tenant", client_admin_user, role="sales_executive")
        assert len(result) == 2
        assert all(user["role"] == "sales_executive" for user in result)
        
        # Test status filter
        result = await user_service.get_users("test_tenant", client_admin_user, status="active")
        assert len(result) == 2
        assert all(user["status"] == "active" for user in result)
        
        # Test search filter
        result = await user_service.get_users("test_tenant", client_admin_user, search="User 1")
        assert len(result) == 1
        assert result[0]["name"] == "User 1"
    
    @pytest.mark.asyncio
    async def test_update_user_superadmin(self, user_service, mock_data_layer, superadmin_user):
        """Test user update by superadmin (auto-approved)."""
        user_service.data_layer = mock_data_layer
        
        from app.domain.models.user import UserUpdate
        
        user_data = UserUpdate(name="Updated Name", email="updated@example.com")
        
        result = await user_service.update_user("1", user_data, "test_tenant", superadmin_user)
        
        assert result["status"] == "completed"
        assert result["approval_required"] is False
        assert result["user"]["name"] == "Updated Name"
    
    @pytest.mark.asyncio
    async def test_update_user_by_admin(self, user_service, mock_data_layer, client_admin_user):
        """Test user update by admin (auto-approved)."""
        user_service.data_layer = mock_data_layer
        
        from app.domain.models.user import UserUpdate
        
        user_data = UserUpdate(status="suspended")
        
        result = await user_service.update_user("1", user_data, "test_tenant", client_admin_user)
        
        assert result["status"] == "completed"
        assert result["approval_required"] is False
        assert result["user"]["status"] == "suspended"
    
    @pytest.mark.asyncio
    async def test_update_user_self_approval_required(self, user_service, mock_data_layer, sales_executive_user):
        """Test user self-update requiring approval."""
        user_service.data_layer = mock_data_layer
        
        from app.domain.models.user import UserUpdate
        
        user_data = UserUpdate(name="Updated Name")
        
        result = await user_service.update_user("1", user_data, "test_tenant", sales_executive_user)
        
        assert result["status"] == "pending_approval"
        assert result["approval_required"] is True
        assert "request_id" in result
    
    @pytest.mark.asyncio
    async def test_update_user_insufficient_permissions(self, user_service, sales_executive_user):
        """Test user update with insufficient permissions."""
        from app.domain.models.user import UserUpdate
        
        user_data = UserUpdate(name="Updated Name")
        
        with pytest.raises(InsufficientPermissionsError) as exc_info:
            await user_service.update_user("2", user_data, "test_tenant", sales_executive_user)
        
        assert "Insufficient permissions to update this user" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_delete_user_success(self, user_service, mock_data_layer, client_admin_user):
        """Test successful user deletion."""
        user_service.data_layer = mock_data_layer
        
        result = await user_service.delete_user("1", "test_tenant", client_admin_user)
        
        assert result is True
    
    @pytest.mark.asyncio
    async def test_delete_user_insufficient_permissions(self, user_service, sales_executive_user):
        """Test user deletion with insufficient permissions."""
        with pytest.raises(InsufficientPermissionsError) as exc_info:
            await user_service.delete_user("2", "test_tenant", sales_executive_user)
        
        assert "Insufficient permissions to delete users" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_delete_user_self(self, user_service, sales_executive_user):
        """Test user self-deletion prevention."""
        with pytest.raises(InvalidUserDataError) as exc_info:
            await user_service.delete_user("1", "test_tenant", sales_executive_user)
        
        assert "Cannot delete your own account" in str(exc_info.value)
    
    @pytest.mark.asyncio
    async def test_get_user_profile(self, user_service, sales_executive_user):
        """Test user profile retrieval."""
        result = await user_service.get_user_profile(sales_executive_user)
        
        assert result == sales_executive_user
    
    @pytest.mark.asyncio
    async def test_update_user_profile(self, user_service, mock_data_layer, sales_executive_user):
        """Test user profile update."""
        user_service.data_layer = mock_data_layer
        
        from app.domain.models.user import UserUpdate
        
        user_data = UserUpdate(name="Updated Name", email="updated@example.com")
        
        result = await user_service.update_user_profile(user_data, sales_executive_user)
        
        assert result["status"] == "pending_approval"
        assert result["approval_required"] is True
