-- Sales Executive Assignments for Simplified Structure
-- Each sales executive gets 2 shops (12 shops per client ÷ 6 sales executives = 2 shops each)

-- AquaStar Assignments
INSERT INTO sales_executive_assignments (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by) VALUES
-- Alex Thompson (ID: 5) - AQ-NORTH Territory
(5, 'AQ-N-001', 'AQ-NORTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(5, 'AQ-N-002', 'AQ-NORTH', 'AQUASTAR', '2024-01-01', 'active', 1),

-- Maria Garcia (ID: 6) - AQ-NORTH Territory
(6, 'AQ-N-003', 'AQ-NORTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(6, 'AQ-N-004', 'AQ-NORTH', 'AQUASTAR', '2024-01-01', 'active', 1),

-- James Anderson (ID: 7) - AQ-SOUTH Territory
(7, 'AQ-S-001', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(7, 'AQ-S-002', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),

-- Jennifer Taylor (ID: 8) - AQ-SOUTH Territory
(8, 'AQ-S-003', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),
(8, 'AQ-S-004', 'AQ-SOUTH', 'AQUASTAR', '2024-01-01', 'active', 1),

-- Robert Martinez (ID: 9) - AQ-EAST Territory
(9, 'AQ-E-001', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
(9, 'AQ-E-002', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),

-- Linda Rodriguez (ID: 10) - AQ-EAST Territory
(10, 'AQ-E-003', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),
(10, 'AQ-E-004', 'AQ-EAST', 'AQUASTAR', '2024-01-01', 'active', 1),

-- FreshFood Assignments
-- Kevin Murphy (ID: 11) - FF-METRO Territory
(11, 'FF-M-001', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
(11, 'FF-M-002', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),

-- Nicole Adams (ID: 12) - FF-METRO Territory
(12, 'FF-M-003', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),
(12, 'FF-M-004', 'FF-METRO', 'FRESHFOOD', '2024-01-01', 'active', 1),

-- Brian Wilson (ID: 13) - FF-SUBURB Territory
(13, 'FF-S-001', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
(13, 'FF-S-002', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),

-- Stephanie Hall (ID: 14) - FF-SUBURB Territory
(14, 'FF-S-003', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),
(14, 'FF-S-004', 'FF-SUBURB', 'FRESHFOOD', '2024-01-01', 'active', 1),

-- Daniel Young (ID: 15) - FF-RURAL Territory
(15, 'FF-R-001', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
(15, 'FF-R-002', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),

-- Jessica King (ID: 16) - FF-RURAL Territory
(16, 'FF-R-003', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),
(16, 'FF-R-004', 'FF-RURAL', 'FRESHFOOD', '2024-01-01', 'active', 1),

-- Metro Assignments
-- Ryan Miller (ID: 17) - MR-DOWNTOWN Territory
(17, 'MR-D-001', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
(17, 'MR-D-002', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),

-- Amanda Garcia (ID: 18) - MR-DOWNTOWN Territory
(18, 'MR-D-003', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),
(18, 'MR-D-004', 'MR-DOWNTOWN', 'METRO', '2024-01-01', 'active', 1),

-- Jason Rodriguez (ID: 19) - MR-UPTOWN Territory
(19, 'MR-U-001', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
(19, 'MR-U-002', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),

-- Melissa Lee (ID: 20) - MR-UPTOWN Territory
(20, 'MR-U-003', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),
(20, 'MR-U-004', 'MR-UPTOWN', 'METRO', '2024-01-01', 'active', 1),

-- Andrew White (ID: 21) - MR-MIDTOWN Territory
(21, 'MR-M-001', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
(21, 'MR-M-002', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),

-- Samantha Harris (ID: 22) - MR-MIDTOWN Territory
(22, 'MR-M-003', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1),
(22, 'MR-M-004', 'MR-MIDTOWN', 'METRO', '2024-01-01', 'active', 1);
