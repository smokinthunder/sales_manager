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


-- ============================================
-- Orders and Order Items (New tables)
-- ============================================

-- Insert Orders
INSERT INTO orders (order_id, bill_number, shop_id, executive_id, order_date, total_amount, status, items_count, notes, delivery_date, payment_status, payment_method, tenant_id, created_by) VALUES
-- AquaStar Orders - Alex Thompson (executive_id: 5)
('ORD2024001', 'BILL-2024-0001', 'AQ-N-001', 5, '2024-11-25', 5850.00, 'completed', 3, 'Regular monthly order', '2024-11-27', 'paid', 'cash', 'AQUASTAR', 1),
('ORD2024002', 'BILL-2024-0002', 'AQ-N-002', 5, '2024-11-26', 8920.00, 'completed', 4, 'Bulk order for renovation', '2024-11-28', 'paid', 'credit', 'AQUASTAR', 1),
('ORD2024003', 'BILL-2024-0003', 'AQ-N-001', 5, '2024-11-28', 3240.00, 'pending', 2, 'Emergency stock replenishment', '2024-12-02', 'pending', 'credit', 'AQUASTAR', 1),

-- AquaStar Orders - Maria Garcia (executive_id: 6)
('ORD2024004', 'BILL-2024-0004', 'AQ-N-003', 6, '2024-11-25', 12450.00, 'completed', 5, 'Major project order', '2024-11-29', 'partial', 'bank_transfer', 'AQUASTAR', 1),
('ORD2024005', 'BILL-2024-0005', 'AQ-N-004', 6, '2024-11-27', 4560.00, 'confirmed', 3, 'Regular weekly order', '2024-12-01', 'pending', 'cash', 'AQUASTAR', 1),
('ORD2024006', 'BILL-2024-0006', 'AQ-N-003', 6, '2024-11-29', 7890.00, 'processing', 4, 'Scheduled maintenance order', '2024-12-03', 'pending', 'credit', 'AQUASTAR', 1),

-- AquaStar Orders - James Anderson (executive_id: 7)
('ORD2024007', 'BILL-2024-0007', 'AQ-S-001', 7, '2024-11-26', 6780.00, 'completed', 3, 'Standard order', '2024-11-30', 'paid', 'cash', 'AQUASTAR', 1),
('ORD2024008', 'BILL-2024-0008', 'AQ-S-002', 7, '2024-11-27', 9340.00, 'shipped', 5, 'Large order for expansion', '2024-12-01', 'partial', 'bank_transfer', 'AQUASTAR', 1),
('ORD2024009', 'BILL-2024-0009', 'AQ-S-001', 7, '2024-11-30', 2890.00, 'cancelled', 2, 'Cancelled due to stock unavailability', NULL, 'pending', NULL, 'AQUASTAR', 1),

-- AquaStar Orders - Jennifer Taylor (executive_id: 8)
('ORD2024010', 'BILL-2024-0010', 'AQ-S-003', 8, '2024-11-25', 5670.00, 'completed', 3, 'Regular order', '2024-11-28', 'paid', 'credit', 'AQUASTAR', 1),
('ORD2024011', 'BILL-2024-0011', 'AQ-S-004', 8, '2024-11-28', 8120.00, 'delivered', 4, 'Special project order', '2024-12-02', 'paid', 'bank_transfer', 'AQUASTAR', 1),

-- FreshFood Orders - Kevin Murphy (executive_id: 11)
('ORD2024012', 'BILL-2024-0012', 'FF-M-001', 11, '2024-11-26', 4320.00, 'completed', 3, 'Regular monthly order', '2024-11-29', 'paid', 'cash', 'FRESHFOOD', 1),
('ORD2024013', 'BILL-2024-0013', 'FF-M-002', 11, '2024-11-29', 6540.00, 'processing', 4, 'Expansion project order', '2024-12-03', 'pending', 'credit', 'FRESHFOOD', 1),

-- FreshFood Orders - Nicole Adams (executive_id: 12)
('ORD2024014', 'BILL-2024-0014', 'FF-M-003', 12, '2024-11-27', 7890.00, 'completed', 5, 'Bulk order', '2024-12-01', 'paid', 'bank_transfer', 'FRESHFOOD', 1),
('ORD2024015', 'BILL-2024-0015', 'FF-M-004', 12, '2024-11-30', 3450.00, 'confirmed', 2, 'Regular order', '2024-12-04', 'pending', 'cash', 'FRESHFOOD', 1),

