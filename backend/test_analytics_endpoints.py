#!/usr/bin/env python3
"""
Test script for analytics endpoints.

This script tests the analytics endpoints to ensure they work correctly
with proper authentication and tenant isolation.
"""

import asyncio
import httpx
import json
from datetime import datetime

# Configuration
BASE_URL = "http://localhost:8000"
TEST_TENANT_ID = "TEST"
TEST_PHONE = "+1111111111"  # Test Sales Executive

async def test_analytics_endpoints():
    """Test all analytics endpoints."""
    
    async with httpx.AsyncClient() as client:
        print("🚀 Starting Analytics Endpoints Test")
        print("=" * 50)
        
        # Step 1: Generate OTP
        print("📱 Step 1: Generating OTP...")
        otp_response = await client.post(
            f"{BASE_URL}/api/v1/auth/otp/generate",
            params={"phone": TEST_PHONE, "tenant_id": TEST_TENANT_ID}
        )
        
        if otp_response.status_code != 200:
            print(f"❌ Failed to generate OTP: {otp_response.status_code}")
            print(f"Response: {otp_response.text}")
            return
        
        otp_data = otp_response.json()
        print(f"✅ OTP generated successfully: {otp_data.get('message', 'N/A')}")
        
        # Step 2: Verify OTP (using a test OTP - in real scenario, this would be from SMS)
        print("\n🔐 Step 2: Verifying OTP...")
        verify_response = await client.post(
            f"{BASE_URL}/api/v1/auth/otp/verify",
            json={
                "phone": TEST_PHONE,
                "otp": "123456",  # Test OTP
                "tenant_id": TEST_TENANT_ID
            }
        )
        
        if verify_response.status_code != 200:
            print(f"❌ Failed to verify OTP: {verify_response.status_code}")
            print(f"Response: {verify_response.text}")
            print("Note: Using test OTP '123456' - this might fail in production")
            return
        
        auth_data = verify_response.json()
        access_token = auth_data.get("access_token")
        if not access_token:
            print("❌ No access token received")
            return
        
        print("✅ OTP verified successfully")
        
        # Headers for authenticated requests
        headers = {"Authorization": f"Bearer {access_token}"}
        
        # Step 3: Test Executive Analytics Endpoints
        print("\n👨‍💼 Step 3: Testing Executive Analytics Endpoints")
        print("-" * 40)
        
        # Test top customers
        print("📊 Testing GET /analytics/executive/top_customers...")
        top_customers_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/executive/top_customers",
            params={"tenant_id": TEST_TENANT_ID},
            headers=headers
        )
        
        if top_customers_response.status_code == 200:
            top_customers = top_customers_response.json()
            print(f"✅ Top customers retrieved: {len(top_customers)} customers")
            for customer in top_customers[:3]:  # Show first 3
                print(f"   - {customer['shop_name']}: {customer['points']} points")
        else:
            print(f"❌ Failed to get top customers: {top_customers_response.status_code}")
            print(f"Response: {top_customers_response.text}")
        
        # Test best selling products
        print("\n📈 Testing GET /analytics/executive/best_selling_products...")
        best_products_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/executive/best_selling_products",
            params={"tenant_id": TEST_TENANT_ID},
            headers=headers
        )
        
        if best_products_response.status_code == 200:
            best_products = best_products_response.json()
            print(f"✅ Best selling products retrieved: {len(best_products)} products")
            for product in best_products[:3]:  # Show first 3
                print(f"   - {product['product_name']}: {product['units_sold']} units ({product['percentage']}%)")
        else:
            print(f"❌ Failed to get best selling products: {best_products_response.status_code}")
            print(f"Response: {best_products_response.text}")
        
        # Test sales report
        print("\n📋 Testing GET /analytics/executive/sales_report...")
        sales_report_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/executive/sales_report",
            params={"tenant_id": TEST_TENANT_ID},
            headers=headers
        )
        
        if sales_report_response.status_code == 200:
            sales_report = sales_report_response.json()
            print(f"✅ Sales report retrieved: {len(sales_report)} months")
            for report in sales_report[:3]:  # Show first 3
                print(f"   - {report['month_year']}: {report['sale_point']} points")
        else:
            print(f"❌ Failed to get sales report: {sales_report_response.status_code}")
            print(f"Response: {sales_report_response.text}")
        
        # Step 4: Test Shop Analytics Endpoints
        print("\n🏪 Step 4: Testing Shop Analytics Endpoints")
        print("-" * 40)
        
        # Test shop purchase analysis
        print("🛒 Testing GET /analytics/shops/purchase_analysis...")
        purchase_analysis_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/shops/purchase_analysis",
            params={"tenant_id": TEST_TENANT_ID, "shop_id": "SHOP001"},
            headers=headers
        )
        
        if purchase_analysis_response.status_code == 200:
            purchase_analysis = purchase_analysis_response.json()
            print(f"✅ Purchase analysis retrieved: {len(purchase_analysis)} months")
            purchased_months = [p for p in purchase_analysis if p['is_purchased']]
            print(f"   - Months with purchases: {len(purchased_months)}")
        else:
            print(f"❌ Failed to get purchase analysis: {purchase_analysis_response.status_code}")
            print(f"Response: {purchase_analysis_response.text}")
        
        # Test shop best selling products
        print("\n🏆 Testing GET /analytics/shops/best_selling_products...")
        shop_products_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/shops/best_selling_products",
            params={"tenant_id": TEST_TENANT_ID, "shop_id": "SHOP001"},
            headers=headers
        )
        
        if shop_products_response.status_code == 200:
            shop_products = shop_products_response.json()
            print(f"✅ Shop best selling products retrieved: {len(shop_products)} products")
            for product in shop_products[:3]:  # Show first 3
                print(f"   - {product['product_name']}: {product['units_sold']} units ({product['percentage']}%)")
        else:
            print(f"❌ Failed to get shop best selling products: {shop_products_response.status_code}")
            print(f"Response: {shop_products_response.text}")
        
        # Test shop sales report
        print("\n📊 Testing GET /analytics/shops/sales_report...")
        shop_sales_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/shops/sales_report",
            params={"tenant_id": TEST_TENANT_ID, "shop_id": "SHOP001"},
            headers=headers
        )
        
        if shop_sales_response.status_code == 200:
            shop_sales = shop_sales_response.json()
            print(f"✅ Shop sales report retrieved: {len(shop_sales)} months")
            for report in shop_sales[:3]:  # Show first 3
                print(f"   - {report['month_year']}: {report['sale_point']} points")
        else:
            print(f"❌ Failed to get shop sales report: {shop_sales_response.status_code}")
            print(f"Response: {shop_sales_response.text}")
        
        # Step 5: Test Security (Unauthorized Access)
        print("\n🔒 Step 5: Testing Security")
        print("-" * 40)
        
        # Test without authentication
        print("🚫 Testing without authentication...")
        unauth_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/executive/top_customers",
            params={"tenant_id": TEST_TENANT_ID}
        )
        
        if unauth_response.status_code == 401:
            print("✅ Unauthorized access properly blocked")
        else:
            print(f"❌ Security issue: Unauthorized access allowed: {unauth_response.status_code}")
        
        # Test with wrong tenant
        print("\n🚫 Testing with wrong tenant...")
        wrong_tenant_response = await client.get(
            f"{BASE_URL}/api/v1/analytics/executive/top_customers",
            params={"tenant_id": "WRONG_TENANT"},
            headers=headers
        )
        
        if wrong_tenant_response.status_code == 403:
            print("✅ Wrong tenant access properly blocked")
        else:
            print(f"❌ Security issue: Wrong tenant access allowed: {wrong_tenant_response.status_code}")
        
        print("\n🎉 Analytics Endpoints Test Completed!")
        print("=" * 50)

if __name__ == "__main__":
    asyncio.run(test_analytics_endpoints())
