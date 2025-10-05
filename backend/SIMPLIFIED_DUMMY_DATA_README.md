# Simplified Dummy Data for Sales Manager Analytics System

This directory contains simplified dummy data for testing the Sales Manager analytics system with exactly the structure you requested.

## 📊 Data Structure (As Requested)

### **3 Clients (Tenants):**
- **AquaStar Beverages** (AQUASTAR)
- **FreshFood Distributors** (FRESHFOOD) 
- **Metro Retail Solutions** (METRO)

### **10 Users per Client:**
- **1 Client Admin** (tenant administrator)
- **3 Area Managers** (territory managers)
- **6 Sales Executives** (field sales staff)

### **12 Shops per Client:**
- **4 shops per territory** (3 territories per client)
- **2 shops per sales executive** (6 sales executives per client)

## 🗂️ File Structure

### **Core Data Files:**
1. **`simplified_dummy_data.sql`** - Users, tenants, territories
2. **`simplified_shops_data.sql`** - 36 shops total (12 per client)
3. **`simplified_assignments.sql`** - Sales executive assignments
4. **`simplified_synced_data.sql`** - Orders, products, and due data

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

## 🧪 Testing Scenarios

### **User Hierarchy Testing:**

#### **Sales Executive Level (Individual Performance):**
- **AquaStar**: Alex Thompson (+1111111121) - 2 shops in AQ-NORTH
- **FreshFood**: Kevin Murphy (+2222222231) - 2 shops in FF-METRO  
- **Metro**: Ryan Miller (+3333333341) - 2 shops in MR-DOWNTOWN

#### **Area Manager Level (Territory Performance):**
- **AquaStar**: Sarah Johnson (+1111111112) - AQ-NORTH territory
- **FreshFood**: Rachel Green (+2222222222) - FF-METRO territory
- **Metro**: Laura Davis (+3333333332) - MR-DOWNTOWN territory

#### **Client Admin Level (Tenant Performance):**
- **AquaStar**: John Smith (+1111111111)
- **FreshFood**: Tom Anderson (+2222222221)
- **Metro**: Mark Johnson (+3333333331)

#### **Super Admin Level (Platform Performance):**
- **Platform**: System Administrator (+1234567890)

## 📈 Data Distribution

### **AquaStar (AQUASTAR):**
```
Territories: AQ-NORTH, AQ-SOUTH, AQ-EAST
Sales Executives: Alex Thompson, Maria Garcia, James Anderson, Jennifer Taylor, Robert Martinez, Linda Rodriguez
Shops: 12 total (4 per territory, 2 per executive)
```

### **FreshFood (FRESHFOOD):**
```
Territories: FF-METRO, FF-SUBURB, FF-RURAL
Sales Executives: Kevin Murphy, Nicole Adams, Brian Wilson, Stephanie Hall, Daniel Young, Jessica King
Shops: 12 total (4 per territory, 2 per executive)
```

### **Metro (METRO):**
```
Territories: MR-DOWNTOWN, MR-UPTOWN, MR-MIDTOWN
Sales Executives: Ryan Miller, Amanda Garcia, Jason Rodriguez, Melissa Lee, Andrew White, Samantha Harris
Shops: 12 total (4 per territory, 2 per executive)
```

## 🔍 Verification Commands

After seeding, verify data with these SQL queries:

```sql
-- Check tenant distribution
SELECT tenant_id, COUNT(*) as user_count FROM users GROUP BY tenant_id;

-- Check territory distribution
SELECT territory_id, COUNT(*) as shop_count FROM shops GROUP BY territory_id;

-- Check sales executive assignments (should be 2 shops each)
SELECT sales_executive_id, COUNT(*) as assigned_shops 
FROM sales_executive_assignments 
GROUP BY sales_executive_id;

-- Check synced data
SELECT COUNT(*) as order_count FROM synced_orders;
SELECT COUNT(*) as product_count FROM synced_products;
SELECT COUNT(*) as due_count FROM due_data;
```

## 🎯 Analytics Testing Checklist

- [ ] **Sales Executive Analytics** - Individual performance (2 shops each)
- [ ] **Area Manager Analytics** - Territory-wide performance (4 shops each)
- [ ] **Client Admin Analytics** - Tenant-wide performance (12 shops each)
- [ ] **Super Admin Analytics** - Platform-wide performance (36 shops total)
- [ ] **Permission Testing** - Users can only see authorized data
- [ ] **Data Relationships** - Proper executive-shop assignments

## 📝 Summary

**Total Data Created:**
- ✅ 3 tenants (clients)
- ✅ 30 users (10 per client)
- ✅ 9 territories (3 per client)
- ✅ 36 shops (12 per client)
- ✅ 36 assignments (2 shops per sales executive)
- ✅ 21 orders with realistic sales data
- ✅ 50+ products with proper categorization
- ✅ 20+ due records for outstanding payments

The analytics system is now ready for comprehensive testing with your exact specifications! 🚀
