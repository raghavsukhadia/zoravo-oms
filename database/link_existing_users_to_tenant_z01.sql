-- Link existing users to Tenant Z01 (RS Car Accessories)
-- This script links all existing installers, managers, accountants, and coordinators
-- that don't have tenant_users entries to the default tenant (Z01)
-- It preserves the original role from the profiles table

DO $$
DECLARE
    default_tenant_id UUID;
    user_record RECORD;
    linked_count INTEGER := 0;
    skipped_count INTEGER := 0;
BEGIN
    -- Get the default tenant ID (Z01 - RS Car Accessories)
    -- Try tenant_code first, then fallback to the hardcoded UUID
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
    
    RAISE NOTICE 'Linking users to tenant: % (Z01)', default_tenant_id;
    
    -- Find all users in profiles table that don't have tenant_users entries
    -- and link them to the default tenant, preserving their original role
    FOR user_record IN
        SELECT p.id as user_id, p.role, p.name, p.email
        FROM profiles p
        WHERE p.role IN ('installer', 'manager', 'accountant', 'coordinator', 'admin')
        AND NOT EXISTS (
            SELECT 1 
            FROM tenant_users tu 
            WHERE tu.user_id = p.id
        )
    LOOP
        -- Insert into tenant_users table, preserving the original role
        BEGIN
            INSERT INTO tenant_users (tenant_id, user_id, role, is_primary_admin)
            VALUES (
                default_tenant_id,
                user_record.user_id,
                user_record.role, -- Preserve original role
                CASE 
                    WHEN user_record.role = 'admin' THEN true 
                    ELSE false 
                END
            )
            ON CONFLICT (tenant_id, user_id) DO NOTHING;
            
            linked_count := linked_count + 1;
            
            RAISE NOTICE '✅ Linked user % (name: %, role: %, email: %) to tenant Z01', 
                user_record.user_id, 
                COALESCE(user_record.name, 'N/A'),
                user_record.role,
                COALESCE(user_record.email, 'N/A');
        EXCEPTION WHEN OTHERS THEN
            skipped_count := skipped_count + 1;
            RAISE WARNING '⚠️ Failed to link user %: %', user_record.user_id, SQLERRM;
        END;
    END LOOP;
    
    RAISE NOTICE '';
    RAISE NOTICE '========================================';
    RAISE NOTICE '✅ Successfully linked % users to tenant Z01', linked_count;
    IF skipped_count > 0 THEN
        RAISE NOTICE '⚠️ Skipped % users due to errors', skipped_count;
    END IF;
    RAISE NOTICE '========================================';
END $$;

-- Verify the results
SELECT 
    tu.role,
    COUNT(*) as user_count,
    t.name as tenant_name,
    t.tenant_code
FROM tenant_users tu
JOIN tenants t ON t.id = tu.tenant_id
WHERE t.tenant_code = 'Z01' OR t.id = '00000000-0000-0000-0000-000000000001'::uuid
GROUP BY tu.role, t.name, t.tenant_code
ORDER BY tu.role;

SELECT '✅ Migration completed! All existing users have been linked to tenant Z01.' as result;

