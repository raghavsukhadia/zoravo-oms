-- Add tenant_id to service_tracker table for multi-tenancy support
-- This script ensures the service_tracker table has tenant_id column

DO $$ 
BEGIN
    -- Check if service_tracker table exists
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'service_tracker') THEN
        -- Add tenant_id column if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'service_tracker' 
            AND column_name = 'tenant_id'
        ) THEN
            ALTER TABLE service_tracker 
            ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
            
            RAISE NOTICE 'Added tenant_id column to service_tracker table';
        ELSE
            RAISE NOTICE 'tenant_id column already exists in service_tracker table';
        END IF;
        
        -- Create index on tenant_id for better performance
        CREATE INDEX IF NOT EXISTS idx_service_tracker_tenant_id ON service_tracker(tenant_id);
        
        RAISE NOTICE 'Created index on tenant_id for service_tracker table';
    ELSE
        RAISE NOTICE 'service_tracker table does not exist - skipping';
    END IF;
END $$;

-- Update existing records to default tenant (if any exist without tenant_id)
-- Only update if there's a default tenant
DO $$ 
DECLARE
    default_tenant_id UUID;
BEGIN
    -- Get the default tenant ID (RS Car Accessories)
    SELECT id INTO default_tenant_id 
    FROM tenants 
    WHERE tenant_code = 'Z01' OR name LIKE '%RS Car Accessories%'
    LIMIT 1;
    
    -- If default tenant exists and service_tracker table exists, update NULL tenant_ids
    IF default_tenant_id IS NOT NULL AND EXISTS (
        SELECT FROM information_schema.tables WHERE table_name = 'service_tracker'
    ) THEN
        UPDATE service_tracker 
        SET tenant_id = default_tenant_id 
        WHERE tenant_id IS NULL;
        
        RAISE NOTICE 'Updated existing service_tracker records to default tenant';
    END IF;
END $$;

