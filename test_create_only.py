#!/usr/bin/env python3
"""
Test ONLY the CREATE outstanding endpoint
"""

import json
import requests
import jwt
from datetime import datetime, timedelta

# Configuration
BACKEND_URL = "http://backend:8000"
TENANT_ID = "default"

# Test user info
TEST_USER = {
    "id": "2",
    "role": "superadmin", 
    "tenant_id": "default"
}

def create_jwt_token(user_id: str, role: str, tenant_id: str):
    """Create a JWT token for testing"""
    secret_key = "your_secret_key_here_make_it_long_and_secure_in_production_please"
    
    payload = {
        "sub": str(user_id),
        "role": role,
        "tenant_id": tenant_id,
        "exp": datetime.utcnow() + timedelta(hours=24),
        "iat": datetime.utcnow()
    }
    
    token = jwt.encode(payload, secret_key, algorithm="HS256")
    return token

def test_create_outstanding():
    """Test creating an outstanding record"""
    print("🔍 Testing CREATE outstanding endpoint...")
    
    # Create valid token
    token = create_jwt_token(
        TEST_USER["id"], 
        TEST_USER["role"], 
        TEST_USER["tenant_id"]
    )
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    test_data = {
        "shop_id": "SHOP-TEST-CREATE",
        "shop_name": "Test Shop for CREATE Outstanding",
        "amount": 3000.00,
        "due_date": "2025-01-25",
        "status": "upcoming",
        "sales_executive_id": 2,
        "territory_id": "TERR001",
        "notes": "Test CREATE outstanding record via API"
    }
    
    url = f"{BACKEND_URL}/api/v1/outstanding/?tenant_id={TENANT_ID}"
    
    print(f"🌐 POST {url}")
    print(f"🔑 Authorization: Bearer {token[:50]}...")
    print(f"📄 Data: {json.dumps(test_data, indent=2)}")
    
    try:
        response = requests.post(url, headers=headers, json=test_data, timeout=30)
        print(f"📊 Status Code: {response.status_code}")
        print(f"📝 Response Headers: {dict(response.headers)}")
        print(f"📄 Response Body: {response.text}")
        
        if response.status_code == 201:
            print("✅ CREATE outstanding SUCCESS!")
            created_data = response.json()
            print(f"🎉 Created outstanding ID: {created_data.get('id')}")
            return True
        else:
            print(f"❌ CREATE outstanding FAILED with status {response.status_code}")
            return False
        
    except Exception as e:
        print(f"💥 Request failed with exception: {e}")
        return False

if __name__ == "__main__":
    print("🚀 Testing CREATE outstanding endpoint...")
    success = test_create_outstanding()
    print(f"\n📋 Final Result: {'✅ SUCCESS' if success else '❌ FAILED'}")