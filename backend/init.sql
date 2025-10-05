-- Sales Manager Database Initialization Script
-- This script creates the initial database schema for the application

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS sales_manager;
USE sales_manager;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    role ENUM('superadmin', 'client_admin', 'area_manager', 'sales_executive') NOT NULL,
    status ENUM('active', 'inactive', 'suspended', 'pending_approval') DEFAULT 'active',
    territory_id VARCHAR(20),
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_phone (tenant_id, phone),
    INDEX idx_role_status (role, status),
    INDEX idx_territory (territory_id),
    UNIQUE KEY unique_tenant_id (tenant_id,phone)
);

-- Create tenants table
CREATE TABLE IF NOT EXISTS tenants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('active', 'inactive', 'suspended', 'trial') DEFAULT 'trial',
    max_users INT DEFAULT 10,
    branding_logo_url TEXT,
    primary_color VARCHAR(7),
    secondary_color VARCHAR(7),
    enable_analytics BOOLEAN DEFAULT TRUE,
    enable_file_uploads BOOLEAN DEFAULT TRUE,
    enable_sync BOOLEAN DEFAULT TRUE,
    enable_approvals BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_code (code),
    INDEX idx_status (status)
);

-- Create territories table
CREATE TABLE IF NOT EXISTS territories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    territory_id VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) NOT NULL,
    description TEXT,
    area_manager_id INT,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_code (tenant_id, code),
    INDEX idx_area_manager (area_manager_id),
    INDEX idx_territory_id (territory_id)
);

-- Create shops table
CREATE TABLE IF NOT EXISTS shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    status ENUM('active', 'inactive', 'suspended', 'closed') DEFAULT 'active',
    address VARCHAR(500),
    phone VARCHAR(20),
    contact_person VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    territory_id VARCHAR(20),
    tenant_id VARCHAR(50) NOT NULL,
    last_sync_date TIMESTAMP NULL,
    sync_status VARCHAR(20) DEFAULT 'pending',
    sync_error VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_shop_code (code),
    INDEX idx_territory (territory_id),
    INDEX idx_status (status),
    INDEX idx_sync_status (sync_status),
    FOREIGN KEY (territory_id) REFERENCES territories(territory_id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);

-- Create routes table
CREATE TABLE IF NOT EXISTS routes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    territory_id VARCHAR(20) NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    week_start_date DATE NOT NULL,
    status ENUM('planned', 'in_progress', 'completed') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_route_id (route_id),
    INDEX idx_tenant_territory (tenant_id, territory_id),
    INDEX idx_week_start (week_start_date)
);

-- Create route_assignments table
CREATE TABLE IF NOT EXISTS route_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id VARCHAR(20) NOT NULL,
    shop_id VARCHAR(20) NOT NULL,
    sales_executive_id INT NOT NULL,
    planned_date DATE NOT NULL,
    planned_time TIME,
    sequence_order INT,
    status ENUM('planned', 'in_progress', 'completed', 'skipped') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_route_shop (route_id, shop_id),
    INDEX idx_executive_date (sales_executive_id, planned_date)
);

-- Create visits table
CREATE TABLE IF NOT EXISTS visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_assignment_id INT NOT NULL,
    shop_id VARCHAR(20) NOT NULL,
    sales_executive_id INT NOT NULL,
    route_id VARCHAR(20),
    tenant_id VARCHAR(50) NOT NULL,
    checkin_time TIMESTAMP,
    checkout_time TIMESTAMP,
    checkin_latitude DECIMAL(10, 8),
    checkin_longitude DECIMAL(11, 8),
    checkout_latitude DECIMAL(10, 8),
    checkout_longitude DECIMAL(11, 8),
    remarks TEXT,
    next_steps TEXT,
    status ENUM('scheduled', 'in_progress', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_executive (tenant_id, sales_executive_id),
    INDEX idx_shop_date (shop_id, checkin_time),
    INDEX idx_route (route_id),
    INDEX idx_status (status)
);


-- Create approvals table
CREATE TABLE IF NOT EXISTS approvals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type ENUM('user', 'shop', 'territory') NOT NULL,
    entity_id INT NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    requested_by INT NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by INT,
    approved_at TIMESTAMP NULL,
    rejected_by INT,
    rejected_at TIMESTAMP NULL,
    rejection_reason TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    INDEX idx_tenant_entity (tenant_id, entity_type, entity_id),
    INDEX idx_status (status),
    INDEX idx_requested_by (requested_by)
);

-- Create audit_logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id VARCHAR(50) NOT NULL,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_tenant_user (tenant_id, user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at)
);

