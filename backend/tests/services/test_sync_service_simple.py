"""
Simple unit tests for SyncService.

Tests core functionality without complex mocking.
"""

import pytest
from unittest.mock import Mock, patch, AsyncMock
from datetime import datetime, date
from decimal import Decimal

from app.services.sync_service import SyncService
from app.domain.models.sync_data import PaymentStatus, SyncStatus


class TestSyncServiceSimple:
    """Simple test cases for SyncService."""
    
    @pytest.fixture
    def sync_service(self):
        """Create sync service instance for testing."""
        mock_db = Mock()
        return SyncService(mock_db)
    
    def test_init(self, sync_service):
        """Test service initialization."""
        assert sync_service.db is not None
        assert sync_service.settings is not None
    
    def test_calculate_payment_summary(self, sync_service):
        """Test payment summary calculation."""
        # Sample orders data
        orders = [
            {"order_amount": 1000.0, "payment_status": PaymentStatus.CURRENT},
            {"order_amount": 1500.0, "payment_status": PaymentStatus.UPCOMING},
            {"order_amount": 500.0, "payment_status": PaymentStatus.OVERDUE}
        ]
        
        current, upcoming, overdue = sync_service._calculate_payment_summary(orders)
        
        assert current == 1000.0
        assert upcoming == 1500.0
        assert overdue == 500.0
    
    def test_calculate_payment_summary_empty(self, sync_service):
        """Test payment summary with empty orders."""
        orders = []
        current, upcoming, overdue = sync_service._calculate_payment_summary(orders)
        
        assert current == 0.0
        assert upcoming == 0.0
        assert overdue == 0.0
    
    @pytest.mark.asyncio
    async def test_sync_client_data_success(self, sync_service):
        """Test successful sync with mocked data."""
        # Mock client data
        sample_data = {
            "tenant_id": "test_tenant",
            "shops": [
                {
                    "shop_id": "shop_001",
                    "name": "Test Shop",
                    "manager_name": "John Doe",
                    "manager_email": "john@test.com",
                    "address": "123 Test St",
                    "phone": "555-0123"
                }
            ],
            "orders": [
                {
                    "order_id": "order_001",
                    "shop_id": "shop_001",
                    "order_date": "2024-01-15T10:30:00Z",
                    "total_amount": 1000.0,
                    "products": [
                        {
                            "product_id": "prod_001",
                            "name": "Test Product",
                            "quantity": 2,
                            "unit_price": 500.0
                        }
                    ]
                }
            ]
        }
        
        with patch.object(sync_service, '_fetch_client_data', return_value=sample_data) as mock_fetch, \
             patch.object(sync_service, '_process_sync_data', return_value={"status": "success"}) as mock_process:
            
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            assert result["status"] == "success"
            mock_fetch.assert_called_once()
            mock_process.assert_called_once()
    
    @pytest.mark.asyncio
    async def test_sync_client_data_fetch_error(self, sync_service):
        """Test sync with fetch error."""
        with patch.object(sync_service, '_fetch_client_data', side_effect=Exception("API Error")):
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            assert result["status"] == "failed"
            assert "API Error" in result["error"]
    
    @pytest.mark.asyncio
    async def test_sync_client_data_process_error(self, sync_service):
        """Test sync with process error."""
        sample_data = {"tenant_id": "test_tenant", "shops": [], "orders": []}
        
        with patch.object(sync_service, '_fetch_client_data', return_value=sample_data), \
             patch.object(sync_service, '_process_sync_data', side_effect=Exception("Process Error")):
            
            result = await sync_service.sync_client_data("test_tenant", "http://test-api.com")
            
            assert result["status"] == "failed"
            assert "Process Error" in result["error"]
    
    @pytest.mark.asyncio
    async def test_get_sync_status(self, sync_service):
        """Test getting sync status."""
        # Mock database query
        mock_shop = Mock()
        mock_shop.last_sync_date = datetime(2024, 1, 15)
        mock_shop.sync_status = SyncStatus.SUCCESS
        mock_shop.sync_error = None
        
        sync_service.db.query.return_value.filter.return_value.first.return_value = mock_shop
        
        result = await sync_service.get_sync_status("test_tenant")
        
        assert result["tenant_id"] == "test_tenant"
        assert result["last_sync_date"] is not None
        assert result["sync_status"] == "success"
    
    @pytest.mark.asyncio
    async def test_get_payment_summary(self, sync_service):
        """Test getting payment summary."""
        # Mock database query
        mock_orders = [
            Mock(order_amount=1000.0, payment_status=PaymentStatus.CURRENT),
            Mock(order_amount=1500.0, payment_status=PaymentStatus.UPCOMING),
            Mock(order_amount=500.0, payment_status=PaymentStatus.OVERDUE)
        ]
        
        sync_service.db.query.return_value.filter.return_value.all.return_value = mock_orders
        
        result = await sync_service.get_payment_summary("test_tenant")
        
        assert result["tenant_id"] == "test_tenant"
        assert result["current_amount"] == 1000.0
        assert result["upcoming_amount"] == 1500.0
        assert result["overdue_amount"] == 500.0
