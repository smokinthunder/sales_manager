# Missing Backend APIs Report

## Overview
This document identifies UI elements and features in the admin dashboard that currently display hardcoded data or "N/A" values because the corresponding backend API endpoints are not yet available.

## Priority Classification

### 🔴 HIGH PRIORITY - Critical Features Blocked

#### 1. Orders Management System
**Affected Screen:** `lib/ui/orders/orders.dart`

**Current State:**
- Total orders count: Hardcoded "100"
- New orders count: Hardcoded "15"  
- Order list: `Iterable.generate(10000)` with dummy data
- ShopAnalyticsCard shows: "National Pipes", Bill "0019", "Rahul Dev", ₹2456

**Required Backend API:**
```
GET /api/v1/orders/
Query Parameters:
  - status: string (optional) - 'pending', 'completed', 'cancelled'
  - search: string (optional) - search by bill number or shop name
  - executive_id: int (optional) - filter by sales executive
  - shop_id: int (optional) - filter by shop
  - from_date: date (optional) - filter by date range
  - to_date: date (optional) - filter by date range
  - page: int (default: 1)
  - page_size: int (default: 20)

Response:
{
  "items": [
    {
      "id": 1,
      "order_id": "ORD001",
      "bill_number": "0019",
      "shop_id": 5,
      "shop_name": "National Pipes",
      "shop_location": "Ernakulam",
      "executive_id": 3,
      "executive_name": "Rahul Dev",
      "executive_phone": "+91 9876543210",
      "total_amount": 2456.00,
      "status": "completed",
      "order_date": "2024-01-15T10:30:00",
      "items_count": 5,
      "tenant_id": "AQUASTAR",
      "created_at": "2024-01-15T10:30:00",
      "updated_at": "2024-01-15T12:45:00"
    }
  ],
  "total": 100,
  "page": 1,
  "page_size": 20,
  "pages": 5
}
```

**Required Additional Endpoint:**
```
GET /api/v1/orders/{order_id}
Response: Single order object with detailed line items
```

**Impact:**
- ❌ Cannot display real order data
- ❌ Cannot search orders
- ❌ Cannot view order details
- ❌ Orders screen completely non-functional

**Required UI Updates After API is Available:**
1. Convert Orders from StatelessWidget to ConsumerStatefulWidget
2. Add `ordersProvider` to data_viewmodel.dart
3. Replace hardcoded counts with `allOrdersCountProvider` and `newOrdersCountProvider`
4. Replace `Iterable.generate(10000)` with real order data
5. Map Order domain model to ShopAnalyticsCard
6. Implement search functionality
7. Add loading/error states

---

#### 2. Shop-Executive Relationship
**Affected Screen:** `lib/ui/executive/find_dealers.dart`

**Current State (ShopStateCard):**
- `executiveName`: "N/A" (hardcoded)
- `executivePhoneNo`: "N/A" (hardcoded)

**Required Backend API Option 1 - Expand Shop Response:**
```
GET /api/v1/shops/?expand=executive
Response:
{
  "items": [
    {
      "id": 1,
      "shop_id": "SH001",
      "name": "Kerala Pipe House",
      // ... other shop fields ...
      "assigned_executive_id": 3,
      "assigned_executive": {
        "id": 3,
        "name": "Abhin K Leji",
        "phone": "+91 8345349537",
        "email": "abhin@example.com"
      }
    }
  ]
}
```

**Required Backend API Option 2 - Separate Assignment Endpoint:**
```
GET /api/v1/shop-assignments/
Query Parameters:
  - shop_id: int (optional)
  - executive_id: int (optional)
  - status: string (optional) - 'active', 'inactive'

Response:
{
  "items": [
    {
      "id": 1,
      "shop_id": 1,
      "shop_name": "Kerala Pipe House",
      "executive_id": 3,
      "executive_name": "Abhin K Leji",
      "executive_phone": "+91 8345349537",
      "assigned_date": "2024-01-01",
      "status": "active",
      "territory_id": 5
    }
  ]
}
```

**Impact:**
- ⚠️ Cannot show which executive is assigned to each shop
- ⚠️ Find Dealers screen shows "N/A" for executive information
- ⚠️ Cannot track shop-executive relationships

