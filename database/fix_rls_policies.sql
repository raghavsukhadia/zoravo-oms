-- Fix RLS Policies to Prevent Infinite Recursion
-- Run this script to fix the infinite recursion issue in RLS policies

-- First, ensure the helper functions exist
CREATE OR REPLACE FUNCTION get_user_tenant_ids()
RETURNS UUID[] AS $$
DECLARE
    tenant_ids UUID[];
BEGIN
    SELECT ARRAY_AGG(tenant_id) INTO tenant_ids
    FROM tenant_users
    WHERE user_id = auth.uid();
    
    RETURN COALESCE(tenant_ids, ARRAY[]::UUID[]);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop and recreate all policies using the helper functions
DROP POLICY IF EXISTS "Users can view their tenants" ON tenants;
DROP POLICY IF EXISTS "Super admins can view all tenants" ON tenants;
DROP POLICY IF EXISTS "Users can view their tenant_users" ON tenant_users;
DROP POLICY IF EXISTS "Super admins can view all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Tenant admins can view their subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Super admins can view all super admins" ON super_admins;

-- Policy: Users can only see tenants they belong to
-- Uses is_super_admin() and get_user_tenant_ids() functions to avoid infinite recursion
CREATE POLICY "Users can view their tenants" ON tenants
    FOR SELECT
    USING (
        id = ANY(get_user_tenant_ids())
        OR is_super_admin()
    );

-- Policy: Super admins and RS Car Accessories admins can view all tenants
CREATE POLICY "Super admins can view all tenants" ON tenants
    FOR SELECT
    USING (is_super_admin());

-- Policy: Users can view their tenant_users relationships
CREATE POLICY "Users can view their tenant_users" ON tenant_users
    FOR SELECT
    USING (
        user_id = auth.uid()
        OR tenant_id = ANY(get_user_tenant_ids())
        OR is_super_admin()
    );

-- Policy: Super admins and RS Car Accessories admins can view all subscriptions
CREATE POLICY "Super admins can view all subscriptions" ON subscriptions
    FOR SELECT
    USING (is_super_admin());

-- Policy: Users can view their tenant's subscriptions
CREATE POLICY "Tenant admins can view their subscriptions" ON subscriptions
    FOR SELECT
    USING (tenant_id = ANY(get_user_tenant_ids()));

-- Policy: Super admins can view all super_admins
CREATE POLICY "Super admins can view all super admins" ON super_admins
    FOR SELECT
    USING (is_super_admin());

-- Verify policies are created
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename IN ('tenants', 'tenant_users', 'subscriptions', 'super_admins')
ORDER BY tablename, policyname;
