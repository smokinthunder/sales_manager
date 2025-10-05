-- Additional Shops for All Territories (Comprehensive Testing Data)
-- This script adds shops for all territories to ensure comprehensive analytics testing

-- AquaStar South Region Shops (50 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('AQ-S-001', 'Southside Market', 'AQS001', 'active', '100 South St, Southside', '+1234568001', 'John South', 40.7000, -74.0000, 'AQ-SOUTH', 'AQUASTAR', 1),
('AQ-S-002', 'Coastal Store', 'AQS002', 'active', '200 Beach Ave, Coastal', '+1234568002', 'Sarah Beach', 40.7100, -73.9900, 'AQ-SOUTH', 'AQUASTAR', 1),
('AQ-S-003', 'Harbor Shop', 'AQS003', 'active', '300 Port St, Harbor', '+1234568003', 'Mike Port', 40.7200, -73.9800, 'AQ-SOUTH', 'AQUASTAR', 1),
('AQ-S-004', 'Marina Mart', 'AQS004', 'active', '400 Dock Ave, Marina', '+1234568004', 'Lisa Dock', 40.7300, -73.9700, 'AQ-SOUTH', 'AQUASTAR', 1),
('AQ-S-005', 'Waterfront Store', 'AQS005', 'active', '500 Pier St, Waterfront', '+1234568005', 'David Pier', 40.7400, -73.9600, 'AQ-SOUTH', 'AQUASTAR', 1);

-- AquaStar East Region Shops (50 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('AQ-E-001', 'Eastside Market', 'AQE001', 'active', '100 East St, Eastside', '+1234569001', 'John East', 40.7500, -73.9500, 'AQ-EAST', 'AQUASTAR', 1),
('AQ-E-002', 'Industrial Store', 'AQE002', 'active', '200 Factory Ave, Industrial', '+1234569002', 'Sarah Factory', 40.7600, -73.9400, 'AQ-EAST', 'AQUASTAR', 1),
('AQ-E-003', 'Business Shop', 'AQE003', 'active', '300 Office St, Business', '+1234569003', 'Mike Office', 40.7700, -73.9300, 'AQ-EAST', 'AQUASTAR', 1),
('AQ-E-004', 'Corporate Mart', 'AQE004', 'active', '400 Tower Ave, Corporate', '+1234569004', 'Lisa Tower', 40.7800, -73.9200, 'AQ-EAST', 'AQUASTAR', 1),
('AQ-E-005', 'Financial Store', 'AQE005', 'active', '500 Bank St, Financial', '+1234569005', 'David Bank', 40.7900, -73.9100, 'AQ-EAST', 'AQUASTAR', 1);

-- AquaStar West Region Shops (50 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('AQ-W-001', 'Westside Market', 'AQW001', 'active', '100 West St, Westside', '+1234570001', 'John West', 40.8000, -73.9000, 'AQ-WEST', 'AQUASTAR', 1),
('AQ-W-002', 'Rural Store', 'AQW002', 'active', '200 Farm Ave, Rural', '+1234570002', 'Sarah Farm', 40.8100, -73.8900, 'AQ-WEST', 'AQUASTAR', 1),
('AQ-W-003', 'Country Shop', 'AQW003', 'active', '300 Village St, Country', '+1234570003', 'Mike Village', 40.8200, -73.8800, 'AQ-WEST', 'AQUASTAR', 1),
('AQ-W-004', 'Suburban Mart', 'AQW004', 'active', '400 Suburb Ave, Suburban', '+1234570004', 'Lisa Suburb', 40.8300, -73.8700, 'AQ-WEST', 'AQUASTAR', 1),
('AQ-W-005', 'Residential Store', 'AQW005', 'active', '500 Home St, Residential', '+1234570005', 'David Home', 40.8400, -73.8600, 'AQ-WEST', 'AQUASTAR', 1);

-- AquaStar Central Region Shops (50 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('AQ-C-001', 'Central Market', 'AQC001', 'active', '100 Center St, Central', '+1234571001', 'John Center', 40.8500, -73.8500, 'AQ-CENTRAL', 'AQUASTAR', 1),
('AQ-C-002', 'Downtown Store', 'AQC002', 'active', '200 Main Ave, Downtown', '+1234571002', 'Sarah Main', 40.8600, -73.8400, 'AQ-CENTRAL', 'AQUASTAR', 1),
('AQ-C-003', 'CBD Shop', 'AQC003', 'active', '300 Business St, CBD', '+1234571003', 'Mike Business', 40.8700, -73.8300, 'AQ-CENTRAL', 'AQUASTAR', 1),
('AQ-C-004', 'Plaza Mart', 'AQC004', 'active', '400 Plaza Ave, Plaza', '+1234571004', 'Lisa Plaza', 40.8800, -73.8200, 'AQ-CENTRAL', 'AQUASTAR', 1),
('AQ-C-005', 'Square Store', 'AQC005', 'active', '500 Square St, Square', '+1234571005', 'David Square', 40.8900, -73.8100, 'AQ-CENTRAL', 'AQUASTAR', 1);

-- FreshFood Metro Area Shops (30 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('FF-M-001', 'Metro Fresh Market', 'FFM001', 'active', '100 Metro St, Metro', '+1234572001', 'Tom Metro', 40.9000, -73.8000, 'FF-METRO', 'FRESHFOOD', 1),
('FF-M-002', 'Urban Fresh Store', 'FFM002', 'active', '200 Urban Ave, Urban', '+1234572002', 'Rachel Urban', 40.9100, -73.7900, 'FF-METRO', 'FRESHFOOD', 1),
('FF-M-003', 'City Fresh Shop', 'FFM003', 'active', '300 City St, City', '+1234572003', 'Chris City', 40.9200, -73.7800, 'FF-METRO', 'FRESHFOOD', 1),
('FF-M-004', 'Downtown Fresh Mart', 'FFM004', 'active', '400 Downtown Ave, Downtown', '+1234572004', 'Amy Downtown', 40.9300, -73.7700, 'FF-METRO', 'FRESHFOOD', 1),
('FF-M-005', 'Central Fresh Store', 'FFM005', 'active', '500 Central St, Central', '+1234572005', 'Kevin Central', 40.9400, -73.7600, 'FF-METRO', 'FRESHFOOD', 1);

-- FreshFood Suburban Zone Shops (30 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('FF-S-001', 'Suburban Fresh Market', 'FFS001', 'active', '100 Suburb St, Suburban', '+1234573001', 'Nicole Suburb', 40.9500, -73.7500, 'FF-SUBURB', 'FRESHFOOD', 1),
('FF-S-002', 'Residential Fresh Store', 'FFS002', 'active', '200 Residential Ave, Residential', '+1234573002', 'Brian Residential', 40.9600, -73.7400, 'FF-SUBURB', 'FRESHFOOD', 1),
('FF-S-003', 'Family Fresh Shop', 'FFS003', 'active', '300 Family St, Family', '+1234573003', 'Stephanie Family', 40.9700, -73.7300, 'FF-SUBURB', 'FRESHFOOD', 1),
('FF-S-004', 'Neighborhood Fresh Mart', 'FFS004', 'active', '400 Neighborhood Ave, Neighborhood', '+1234573004', 'Daniel Neighborhood', 40.9800, -73.7200, 'FF-SUBURB', 'FRESHFOOD', 1),
('FF-S-005', 'Community Fresh Store', 'FFS005', 'active', '500 Community St, Community', '+1234573005', 'Jessica Community', 40.9900, -73.7100, 'FF-SUBURB', 'FRESHFOOD', 1);

-- FreshFood Rural Territory Shops (30 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('FF-R-001', 'Rural Fresh Market', 'FFR001', 'active', '100 Rural St, Rural', '+1234574001', 'Mark Rural', 41.0000, -73.7000, 'FF-RURAL', 'FRESHFOOD', 1),
('FF-R-002', 'Farm Fresh Store', 'FFR002', 'active', '200 Farm Ave, Farm', '+1234574002', 'Laura Farm', 41.0100, -73.6900, 'FF-RURAL', 'FRESHFOOD', 1),
('FF-R-003', 'Country Fresh Shop', 'FFR003', 'active', '300 Country St, Country', '+1234574003', 'Steven Country', 41.0200, -73.6800, 'FF-RURAL', 'FRESHFOOD', 1),
('FF-R-004', 'Village Fresh Mart', 'FFR004', 'active', '400 Village Ave, Village', '+1234574004', 'Karen Village', 41.0300, -73.6700, 'FF-RURAL', 'FRESHFOOD', 1),
('FF-R-005', 'Township Fresh Store', 'FFR005', 'active', '500 Township St, Township', '+1234574005', 'Ryan Township', 41.0400, -73.6600, 'FF-RURAL', 'FRESHFOOD', 1);

-- Metro Downtown District Shops (25 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('MR-D-001', 'Downtown Metro Market', 'MRD001', 'active', '100 Downtown St, Downtown', '+1234575001', 'Amanda Downtown', 41.0500, -73.6500, 'MR-DOWNTOWN', 'METRO', 1),
('MR-D-002', 'CBD Metro Store', 'MRD002', 'active', '200 CBD Ave, CBD', '+1234575002', 'Jason CBD', 41.0600, -73.6400, 'MR-DOWNTOWN', 'METRO', 1),
('MR-D-003', 'Financial Metro Shop', 'MRD003', 'active', '300 Financial St, Financial', '+1234575003', 'Melissa Financial', 41.0700, -73.6300, 'MR-DOWNTOWN', 'METRO', 1),
('MR-D-004', 'Business Metro Mart', 'MRD004', 'active', '400 Business Ave, Business', '+1234575004', 'Andrew Business', 41.0800, -73.6200, 'MR-DOWNTOWN', 'METRO', 1),
('MR-D-005', 'Corporate Metro Store', 'MRD005', 'active', '500 Corporate St, Corporate', '+1234575005', 'Samantha Corporate', 41.0900, -73.6100, 'MR-DOWNTOWN', 'METRO', 1);

-- Metro Uptown Area Shops (25 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('MR-U-001', 'Uptown Metro Market', 'MRU001', 'active', '100 Uptown St, Uptown', '+1234576001', 'Nathan Uptown', 41.1000, -73.6000, 'MR-UPTOWN', 'METRO', 1),
('MR-U-002', 'Residential Metro Store', 'MRU002', 'active', '200 Residential Ave, Residential', '+1234576002', 'Olivia Residential', 41.1100, -73.5900, 'MR-UPTOWN', 'METRO', 1),
('MR-U-003', 'Suburban Metro Shop', 'MRU003', 'active', '300 Suburban St, Suburban', '+1234576003', 'Ethan Suburban', 41.1200, -73.5800, 'MR-UPTOWN', 'METRO', 1),
('MR-U-004', 'Family Metro Mart', 'MRU004', 'active', '400 Family Ave, Family', '+1234576004', 'Isabella Family', 41.1300, -73.5700, 'MR-UPTOWN', 'METRO', 1),
('MR-U-005', 'Community Metro Store', 'MRU005', 'active', '500 Community St, Community', '+1234576005', 'Mason Community', 41.1400, -73.5600, 'MR-UPTOWN', 'METRO', 1);

-- Metro Midtown Region Shops (25 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('MR-M-001', 'Midtown Metro Market', 'MRM001', 'active', '100 Midtown St, Midtown', '+1234577001', 'Sophia Midtown', 41.1500, -73.5500, 'MR-MIDTOWN', 'METRO', 1),
('MR-M-002', 'Central Metro Store', 'MRM002', 'active', '200 Central Ave, Central', '+1234577002', 'Logan Central', 41.1600, -73.5400, 'MR-MIDTOWN', 'METRO', 1),
('MR-M-003', 'Mixed Metro Shop', 'MRM003', 'active', '300 Mixed St, Mixed', '+1234577003', 'Emma Mixed', 41.1700, -73.5300, 'MR-MIDTOWN', 'METRO', 1),
('MR-M-004', 'Transition Metro Mart', 'MRM004', 'active', '400 Transition Ave, Transition', '+1234577004', 'Noah Transition', 41.1800, -73.5200, 'MR-MIDTOWN', 'METRO', 1),
('MR-M-005', 'Bridge Metro Store', 'MRM005', 'active', '500 Bridge St, Bridge', '+1234577005', 'Ava Bridge', 41.1900, -73.5100, 'MR-MIDTOWN', 'METRO', 1);

-- Coastal Beachfront Zone Shops (20 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('CT-B-001', 'Beachfront Coastal Market', 'CTB001', 'active', '100 Beach St, Beachfront', '+1234578001', 'Liam Beach', 41.2000, -73.5000, 'CT-BEACH', 'COASTAL', 1),
('CT-B-002', 'Seaside Coastal Store', 'CTB002', 'active', '200 Seaside Ave, Seaside', '+1234578002', 'Charlotte Seaside', 41.2100, -73.4900, 'CT-BEACH', 'COASTAL', 1),
('CT-B-003', 'Oceanfront Coastal Shop', 'CTB003', 'active', '300 Oceanfront St, Oceanfront', '+1234578003', 'William Oceanfront', 41.2200, -73.4800, 'CT-BEACH', 'COASTAL', 1),
('CT-B-004', 'Shoreline Coastal Mart', 'CTB004', 'active', '400 Shoreline Ave, Shoreline', '+1234578004', 'James Shoreline', 41.2300, -73.4700, 'CT-BEACH', 'COASTAL', 1),
('CT-B-005', 'Waterfront Coastal Store', 'CTB005', 'active', '500 Waterfront St, Waterfront', '+1234578005', 'Harper Waterfront', 41.2400, -73.4600, 'CT-BEACH', 'COASTAL', 1);

-- Coastal Port District Shops (20 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('CT-P-001', 'Port Coastal Market', 'CTP001', 'active', '100 Port St, Port', '+1234579001', 'Benjamin Port', 41.2500, -73.4500, 'CT-PORT', 'COASTAL', 1),
('CT-P-002', 'Harbor Coastal Store', 'CTP002', 'active', '200 Harbor Ave, Harbor', '+1234579002', 'Evelyn Harbor', 41.2600, -73.4400, 'CT-PORT', 'COASTAL', 1),
('CT-P-003', 'Dock Coastal Shop', 'CTP003', 'active', '300 Dock St, Dock', '+1234579003', 'Henry Dock', 41.2700, -73.4300, 'CT-PORT', 'COASTAL', 1),
('CT-P-004', 'Marina Coastal Mart', 'CTP004', 'active', '400 Marina Ave, Marina', '+1234579004', 'Amelia Marina', 41.2800, -73.4200, 'CT-PORT', 'COASTAL', 1),
('CT-P-005', 'Wharf Coastal Store', 'CTP005', 'active', '500 Wharf St, Wharf', '+1234579005', 'Alexander Wharf', 41.2900, -73.4100, 'CT-PORT', 'COASTAL', 1);

-- Urban City Center Shops (30 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('UR-C1-001', 'City Center Urban Market', 'URC1001', 'active', '100 City Center St, City Center', '+1234580001', 'Michael City Center', 41.3000, -73.4000, 'UR-CITY1', 'URBAN', 1),
('UR-C1-002', 'Downtown Urban Store', 'URC1002', 'active', '200 Downtown Ave, Downtown', '+1234580002', 'Abigail Downtown', 41.3100, -73.3900, 'UR-CITY1', 'URBAN', 1),
('UR-C1-003', 'CBD Urban Shop', 'URC1003', 'active', '300 CBD St, CBD', '+1234580003', 'Daniel CBD', 41.3200, -73.3800, 'UR-CITY1', 'URBAN', 1),
('UR-C1-004', 'Financial Urban Mart', 'URC1004', 'active', '400 Financial Ave, Financial', '+1234580004', 'Sofia Financial', 41.3300, -73.3700, 'UR-CITY1', 'URBAN', 1),
('UR-C1-005', 'Business Urban Store', 'URC1005', 'active', '500 Business St, Business', '+1234580005', 'Matthew Business', 41.3400, -73.3600, 'UR-CITY1', 'URBAN', 1);

-- Urban Secondary City Shops (30 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('UR-C2-001', 'Secondary City Urban Market', 'URC2001', 'active', '100 Secondary St, Secondary', '+1234581001', 'Emily Secondary', 41.3500, -73.3500, 'UR-CITY2', 'URBAN', 1),
('UR-C2-002', 'Suburban Urban Store', 'URC2002', 'active', '200 Suburban Ave, Suburban', '+1234581002', 'David Suburban', 41.3600, -73.3400, 'UR-CITY2', 'URBAN', 1),
('UR-C2-003', 'Residential Urban Shop', 'URC2003', 'active', '300 Residential St, Residential', '+1234581003', 'Elizabeth Residential', 41.3700, -73.3300, 'UR-CITY2', 'URBAN', 1),
('UR-C2-004', 'Family Urban Mart', 'URC2004', 'active', '400 Family Ave, Family', '+1234581004', 'Jackson Family', 41.3800, -73.3200, 'UR-CITY2', 'URBAN', 1),
('UR-C2-005', 'Community Urban Store', 'URC2005', 'active', '500 Community St, Community', '+1234581005', 'Avery Community', 41.3900, -73.3100, 'UR-CITY2', 'URBAN', 1);

-- Urban Industrial Zone Shops (30 shops)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
('UR-I-001', 'Industrial Urban Market', 'URI001', 'active', '100 Industrial St, Industrial', '+1234582001', 'Sebastian Industrial', 41.4000, -73.3000, 'UR-INDUSTRIAL', 'URBAN', 1),
('UR-I-002', 'Manufacturing Urban Store', 'URI002', 'active', '200 Manufacturing Ave, Manufacturing', '+1234582002', 'Ella Manufacturing', 41.4100, -73.2900, 'UR-INDUSTRIAL', 'URBAN', 1),
('UR-I-003', 'Factory Urban Shop', 'URI003', 'active', '300 Factory St, Factory', '+1234582003', 'Carter Factory', 41.4200, -73.2800, 'UR-INDUSTRIAL', 'URBAN', 1),
('UR-I-004', 'Warehouse Urban Mart', 'URI004', 'active', '400 Warehouse Ave, Warehouse', '+1234582004', 'Madison Warehouse', 41.4300, -73.2700, 'UR-INDUSTRIAL', 'URBAN', 1),
('UR-I-005', 'Distribution Urban Store', 'URI005', 'active', '500 Distribution St, Distribution', '+1234582005', 'Wyatt Distribution', 41.4400, -73.2600, 'UR-INDUSTRIAL', 'URBAN', 1);
