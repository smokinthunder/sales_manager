-- insert_users.sql

-- Insert Users (Multi-value INSERT for DRY approach)
INSERT INTO users (phone, name, email, role, status, tenant_id, created_by) 
VALUES 
    ('9999999999', 'Super Admin', 'super@example.com', 'superadmin', 'active', 'default', 1),
    ('5555555555', 'Nagarjuna', 'nag@example.com', 'area_manager', 'active', 'default', 2),
    ('4444444444', 'Soubin', 'soubin@example.com', 'sales_executive', 'active', 'default', 2)
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    email = VALUES(email),
    role = VALUES(role),
    status = VALUES(status),
    tenant_id = VALUES(tenant_id),
    created_by = VALUES(created_by);

-- Insert Kerala Territories (Multi-value INSERT for DRY approach)
INSERT INTO territories (territory_id, name, code, description, area_manager_id, tenant_id, created_by) 
VALUES 
    ('KL-TRV-001', 'Thiruvananthapuram Central', 'TRV-CENT', 'Central business district of Thiruvananthapuram', 3, 'default', 1),
    ('KL-KOC-001', 'Kochi Metro', 'KOC-METRO', 'Kochi metropolitan area including Ernakulam', 3, 'default', 1),
    ('KL-CAL-001', 'Kozhikode North', 'CAL-NORTH', 'Northern region of Kozhikode district', 3, 'default', 1),
    ('KL-TSR-001', 'Thrissur Central', 'TSR-CENT', 'Central Thrissur with major commercial areas', 3, 'default', 1),
    ('KL-KAN-001', 'Kannur Coastal', 'KAN-COAST', 'Coastal areas of Kannur district', 3, 'default', 1)
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    code = VALUES(code),
    description = VALUES(description),
    area_manager_id = VALUES(area_manager_id),
    tenant_id = VALUES(tenant_id),
    created_by = VALUES(created_by);

