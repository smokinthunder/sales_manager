# Comprehensive Dummy Data for Sales Manager Analytics System

This directory contains comprehensive dummy data for testing the Sales Manager analytics system with realistic, large-scale data that covers all user hierarchies and analytics scenarios.

## 📊 Data Overview

### **Scale of Data:**
- **5 Tenants** (clients): AquaStar, FreshFood, Metro, Coastal, Urban
- **15 Territories** across all tenants
- **32 Users** (5 client admins, 10 area managers, 17 sales executives)
- **300+ Shops** distributed across all territories
- **300+ Sales Executive Assignments** linking executives to shops
- **24 Orders** with realistic sales data
- **100+ Products** with proper categorization
- **25+ Due Data Records** for outstanding payments

### **User Hierarchy Testing:**
- **SUPERADMIN**: Platform owner (+1234567890)
- **CLIENT_ADMIN**: Tenant administrators (5 users)
- **AREA_MANAGER**: Territory managers (10 users)
- **SALES_EXECUTIVE**: Field sales staff (17 users)

## 🗂️ File Structure

### **Core Data Files:**
1. **`comprehensive_dummy_data.sql`** - Users, tenants, territories, and basic assignments
2. **`shops_dummy_data.sql`** - Initial shops and sales executive assignments
3. **`additional_shops_dummy.sql`** - Additional shops for all territories
4. **`additional_assignments_dummy.sql`** - Assignments for additional shops
5. **`synced_data_dummy.sql`** - Orders, products, and due data for analytics

### **Deployment Files:**
- **`seed_database.sh`** - Automated seeding script
- **`docker-compose-with-seeding.yml`** - Docker Compose with automatic seeding

## 🚀 Quick Start

### **Option 1: Docker Compose (Recommended)**
```bash
# Start the entire system with automatic seeding
docker-compose -f docker-compose-with-seeding.yml up -d

# Check seeding progress
docker logs sales_manager_seeder
```

### **Option 2: Manual Seeding**
```bash
# Make script executable
chmod +x seed_database.sh

# Run seeding script
./seed_database.sh
```

### **Option 3: Individual SQL Files**
```bash
# Run each file individually
mysql -u root -p sales_manager < comprehensive_dummy_data.sql
mysql -u root -p sales_manager < shops_dummy_data.sql
mysql -u root -p sales_manager < additional_shops_dummy.sql
mysql -u root -p sales_manager < additional_assignments_dummy.sql
mysql -u root -p sales_manager < synced_data_dummy.sql
```

## 🧪 Testing Scenarios

### **Analytics Endpoints Testing:**

#### **Sales Executive Level (Individual Performance):**
- **User**: Alex Thompson (+1111111121)
- **Territory**: AQ-NORTH
- **Shops**: 25 assigned shops
- **Test Endpoints**:
  - `/api/analytics/executive/7/top-customers`
  - `/api/analytics/executive/7/best-selling-products`
  - `/api/analytics/executive/7/sales-report`

#### **Area Manager Level (Territory Performance):**
- **User**: Sarah Johnson (+1111111112)
- **Territory**: AQ-NORTH
- **Sales Executives**: Alex Thompson, Maria Garcia
- **Test Endpoints**:
  - View individual executive performance
  - Territory-wide analytics

#### **Client Admin Level (Tenant Performance):**
- **User**: John Smith (+1111111111)
- **Tenant**: AQUASTAR
- **Test Endpoints**:
  - All analytics endpoints for any user in tenant
  - Cross-territory analytics

#### **Super Admin Level (Platform Performance):**
- **User**: System Administrator (+1234567890)
- **Test Endpoints**:
  - All analytics endpoints across all tenants
  - Platform-wide analytics

### **Shop-Level Analytics Testing:**
- **Shop**: Downtown Convenience Store (AQ-N-001)
- **Assigned Executive**: Alex Thompson
- **Test Endpoints**:
  - `/api/analytics/shops/AQ-N-001/purchase-analysis`
  - `/api/analytics/shops/AQ-N-001/best-selling-products`
  - `/api/analytics/shops/AQ-N-001/sales-report`

## 📈 Data Relationships

### **Tenant → Territory → Sales Executive → Shop Chain:**
```
AQUASTAR
├── AQ-NORTH (Sarah Johnson - Area Manager)
│   ├── Alex Thompson (Sales Executive) → 25 shops
│   └── Maria Garcia (Sales Executive) → 25 shops
├── AQ-SOUTH (Mike Wilson - Area Manager)
│   ├── James Anderson (Sales Executive) → 25 shops
│   └── Jennifer Taylor (Sales Executive) → 25 shops
└── ... (other territories)
```

### **Sales Data Flow:**
```
Client API → Synced Orders → Synced Products → Analytics
     ↓
Sales Executive Assignment → Performance Tracking
```

## 🔍 Verification Commands

After seeding, verify data with these SQL queries:

```sql
-- Check tenant distribution
SELECT tenant_id, COUNT(*) as user_count FROM users GROUP BY tenant_id;

-- Check territory distribution
SELECT territory_id, COUNT(*) as shop_count FROM shops GROUP BY territory_id;

-- Check sales executive assignments
SELECT sales_executive_id, COUNT(*) as assigned_shops 
FROM sales_executive_assignments 
GROUP BY sales_executive_id;

-- Check synced data
SELECT COUNT(*) as order_count FROM synced_orders;
SELECT COUNT(*) as product_count FROM synced_products;
SELECT COUNT(*) as due_count FROM due_data;
```

## 🎯 Analytics Testing Checklist

- [ ] **Sales Executive Analytics** - Individual performance data
- [ ] **Area Manager Analytics** - Territory-wide performance
- [ ] **Client Admin Analytics** - Tenant-wide performance
- [ ] **Super Admin Analytics** - Platform-wide performance
- [ ] **Shop Analytics** - Individual shop performance
- [ ] **Permission Testing** - Users can only see authorized data
- [ ] **Data Relationships** - Proper executive-shop assignments
- [ ] **Real-time Analytics** - Using actual synced data

## 🚨 Troubleshooting

### **Common Issues:**

1. **Foreign Key Constraints**: Ensure data is inserted in correct order
2. **Duplicate Keys**: Check for existing data before inserting
3. **Permission Errors**: Verify database user permissions
4. **Connection Issues**: Check database connectivity

### **Reset Database:**
```bash
# Drop and recreate database
mysql -u root -p -e "DROP DATABASE IF EXISTS sales_manager; CREATE DATABASE sales_manager;"

# Re-run seeding
./seed_database.sh
```

## 📝 Notes

- **Realistic Data**: All data follows realistic business patterns
- **Proper Relationships**: All foreign keys and relationships are maintained
- **Scalable Design**: Easy to add more data by extending the SQL files
- **Analytics Ready**: Data is structured for comprehensive analytics testing
- **Security Testing**: Includes proper user hierarchy for permission testing

## 🎉 Success Indicators

After successful seeding, you should see:
- ✅ 5 tenants created
- ✅ 32 users created
- ✅ 15 territories created
- ✅ 300+ shops created
- ✅ 300+ assignments created
- ✅ 24 orders created
- ✅ 100+ products created
- ✅ 25+ due records created

The analytics system is now ready for comprehensive testing! 🚀

