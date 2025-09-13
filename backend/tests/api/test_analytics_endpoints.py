"""
Integration tests for analytics API endpoints.

Tests analytics endpoints, performance tracking,
and business intelligence functionality.
"""

import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch, Mock
from datetime import datetime
from decimal import Decimal

from app.main import app


class TestAnalyticsEndpoints:
    """Test cases for analytics API endpoints."""
    
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
    def sample_performance_data(self):
        """Sample performance data."""
        return {
            "user_id": 1,
            "tenant_id": "test_tenant",
            "total_sales": 50000.00,
            "total_orders": 25,
            "performance_level": "excellent",
            "period_start": "2024-01-01T00:00:00Z",
            "period_end": "2024-01-31T23:59:59Z"
        }
    
    @pytest.fixture
    def sample_shop_analytics_data(self):
        """Sample shop analytics data."""
        return {
            "shop_id": "shop_001",
            "tenant_id": "test_tenant",
            "total_sales": 25000.00,
            "total_orders": 15,
            "average_order_value": 1666.67,
            "period_start": "2024-01-01T00:00:00Z",
            "period_end": "2024-01-31T23:59:59Z"
        }
    
    def test_get_executive_performance_success(self, client, mock_auth, sample_performance_data):
        """Test successful executive performance retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_executive_performance') as mock_performance:
            mock_performance.return_value = sample_performance_data
            
            response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["user_id"] == 1
            assert data["tenant_id"] == "test_tenant"
            assert data["total_sales"] == 50000.00
            assert data["total_orders"] == 25
            assert data["performance_level"] == "excellent"
    
    def test_get_executive_performance_unauthorized(self, client):
        """Test executive performance without authentication."""
        response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
        
        assert response.status_code == 401
    
    def test_get_executive_performance_not_found(self, client, mock_auth):
        """Test executive performance for non-existent user."""
        with patch('app.services.analytics_service.AnalyticsService.get_executive_performance') as mock_performance:
            mock_performance.return_value = None
            
            response = client.get("/api/v1/analytics/executive/999/performance?tenant_id=test_tenant")
            
            assert response.status_code == 404
            data = response.json()
            assert "User not found" in data["detail"]
    
    def test_get_shop_analytics_success(self, client, mock_auth, sample_shop_analytics_data):
        """Test successful shop analytics retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_shop_analytics') as mock_analytics:
            mock_analytics.return_value = sample_shop_analytics_data
            
            response = client.get("/api/v1/analytics/shop/shop_001/analytics?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["shop_id"] == "shop_001"
            assert data["tenant_id"] == "test_tenant"
            assert data["total_sales"] == 25000.00
            assert data["total_orders"] == 15
            assert data["average_order_value"] == 1666.67
    
    def test_get_shop_analytics_not_found(self, client, mock_auth):
        """Test shop analytics for non-existent shop."""
        with patch('app.services.analytics_service.AnalyticsService.get_shop_analytics') as mock_analytics:
            mock_analytics.return_value = None
            
            response = client.get("/api/v1/analytics/shop/nonexistent/analytics?tenant_id=test_tenant")
            
            assert response.status_code == 404
            data = response.json()
            assert "Shop not found" in data["detail"]
    
    def test_get_payment_analytics_success(self, client, mock_auth):
        """Test successful payment analytics retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_payment_analytics') as mock_analytics:
            mock_analytics.return_value = {
                "tenant_id": "test_tenant",
                "total_current": 30000.00,
                "total_upcoming": 15000.00,
                "total_overdue": 5000.00,
                "collection_rate": 85.5,
                "compliance_rate": 92.0,
                "period_start": "2024-01-01T00:00:00Z",
                "period_end": "2024-01-31T23:59:59Z"
            }
            
            response = client.get("/api/v1/analytics/payments/analytics?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert data["total_current"] == 30000.00
            assert data["total_upcoming"] == 15000.00
            assert data["total_overdue"] == 5000.00
            assert data["collection_rate"] == 85.5
            assert data["compliance_rate"] == 92.0
    
    def test_get_overdue_analysis_success(self, client, mock_auth):
        """Test successful overdue analysis retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_overdue_analysis') as mock_analysis:
            mock_analysis.return_value = {
                "tenant_id": "test_tenant",
                "total_overdue_amount": 5000.00,
                "total_overdue_orders": 3,
                "overdue_orders": [
                    {
                        "shop_id": "shop_001",
                        "order_id": "order_001",
                        "overdue_amount": 2000.00,
                        "days_overdue": 5
                    },
                    {
                        "shop_id": "shop_002",
                        "order_id": "order_002",
                        "overdue_amount": 3000.00,
                        "days_overdue": 10
                    }
                ]
            }
            
            response = client.get("/api/v1/analytics/payments/overdue?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert data["total_overdue_amount"] == 5000.00
            assert data["total_overdue_orders"] == 3
            assert len(data["overdue_orders"]) == 2
    
    def test_get_best_selling_products_success(self, client, mock_auth):
        """Test successful best selling products retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_best_selling_products') as mock_products:
            mock_products.return_value = {
                "tenant_id": "test_tenant",
                "products": [
                    {
                        "product_id": "prod_001",
                        "product_name": "Product A",
                        "total_quantity": 100,
                        "total_revenue": 50000.00
                    },
                    {
                        "product_id": "prod_002",
                        "product_name": "Product B",
                        "total_quantity": 80,
                        "total_revenue": 40000.00
                    }
                ]
            }
            
            response = client.get("/api/v1/analytics/products/best-selling?tenant_id=test_tenant&limit=10")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert len(data["products"]) == 2
            assert data["products"][0]["product_id"] == "prod_001"
            assert data["products"][0]["total_quantity"] == 100
            assert data["products"][0]["total_revenue"] == 50000.00
    
    def test_get_executives_summary_success(self, client, mock_auth):
        """Test successful executives summary retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_executives_summary') as mock_summary:
            mock_summary.return_value = {
                "tenant_id": "test_tenant",
                "total_executives": 5,
                "total_sales": 250000.00,
                "total_orders": 125,
                "top_performer": {
                    "user_id": 1,
                    "name": "John Doe",
                    "total_sales": 75000.00,
                    "performance_level": "excellent"
                }
            }
            
            response = client.get("/api/v1/analytics/executives/summary?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert data["total_executives"] == 5
            assert data["total_sales"] == 250000.00
            assert data["total_orders"] == 125
            assert data["top_performer"]["user_id"] == 1
    
    def test_get_shops_summary_success(self, client, mock_auth):
        """Test successful shops summary retrieval."""
        with patch('app.services.analytics_service.AnalyticsService.get_shops_summary') as mock_summary:
            mock_summary.return_value = {
                "tenant_id": "test_tenant",
                "total_shops": 10,
                "total_sales": 500000.00,
                "total_orders": 250,
                "top_shop": {
                    "shop_id": "shop_001",
                    "name": "Best Shop",
                    "total_sales": 75000.00,
                    "total_orders": 35
                }
            }
            
            response = client.get("/api/v1/analytics/shops/summary?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["tenant_id"] == "test_tenant"
            assert data["total_shops"] == 10
            assert data["total_sales"] == 500000.00
            assert data["total_orders"] == 250
            assert data["top_shop"]["shop_id"] == "shop_001"
    
    def test_analytics_endpoints_require_authentication(self, client):
        """Test that all analytics endpoints require authentication."""
        endpoints = [
            ("GET", "/api/v1/analytics/executive/1/performance"),
            ("GET", "/api/v1/analytics/shop/shop_001/analytics"),
            ("GET", "/api/v1/analytics/payments/analytics"),
            ("GET", "/api/v1/analytics/payments/overdue"),
            ("GET", "/api/v1/analytics/products/best-selling"),
            ("GET", "/api/v1/analytics/executives/summary"),
            ("GET", "/api/v1/analytics/shops/summary")
        ]
        
        for method, endpoint in endpoints:
            response = client.get(endpoint)
            assert response.status_code == 401
    
    def test_analytics_endpoints_validation(self, client, mock_auth):
        """Test analytics endpoints input validation."""
        # Test missing tenant_id
        response = client.get("/api/v1/analytics/executive/1/performance")
        assert response.status_code == 422
        
        # Test invalid user_id
        response = client.get("/api/v1/analytics/executive/invalid/performance?tenant_id=test_tenant")
        assert response.status_code == 422
        
        # Test invalid shop_id
        response = client.get("/api/v1/analytics/shop//analytics?tenant_id=test_tenant")
        assert response.status_code == 404
        
        # Test invalid limit parameter
        response = client.get("/api/v1/analytics/products/best-selling?tenant_id=test_tenant&limit=invalid")
        assert response.status_code == 422
    
    def test_analytics_endpoints_error_handling(self, client, mock_auth):
        """Test analytics endpoints error handling."""
        with patch('app.services.analytics_service.AnalyticsService') as mock_service:
            # Test database connection error
            mock_service.side_effect = Exception("Database connection failed")
            
            response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
            
            assert response.status_code == 500
            data = response.json()
            assert "Database connection failed" in data["detail"]
    
    def test_analytics_endpoints_response_format(self, client, mock_auth, sample_performance_data):
        """Test analytics endpoints response format consistency."""
        with patch('app.services.analytics_service.AnalyticsService.get_executive_performance') as mock_performance:
            mock_performance.return_value = sample_performance_data
            
            response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            
            # Verify required fields
            required_fields = ["user_id", "tenant_id", "total_sales", "total_orders", "performance_level"]
            for field in required_fields:
                assert field in data
            
            # Verify data types
            assert isinstance(data["user_id"], int)
            assert isinstance(data["tenant_id"], str)
            assert isinstance(data["total_sales"], (int, float))
            assert isinstance(data["total_orders"], int)
            assert isinstance(data["performance_level"], str)
    
    def test_analytics_endpoints_performance(self, client, mock_auth):
        """Test analytics endpoints performance."""
        with patch('app.services.analytics_service.AnalyticsService.get_executive_performance') as mock_performance:
            mock_performance.return_value = {
                "user_id": 1,
                "tenant_id": "test_tenant",
                "total_sales": 100000.00,
                "total_orders": 50,
                "performance_level": "excellent"
            }
            
            import time
            start_time = time.time()
            
            response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
            
            end_time = time.time()
            
            assert response.status_code == 200
            # Should complete in reasonable time (< 3 seconds)
            assert end_time - start_time < 3.0
    
    def test_analytics_endpoints_pagination(self, client, mock_auth):
        """Test analytics endpoints pagination."""
        with patch('app.services.analytics_service.AnalyticsService.get_best_selling_products') as mock_products:
            mock_products.return_value = {
                "tenant_id": "test_tenant",
                "products": [
                    {"product_id": f"prod_{i:03d}", "product_name": f"Product {i}", "total_quantity": i*10, "total_revenue": i*1000.00}
                    for i in range(1, 6)
                ]
            }
            
            # Test with limit
            response = client.get("/api/v1/analytics/products/best-selling?tenant_id=test_tenant&limit=3")
            
            assert response.status_code == 200
            data = response.json()
            assert len(data["products"]) == 3
            
            # Test with offset
            response = client.get("/api/v1/analytics/products/best-selling?tenant_id=test_tenant&limit=3&offset=2")
            
            assert response.status_code == 200
            data = response.json()
            assert len(data["products"]) == 3