-- Metro Orders - Ryan Miller (executive_id: 17)
('ORD2024016', 'BILL-2024-0016', 'MR-D-001', 17, '2024-11-25', 9870.00, 'completed', 4, 'Large project order', '2024-11-28', 'paid', 'bank_transfer', 'METRO', 1),
('ORD2024017', 'BILL-2024-0017', 'MR-D-002', 17, '2024-11-28', 5430.00, 'delivered', 3, 'Regular monthly order', '2024-12-02', 'paid', 'credit', 'METRO', 1),

-- Metro Orders - Amanda Garcia (executive_id: 18)
('ORD2024018', 'BILL-2024-0018', 'MR-D-003', 18, '2024-11-26', 6780.00, 'completed', 4, 'Standard order', '2024-11-30', 'paid', 'cash', 'METRO', 1),
('ORD2024019', 'BILL-2024-0019', 'MR-D-004', 18, '2024-11-29', 8920.00, 'processing', 5, 'Special project', '2024-12-03', 'pending', 'bank_transfer', 'METRO', 1),

-- Returned order example
('ORD2024020', 'BILL-2024-0020', 'AQ-N-002', 5, '2024-11-27', 2340.00, 'returned', 2, 'Quality issues - returned', NULL, 'pending', NULL, 'AQUASTAR', 1);


-- Insert Order Items
INSERT INTO order_items (order_id, product_code, product_name, quantity, unit, unit_price, total_price, discount, tax_amount, tenant_id) VALUES
-- Order 1 items (ORD2024001 - get order id dynamically)
((SELECT id FROM orders WHERE order_id = 'ORD2024001'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 20.00, 'pcs', 150.00, 3000.00, 0.00, 360.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024001'), 'ELB-100-90', '100mm 90° Elbow', 15.00, 'pcs', 45.00, 675.00, 33.75, 81.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024001'), 'TEE-100', '100mm T-Joint', 25.00, 'pcs', 65.00, 1625.00, 81.25, 195.00, 'AQUASTAR'),

-- Order 2 items (ORD2024002)
((SELECT id FROM orders WHERE order_id = 'ORD2024002'), 'PVC-150-10', 'PVC Pipe 150mm x 10ft', 15.00, 'pcs', 280.00, 4200.00, 0.00, 504.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024002'), 'ELB-150-90', '150mm 90° Elbow', 20.00, 'pcs', 75.00, 1500.00, 75.00, 180.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024002'), 'CPL-150', '150mm Coupler', 30.00, 'pcs', 55.00, 1650.00, 82.50, 198.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024002'), 'VLV-150', '150mm Ball Valve', 10.00, 'pcs', 120.00, 1200.00, 60.00, 144.00, 'AQUASTAR'),

-- Order 3 items (ORD2024003)
((SELECT id FROM orders WHERE order_id = 'ORD2024003'), 'PVC-75-10', 'PVC Pipe 75mm x 10ft', 25.00, 'pcs', 95.00, 2375.00, 0.00, 285.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024003'), 'ELB-75-45', '75mm 45° Elbow', 12.00, 'pcs', 35.00, 420.00, 21.00, 50.40, 'AQUASTAR'),

-- Order 4 items (ORD2024004)
((SELECT id FROM orders WHERE order_id = 'ORD2024004'), 'PVC-200-10', 'PVC Pipe 200mm x 10ft', 20.00, 'pcs', 450.00, 9000.00, 0.00, 1080.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024004'), 'ELB-200-90', '200mm 90° Elbow', 8.00, 'pcs', 125.00, 1000.00, 50.00, 120.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024004'), 'TEE-200', '200mm T-Joint', 10.00, 'pcs', 180.00, 1800.00, 90.00, 216.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024004'), 'CPL-200', '200mm Coupler', 15.00, 'pcs', 95.00, 1425.00, 71.25, 171.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024004'), 'VLV-200', '200mm Ball Valve', 5.00, 'pcs', 280.00, 1400.00, 70.00, 168.00, 'AQUASTAR'),

-- Order 5 items (ORD2024005)
((SELECT id FROM orders WHERE order_id = 'ORD2024005'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 18.00, 'pcs', 150.00, 2700.00, 0.00, 324.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024005'), 'CPL-100', '100mm Coupler', 20.00, 'pcs', 42.00, 840.00, 42.00, 100.80, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024005'), 'VLV-100', '100mm Ball Valve', 8.00, 'pcs', 95.00, 760.00, 38.00, 91.20, 'AQUASTAR'),

