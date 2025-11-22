-- Migration: Add new fields to shops table
-- Date: 2024-01-16
-- Description: Add pin_code, email, aadhaar_number, pan_number, location_name, gst_number fields to shops table

-- Add new columns to shops table
ALTER TABLE shops 
ADD COLUMN pin_code VARCHAR(10) AFTER territory_id,
ADD COLUMN email VARCHAR(100) AFTER pin_code,
ADD COLUMN aadhaar_number VARCHAR(12) AFTER email,
ADD COLUMN pan_number VARCHAR(10) AFTER aadhaar_number,
ADD COLUMN location_name VARCHAR(100) AFTER pan_number,
ADD COLUMN gst_number VARCHAR(15) AFTER location_name;

-- Add indexes for performance
ALTER TABLE shops 
ADD INDEX idx_email (email),
ADD INDEX idx_pin_code (pin_code);

-- Update existing shops with default values if needed
UPDATE shops 
SET pin_code = NULL, 
    email = NULL, 
    aadhaar_number = NULL, 
    pan_number = NULL, 
    location_name = NULL, 
    gst_number = NULL 
WHERE pin_code IS NULL;