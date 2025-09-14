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