# Analytics Endpoints Implementation

This document describes the implementation of analytics endpoints for the Sales Manager application, based on the specifications in `ANALYTICSENDPOINT.md`.

## Overview

The analytics system provides comprehensive reporting capabilities for both sales executives and shops, with proper security, tenant isolation, and role-based access control.

## Implemented Endpoints

### Executive Analytics

#### 1. GET `/analytics/executive/top_customers`
- **Purpose**: Get top customers (shops) for a sales executive based on payment amounts
- **Input**: 
  - `tenant_id` (required)
  - `sales_executive_id` (optional - only for area_manager, client_admin, superadmin)
- **Output**: List of shops with points (total payment amounts)
- **Security**: Sales executives can only see their own data unless they have higher privileges

#### 2. GET `/analytics/executive/best_selling_products`
- **Purpose**: Get best selling products for a sales executive
- **Input**: 
  - `tenant_id` (required)
  - `sales_executive_id` (optional - only for area_manager, client_admin, superadmin)
- **Output**: List of products with units sold and percentage of total sales
- **Security**: Sales executives can only see their own data unless they have higher privileges

#### 3. GET `/analytics/executive/sales_report`
- **Purpose**: Get sales report for a sales executive for the last year
- **Input**: 
  - `tenant_id` (required)
  - `sales_executive_id` (optional - only for area_manager, client_admin, superadmin)
- **Output**: List of monthly sales data (YYYY-MM format) with sale points
- **Security**: Sales executives can only see their own data unless they have higher privileges

### Shop Analytics

#### 4. GET `/analytics/shops/purchase_analysis`
- **Purpose**: Get purchase analysis for a shop
- **Input**: 
  - `tenant_id` (required)
  - `shop_id` (required)
  - `year` (optional - defaults to last year)
- **Output**: List of monthly purchase data showing whether purchases were made
- **Security**: Users can only access shops from their tenant

#### 5. GET `/analytics/shops/best_selling_products`
- **Purpose**: Get best selling products for a shop
- **Input**: 
  - `tenant_id` (required)
  - `shop_id` (required)
  - `year` (optional - defaults to last year)
- **Output**: List of products with units sold and percentage of total sales
- **Security**: Users can only access shops from their tenant

#### 6. GET `/analytics/shops/sales_report`
- **Purpose**: Get sales report for a shop for the specified year
- **Input**: 
  - `tenant_id` (required)
  - `shop_id` (required)
  - `year` (optional - defaults to last year)
- **Output**: List of monthly sales data (YYYY-MM format) with sale points
- **Security**: Users can only access shops from their tenant

## Security Features

### Authentication
- All endpoints require authentication via Bearer token
- Token obtained through OTP verification process

### Authorization
- **Tenant Isolation**: Users can only access data from their assigned tenant
- **Role-based Access**: 
  - `sales_executive`: Can only see their own data
  - `area_manager`, `client_admin`, `superadmin`: Can specify `sales_executive_id` to view other executives' data
- **Superadmin Override**: Superadmin can access any tenant's data

### Data Validation
- Input validation for all query parameters
- Proper error handling with meaningful messages
- Protection against SQL injection through ORM usage

## Database Schema

The analytics system uses existing tables:

### Core Tables
- `users`: User information and roles
- `shops`: Shop information
- `territories`: Territory management
- `routes`: Route assignments
- `route_assignments`: Shop-executive assignments

### Analytics Tables
- `sales_performance`: Executive performance metrics
- `shop_analytics`: Shop-specific analytics
- `payment_analytics`: Payment analytics

### Sync Data Tables
- `synced_shop_data`: Shop payment data
- `synced_orders`: Order information
- `synced_products`: Product sales data

## Implementation Details

### Service Layer (`AnalyticsService`)
- **Location**: `backend/app/services/analytics_service.py`
- **Methods**:
  - `get_executive_top_customers()`: Calculate top customers by payment amounts
  - `get_executive_best_selling_products()`: Analyze product sales by executive
  - `get_executive_sales_report()`: Generate monthly sales reports
  - `get_shop_purchase_analysis()`: Analyze shop purchase patterns
  - `get_shop_best_selling_products()`: Analyze product sales by shop
  - `get_shop_sales_report()`: Generate shop monthly sales reports

### Domain Models
- **Location**: `backend/app/domain/models/analytics.py`
- **Response Models**:
  - `TopCustomerResponse`: Shop name and points
  - `BestSellingProductResponse`: Product name, units sold, percentage
  - `SalesReportResponse`: Month-year and sale points
  - `PurchaseAnalysisResponse`: Month-year and purchase status
  - `ShopBestSellingProductResponse`: Product sales by shop
  - `ShopSalesReportResponse`: Shop monthly sales

### API Endpoints
- **Location**: `backend/app/api/v1/analytics.py`
- **Features**:
  - Comprehensive documentation
  - Proper error handling
  - Security validation
  - Response model validation

## Testing

### Test Script
- **Location**: `backend/test_analytics_endpoints.py`
- **Features**:
  - End-to-end testing of all endpoints
  - Security testing (unauthorized access, wrong tenant)
  - Sample data validation

### Sample Data
- **Location**: `backend/init.sql`
- **Includes**:
  - Test tenant (`TEST`)
  - Test users (sales_executive, area_manager, client_admin)
  - Test shops and territories
  - Sample synced data (orders, products, payments)
  - Route assignments

## Usage Examples

### Get Top Customers for Sales Executive
```bash
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8000/api/v1/analytics/executive/top_customers?tenant_id=TEST"
```

### Get Best Selling Products for Shop
```bash
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8000/api/v1/analytics/shops/best_selling_products?tenant_id=TEST&shop_id=SHOP001&year=2024"
```

### Get Sales Report for Executive
```bash
curl -H "Authorization: Bearer <token>" \
  "http://localhost:8000/api/v1/analytics/executive/sales_report?tenant_id=TEST"
```

## Error Handling

The system provides comprehensive error handling:

- **401 Unauthorized**: Missing or invalid authentication token
- **403 Forbidden**: Insufficient permissions or wrong tenant access
- **404 Not Found**: Resource not found (shop, executive, etc.)
- **500 Internal Server Error**: Unexpected server errors

## Performance Considerations

- **Database Indexes**: Optimized indexes for analytics queries
- **Query Optimization**: Efficient SQL queries with proper joins
- **Caching**: Analytics data can be cached for better performance
- **Pagination**: Large result sets can be paginated if needed

## Future Enhancements

- **Real-time Analytics**: WebSocket-based real-time updates
- **Advanced Filtering**: Date ranges, product categories, etc.
- **Export Functionality**: CSV/Excel export of analytics data
- **Dashboard Integration**: Real-time dashboard with charts and graphs
- **Predictive Analytics**: Machine learning-based predictions

## Maintenance

- **Data Cleanup**: Regular cleanup of old analytics data
- **Performance Monitoring**: Monitor query performance and optimize as needed
- **Security Audits**: Regular security reviews and updates
- **Documentation Updates**: Keep documentation current with changes
