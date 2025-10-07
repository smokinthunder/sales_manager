-- Simplified Dummy Data for Sales Manager System
-- 3 Clients, 10 Users per Client, 12 Shops per Client

-- Clear existing data (except system data)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE sales_executive_assignments;
TRUNCATE TABLE due_data;
TRUNCATE TABLE synced_products;
TRUNCATE TABLE synced_orders;
TRUNCATE TABLE synced_shop_data;
TRUNCATE TABLE visits;
TRUNCATE TABLE route_assignments;
TRUNCATE TABLE routes;
TRUNCATE TABLE shops;
TRUNCATE TABLE territories;
TRUNCATE TABLE users;
TRUNCATE TABLE tenants;
SET FOREIGN_KEY_CHECKS = 1;

-- Insert 3 tenants (clients)
INSERT INTO tenants (name, code, status, max_users, branding_logo_url, primary_color, secondary_color, enable_analytics, enable_file_uploads, enable_sync, enable_approvals, created_by) VALUES
('AquaStar Beverages', 'AQUASTAR', 'active', 50, 'https://aquastar.com/logo.png', '#1E40AF', '#3B82F6', TRUE, TRUE, TRUE, TRUE, 1),
('FreshFood Distributors', 'FRESHFOOD', 'active', 30, 'https://freshfood.com/logo.png', '#059669', '#10B981', TRUE, TRUE, TRUE, TRUE, 1),
('Metro Retail Solutions', 'METRO', 'active', 25, 'https://metro.com/logo.png', '#DC2626', '#EF4444', TRUE, TRUE, TRUE, TRUE, 1);

-- Insert territories for each client (3 territories per client)
INSERT INTO territories (territory_id, name, code, description, tenant_id, created_by) VALUES
-- AquaStar territories
('AQ-NORTH', 'North Region', 'NORTH', 'Northern territory', 'AQUASTAR', 1),
('AQ-SOUTH', 'South Region', 'SOUTH', 'Southern territory', 'AQUASTAR', 1),
('AQ-EAST', 'East Region', 'EAST', 'Eastern territory', 'AQUASTAR', 1),

-- FreshFood territories
('FF-METRO', 'Metro Area', 'METRO', 'Metropolitan area', 'FRESHFOOD', 1),
('FF-SUBURB', 'Suburban Zone', 'SUBURB', 'Suburban area', 'FRESHFOOD', 1),
('FF-RURAL', 'Rural Territory', 'RURAL', 'Rural area', 'FRESHFOOD', 1),

-- Metro territories
('MR-DOWNTOWN', 'Downtown District', 'DOWNTOWN', 'Downtown area', 'METRO', 1),
('MR-UPTOWN', 'Uptown Area', 'UPTOWN', 'Uptown area', 'METRO', 1),
('MR-MIDTOWN', 'Midtown Region', 'MIDTOWN', 'Midtown area', 'METRO', 1);

-- Insert users for each client (10 users per client: 1 admin, 3 area managers, 6 sales executives)
INSERT INTO users (phone, name, email, role, status, territory_id, tenant_id, created_by) VALUES
-- AquaStar users (10 total)
('+1111111111', 'John Smith', 'john.smith@aquastar.com', 'client_admin', 'active', NULL, 'AQUASTAR', 1),
('+1111111112', 'Sarah Johnson', 'sarah.johnson@aquastar.com', 'area_manager', 'active', 'AQ-NORTH', 'AQUASTAR', 1),
('+1111111113', 'Mike Wilson', 'mike.wilson@aquastar.com', 'area_manager', 'active', 'AQ-SOUTH', 'AQUASTAR', 1),
('+1111111114', 'Lisa Brown', 'lisa.brown@aquastar.com', 'area_manager', 'active', 'AQ-EAST', 'AQUASTAR', 1),
('+1111111121', 'Alex Thompson', 'alex.thompson@aquastar.com', 'sales_executive', 'active', 'AQ-NORTH', 'AQUASTAR', 1),
('+1111111122', 'Maria Garcia', 'maria.garcia@aquastar.com', 'sales_executive', 'active', 'AQ-NORTH', 'AQUASTAR', 1),
('+1111111123', 'James Anderson', 'james.anderson@aquastar.com', 'sales_executive', 'active', 'AQ-SOUTH', 'AQUASTAR', 1),
('+1111111124', 'Jennifer Taylor', 'jennifer.taylor@aquastar.com', 'sales_executive', 'active', 'AQ-SOUTH', 'AQUASTAR', 1),
('+1111111125', 'Robert Martinez', 'robert.martinez@aquastar.com', 'sales_executive', 'active', 'AQ-EAST', 'AQUASTAR', 1),
('+1111111126', 'Linda Rodriguez', 'linda.rodriguez@aquastar.com', 'sales_executive', 'active', 'AQ-EAST', 'AQUASTAR', 1),

