-- Check and Fix Super Admin Access for raghav@sunkool.in
-- This script checks the current state and fixes super admin access

-- Step 1: Check if user exists in auth.users
SELECT 
    id,
    email,
    created_at
FROM auth.users
WHERE email = 'raghav@sunkool.in';

-- Step 2: Check if user is in super_admins table
SELECT 
    sa.id,
    sa.user_id,
    sa.email,
    sa.can_access_all_tenants,
    sa.created_at
FROM super_admins sa
JOIN auth.users u ON u.id = sa.user_id
WHERE u.email = 'raghav@sunkool.in';

-- Step 3: Check if user is admin in RS Car Accessories tenant
SELECT 
    tu.id,
    tu.tenant_id,
    tu.user_id,
    tu.role,
    tu.is_primary_admin,
    t.name as tenant_name,
    t.workspace_url
FROM tenant_users tu
JOIN tenants t ON t.id = tu.tenant_id
JOIN auth.users u ON u.id = tu.user_id
WHERE u.email = 'raghav@sunkool.in'
AND t.workspace_url = 'rs-car-accessories-nagpur';

-- Step 4: Fix - Ensure user is admin in RS Car Accessories tenant
-- First, get the user_id and tenant_id
DO $$
DECLARE
    v_user_id UUID;
    v_tenant_id UUID := '00000000-0000-0000-0000-000000000001'::uuid;
BEGIN
    -- Get user_id
    SELECT id INTO v_user_id
    FROM auth.users
    WHERE email = 'raghav@sunkool.in';
    
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User raghav@sunkool.in not found in auth.users';
    END IF;
    
    -- Check if user is already in tenant_users for RS Car Accessories
    IF NOT EXISTS (
        SELECT 1 FROM tenant_users 
        WHERE user_id = v_user_id 
        AND tenant_id = v_tenant_id
    ) THEN
        -- Insert user as admin in RS Car Accessories tenant
        INSERT INTO tenant_users (tenant_id, user_id, role, is_primary_admin)
        VALUES (v_tenant_id, v_user_id, 'admin', true)
        ON CONFLICT (tenant_id, user_id) DO UPDATE
        SET role = 'admin', is_primary_admin = true;
        
        RAISE NOTICE 'Added raghav@sunkool.in as admin to RS Car Accessories tenant';
    ELSE
        -- Update existing record to ensure role is admin
        UPDATE tenant_users
        SET role = 'admin', is_primary_admin = true
        WHERE user_id = v_user_id 
        AND tenant_id = v_tenant_id;
        
        RAISE NOTICE 'Updated raghav@sunkool.in role to admin in RS Car Accessories tenant';
    END IF;
    
    -- Ensure super_admin record exists (optional, but good to have)
    INSERT INTO super_admins (user_id, email, can_access_all_tenants)
    VALUES (v_user_id, 'raghav@sunkool.in', true)
    ON CONFLICT (user_id) DO NOTHING;
    
    RAISE NOTICE 'Super admin access verified for raghav@sunkool.in';
END $$;

-- Step 5: Verify the fix
SELECT 
    'Super Admin Check' as check_type,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM super_admins sa
            JOIN auth.users u ON u.id = sa.user_id
            WHERE u.email = 'raghav@sunkool.in'
        ) THEN '✓ User is in super_admins table'
        ELSE '✗ User NOT in super_admins table'
    END as status
UNION ALL
SELECT 
    'RS Car Accessories Admin Check' as check_type,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM tenant_users tu
            JOIN tenants t ON t.id = tu.tenant_id
            JOIN auth.users u ON u.id = tu.user_id
            WHERE u.email = 'raghav@sunkool.in'
            AND t.workspace_url = 'rs-car-accessories-nagpur'
            AND tu.role = 'admin'
        ) THEN '✓ User is admin in RS Car Accessories tenant'
        ELSE '✗ User is NOT admin in RS Car Accessories tenant'
    END as status;