-- Insert Shops in Kerala (Multi-value INSERT for DRY approach)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) 
VALUES 
    -- Thiruvananthapuram Shops
    ('SHOP-TRV-001', 'Lulu Mall Thiruvananthapuram', 'LULU-TRV', 'active', 'Lulu Mall, Pattom, Thiruvananthapuram, Kerala 695004', '0471-1234567', 'Rajesh Kumar', 8.5241, 76.9366, 'KL-TRV-001', 'default', 1),
    ('SHOP-TRV-002', 'Spencer Plaza TVM', 'SPEN-TVM', 'active', 'Spencer Plaza, MG Road, Thiruvananthapuram, Kerala 695001', '0471-2345678', 'Priya Menon', 8.5081, 76.9524, 'KL-TRV-001', 'default', 1),
    ('SHOP-TRV-003', 'Pothys Thiruvananthapuram', 'POTHY-TRV', 'active', 'Pothys, Statue Junction, Thiruvananthapuram, Kerala 695001', '0471-3456789', 'Suresh Nair', 8.5081, 76.9524, 'KL-TRV-001', 'default', 1),
    
    -- Kochi Shops
    ('SHOP-KOC-001', 'Lulu Mall Kochi', 'LULU-KOC', 'active', 'Lulu Mall, Edappally, Kochi, Kerala 682024', '0484-1234567', 'Anil Kumar', 10.0169, 76.3118, 'KL-KOC-001', 'default', 1),
    ('SHOP-KOC-002', 'Oberon Mall', 'OBER-KOC', 'active', 'Oberon Mall, Edappally, Kochi, Kerala 682024', '0484-2345678', 'Deepa Pillai', 10.0169, 76.3118, 'KL-KOC-001', 'default', 1),
    ('SHOP-KOC-003', 'Centre Square Mall', 'CENT-KOC', 'active', 'Centre Square Mall, MG Road, Kochi, Kerala 682016', '0484-3456789', 'Vijay Menon', 9.9674, 76.2458, 'KL-KOC-001', 'default', 1),
    ('SHOP-KOC-004', 'Gold Souk Grande', 'GOLD-KOC', 'active', 'Gold Souk Grande, Kaloor, Kochi, Kerala 682017', '0484-4567890', 'Rekha Nair', 9.9969, 76.2904, 'KL-KOC-001', 'default', 1),
    
    -- Kozhikode Shops
    ('SHOP-CAL-001', 'Focus Mall Kozhikode', 'FOCUS-CAL', 'active', 'Focus Mall, Mavoor Road, Kozhikode, Kerala 673001', '0495-1234567', 'Mohammed Ali', 11.2588, 75.7804, 'KL-CAL-001', 'default', 1),
    ('SHOP-CAL-002', 'HiLITE Mall', 'HILITE-CAL', 'active', 'HiLITE Mall, HiLITE Business Park, Kozhikode, Kerala 673014', '0495-2345678', 'Sajitha Rahman', 11.2588, 75.7804, 'KL-CAL-001', 'default', 1),
    ('SHOP-CAL-003', 'Pothys Kozhikode', 'POTHY-CAL', 'active', 'Pothys, SM Street, Kozhikode, Kerala 673001', '0495-3456789', 'Abdul Rahman', 11.2588, 75.7804, 'KL-CAL-001', 'default', 1),
    
    -- Thrissur Shops
    ('SHOP-TSR-001', 'Sobha City Mall', 'SOBHA-TSR', 'active', 'Sobha City Mall, Thrissur, Kerala 680001', '0487-1234567', 'Gopalakrishnan', 10.5276, 76.2144, 'KL-TSR-001', 'default', 1),
    ('SHOP-TSR-002', 'Pothys Thrissur', 'POTHY-TSR', 'active', 'Pothys, Round West, Thrissur, Kerala 680001', '0487-2345678', 'Lakshmi Nair', 10.5276, 76.2144, 'KL-TSR-001', 'default', 1),
    ('SHOP-TSR-003', 'Kalyan Silks Thrissur', 'KALYAN-TSR', 'active', 'Kalyan Silks, MG Road, Thrissur, Kerala 680001', '0487-3456789', 'Radha Menon', 10.5276, 76.2144, 'KL-TSR-001', 'default', 1),
    
    -- Kannur Shops
    ('SHOP-KAN-001', 'Pothys Kannur', 'POTHY-KAN', 'active', 'Pothys, Fort Road, Kannur, Kerala 670001', '0497-1234567', 'Suresh Kumar', 11.8745, 75.3704, 'KL-KAN-001', 'default', 1),
    ('SHOP-KAN-002', 'Kalyan Silks Kannur', 'KALYAN-KAN', 'active', 'Kalyan Silks, Bank Road, Kannur, Kerala 670001', '0497-2345678', 'Meera Nair', 11.8745, 75.3704, 'KL-KAN-001', 'default', 1),
    ('SHOP-KAN-003', 'Fashion Store Kannur', 'FASH-KAN', 'active', 'Fashion Store, Thavakkara, Kannur, Kerala 670001', '0497-3456789', 'Rajesh Pillai', 11.8745, 75.3704, 'KL-KAN-001', 'default', 1)
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    code = VALUES(code),
    status = VALUES(status),
    address = VALUES(address),
    phone = VALUES(phone),
    contact_person = VALUES(contact_person),
    latitude = VALUES(latitude),
    longitude = VALUES(longitude),
    territory_id = VALUES(territory_id),
    tenant_id = VALUES(tenant_id),
    created_by = VALUES(created_by);

