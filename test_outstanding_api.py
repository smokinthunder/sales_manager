#!/usr/bin/env python3
"""
Test script for Outstanding API endpoints
"""

import requests
import json
from datetime import date, datetime

# Test configuration
BACKEND_URL = "http://localhost:8000"
TENANT_ID = "test_tenant"

# Test data
test_outstanding_data = {
    "shop_id": "SHOP001",
    "shop_name": "Test Shop",
    "amount": 1500.00,
    "due_date": "2025-01-15",
    "status": "upcoming",
    "sales_executive_id": 1,
    "territory_id": "TERR001",
    "notes": "Test outstanding record"
}

def test_create_outstanding():
    """Test creating an outstanding record"""
    print("Testing CREATE outstanding...")
    
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}"
    headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer test_token"  # This will need to be a valid token
    }
    
    response = requests.post(url, json=test_outstanding_data, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 201:
        return response.json()
    else:
        print(f"Failed to create outstanding: {response.text}")
        return None

def test_get_outstanding():
    """Test getting outstanding records"""
    print("\nTesting GET outstanding...")
    
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}"
    headers = {
        "Authorization": "Bearer test_token"  # This will need to be a valid token
    }
    
    response = requests.get(url, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    return response.json() if response.status_code == 200 else None

def test_data_layer_direct():
    """Test data layer directly"""
    print("\nTesting Data Layer directly...")
    
    # Test health first
    response = requests.get("http://localhost:8001/health")
    print(f"Data Layer Health - Status: {response.status_code}, Response: {response.text}")
    
    # Test creating due data directly
    url = f"http://localhost:8001/api/due-data/{TENANT_ID}"
    data = {
        **test_outstanding_data,
        "tenant_id": TENANT_ID
    }
    
    response = requests.post(url, json=data)
    print(f"Direct Data Layer CREATE - Status: {response.status_code}, Response: {response.text}")

if __name__ == "__main__":
    print("Testing Outstanding API...")
    
    # First test data layer directly
    test_data_layer_direct()
    
    # Then test through backend (will fail due to auth, but we can see the error)
    created_record = test_create_outstanding()
    
    if created_record:
        test_get_outstanding()
    else:
        print("Skipping GET test due to CREATE failure")