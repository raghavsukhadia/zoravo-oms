-- Setup script for Multi-Tenant Zoravo OMS
-- Run this after applying multi_tenant_schema.sql

-- ============================================
-- 1. CREATE DEFAULT TENANT (RS Car Accessories • Nagpur)
-- ============================================
INSERT INTO tenants (id, name, workspace_url, is_active, is_free, subscription_status)
VALUES (
    '00000000-0000-0000-0000-000000000001'::uuid,
    'RS Car Accessories • Nagpur',
    'rs-car-accessories-nagpur',
    true,
    true,
    'active'
)
ON CONFLICT (workspace_url) DO NOTHING;

-- ============================================
-- 2. MIGRATE EXISTING DATA TO DEFAULT TENANT
-- ============================================
-- Update all existing records to belong to the default tenant
-- This assumes you have existing data that needs to be migrated

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customers') THEN
        UPDATE customers 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicles') THEN
        UPDATE vehicles 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicle_inward') THEN
        UPDATE vehicle_inward 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'work_orders') THEN
        UPDATE work_orders 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'invoices') THEN
        UPDATE invoices 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'service_trackers') THEN
        UPDATE service_trackers 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'follow_ups') THEN
        UPDATE follow_ups 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'requirements') THEN
        UPDATE requirements 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
    
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'payments') THEN
        UPDATE payments 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
END $$;

-- Update profiles if exists
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'profiles') THEN
        UPDATE profiles 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
END $$;

-- Update system_settings if exists
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'system_settings') THEN
        UPDATE system_settings 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
END $$;

-- Update locations if exists
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'locations') THEN
        UPDATE locations 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
END $$;

-- Update vehicle_types if exists
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicle_types') THEN
        UPDATE vehicle_types 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
END $$;

-- Update departments if exists
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'departments') THEN
        UPDATE departments 
        SET tenant_id = '00000000-0000-0000-0000-000000000001'::uuid 
        WHERE tenant_id IS NULL;
    END IF;
END $$;

-- ============================================
-- 3. LINK EXISTING USERS TO DEFAULT TENANT
-- ============================================
-- This will link all existing users in the profiles table to the default tenant
-- You may need to adjust this based on your user structure

DO $$ 
DECLARE
    user_record RECORD;
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'profiles') THEN
        FOR user_record IN 
            SELECT id FROM profiles WHERE id NOT IN (SELECT user_id FROM tenant_users)
        LOOP
            INSERT INTO tenant_users (tenant_id, user_id, role, is_primary_admin)
            VALUES (
                '00000000-0000-0000-0000-000000000001'::uuid,
                user_record.id,
                'admin',
                false
            )
            ON CONFLICT (tenant_id, user_id) DO NOTHING;
        END LOOP;
    END IF;
END $$;

-- ============================================
-- 4. CREATE SUPER ADMIN (for raghav@sunkool.in)
-- ============================================
-- First, ensure the user exists in auth.users
-- Then create the super admin record
-- Note: Replace 'USER_ID_HERE' with the actual user ID from auth.users

-- To find the user ID, run:
-- SELECT id, email FROM auth.users WHERE email = 'raghav@sunkool.in';

-- Then run:
-- INSERT INTO super_admins (user_id, email, can_access_all_tenants)
-- VALUES ('USER_ID_HERE', 'raghav@sunkool.in', true)
-- ON CONFLICT (user_id) DO NOTHING;

-- ============================================
-- 5. VERIFY SETUP
-- ============================================
-- Run these queries to verify everything is set up correctly:

-- Check default tenant exists
SELECT * FROM tenants WHERE workspace_url = 'rs-car-accessories-nagpur';

-- Check tenant_users are linked
SELECT COUNT(*) as user_count FROM tenant_users WHERE tenant_id = '00000000-0000-0000-0000-000000000001'::uuid;

-- Check data migration
SELECT 
    'customers' as table_name, 
    COUNT(*) as total_records,
    COUNT(*) FILTER (WHERE tenant_id IS NOT NULL) as with_tenant_id
FROM customers
UNION ALL
SELECT 'vehicles', COUNT(*), COUNT(*) FILTER (WHERE tenant_id IS NOT NULL) FROM vehicles
UNION ALL
SELECT 'vehicle_inward', COUNT(*), COUNT(*) FILTER (WHERE tenant_id IS NOT NULL) FROM vehicle_inward;

-- Check super admin
SELECT * FROM super_admins;

