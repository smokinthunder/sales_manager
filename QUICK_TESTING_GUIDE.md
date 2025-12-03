# Quick Testing Guide - Orders & Assignments

## 🚀 Quick Start

### 1. Reset and Start Fresh

```bash
# Stop everything and remove volumes
docker-compose down -v

# Start all services (auto-seeds data)
docker-compose up -d

# Watch seeding logs
docker-compose logs -f db-seeder
```

### 2. Verify Database

```bash
# Connect to MySQL
docker exec -it sales_manager_mysql mysql -u sales_user -psales_password sales_manager

# Run verification queries
SELECT COUNT(*) as orders FROM orders;
SELECT COUNT(*) as order_items FROM order_items;
SELECT COUNT(*) as shop_assignments FROM shop_assignments;

# Check a sample order with items
SELECT 
    o.order_id, 
    o.bill_number,
    o.total_amount,
    COUNT(oi.id) as item_count
FROM orders o
LEFT JOIN order_items oi ON o.id = oi.order_id
WHERE o.order_id = 'ORD2024001'
GROUP BY o.id;

# Exit MySQL
exit;
```

### 3. Test Backend APIs

First, get an authentication token:

```bash
# Login (use appropriate credentials)
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone": "+1111111111", "password": "password123"}'

# Copy the token from response
```

Then test the new endpoints:

```bash
# Set your token
TOKEN="your_token_here"

# Test Orders List
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/"

# Test Orders with filters
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?status=completed&page=1&page_size=5"

# Test Order Detail (use actual order ID from previous response)
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/1"

# Test Shop Assignments List
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/shop-assignments/"

# Test Visits with order tracking
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/visits/"

# Test Shop Visit Status
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/visits/shops/AQ-N-001/visit-status"
```

---

## 📊 Sample Data Reference

### Test Users (AQUASTAR)

| Name | Phone | Role | ID |
|------|-------|------|-----|
| John Smith | +1111111111 | client_admin | 1 |
| Alex Thompson | +1111111121 | sales_executive | 5 |
| Maria Garcia | +1111111122 | sales_executive | 6 |
| James Anderson | +1111111123 | sales_executive | 7 |
| Jennifer Taylor | +1111111124 | sales_executive | 8 |

### Sample Orders

| Order ID | Bill Number | Shop | Executive | Amount | Status |
|----------|-------------|------|-----------|--------|--------|
| ORD2024001 | BILL-2024-0001 | AQ-N-001 | Alex (5) | $5,850 | completed |
| ORD2024002 | BILL-2024-0002 | AQ-N-002 | Alex (5) | $8,920 | completed |
| ORD2024003 | BILL-2024-0003 | AQ-N-001 | Alex (5) | $3,240 | pending |
| ORD2024004 | BILL-2024-0004 | AQ-N-003 | Maria (6) | $12,450 | completed |
| ORD2024005 | BILL-2024-0005 | AQ-N-004 | Maria (6) | $4,560 | confirmed |

### Sample Shops (AQUASTAR)

| Shop ID | Name | Territory | Assigned To |
|---------|------|-----------|-------------|
| AQ-N-001 | Downtown Convenience Store | AQ-NORTH | Alex Thompson (5) |
| AQ-N-002 | Central Market | AQ-NORTH | Alex Thompson (5) |
| AQ-N-003 | Metro Supermarket | AQ-NORTH | Maria Garcia (6) |
| AQ-N-004 | City Corner Store | AQ-NORTH | Maria Garcia (6) |
| AQ-S-001 | Southside Market | AQ-SOUTH | James Anderson (7) |
| AQ-S-002 | Coastal Store | AQ-SOUTH | James Anderson (7) |

---

## 🧪 Testing Scenarios

### Scenario 1: List Orders with Pagination

```bash
# Page 1 (first 10 orders)
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?page=1&page_size=10"

# Page 2
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?page=2&page_size=10"
```

### Scenario 2: Filter by Status

```bash
# Only completed orders
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?status=completed"

# Only pending orders
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?status=pending"

# Processing orders
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?status=processing"
```

### Scenario 3: Filter by Executive

```bash
# Alex Thompson's orders (executive_id: 5)
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?executive_id=5"

# Maria Garcia's orders (executive_id: 6)
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?executive_id=6"
```

### Scenario 4: Search Orders

```bash
# Search by bill number
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?search=BILL-2024-0001"

# Search by shop name
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?search=Downtown"
```

### Scenario 5: Date Range Filter

