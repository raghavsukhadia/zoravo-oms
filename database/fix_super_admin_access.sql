-- Quick Fix: Ensure raghav@sunkool.in has super admin access
-- Run this script to fix super admin access issues

-- This script will:
-- 1. Add user to RS Car Accessories tenant as admin (if not already)
-- 2. Ensure super_admin record exists (if not already)

DO $$
DECLARE
    v_user_id UUID;
    v_tenant_id UUID := '00000000-0000-0000-0000-000000000001'::uuid;
    v_email TEXT := 'raghav@sunkool.in';
BEGIN
    -- Get user_id from email
    SELECT id INTO v_user_id
    FROM auth.users
    WHERE email = v_email;
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User % not found in auth.users. Please create the user first.', v_email;
    END IF;
    
    RAISE NOTICE 'Found user: % (ID: %)', v_email, v_user_id;
    
    -- Ensure user is admin in RS Car Accessories tenant
    INSERT INTO tenant_users (tenant_id, user_id, role, is_primary_admin)
    VALUES (v_tenant_id, v_user_id, 'admin', true)
    ON CONFLICT (tenant_id, user_id) 
    DO UPDATE SET 
        role = 'admin',
        is_primary_admin = true;
    
    RAISE NOTICE 'User added/updated as admin in RS Car Accessories tenant';
    
    -- Ensure super_admin record exists (optional but recommended)
    INSERT INTO super_admins (user_id, email, can_access_all_tenants)
    VALUES (v_user_id, v_email, true)
    ON CONFLICT (user_id) DO NOTHING;
    
    RAISE NOTICE 'Super admin record verified';
    
    RAISE NOTICE 'SUCCESS: % now has super admin access!', v_email;
END $$;

-- Verify the setup
SELECT 
    'Verification' as check_type,
    u.email,
    CASE WHEN sa.id IS NOT NULL THEN 'Yes' ELSE 'No' END as in_super_admins,
    CASE WHEN tu.role = 'admin' THEN 'Yes (Admin)' ELSE COALESCE(tu.role, 'No') END as in_rs_car_tenant
FROM auth.users u
LEFT JOIN super_admins sa ON sa.user_id = u.id
LEFT JOIN tenant_users tu ON tu.user_id = u.id AND tu.tenant_id = '00000000-0000-0000-0000-000000000001'::uuid
WHERE u.email = 'raghav@sunkool.in';

