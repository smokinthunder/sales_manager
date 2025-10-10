#!/usr/bin/env python3
"""
Direct test for notification confirmation endpoint
"""

import requests
import json

def test_notification_confirmation_direct():
    """Direct test with known values"""
    
    print("============================================================")
    print("DIRECT NOTIFICATION CONFIRMATION TEST")
    print("============================================================\n")
    
    BASE_URL = "http://localhost:8000"
    
    # Known values from database and logs
    phone = "+1111111112"
    otp = "020960"  # From backend logs
    tenant_id = "AQUASTAR"
    notification_id = "11"  # From database query - user 36 has notification 11 (customer_creation)
    
    print(f"Testing notification confirmation:")
    print(f"  User: {phone}")
    print(f"  OTP: {otp}")
    print(f"  Notification ID: {notification_id}")
    print()
    
    # Step 1: Verify OTP
    print("=== Step 1: Verify OTP ===")
    try:
        response = requests.post(f"{BASE_URL}/api/v1/auth/otp/verify?phone={phone}&otp={otp}&tenant_id={tenant_id}")
        
        if response.status_code != 200:
            print(f"❌ Failed to verify OTP: {response.text}")
            return
        
        print("✅ OTP verified successfully")
        auth_data = response.json()
        token = auth_data["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        user_info = auth_data.get('user', {})
        print(f"  User ID: {user_info.get('id')}")
        print(f"  Role: {user_info.get('role')}")
        
    except Exception as e:
        print(f"❌ Error verifying OTP: {e}")
        return
    
    # Step 2: Get notifications to verify access
    print("\n=== Step 2: Get User Notifications ===")
    try:
        response = requests.get(f"{BASE_URL}/api/v1/notifications?tenant_id={tenant_id}", headers=headers)
        
        if response.status_code != 200:
            print(f"❌ Failed to get notifications: {response.text}")
            return
        
        notifications = response.json()
        print(f"✅ User has {len(notifications)} notifications")
        
        target_notification = None
        for notif in notifications:
            if str(notif['id']) == notification_id:
                target_notification = notif
                break
        
        if target_notification:
            print(f"✅ Found target notification:")
            print(f"  ID: {target_notification['id']}")
            print(f"  Type: {target_notification.get('notification_type')}")
            print(f"  Subject: {target_notification.get('subject', 'N/A')}")
            print(f"  Confirmed: {target_notification.get('is_confirmed')}")
        else:
            print(f"❌ Target notification {notification_id} not found for this user")
            print("Available notifications:")
            for notif in notifications:
                print(f"  ID: {notif['id']}, Type: {notif.get('notification_type')}, Confirmed: {notif.get('is_confirmed')}")
            return
        
    except Exception as e:
        print(f"❌ Error getting notifications: {e}")
        return
    
    # Step 3: Test notification confirmation
    print("\n=== Step 3: Confirm Notification ===")
    try:
        confirmation_data = {
            "action": "approve",
            "comments": "Direct test approval"
        }
        
        confirmation_url = f"{BASE_URL}/api/v1/notifications/{notification_id}/confirm?tenant_id={tenant_id}"
        print(f"Making POST request to: {confirmation_url}")
        print(f"Data: {json.dumps(confirmation_data, indent=2)}")
        
        response = requests.post(
            confirmation_url,
            json=confirmation_data,
            headers=headers
        )
        
        print(f"\nResponse Status: {response.status_code}")
        print(f"Response Body: {response.text}")
        
        if response.status_code == 200:
            print("\n✅ SUCCESS: Notification confirmation worked!")
            try:
                result_data = response.json()
                print(f"Response data: {json.dumps(result_data, indent=2)}")
            except:
                pass
        else:
            print(f"\n❌ FAILED: Notification confirmation failed with status {response.status_code}")
            try:
                error_data = response.json()
                print(f"Error details: {json.dumps(error_data, indent=2)}")
            except:
                print(f"Raw response: {response.text}")
                
    except Exception as e:
        print(f"❌ Error during notification confirmation: {e}")
        return
    
    # Step 4: Verify the result
    print("\n=== Step 4: Verify Result ===")
    try:
        response = requests.get(f"{BASE_URL}/api/v1/notifications?tenant_id={tenant_id}", headers=headers)
        
        if response.status_code == 200:
            notifications = response.json()
            updated_notification = next((n for n in notifications if str(n['id']) == notification_id), None)
            
            if updated_notification:
                is_confirmed = updated_notification.get('is_confirmed')
                print(f"Notification {notification_id} is_confirmed: {is_confirmed}")
                
                if is_confirmed:
                    print("✅ VERIFICATION PASSED: Notification was successfully confirmed!")
                else:
                    print("❌ VERIFICATION FAILED: Notification is still not confirmed")
            else:
                print("❌ Could not find the notification after confirmation attempt")
        else:
            print(f"❌ Failed to get notifications for verification: {response.text}")
            
    except Exception as e:
        print(f"❌ Error during verification: {e}")
    
    print("\n=== Test Complete ===")

if __name__ == "__main__":
    test_notification_confirmation_direct()