INSERT INTO routes (route_id, name, territory_id, week_start_date, status, tenant_id, created_by)
VALUES 
    -- Thiruvananthapuram Central Routes
    ('RT-001', 'Thiruvananthapuram Morning Route', 'KL-TRV-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-002', 'Thiruvananthapuram Afternoon Route', 'KL-TRV-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-003', 'Thiruvananthapuram Weekend Route', 'KL-TRV-001', '2025-06-07', 'planned', 'default', 1),

    -- Kochi Metro Routes
    ('RT-004', 'Kochi Metro Morning Route', 'KL-KOC-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-005', 'Kochi Metro Afternoon Route', 'KL-KOC-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-006', 'Kochi Weekend Mall Route', 'KL-KOC-001', '2025-06-07', 'planned', 'default', 1),

    -- Kozhikode North Routes
    ('RT-007', 'Kozhikode North Morning Route', 'KL-CAL-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-008', 'Kozhikode North Evening Route', 'KL-CAL-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-009', 'Kozhikode Weekend Route', 'KL-CAL-001', '2025-06-07', 'planned', 'default', 1),

    -- Thrissur Central Routes
    ('RT-010', 'Thrissur Central Morning Route', 'KL-TSR-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-011', 'Thrissur Central Afternoon Route', 'KL-TSR-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-012', 'Thrissur Weekend Silks Route', 'KL-TSR-001', '2025-06-07', 'planned', 'default', 1),

    -- Kannur Coastal Routes
    ('RT-013', 'Kannur Coastal Morning Route', 'KL-KAN-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-014', 'Kannur Coastal Evening Route', 'KL-KAN-001', '2025-06-02', 'planned', 'default', 1),
    ('RT-015', 'Kannur Weekend Coastal Route', 'KL-KAN-001', '2025-06-07', 'planned', 'default', 1)
ON DUPLICATE KEY UPDATE 
    name = VALUES(name),
    territory_id = VALUES(territory_id),
    week_start_date = VALUES(week_start_date),
    status = VALUES(status),
    tenant_id = VALUES(tenant_id),
    created_by = VALUES(created_by);

-- Insert Outstanding Due Data (sample seed)
INSERT INTO due_data (
    shop_id, shop_name, amount, due_date, status, territory_id, tenant_id, notes, sales_executive_id
) VALUES 
    ('SHOP-TRV-001', 'Lulu Mall Thiruvananthapuram', 15000.00, '2025-10-05', 'upcoming', 'KL-TRV-001', 'default', 'Q4 payment', 4),
    ('SHOP-KOC-001', 'Lulu Mall Kochi', 23000.00, '2025-09-15', 'current', 'KL-KOC-001', 'default', 'September due', 4),
    ('SHOP-CAL-001', 'Focus Mall Kozhikode', 12500.00, '2025-08-20', 'overdue', 'KL-CAL-001', 'default', 'August overdue', 4),
    ('SHOP-TSR-001', 'Sobha City Mall', 8400.00, '2025-10-01', 'upcoming', 'KL-TSR-001', 'default', 'Planned before festival', 4),
    ('SHOP-KAN-001', 'Pothys Kannur', 5600.00, '2025-09-25', 'current', 'KL-KAN-001', 'default', 'Due today', 4),
    ('SHOP-KOC-004', 'Gold Souk Grande', 9900.00, '2025-07-30', 'overdue', 'KL-KOC-001', 'default', 'Past due', 4),
    ('SHOP-TRV-003', 'Pothys Thiruvananthapuram', 7300.00, '2025-09-10', 'overdue', 'KL-TRV-001', 'default', 'Missed reminder', 4),
    ('SHOP-CAL-003', 'Pothys Kozhikode', 11200.00, '2025-10-12', 'upcoming', 'KL-CAL-001', 'default', 'Festival season', 4),
    ('SHOP-KOC-002', 'Oberon Mall', 10000.00, '2025-10-10', 'upcoming', 'KL-KOC-001', 'default', 'October due', 4),
    ('SHOP-KOC-003', 'Centre Square Mall', 13000.00, '2025-09-20', 'current', 'KL-KOC-001', 'default', 'September due', 4),
    ('SHOP-KOC-004', 'Gold Souk Grande', 9900.00, '2025-07-30', 'overdue', 'KL-KOC-001', 'default', 'Past due', 4),
    ('SHOP-KOC-005', 'Pothys Kochi', 12000.00, '2025-09-15', 'current', 'KL-KOC-001', 'default', 'September due', 4),
    ('SHOP-KOC-006', 'HiLITE Mall', 11000.00, '2025-08-25', 'overdue', 'KL-KOC-001', 'default', 'August overdue', 4),
    ('SHOP-KOC-007', 'Lulu Mall Kochi', 14000.00, '2025-10-05', 'upcoming', 'KL-KOC-001', 'default', 'Q4 payment', 4);

