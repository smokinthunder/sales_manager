"""
Tests for User Management API endpoints.

Tests all CRUD operations, profile management, and approval workflow endpoints.
"""

import pytest
from fastapi.testclient import TestClient
from unittest.mock import AsyncMock, patch

from tests.utils.auth_utils import (
    create_test_jwt_token,
    get_auth_headers,
    create_test_user_payload,
    create_test_user_update_payload
)


class TestUserManagementAPI:
    """Test class for User Management API endpoints."""
    
    def test_create_user_success(self, client: TestClient):
        """Test successful user creation by admin."""
        # Create token for client_admin
        token = create_test_jwt_token(user_id="2", role="client_admin")
        headers = get_auth_headers(token)
        
        user_data = create_test_user_payload()
        
        response = client.post("/api/v1/users/", json=user_data, headers=headers)
        
        assert response.status_code == 201
        data = response.json()
        assert data["phone"] == user_data["phone"]
        assert data["name"] == user_data["name"]
        assert data["role"] == user_data["role"]
        assert data["tenant_id"] == user_data["tenant_id"]
    
    def test_create_user_insufficient_permissions(self, client: TestClient):
        """Test user creation with insufficient permissions."""
        # Create token for sales_executive (should not have permission)
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        user_data = create_test_user_payload()
        
        response = client.post("/api/v1/users/", json=user_data, headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_create_user_unauthorized(self, client: TestClient):
        """Test user creation without authentication."""
        user_data = create_test_user_payload()
        
        response = client.post("/api/v1/users/", json=user_data)
        
        assert response.status_code == 401
    
    def test_get_users_success(self, client: TestClient):
        """Test successful user listing by admin."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
        assert len(data) > 0
    
    def test_get_users_with_filters(self, client: TestClient):
        """Test user listing with filters."""
        # Create token for client_admin
        token = create_test_jwt_token(user_id="2", role="client_admin")
        headers = get_auth_headers(token)
        
        # Test with role filter
        response = client.get(
            "/api/v1/users/?tenant_id=test_tenant&role=sales_executive",
            headers=headers
        )
        
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
    
    def test_get_users_insufficient_permissions(self, client: TestClient):
        """Test user listing with insufficient permissions."""
        # Create token for sales_executive (should not have permission)
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_get_user_by_id_success(self, client: TestClient):
        """Test successful user retrieval by ID."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/1?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "1"
    
    def test_get_user_by_id_own_profile(self, client: TestClient):
        """Test user can view their own profile."""
        # Create token for sales_executive
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/1?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "1"
    
    def test_get_user_by_id_insufficient_permissions(self, client: TestClient):
        """Test user retrieval with insufficient permissions."""
        # Create token for sales_executive trying to view another user
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/2?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_get_user_profile_success(self, client: TestClient):
        """Test successful profile retrieval."""
        # Create token for sales_executive
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/profile/me", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["id"] == "1"
        assert data["role"] == "sales_executive"
    
    def test_get_user_profile_unauthorized(self, client: TestClient):
        """Test profile retrieval without authentication."""
        response = client.get("/api/v1/users/profile/me")
        
        assert response.status_code == 401
    
    def test_update_user_profile_success(self, client: TestClient):
        """Test successful profile update with approval workflow."""
        # Create token for sales_executive
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        update_data = create_test_user_update_payload(name="New Name", email="new@example.com")
        
        response = client.put("/api/v1/users/profile/me", json=update_data, headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "pending_approval"
        assert data["approval_required"] is True
        assert "request_id" in data
    
    def test_update_user_profile_unauthorized(self, client: TestClient):
        """Test profile update without authentication."""
        update_data = create_test_user_update_payload(name="New Name")
        
        response = client.put("/api/v1/users/profile/me", json=update_data)
        
        assert response.status_code == 401
    
    def test_update_user_by_admin_success(self, client: TestClient):
        """Test successful user update by admin."""
        # Create token for client_admin
        token = create_test_jwt_token(user_id="2", role="client_admin")
        headers = get_auth_headers(token)
        
        update_data = create_test_user_update_payload(status="suspended")
        
        response = client.put("/api/v1/users/1?tenant_id=test_tenant", json=update_data, headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "completed"
        assert data["approval_required"] is False
    
    def test_update_user_insufficient_permissions(self, client: TestClient):
        """Test user update with insufficient permissions."""
        # Create token for sales_executive trying to update another user
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        update_data = create_test_user_update_payload(status="suspended")
        
        response = client.put("/api/v1/users/2?tenant_id=test_tenant", json=update_data, headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_delete_user_success(self, client: TestClient):
        """Test successful user deletion by admin."""
        # Create token for client_admin
        token = create_test_jwt_token(user_id="2", role="client_admin")
        headers = get_auth_headers(token)
        
        response = client.delete("/api/v1/users/1?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 204
    
    def test_delete_user_insufficient_permissions(self, client: TestClient):
        """Test user deletion with insufficient permissions."""
        # Create token for sales_executive (should not have permission)
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.delete("/api/v1/users/2?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_get_user_by_phone_success(self, client: TestClient):
        """Test successful user search by phone."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/by-phone/+919876543210?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert data["phone"] == "+919876543210"
    
    def test_get_user_by_phone_insufficient_permissions(self, client: TestClient):
        """Test user search by phone with insufficient permissions."""
        # Create token for sales_executive (should not have permission)
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/by-phone/+919876543210?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_bulk_status_update_success(self, client: TestClient):
        """Test successful bulk status update."""
        # Create token for client_admin
        token = create_test_jwt_token(user_id="2", role="client_admin")
        headers = get_auth_headers(token)
        
        bulk_data = {
            "user_ids": ["1", "2"],
            "new_status": "suspended"
        }
        
        response = client.post(
            "/api/v1/users/bulk-status-update?tenant_id=test_tenant",
            json=bulk_data,
            headers=headers
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "updated_count" in data
        assert "total_count" in data
    
    def test_bulk_status_update_insufficient_permissions(self, client: TestClient):
        """Test bulk status update with insufficient permissions."""
        # Create token for sales_executive (should not have permission)
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        bulk_data = {
            "user_ids": ["1", "2"],
            "new_status": "suspended"
        }
        
        response = client.post(
            "/api/v1/users/bulk-status-update?tenant_id=test_tenant",
            json=bulk_data,
            headers=headers
        )
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]


class TestApprovalWorkflowAPI:
    """Test class for Approval Workflow API endpoints."""
    
    def test_get_pending_approvals_success(self, client: TestClient):
        """Test successful pending approvals retrieval."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/approvals/pending?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert "pending_approvals" in data
        assert "count" in data
    
    def test_get_pending_approvals_insufficient_permissions(self, client: TestClient):
        """Test pending approvals retrieval with insufficient permissions."""
        # Create token for sales_executive (should not have permission)
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/approvals/pending?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]
    
    def test_approve_profile_update_success(self, client: TestClient):
        """Test successful profile update approval."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.post(
            "/api/v1/users/approvals/req_123/approve?tenant_id=test_tenant",
            headers=headers
        )
        
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "approved"
    
    def test_reject_profile_update_success(self, client: TestClient):
        """Test successful profile update rejection."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.post(
            "/api/v1/users/approvals/req_123/reject?reason=Invalid data&tenant_id=test_tenant",
            headers=headers
        )
        
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "rejected"
    
    def test_get_approval_history_success(self, client: TestClient):
        """Test successful approval history retrieval."""
        # Create token for area_manager
        token = create_test_jwt_token(user_id="2", role="area_manager")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/approvals/history/1?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert "approval_history" in data
        assert "count" in data
    
    def test_get_own_approval_history_success(self, client: TestClient):
        """Test successful own approval history retrieval."""
        # Create token for sales_executive
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/approvals/history/1?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 200
        data = response.json()
        assert "approval_history" in data
        assert "count" in data
    
    def test_get_approval_history_insufficient_permissions(self, client: TestClient):
        """Test approval history retrieval with insufficient permissions."""
        # Create token for sales_executive trying to view another user's history
        token = create_test_jwt_token(user_id="1", role="sales_executive")
        headers = get_auth_headers(token)
        
        response = client.get("/api/v1/users/approvals/history/2?tenant_id=test_tenant", headers=headers)
        
        assert response.status_code == 403
        assert "Insufficient permissions" in response.json()["detail"]


class TestAuthenticationAPI:
    """Test class for Authentication API endpoints."""
    
    def test_generate_otp_success(self, client: TestClient):
        """Test successful OTP generation."""
        otp_data = {
            "phone": "+919876543210",
            "tenant_id": "test_tenant"
        }
        
        response = client.post("/api/v1/auth/otp/generate", json=otp_data)
        
        assert response.status_code == 200
        data = response.json()
        assert data["message"] == "OTP sent successfully"
        assert data["phone"] == otp_data["phone"]
    
    def test_generate_otp_missing_data(self, client: TestClient):
        """Test OTP generation with missing data."""
        otp_data = {
            "phone": "+919876543210"
            # Missing tenant_id
        }
        
        response = client.post("/api/v1/auth/otp/generate", json=otp_data)
        
        assert response.status_code == 400
        assert "Phone and tenant_id are required" in response.json()["detail"]
    
    def test_verify_otp_success(self, client: TestClient):
        """Test successful OTP verification."""
        otp_data = {
            "phone": "+919876543210",
            "otp": "123456",
            "tenant_id": "test_tenant"
        }
        
        response = client.post("/api/v1/auth/otp/verify", json=otp_data)
        
        assert response.status_code == 200
        data = response.json()
        assert "access_token" in data
        assert "refresh_token" in data
        assert data["token_type"] == "bearer"
    
    def test_verify_otp_missing_data(self, client: TestClient):
        """Test OTP verification with missing data."""
        otp_data = {
            "phone": "+919876543210"
            # Missing otp and tenant_id
        }
        
        response = client.post("/api/v1/auth/otp/verify", json=otp_data)
        
        assert response.status_code == 400
        assert "Phone, otp, and tenant_id are required" in response.json()["detail"]
