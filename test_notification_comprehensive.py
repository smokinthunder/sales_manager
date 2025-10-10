#!/usr/bin/env python3
"""
Comprehensive test for notification confirmation endpoint with real data
"""

import requests
import json
import time

def wait_for_rate_limit():
    """Wait for rate limit to reset"""
    print("⏳ Waiting for rate limit to reset...")
    time.sleep(30)

def test_notification_confirmation_with_real_data():
    """Test notification confirmation with existing database data"""
    
    print("============================================================")
    print("NOTIFICATION CONFIRMATION TEST - WITH REAL DATA")
    print("============================================================\n")
    
    BASE_URL = "http://localhost:8000"
    
    # Test with user ID 3 (+1111111113) who has an unconfirmed customer_creation notification
    phone = "+1111111113"
    tenant_id = "AQUASTAR"
    
    print(f"Testing with user: {phone}")
    print("This user has notification ID 3 (customer_creation, unconfirmed)")
    print()
    
    # Step 1: Generate OTP
    print("=== Step 1: Generate OTP ===")
    try:
        response = requests.post(f"{BASE_URL}/api/v1/auth/otp/generate?phone={phone}&tenant_id={tenant_id}")
        
        if response.status_code == 429:  # Rate limited
            wait_for_rate_limit()
            response = requests.post(f"{BASE_URL}/api/v1/auth/otp/generate?phone={phone}&tenant_id={tenant_id}")
        
        if response.status_code != 200:
            print(f"❌ Failed to generate OTP: {response.text}")
            return
            
        print("✅ OTP generated successfully")
        
    except Exception as e:
        print(f"❌ Error generating OTP: {e}")
        return
    
    # Step 2: Get OTP from logs
    print("\n=== Step 2: Getting OTP from backend logs ===")
    try:
        import subprocess
        result = subprocess.run(
            ["docker", "logs", "sales_manager_backend"], 
            capture_output=True, 
            text=True,
            cwd="/home/antesh/Desktop/sales_manager"
        )
        
        # Find the latest OTP for this phone number
        lines = result.stdout.split('\n')
        latest_otp = None
        
        for line in reversed(lines):
            if f"phone={phone}" in line and "Development OTP" in line:
                # Extract OTP from line like: "otp=123456 phone=+1111111113"
                parts = line.split()
                for part in parts:
                    if part.startswith("otp="):
                        latest_otp = part.split("=")[1]
                        break
                if latest_otp:
                    break
        
        if not latest_otp:
            print(f"❌ Could not find OTP in logs for {phone}")
            return
            
        print(f"✅ Found OTP: {latest_otp}")
        
    except Exception as e:
        print(f"❌ Error getting OTP from logs: {e}")
        return
    
    # Step 3: Verify OTP
    print("\n=== Step 3: Verify OTP ===")
    try:
        response = requests.post(f"{BASE_URL}/api/v1/auth/otp/verify?phone={phone}&otp={latest_otp}&tenant_id={tenant_id}")
        
        if response.status_code != 200:
            print(f"❌ Failed to verify OTP: {response.text}")
            return
        
        print("✅ OTP verified successfully")
        auth_data = response.json()
        token = auth_data["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        print(f"User info: {auth_data.get('user', {})}")
        
    except Exception as e:
        print(f"❌ Error verifying OTP: {e}")
        return
    
    # Step 4: Get notifications for this user
    print("\n=== Step 4: Get Notifications ===")
    try:
        response = requests.get(f"{BASE_URL}/api/v1/notifications", headers=headers)
        
        if response.status_code != 200:
            print(f"❌ Failed to get notifications: {response.text}")
            return
        
        notifications = response.json()
        print(f"✅ Found {len(notifications)} notifications for this user")
        
        # Show all notifications
        for notif in notifications:
            status = "✅ Confirmed" if notif.get('is_confirmed') else "⏳ Pending"
            print(f"  ID: {notif['id']}, Type: {notif.get('notification_type', 'N/A')}, Status: {status}")
        
        # Find unconfirmed notifications
        unconfirmed = [n for n in notifications if not n.get('is_confirmed')]
        
        if not unconfirmed:
            print("ℹ️ No unconfirmed notifications found for this user")
            return
            
        notification_to_test = unconfirmed[0]
        notification_id = notification_to_test["id"]
        
        print(f"\n📋 Testing with notification ID: {notification_id}")
        print(f"   Type: {notification_to_test.get('notification_type')}")
        print(f"   Subject: {notification_to_test.get('subject', 'N/A')}")
        
    except Exception as e:
        print(f"❌ Error getting notifications: {e}")
        return
    
    # Step 5: Test notification confirmation
    print("\n=== Step 5: Test Notification Confirmation ===")
    try:
        confirmation_data = {
            "action": "approve",
            "comments": "Test approval from automated test script"
        }
        
        print(f"Making request to: {BASE_URL}/api/v1/notifications/{notification_id}/confirm")
        print(f"With data: {json.dumps(confirmation_data, indent=2)}")
        print(f"With headers: Authorization: Bearer {token[:20]}...")
        
        response = requests.post(
            f"{BASE_URL}/api/v1/notifications/{notification_id}/confirm",
            json=confirmation_data,
            headers=headers
        )
        
        print(f"\nResponse status: {response.status_code}")
        print(f"Response headers: {dict(response.headers)}")
        print(f"Response body: {response.text}")
        
        if response.status_code == 200:
            print("\n✅ Notification confirmation successful!")
            result = response.json()
            print(f"Result: {json.dumps(result, indent=2)}")
        else:
            print(f"\n❌ Notification confirmation failed with status {response.status_code}")
            try:
                error_details = response.json()
                print(f"Error details: {json.dumps(error_details, indent=2)}")
            except:
                print(f"Raw error response: {response.text}")
                
    except Exception as e:
        print(f"❌ Error during notification confirmation: {e}")
        return
    
    # Step 6: Verify the confirmation worked
    print("\n=== Step 6: Verify Confirmation ===")
    try:
        response = requests.get(f"{BASE_URL}/api/v1/notifications", headers=headers)
        
        if response.status_code == 200:
            notifications = response.json()
            updated_notification = next((n for n in notifications if str(n['id']) == str(notification_id)), None)
            
            if updated_notification:
                if updated_notification.get('is_confirmed'):
                    print("✅ Notification was successfully confirmed!")
                else:
                    print("❌ Notification is still not confirmed")
            else:
                print("❌ Could not find the notification after confirmation")
        else:
            print(f"❌ Failed to verify confirmation: {response.text}")
            
    except Exception as e:
        print(f"❌ Error verifying confirmation: {e}")
    
    print("\n=== Test Complete ===")

if __name__ == "__main__":
    test_notification_confirmation_with_real_data()