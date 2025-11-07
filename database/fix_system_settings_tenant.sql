-- Fix system_settings table to support tenant-specific settings
-- This script updates the unique constraint to include tenant_id

-- Drop the old unique constraint on setting_key only
DO $$ 
BEGIN
    -- Check if the unique constraint exists
    IF EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'system_settings_setting_key_key'
    ) THEN
        ALTER TABLE system_settings DROP CONSTRAINT system_settings_setting_key_key;
    END IF;
END $$;

-- Create a new unique constraint that includes tenant_id
-- This allows the same setting_key for different tenants
-- If tenant_id is NULL, it's a global setting (for super admin)
CREATE UNIQUE INDEX IF NOT EXISTS system_settings_setting_key_tenant_unique 
ON system_settings(setting_key, COALESCE(tenant_id, '00000000-0000-0000-0000-000000000000'::uuid));

-- Create index on tenant_id for faster filtering
CREATE INDEX IF NOT EXISTS idx_system_settings_tenant_id ON system_settings(tenant_id);

-- Note: The COALESCE trick allows NULL tenant_id to be treated as a specific UUID
-- This ensures global settings (NULL tenant_id) don't conflict with tenant-specific settings