-- Order 6 items (ORD2024006)
((SELECT id FROM orders WHERE order_id = 'ORD2024006'), 'PVC-150-10', 'PVC Pipe 150mm x 10ft', 12.00, 'pcs', 280.00, 3360.00, 0.00, 403.20, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024006'), 'ELB-150-90', '150mm 90° Elbow', 16.00, 'pcs', 75.00, 1200.00, 60.00, 144.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024006'), 'TEE-150', '150mm T-Joint', 18.00, 'pcs', 95.00, 1710.00, 85.50, 205.20, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024006'), 'CPL-150', '150mm Coupler', 25.00, 'pcs', 55.00, 1375.00, 68.75, 165.00, 'AQUASTAR'),

-- Order 7 items (ORD2024007)
((SELECT id FROM orders WHERE order_id = 'ORD2024007'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 22.00, 'pcs', 150.00, 3300.00, 0.00, 396.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024007'), 'ELB-100-90', '100mm 90° Elbow', 18.00, 'pcs', 45.00, 810.00, 40.50, 97.20, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024007'), 'TEE-100', '100mm T-Joint', 20.00, 'pcs', 65.00, 1300.00, 65.00, 156.00, 'AQUASTAR'),

-- Order 8 items (ORD2024008)
((SELECT id FROM orders WHERE order_id = 'ORD2024008'), 'PVC-200-10', 'PVC Pipe 200mm x 10ft', 10.00, 'pcs', 450.00, 4500.00, 0.00, 540.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024008'), 'ELB-200-90', '200mm 90° Elbow', 12.00, 'pcs', 125.00, 1500.00, 75.00, 180.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024008'), 'TEE-200', '200mm T-Joint', 8.00, 'pcs', 180.00, 1440.00, 72.00, 172.80, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024008'), 'CPL-200', '200mm Coupler', 18.00, 'pcs', 95.00, 1710.00, 85.50, 205.20, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024008'), 'VLV-200', '200mm Ball Valve', 6.00, 'pcs', 280.00, 1680.00, 84.00, 201.60, 'AQUASTAR'),

-- Order 10 items (ORD2024010)
((SELECT id FROM orders WHERE order_id = 'ORD2024010'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 16.00, 'pcs', 150.00, 2400.00, 0.00, 288.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024010'), 'ELB-100-90', '100mm 90° Elbow', 22.00, 'pcs', 45.00, 990.00, 49.50, 118.80, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024010'), 'CPL-100', '100mm Coupler', 28.00, 'pcs', 42.00, 1176.00, 58.80, 141.12, 'AQUASTAR'),

-- Order 11 items (ORD2024011)
((SELECT id FROM orders WHERE order_id = 'ORD2024011'), 'PVC-150-10', 'PVC Pipe 150mm x 10ft', 14.00, 'pcs', 280.00, 3920.00, 0.00, 470.40, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024011'), 'ELB-150-90', '150mm 90° Elbow', 16.00, 'pcs', 75.00, 1200.00, 60.00, 144.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024011'), 'TEE-150', '150mm T-Joint', 12.00, 'pcs', 95.00, 1140.00, 57.00, 136.80, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024011'), 'VLV-150', '150mm Ball Valve', 10.00, 'pcs', 150.00, 1500.00, 75.00, 180.00, 'AQUASTAR'),

-- FreshFood Orders
-- Order 12 items (ORD2024012)
((SELECT id FROM orders WHERE order_id = 'ORD2024012'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 14.00, 'pcs', 150.00, 2100.00, 0.00, 252.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024012'), 'ELB-100-90', '100mm 90° Elbow', 20.00, 'pcs', 45.00, 900.00, 45.00, 108.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024012'), 'CPL-100', '100mm Coupler', 18.00, 'pcs', 42.00, 756.00, 37.80, 90.72, 'FRESHFOOD'),

-- Order 13 items (ORD2024013)
((SELECT id FROM orders WHERE order_id = 'ORD2024013'), 'PVC-150-10', 'PVC Pipe 150mm x 10ft', 10.00, 'pcs', 280.00, 2800.00, 0.00, 336.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024013'), 'ELB-150-90', '150mm 90° Elbow', 15.00, 'pcs', 75.00, 1125.00, 56.25, 135.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024013'), 'TEE-150', '150mm T-Joint', 12.00, 'pcs', 95.00, 1140.00, 57.00, 136.80, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024013'), 'VLV-150', '150mm Ball Valve', 8.00, 'pcs', 150.00, 1200.00, 60.00, 144.00, 'FRESHFOOD'),

