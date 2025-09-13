"""
Integration tests for sync API endpoints.

Tests data synchronization endpoints, error handling,
and integration with mock client API.
"""

import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch, Mock
from datetime import datetime
from decimal import Decimal

from app.main import app


class TestSyncEndpoints:
    """Test cases for sync API endpoints."""
    
    @pytest.fixture
    def client(self):
        """Create test client."""
        return TestClient(app)
    
    @pytest.fixture
    def mock_auth(self):
        """Mock authentication."""
        with patch('app.api.deps.get_current_user') as mock:
            mock_user = Mock()
            mock_user.id = 1
            mock_user.tenant_id = "test_tenant"
            mock_user.role = "admin"
            mock.return_value = mock_user
            yield mock
    
    @pytest.fixture
    def sample_sync_response(self):
        """Sample sync response data."""
        return {
            "status": "success",
            "tenant_id": "test_tenant",
            "shops_processed": 2,
            "orders_processed": 3,
            "products_processed": 5,
            "sync_timestamp": "2024-01-15T10:30:00Z"
        }
    
    def test_sync_client_data_success(self, client, mock_auth, sample_sync_response):
        """Test successful client data synchronization."""
        with patch('app.services.sync_service.SyncService.sync_client_data') as mock_sync:
            mock_sync.return_value = sample_sync_response
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "test_tenant"}
            )
            
            assert response.status_code == 200
            data = response.json()
            assert data["status"] == "success"
            assert data["tenant_id"] == "test_tenant"
            assert data["shops_processed"] == 2
            assert data["orders_processed"] == 3
            assert data["products_processed"] == 5
    
    def test_sync_client_data_unauthorized(self, client):
        """Test sync endpoint without authentication."""
        response = client.post(
            "/api/v1/sync/client-data",
            json={"tenant_id": "test_tenant"}
        )
        
        assert response.status_code == 401
    
    def test_sync_client_data_invalid_tenant(self, client, mock_auth):
        """Test sync with invalid tenant ID."""
        with patch('app.services.sync_service.SyncService.sync_client_data') as mock_sync:
            mock_sync.side_effect = ValueError("Invalid tenant ID")
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "invalid_tenant"}
            )
            
            assert response.status_code == 400
            data = response.json()
            assert "Invalid tenant ID" in data["detail"]
    
    def test_sync_client_data_service_error(self, client, mock_auth):
        """Test sync with service error."""
        with patch('app.services.sync_service.SyncService.sync_client_data') as mock_sync:
            mock_sync.side_effect = Exception("Service error")
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "test_tenant"}
            )
            
            assert response.status_code == 500
            data = response.json()
            assert "Service error" in data["detail"]
    
    def test_get_sync_status_success(self, client, mock_auth):
        """Test successful sync status retrieval."""
        with patch('app.services.sync_service.SyncService.get_sync_status') as mock_status:
            mock_status.return_value = {
                "tenant_id": "test_tenant",
                "last_sync": "2024-01-15T10:30:00Z",
                "status": "completed",
                "shops_synced": 2,
                "orders_synced": 3
            }
            
            response = client.get("/api/v1/sync/status?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert data["status"] == "completed"
            assert data["shops_synced"] == 2
            assert data["orders_synced"] == 3
    
    def test_get_sync_status_unauthorized(self, client):
        """Test sync status without authentication."""
        response = client.get("/api/v1/sync/status?tenant_id=test_tenant")
        
        assert response.status_code == 401
    
    def test_get_sync_status_missing_tenant(self, client, mock_auth):
        """Test sync status without tenant ID."""
        response = client.get("/api/v1/sync/status")
        
        assert response.status_code == 422  # Validation error
    
    def test_get_payment_summary_success(self, client, mock_auth):
        """Test successful payment summary retrieval."""
        with patch('app.services.sync_service.SyncService.get_payment_summary') as mock_summary:
            mock_summary.return_value = {
                "tenant_id": "test_tenant",
                "total_current": 5000.00,
                "total_upcoming": 2000.00,
                "total_overdue": 1000.00,
                "total_amount": 8000.00
            }
            
            response = client.get("/api/v1/sync/payment-summary?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert data["total_current"] == 5000.00
            assert data["total_upcoming"] == 2000.00
            assert data["total_overdue"] == 1000.00
            assert data["total_amount"] == 8000.00
    
    def test_get_shop_synced_data_success(self, client, mock_auth):
        """Test successful shop synced data retrieval."""
        with patch('app.services.sync_service.SyncService.get_shop_synced_data') as mock_data:
            mock_data.return_value = {
                "shop_id": "shop_001",
                "tenant_id": "test_tenant",
                "shop_name": "Test Shop",
                "last_sync": "2024-01-15T10:30:00Z",
                "total_orders": 5,
                "total_sales": 15000.00,
                "payment_status": {
                    "current": 5000.00,
                    "upcoming": 2000.00,
                    "overdue": 1000.00
                }
            }
            
            response = client.get("/api/v1/sync/shops/shop_001/synced-data")
            
            assert response.status_code == 200
            data = response.json()
            assert data["shop_id"] == "shop_001"
            assert data["tenant_id"] == "test_tenant"
            assert data["shop_name"] == "Test Shop"
            assert data["total_orders"] == 5
            assert data["total_sales"] == 15000.00
    
    def test_get_shop_synced_data_not_found(self, client, mock_auth):
        """Test shop synced data not found."""
        with patch('app.services.sync_service.SyncService.get_shop_synced_data') as mock_data:
            mock_data.return_value = None
            
            response = client.get("/api/v1/sync/shops/nonexistent/synced-data")
            
            assert response.status_code == 404
            data = response.json()
            assert "Shop not found" in data["detail"]
    
    def test_get_shop_payment_status_success(self, client, mock_auth):
        """Test successful shop payment status retrieval."""
        with patch('app.services.sync_service.SyncService.get_shop_payment_status') as mock_status:
            mock_status.return_value = {
                "shop_id": "shop_001",
                "tenant_id": "test_tenant",
                "current_amount": 5000.00,
                "upcoming_amount": 2000.00,
                "overdue_amount": 1000.00,
                "total_amount": 8000.00,
                "current_count": 3,
                "upcoming_count": 2,
                "overdue_count": 1
            }
            
            response = client.get("/api/v1/sync/shops/shop_001/payment-status")
            
            assert response.status_code == 200
            data = response.json()
            assert data["shop_id"] == "shop_001"
            assert data["tenant_id"] == "test_tenant"
            assert data["current_amount"] == 5000.00
            assert data["upcoming_amount"] == 2000.00
            assert data["overdue_amount"] == 1000.00
            assert data["total_amount"] == 8000.00
    
    def test_sync_endpoints_require_authentication(self, client):
        """Test that all sync endpoints require authentication."""
        endpoints = [
            ("POST", "/api/v1/sync/client-data"),
            ("GET", "/api/v1/sync/status"),
            ("GET", "/api/v1/sync/payment-summary"),
            ("GET", "/api/v1/sync/shops/shop_001/synced-data"),
            ("GET", "/api/v1/sync/shops/shop_001/payment-status")
        ]
        
        for method, endpoint in endpoints:
            if method == "POST":
                response = client.post(endpoint, json={"tenant_id": "test_tenant"})
            else:
                response = client.get(endpoint)
            
            assert response.status_code == 401
    
    def test_sync_endpoints_validation(self, client, mock_auth):
        """Test sync endpoints input validation."""
        # Test missing tenant_id in POST request
        response = client.post("/api/v1/sync/client-data", json={})
        assert response.status_code == 422
        
        # Test invalid tenant_id format
        response = client.post("/api/v1/sync/client-data", json={"tenant_id": ""})
        assert response.status_code == 422
        
        # Test missing tenant_id in GET requests
        response = client.get("/api/v1/sync/status")
        assert response.status_code == 422
        
        response = client.get("/api/v1/sync/payment-summary")
        assert response.status_code == 422
    
    def test_sync_endpoints_error_handling(self, client, mock_auth):
        """Test sync endpoints error handling."""
        with patch('app.services.sync_service.SyncService') as mock_service:
            # Test database connection error
            mock_service.side_effect = Exception("Database connection failed")
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "test_tenant"}
            )
            
            assert response.status_code == 500
            data = response.json()
            assert "Database connection failed" in data["detail"]
    
    def test_sync_endpoints_response_format(self, client, mock_auth, sample_sync_response):
        """Test sync endpoints response format consistency."""
        with patch('app.services.sync_service.SyncService.sync_client_data') as mock_sync:
            mock_sync.return_value = sample_sync_response
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "test_tenant"}
            )
            
            assert response.status_code == 200
            data = response.json()
            
            # Verify required fields
            required_fields = ["status", "tenant_id", "shops_processed", "orders_processed", "products_processed"]
            for field in required_fields:
                assert field in data
            
            # Verify data types
            assert isinstance(data["status"], str)
            assert isinstance(data["tenant_id"], str)
            assert isinstance(data["shops_processed"], int)
            assert isinstance(data["orders_processed"], int)
            assert isinstance(data["products_processed"], int)
    
    def test_sync_endpoints_performance(self, client, mock_auth):
        """Test sync endpoints performance."""
        with patch('app.services.sync_service.SyncService.sync_client_data') as mock_sync:
            mock_sync.return_value = {
                "status": "success",
                "tenant_id": "test_tenant",
                "shops_processed": 100,
                "orders_processed": 500,
                "products_processed": 1000
            }
            
            import time
            start_time = time.time()
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "test_tenant"}
            )
            
            end_time = time.time()
            
            assert response.status_code == 200
            # Should complete in reasonable time (< 5 seconds)
            assert end_time - start_time < 5.0

