#!/usr/bin/env python3
"""
Simple test for notification confirmation endpoint
"""

import requests
import time

def test_notification_confirmation():
    """Test the notification confirmation workflow"""
    
    print("============================================================")
    print("NOTIFICATION CONFIRMATION TEST - SIMPLE VERSION")
    print("============================================================\n")
    
    BASE_URL = "http://localhost:8000"
    
    # Step 1: Generate OTP
    print("=== Step 1: Generate OTP ===")
    response = requests.post(f"{BASE_URL}/api/v1/auth/otp/generate?phone=+1111111111&tenant_id=AQUASTAR")
    
    if response.status_code != 200:
        print(f"❌ Failed to generate OTP: {response.text}")
        return
        
    print("✅ OTP generated. Please check backend logs for the OTP...")
    print("Run: docker logs sales_manager_backend | grep 'Development OTP' | tail -1")
    print("Then enter the OTP below:")
    
    otp = input("Enter OTP: ").strip()
    
    # Step 2: Verify OTP
    print("\n=== Step 2: Verify OTP ===")
    response = requests.post(f"{BASE_URL}/api/v1/auth/otp/verify?phone=+1111111111&otp={otp}&tenant_id=AQUASTAR")
    
    if response.status_code != 200:
        print(f"❌ Failed to verify OTP: {response.text}")
        return
    
    print("✅ OTP verified successfully")
    token = response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    
    # Step 3: Get notifications
    print("\n=== Step 3: Get Notifications ===")
    response = requests.get(f"{BASE_URL}/api/v1/notifications", headers=headers)
    
    if response.status_code != 200:
        print(f"❌ Failed to get notifications: {response.text}")
        return
    
    notifications = response.json()
    print(f"✅ Found {len(notifications)} notifications")
    
    if not notifications:
        print("ℹ️ No notifications found. You may need to create a shop first to generate notifications.")
        return
    
    # Show all notifications
    for i, notif in enumerate(notifications):
        print(f"  {i+1}. ID: {notif['id']}, Type: {notif.get('notification_type', 'N/A')}, Subject: {notif.get('subject', 'N/A')}")
    
    # Step 4: Test notification confirmation with first notification
    print("\n=== Step 4: Test Notification Confirmation ===")
    
    notification_id = notifications[0]["id"]
    print(f"Testing confirmation for notification ID: {notification_id}")
    
    confirmation_data = {
        "action": "approve",
        "comments": "Test approval from confirmation test"
    }
    
    response = requests.post(f"{BASE_URL}/api/v1/notifications/{notification_id}/confirm",
                           json=confirmation_data,
                           headers=headers)
    
    print(f"Confirmation request status: {response.status_code}")
    print(f"Response: {response.text}")
    
    if response.status_code == 200:
        print("✅ Notification confirmation successful!")
    else:
        print(f"❌ Notification confirmation failed")
    
    print("\n=== Test Complete ===")

if __name__ == "__main__":
    test_notification_confirmation()