```bash
# Orders in November 2024
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?from_date=2024-11-01&to_date=2024-11-30"

# Orders this week
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/?from_date=2024-11-25&to_date=2024-12-03"
```

### Scenario 6: Shop Assignments by Territory

```bash
# North territory assignments
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/shop-assignments/?territory_id=AQ-NORTH"

# South territory assignments
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/shop-assignments/?territory_id=AQ-SOUTH"
```

### Scenario 7: Get Order with All Items

```bash
# Get order detail (includes all order items)
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/orders/1"

# Response includes:
# - Order details
# - All order items with product info
# - Pricing, discounts, taxes
```

### Scenario 8: Check Shop Visit Status

```bash
# Get visit statistics for a shop
curl -H "Authorization: Bearer $TOKEN" \
     -H "X-Tenant-ID: AQUASTAR" \
     "http://localhost:8000/api/v1/visits/shops/AQ-N-001/visit-status"

# Response includes:
# - Last visit date
# - Days since last visit
# - Visit count this month
# - Last order date
# - Orders this month
```

---

## 🐛 Troubleshooting

### Issue: "Table doesn't exist"

```bash
# Check if tables were created
docker exec -it sales_manager_mysql mysql -u sales_user -psales_password sales_manager -e "SHOW TABLES;"

# If missing, restart with fresh database
docker-compose down -v
docker-compose up -d
```

### Issue: "No data returned"

```bash
# Check record counts
docker exec -it sales_manager_mysql mysql -u sales_user -psales_password sales_manager -e "
SELECT 
    (SELECT COUNT(*) FROM orders) as orders,
    (SELECT COUNT(*) FROM order_items) as items,
    (SELECT COUNT(*) FROM shop_assignments) as assignments;
"

# If zero, check seeder logs
docker-compose logs db-seeder
```

### Issue: "Authentication failed"

```bash
# Verify user exists
docker exec -it sales_manager_mysql mysql -u sales_user -psales_password sales_manager -e "
SELECT id, name, phone, role FROM users WHERE phone = '+1111111111';
"

# Try login again with correct credentials
```

### Issue: "404 Not Found on new endpoints"

```bash
# Check backend logs
docker-compose logs backend | tail -50

# Verify backend is running
docker-compose ps backend

# Restart backend
docker-compose restart backend
```

---

## 📖 API Documentation

For complete API documentation including:
- All request/response schemas
- Error codes and handling
- Advanced filtering options
- Pagination details

See: **BACKEND_API_IMPLEMENTATION_REPORT.md**

For frontend integration:
See: **FRONTEND_INTEGRATION_GUIDE.md**

For database details:
See: **DATABASE_INTEGRATION_SUMMARY.md**

---

## ✅ Expected Results

### Orders List Response
```json
{
  "items": [
    {
      "order_id": "ORD2024001",
      "bill_number": "BILL-2024-0001",
      "shop_id": "AQ-N-001",
      "shop_name": "Downtown Convenience Store",
      "executive_id": 5,
      "executive_name": "Alex Thompson",
      "order_date": "2024-11-25",
      "total_amount": 5850.00,
      "status": "completed",
      "items_count": 3,
      "payment_status": "paid"
    }
  ],
  "total": 20,
  "page": 1,
  "page_size": 10,
  "pages": 2
}
```

### Order Detail Response
```json
{
  "order_id": "ORD2024001",
  "bill_number": "BILL-2024-0001",
  "shop_id": "AQ-N-001",
  "executive_id": 5,
  "order_date": "2024-11-25",
  "total_amount": 5850.00,
  "status": "completed",
  "items_count": 3,
  "payment_status": "paid",
  "items": [
    {
      "product_code": "PVC-100-10",
      "product_name": "PVC Pipe 100mm x 10ft",
      "quantity": 20.00,
      "unit": "pcs",
      "unit_price": 150.00,
      "total_price": 3000.00,
      "discount": 0.00,
      "tax_amount": 360.00
    }
  ]
}
```

### Shop Assignments Response
```json
{
  "items": [
    {
      "shop_id": "AQ-N-001",
      "shop_name": "Downtown Convenience Store",
      "executive_id": 5,
      "executive_name": "Alex Thompson",
      "territory_id": "AQ-NORTH",
      "territory_name": "North Region",
      "assigned_date": "2024-01-01",
      "status": "active"
    }
  ],
  "total": 36,
  "page": 1,
  "page_size": 10,
  "pages": 4
}
```

---

**Happy Testing!** 🎉