**Required Domain Model:**
```dart
class ShopAssignment {
  final int id;
  final int shopId;
  final String shopName;
  final int executiveId;
  final String executiveName;
  final String executivePhone;
  final DateTime assignedDate;
  final String status;
  final int? territoryId;
}
```

---

#### 3. Visit Tracking System
**Affected Screen:** `lib/ui/executive/find_dealers.dart`

**Current State (ShopStateCard):**
- `shopVisited`: false (hardcoded)
- `orderReceived`: false (hardcoded)

**Required Backend API:**
```
GET /api/v1/visits/
Query Parameters:
  - executive_id: int (optional)
  - shop_id: int (optional)
  - date: date (optional) - default: today
  - from_date: date (optional)
  - to_date: date (optional)
  - status: string (optional) - 'visited', 'missed', 'planned'

Response:
{
  "items": [
    {
      "id": 1,
      "shop_id": 1,
      "shop_name": "Kerala Pipe House",
      "executive_id": 3,
      "executive_name": "Abhin K Leji",
      "visit_date": "2024-01-15",
      "visit_time": "10:30:00",
      "status": "visited",
      "check_in_time": "10:30:00",
      "check_out_time": "11:15:00",
      "location_lat": 10.1234,
      "location_lng": 76.5678,
      "notes": "Customer interested in new product line",
      "order_placed": true,
      "order_id": 5,
      "photos": ["url1", "url2"],
      "created_at": "2024-01-15T10:30:00"
    }
  ]
}
```

**Required Additional Endpoint:**
```
GET /api/v1/shops/{shop_id}/visit-status
Response:
{
  "shop_id": 1,
  "last_visit_date": "2024-01-15",
  "days_since_visit": 2,
  "visit_count_this_month": 4,
  "last_order_date": "2024-01-15",
  "orders_this_month": 3
}
```

**Impact:**
- ⚠️ Cannot track shop visits
- ⚠️ Cannot show visit history
- ⚠️ Cannot verify if executive visited shop
- ⚠️ Cannot correlate visits with orders

**Required Domain Models:**
```dart
class Visit {
  final int id;
  final int shopId;
  final String shopName;
  final int executiveId;
  final String executiveName;
  final DateTime visitDate;
  final String status;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double? locationLat;
  final double? locationLng;
  final String? notes;
  final bool orderPlaced;
  final int? orderId;
  final List<String> photos;
}

class ShopVisitStatus {
  final int shopId;
  final DateTime? lastVisitDate;
  final int daysSinceVisit;
  final int visitCountThisMonth;
  final DateTime? lastOrderDate;
  final int ordersThisMonth;
}
```

---

### 🟡 MEDIUM PRIORITY - Display Enhancement

#### 4. Territory/Location Details
**Affected Screens:** 
- `lib/ui/executive/executive.dart` (ExecutiveCard)

**Current State:**
- Location field: "N/A" (hardcoded)
- Shows: "Kochi, Edappaly +91 984624352" in hardcoded example

**Required Backend API Option 1 - Expand User Response:**
```
GET /api/v1/users/?expand=territory
Response:
{
  "items": [
    {
      "id": 3,
      "name": "Rahul Dev",
      "phone": "+91 9876543210",
      "territory_id": 5,
      "territory": {
        "id": 5,
        "name": "Ernakulam",
        "district": "Ernakulam",
        "state": "Kerala",
        "pin_codes": ["682024", "682025"],
        "area_manager_id": 2
      }
    }
  ]
}
```

**Required Backend API Option 2 - Separate Territory Endpoint:**
```
GET /api/v1/territories/{territory_id}
Response:
{
  "id": 5,
  "name": "Ernakulam",
  "district": "Ernakulam",
  "state": "Kerala",
  "region": "South",
  "pin_codes": ["682024", "682025", "682026"],
  "area_manager_id": 2,
  "area_manager_name": "Arun Kumar",
  "sales_executives_count": 12,
  "shops_count": 45,
  "status": "active"
}
```

**Impact:**
- ⚠️ Cannot show executive's territory/location
- ⚠️ Cannot group executives by territory
- ⚠️ Cannot show territorial hierarchy

**Required Domain Model:**
```dart
class Territory {
  final int id;
  final String name;
  final String district;
  final String state;
  final String? region;
  final List<String> pinCodes;
  final int? areaManagerId;
  final String? areaManagerName;
  final int salesExecutivesCount;
  final int shopsCount;
  final String status;
}
```

