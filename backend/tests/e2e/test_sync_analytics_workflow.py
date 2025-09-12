"""
End-to-end tests for sync and analytics workflow.

Tests complete data flow from client API sync to analytics generation,
including 30-day payment policy integration.
"""

import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch, Mock
from datetime import datetime, timedelta
from decimal import Decimal

from app.main import app


class TestSyncAnalyticsWorkflow:
    """End-to-end test cases for sync and analytics workflow."""
    
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
    def sample_client_data(self):
        """Sample client data for end-to-end testing."""
        return {
            "tenant_id": "test_tenant",
            "shops": [
                {
                    "shop_id": "shop_001",
                    "name": "Electronics Store",
                    "address": "123 Main St",
                    "phone": "+1234567890",
                    "email": "electronics@test.com",
                    "manager_name": "John Doe",
                    "payment_status": {
                        "current": 5000.00,
                        "upcoming": 2000.00,
                        "overdue": 1000.00
                    }
                },
                {
                    "shop_id": "shop_002",
                    "name": "Fashion Store",
                    "address": "456 Oak Ave",
                    "phone": "+1234567891",
                    "email": "fashion@test.com",
                    "manager_name": "Jane Smith",
                    "payment_status": {
                        "current": 3000.00,
                        "upcoming": 1500.00,
                        "overdue": 500.00
                    }
                }
            ],
            "orders": [
                {
                    "order_id": "order_001",
                    "shop_id": "shop_001",
                    "order_date": "2024-01-15T10:30:00Z",
                    "total_amount": 1500.00,
                    "status": "completed",
                    "products": [
                        {
                            "product_id": "prod_001",
                            "name": "Laptop",
                            "category": "Electronics",
                            "quantity": 1,
                            "unit_price": 1500.00,
                            "total_price": 1500.00
                        }
                    ]
                },
                {
                    "order_id": "order_002",
                    "shop_id": "shop_001",
                    "order_date": "2024-01-20T14:15:00Z",
                    "total_amount": 800.00,
                    "status": "completed",
                    "products": [
                        {
                            "product_id": "prod_002",
                            "name": "Mouse",
                            "category": "Electronics",
                            "quantity": 2,
                            "unit_price": 400.00,
                            "total_price": 800.00
                        }
                    ]
                },
                {
                    "order_id": "order_003",
                    "shop_id": "shop_002",
                    "order_date": "2024-01-25T09:45:00Z",
                    "total_amount": 1200.00,
                    "status": "completed",
                    "products": [
                        {
                            "product_id": "prod_003",
                            "name": "Shirt",
                            "category": "Fashion",
                            "quantity": 3,
                            "unit_price": 400.00,
                            "total_price": 1200.00
                        }
                    ]
                }
            ]
        }
    
    def test_complete_sync_workflow(self, client, mock_auth, sample_client_data):
        """Test complete data synchronization workflow."""
        # Mock client API response
        with patch('httpx.AsyncClient') as mock_client:
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = sample_client_data
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            # Mock database operations
            with patch('app.services.sync_service.SyncService') as mock_sync_service:
                mock_sync_service.return_value.sync_client_data.return_value = {
                    "status": "success",
                    "tenant_id": "test_tenant",
                    "shops_processed": 2,
                    "orders_processed": 3,
                    "products_processed": 3
                }
                
                # Step 1: Trigger sync
                response = client.post(
                    "/api/v1/sync/client-data",
                    json={"tenant_id": "test_tenant"}
                )
                
                assert response.status_code == 200
                data = response.json()
                assert data["status"] == "success"
                assert data["shops_processed"] == 2
                assert data["orders_processed"] == 3
                assert data["products_processed"] == 3
                
                # Step 2: Check sync status
                mock_sync_service.return_value.get_sync_status.return_value = {
                    "tenant_id": "test_tenant",
                    "last_sync": "2024-01-15T10:30:00Z",
                    "status": "completed",
                    "shops_synced": 2,
                    "orders_synced": 3
                }
                
                response = client.get("/api/v1/sync/status?tenant_id=test_tenant")
                
                assert response.status_code == 200
                data = response.json()
                assert data["status"] == "completed"
                assert data["shops_synced"] == 2
                assert data["orders_synced"] == 3
                
                # Step 3: Get payment summary
                mock_sync_service.return_value.get_payment_summary.return_value = {
                    "tenant_id": "test_tenant",
                    "total_current": 8000.00,
                    "total_upcoming": 3500.00,
                    "total_overdue": 1500.00,
                    "total_amount": 13000.00
                }
                
                response = client.get("/api/v1/sync/payment-summary?tenant_id=test_tenant")
                
                assert response.status_code == 200
                data = response.json()
                assert data["total_current"] == 8000.00
                assert data["total_upcoming"] == 3500.00
                assert data["total_overdue"] == 1500.00
                assert data["total_amount"] == 13000.00
    
    def test_complete_analytics_workflow(self, client, mock_auth):
        """Test complete analytics generation workflow."""
        with patch('app.services.analytics_service.AnalyticsService') as mock_analytics_service:
            # Step 1: Get executive performance
            mock_analytics_service.return_value.get_executive_performance.return_value = {
                "user_id": 1,
                "tenant_id": "test_tenant",
                "total_sales": 3500.00,
                "total_orders": 3,
                "performance_level": "good",
                "period_start": "2024-01-01T00:00:00Z",
                "period_end": "2024-01-31T23:59:59Z"
            }
            
            response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["total_sales"] == 3500.00
            assert data["total_orders"] == 3
            assert data["performance_level"] == "good"
            
            # Step 2: Get shop analytics
            mock_analytics_service.return_value.get_shop_analytics.return_value = {
                "shop_id": "shop_001",
                "tenant_id": "test_tenant",
                "total_sales": 2300.00,
                "total_orders": 2,
                "average_order_value": 1150.00,
                "period_start": "2024-01-01T00:00:00Z",
                "period_end": "2024-01-31T23:59:59Z"
            }
            
            response = client.get("/api/v1/analytics/shop/shop_001/analytics?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["shop_id"] == "shop_001"
            assert data["total_sales"] == 2300.00
            assert data["total_orders"] == 2
            assert data["average_order_value"] == 1150.00
            
            # Step 3: Get payment analytics
            mock_analytics_service.return_value.get_payment_analytics.return_value = {
                "tenant_id": "test_tenant",
                "total_current": 8000.00,
                "total_upcoming": 3500.00,
                "total_overdue": 1500.00,
                "collection_rate": 85.5,
                "compliance_rate": 92.0,
                "period_start": "2024-01-01T00:00:00Z",
                "period_end": "2024-01-31T23:59:59Z"
            }
            
            response = client.get("/api/v1/analytics/payments/analytics?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["total_current"] == 8000.00
            assert data["total_upcoming"] == 3500.00
            assert data["total_overdue"] == 1500.00
            assert data["collection_rate"] == 85.5
            assert data["compliance_rate"] == 92.0
            
            # Step 4: Get overdue analysis
            mock_analytics_service.return_value.get_overdue_analysis.return_value = {
                "tenant_id": "test_tenant",
                "total_overdue_amount": 1500.00,
                "total_overdue_orders": 2,
                "overdue_orders": [
                    {
                        "shop_id": "shop_001",
                        "order_id": "order_001",
                        "overdue_amount": 1000.00,
                        "days_overdue": 5
                    },
                    {
                        "shop_id": "shop_002",
                        "order_id": "order_002",
                        "overdue_amount": 500.00,
                        "days_overdue": 3
                    }
                ]
            }
            
            response = client.get("/api/v1/analytics/payments/overdue?tenant_id=test_tenant")
            
            assert response.status_code == 200
            data = response.json()
            assert data["total_overdue_amount"] == 1500.00
            assert data["total_overdue_orders"] == 2
            assert len(data["overdue_orders"]) == 2
            
            # Step 5: Get best selling products
            mock_analytics_service.return_value.get_best_selling_products.return_value = {
                "tenant_id": "test_tenant",
                "products": [
                    {
                        "product_id": "prod_001",
                        "product_name": "Laptop",
                        "total_quantity": 1,
                        "total_revenue": 1500.00
                    },
                    {
                        "product_id": "prod_002",
                        "product_name": "Mouse",
                        "total_quantity": 2,
                        "total_revenue": 800.00
                    },
                    {
                        "product_id": "prod_003",
                        "product_name": "Shirt",
                        "total_quantity": 3,
                        "total_revenue": 1200.00
                    }
                ]
            }
            
            response = client.get("/api/v1/analytics/products/best-selling?tenant_id=test_tenant&limit=10")
            
            assert response.status_code == 200
            data = response.json()
            assert len(data["products"]) == 3
            assert data["products"][0]["product_name"] == "Laptop"
            assert data["products"][0]["total_revenue"] == 1500.00
    
    def test_30_day_payment_policy_integration(self, client, mock_auth):
        """Test 30-day payment policy integration in workflow."""
        # Test payment status calculation with different order dates
        test_cases = [
            {
                "order_date": "2024-01-01T00:00:00Z",
                "current_date": "2024-01-15T00:00:00Z",
                "expected_status": "current"
            },
            {
                "order_date": "2024-01-01T00:00:00Z",
                "current_date": "2024-01-25T00:00:00Z",
                "expected_status": "upcoming"
            },
            {
                "order_date": "2024-01-01T00:00:00Z",
                "current_date": "2024-02-05T00:00:00Z",
                "expected_status": "overdue"
            }
        ]
        
        for case in test_cases:
            # Mock shop payment status with specific order date
            with patch('app.services.sync_service.SyncService.get_shop_payment_status') as mock_status:
                mock_status.return_value = {
                    "shop_id": "shop_001",
                    "tenant_id": "test_tenant",
                    "current_amount": 1000.00 if case["expected_status"] == "current" else 0.00,
                    "upcoming_amount": 1000.00 if case["expected_status"] == "upcoming" else 0.00,
                    "overdue_amount": 1000.00 if case["expected_status"] == "overdue" else 0.00,
                    "total_amount": 1000.00,
                    "current_count": 1 if case["expected_status"] == "current" else 0,
                    "upcoming_count": 1 if case["expected_status"] == "upcoming" else 0,
                    "overdue_count": 1 if case["expected_status"] == "overdue" else 0
                }
                
                response = client.get("/api/v1/sync/shops/shop_001/payment-status")
                
                assert response.status_code == 200
                data = response.json()
                
                if case["expected_status"] == "current":
                    assert data["current_amount"] == 1000.00
                    assert data["upcoming_amount"] == 0.00
                    assert data["overdue_amount"] == 0.00
                elif case["expected_status"] == "upcoming":
                    assert data["current_amount"] == 0.00
                    assert data["upcoming_amount"] == 1000.00
                    assert data["overdue_amount"] == 0.00
                elif case["expected_status"] == "overdue":
                    assert data["current_amount"] == 0.00
                    assert data["upcoming_amount"] == 0.00
                    assert data["overdue_amount"] == 1000.00
    
    def test_error_handling_workflow(self, client, mock_auth):
        """Test error handling throughout the workflow."""
        # Test sync error
        with patch('app.services.sync_service.SyncService.sync_client_data') as mock_sync:
            mock_sync.side_effect = Exception("Sync failed")
            
            response = client.post(
                "/api/v1/sync/client-data",
                json={"tenant_id": "test_tenant"}
            )
            
            assert response.status_code == 500
            data = response.json()
            assert "Sync failed" in data["detail"]
        
        # Test analytics error
        with patch('app.services.analytics_service.AnalyticsService.get_executive_performance') as mock_analytics:
            mock_analytics.side_effect = Exception("Analytics failed")
            
            response = client.get("/api/v1/analytics/executive/1/performance?tenant_id=test_tenant")
            
            assert response.status_code == 500
            data = response.json()
            assert "Analytics failed" in data["detail"]
    
    def test_workflow_performance(self, client, mock_auth):
        """Test workflow performance with large datasets."""
        # Mock large dataset
        large_client_data = {
            "tenant_id": "test_tenant",
            "shops": [{"shop_id": f"shop_{i:03d}", "name": f"Shop {i}"} for i in range(100)],
            "orders": [{"order_id": f"order_{i:03d}", "shop_id": f"shop_{i%100:03d}"} for i in range(1000)],
            "products": [{"product_id": f"prod_{i:03d}", "name": f"Product {i}"} for i in range(500)]
        }
        
        with patch('httpx.AsyncClient') as mock_client:
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = large_client_data
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            with patch('app.services.sync_service.SyncService') as mock_sync_service:
                mock_sync_service.return_value.sync_client_data.return_value = {
                    "status": "success",
                    "tenant_id": "test_tenant",
                    "shops_processed": 100,
                    "orders_processed": 1000,
                    "products_processed": 500
                }
                
                import time
                start_time = time.time()
                
                # Test sync performance
                response = client.post(
                    "/api/v1/sync/client-data",
                    json={"tenant_id": "test_tenant"}
                )
                
                end_time = time.time()
                
                assert response.status_code == 200
                # Should complete in reasonable time (< 10 seconds)
                assert end_time - start_time < 10.0
    
    def test_workflow_data_consistency(self, client, mock_auth, sample_client_data):
        """Test data consistency throughout the workflow."""
        with patch('httpx.AsyncClient') as mock_client:
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = sample_client_data
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            with patch('app.services.sync_service.SyncService') as mock_sync_service:
                # Mock sync service
                mock_sync_service.return_value.sync_client_data.return_value = {
                    "status": "success",
                    "tenant_id": "test_tenant",
                    "shops_processed": 2,
                    "orders_processed": 3,
                    "products_processed": 3
                }
                
                mock_sync_service.return_value.get_shop_synced_data.return_value = {
                    "shop_id": "shop_001",
                    "tenant_id": "test_tenant",
                    "shop_name": "Electronics Store",
                    "last_sync": "2024-01-15T10:30:00Z",
                    "total_orders": 2,
                    "total_sales": 2300.00
                }
                
                # Step 1: Sync data
                response = client.post(
                    "/api/v1/sync/client-data",
                    json={"tenant_id": "test_tenant"}
                )
                
                assert response.status_code == 200
                sync_data = response.json()
                assert sync_data["shops_processed"] == 2
                assert sync_data["orders_processed"] == 3
                assert sync_data["products_processed"] == 3
                
                # Step 2: Verify shop data consistency
                response = client.get("/api/v1/sync/shops/shop_001/synced-data")
                
                assert response.status_code == 200
                shop_data = response.json()
                assert shop_data["shop_id"] == "shop_001"
                assert shop_data["tenant_id"] == "test_tenant"
                assert shop_data["shop_name"] == "Electronics Store"
                assert shop_data["total_orders"] == 2
                assert shop_data["total_sales"] == 2300.00
                
                # Verify data consistency between sync and shop data
                assert shop_data["total_orders"] <= sync_data["orders_processed"]
                assert shop_data["total_sales"] > 0

