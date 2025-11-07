-- Verify and Fix system_settings Tenant Isolation
-- This script ensures proper data isolation for tenant-specific settings

-- Step 1: Verify tenant_id column exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'system_settings' 
        AND column_name = 'tenant_id'
    ) THEN
        ALTER TABLE system_settings ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
        RAISE NOTICE 'Added tenant_id column to system_settings';
    ELSE
        RAISE NOTICE 'tenant_id column already exists';
    END IF;
END $$;

-- Step 2: Drop old unique constraint if it exists (setting_key only)
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'system_settings_setting_key_key'
    ) THEN
        ALTER TABLE system_settings DROP CONSTRAINT system_settings_setting_key_key;
        RAISE NOTICE 'Dropped old unique constraint on setting_key';
    END IF;
END $$;

-- Step 3: Drop the COALESCE-based unique index if it exists (we'll use a better approach)
DROP INDEX IF EXISTS system_settings_setting_key_tenant_unique;

-- Step 4: Create a proper unique constraint that handles NULL tenant_id correctly
-- For tenant-specific settings: (setting_key, tenant_id) must be unique
-- For global settings: (setting_key) where tenant_id IS NULL must be unique
-- We'll use a partial unique index for this

-- First, create a unique index for tenant-specific settings (where tenant_id IS NOT NULL)
CREATE UNIQUE INDEX IF NOT EXISTS system_settings_setting_key_tenant_unique 
ON system_settings(setting_key, tenant_id)
WHERE tenant_id IS NOT NULL;

-- Second, create a unique index for global settings (where tenant_id IS NULL)
CREATE UNIQUE INDEX IF NOT EXISTS system_settings_setting_key_global_unique 
ON system_settings(setting_key)
WHERE tenant_id IS NULL;

-- Step 5: Create index on tenant_id for faster filtering
CREATE INDEX IF NOT EXISTS idx_system_settings_tenant_id ON system_settings(tenant_id);

-- Step 6: Verify existing data - check for any settings without tenant_id that should have one
-- This is a diagnostic query - run it to see if there are orphaned settings
SELECT 
    setting_key,
    setting_group,
    COUNT(*) as count,
    COUNT(DISTINCT tenant_id) as tenant_count
FROM system_settings
WHERE setting_group = 'company'
GROUP BY setting_key, setting_group
ORDER BY count DESC;

-- Step 7: Show current isolation status
SELECT 
    'Current Settings Distribution' as info,
    COUNT(*) FILTER (WHERE tenant_id IS NULL) as global_settings,
    COUNT(*) FILTER (WHERE tenant_id IS NOT NULL) as tenant_specific_settings,
    COUNT(DISTINCT tenant_id) FILTER (WHERE tenant_id IS NOT NULL) as unique_tenants
FROM system_settings
WHERE setting_group = 'company';

