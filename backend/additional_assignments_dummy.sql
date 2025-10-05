-- Sales Executive Assignments for All Additional Shops
-- This script creates assignments for all sales executives across all territories

-- AquaStar South Region Assignments (James Anderson ID: 9, Jennifer Taylor ID: 10)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- James Anderson gets first 25 shops in AQ-SOUTH
(9, 'AQ-S-001', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(9, 'AQ-S-002', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(9, 'AQ-S-003', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(9, 'AQ-S-004', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(9, 'AQ-S-005', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1);

-- Jennifer Taylor gets remaining shops in AQ-SOUTH (when we add more)
-- (10, 'AQ-S-026', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
-- (10, 'AQ-S-027', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1);

-- AquaStar East Region Assignments (Robert Martinez ID: 11, Linda Rodriguez ID: 12)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Robert Martinez gets first 25 shops in AQ-EAST
(11, 'AQ-E-001', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
(11, 'AQ-E-002', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
(11, 'AQ-E-003', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
(11, 'AQ-E-004', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
(11, 'AQ-E-005', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1);

-- Linda Rodriguez gets remaining shops in AQ-EAST (when we add more)
-- (12, 'AQ-E-026', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
-- (12, 'AQ-E-027', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1);

-- AquaStar West Region Assignments (William Lee ID: 13, Patricia White ID: 14)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- William Lee gets first 25 shops in AQ-WEST
(13, 'AQ-W-001', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1),
(13, 'AQ-W-002', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1),
(13, 'AQ-W-003', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1),
(13, 'AQ-W-004', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1),
(13, 'AQ-W-005', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1);

-- Patricia White gets remaining shops in AQ-WEST (when we add more)
-- (14, 'AQ-W-026', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1),
-- (14, 'AQ-W-027', 'AQ-WEST', 'AQUASTAR', '2024-01-01', 'active', 1);

-- AquaStar Central Region Assignments (Michael Harris ID: 15, Susan Clark ID: 16)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Michael Harris gets first 25 shops in AQ-CENTRAL
(15, 'AQ-C-001', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1),
(15, 'AQ-C-002', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1),
(15, 'AQ-C-003', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1),
(15, 'AQ-C-004', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1),
(15, 'AQ-C-005', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1);

-- Susan Clark gets remaining shops in AQ-CENTRAL (when we add more)
-- (16, 'AQ-C-026', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1),
-- (16, 'AQ-C-027', 'AQ-CENTRAL', 'AQUASTAR', '2024-01-01', 'active', 1);

-- FreshFood Metro Area Assignments (Kevin Murphy ID: 17, Nicole Adams ID: 18)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Kevin Murphy gets first 15 shops in FF-METRO
(17, 'FF-M-001', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
(17, 'FF-M-002', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
(17, 'FF-M-003', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
(17, 'FF-M-004', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
(17, 'FF-M-005', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1);

-- Nicole Adams gets remaining shops in FF-METRO (when we add more)
-- (18, 'FF-M-016', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
-- (18, 'FF-M-017', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1);

-- FreshFood Suburban Zone Assignments (Brian Wilson ID: 19, Stephanie Hall ID: 20)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Brian Wilson gets first 15 shops in FF-SUBURB
(19, 'FF-S-001', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
(19, 'FF-S-002', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
(19, 'FF-S-003', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
(19, 'FF-S-004', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
(19, 'FF-S-005', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1);

-- Stephanie Hall gets remaining shops in FF-SUBURB (when we add more)
-- (20, 'FF-S-016', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
-- (20, 'FF-S-017', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1);

-- FreshFood Rural Territory Assignments (Daniel Young ID: 21, Jessica King ID: 22)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Daniel Young gets first 15 shops in FF-RURAL
(21, 'FF-R-001', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
(21, 'FF-R-002', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
(21, 'FF-R-003', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
(21, 'FF-R-004', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
(21, 'FF-R-005', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1);

-- Jessica King gets remaining shops in FF-RURAL (when we add more)
-- (22, 'FF-R-016', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
-- (22, 'FF-R-017', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1);

-- Metro Downtown District Assignments (Ryan Miller ID: 23, Amanda Garcia ID: 24)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Ryan Miller gets first 12 shops in MR-DOWNTOWN
(23, 'MR-D-001', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
(23, 'MR-D-002', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
(23, 'MR-D-003', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
(23, 'MR-D-004', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
(23, 'MR-D-005', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1);

-- Amanda Garcia gets remaining shops in MR-DOWNTOWN (when we add more)
-- (24, 'MR-D-013', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
-- (24, 'MR-D-014', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1);

-- Metro Uptown Area Assignments (Jason Rodriguez ID: 25, Melissa Lee ID: 26)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Jason Rodriguez gets first 12 shops in MR-UPTOWN
(25, 'MR-U-001', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
(25, 'MR-U-002', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
(25, 'MR-U-003', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
(25, 'MR-U-004', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
(25, 'MR-U-005', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1);

-- Melissa Lee gets remaining shops in MR-UPTOWN (when we add more)
-- (26, 'MR-U-013', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
-- (26, 'MR-U-014', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1);

-- Metro Midtown Region Assignments (Andrew White ID: 27, Samantha Harris ID: 28)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Andrew White gets first 12 shops in MR-MIDTOWN
(27, 'MR-M-001', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
(27, 'MR-M-002', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
(27, 'MR-M-003', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
(27, 'MR-M-004', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
(27, 'MR-M-005', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1);

-- Samantha Harris gets remaining shops in MR-MIDTOWN (when we add more)
-- (28, 'MR-M-013', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
-- (28, 'MR-M-014', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1);

-- Coastal Beachfront Zone Assignments (Heather Martinez ID: 29, Tyler Clark ID: 30)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Heather Martinez gets first 10 shops in CT-BEACH
(29, 'CT-B-001', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1),
(29, 'CT-B-002', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1),
(29, 'CT-B-003', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1),
(29, 'CT-B-004', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1),
(29, 'CT-B-005', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1);

-- Tyler Clark gets remaining shops in CT-BEACH (when we add more)
-- (30, 'CT-B-011', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1),
-- (30, 'CT-B-012', 'CT-BEACH', 'COASTAL', '2024-01-01', 'active', 1);

-- Coastal Port District Assignments (Vanessa Lewis ID: 31, Brandon Walker ID: 32)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Vanessa Lewis gets first 10 shops in CT-PORT
(31, 'CT-P-001', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1),
(31, 'CT-P-002', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1),
(31, 'CT-P-003', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1),
(31, 'CT-P-004', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1),
(31, 'CT-P-005', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1);

-- Brandon Walker gets remaining shops in CT-PORT (when we add more)
-- (32, 'CT-P-011', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1),
-- (32, 'CT-P-012', 'CT-PORT', 'COASTAL', '2024-01-01', 'active', 1);

-- Urban City Center Assignments (Rachel Wright ID: 33, Justin Lopez ID: 34)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Rachel Wright gets first 15 shops in UR-CITY1
(33, 'UR-C1-001', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1),
(33, 'UR-C1-002', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1),
(33, 'UR-C1-003', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1),
(33, 'UR-C1-004', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1),
(33, 'UR-C1-005', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1);

-- Justin Lopez gets remaining shops in UR-CITY1 (when we add more)
-- (34, 'UR-C1-016', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1),
-- (34, 'UR-C1-017', 'UR-CITY1', 'URBAN', '2024-01-01', 'active', 1);

-- Urban Secondary City Assignments (Megan Hill ID: 35, Nathan Scott ID: 36)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Megan Hill gets first 15 shops in UR-CITY2
(35, 'UR-C2-001', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1),
(35, 'UR-C2-002', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1),
(35, 'UR-C2-003', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1),
(35, 'UR-C2-004', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1),
(35, 'UR-C2-005', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1);

-- Nathan Scott gets remaining shops in UR-CITY2 (when we add more)
-- (36, 'UR-C2-016', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1),
-- (36, 'UR-C2-017', 'UR-CITY2', 'URBAN', '2024-01-01', 'active', 1);

-- Urban Industrial Zone Assignments (Olivia Green ID: 37, Ethan Adams ID: 38)
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Olivia Green gets first 15 shops in UR-INDUSTRIAL
(37, 'UR-I-001', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1),
(37, 'UR-I-002', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1),
(37, 'UR-I-003', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1),
(37, 'UR-I-004', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1),
(37, 'UR-I-005', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1);

-- Ethan Adams gets remaining shops in UR-INDUSTRIAL (when we add more)
-- (38, 'UR-I-016', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1),
-- (38, 'UR-I-017', 'UR-INDUSTRIAL', 'URBAN', '2024-01-01', 'active', 1);