---

#### 5. Manager-Executive Relationship
**Affected Screen:** `lib/ui/executive/executive.dart` (ExecutiveCard)

**Current State:**
- Manager name (crown icon): "N/A" (hardcoded)
- Shows: "Rajev" in hardcoded example

**Required Backend API - Expand User Response:**
```
GET /api/v1/users/?expand=manager
Response:
{
  "items": [
    {
      "id": 3,
      "name": "Rahul Dev",
      "role": "sales_executive",
      "reporting_manager_id": 2,
      "reporting_manager": {
        "id": 2,
        "name": "Rajev Kumar",
        "phone": "+91 9876543210",
        "role": "area_manager"
      }
    }
  ]
}
```

**Alternative - Database Schema Update:**
Add `reporting_manager_id` field to users table and include in default response

**Impact:**
- ⚠️ Cannot show reporting hierarchy
- ⚠️ Cannot identify who executive reports to
- ⚠️ Cannot navigate organizational structure

---

#### 6. Dashboard Statistics Enhancement
**Affected Screen:** `lib/ui/executive/executive.dart`

**Current State:**
- New Executives count: Hardcoded "0"
- Backend DashboardStats has `newAreaManagers` but not `newExecutives`

**Required Backend API Update:**
```
GET /api/v1/analytics/dashboard
Current Response:
{
  "total_executives": 100,
  "total_customers": 15489,
  "new_customers": 20,
  "total_area_managers": 15,
  "new_area_managers": 5,
  "today_sales": 125000.50,
  "today_collection": 98000.00,
  "today_new_customers": 3
}

Required Addition:
{
  // ... existing fields ...
  "new_executives": 5,  // <-- ADD THIS
  "new_executives_this_week": 12,  // <-- OPTIONAL
  "new_executives_this_month": 25  // <-- OPTIONAL
}
```

**Impact:**
- ⚠️ Cannot track new executive hires
- ⚠️ Cannot show growth metrics for sales team
- ⚠️ Dashboard incomplete

**Required Update:**
Update `lib/domain/models/analytics/dashboard_stats.dart`:
```dart
class DashboardStats {
  // ... existing fields ...
  final int newExecutives;
  final int? newExecutivesThisWeek;
  final int? newExecutivesThisMonth;
}
```

---

### 🟢 LOW PRIORITY - Nice to Have

#### 7. Server-Side Search
**Affected Screens:** All list screens with search

**Current State:**
- Client-side filtering: Load all data, then filter in UI
- Works for small datasets (< 10,000 records)
- Performance degrades with large datasets

**Required Backend API Enhancement:**
Add `search` query parameter to existing endpoints:

```
GET /api/v1/users/?search=rahul
GET /api/v1/shops/?search=kerala
GET /api/v1/orders/?search=0019

Implementation:
- Search across multiple fields (name, phone, email for users)
- Case-insensitive LIKE query
- Return paginated results
- Better performance for large datasets
```

**Impact:**
- ℹ️ Faster search for large datasets
- ℹ️ Reduced data transfer
- ℹ️ Better mobile experience

---

#### 8. Chart Data for Dashboard
**Affected Screen:** `lib/ui/dashboard/dashboard.dart`

**Current State:**
- SalesReportDataMap: Using dummy data
- BarChartDataMap: Using dummy data
- Charts display but with hardcoded values

**Required Backend APIs:**

**Sales Trend Chart:**
```
GET /api/v1/analytics/sales-trend
Query Parameters:
  - period: string - 'day', 'week', 'month', 'year'
  - from_date: date (optional)
  - to_date: date (optional)

Response:
{
  "period": "week",
  "data_points": [
    {
      "date": "2024-01-15",
      "sales": 125000.50,
      "orders_count": 45,
      "new_customers": 3
    }
  ]
}
```

**Category-wise Sales:**
```
GET /api/v1/analytics/category-sales
Response:
{
  "categories": [
    {
      "category_name": "Pipes",
      "sales_amount": 450000.00,
      "percentage": 35
    }
  ]
}
```

**Impact:**
- ℹ️ Charts show dummy data
- ℹ️ Cannot analyze sales trends
- ℹ️ Cannot make data-driven decisions

---

#### 9. Notifications for Data Updates
**Affected:** All screens with real-time data

