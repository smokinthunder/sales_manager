#!/bin/bash

# Helper script to extract OTP from backend logs
# This script watches for OTP generation in the backend logs

echo "=== OTP Extraction Helper ==="
echo "This script will help you extract OTPs from backend logs."
echo

# Function to get recent OTP from logs
get_recent_otp() {
    local phone=$1
    echo "Looking for OTP for phone: $phone"
    
    # Get the most recent OTP log entry
    local otp_line=$(docker logs sales_manager_backend 2>&1 | grep "Development OTP" | grep "$phone" | tail -1)
    
    if [[ -n "$otp_line" ]]; then
        # Extract OTP from the log line using regex
        local otp=$(echo "$otp_line" | grep -o 'otp=[0-9]*' | cut -d'=' -f2)
        if [[ -n "$otp" ]]; then
            echo "Found OTP: $otp"
            echo "$otp"
            return 0
        fi
    fi
    
    echo "No OTP found for $phone"
    return 1
}

# Function to generate OTP for a phone number
generate_otp() {
    local phone=$1
    local tenant_id=$2
    
    echo "Generating OTP for $phone in tenant $tenant_id..."
    
    # Make API call to generate OTP
    curl -X POST "http://localhost:8000/api/v1/auth/otp/generate?phone=$phone&tenant_id=$tenant_id" \
         -H "Content-Type: application/json" \
         -s | jq .
    
    echo
    echo "Waiting for OTP to appear in logs..."
    sleep 2
    
    # Get the OTP from logs
    get_recent_otp "$phone"
}

# Main execution
if [[ $# -eq 2 ]]; then
    generate_otp "$1" "$2"
elif [[ $# -eq 1 ]]; then
    get_recent_otp "$1"
else
    echo "Usage:"
    echo "  $0 <phone>           - Extract existing OTP from logs"
    echo "  $0 <phone> <tenant>  - Generate new OTP and extract from logs"
    echo
    echo "Examples:"
    echo "  $0 +1111111121"
    echo "  $0 +1111111121 AQUASTAR"
fi