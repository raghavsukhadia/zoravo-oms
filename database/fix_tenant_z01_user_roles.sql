-- Fix: Update tenant_users.role for existing users in Tenant Z01
-- This script corrects the 'role' in the tenant_users table for users
-- linked to the default tenant (Z01) to match their actual role in the profiles table.

DO $$
DECLARE
    default_tenant_id UUID;
    updated_count INTEGER := 0;
    user_record RECORD;
BEGIN
    -- Get the default tenant ID (Z01 - RS Car Accessories)
    SELECT id INTO default_tenant_id
    FROM tenants
    WHERE (tenant_code = 'Z01' OR id = '00000000-0000-0000-0000-000000000001'::uuid)
    AND workspace_url = 'rs-car-accessories-nagpur'
    LIMIT 1;
    
    -- If still not found, try just the UUID
    IF default_tenant_id IS NULL THEN
        SELECT id INTO default_tenant_id
        FROM tenants
        WHERE id = '00000000-0000-0000-0000-000000000001'::uuid
        LIMIT 1;
    END IF;
    
    -- If still not found, try workspace_url
    IF default_tenant_id IS NULL THEN
        SELECT id INTO default_tenant_id
        FROM tenants
        WHERE workspace_url = 'rs-car-accessories-nagpur'
        LIMIT 1;
    END IF;
    
    IF default_tenant_id IS NULL THEN
        RAISE EXCEPTION 'Default tenant (Z01 - RS Car Accessories) not found. Please ensure the tenant exists.';
    END IF;
    
    RAISE NOTICE 'Fixing tenant_users roles for tenant: % (Z01)', default_tenant_id;
    RAISE NOTICE '';
    
    -- Update the role in tenant_users to match the role in profiles
    -- Only update if the roles are different
    -- NOTE: Cast p.role (enum) to text for comparison with tu.role (varchar)
    FOR user_record IN
        SELECT 
            tu.id as tenant_user_id,
            tu.user_id,
            tu.role as current_tenant_role,
            p.role::text as correct_profile_role,
            p.name as user_name,
            p.email as user_email
        FROM tenant_users tu
        JOIN profiles p ON p.id = tu.user_id
        WHERE tu.tenant_id = default_tenant_id
        AND tu.role <> p.role::text -- Cast enum to text for comparison
        AND p.role::text IN ('installer', 'manager', 'accountant', 'coordinator', 'admin')
    LOOP
        -- Update the role
        UPDATE tenant_users
        SET role = user_record.correct_profile_role,
            updated_at = NOW()
        WHERE id = user_record.tenant_user_id;
        
        updated_count := updated_count + 1;
        
        RAISE NOTICE '✅ Updated user % (name: %, email: %) from role "%" to "%"', 
            user_record.user_id,
            COALESCE(user_record.user_name, 'N/A'),
            COALESCE(user_record.user_email, 'N/A'),
            user_record.current_tenant_role,
            user_record.correct_profile_role;
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE '✅ Successfully updated % user roles for tenant Z01', updated_count;
    RAISE NOTICE '========================================';
END $$;

-- Verify the updated roles
SELECT 
    tu.role as tenant_users_role,
    p.role::text as profiles_role,
    p.name as user_name,
    p.email as user_email,
    CASE 
        WHEN tu.role = p.role::text THEN '✅ Match'
        ELSE '❌ Mismatch'
    END as status,
    t.name as tenant_name,
    t.tenant_code
FROM tenant_users tu
JOIN profiles p ON p.id = tu.user_id
JOIN tenants t ON t.id = tu.tenant_id
WHERE t.tenant_code = 'Z01' 
   OR t.id = '00000000-0000-0000-0000-000000000001'::uuid
   OR t.workspace_url = 'rs-car-accessories-nagpur'
ORDER BY tu.role, p.name;

-- Summary by role
SELECT 
    tu.role,
    COUNT(*) as user_count,
    t.tenant_code
FROM tenant_users tu
JOIN tenants t ON t.id = tu.tenant_id
WHERE t.tenant_code = 'Z01' 
   OR t.id = '00000000-0000-0000-0000-000000000001'::uuid
   OR t.workspace_url = 'rs-car-accessories-nagpur'
GROUP BY tu.role, t.tenant_code
ORDER BY tu.role;

SELECT '✅ Role fix completed! All tenant_users roles now match profiles roles for tenant Z01.' as result;