**Current State:**
- Data loaded on screen open
- No automatic updates
- Manual refresh required

**Required Backend API:**
WebSocket or Server-Sent Events endpoint for real-time updates:

```
WS /api/v1/notifications/data-updates
Messages:
{
  "event": "order_created",
  "data": {
    "order_id": 123,
    "shop_id": 5,
    "executive_id": 3,
    "amount": 2456.00
  }
}

{
  "event": "shop_visited",
  "data": {
    "shop_id": 5,
    "executive_id": 3,
    "visit_time": "2024-01-15T10:30:00"
  }
}
```

**Impact:**
- ℹ️ Real-time dashboard updates
- ℹ️ Better user experience
- ℹ️ Instant visibility of business events

---

## Summary Table

| Priority | Feature | Affected Screen | Status | Backend API Needed |
|----------|---------|----------------|--------|-------------------|
| 🔴 HIGH | Orders Management | orders.dart | ❌ Blocked | GET /api/v1/orders/ |
| 🔴 HIGH | Shop-Executive Link | find_dealers.dart | ⚠️ Shows N/A | GET /api/v1/shop-assignments/ |
| 🔴 HIGH | Visit Tracking | find_dealers.dart | ⚠️ Shows false | GET /api/v1/visits/ |
| 🟡 MEDIUM | Territory Details | executive.dart | ⚠️ Shows N/A | GET /api/v1/territories/{id} |
| 🟡 MEDIUM | Manager Relationship | executive.dart | ⚠️ Shows N/A | Expand user response |
| 🟡 MEDIUM | New Executives Count | executive.dart | ⚠️ Shows 0 | Update dashboard stats API |
| 🟢 LOW | Server-Side Search | All list screens | ✅ Works | Add search parameter |
| 🟢 LOW | Chart Data | dashboard.dart | ⚠️ Dummy data | GET /api/v1/analytics/* |
| 🟢 LOW | Real-time Updates | All screens | ✅ Works | WebSocket endpoint |

## Implementation Timeline Recommendation

### Phase 1: Critical Features (Week 1-2)
1. Implement Orders API
2. Update orders.dart screen
3. Implement Shop-Executive Assignment API
4. Update find_dealers.dart with real executive data

### Phase 2: Visit Tracking (Week 3)
1. Implement Visits API
2. Update find_dealers.dart with visit status
3. Add visit history feature

### Phase 3: Enhancements (Week 4)
1. Add Territory API
2. Update user responses with manager relationship
3. Update dashboard stats with new executives count
4. Update relevant UI screens

### Phase 4: Optimization (Week 5)
1. Add server-side search to all endpoints
2. Implement chart data APIs
3. Add real-time update notifications

## Testing Requirements After API Implementation

### For Each New API:
1. **Unit Tests:**
   - Request/response serialization
   - Error handling
   - Validation logic

2. **Integration Tests:**
   - End-to-end API flow
   - Authentication
   - Pagination
   - Filtering

3. **UI Tests:**
   - Data display
   - Loading states
   - Error states
   - Search functionality

### Performance Tests:
- Load testing with 10,000+ records
- Search performance
- Pagination performance
- Concurrent user testing

## Notes for Backend Developers

### Common Patterns to Follow:

1. **Response Format:**
```json
{
  "items": [...],
  "total": 100,
  "page": 1,
  "page_size": 20,
  "pages": 5
}
```

2. **Error Response:**
```json
{
  "detail": "Error message",
  "error_code": "ERROR_CODE",
  "status_code": 400
}
```

3. **Date/Time Format:**
- Use ISO 8601: "2024-01-15T10:30:00Z"
- Include timezone information

4. **Filtering:**
- Support multiple filter parameters
- Support null/empty values
- Support range queries for dates/amounts

5. **Sorting:**
- Add `sort_by` and `order` parameters
- Default to `created_at DESC`

6. **Authentication:**
- All endpoints require Bearer token
- Include tenant_id in headers: `X-Tenant-ID: AQUASTAR`

7. **Pagination:**
- Default page_size: 20
- Maximum page_size: 100
- Include pagination metadata in response

---

**Document Version:** 1.0  
**Date:** 2024  
**Status:** 🔴 5 High Priority APIs Missing  
**Last Updated:** After completing 5/6 screens data integration