-- Insert Route Assignments for Sales Executive
INSERT INTO route_assignments (route_id, shop_id, sales_executive_id, planned_date, sequence_order, status)
VALUES 
    -- Thiruvananthapuram Routes
    ('RT-001', 'SHOP-TRV-001', 4, '2025-10-07', 1, 'planned'),
    ('RT-001', 'SHOP-TRV-002', 4, '2025-10-07', 2, 'planned'),
    ('RT-002', 'SHOP-TRV-003', 4, '2025-10-08', 1, 'planned'),
    
    -- Kochi Routes
    ('RT-004', 'SHOP-KOC-001', 4, '2025-10-07', 1, 'planned'),
    ('RT-004', 'SHOP-KOC-002', 4, '2025-10-07', 2, 'planned'),
    ('RT-004', 'SHOP-KOC-003', 4, '2025-10-07', 3, 'planned'),
    ('RT-005', 'SHOP-KOC-004', 4, '2025-10-08', 1, 'planned'),
    
    -- Kozhikode Routes
    ('RT-007', 'SHOP-CAL-001', 4, '2025-10-09', 1, 'planned'),
    ('RT-007', 'SHOP-CAL-002', 4, '2025-10-09', 2, 'planned'),
    ('RT-008', 'SHOP-CAL-003', 4, '2025-10-10', 1, 'planned'),
    
    -- Thrissur Routes
    ('RT-010', 'SHOP-TSR-001', 4, '2025-10-11', 1, 'planned'),
    ('RT-010', 'SHOP-TSR-002', 4, '2025-10-11', 2, 'planned'),
    ('RT-011', 'SHOP-TSR-003', 4, '2025-10-12', 1, 'planned'),
    
    -- Kannur Routes
    ('RT-013', 'SHOP-KAN-001', 4, '2025-10-14', 1, 'planned'),
    ('RT-013', 'SHOP-KAN-002', 4, '2025-10-14', 2, 'planned'),
    ('RT-014', 'SHOP-KAN-003', 4, '2025-10-15', 1, 'planned')
ON DUPLICATE KEY UPDATE 
    shop_id = VALUES(shop_id),
    sales_executive_id = VALUES(sales_executive_id),
    planned_date = VALUES(planned_date),
    sequence_order = VALUES(sequence_order),
    status = VALUES(status);

-- Insert Synced Shop Data (payment information)
INSERT INTO synced_shop_data (
    shop_id, shop_name, tenant_id, current_payment, upcoming_payment, overdue_payment, 
    sync_status, created_by
) VALUES 
    -- Thiruvananthapuram Shops
    ('SHOP-TRV-001', 'Lulu Mall Thiruvananthapuram', 'default', 42000.00, 15000.00, 0.00, 'completed', 1),
    ('SHOP-TRV-002', 'Spencer Plaza TVM', 'default', 30000.00, 8000.00, 0.00, 'completed', 1),
    ('SHOP-TRV-003', 'Pothys Thiruvananthapuram', 'default', 25000.00, 0.00, 7300.00, 'completed', 1),
    
    -- Kochi Shops (highest payments)
    ('SHOP-KOC-001', 'Lulu Mall Kochi', 'default', 62000.00, 23000.00, 0.00, 'completed', 1),
    ('SHOP-KOC-002', 'Oberon Mall', 'default', 48000.00, 10000.00, 0.00, 'completed', 1),
    ('SHOP-KOC-003', 'Centre Square Mall', 'default', 35000.00, 13000.00, 0.00, 'completed', 1),
    ('SHOP-KOC-004', 'Gold Souk Grande', 'default', 40000.00, 0.00, 9900.00, 'completed', 1),
    
    -- Kozhikode Shops
    ('SHOP-CAL-001', 'Focus Mall Kozhikode', 'default', 32000.00, 0.00, 12500.00, 'completed', 1),
    ('SHOP-CAL-002', 'HiLITE Mall', 'default', 27000.00, 6000.00, 0.00, 'completed', 1),
    ('SHOP-CAL-003', 'Pothys Kozhikode', 'default', 24000.00, 11200.00, 0.00, 'completed', 1),
    
    -- Thrissur Shops
    ('SHOP-TSR-001', 'Sobha City Mall', 'default', 38000.00, 8400.00, 0.00, 'completed', 1),
    ('SHOP-TSR-002', 'Pothys Thrissur', 'default', 31000.00, 7500.00, 0.00, 'completed', 1),
    ('SHOP-TSR-003', 'Kalyan Silks Thrissur', 'default', 35000.00, 9200.00, 0.00, 'completed', 1),
    
    -- Kannur Shops
    ('SHOP-KAN-001', 'Pothys Kannur', 'default', 22000.00, 5600.00, 0.00, 'completed', 1),
    ('SHOP-KAN-002', 'Kalyan Silks Kannur', 'default', 19000.00, 4800.00, 0.00, 'completed', 1),
    ('SHOP-KAN-003', 'Fashion Store Kannur', 'default', 17000.00, 3200.00, 0.00, 'completed', 1)
