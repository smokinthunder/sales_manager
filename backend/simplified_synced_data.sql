-- Synced Data for Analytics Testing (Simplified Structure)
-- This creates realistic sales data for comprehensive analytics testing

-- Insert synced shop data (links to shops)
INSERT INTO synced_shop_data (shop_id, shop_name, tenant_id, current_payment, upcoming_payment, overdue_payment, sync_date, sync_status, created_by) VALUES
-- AquaStar shops
('AQ-N-001', 'Downtown Convenience Store', 'AQUASTAR', 1500.00, 800.00, 200.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-N-002', 'Central Market', 'AQUASTAR', 2200.00, 1200.00, 150.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-N-003', 'Metro Supermarket', 'AQUASTAR', 1800.00, 900.00, 300.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-N-004', 'City Corner Store', 'AQUASTAR', 1200.00, 600.00, 100.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-S-001', 'Southside Market', 'AQUASTAR', 1600.00, 700.00, 250.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-S-002', 'Coastal Store', 'AQUASTAR', 1900.00, 1000.00, 180.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-E-001', 'Eastside Market', 'AQUASTAR', 1400.00, 800.00, 120.00, '2024-01-15 10:00:00', 'completed', 1),
('AQ-E-002', 'Industrial Store', 'AQUASTAR', 2100.00, 1100.00, 200.00, '2024-01-15 10:00:00', 'completed', 1),

-- FreshFood shops
('FF-M-001', 'Metro Fresh Market', 'FRESHFOOD', 1300.00, 700.00, 150.00, '2024-01-15 10:00:00', 'completed', 1),
('FF-M-002', 'Urban Fresh Store', 'FRESHFOOD', 1700.00, 900.00, 100.00, '2024-01-15 10:00:00', 'completed', 1),
('FF-S-001', 'Suburban Fresh Market', 'FRESHFOOD', 1100.00, 600.00, 80.00, '2024-01-15 10:00:00', 'completed', 1),
('FF-S-002', 'Residential Fresh Store', 'FRESHFOOD', 1500.00, 800.00, 120.00, '2024-01-15 10:00:00', 'completed', 1),
('FF-R-001', 'Rural Fresh Market', 'FRESHFOOD', 900.00, 500.00, 60.00, '2024-01-15 10:00:00', 'completed', 1),
('FF-R-002', 'Farm Fresh Store', 'FRESHFOOD', 1200.00, 650.00, 90.00, '2024-01-15 10:00:00', 'completed', 1),

-- Metro shops
('MR-D-001', 'Downtown Metro Market', 'METRO', 2000.00, 1000.00, 300.00, '2024-01-15 10:00:00', 'completed', 1),
('MR-D-002', 'CBD Metro Store', 'METRO', 1800.00, 900.00, 250.00, '2024-01-15 10:00:00', 'completed', 1),
('MR-U-001', 'Uptown Metro Market', 'METRO', 1600.00, 800.00, 200.00, '2024-01-15 10:00:00', 'completed', 1),
('MR-U-002', 'Residential Metro Store', 'METRO', 1400.00, 700.00, 150.00, '2024-01-15 10:00:00', 'completed', 1),
('MR-M-001', 'Midtown Metro Market', 'METRO', 1700.00, 850.00, 180.00, '2024-01-15 10:00:00', 'completed', 1),
('MR-M-002', 'Central Metro Store', 'METRO', 1900.00, 950.00, 220.00, '2024-01-15 10:00:00', 'completed', 1);

