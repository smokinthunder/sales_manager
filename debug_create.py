#!/usr/bin/env python3
"""
Debug script for CREATE outstanding endpoint
"""

import json
import requests

# Configuration
BACKEND_URL = "http://localhost:8001"
TENANT_ID = "default"

# Test user info
TEST_USER = {
    "id": "2",
    "role": "superadmin", 
    "tenant_id": "default"
}

def create_jwt_token(user_id: str, role: str, tenant_id: str):
    """Create a JWT token for testing"""
    import jwt
    from datetime import datetime, timedelta
    
    # Use the same secret as the backend
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

def test_models():
    """Test the models directly"""
    try:
        from app.domain.models.outstanding import DueDataCreate
        from datetime import date
        
        # Test the model can be created without tenant_id
        test_data = {
            "shop_id": "SHOP-TEST-001",
            "shop_name": "Test Shop",
            "amount": 2500.00,
            "due_date": date(2025, 1, 20),
            "status": "upcoming",
            "sales_executive_id": 2,
            "territory_id": "TERR001",
            "notes": "Test outstanding record"
        }
        
        model = DueDataCreate(**test_data)
        print("✅ DueDataCreate model validation passed")
        print(f"Model data: {model.model_dump()}")
        return True
        
    except Exception as e:
        print(f"❌ Model validation failed: {e}")
        return False

def test_api_endpoint():
    """Test the API endpoint directly"""
    print("\n🔍 Testing API endpoint...")
    
    # Create token
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
    
    print(f"🌐 POST {url}")
    print(f"📋 Headers: {headers}")
    print(f"📄 Data: {json.dumps(test_data, indent=2)}")
    
    try:
        response = requests.post(url, headers=headers, json=test_data, timeout=10)
        print(f"📊 Status Code: {response.status_code}")
        print(f"📝 Response: {response.text}")
        
        if response.status_code == 422:
            # Parse validation error
            error_data = response.json()
            print(f"\n❌ Validation Error Details:")
            if 'detail' in error_data and 'errors' in error_data['detail'] if isinstance(error_data['detail'], dict) else False:
                for error in error_data['detail']['errors']:
                    print(f"  - {error}")
            elif 'errors' in error_data:
                for error in error_data['errors']:
                    print(f"  - {error}")
        
        return response.status_code == 201
        
    except Exception as e:
        print(f"❌ Request failed: {e}")
        return False

if __name__ == "__main__":
    print("🔧 Debugging CREATE outstanding endpoint...")
    
    print("\n1️⃣ Testing model validation...")
    model_ok = test_models()
    
    print("\n2️⃣ Testing API endpoint...")
    api_ok = test_api_endpoint()
    
    print(f"\n📊 Results:")
    print(f"  Model validation: {'✅ PASS' if model_ok else '❌ FAIL'}")
    print(f"  API endpoint: {'✅ PASS' if api_ok else '❌ FAIL'}")