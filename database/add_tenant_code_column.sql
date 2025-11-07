-- Add tenant_code column to existing tenants table
-- This script is idempotent and can be run multiple times safely

-- Add tenant_code column if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'tenants' AND column_name = 'tenant_code'
    ) THEN
        ALTER TABLE tenants ADD COLUMN tenant_code VARCHAR(10) UNIQUE;
    END IF;
END $$;

-- Create index on tenant_code for faster lookups
CREATE INDEX IF NOT EXISTS idx_tenants_tenant_code ON tenants(tenant_code);

-- Function to generate next tenant code (Z01, Z02, Z03, etc.)
CREATE OR REPLACE FUNCTION generate_tenant_code()
RETURNS VARCHAR(10) AS $$
DECLARE
    next_num INTEGER;
    new_code VARCHAR(10);
BEGIN
    -- Get the highest existing tenant code number
    SELECT COALESCE(MAX(CAST(SUBSTRING(tenant_code FROM 2) AS INTEGER)), 0) + 1
    INTO next_num
    FROM tenants
    WHERE tenant_code IS NOT NULL AND tenant_code ~ '^Z[0-9]+$';
    
    -- Format as Z01, Z02, etc. (padded to 2 digits)
    new_code := 'Z' || LPAD(next_num::TEXT, 2, '0');
    
    RETURN new_code;
END;
$$ LANGUAGE plpgsql;

-- Set Z01 for RS Car Accessories if it doesn't have a code
UPDATE tenants 
SET tenant_code = 'Z01'
WHERE id = '00000000-0000-0000-0000-000000000001'::uuid 
  AND tenant_code IS NULL;

-- Assign codes to existing tenants that don't have one
DO $$
DECLARE
    tenant_record RECORD;
    current_num INTEGER := 1;
BEGIN
    -- Start from Z02 since Z01 is reserved for RS Car Accessories
    FOR tenant_record IN 
        SELECT id FROM tenants 
        WHERE tenant_code IS NULL 
        AND id != '00000000-0000-0000-0000-000000000001'::uuid
        ORDER BY created_at ASC
    LOOP
        -- Check if Z02, Z03, etc. are already taken
        WHILE EXISTS (
            SELECT 1 FROM tenants 
            WHERE tenant_code = 'Z' || LPAD(current_num::TEXT, 2, '0')
        ) LOOP
            current_num := current_num + 1;
        END LOOP;
        
        -- Assign the code
        UPDATE tenants 
        SET tenant_code = 'Z' || LPAD(current_num::TEXT, 2, '0')
        WHERE id = tenant_record.id;
        
        current_num := current_num + 1;
    END LOOP;
END $$;

