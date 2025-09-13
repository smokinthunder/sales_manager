"""
Unit tests for analytics service.

Tests analytics calculations, performance tracking,
and business intelligence functionality.
"""

import pytest
from unittest.mock import Mock, patch
from datetime import datetime, timedelta
from decimal import Decimal

from app.services.analytics_service import AnalyticsService
from app.domain.models.analytics import (
    SalesPerformance, ShopAnalytics, PaymentAnalytics,
    PerformanceLevel, PaymentTrend
)


class TestAnalyticsService:
    """Test cases for AnalyticsService."""
    
    @pytest.fixture
    def mock_db(self):
        """Mock database session."""
        return Mock()
    
    @pytest.fixture
    def analytics_service(self, mock_db):
        """Create AnalyticsService instance with mocked dependencies."""
        return AnalyticsService(mock_db)
    
    @pytest.fixture
    def sample_sales_data(self):
        """Sample sales data for testing."""
        return [
            {
                "user_id": 1,
                "shop_id": "shop_001",
                "order_id": "order_001",
                "order_date": datetime(2024, 1, 15),
                "total_amount": Decimal("1500.00"),
                "payment_status": "completed"
            },
            {
                "user_id": 1,
                "shop_id": "shop_002",
                "order_id": "order_002",
                "order_date": datetime(2024, 1, 16),
                "total_amount": Decimal("2000.00"),
                "payment_status": "completed"
            }
        ]
    
    @pytest.fixture
    def sample_payment_data(self):
        """Sample payment data for testing."""
        return [
            {
                "shop_id": "shop_001",
                "order_id": "order_001",
                "order_date": datetime(2024, 1, 1),
                "due_date": datetime(2024, 1, 31),
                "total_amount": Decimal("1000.00"),
                "payment_status": "current"
            },
            {
                "shop_id": "shop_002",
                "order_id": "order_002",
                "order_date": datetime(2024, 1, 5),
                "due_date": datetime(2024, 2, 4),
                "total_amount": Decimal("1500.00"),
                "payment_status": "upcoming"
            }
        ]
    
    def test_calculate_performance_level(self, analytics_service):
        """Test performance level calculation."""
        # Test excellent performance
        performance = analytics_service._calculate_performance_level(Decimal("10000.00"), 10)
        assert performance == PerformanceLevel.EXCELLENT
        
        # Test good performance
        performance = analytics_service._calculate_performance_level(Decimal("5000.00"), 5)
        assert performance == PerformanceLevel.GOOD
        
        # Test average performance
        performance = analytics_service._calculate_performance_level(Decimal("2000.00"), 3)
        assert performance == PerformanceLevel.AVERAGE
        
        # Test poor performance
        performance = analytics_service._calculate_performance_level(Decimal("500.00"), 1)
        assert performance == PerformanceLevel.POOR
    
    def test_calculate_payment_trend(self, analytics_service):
        """Test payment trend calculation."""
        # Test improving trend
        current_period = Decimal("8000.00")
        previous_period = Decimal("6000.00")
        trend = analytics_service._calculate_payment_trend(current_period, previous_period)
        assert trend == PaymentTrend.IMPROVING
        
        # Test declining trend
        current_period = Decimal("4000.00")
        previous_period = Decimal("6000.00")
        trend = analytics_service._calculate_payment_trend(current_period, previous_period)
        assert trend == PaymentTrend.DECLINING
        
        # Test stable trend
        current_period = Decimal("6000.00")
        previous_period = Decimal("6000.00")
        trend = analytics_service._calculate_payment_trend(current_period, previous_period)
        assert trend == PaymentTrend.STABLE
    
    def test_calculate_payment_collection_rate(self, analytics_service):
        """Test payment collection rate calculation."""
        # Test 100% collection rate
        total_due = Decimal("10000.00")
        collected = Decimal("10000.00")
        rate = analytics_service._calculate_payment_collection_rate(collected, total_due)
        assert rate == 100.0
        
        # Test 75% collection rate
        total_due = Decimal("10000.00")
        collected = Decimal("7500.00")
        rate = analytics_service._calculate_payment_collection_rate(collected, total_due)
        assert rate == 75.0
        
        # Test 0% collection rate
        total_due = Decimal("10000.00")
        collected = Decimal("0.00")
        rate = analytics_service._calculate_payment_collection_rate(collected, total_due)
        assert rate == 0.0
    
    def test_calculate_compliance_rate(self, analytics_service):
        """Test compliance rate calculation."""
        # Test 100% compliance
        total_orders = 10
        compliant_orders = 10
        rate = analytics_service._calculate_compliance_rate(compliant_orders, total_orders)
        assert rate == 100.0
        
        # Test 80% compliance
        total_orders = 10
        compliant_orders = 8
        rate = analytics_service._calculate_compliance_rate(compliant_orders, total_orders)
        assert rate == 80.0
        
        # Test 0% compliance
        total_orders = 10
        compliant_orders = 0
        rate = analytics_service._calculate_compliance_rate(compliant_orders, total_orders)
        assert rate == 0.0
    
    @pytest.mark.asyncio
    async def test_get_executive_performance_success(self, analytics_service, sample_sales_data):
        """Test successful executive performance calculation."""
        # Mock database query
        mock_query = Mock()
        mock_query.filter.return_value.all.return_value = sample_sales_data
        analytics_service.db.query.return_value = mock_query
        
        # Execute test
        result = await analytics_service.get_executive_performance(1, "test_tenant")
        
        # Verify results
        assert result["user_id"] == 1
        assert result["tenant_id"] == "test_tenant"
        assert result["total_sales"] == Decimal("3500.00")
        assert result["total_orders"] == 2
        assert result["performance_level"] == PerformanceLevel.GOOD
        assert result["period_start"] is not None
        assert result["period_end"] is not None
    
    @pytest.mark.asyncio
    async def test_get_shop_analytics_success(self, analytics_service, sample_sales_data):
        """Test successful shop analytics calculation."""
        # Mock database query
        mock_query = Mock()
        mock_query.filter.return_value.all.return_value = sample_sales_data
        analytics_service.db.query.return_value = mock_query
        
        # Execute test
        result = await analytics_service.get_shop_analytics("shop_001", "test_tenant")
        
        # Verify results
        assert result["shop_id"] == "shop_001"
        assert result["tenant_id"] == "test_tenant"
        assert result["total_sales"] == Decimal("1500.00")
        assert result["total_orders"] == 1
        assert result["period_start"] is not None
        assert result["period_end"] is not None
    
    @pytest.mark.asyncio
    async def test_get_payment_analytics_success(self, analytics_service, sample_payment_data):
        """Test successful payment analytics calculation."""
        # Mock database query
        mock_query = Mock()
        mock_query.filter.return_value.all.return_value = sample_payment_data
        analytics_service.db.query.return_value = mock_query
        
        # Execute test
        result = await analytics_service.get_payment_analytics("test_tenant")
        
        # Verify results
        assert result["tenant_id"] == "test_tenant"
        assert result["total_current"] == Decimal("1000.00")
        assert result["total_upcoming"] == Decimal("1500.00")
        assert result["total_overdue"] == Decimal("0.00")
        assert result["collection_rate"] == 100.0
        assert result["compliance_rate"] == 100.0
    
    @pytest.mark.asyncio
    async def test_get_overdue_analysis_success(self, analytics_service):
        """Test successful overdue analysis."""
        # Mock database query
        mock_query = Mock()
        mock_query.filter.return_value.all.return_value = [
            {
                "shop_id": "shop_001",
                "order_id": "order_001",
                "overdue_amount": Decimal("500.00"),
                "days_overdue": 5
            }
        ]
        analytics_service.db.query.return_value = mock_query
        
        # Execute test
        result = await analytics_service.get_overdue_analysis("test_tenant")
        
        # Verify results
        assert result["tenant_id"] == "test_tenant"
        assert result["total_overdue_amount"] == Decimal("500.00")
        assert result["total_overdue_orders"] == 1
        assert len(result["overdue_orders"]) == 1
        assert result["overdue_orders"][0]["shop_id"] == "shop_001"
    
    @pytest.mark.asyncio
    async def test_get_best_selling_products_success(self, analytics_service):
        """Test successful best selling products analysis."""
        # Mock database query
        mock_query = Mock()
        mock_query.filter.return_value.all.return_value = [
            {
                "product_id": "prod_001",
                "product_name": "Test Product 1",
                "total_quantity": 10,
                "total_revenue": Decimal("5000.00")
            }
        ]
        analytics_service.db.query.return_value = mock_query
        
        # Execute test
        result = await analytics_service.get_best_selling_products("test_tenant", limit=10)
        
        # Verify results
        assert result["tenant_id"] == "test_tenant"
        assert len(result["products"]) == 1
        assert result["products"][0]["product_id"] == "prod_001"
        assert result["products"][0]["total_quantity"] == 10
    
    @pytest.mark.asyncio
    async def test_database_error_handling(self, analytics_service):
        """Test database error handling."""
        # Mock database error
        analytics_service.db.query.side_effect = Exception("Database Error")
        
        # Execute test
        result = await analytics_service.get_executive_performance(1, "test_tenant")
        
        # Verify error handling
        assert result["error"] == "Database Error"
    
    def test_performance_level_thresholds(self, analytics_service):
        """Test performance level threshold calculations."""
        # Test boundary conditions
        test_cases = [
            (Decimal("9999.99"), 9, PerformanceLevel.GOOD),  # Just below excellent
            (Decimal("10000.00"), 10, PerformanceLevel.EXCELLENT),  # Exactly excellent
            (Decimal("4999.99"), 4, PerformanceLevel.AVERAGE),  # Just below good
            (Decimal("5000.00"), 5, PerformanceLevel.GOOD),  # Exactly good
            (Decimal("1999.99"), 2, PerformanceLevel.POOR),  # Just below average
            (Decimal("2000.00"), 3, PerformanceLevel.AVERAGE),  # Exactly average
        ]
        
        for sales, orders, expected_level in test_cases:
            level = analytics_service._calculate_performance_level(sales, orders)
            assert level == expected_level, f"Failed for sales={sales}, orders={orders}"
    
    def test_payment_trend_calculation_edge_cases(self, analytics_service):
        """Test payment trend calculation edge cases."""
        # Test with zero values
        trend = analytics_service._calculate_payment_trend(Decimal("0.00"), Decimal("0.00"))
        assert trend == PaymentTrend.STABLE
        
        # Test with very small differences
        trend = analytics_service._calculate_payment_trend(Decimal("1000.01"), Decimal("1000.00"))
        assert trend == PaymentTrend.IMPROVING
        
        # Test with large differences
        trend = analytics_service._calculate_payment_trend(Decimal("10000.00"), Decimal("1000.00"))
        assert trend == PaymentTrend.IMPROVING
    
    def test_collection_rate_edge_cases(self, analytics_service):
        """Test collection rate calculation edge cases."""
        # Test with zero total due
        rate = analytics_service._calculate_payment_collection_rate(Decimal("0.00"), Decimal("0.00"))
        assert rate == 0.0
        
        # Test with collected > total due (should cap at 100%)
        rate = analytics_service._calculate_payment_collection_rate(Decimal("1500.00"), Decimal("1000.00"))
        assert rate == 100.0
    
    def test_compliance_rate_edge_cases(self, analytics_service):
        """Test compliance rate calculation edge cases."""
        # Test with zero total orders
        rate = analytics_service._calculate_compliance_rate(0, 0)
        assert rate == 0.0
        
        # Test with compliant > total (should cap at 100%)
        rate = analytics_service._calculate_compliance_rate(10, 5)
        assert rate == 100.0
    
    @pytest.mark.asyncio
    async def test_analytics_with_empty_data(self, analytics_service):
        """Test analytics with empty data sets."""
        # Mock empty database query
        mock_query = Mock()
        mock_query.filter.return_value.all.return_value = []
        analytics_service.db.query.return_value = mock_query
        
        # Test executive performance with no data
        result = await analytics_service.get_executive_performance(1, "test_tenant")
        assert result["total_sales"] == Decimal("0.00")
        assert result["total_orders"] == 0
        assert result["performance_level"] == PerformanceLevel.POOR
        
        # Test payment analytics with no data
        result = await analytics_service.get_payment_analytics("test_tenant")
        assert result["total_current"] == Decimal("0.00")
        assert result["total_upcoming"] == Decimal("0.00")
        assert result["total_overdue"] == Decimal("0.00")
        assert result["collection_rate"] == 0.0
        assert result["compliance_rate"] == 0.0

