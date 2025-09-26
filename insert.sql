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
    ('SHOP-TRV-001', 'Lulu Mall Thiruvananthapuram', 15000.00, '2025-10-05', 'upcoming', 'KL-TRV-001', 'default', 'Q4 payment', 5),
    ('SHOP-KOC-001', 'Lulu Mall Kochi', 23000.00, '2025-09-15', 'current', 'KL-KOC-001', 'default', 'September due', 5),
    ('SHOP-CAL-001', 'Focus Mall Kozhikode', 12500.00, '2025-08-20', 'overdue', 'KL-CAL-001', 'default', 'August overdue', 5),
    ('SHOP-TSR-001', 'Sobha City Mall', 8400.00, '2025-10-01', 'upcoming', 'KL-TSR-001', 'default', 'Planned before festival', 5),
    ('SHOP-KAN-001', 'Pothys Kannur', 5600.00, '2025-09-25', 'current', 'KL-KAN-001', 'default', 'Due today', 5),
    ('SHOP-KOC-004', 'Gold Souk Grande', 9900.00, '2025-07-30', 'overdue', 'KL-KOC-001', 'default', 'Past due', 5),
    ('SHOP-TRV-003', 'Pothys Thiruvananthapuram', 7300.00, '2025-09-10', 'overdue', 'KL-TRV-001', 'default', 'Missed reminder', 5),
    ('SHOP-CAL-003', 'Pothys Kozhikode', 11200.00, '2025-10-12', 'upcoming', 'KL-CAL-001', 'default', 'Festival season', 5),
    ('SHOP-KOC-002', 'Oberon Mall', 10000.00, '2025-10-10', 'upcoming', 'KL-KOC-001', 'default', 'October due', 5),
    ('SHOP-KOC-003', 'Centre Square Mall', 13000.00, '2025-09-20', 'current', 'KL-KOC-001', 'default', 'September due', 5),
    ('SHOP-KOC-004', 'Gold Souk Grande', 9900.00, '2025-07-30', 'overdue', 'KL-KOC-001', 'default', 'Past due', 5),
    ('SHOP-KOC-005', 'Pothys Kochi', 12000.00, '2025-09-15', 'current', 'KL-KOC-001', 'default', 'September due', 5),
    ('SHOP-KOC-006', 'HiLITE Mall', 11000.00, '2025-08-25', 'overdue', 'KL-KOC-001', 'default', 'August overdue', 5),
    ('SHOP-KOC-007', 'Lulu Mall Kochi', 14000.00, '2025-10-05', 'upcoming', 'KL-KOC-001', 'default', 'Q4 payment', 5);

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
SELECT shop_id, shop_name, amount, due_date, status, territory_id, tenant_id, notes, sales_executive_id FROM due_data;




*/