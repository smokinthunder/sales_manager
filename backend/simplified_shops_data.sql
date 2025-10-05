-- Shops Data for Simplified Structure
-- 12 shops per client, divided among 6 sales executives (2 shops each)

-- AquaStar Shops (12 total - 4 shops per territory, 2 shops per sales executive)
INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, latitude, longitude, territory_id, tenant_id, created_by) VALUES
-- AQ-NORTH Territory (Sarah Johnson - Area Manager)
-- Alex Thompson (Sales Executive) - 2 shops
('AQ-N-001', 'Downtown Convenience Store', 'AQN001', 'active', '123 Main St, Downtown', '+1234567001', 'John Manager', 40.7128, -74.0060, 'AQ-NORTH', 'AQUASTAR', 1),
('AQ-N-002', 'Central Market', 'AQN002', 'active', '456 Oak Ave, Central', '+1234567002', 'Sarah Owner', 40.7589, -73.9851, 'AQ-NORTH', 'AQUASTAR', 1),

-- Maria Garcia (Sales Executive) - 2 shops
('AQ-N-003', 'Metro Supermarket', 'AQN003', 'active', '789 Pine St, Metro', '+1234567003', 'Mike Director', 40.7505, -73.9934, 'AQ-NORTH', 'AQUASTAR', 1),
('AQ-N-004', 'City Corner Store', 'AQN004', 'active', '321 Elm St, City', '+1234567004', 'Lisa Manager', 40.7614, -73.9776, 'AQ-NORTH', 'AQUASTAR', 1),

-- AQ-SOUTH Territory (Mike Wilson - Area Manager)
-- James Anderson (Sales Executive) - 2 shops
('AQ-S-001', 'Southside Market', 'AQS001', 'active', '100 South St, Southside', '+1234568001', 'John South', 40.7000, -74.0000, 'AQ-SOUTH', 'AQUASTAR', 1),
('AQ-S-002', 'Coastal Store', 'AQS002', 'active', '200 Beach Ave, Coastal', '+1234568002', 'Sarah Beach', 40.7100, -73.9900, 'AQ-SOUTH', 'AQUASTAR', 1),

-- Jennifer Taylor (Sales Executive) - 2 shops
('AQ-S-003', 'Harbor Shop', 'AQS003', 'active', '300 Port St, Harbor', '+1234568003', 'Mike Port', 40.7200, -73.9800, 'AQ-SOUTH', 'AQUASTAR', 1),
('AQ-S-004', 'Marina Mart', 'AQS004', 'active', '400 Dock Ave, Marina', '+1234568004', 'Lisa Dock', 40.7300, -73.9700, 'AQ-SOUTH', 'AQUASTAR', 1),

-- AQ-EAST Territory (Lisa Brown - Area Manager)
-- Robert Martinez (Sales Executive) - 2 shops
('AQ-E-001', 'Eastside Market', 'AQE001', 'active', '100 East St, Eastside', '+1234569001', 'John East', 40.7500, -73.9500, 'AQ-EAST', 'AQUASTAR', 1),
('AQ-E-002', 'Industrial Store', 'AQE002', 'active', '200 Factory Ave, Industrial', '+1234569002', 'Sarah Factory', 40.7600, -73.9400, 'AQ-EAST', 'AQUASTAR', 1),

-- Linda Rodriguez (Sales Executive) - 2 shops
('AQ-E-003', 'Business Shop', 'AQE003', 'active', '300 Office St, Business', '+1234569003', 'Mike Office', 40.7700, -73.9300, 'AQ-EAST', 'AQUASTAR', 1),
('AQ-E-004', 'Corporate Mart', 'AQE004', 'active', '400 Tower Ave, Corporate', '+1234569004', 'Lisa Tower', 40.7800, -73.9200, 'AQ-EAST', 'AQUASTAR', 1),

-- FreshFood Shops (12 total - 4 shops per territory, 2 shops per sales executive)
-- FF-METRO Territory (Rachel Green - Area Manager)
-- Kevin Murphy (Sales Executive) - 2 shops
('FF-M-001', 'Metro Fresh Market', 'FFM001', 'active', '100 Metro St, Metro', '+1234572001', 'Tom Metro', 40.9000, -73.8000, 'FF-METRO', 'FRESHFOOD', 1),
('FF-M-002', 'Urban Fresh Store', 'FFM002', 'active', '200 Urban Ave, Urban', '+1234572002', 'Rachel Urban', 40.9100, -73.7900, 'FF-METRO', 'FRESHFOOD', 1),

-- Nicole Adams (Sales Executive) - 2 shops
('FF-M-003', 'City Fresh Shop', 'FFM003', 'active', '300 City St, City', '+1234572003', 'Chris City', 40.9200, -73.7800, 'FF-METRO', 'FRESHFOOD', 1),
('FF-M-004', 'Downtown Fresh Mart', 'FFM004', 'active', '400 Downtown Ave, Downtown', '+1234572004', 'Amy Downtown', 40.9300, -73.7700, 'FF-METRO', 'FRESHFOOD', 1),

-- FF-SUBURB Territory (Chris Evans - Area Manager)
-- Brian Wilson (Sales Executive) - 2 shops
('FF-S-001', 'Suburban Fresh Market', 'FFS001', 'active', '100 Suburb St, Suburban', '+1234573001', 'Nicole Suburb', 40.9500, -73.7500, 'FF-SUBURB', 'FRESHFOOD', 1),
('FF-S-002', 'Residential Fresh Store', 'FFS002', 'active', '200 Residential Ave, Residential', '+1234573002', 'Brian Residential', 40.9600, -73.7400, 'FF-SUBURB', 'FRESHFOOD', 1),

