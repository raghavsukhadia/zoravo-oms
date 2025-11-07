-- Add UPDATE policy for super admins on tenants table
-- This allows super admins to update tenant status (is_active, subscription_status, etc.)

-- Drop existing UPDATE policy if it exists
DROP POLICY IF EXISTS "Super admins can update tenants" ON tenants;

-- Policy: Super admins can update all tenants
-- Uses is_super_admin() function to avoid infinite recursion
CREATE POLICY "Super admins can update tenants" ON tenants
    FOR UPDATE
    USING (is_super_admin())
    WITH CHECK (is_super_admin());

-- Verify the policy was created
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies
WHERE tablename = 'tenants' AND cmd = 'UPDATE';

