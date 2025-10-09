#!/usr/bin/env python3
"""
Test script for Add Shop API functionality.

Tests the add shops API endpoint with different user roles:
1. sales_executive - should create approval notification
2. area_manager - should create shop directly

This script tests the approval workflow and role-based permissions.
"""

import requests
import json
import time
from datetime import datetime

# Configuration
BASE_URL = "http://localhost:8000"
TENANT_ID = "AQUASTAR"

# Test users (these should exist in your database)
SALES_EXECUTIVE_USER = {
    "phone": "+1111111121",  # Alex Thompson - sales_executive in AQ-NORTH
    "password": "password123"
}

AREA_MANAGER_USER = {
    "phone": "+1111111112",  # Sarah Johnson - area_manager in AQ-NORTH 
    "password": "password123"
}

# Test shop data
SHOP_DATA_TEMPLATE = {
    "shop_id": "SH{timestamp}",
    "name": "Test Shop {timestamp}",
    "address": "123 Test Street",
    "phone": "+1111111111",
    "contact_person": "Test Contact",
    "latitude": 40.7128,
    "longitude": -74.0060,
    "status": "active"
}

def make_request(method, endpoint, headers=None, data=None, params=None):
    """Make HTTP request with error handling."""
    url = f"{BASE_URL}{endpoint}"
    try:
        response = requests.request(method, url, headers=headers, json=data, params=params)
        print(f"\n{method} {url}")
        print(f"Status: {response.status_code}")
        
        if response.headers.get('content-type', '').startswith('application/json'):
            response_data = response.json()
            print(f"Response: {json.dumps(response_data, indent=2)}")
            return response.status_code, response_data
        else:
            print(f"Response: {response.text}")
            return response.status_code, response.text
    except Exception as e:
        print(f"Error making request: {e}")
        return None, None

def login_user(phone):
    """Login user using OTP flow and get JWT token."""
    print(f"\n=== Logging in user {phone} ===")
    
    # Step 1: Generate OTP
    print("Step 1: Generating OTP...")
    status, response = make_request("POST", "/api/v1/auth/otp/generate", params={"phone": phone, "tenant_id": TENANT_ID})
    
    if status != 200:
        print(f"OTP generation failed! Status: {status}")
        return None, None
    
    print("OTP generated successfully!")
    
    # Step 2: Get OTP from logs (in development mode, OTP is logged)
    print("Step 2: Please check the backend logs for the OTP...")
    print("You can find it by running: docker logs sales_manager_backend | grep 'Development OTP'")
    
    # For testing purposes, let's try a common test OTP
    # In real implementation, you'd get this from logs or SMS
    test_otps = ["123456", "000000", "111111"]
    
    for test_otp in test_otps:
        print(f"Trying OTP: {test_otp}")
        status, response = make_request(
            "POST", 
            "/api/v1/auth/otp/verify", 
            params={"phone": phone, "otp": test_otp, "tenant_id": TENANT_ID}
        )
        
        if status == 200 and response:
            token = response.get("access_token")
            user_data = response.get("user", {})
            print(f"Login successful! Role: {user_data.get('role')}")
            return token, user_data
    
    print("All test OTPs failed. Please check backend logs for the actual OTP.")
    return None, None

def create_shop(token, shop_data):
    """Create a shop using the provided token."""
    print(f"\n=== Creating shop {shop_data['shop_id']} ===")
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    status, response = make_request(
        "POST", 
        "/api/v1/shops/", 
        headers=headers, 
        data=shop_data,
        params={"tenant_id": TENANT_ID}
    )
    
    return status, response

def get_notifications(token):
    """Get notifications for the current user."""
    print(f"\n=== Getting notifications ===")
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    status, response = make_request(
        "GET", 
        "/api/v1/notifications/", 
        headers=headers,
        params={"tenant_id": TENANT_ID}
    )
    
    return status, response

def approve_notification(token, notification_id):
    """Approve a notification."""
    print(f"\n=== Approving notification {notification_id} ===")
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    approval_data = {
        "action": "approve",
        "remarks": "Approved by area manager"
    }
    
    status, response = make_request(
        "POST", 
        f"/api/v1/notifications/{notification_id}/confirm", 
        headers=headers,
        data=approval_data,
        params={"tenant_id": TENANT_ID}
    )
    
    return status, response

