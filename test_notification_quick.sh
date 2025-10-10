#!/bin/bash
# Quick notification confirmation test

echo "============================================================"
echo "QUICK NOTIFICATION CONFIRMATION TEST"
echo "============================================================"

# Generate OTP
echo "=== Generating OTP ==="
curl -X POST "http://localhost:8000/api/v1/auth/otp/generate?phone=+1111111112&tenant_id=AQUASTAR" > /dev/null 2>&1

# Extract OTP from logs
echo "=== Getting OTP from logs ==="
OTP=$(docker logs sales_manager_backend 2>&1 | grep 'Development OTP' | tail -1 | grep -o 'otp=[0-9]*' | cut -d= -f2)
echo "OTP: $OTP"

# Verify OTP and get token
echo "=== Verifying OTP ==="
AUTH_RESPONSE=$(curl -s -X POST "http://localhost:8000/api/v1/auth/otp/verify?phone=+1111111112&otp=$OTP&tenant_id=AQUASTAR")
echo "Auth response: $AUTH_RESPONSE"

# Extract token
TOKEN=$(echo $AUTH_RESPONSE | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
echo "Token: ${TOKEN:0:20}..."

# Test notification confirmation
echo "=== Testing Notification Confirmation ==="
CONFIRM_RESPONSE=$(curl -s -X POST \
  "http://localhost:8000/api/v1/notifications/11/confirm?tenant_id=AQUASTAR" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"action": "approve", "comments": "Test approval"}')

echo "Confirmation response: $CONFIRM_RESPONSE"

# Check if notification was confirmed
echo "=== Verifying Result ==="
NOTIFICATIONS_RESPONSE=$(curl -s -X GET \
  "http://localhost:8000/api/v1/notifications?tenant_id=AQUASTAR" \
  -H "Authorization: Bearer $TOKEN")

echo "Notifications response: $NOTIFICATIONS_RESPONSE"

echo "=== Test Complete ==="