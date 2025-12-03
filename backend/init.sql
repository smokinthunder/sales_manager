-- Sales Manager Database Initialization Script
-- This script creates the initial database schema for the application
-- Includes dual authentication system: Email/Password for admin users, OTP for sales users

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
    pin_code VARCHAR(10),
    email VARCHAR(100),
    aadhaar_number VARCHAR(12),
    pan_number VARCHAR(10),
    location_name VARCHAR(100),
    gst_number VARCHAR(15),
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
    INDEX idx_email (email),
    INDEX idx_pin_code (pin_code),
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

-- Insert sample tenants for development
INSERT INTO tenants (name, code, status, max_users, created_by) VALUES
('AquaStar Foods', 'AQUASTAR', 'active', 100, 1),
('Fresh Food Co', 'FRESHFOOD', 'active', 150, 1),
('Metro Mart', 'METRO', 'active', 200, 1),
('Sample Tenant 1', 'tenant1', 'active', 50, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert default superadmin user
INSERT INTO users (phone, name, email, role, status, tenant_id, created_by) 
VALUES ('+1234567890', 'System Administrator', 'admin@platform.com', 'superadmin', 'active', 'PLATFORM', 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert sample admin users for each tenant
INSERT INTO users (phone, name, email, role, status, tenant_id, created_by) VALUES
('+1111111111', 'John Smith', 'john.smith@aquastar.com', 'client_admin', 'active', 'AQUASTAR', 1),
('+2222222222', 'Tom Anderson', 'tom.anderson@freshfood.com', 'client_admin', 'active', 'FRESHFOOD', 1),
('+3333333333', 'Mark Johnson', 'mark.johnson@metro.com', 'client_admin', 'active', 'METRO', 1),
('+9999999999', 'Super Administrator', 'superadmin@salesmanager.com', 'superadmin', 'active', 'tenant1', 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email);

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

-- Create notifications table for approval workflow
CREATE TABLE IF NOT EXISTS notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    subject VARCHAR(255) NOT NULL,
    notification_type ENUM('profile_update', 'customer_creation') NOT NULL,
    related_data JSON,
    is_confirmed BOOLEAN DEFAULT FALSE,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_receiver_status (receiver_id, is_confirmed),
    INDEX idx_sender (sender_id),
    INDEX idx_tenant_type (tenant_id, notification_type),
    INDEX idx_type_status (notification_type, is_confirmed),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Create user_auth table for email/password authentication
-- Provides email/password authentication for client_admin and superadmin users
-- while maintaining OTP authentication for sales_executive and area_manager users
CREATE TABLE IF NOT EXISTS user_auth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    reset_token VARCHAR(255) NULL,
    reset_token_expires TIMESTAMP NULL,
    last_login TIMESTAMP NULL,
    login_attempts INT DEFAULT 0,
    locked_until TIMESTAMP NULL,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    
    -- Indexes for performance
    INDEX idx_user_id (user_id),
    INDEX idx_email_tenant (email, tenant_id),
    INDEX idx_reset_token (reset_token),
    INDEX idx_tenant_email (tenant_id, email),
    
    -- Foreign key constraints
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES tenants(code) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Unique constraints for email per tenant
    UNIQUE KEY unique_tenant_email (tenant_id, email),
    UNIQUE KEY unique_user_auth (user_id)
);

-- Create user_auth_audit table for authentication logging
CREATE TABLE IF NOT EXISTS user_auth_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_auth_id INT NOT NULL,
    action ENUM('login_attempt', 'login_success', 'login_failed', 'password_reset_requested', 'password_reset_completed', 'password_changed') NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    additional_data JSON,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_user_auth_id (user_auth_id),
    INDEX idx_action (action),
    INDEX idx_tenant_created (tenant_id, created_at),
    
    FOREIGN KEY (user_auth_id) REFERENCES user_auth(id) ON DELETE CASCADE
);

-- Create indexes for performance (IF NOT EXISTS removed as it's not supported in MySQL for CREATE INDEX)
CREATE INDEX idx_users_tenant_role ON users(tenant_id, role);
CREATE INDEX idx_territories_tenant ON territories(tenant_id);
CREATE INDEX idx_shops_tenant_territory ON shops(tenant_id, territory_id);
CREATE INDEX idx_routes_tenant_week ON routes(tenant_id, week_start_date);
CREATE INDEX idx_visits_tenant_date ON visits(tenant_id, checkin_time);
CREATE INDEX idx_sales_executive_assignments_tenant ON sales_executive_assignments(tenant_id);

-- Additional indexes for email authentication
CREATE INDEX idx_user_auth_tenant_email ON user_auth(tenant_id, email);
CREATE INDEX idx_user_auth_reset_token ON user_auth(reset_token);
CREATE INDEX idx_user_auth_audit_tenant_action ON user_auth_audit(tenant_id, action, created_at);

-- Insert email authentication records for admin users
-- Default password: "Aquastar123!" for all admin users (should be changed after first login)
-- Password hash for "Aquastar123!" using bcrypt with 12 rounds
INSERT INTO user_auth (user_id, email, password_hash, tenant_id, created_by, updated_by)
SELECT 
    u.id,
    u.email,
    '$2b$12$R7Ck0FScqhGU7tQFHSE/3ud59IQkboS22lNayccGm6KJOv3sVGUzK',  -- bcrypt hash for "Aquastar123!"
    u.tenant_id,
    1,  -- created_by superadmin
    1   -- updated_by superadmin
FROM users u
WHERE u.role IN ('client_admin', 'superadmin')
AND u.email IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM user_auth ua WHERE ua.user_id = u.id
)
AND u.status = 'active'
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password_hash = VALUES(password_hash),
    updated_at = CURRENT_TIMESTAMP;

