#!/usr/bin/env python3
"""
Comprehensive test runner for the AquaStar backend.

Runs all unit tests, integration tests, and end-to-end tests
to verify the complete sync and analytics functionality.
"""

import subprocess
import sys
import os
from pathlib import Path


def run_command(command, description):
    """Run a command and return the result."""
    print(f"\n{'='*60}")
    print(f"Running: {description}")
    print(f"Command: {command}")
    print(f"{'='*60}")
    
    try:
        result = subprocess.run(
            command,
            shell=True,
            capture_output=True,
            text=True,
            cwd=Path(__file__).parent
        )
        
        print(f"Exit Code: {result.returncode}")
        if result.stdout:
            print("STDOUT:")
            print(result.stdout)
        if result.stderr:
            print("STDERR:")
            print(result.stderr)
        
        return result.returncode == 0
    except Exception as e:
        print(f"Error running command: {e}")
        return False


def main():
    """Run comprehensive tests."""
    print("🚀 Starting Comprehensive Test Suite for AquaStar Backend")
    print("=" * 80)
    
    # Change to backend directory
    backend_dir = Path(__file__).parent
    os.chdir(backend_dir)
    
    # Test results
    test_results = {}
    
    # 1. Unit Tests
    print("\n📋 Running Unit Tests...")
    unit_tests = [
        ("pytest tests/services/test_sync_service.py -v", "Sync Service Unit Tests"),
        ("pytest tests/services/test_analytics_service.py -v", "Analytics Service Unit Tests"),
        ("pytest tests/test_payment_policy.py -v", "Payment Policy Unit Tests")
    ]
    
    for command, description in unit_tests:
        success = run_command(command, description)
        test_results[description] = success
    
    # 2. Integration Tests
    print("\n🔗 Running Integration Tests...")
    integration_tests = [
        ("pytest tests/api/test_sync_endpoints.py -v", "Sync API Integration Tests"),
        ("pytest tests/api/test_analytics_endpoints.py -v", "Analytics API Integration Tests")
    ]
    
    for command, description in integration_tests:
        success = run_command(command, description)
        test_results[description] = success
    
    # 3. End-to-End Tests
    print("\n🌐 Running End-to-End Tests...")
    e2e_tests = [
        ("pytest tests/e2e/test_sync_analytics_workflow.py -v", "Sync & Analytics Workflow E2E Tests")
    ]
    
    for command, description in e2e_tests:
        success = run_command(command, description)
        test_results[description] = success
    
    # 4. All Tests Together
    print("\n🎯 Running All Tests Together...")
    all_tests_success = run_command(
        "pytest tests/ -v --tb=short",
        "All Tests Combined"
    )
    test_results["All Tests Combined"] = all_tests_success
    
    # 5. Test Coverage
    print("\n📊 Running Test Coverage...")
    coverage_success = run_command(
        "pytest tests/ --cov=app --cov-report=html --cov-report=term",
        "Test Coverage Analysis"
    )
    test_results["Test Coverage"] = coverage_success
    
    # 6. Performance Tests
    print("\n⚡ Running Performance Tests...")
    performance_success = run_command(
        "pytest tests/ -k 'performance' -v",
        "Performance Tests"
    )
    test_results["Performance Tests"] = performance_success
    
    # Summary
    print("\n" + "="*80)
    print("📋 TEST RESULTS SUMMARY")
    print("="*80)
    
    total_tests = len(test_results)
    passed_tests = sum(1 for success in test_results.values() if success)
    failed_tests = total_tests - passed_tests
    
    for test_name, success in test_results.items():
        status = "✅ PASSED" if success else "❌ FAILED"
        print(f"{status} {test_name}")
    
    print(f"\n📊 Overall Results:")
    print(f"   Total Test Suites: {total_tests}")
    print(f"   Passed: {passed_tests}")
    print(f"   Failed: {failed_tests}")
    print(f"   Success Rate: {(passed_tests/total_tests)*100:.1f}%")
    
    if failed_tests == 0:
        print("\n🎉 All tests passed! The system is ready for production.")
        return 0
    else:
        print(f"\n⚠️  {failed_tests} test suite(s) failed. Please review the results above.")
        return 1


if __name__ == "__main__":
    sys.exit(main())

