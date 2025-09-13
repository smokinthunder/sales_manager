"""
Unit tests for 30-day payment policy logic.

Tests payment due date calculations, status determination,
and business rule enforcement.
"""

import pytest
from unittest.mock import patch, Mock
from datetime import datetime, timedelta, date
from decimal import Decimal

from app.domain.models.sync_data import (
    calculate_due_date, calculate_payment_status, calculate_shop_payment_summary,
    PaymentStatus, SyncedOrder
)


class TestPaymentPolicy:
    """Test cases for 30-day payment policy."""
    
    def test_calculate_due_date_basic(self):
        """Test basic due date calculation."""
        # Test normal case
        order_date = date(2024, 1, 15)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 2, 14)  # 30 days later
        assert due_date == expected_due_date
        
        # Test leap year
        order_date = date(2024, 1, 31)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 3, 1)  # 30 days later
        assert due_date == expected_due_date
        
        # Test year boundary
        order_date = date(2023, 12, 15)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 1, 14)  # 30 days later
        assert due_date == expected_due_date
    
    def test_calculate_due_date_edge_cases(self):
        """Test due date calculation edge cases."""
        # Test February 29th in leap year
        order_date = date(2024, 2, 29)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 3, 30)  # 30 days later
        assert due_date == expected_due_date
        
        # Test month with 31 days
        order_date = date(2024, 1, 31)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 3, 1)  # 30 days later
        assert due_date == expected_due_date
        
        # Test month with 30 days
        order_date = date(2024, 4, 30)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 5, 30)  # 30 days later
        assert due_date == expected_due_date
    
    def test_calculate_payment_status_current(self):
        """Test current payment status calculation."""
        # Test payment within 30 days
        order_date = date(2024, 1, 1)
        due_date = calculate_due_date(order_date)
        # Mock today to be well before due date
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 1, 15)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.CURRENT
            assert days_overdue == 0
    
    def test_calculate_payment_status_upcoming(self):
        """Test upcoming payment status calculation."""
        # Test payment approaching due date (within 7 days)
        order_date = date(2024, 1, 1)
        due_date = calculate_due_date(order_date)
        # Mock today to be within 7 days of due date
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 1, 25)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.UPCOMING
            assert days_overdue == 0
    
    def test_calculate_payment_status_overdue(self):
        """Test overdue payment status calculation."""
        # Test payment after due date
        order_date = date(2024, 1, 1)
        due_date = calculate_due_date(order_date)
        # Mock today to be after due date
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 2, 5)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.OVERDUE
            assert days_overdue == 5
    
    def test_calculate_payment_status_boundary_conditions(self):
        """Test payment status boundary conditions."""
        order_date = date(2024, 1, 1)
        due_date = calculate_due_date(order_date)
        
        # Test day 24 (upcoming threshold)
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 1, 25)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.UPCOMING
            assert days_overdue == 0
        
        # Test day 25 (current threshold - more than 7 days before due)
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 1, 20)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.CURRENT
            assert days_overdue == 0
        
        # Test day 30 (due date) - should be upcoming since it's within 7 days
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 1, 31)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.UPCOMING
            assert days_overdue == 0
        
        # Test day 31 (overdue)
        with patch('app.domain.models.sync_data.date') as mock_date:
            mock_date.today.return_value = date(2024, 2, 1)
            status, days_overdue = calculate_payment_status(due_date)
            assert status == PaymentStatus.OVERDUE
            assert days_overdue == 1
    
    def test_calculate_shop_payment_summary(self):
        """Test shop payment summary calculation."""
        # Create mock orders
        orders = [
            Mock(spec=SyncedOrder, order_amount=1000.00, payment_status=PaymentStatus.CURRENT),
            Mock(spec=SyncedOrder, order_amount=1500.00, payment_status=PaymentStatus.UPCOMING),
            Mock(spec=SyncedOrder, order_amount=500.00, payment_status=PaymentStatus.OVERDUE)
        ]
        
        current, upcoming, overdue = calculate_shop_payment_summary(orders)
        
        # Verify summary calculations
        assert current == 1000.00
        assert upcoming == 1500.00
        assert overdue == 500.00
    
    def test_calculate_shop_payment_summary_empty(self):
        """Test shop payment summary with empty data."""
        orders = []
        current, upcoming, overdue = calculate_shop_payment_summary(orders)
        
        # Verify empty summary
        assert current == 0.0
        assert upcoming == 0.0
        assert overdue == 0.0
    
    def test_payment_policy_consistency(self):
        """Test payment policy consistency across different scenarios."""
        # Test consistency with different order dates
        test_cases = [
            date(2024, 1, 1),
            date(2024, 2, 15),
            date(2024, 6, 30),
            date(2024, 12, 31)
        ]
        
        for order_date in test_cases:
            due_date = calculate_due_date(order_date)
            
            # Verify due date is exactly 30 days later
            expected_due_date = order_date + timedelta(days=30)
            assert due_date == expected_due_date
    
    def test_payment_status_enum_values(self):
        """Test PaymentStatus enum values."""
        assert PaymentStatus.CURRENT.value == "current"
        assert PaymentStatus.UPCOMING.value == "upcoming"
        assert PaymentStatus.OVERDUE.value == "overdue"
        
        # Test enum comparison
        status1 = PaymentStatus.CURRENT
        status2 = PaymentStatus.UPCOMING
        assert status1 != status2
        assert status1 == PaymentStatus.CURRENT
    
    def test_decimal_precision(self):
        """Test decimal precision in calculations."""
        # Test with decimal amounts
        amount = Decimal("1234.567890")
        assert amount == Decimal("1234.567890")
        
        # Test payment summary with decimal amounts
        orders = [
            Mock(spec=SyncedOrder, order_amount=1234.567890, payment_status=PaymentStatus.CURRENT)
        ]
        
        current, upcoming, overdue = calculate_shop_payment_summary(orders)
        assert current == 1234.567890
        assert upcoming == 0.0
        assert overdue == 0.0
    
    def test_edge_case_february_29th(self):
        """Test edge case with February 29th in leap year."""
        # Test order on February 29th, 2024 (leap year)
        order_date = date(2024, 2, 29)
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2024, 3, 30)
        assert due_date == expected_due_date
        
        # Test with non-leap year (should handle gracefully)
        order_date = date(2023, 2, 28)  # Non-leap year
        due_date = calculate_due_date(order_date)
        expected_due_date = date(2023, 3, 30)
        assert due_date == expected_due_date
    
    def test_performance_with_large_datasets(self):
        """Test performance with large datasets."""
        # Create large dataset
        orders = []
        for i in range(1000):
            orders.append(Mock(
                spec=SyncedOrder,
                order_amount=1000.0 + i,
                payment_status=PaymentStatus.CURRENT
            ))
        
        # Should complete quickly
        import time
        start_time = time.time()
        current, upcoming, overdue = calculate_shop_payment_summary(orders)
        end_time = time.time()
        
        # Should complete in reasonable time (< 1 second)
        assert end_time - start_time < 1.0
        assert current == sum(1000.0 + i for i in range(1000))
        assert upcoming == 0.0
        assert overdue == 0.0