-- ============================================
-- NEW TABLES: Orders, Order Items, Shop Assignments
-- ============================================

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    bill_number VARCHAR(50) NOT NULL,
    shop_id VARCHAR(20) NOT NULL,
    executive_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    status ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'completed', 'cancelled', 'returned') DEFAULT 'pending',
    items_count INT DEFAULT 0,
    notes TEXT,
    delivery_date DATE,
    payment_status ENUM('pending', 'partial', 'paid', 'overdue') DEFAULT 'pending',
    payment_method VARCHAR(50),
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    UNIQUE KEY uq_order_id_tenant (order_id, tenant_id),
    UNIQUE KEY uq_bill_number_tenant (bill_number, tenant_id),
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_tenant_executive (tenant_id, executive_id),
    INDEX idx_tenant_date (tenant_id, order_date),
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_shop_date (shop_id, order_date),
    INDEX idx_executive_date (executive_id, order_date),
    INDEX idx_status_date (status, order_date),
    INDEX idx_payment_status (payment_status),
    FOREIGN KEY (executive_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Order Items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_code VARCHAR(50) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(20) NOT NULL DEFAULT 'pcs',
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_order (order_id),
    INDEX idx_product (product_code),
    INDEX idx_tenant (tenant_id),
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Shop Assignments table
CREATE TABLE IF NOT EXISTS shop_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id VARCHAR(20) NOT NULL,
    executive_id INT NOT NULL,
    territory_id VARCHAR(20),
    assigned_date DATE NOT NULL,
    end_date DATE,
    status ENUM('active', 'inactive', 'suspended', 'transferred') DEFAULT 'active',
    notes TEXT,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    UNIQUE KEY uq_shop_executive_tenant (shop_id, executive_id, tenant_id),
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_tenant_executive (tenant_id, executive_id),
    INDEX idx_tenant_territory (tenant_id, territory_id),
    INDEX idx_tenant_status (tenant_id, status),
    INDEX idx_shop_status (shop_id, status),
    INDEX idx_executive_status (executive_id, status),
    FOREIGN KEY (executive_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add columns to visits table for order tracking (conditional)
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'visits' AND COLUMN_NAME = 'order_placed');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE visits ADD COLUMN order_placed BOOLEAN DEFAULT FALSE AFTER remarks', 
    'SELECT "Column order_placed already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'visits' AND COLUMN_NAME = 'order_id');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE visits ADD COLUMN order_id INT AFTER order_placed', 
    'SELECT "Column order_id already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'visits' AND COLUMN_NAME = 'photos');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE visits ADD COLUMN photos TEXT AFTER order_id', 
    'SELECT "Column photos already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add index for order_id (conditional)
SET @idx_exists = (SELECT COUNT(*) FROM information_schema.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'visits' AND INDEX_NAME = 'idx_order');
SET @sql = IF(@idx_exists = 0, 
    'ALTER TABLE visits ADD INDEX idx_order (order_id)', 
    'SELECT "Index idx_order already exists"');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Create views for reporting
CREATE OR REPLACE VIEW v_active_shop_assignments AS
SELECT 
    sa.id,
    sa.shop_id,
    s.name AS shop_name,
    sa.executive_id,
    u.name AS executive_name,
    sa.territory_id,
    t.name AS territory_name,
    sa.assigned_date,
    sa.status,
    sa.tenant_id
FROM shop_assignments sa
JOIN shops s ON sa.shop_id COLLATE utf8mb4_unicode_ci = s.shop_id COLLATE utf8mb4_unicode_ci
JOIN users u ON sa.executive_id = u.id
LEFT JOIN territories t ON sa.territory_id COLLATE utf8mb4_unicode_ci = t.territory_id COLLATE utf8mb4_unicode_ci
WHERE sa.status = 'active';

CREATE OR REPLACE VIEW v_order_summary AS
SELECT 
    o.id,
    o.order_id,
    o.bill_number,
    o.shop_id,
    s.name AS shop_name,
    o.executive_id,
    u.name AS executive_name,
    o.order_date,
    o.total_amount,
    o.status,
    o.payment_status,
    o.items_count,
    o.tenant_id
FROM orders o
JOIN shops s ON o.shop_id COLLATE utf8mb4_unicode_ci = s.shop_id COLLATE utf8mb4_unicode_ci
JOIN users u ON o.executive_id = u.id;

CREATE OR REPLACE VIEW v_visit_summary AS
SELECT 
    v.id,
    v.shop_id,
    s.name AS shop_name,
    v.sales_executive_id,
    u.name AS executive_name,
    v.checkin_time,
    v.checkout_time,
    v.status,
    v.order_placed,
    v.order_id,
    CASE 
        WHEN v.order_placed = TRUE THEN o.bill_number
        ELSE NULL
    END AS bill_number,
    v.tenant_id
FROM visits v
JOIN shops s ON v.shop_id COLLATE utf8mb4_unicode_ci = s.shop_id COLLATE utf8mb4_unicode_ci
JOIN users u ON v.sales_executive_id = u.id
LEFT JOIN orders o ON v.order_id = o.id;
