-- Sample Shop Data with New Fields
-- This file demonstrates how to insert shops with all the new fields

INSERT INTO shops (
    shop_id, name, code, status, address, phone, contact_person, 
    latitude, longitude, territory_id, pin_code, email, aadhaar_number,
    pan_number, location_name, gst_number, tenant_id, created_by
) VALUES
(
    'SAMPLE-001', 
    'Modern Electronics Store', 
    'MES001', 
    'active', 
    '123 Tech Street, Electronics Plaza, Kochi', 
    '+91-9876543210', 
    'Rajesh Kumar', 
    9.9312, 
    76.2673, 
    'TERR001', 
    '682016', 
    'rajesh@modernelectronics.com', 
    '123456789012', 
    'ABCDE1234F', 
    'Electronics Plaza, Kochi', 
    '32ABCDE1234F1Z5', 
    'SAMPLE_TENANT', 
    1
),
(
    'SAMPLE-002', 
    'Green Grocers', 
    'GG001', 
    'active', 
    '456 Market Road, Fresh Market Complex, Ernakulam', 
    '+91-9876543211', 
    'Priya Sharma', 
    9.9816, 
    76.2999, 
    'TERR001', 
    '682018', 
    'priya@greengrocers.com', 
    '987654321098', 
    'FGHIJ5678K', 
    'Fresh Market Complex, Ernakulam', 
    '32FGHIJ5678K1Z5', 
    'SAMPLE_TENANT', 
    1
);

-- You can also insert shops with only some of the new fields
INSERT INTO shops (
    shop_id, name, code, status, address, phone, contact_person, 
    latitude, longitude, territory_id, pin_code, email, tenant_id, created_by
) VALUES
(
    'SAMPLE-003', 
    'Quick Mart', 
    'QM001', 
    'active', 
    '789 Convenience Lane, Quick Plaza', 
    '+91-9876543212', 
    'Amit Patel', 
    9.9400, 
    76.2800, 
    'TERR001', 
    '682020', 
    'amit@quickmart.com', 
    'SAMPLE_TENANT', 
    1
);