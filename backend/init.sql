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
    status ENUM('active', 'inactive', 'suspended', 'pending_approval') DEFAULT 'pending_approval',
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_phone (tenant_id, phone),
    INDEX idx_role_status (role, status),
    UNIQUE KEY unique_tenant_id (tenant_id)
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
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50) NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    area_manager_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_code (tenant_id, code),
    INDEX idx_area_manager (area_manager_id)
);

-- Create shops table
CREATE TABLE IF NOT EXISTS shops (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(20),
    territory_id INT,
    tenant_id VARCHAR(50) NOT NULL,
    status ENUM('active', 'inactive', 'pending_approval') DEFAULT 'pending_approval',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_territory (territory_id),
    INDEX idx_status (status)
);

-- Create routes table
CREATE TABLE IF NOT EXISTS routes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    territory_id INT NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    week_start_date DATE NOT NULL,
    status ENUM('planned', 'in_progress', 'completed') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_territory (tenant_id, territory_id),
    INDEX idx_week_start (week_start_date)
);

-- Create route_assignments table
CREATE TABLE IF NOT EXISTS route_assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_id INT NOT NULL,
    shop_id INT NOT NULL,
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
    shop_id INT NOT NULL,
    sales_executive_id INT NOT NULL,
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
    INDEX idx_status (status)
);

-- Create products table (read-only from client system)
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    mrp DECIMAL(10, 2),
    tenant_id VARCHAR(50) NOT NULL,
    last_synced TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_sku (tenant_id, sku),
    INDEX idx_category (category)
);

-- Create orders table (read-only from client system)
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(100) NOT NULL,
    shop_id VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'delivered', 'cancelled') NOT NULL,
    total_amount DECIMAL(12, 2),
    tenant_id VARCHAR(50) NOT NULL,
    last_synced TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_order_date (order_date),
    INDEX idx_status (status)
);

-- Create order_lines table
CREATE TABLE IF NOT EXISTS order_lines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    sku VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    rate DECIMAL(10, 2) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    INDEX idx_order_sku (order_id, sku)
);

-- Create payments table (read-only from client system)
CREATE TABLE IF NOT EXISTS payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id VARCHAR(100) NOT NULL,
    shop_id VARCHAR(100) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50),
    tenant_id VARCHAR(50) NOT NULL,
    last_synced TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_payment_date (payment_date)
);

-- Create outstandings table (read-only from client system)
CREATE TABLE IF NOT EXISTS outstandings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_id VARCHAR(100) NOT NULL,
    amount_due DECIMAL(12, 2) NOT NULL,
    as_of_date DATE NOT NULL,
    days_overdue INT NOT NULL,
    tenant_id VARCHAR(50) NOT NULL,
    last_synced TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_days_overdue (days_overdue)
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

-- Insert default superadmin tenant
INSERT INTO tenants (name, code, status, max_users, created_by) 
VALUES ('Platform Owner', 'PLATFORM', 'active', 1000, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert default superadmin user
INSERT INTO users (phone, name, email, role, status, tenant_id, created_by) 
VALUES ('+1234567890', 'System Administrator', 'admin@platform.com', 'superadmin', 'active', 'PLATFORM', 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Create indexes for performance
CREATE INDEX idx_users_tenant_role ON users(tenant_id, role);
CREATE INDEX idx_territories_tenant ON territories(tenant_id);
CREATE INDEX idx_shops_tenant_territory ON shops(tenant_id, territory_id);
CREATE INDEX idx_routes_tenant_week ON routes(tenant_id, week_start_date);
CREATE INDEX idx_visits_tenant_date ON visits(tenant_id, DATE(checkin_time));
CREATE INDEX idx_products_tenant_category ON products(tenant_id, category);
CREATE INDEX idx_orders_tenant_date ON orders(tenant_id, order_date);
CREATE INDEX idx_payments_tenant_date ON payments(tenant_id, payment_date);
CREATE INDEX idx_outstandings_tenant_overdue ON outstandings(tenant_id, days_overdue);
