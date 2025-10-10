#!/usr/bin/env python3
"""
Test script for notification confirmation endpoint
"""

import requests
import json

# Configuration
BASE_URL = "http://localhost:8000"
OTP = "962748"  # Get this from backend logs

def test_notification_confirmation():
    """Test the notification confirmation workflow"""
    
    print("============================================================")
    print("NOTIFICATION CONFIRMATION TEST")
    print("============================================================\n")
    
    # Step 1: Login as area manager to create notification
    print("=== Step 1: Login as Area Manager ===")
    
    # Generate OTP for area manager
    response = requests.post(f"{BASE_URL}/api/v1/auth/otp/generate?phone=+1111111111&tenant_id=AQUASTAR")
    
    if response.status_code != 200:
        print(f"❌ Failed to generate OTP: {response.text}")
        return
        
    print("✅ OTP generated for area manager")
    
    # Get OTP from logs (we'll use a test OTP for now)
    # You might need to check docker logs for the actual OTP
    
    # Verify OTP
    response = requests.post(f"{BASE_URL}/api/v1/auth/otp/verify?phone=+1111111111&otp=828325&tenant_id=AQUASTAR")
    
    if response.status_code != 200:
        print(f"❌ Failed to verify OTP for area manager: {response.text}")
        # Try common test OTPs
        for test_otp in ["000000", "111111", "123456", "555555"]:
            response = requests.post(f"{BASE_URL}/api/v1/auth/otp/verify?phone=+1111111111&otp={test_otp}&tenant_id=AQUASTAR")
            if response.status_code == 200:
                print(f"✅ Area manager logged in with OTP: {test_otp}")
                break
        else:
            print("❌ Could not login area manager with any test OTP")
            return
    else:
        print("✅ Area manager logged in")
    
    area_manager_token = response.json()["access_token"]
    area_manager_headers = {"Authorization": f"Bearer {area_manager_token}"}
    
    # Step 2: Create a shop request (this should create a notification)
    print("\n=== Step 2: Create Shop Request ===")
    
    shop_data = {
        "name": "Test Notification Shop",
        "address": "123 Test Street",
        "phone": "+1234567890",
        "email": "testshop@example.com",
        "shop_type": "RETAILER",
        "owner_name": "Test Owner",
        "location": {
            "latitude": 23.8103,
            "longitude": 90.4125
        }
    }
    
    response = requests.post(f"{BASE_URL}/api/v1/shops/", 
                           json=shop_data,
                           headers=area_manager_headers)
    
    if response.status_code not in [200, 201]:
        print(f"❌ Failed to create shop: {response.text}")
        return
        
    shop_id = response.json()["id"]
    print(f"✅ Shop created with ID: {shop_id}")
    
    # Step 3: Get notifications for area manager
    print("\n=== Step 3: Get Notifications ===")
    
    response = requests.get(f"{BASE_URL}/api/v1/notifications", 
                           headers=area_manager_headers)
    
    if response.status_code != 200:
        print(f"❌ Failed to get notifications: {response.text}")
        return
        
    notifications = response.json()
    print(f"✅ Found {len(notifications)} notifications")
    
    # Find shop creation notification
    shop_notifications = [n for n in notifications if n.get("notification_type") == "SHOP_CREATION"]
    
    if not shop_notifications:
        print("❌ No shop creation notifications found")
        return
        
    notification = shop_notifications[0]
    notification_id = notification["id"]
    print(f"✅ Found shop creation notification with ID: {notification_id}")
    
    # Step 4: Test notification confirmation
    print("\n=== Step 4: Test Notification Confirmation ===")
    
    confirmation_data = {
        "action": "approve",
        "comments": "Test approval"
    }
    
    response = requests.post(f"{BASE_URL}/api/v1/notifications/{notification_id}/confirm",
                           json=confirmation_data,
                           headers=area_manager_headers)
    
    print(f"Confirmation request status: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 200:
        print("✅ Notification confirmation successful!")
    else:
        print(f"❌ Notification confirmation failed: {response.text}")
        
        # Let's check the error details
        try:
            error_details = response.json()
            print(f"Error details: {json.dumps(error_details, indent=2)}")
        except:
            pass
    
    print("\n=== Test Complete ===")

if __name__ == "__main__":
    test_notification_confirmation()