-- Create synced_shop_data table for client data synchronization
CREATE TABLE IF NOT EXISTS synced_shop_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id VARCHAR(20) NOT NULL,
    shop_name VARCHAR(100) NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    current_payment DECIMAL(12,2) DEFAULT 0.0,
    upcoming_payment DECIMAL(12,2) DEFAULT 0.0,
    overdue_payment DECIMAL(12,2) DEFAULT 0.0,
    sync_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sync_status ENUM('pending','in_progress','completed','failed','not_synced') DEFAULT 'completed',
    sync_error VARCHAR(500),
    raw_client_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_shop_tenant (shop_id, tenant_id),
    INDEX idx_sync_status (sync_status)
);

-- Create synced_orders table for synchronized order data
CREATE TABLE IF NOT EXISTS synced_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    payment_status ENUM('current','upcoming','overdue') NOT NULL,
    days_overdue INT DEFAULT 0,
    shop_data_id INT NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    sync_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    raw_order_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_order_tenant (order_id, tenant_id),
    INDEX idx_shop_data (shop_data_id),
    INDEX idx_payment_status (payment_status),
    FOREIGN KEY (shop_data_id) REFERENCES synced_shop_data(id) ON DELETE CASCADE
);

-- Create synced_products table for synchronized product data
CREATE TABLE IF NOT EXISTS synced_products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_amount DECIMAL(12,2) NOT NULL,
    sku VARCHAR(50),
    category VARCHAR(50),
    shop_data_id INT NOT NULL,
    order_id INT,
    tenant_id VARCHAR(50) NOT NULL,
    sync_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    raw_product_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_shop_data (shop_data_id),
    INDEX idx_order (order_id),
    INDEX idx_sku (sku),
    FOREIGN KEY (shop_data_id) REFERENCES synced_shop_data(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES synced_orders(id) ON DELETE CASCADE
);

-- Create sales_performance table for executive analytics
CREATE TABLE IF NOT EXISTS sales_performance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_orders INT DEFAULT 0,
    total_order_value DECIMAL(12,2) DEFAULT 0.0,
    average_order_value DECIMAL(12,2) DEFAULT 0.0,
    current_payments DECIMAL(12,2) DEFAULT 0.0,
    upcoming_payments DECIMAL(12,2) DEFAULT 0.0,
    overdue_payments DECIMAL(12,2) DEFAULT 0.0,
    payment_collection_rate DECIMAL(5,2) DEFAULT 0.0,
    performance_level ENUM('excellent','good','average','poor','critical') NOT NULL,
    payment_trend ENUM('improving','stable','declining','critical') NOT NULL,
    shops_managed INT DEFAULT 0,
    active_shops INT DEFAULT 0,
    total_visits INT DEFAULT 0,
    completed_visits INT DEFAULT 0,
    visit_completion_rate DECIMAL(5,2) DEFAULT 0.0,
    additional_metrics JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_user_tenant (user_id, tenant_id),
    INDEX idx_period (period_start, period_end),
    INDEX idx_performance (performance_level),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create shop_analytics table for shop-specific analytics
CREATE TABLE IF NOT EXISTS shop_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id INT NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_orders INT DEFAULT 0,
    total_order_value DECIMAL(12,2) DEFAULT 0.0,
    average_order_value DECIMAL(12,2) DEFAULT 0.0,
    order_frequency DECIMAL(8,2) DEFAULT 0.0,
    current_payment DECIMAL(12,2) DEFAULT 0.0,
    upcoming_payment DECIMAL(12,2) DEFAULT 0.0,
    overdue_payment DECIMAL(12,2) DEFAULT 0.0,
    payment_collection_rate DECIMAL(5,2) DEFAULT 0.0,
    average_payment_delay INT DEFAULT 0,
    total_visits INT DEFAULT 0,
    completed_visits INT DEFAULT 0,
    visit_frequency DECIMAL(8,2) DEFAULT 0.0,
    performance_level ENUM('excellent','good','average','poor','critical') NOT NULL,
    payment_trend ENUM('improving','stable','declining','critical') NOT NULL,
    top_products JSON,
    product_diversity INT DEFAULT 0,
    additional_analytics JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_shop_tenant (shop_id, tenant_id),
    INDEX idx_period (period_start, period_end),
    INDEX idx_performance (performance_level),
    FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE CASCADE
);