-- FreshFood users (10 total)
('+2222222221', 'Tom Anderson', 'tom.anderson@freshfood.com', 'client_admin', 'active', NULL, 'FRESHFOOD', 1),
('+2222222222', 'Rachel Green', 'rachel.green@freshfood.com', 'area_manager', 'active', 'FF-METRO', 'FRESHFOOD', 1),
('+2222222223', 'Chris Evans', 'chris.evans@freshfood.com', 'area_manager', 'active', 'FF-SUBURB', 'FRESHFOOD', 1),
('+2222222224', 'Amy Stone', 'amy.stone@freshfood.com', 'area_manager', 'active', 'FF-RURAL', 'FRESHFOOD', 1),
('+2222222231', 'Kevin Murphy', 'kevin.murphy@freshfood.com', 'sales_executive', 'active', 'FF-METRO', 'FRESHFOOD', 1),
('+2222222232', 'Nicole Adams', 'nicole.adams@freshfood.com', 'sales_executive', 'active', 'FF-METRO', 'FRESHFOOD', 1),
('+2222222233', 'Brian Wilson', 'brian.wilson@freshfood.com', 'sales_executive', 'active', 'FF-SUBURB', 'FRESHFOOD', 1),
('+2222222234', 'Stephanie Hall', 'stephanie.hall@freshfood.com', 'sales_executive', 'active', 'FF-SUBURB', 'FRESHFOOD', 1),
('+2222222235', 'Daniel Young', 'daniel.young@freshfood.com', 'sales_executive', 'active', 'FF-RURAL', 'FRESHFOOD', 1),
('+2222222236', 'Jessica King', 'jessica.king@freshfood.com', 'sales_executive', 'active', 'FF-RURAL', 'FRESHFOOD', 1),

-- Metro users (10 total)
('+3333333331', 'Mark Johnson', 'mark.johnson@metro.com', 'client_admin', 'active', NULL, 'METRO', 1),
('+3333333332', 'Laura Davis', 'laura.davis@metro.com', 'area_manager', 'active', 'MR-DOWNTOWN', 'METRO', 1),
('+3333333333', 'Steven Wilson', 'steven.wilson@metro.com', 'area_manager', 'active', 'MR-UPTOWN', 'METRO', 1),
('+3333333334', 'Karen Brown', 'karen.brown@metro.com', 'area_manager', 'active', 'MR-MIDTOWN', 'METRO', 1),
('+3333333341', 'Ryan Miller', 'ryan.miller@metro.com', 'sales_executive', 'active', 'MR-DOWNTOWN', 'METRO', 1),
('+3333333342', 'Amanda Garcia', 'amanda.garcia@metro.com', 'sales_executive', 'active', 'MR-DOWNTOWN', 'METRO', 1),
('+3333333343', 'Jason Rodriguez', 'jason.rodriguez@metro.com', 'sales_executive', 'active', 'MR-UPTOWN', 'METRO', 1),
('+3333333344', 'Melissa Lee', 'melissa.lee@metro.com', 'sales_executive', 'active', 'MR-UPTOWN', 'METRO', 1),
('+3333333345', 'Andrew White', 'andrew.white@metro.com', 'sales_executive', 'active', 'MR-MIDTOWN', 'METRO', 1),
('+3333333346', 'Samantha Harris', 'samantha.harris@metro.com', 'sales_executive', 'active', 'MR-MIDTOWN', 'METRO', 1);

-- Update territories with area manager IDs
UPDATE territories SET area_manager_id = 2 WHERE territory_id = 'AQ-NORTH';
UPDATE territories SET area_manager_id = 3 WHERE territory_id = 'AQ-SOUTH';
UPDATE territories SET area_manager_id = 4 WHERE territory_id = 'AQ-EAST';
UPDATE territories SET area_manager_id = 8 WHERE territory_id = 'FF-METRO';
UPDATE territories SET area_manager_id = 9 WHERE territory_id = 'FF-SUBURB';
UPDATE territories SET area_manager_id = 10 WHERE territory_id = 'FF-RURAL';
UPDATE territories SET area_manager_id = 12 WHERE territory_id = 'MR-DOWNTOWN';
UPDATE territories SET area_manager_id = 13 WHERE territory_id = 'MR-UPTOWN';
UPDATE territories SET area_manager_id = 14 WHERE territory_id = 'MR-MIDTOWN';

-- Insert test notifications for demonstration
INSERT INTO notifications (sender_id, receiver_id, subject, notification_type, related_data, is_confirmed, tenant_id, created_by, updated_by) VALUES
-- Profile update notifications (from sales executives to area managers)
(5, 2, 'Profile Update Request from Alex Thompson', 'profile_update', 
 '{"user_id": 5, "update_data": {"name": "Alexander Thompson", "email": "alexander.thompson@aquastar.com"}, "sender_name": "Alex Thompson", "sender_role": "sales_executive"}', 
 FALSE, 'AQUASTAR', 5, 5),

(6, 2, 'Profile Update Request from Maria Garcia', 'profile_update', 
 '{"user_id": 6, "update_data": {"email": "maria.garcia.updated@aquastar.com"}, "sender_name": "Maria Garcia", "sender_role": "sales_executive"}', 
 FALSE, 'AQUASTAR', 6, 6),

-- Customer creation notifications (from sales executives to area managers)
(7, 3, 'New Customer Creation Request from David Lee', 'customer_creation',
 '{"shop_data": {"shop_id": "AQ-SHOP-001", "name": "New Corner Store", "address": "123 Main St", "phone": "+1555123456", "contact_person": "John Doe", "territory_id": "AQ-SOUTH"}, "sender_name": "David Lee", "sender_role": "sales_executive"}',
 FALSE, 'AQUASTAR', 7, 7),

(11, 8, 'New Customer Creation Request from Bob White', 'customer_creation',
 '{"shop_data": {"shop_id": "FF-SHOP-001", "name": "Fresh Market Plus", "address": "456 Oak Ave", "phone": "+1555789012", "contact_person": "Jane Smith", "territory_id": "FF-METRO"}, "sender_name": "Bob White", "sender_role": "sales_executive"}',
 FALSE, 'FRESHFOOD', 11, 11),

-- Already confirmed notification example
(16, 12, 'Profile Update Request from Kate Davis', 'profile_update',
 '{"user_id": 16, "update_data": {"name": "Katherine Davis"}, "sender_name": "Kate Davis", "sender_role": "sales_executive"}',
 TRUE, 'METRO', 16, 12);