-- Insert synced orders (with sales executive assignments)
INSERT INTO synced_orders (order_id, order_date, order_amount, due_date, payment_status, days_overdue, shop_data_id, sales_executive_id, tenant_id, sync_date, created_by) VALUES
-- AquaStar orders
-- Alex Thompson's shops (AQ-N-001, AQ-N-002)
('ORD-001', '2024-01-01', 500.00, '2024-01-31', 'current', 0, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-002', '2024-01-05', 750.00, '2024-02-04', 'current', 0, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-003', '2023-12-15', 400.00, '2024-01-14', 'overdue', 1, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-004', '2024-01-02', 800.00, '2024-02-01', 'current', 0, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-005', '2023-12-10', 500.00, '2024-01-09', 'overdue', 6, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Maria Garcia's shops (AQ-N-003, AQ-N-004)
('ORD-006', '2024-01-03', 600.00, '2024-02-02', 'current', 0, 3, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-007', '2023-12-18', 400.00, '2024-01-17', 'overdue', 2, 3, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-008', '2024-01-04', 350.00, '2024-02-03', 'current', 0, 4, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-009', '2023-12-22', 250.00, '2024-01-21', 'overdue', 7, 4, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- James Anderson's shops (AQ-S-001, AQ-S-002)
('ORD-010', '2024-01-06', 450.00, '2024-02-05', 'current', 0, 5, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-011', '2023-12-28', 300.00, '2024-01-27', 'overdue', 12, 5, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-012', '2024-01-09', 550.00, '2024-02-08', 'current', 0, 6, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-013', '2023-12-30', 400.00, '2024-01-29', 'overdue', 14, 6, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Jennifer Taylor's shops (AQ-E-001, AQ-E-002)
('ORD-022', '2024-01-12', 400.00, '2024-02-11', 'current', 0, 7, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-023', '2023-12-14', 300.00, '2024-01-13', 'overdue', 2, 7, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-024', '2024-01-13', 500.00, '2024-02-12', 'current', 0, 8, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-025', '2023-12-16', 350.00, '2024-01-15', 'overdue', 0, 8, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Robert Martinez's shops (remaining shops)
('ORD-026', '2024-01-14', 450.00, '2024-02-13', 'current', 0, 9, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-027', '2023-12-18', 250.00, '2024-01-17', 'overdue', 1, 9, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-028', '2024-01-15', 600.00, '2024-02-14', 'current', 0, 10, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Linda Rodriguez's shops (remaining shops)
('ORD-029', '2024-01-16', 350.00, '2024-02-15', 'current', 0, 11, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-030', '2023-12-20', 200.00, '2024-01-19', 'overdue', 3, 11, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('ORD-031', '2024-01-17', 400.00, '2024-02-16', 'current', 0, 12, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- FreshFood orders
-- Kevin Murphy's shops (FF-M-001, FF-M-002)
('ORD-014', '2024-01-07', 400.00, '2024-02-06', 'current', 0, 9, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('ORD-015', '2023-12-20', 300.00, '2024-01-19', 'overdue', 4, 9, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('ORD-016', '2024-01-10', 500.00, '2024-02-09', 'current', 0, 10, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('ORD-017', '2023-12-25', 350.00, '2024-01-24', 'overdue', 9, 10, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),

-- Metro orders
-- Ryan Miller's shops (MR-D-001, MR-D-002)
('ORD-018', '2024-01-08', 600.00, '2024-02-07', 'current', 0, 15, 17, 'METRO', '2024-01-15 10:00:00', 1),
('ORD-019', '2023-12-12', 400.00, '2024-01-11', 'overdue', 4, 15, 17, 'METRO', '2024-01-15 10:00:00', 1),
('ORD-020', '2024-01-11', 700.00, '2024-02-10', 'current', 0, 16, 17, 'METRO', '2024-01-15 10:00:00', 1),
('ORD-021', '2023-12-05', 500.00, '2024-01-04', 'overdue', 11, 16, 17, 'METRO', '2024-01-15 10:00:00', 1);

-- Insert synced products (linked to orders and sales executives)
INSERT INTO synced_products (product_name, product_amount, sku, category, shop_data_id, order_id, sales_executive_id, tenant_id, sync_date, created_by) VALUES
-- AquaStar products
-- Products for ORD-001 (Alex Thompson)
('AquaStar Water 500ml', 50.00, 'ASW500', 'Beverages', 1, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 80.00, 'ASW1000', 'Beverages', 1, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 120.00, 'ASS500', 'Beverages', 1, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 100.00, 'ASF500', 'Beverages', 1, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sports', 150.00, 'ASSP500', 'Beverages', 1, 1, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-002 (Alex Thompson)
('AquaStar Water 500ml', 75.00, 'ASW500', 'Beverages', 1, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 120.00, 'ASW1000', 'Beverages', 1, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 180.00, 'ASS500', 'Beverages', 1, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 150.00, 'ASF500', 'Beverages', 1, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sports', 225.00, 'ASSP500', 'Beverages', 1, 2, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-003 (Alex Thompson)
('AquaStar Water 500ml', 60.00, 'ASW500', 'Beverages', 1, 3, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 100.00, 'ASW1000', 'Beverages', 1, 3, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 120.00, 'ASS500', 'Beverages', 1, 3, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 120.00, 'ASF500', 'Beverages', 1, 3, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-004 (Alex Thompson)
('AquaStar Water 500ml', 100.00, 'ASW500', 'Beverages', 2, 4, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 160.00, 'ASW1000', 'Beverages', 2, 4, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 240.00, 'ASS500', 'Beverages', 2, 4, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 200.00, 'ASF500', 'Beverages', 2, 4, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sports', 100.00, 'ASSP500', 'Beverages', 2, 4, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-005 (Alex Thompson)
('AquaStar Water 500ml', 80.00, 'ASW500', 'Beverages', 2, 5, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 120.00, 'ASW1000', 'Beverages', 2, 5, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 150.00, 'ASS500', 'Beverages', 2, 5, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 150.00, 'ASF500', 'Beverages', 2, 5, 5, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-006 (Maria Garcia)
('AquaStar Water 500ml', 90.00, 'ASW500', 'Beverages', 3, 6, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 140.00, 'ASW1000', 'Beverages', 3, 6, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 180.00, 'ASS500', 'Beverages', 3, 6, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 190.00, 'ASF500', 'Beverages', 3, 6, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-007 (Maria Garcia)
('AquaStar Water 500ml', 70.00, 'ASW500', 'Beverages', 3, 7, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 110.00, 'ASW1000', 'Beverages', 3, 7, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 120.00, 'ASS500', 'Beverages', 3, 7, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 100.00, 'ASF500', 'Beverages', 3, 7, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-008 (Maria Garcia)
('AquaStar Water 500ml', 50.00, 'ASW500', 'Beverages', 4, 8, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 80.00, 'ASW1000', 'Beverages', 4, 8, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 100.00, 'ASS500', 'Beverages', 4, 8, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 120.00, 'ASF500', 'Beverages', 4, 8, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-009 (Maria Garcia)
('AquaStar Water 500ml', 40.00, 'ASW500', 'Beverages', 4, 9, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 60.00, 'ASW1000', 'Beverages', 4, 9, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 80.00, 'ASS500', 'Beverages', 4, 9, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 70.00, 'ASF500', 'Beverages', 4, 9, 6, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-010 (James Anderson)
('AquaStar Water 500ml', 80.00, 'ASW500', 'Beverages', 5, 10, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 120.00, 'ASW1000', 'Beverages', 5, 10, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 150.00, 'ASS500', 'Beverages', 5, 10, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 100.00, 'ASF500', 'Beverages', 5, 10, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-011 (James Anderson)
('AquaStar Water 500ml', 60.00, 'ASW500', 'Beverages', 5, 11, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 90.00, 'ASW1000', 'Beverages', 5, 11, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 100.00, 'ASS500', 'Beverages', 5, 11, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 50.00, 'ASF500', 'Beverages', 5, 11, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-012 (James Anderson)
('AquaStar Water 500ml', 100.00, 'ASW500', 'Beverages', 6, 12, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 150.00, 'ASW1000', 'Beverages', 6, 12, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 180.00, 'ASS500', 'Beverages', 6, 12, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 120.00, 'ASF500', 'Beverages', 6, 12, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-013 (James Anderson)
('AquaStar Water 500ml', 80.00, 'ASW500', 'Beverages', 6, 13, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 120.00, 'ASW1000', 'Beverages', 6, 13, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 120.00, 'ASS500', 'Beverages', 6, 13, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 80.00, 'ASF500', 'Beverages', 6, 13, 7, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-022 (Jennifer Taylor)
('AquaStar Water 500ml', 80.00, 'ASW500', 'Beverages', 7, 22, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 120.00, 'ASW1000', 'Beverages', 7, 22, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 100.00, 'ASS500', 'Beverages', 7, 22, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 100.00, 'ASF500', 'Beverages', 7, 22, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-023 (Jennifer Taylor)
('AquaStar Water 500ml', 60.00, 'ASW500', 'Beverages', 7, 23, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 90.00, 'ASW1000', 'Beverages', 7, 23, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 80.00, 'ASS500', 'Beverages', 7, 23, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 70.00, 'ASF500', 'Beverages', 7, 23, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-024 (Jennifer Taylor)
('AquaStar Water 500ml', 100.00, 'ASW500', 'Beverages', 8, 24, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 150.00, 'ASW1000', 'Beverages', 8, 24, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 120.00, 'ASS500', 'Beverages', 8, 24, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 130.00, 'ASF500', 'Beverages', 8, 24, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-025 (Jennifer Taylor)
('AquaStar Water 500ml', 70.00, 'ASW500', 'Beverages', 8, 25, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 110.00, 'ASW1000', 'Beverages', 8, 25, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 90.00, 'ASS500', 'Beverages', 8, 25, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 80.00, 'ASF500', 'Beverages', 8, 25, 8, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-026 (Robert Martinez)
('AquaStar Water 500ml', 90.00, 'ASW500', 'Beverages', 9, 26, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 130.00, 'ASW1000', 'Beverages', 9, 26, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 120.00, 'ASS500', 'Beverages', 9, 26, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 110.00, 'ASF500', 'Beverages', 9, 26, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-027 (Robert Martinez)
('AquaStar Water 500ml', 50.00, 'ASW500', 'Beverages', 9, 27, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 80.00, 'ASW1000', 'Beverages', 9, 27, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 70.00, 'ASS500', 'Beverages', 9, 27, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 50.00, 'ASF500', 'Beverages', 9, 27, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-028 (Robert Martinez)
('AquaStar Water 500ml', 120.00, 'ASW500', 'Beverages', 10, 28, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 180.00, 'ASW1000', 'Beverages', 10, 28, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 150.00, 'ASS500', 'Beverages', 10, 28, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 150.00, 'ASF500', 'Beverages', 10, 28, 9, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-029 (Linda Rodriguez)
('AquaStar Water 500ml', 70.00, 'ASW500', 'Beverages', 11, 29, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 110.00, 'ASW1000', 'Beverages', 11, 29, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 90.00, 'ASS500', 'Beverages', 11, 29, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 80.00, 'ASF500', 'Beverages', 11, 29, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-030 (Linda Rodriguez)
('AquaStar Water 500ml', 40.00, 'ASW500', 'Beverages', 11, 30, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 60.00, 'ASW1000', 'Beverages', 11, 30, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 50.00, 'ASS500', 'Beverages', 11, 30, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 50.00, 'ASF500', 'Beverages', 11, 30, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- Products for ORD-031 (Linda Rodriguez)
('AquaStar Water 500ml', 80.00, 'ASW500', 'Beverages', 12, 31, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Water 1L', 120.00, 'ASW1000', 'Beverages', 12, 31, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Sparkling', 100.00, 'ASS500', 'Beverages', 12, 31, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),
('AquaStar Flavored', 100.00, 'ASF500', 'Beverages', 12, 31, 10, 'AQUASTAR', '2024-01-15 10:00:00', 1),

-- FreshFood products
-- Products for ORD-014 (Kevin Murphy)
('FreshFood Organic', 60.00, 'FFO500', 'Food', 9, 14, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Natural', 100.00, 'FFN500', 'Food', 9, 14, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Healthy', 150.00, 'FFH500', 'Food', 9, 14, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Premium', 90.00, 'FFP500', 'Food', 9, 14, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),

-- Products for ORD-015 (Kevin Murphy)
('FreshFood Organic', 50.00, 'FFO500', 'Food', 9, 15, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Natural', 80.00, 'FFN500', 'Food', 9, 15, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Healthy', 100.00, 'FFH500', 'Food', 9, 15, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Premium', 70.00, 'FFP500', 'Food', 9, 15, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),

-- Products for ORD-016 (Kevin Murphy)
('FreshFood Organic', 80.00, 'FFO500', 'Food', 10, 16, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Natural', 120.00, 'FFN500', 'Food', 10, 16, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Healthy', 150.00, 'FFH500', 'Food', 10, 16, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Premium', 150.00, 'FFP500', 'Food', 10, 16, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),

-- Products for ORD-017 (Kevin Murphy)
('FreshFood Organic', 60.00, 'FFO500', 'Food', 10, 17, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Natural', 90.00, 'FFN500', 'Food', 10, 17, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Healthy', 100.00, 'FFH500', 'Food', 10, 17, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),
('FreshFood Premium', 100.00, 'FFP500', 'Food', 10, 17, 11, 'FRESHFOOD', '2024-01-15 10:00:00', 1),

-- Products for ORD-019 (Ryan Miller)
('Metro Electronics', 80.00, 'ME500', 'Electronics', 15, 19, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Gadgets', 120.00, 'MG500', 'Electronics', 15, 19, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Accessories', 100.00, 'MA500', 'Electronics', 15, 19, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Premium', 100.00, 'MP500', 'Electronics', 15, 19, 17, 'METRO', '2024-01-15 10:00:00', 1),

-- Products for ORD-020 (Ryan Miller)
('Metro Electronics', 120.00, 'ME500', 'Electronics', 16, 20, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Gadgets', 180.00, 'MG500', 'Electronics', 16, 20, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Accessories', 200.00, 'MA500', 'Electronics', 16, 20, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Premium', 200.00, 'MP500', 'Electronics', 16, 20, 17, 'METRO', '2024-01-15 10:00:00', 1),

-- Products for ORD-021 (Ryan Miller)
('Metro Electronics', 100.00, 'ME500', 'Electronics', 16, 21, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Gadgets', 150.00, 'MG500', 'Electronics', 16, 21, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Accessories', 150.00, 'MA500', 'Electronics', 16, 21, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Premium', 100.00, 'MP500', 'Electronics', 16, 21, 17, 'METRO', '2024-01-15 10:00:00', 1),

-- Metro products
-- Products for ORD-018 (Ryan Miller)
('Metro Electronics', 120.00, 'ME500', 'Electronics', 15, 18, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Gadgets', 180.00, 'MG500', 'Electronics', 15, 18, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Accessories', 150.00, 'MA500', 'Electronics', 15, 18, 17, 'METRO', '2024-01-15 10:00:00', 1),
('Metro Premium', 150.00, 'MP500', 'Electronics', 15, 18, 17, 'METRO', '2024-01-15 10:00:00', 1);

-- Insert due data (outstanding payments)
INSERT INTO due_data (shop_id, shop_name, amount, due_date, status, sales_executive_id, territory_id, tenant_id, original_amount, days_overdue, last_payment_date, notes, created_by) VALUES
-- AquaStar due data
-- Alex Thompson's shops
('AQ-N-001', 'Downtown Convenience Store', 200.00, '2024-01-14', 'overdue', 5, 'AQ-NORTH', 'AQUASTAR', 400.00, 1, '2023-12-15', 'Partial payment received', 1),
('AQ-N-002', 'Central Market', 500.00, '2024-01-09', 'overdue', 5, 'AQ-NORTH', 'AQUASTAR', 500.00, 6, NULL, 'Payment pending', 1),

-- Maria Garcia's shops
('AQ-N-003', 'Metro Supermarket', 400.00, '2024-01-17', 'overdue', 6, 'AQ-NORTH', 'AQUASTAR', 400.00, 2, NULL, 'Payment pending', 1),
('AQ-N-004', 'City Corner Store', 250.00, '2024-01-21', 'overdue', 6, 'AQ-NORTH', 'AQUASTAR', 250.00, 7, NULL, 'Payment pending', 1),

-- James Anderson's shops
('AQ-S-001', 'Southside Market', 300.00, '2024-01-27', 'overdue', 7, 'AQ-SOUTH', 'AQUASTAR', 300.00, 12, NULL, 'Payment pending', 1),
('AQ-S-002', 'Coastal Store', 400.00, '2024-01-29', 'overdue', 7, 'AQ-SOUTH', 'AQUASTAR', 400.00, 14, NULL, 'Payment pending', 1),

-- FreshFood due data
-- Kevin Murphy's shops
('FF-M-001', 'Metro Fresh Market', 300.00, '2024-01-19', 'overdue', 11, 'FF-METRO', 'FRESHFOOD', 300.00, 4, NULL, 'Payment pending', 1),
('FF-M-002', 'Urban Fresh Store', 350.00, '2024-01-24', 'overdue', 11, 'FF-METRO', 'FRESHFOOD', 350.00, 9, NULL, 'Payment pending', 1),

-- Metro due data
-- Ryan Miller's shops
('MR-D-001', 'Downtown Metro Market', 400.00, '2024-01-11', 'overdue', 17, 'MR-DOWNTOWN', 'METRO', 400.00, 4, NULL, 'Payment pending', 1),
('MR-D-002', 'CBD Metro Store', 500.00, '2024-01-04', 'overdue', 17, 'MR-DOWNTOWN', 'METRO', 500.00, 11, NULL, 'Payment pending', 1),

-- Current payments (not overdue)
('AQ-N-001', 'Downtown Convenience Store', 500.00, '2024-01-31', 'current', 5, 'AQ-NORTH', 'AQUASTAR', 500.00, 0, NULL, 'Current payment', 1),
('AQ-N-001', 'Downtown Convenience Store', 750.00, '2024-02-04', 'current', 5, 'AQ-NORTH', 'AQUASTAR', 750.00, 0, NULL, 'Current payment', 1),
('AQ-N-002', 'Central Market', 800.00, '2024-02-01', 'current', 5, 'AQ-NORTH', 'AQUASTAR', 800.00, 0, NULL, 'Current payment', 1),
('AQ-N-003', 'Metro Supermarket', 600.00, '2024-02-02', 'current', 6, 'AQ-NORTH', 'AQUASTAR', 600.00, 0, NULL, 'Current payment', 1),
('AQ-N-004', 'City Corner Store', 350.00, '2024-02-03', 'current', 6, 'AQ-NORTH', 'AQUASTAR', 350.00, 0, NULL, 'Current payment', 1),
('AQ-S-001', 'Southside Market', 450.00, '2024-02-05', 'current', 7, 'AQ-SOUTH', 'AQUASTAR', 450.00, 0, NULL, 'Current payment', 1),
('AQ-S-002', 'Coastal Store', 550.00, '2024-02-08', 'current', 7, 'AQ-SOUTH', 'AQUASTAR', 550.00, 0, NULL, 'Current payment', 1),
('FF-M-001', 'Metro Fresh Market', 400.00, '2024-02-06', 'current', 11, 'FF-METRO', 'FRESHFOOD', 400.00, 0, NULL, 'Current payment', 1),
('FF-M-002', 'Urban Fresh Store', 500.00, '2024-02-09', 'current', 11, 'FF-METRO', 'FRESHFOOD', 500.00, 0, NULL, 'Current payment', 1),
('MR-D-001', 'Downtown Metro Market', 600.00, '2024-02-07', 'current', 17, 'MR-DOWNTOWN', 'METRO', 600.00, 0, NULL, 'Current payment', 1),
('MR-D-002', 'CBD Metro Store', 700.00, '2024-02-10', 'current', 17, 'MR-DOWNTOWN', 'METRO', 700.00, 0, NULL, 'Current payment', 1);
