# Database Seeding for Sales Manager

This directory contains scripts to seed your Sales Manager database with simplified dummy data for testing analytics.

## 🚀 Quick Start

### **Option 1: Use the Simple Seeding Scripts (Recommended)**

#### **Linux/Mac:**
```bash
# Make script executable
chmod +x seed.sh

# Run seeding
./seed.sh
```

#### **Windows:**
```cmd
# Run seeding
seed.bat
```

### **Option 2: Use Docker Compose Profile**

```bash
# Start MySQL first (if not running)
docker-compose up -d mysql

# Run seeding with profile
docker-compose --profile seed up db-seeder
```

### **Option 3: Manual Seeding**

```bash
# Make script executable
chmod +x seed_database.sh

# Run seeding script directly
./seed_database.sh
```

## 📊 What Gets Seeded

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

### **Analytics Data:**
- **21 Orders** with realistic sales data
- **50+ Products** with proper categorization
- **20+ Due Records** for outstanding payments

## 🧪 Test Users Available

After seeding, you can test with these users:

- **SUPERADMIN**: +1234567890 (Platform Owner)
- **AquaStar Admin**: +1111111111 (John Smith)
- **AquaStar Area Manager**: +1111111112 (Sarah Johnson)
- **AquaStar Sales Executive**: +1111111121 (Alex Thompson)
- **FreshFood Admin**: +2222222221 (Tom Anderson)
- **Metro Admin**: +3333333331 (Mark Johnson)

## 🔧 Configuration

The seeding scripts use these default database settings (matching your docker-compose.yml):

- **Host**: localhost
- **Port**: 3307
- **Database**: sales_manager
- **User**: sales_user
- **Password**: sales_password

You can override these by setting environment variables:

```bash
export DB_HOST=localhost
export DB_PORT=3307
export DB_NAME=sales_manager
export DB_USER=sales_user
export DB_PASSWORD=sales_password
```

## 📁 Files Used

The seeding process uses these files:

1. **`backend/init.sql`** - Database schema initialization
2. **`backend/simplified_dummy_data.sql`** - Users, tenants, territories
3. **`backend/simplified_shops_data.sql`** - 36 shops total
4. **`backend/simplified_assignments.sql`** - Sales executive assignments
5. **`backend/simplified_synced_data.sql`** - Orders, products, due data

## 🔍 Verification

After seeding, verify the data:

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

## 🚨 Troubleshooting

### **Common Issues:**

1. **Database Connection Failed**
   - Ensure MySQL container is running: `docker-compose ps`
   - Check database credentials match docker-compose.yml

2. **Permission Denied**
   - Make scripts executable: `chmod +x seed.sh seed_database.sh`

3. **File Not Found**
   - Ensure you're running from the project root directory
   - Check that all SQL files exist in the backend/ directory

### **Reset Database:**
```bash
# Stop containers
docker-compose down

# Remove database volume
docker volume rm sales_manager_mysql_data

# Start fresh and seed
docker-compose up -d mysql
./seed.sh
```

## 🎯 Next Steps

After successful seeding:

1. **Start the full system:**
   ```bash
   docker-compose up -d
   ```

2. **Test analytics endpoints** with the provided test users

3. **Verify user hierarchy** and permissions work correctly

The analytics system is now ready for comprehensive testing! 🚀