def get_shops(token):
    """Get all shops to verify creation."""
    print(f"\n=== Getting shops list ===")
    
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    status, response = make_request(
        "GET", 
        "/api/v1/shops/", 
        headers=headers,
        params={"tenant_id": TENANT_ID}
    )
    
    return status, response

def generate_shop_data():
    """Generate unique shop data for testing."""
    timestamp = int(time.time())
    shop_data = SHOP_DATA_TEMPLATE.copy()
    shop_data["shop_id"] = shop_data["shop_id"].format(timestamp=timestamp)
    shop_data["name"] = shop_data["name"].format(timestamp=timestamp)
    return shop_data

def main():
    """Main test function."""
    print("="*60)
    print("SHOP API TESTING SCRIPT")
    print("="*60)
    
    # Test 1: Sales Executive creates shop (should create notification)
    print("\n" + "="*50)
    print("TEST 1: Sales Executive Creating Shop")
    print("="*50)
    
    sales_exec_token, sales_exec_user = login_user(SALES_EXECUTIVE_USER["phone"])
    
    if not sales_exec_token:
        print("❌ Failed to login sales executive")
        return
    
    # Create shop as sales executive
    shop_data_1 = generate_shop_data()
    status, response = create_shop(sales_exec_token, shop_data_1)
    
    if status == 201:
        if response.get("approval_required"):
            print("✅ Sales executive shop creation requires approval (correct behavior)")
            notification_id = response.get("notification_id")
            print(f"📩 Notification ID: {notification_id}")
        else:
            print("❌ Sales executive shop was created directly (incorrect behavior)")
    else:
        print(f"❌ Shop creation failed with status {status}")
    
    # Test 2: Area Manager creates shop (should create directly)
    print("\n" + "="*50)
    print("TEST 2: Area Manager Creating Shop")
    print("="*50)
    
    area_mgr_token, area_mgr_user = login_user(AREA_MANAGER_USER["phone"])
    
    if not area_mgr_token:
        print("❌ Failed to login area manager")
        return
    
    # Create shop as area manager
    shop_data_2 = generate_shop_data()
    status, response = create_shop(area_mgr_token, shop_data_2)
    
    if status == 201:
        if not response.get("approval_required"):
            print("✅ Area manager shop was created directly (correct behavior)")
            if response.get("shop"):
                print(f"🏪 Shop created: {response['shop']['shop_id']}")
        else:
            print("❌ Area manager shop creation required approval (incorrect behavior)")
    else:
        print(f"❌ Shop creation failed with status {status}")
    
    # Test 3: Check notifications for area manager
    print("\n" + "="*50)
    print("TEST 3: Checking Notifications")
    print("="*50)
    
    status, notifications = get_notifications(area_mgr_token)
    
    if status == 200 and notifications:
        unconfirmed_notifications = [n for n in notifications if not n.get("is_confirmed")]
        if unconfirmed_notifications:
            print(f"📬 Found {len(unconfirmed_notifications)} unconfirmed notifications")
            
            # Test 4: Approve the first notification
            print("\n" + "="*50)
            print("TEST 4: Approving Notification")
            print("="*50)
            
            notification_to_approve = unconfirmed_notifications[0]
            notification_id = notification_to_approve.get("id")
            
            status, approval_response = approve_notification(area_mgr_token, notification_id)
            
            if status == 200:
                print("✅ Notification approved successfully")
                if approval_response.get("action_result"):
                    print("🏪 Shop was created from approval")
            else:
                print(f"❌ Notification approval failed with status {status}")
        else:
            print("📭 No unconfirmed notifications found")
    else:
        print("❌ Failed to get notifications")
    
    # Test 5: List all shops to verify
    print("\n" + "="*50)
    print("TEST 5: Listing All Shops")
    print("="*50)
    
    status, shops = get_shops(area_mgr_token)
    
    if status == 200:
        print(f"🏪 Total shops: {len(shops)}")
        recent_shops = [s for s in shops if s['shop_id'].startswith('SH2')]  # Recent test shops
        if recent_shops:
            print("Recent test shops:")
            for shop in recent_shops[-5:]:  # Show last 5
                print(f"  - {shop['shop_id']}: {shop['name']}")
    else:
        print("❌ Failed to get shops list")
    
    print("\n" + "="*60)
    print("TESTING COMPLETED")
    print("="*60)

if __name__ == "__main__":
    main()
