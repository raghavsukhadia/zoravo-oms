-- Add tenant_id to call_follow_up table for multi-tenancy support
-- This script ensures the call_follow_up table has tenant_id column

DO $$ 
BEGIN
    -- Check if call_follow_up table exists
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'call_follow_up') THEN
        -- Add tenant_id column if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'call_follow_up' 
            AND column_name = 'tenant_id'
        ) THEN
            ALTER TABLE call_follow_up 
            ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
            
            RAISE NOTICE 'Added tenant_id column to call_follow_up table';
        ELSE
            RAISE NOTICE 'tenant_id column already exists in call_follow_up table';
        END IF;
        
        -- Create index on tenant_id for better performance
        CREATE INDEX IF NOT EXISTS idx_call_follow_up_tenant_id ON call_follow_up(tenant_id);
        
        RAISE NOTICE 'Created index on tenant_id for call_follow_up table';
    ELSE
        RAISE NOTICE 'call_follow_up table does not exist - skipping';
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
    
    -- If default tenant exists and call_follow_up table exists, update NULL tenant_ids
    IF default_tenant_id IS NOT NULL AND EXISTS (
        SELECT FROM information_schema.tables WHERE table_name = 'call_follow_up'
    ) THEN
        UPDATE call_follow_up 
        SET tenant_id = default_tenant_id 
        WHERE tenant_id IS NULL;
        
        RAISE NOTICE 'Updated existing call_follow_up records to default tenant';
    END IF;
END $$;