-- Stephanie Hall (Sales Executive) - 2 shops
('FF-S-003', 'Family Fresh Shop', 'FFS003', 'active', '300 Family St, Family', '+1234573003', 'Stephanie Family', 40.9700, -73.7300, 'FF-SUBURB', 'FRESHFOOD', 1),
('FF-S-004', 'Neighborhood Fresh Mart', 'FFS004', 'active', '400 Neighborhood Ave, Neighborhood', '+1234573004', 'Daniel Neighborhood', 40.9800, -73.7200, 'FF-SUBURB', 'FRESHFOOD', 1),

-- FF-RURAL Territory (Amy Stone - Area Manager)
-- Daniel Young (Sales Executive) - 2 shops
('FF-R-001', 'Rural Fresh Market', 'FFR001', 'active', '100 Rural St, Rural', '+1234574001', 'Mark Rural', 41.0000, -73.7000, 'FF-RURAL', 'FRESHFOOD', 1),
('FF-R-002', 'Farm Fresh Store', 'FFR002', 'active', '200 Farm Ave, Farm', '+1234574002', 'Laura Farm', 41.0100, -73.6900, 'FF-RURAL', 'FRESHFOOD', 1),

-- Jessica King (Sales Executive) - 2 shops
('FF-R-003', 'Country Fresh Shop', 'FFR003', 'active', '300 Country St, Country', '+1234574003', 'Steven Country', 41.0200, -73.6800, 'FF-RURAL', 'FRESHFOOD', 1),
('FF-R-004', 'Village Fresh Mart', 'FFR004', 'active', '400 Village Ave, Village', '+1234574004', 'Karen Village', 41.0300, -73.6700, 'FF-RURAL', 'FRESHFOOD', 1),

-- Metro Shops (12 total - 4 shops per territory, 2 shops per sales executive)
-- MR-DOWNTOWN Territory (Laura Davis - Area Manager)
-- Ryan Miller (Sales Executive) - 2 shops
('MR-D-001', 'Downtown Metro Market', 'MRD001', 'active', '100 Downtown St, Downtown', '+1234575001', 'Amanda Downtown', 41.0500, -73.6500, 'MR-DOWNTOWN', 'METRO', 1),
('MR-D-002', 'CBD Metro Store', 'MRD002', 'active', '200 CBD Ave, CBD', '+1234575002', 'Jason CBD', 41.0600, -73.6400, 'MR-DOWNTOWN', 'METRO', 1),

-- Amanda Garcia (Sales Executive) - 2 shops
('MR-D-003', 'Financial Metro Shop', 'MRD003', 'active', '300 Financial St, Financial', '+1234575003', 'Melissa Financial', 41.0700, -73.6300, 'MR-DOWNTOWN', 'METRO', 1),
('MR-D-004', 'Business Metro Mart', 'MRD004', 'active', '400 Business Ave, Business', '+1234575004', 'Andrew Business', 41.0800, -73.6200, 'MR-DOWNTOWN', 'METRO', 1),

-- MR-UPTOWN Territory (Steven Wilson - Area Manager)
-- Jason Rodriguez (Sales Executive) - 2 shops
('MR-U-001', 'Uptown Metro Market', 'MRU001', 'active', '100 Uptown St, Uptown', '+1234576001', 'Nathan Uptown', 41.1000, -73.6000, 'MR-UPTOWN', 'METRO', 1),
('MR-U-002', 'Residential Metro Store', 'MRU002', 'active', '200 Residential Ave, Residential', '+1234576002', 'Olivia Residential', 41.1100, -73.5900, 'MR-UPTOWN', 'METRO', 1),

-- Melissa Lee (Sales Executive) - 2 shops
('MR-U-003', 'Suburban Metro Shop', 'MRU003', 'active', '300 Suburban St, Suburban', '+1234576003', 'Ethan Suburban', 41.1200, -73.5800, 'MR-UPTOWN', 'METRO', 1),
('MR-U-004', 'Family Metro Mart', 'MRU004', 'active', '400 Family Ave, Family', '+1234576004', 'Isabella Family', 41.1300, -73.5700, 'MR-UPTOWN', 'METRO', 1),

-- MR-MIDTOWN Territory (Karen Brown - Area Manager)
-- Andrew White (Sales Executive) - 2 shops
('MR-M-001', 'Midtown Metro Market', 'MRM001', 'active', '100 Midtown St, Midtown', '+1234577001', 'Sophia Midtown', 41.1500, -73.5500, 'MR-MIDTOWN', 'METRO', 1),
('MR-M-002', 'Central Metro Store', 'MRM002', 'active', '200 Central Ave, Central', '+1234577002', 'Logan Central', 41.1600, -73.5400, 'MR-MIDTOWN', 'METRO', 1),

-- Samantha Harris (Sales Executive) - 2 shops
('MR-M-003', 'Mixed Metro Shop', 'MRM003', 'active', '300 Mixed St, Mixed', '+1234577003', 'Emma Mixed', 41.1700, -73.5300, 'MR-MIDTOWN', 'METRO', 1),
('MR-M-004', 'Transition Metro Mart', 'MRM004', 'active', '400 Transition Ave, Transition', '+1234577004', 'Noah Transition', 41.1800, -73.5200, 'MR-MIDTOWN', 'METRO', 1);