-- Order 14 items (ORD2024014)
((SELECT id FROM orders WHERE order_id = 'ORD2024014'), 'PVC-200-10', 'PVC Pipe 200mm x 10ft', 8.00, 'pcs', 450.00, 3600.00, 0.00, 432.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024014'), 'ELB-200-90', '200mm 90° Elbow', 10.00, 'pcs', 125.00, 1250.00, 62.50, 150.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024014'), 'TEE-200', '200mm T-Joint', 12.00, 'pcs', 180.00, 2160.00, 108.00, 259.20, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024014'), 'CPL-200', '200mm Coupler', 14.00, 'pcs', 95.00, 1330.00, 66.50, 159.60, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024014'), 'VLV-200', '200mm Ball Valve', 4.00, 'pcs', 280.00, 1120.00, 56.00, 134.40, 'FRESHFOOD'),

-- Order 15 items (ORD2024015)
((SELECT id FROM orders WHERE order_id = 'ORD2024015'), 'PVC-75-10', 'PVC Pipe 75mm x 10ft', 20.00, 'pcs', 95.00, 1900.00, 0.00, 228.00, 'FRESHFOOD'),
((SELECT id FROM orders WHERE order_id = 'ORD2024015'), 'ELB-75-90', '75mm 90° Elbow', 18.00, 'pcs', 38.00, 684.00, 34.20, 82.08, 'FRESHFOOD'),

-- Metro Orders
-- Order 16 items (ORD2024016)
((SELECT id FROM orders WHERE order_id = 'ORD2024016'), 'PVC-200-10', 'PVC Pipe 200mm x 10ft', 12.00, 'pcs', 450.00, 5400.00, 0.00, 648.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024016'), 'ELB-200-90', '200mm 90° Elbow', 15.00, 'pcs', 125.00, 1875.00, 93.75, 225.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024016'), 'TEE-200', '200mm T-Joint', 10.00, 'pcs', 180.00, 1800.00, 90.00, 216.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024016'), 'VLV-200', '200mm Ball Valve', 6.00, 'pcs', 280.00, 1680.00, 84.00, 201.60, 'METRO'),

-- Order 17 items (ORD2024017)
((SELECT id FROM orders WHERE order_id = 'ORD2024017'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 18.00, 'pcs', 150.00, 2700.00, 0.00, 324.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024017'), 'ELB-100-90', '100mm 90° Elbow', 16.00, 'pcs', 45.00, 720.00, 36.00, 86.40, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024017'), 'TEE-100', '100mm T-Joint', 14.00, 'pcs', 65.00, 910.00, 45.50, 109.20, 'METRO'),

-- Order 18 items (ORD2024018)
((SELECT id FROM orders WHERE order_id = 'ORD2024018'), 'PVC-150-10', 'PVC Pipe 150mm x 10ft', 11.00, 'pcs', 280.00, 3080.00, 0.00, 369.60, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024018'), 'ELB-150-90', '150mm 90° Elbow', 14.00, 'pcs', 75.00, 1050.00, 52.50, 126.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024018'), 'TEE-150', '150mm T-Joint', 16.00, 'pcs', 95.00, 1520.00, 76.00, 182.40, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024018'), 'CPL-150', '150mm Coupler', 20.00, 'pcs', 55.00, 1100.00, 55.00, 132.00, 'METRO'),

-- Order 19 items (ORD2024019)
((SELECT id FROM orders WHERE order_id = 'ORD2024019'), 'PVC-200-10', 'PVC Pipe 200mm x 10ft', 10.00, 'pcs', 450.00, 4500.00, 0.00, 540.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024019'), 'ELB-200-90', '200mm 90° Elbow', 12.00, 'pcs', 125.00, 1500.00, 75.00, 180.00, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024019'), 'TEE-200', '200mm T-Joint', 14.00, 'pcs', 180.00, 2520.00, 126.00, 302.40, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024019'), 'CPL-200', '200mm Coupler', 16.00, 'pcs', 95.00, 1520.00, 76.00, 182.40, 'METRO'),
((SELECT id FROM orders WHERE order_id = 'ORD2024019'), 'VLV-200', '200mm Ball Valve', 5.00, 'pcs', 280.00, 1400.00, 70.00, 168.00, 'METRO'),

-- Order 20 items (ORD2024020 - returned order)
((SELECT id FROM orders WHERE order_id = 'ORD2024020'), 'PVC-100-10', 'PVC Pipe 100mm x 10ft', 10.00, 'pcs', 150.00, 1500.00, 0.00, 180.00, 'AQUASTAR'),
((SELECT id FROM orders WHERE order_id = 'ORD2024020'), 'ELB-100-90', '100mm 90° Elbow', 8.00, 'pcs', 45.00, 360.00, 18.00, 43.20, 'AQUASTAR');