ON DUPLICATE KEY UPDATE 
    shop_name = VALUES(shop_name),
    current_payment = VALUES(current_payment),
    upcoming_payment = VALUES(upcoming_payment),
    overdue_payment = VALUES(overdue_payment),
    sync_status = VALUES(sync_status),
    created_by = VALUES(created_by);

-- Insert Sales Performance Data (sample seed)
INSERT INTO sales_performance (
    user_id, tenant_id, period_start, period_end, 
    total_orders, total_order_value, average_order_value, 
    current_payments, upcoming_payments, overdue_payments, 
    payment_collection_rate, performance_level, payment_trend, 
    shops_managed, active_shops, total_visits, completed_visits, 
    visit_completion_rate, created_by
) VALUES 
    -- September 2025 Performance Data
    (4, 'default', '2025-09-01', '2025-09-30', 95, 545000.00, 5736.84, 488000.00, 35000.00, 22000.00, 89.54, 'good', 'stable', 16, 16, 151, 143, 94.70, 1),
    
    -- August 2025 Performance Data  
    (4, 'default', '2025-08-01', '2025-08-31', 103, 598000.00, 5805.83, 568000.00, 25000.00, 5000.00, 94.98, 'excellent', 'improving', 16, 16, 165, 158, 95.76, 1),
    
    -- July 2025 Performance Data
    (4, 'default', '2025-07-01', '2025-07-31', 87, 497000.00, 5712.64, 465000.00, 20000.00, 12000.00, 93.56, 'good', 'stable', 16, 16, 142, 135, 95.07, 1)
ON DUPLICATE KEY UPDATE 
    total_orders = VALUES(total_orders),
    total_order_value = VALUES(total_order_value),
    average_order_value = VALUES(average_order_value),
    current_payments = VALUES(current_payments),
    upcoming_payments = VALUES(upcoming_payments),
    overdue_payments = VALUES(overdue_payments),
    payment_collection_rate = VALUES(payment_collection_rate),
    performance_level = VALUES(performance_level),
    payment_trend = VALUES(payment_trend),
    shops_managed = VALUES(shops_managed),
    active_shops = VALUES(active_shops),
    total_visits = VALUES(total_visits),
    completed_visits = VALUES(completed_visits),
    visit_completion_rate = VALUES(visit_completion_rate),
    created_by = VALUES(created_by);

/*


For Opening MySQL shell inside the Docker container
docker exec -it sales_manager_mysql mysql -u root -prootpassword sales_manager

For running the script
docker exec -i sales_manager_mysql mysql -u root -prootpassword sales_manager < insert.sql

For seeing the inserted data
SELECT phone, name, email, role, tenant_id FROM users;
SELECT territory_id, name, code, area_manager_id FROM territories;
SELECT shop_id, name, code, territory_id FROM shops;
SELECT route_id, name, territory_id, week_start_date, status FROM routes;
SELECT id, route_id, shop_id, sales_executive_id, planned_date FROM route_assignments;
SELECT shop_id, shop_name, amount, due_date, status, territory_id, tenant_id, notes, sales_executive_id FROM due_data;
SELECT user_id, period_start, period_end, total_orders, total_order_value, payment_collection_rate, performance_level FROM sales_performance;
SELECT shop_id, shop_name, current_payment, upcoming_payment, overdue_payment, sync_status FROM synced_shop_data;




*/