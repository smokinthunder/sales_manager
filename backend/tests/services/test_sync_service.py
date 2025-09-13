"""
Unit tests for sync service.

Tests data synchronization functionality, 30-day payment policy,
and error handling scenarios.
"""

import pytest
from unittest.mock import Mock, patch, AsyncMock
from datetime import datetime, timedelta
from decimal import Decimal

from app.services.sync_service import SyncService
from app.domain.models.sync_data import SyncedShopData, SyncedOrder, SyncedProduct, PaymentStatus


class TestSyncService:
    """Test cases for SyncService."""
    
    @pytest.fixture
    def mock_db(self):
        """Mock database session."""
        return Mock()
    
    @pytest.fixture
    def sync_service(self, mock_db):
        """Create SyncService instance with mocked dependencies."""
        return SyncService(mock_db)
    
    @pytest.fixture
    def sample_client_data(self):
        """Sample client data for testing."""
        return {
            "tenant_id": "test_tenant",
            "shops": [
                {
                    "shop_id": "shop_001",
                    "name": "Test Shop 1",
                    "address": "123 Test Street",
                    "phone": "+1234567890",
                    "email": "shop1@test.com",
                    "manager_name": "John Doe",
                    "payment_status": {
                        "current": 5000.00,
                        "upcoming": 2000.00,
                        "overdue": 1000.00
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
                            "name": "Test Product 1",
                            "category": "Electronics",
                            "quantity": 2,
                            "unit_price": 750.00,
                            "total_price": 1500.00
                        }
                    ]
                }
            ]
        }
    
    def test_calculate_due_date(self, sync_service):
        """Test due date calculation for 30-day payment policy."""
        # Test current date
        current_date = datetime(2024, 1, 15)
        due_date = sync_service._calculate_due_date(current_date)
        expected_due_date = datetime(2024, 2, 14)  # 30 days later
        assert due_date == expected_due_date
        
        # Test leap year
        leap_year_date = datetime(2024, 1, 31)
        due_date = sync_service._calculate_due_date(leap_year_date)
        expected_due_date = datetime(2024, 3, 1)  # 30 days later
        assert due_date == expected_due_date
    
    def test_calculate_overdue_status(self, sync_service):
        """Test overdue status calculation."""
        # Test current payment (not overdue)
        current_date = datetime(2024, 1, 15)
        due_date = datetime(2024, 1, 20)
        is_overdue = sync_service._calculate_overdue_status(current_date, due_date)
        assert is_overdue == False
        
        # Test overdue payment
        current_date = datetime(2024, 1, 25)
        due_date = datetime(2024, 1, 20)
        is_overdue = sync_service._calculate_overdue_status(current_date, due_date)
        assert is_overdue == True
        
        # Test exact due date
        current_date = datetime(2024, 1, 20)
        due_date = datetime(2024, 1, 20)
        is_overdue = sync_service._calculate_overdue_status(current_date, due_date)
        assert is_overdue == False
    
    @pytest.mark.asyncio
    async def test_sync_client_data_success(self, sync_service, sample_client_data):
        """Test successful data synchronization."""
        with patch('httpx.AsyncClient') as mock_client:
            # Mock HTTP response
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = sample_client_data
            
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            # Mock database operations
            sync_service.db.query.return_value.filter.return_value.first.return_value = None
            sync_service.db.add = Mock()
            sync_service.db.commit = Mock()
            
            # Execute sync
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            # Verify results
            assert result["status"] == "success"
            assert result["tenant_id"] == "test_tenant"
            assert result["shops_processed"] == 1
            assert result["orders_processed"] == 1
            assert result["products_processed"] == 1
            
            # Verify database operations
            assert sync_service.db.add.call_count == 3  # 1 shop + 1 order + 1 product
            sync_service.db.commit.assert_called_once()
    
    @pytest.mark.asyncio
    async def test_sync_client_data_api_error(self, sync_service):
        """Test sync with API error."""
        with patch('httpx.AsyncClient') as mock_client:
            # Mock HTTP error
            mock_client.return_value.__aenter__.return_value.get.side_effect = Exception("API Error")
            
            # Execute sync
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            # Verify error handling
            assert result["status"] == "error"
            assert "API Error" in result["error"]
    
    @pytest.mark.asyncio
    async def test_sync_client_data_http_error(self, sync_service):
        """Test sync with HTTP error response."""
        with patch('httpx.AsyncClient') as mock_client:
            # Mock HTTP error response
            mock_response = Mock()
            mock_response.status_code = 500
            mock_response.text = "Internal Server Error"
            
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            # Execute sync
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            # Verify error handling
            assert result["status"] == "error"
            assert "HTTP 500" in result["error"]
    
    @pytest.mark.asyncio
    async def test_sync_client_data_database_error(self, sync_service, sample_client_data):
        """Test sync with database error."""
        with patch('httpx.AsyncClient') as mock_client:
            # Mock HTTP response
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = sample_client_data
            
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            # Mock database error
            sync_service.db.commit.side_effect = Exception("Database Error")
            
            # Execute sync
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            # Verify error handling
            assert result["status"] == "error"
            assert "Database Error" in result["error"]
    
    def test_process_sync_data(self, sync_service, sample_client_data):
        """Test data processing logic."""
        # Mock database operations
        sync_service.db.query.return_value.filter.return_value.first.return_value = None
        sync_service.db.add = Mock()
        
        # Process data
        result = sync_service._process_sync_data(sample_client_data)
        
        # Verify processing results
        assert result["shops_processed"] == 1
        assert result["orders_processed"] == 1
        assert result["products_processed"] == 1
        
        # Verify database operations
        assert sync_service.db.add.call_count == 3
    
    def test_process_sync_data_existing_shop(self, sync_service, sample_client_data):
        """Test processing with existing shop data."""
        # Mock existing shop
        existing_shop = Mock()
        existing_shop.shop_id = "shop_001"
        sync_service.db.query.return_value.filter.return_value.first.return_value = existing_shop
        sync_service.db.add = Mock()
        
        # Process data
        result = sync_service._process_sync_data(sample_client_data)
        
        # Verify processing results
        assert result["shops_processed"] == 1
        assert result["orders_processed"] == 1
        assert result["products_processed"] == 1
        
        # Verify existing shop was updated, not added
        assert sync_service.db.add.call_count == 2  # 1 order + 1 product (shop not added)
    
    def test_payment_status_calculation(self, sync_service):
        """Test payment status calculation logic."""
        # Test current payment
        current_date = datetime(2024, 1, 15)
        order_date = datetime(2024, 1, 1)
        due_date = sync_service._calculate_due_date(order_date)
        
        status = sync_service._calculate_payment_status(current_date, due_date)
        assert status == PaymentStatus.CURRENT
        
        # Test upcoming payment
        current_date = datetime(2024, 1, 25)
        order_date = datetime(2024, 1, 1)
        due_date = sync_service._calculate_due_date(order_date)
        
        status = sync_service._calculate_payment_status(current_date, due_date)
        assert status == PaymentStatus.UPCOMING
        
        # Test overdue payment
        current_date = datetime(2024, 2, 5)
        order_date = datetime(2024, 1, 1)
        due_date = sync_service._calculate_due_date(order_date)
        
        status = sync_service._calculate_payment_status(current_date, due_date)
        assert status == PaymentStatus.OVERDUE
    
    def test_30_day_payment_policy_integration(self, sync_service):
        """Test 30-day payment policy integration."""
        # Test various scenarios
        test_cases = [
            {
                "order_date": datetime(2024, 1, 1),
                "current_date": datetime(2024, 1, 15),
                "expected_status": PaymentStatus.CURRENT
            },
            {
                "order_date": datetime(2024, 1, 1),
                "current_date": datetime(2024, 1, 25),
                "expected_status": PaymentStatus.UPCOMING
            },
            {
                "order_date": datetime(2024, 1, 1),
                "current_date": datetime(2024, 2, 5),
                "expected_status": PaymentStatus.OVERDUE
            }
        ]
        
        for case in test_cases:
            due_date = sync_service._calculate_due_date(case["order_date"])
            status = sync_service._calculate_payment_status(case["current_date"], due_date)
            assert status == case["expected_status"], f"Failed for case: {case}"
    
    def test_error_handling_robustness(self, sync_service):
        """Test error handling robustness."""
        # Test with invalid data
        invalid_data = {
            "tenant_id": "test_tenant",
            "shops": None,  # Invalid data
            "orders": []
        }
        
        # Should not raise exception
        result = sync_service._process_sync_data(invalid_data)
        assert result["shops_processed"] == 0
        assert result["orders_processed"] == 0
        assert result["products_processed"] == 0
    
    @pytest.mark.asyncio
    async def test_logging_verification(self, sync_service, caplog):
        """Test that appropriate logging occurs."""
        with patch('httpx.AsyncClient') as mock_client:
            # Mock HTTP response
            mock_response = Mock()
            mock_response.status_code = 200
            mock_response.json.return_value = {"tenant_id": "test_tenant", "shops": [], "orders": []}
            
            mock_client.return_value.__aenter__.return_value.get.return_value = mock_response
            
            # Mock database operations
            sync_service.db.query.return_value.filter.return_value.first.return_value = None
            sync_service.db.add = Mock()
            sync_service.db.commit = Mock()
            
            # Execute sync
            await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            # Verify logging
            assert "Starting sync for tenant" in caplog.text
            assert "Sync completed successfully" in caplog.text
