#!/usr/bin/env python3
"""
Test script for Outstanding API endpoints with proper JWT authentication
"""

import requests
import json
import jwt
from datetime import date, datetime, timedelta

# Test configuration
BACKEND_URL = "http://localhost:8000"
TENANT_ID = "default"
SECRET_KEY = "your-super-secret-key-for-development-only-change-in-production"

# User from database (superadmin)
TEST_USER = {
    "id": "2",
    "role": "superadmin", 
    "tenant_id": "default"
}

def create_jwt_token(user_id: str, role: str, tenant_id: str) -> str:
    """Create a valid JWT token for testing"""
    payload = {
        "sub": user_id,
        "role": role,
        "tenant_id": tenant_id,
        "exp": datetime.utcnow() + timedelta(minutes=30),
        "iat": datetime.utcnow()
    }
    
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")

def test_get_outstanding():
    """Test getting outstanding records"""
    print("Testing GET outstanding...")
    
    # Create valid token
    token = create_jwt_token(
        TEST_USER["id"], 
        TEST_USER["role"], 
        TEST_USER["tenant_id"]
    )
    
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    response = requests.get(url, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"Found {len(data)} outstanding records")
        if data:
            print(f"First record: {json.dumps(data[0], indent=2, default=str)}")
        return data
    else:
        print(f"Failed to get outstanding: {response.text}")
        return None

def test_create_outstanding():
    """Test creating an outstanding record"""
    print("\nTesting CREATE outstanding...")
    
    # Create valid token
    token = create_jwt_token(
        TEST_USER["id"], 
        TEST_USER["role"], 
        TEST_USER["tenant_id"]
    )
    
    test_data = {
        "shop_id": "SHOP-TEST-001",
        "shop_name": "Test Shop for Outstanding",
        "amount": 2500.00,
        "due_date": "2025-01-20",
        "status": "upcoming",
        "sales_executive_id": 2,
        "territory_id": "TERR001",
        "notes": "Test outstanding record via API"
    }
    
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    response = requests.post(url, json=test_data, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 201:
        created = response.json()
        print(f"Created record: {json.dumps(created, indent=2, default=str)}")
        return created
    else:
        print(f"Failed to create outstanding: {response.text}")
        return None

def test_outstanding_summary():
    """Test getting outstanding summary"""
    print("\nTesting GET outstanding summary...")
    
    # Create valid token
    token = create_jwt_token(
        TEST_USER["id"], 
        TEST_USER["role"], 
        TEST_USER["tenant_id"]
    )
    
    url = f"{BACKEND_URL}/api/v1/outstanding/summary/statistics?tenant_id={TENANT_ID}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    response = requests.get(url, headers=headers)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 200:
        summary = response.json()
        print(f"Summary: {json.dumps(summary, indent=2, default=str)}")
        return summary
    else:
        print(f"Failed to get summary: {response.text}")
        return None

def test_outstanding_filters():
    """Test getting outstanding with filters"""
    print("\nTesting GET outstanding with filters...")
    
    # Create valid token
    token = create_jwt_token(
        TEST_USER["id"], 
        TEST_USER["role"], 
        TEST_USER["tenant_id"]
    )
    
    # Test with status filter
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}&status=overdue"
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    response = requests.get(url, headers=headers)
    print(f"Overdue records - Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Found {len(data)} overdue records")
    
    # Test with amount filter
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}&min_amount=10000"
    response = requests.get(url, headers=headers)
    print(f"High amount records (>=10000) - Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"Found {len(data)} high amount records")

if __name__ == "__main__":
    print("Testing Outstanding API with proper authentication...")
    print(f"Using tenant: {TENANT_ID}")
    print(f"Using user: {TEST_USER}")
    print("-" * 60)
    
    # Test in order
    records = test_get_outstanding()
    
    if records is not None:
        created = test_create_outstanding()
        test_outstanding_summary() 
        test_outstanding_filters()
    else:
        print("Skipping other tests due to GET failure")