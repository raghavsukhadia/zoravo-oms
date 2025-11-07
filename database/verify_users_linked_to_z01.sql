-- Verify that users are correctly linked to Tenant Z01
-- Run this script to check if users are properly linked

-- 1. Check if tenant Z01 exists
SELECT 
    id,
    name,
    tenant_code,
    workspace_url,
    is_active
FROM tenants
WHERE tenant_code = 'Z01' OR id = '00000000-0000-0000-0000-000000000001'::uuid
OR workspace_url = 'rs-car-accessories-nagpur'
ORDER BY created_at
LIMIT 1;

-- 2. Count users in profiles table by role
SELECT 
    role,
    COUNT(*) as total_users
FROM profiles
WHERE role IN ('installer', 'manager', 'accountant', 'coordinator', 'admin')
GROUP BY role
ORDER BY role;

-- 3. Count users linked to tenant Z01 by role
SELECT 
    tu.role,
    COUNT(*) as linked_users,
    t.name as tenant_name,
    t.tenant_code
FROM tenant_users tu
JOIN tenants t ON t.id = tu.tenant_id
WHERE t.tenant_code = 'Z01' 
   OR t.id = '00000000-0000-0000-0000-000000000001'::uuid
   OR t.workspace_url = 'rs-car-accessories-nagpur'
GROUP BY tu.role, t.name, t.tenant_code
ORDER BY tu.role;

-- 4. Find users in profiles that are NOT linked to any tenant
SELECT 
    p.id,
    p.name,
    p.email,
    p.role,
    p.created_at
FROM profiles p
WHERE p.role IN ('installer', 'manager', 'accountant', 'coordinator', 'admin')
AND NOT EXISTS (
    SELECT 1 
    FROM tenant_users tu 
    WHERE tu.user_id = p.id
)
ORDER BY p.role, p.created_at;

-- 5. Show all tenant_users entries for Z01 with user details
SELECT 
    tu.id as tenant_user_id,
    tu.role,
    tu.is_primary_admin,
    tu.created_at as linked_at,
    p.id as user_id,
    p.name as user_name,
    p.email as user_email,
    p.role as profile_role,
    t.name as tenant_name,
    t.tenant_code
FROM tenant_users tu
JOIN profiles p ON p.id = tu.user_id
JOIN tenants t ON t.id = tu.tenant_id
WHERE t.tenant_code = 'Z01' 
   OR t.id = '00000000-0000-0000-0000-000000000001'::uuid
   OR t.workspace_url = 'rs-car-accessories-nagpur'
ORDER BY tu.role, p.name;