-- Create payment_analytics table for payment analytics
CREATE TABLE IF NOT EXISTS payment_analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id VARCHAR(50) NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_current_payments DECIMAL(12,2) DEFAULT 0.0,
    total_upcoming_payments DECIMAL(12,2) DEFAULT 0.0,
    total_overdue_payments DECIMAL(12,2) DEFAULT 0.0,
    total_payments DECIMAL(12,2) DEFAULT 0.0,
    average_payment_amount DECIMAL(12,2) DEFAULT 0.0,
    payment_collection_rate DECIMAL(5,2) DEFAULT 0.0,
    overdue_rate DECIMAL(5,2) DEFAULT 0.0,
    orders_within_30_days INT DEFAULT 0,
    orders_overdue INT DEFAULT 0,
    compliance_rate DECIMAL(5,2) DEFAULT 0.0,
    payment_trend ENUM('improving','stable','declining','critical') NOT NULL,
    days_to_payment_improvement INT,
    total_shops INT DEFAULT 0,
    shops_with_overdue INT DEFAULT 0,
    shops_with_upcoming INT DEFAULT 0,
    additional_payment_metrics JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_period (tenant_id, period_start, period_end),
    INDEX idx_payment_trend (payment_trend)
);

-- Insert default superadmin tenant
INSERT INTO tenants (name, code, status, max_users, created_by) 
VALUES ('Platform Owner', 'PLATFORM', 'active', 1000, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert default superadmin user
INSERT INTO users (phone, name, email, role, status, tenant_id, created_by) 
VALUES ('+1234567890', 'System Administrator', 'admin@platform.com', 'superadmin', 'active', 'PLATFORM', 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Create due_data table for outstanding payments
CREATE TABLE IF NOT EXISTS due_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id VARCHAR(20) NOT NULL,
    shop_name VARCHAR(100) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('current','upcoming','overdue') NOT NULL,
    sales_executive_id INT,
    territory_id VARCHAR(20),
    tenant_id VARCHAR(50) NOT NULL,
    original_amount DECIMAL(12,2),
    days_overdue INT,
    last_payment_date DATE,
    notes TEXT,
    last_sync_date TIMESTAMP NULL,
    sync_status VARCHAR(20) DEFAULT 'pending',
    sync_error VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_shop_id (shop_id),
    INDEX idx_due_date (due_date),
    INDEX idx_status (status),
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_tenant_executive (tenant_id, sales_executive_id),
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_tenant_due_date (tenant_id, due_date),
    INDEX idx_tenant_territory (tenant_id, territory_id),
    FOREIGN KEY (sales_executive_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Create sales_executive_assignments table for analytics
CREATE TABLE IF NOT EXISTS sales_executive_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sales_executive_id INT NOT NULL,
    shop_id VARCHAR(20) NOT NULL,
    territory_id VARCHAR(20) NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    assigned_date DATE NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_executive_shop (sales_executive_id, shop_id),
    INDEX idx_tenant_executive (tenant_id, sales_executive_id),
    INDEX idx_territory (territory_id),
    INDEX idx_status (status),
    FOREIGN KEY (sales_executive_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (shop_id) REFERENCES shops(shop_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_executive_shop (sales_executive_id, shop_id)
);

-- Enhance synced_orders table with sales executive assignment
ALTER TABLE synced_orders ADD COLUMN sales_executive_id INT;
ALTER TABLE synced_orders ADD INDEX idx_sales_executive (sales_executive_id);
ALTER TABLE synced_orders ADD CONSTRAINT fk_synced_orders_sales_executive 
    FOREIGN KEY (sales_executive_id) REFERENCES users(id) ON DELETE SET NULL;

-- Enhance synced_products table with sales executive assignment  
ALTER TABLE synced_products ADD COLUMN sales_executive_id INT;
ALTER TABLE synced_products ADD INDEX idx_sales_executive (sales_executive_id);
ALTER TABLE synced_products ADD CONSTRAINT fk_synced_products_sales_executive 
    FOREIGN KEY (sales_executive_id) REFERENCES users(id) ON DELETE SET NULL;

-- Create indexes for performance
CREATE INDEX idx_users_tenant_role ON users(tenant_id, role);
CREATE INDEX idx_territories_tenant ON territories(tenant_id);
CREATE INDEX idx_shops_tenant_territory ON shops(tenant_id, territory_id);
CREATE INDEX idx_routes_tenant_week ON routes(tenant_id, week_start_date);
CREATE INDEX idx_visits_tenant_date ON visits(tenant_id, checkin_time);
CREATE INDEX idx_sales_executive_assignments_tenant ON sales_executive_assignments(tenant_id);
CREATE INDEX idx_sales_executive_assignments_territory ON sales_executive_assignments(territory_id);
