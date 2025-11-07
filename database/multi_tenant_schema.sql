-- Multi-Tenant Schema for Zoravo OMS SaaS
-- This migration adds multi-tenancy support to the existing application

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TENANTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tenants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    workspace_url VARCHAR(100) UNIQUE NOT NULL, -- e.g., "rs-car-accessories" -> rs-car-accessories.zoravo.com
    tenant_code VARCHAR(10) UNIQUE, -- e.g., "Z01", "Z02", "Z03" for easy identification
    domain VARCHAR(255), -- Full domain if custom domain is used
    is_active BOOLEAN DEFAULT true,
    is_free BOOLEAN DEFAULT false, -- "RS Car Accessories • Nagpur" will be free
    subscription_status VARCHAR(50) DEFAULT 'trial', -- trial, active, suspended, cancelled
    trial_ends_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metadata JSONB DEFAULT '{}'::jsonb -- Store additional tenant-specific settings
);

-- ============================================
-- TENANT USERS TABLE (Many-to-Many relationship)
-- ============================================
CREATE TABLE IF NOT EXISTS tenant_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL DEFAULT 'admin', -- admin, manager, coordinator, installer, accountant
    is_primary_admin BOOLEAN DEFAULT false, -- The first admin who created the tenant
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(tenant_id, user_id)
);

-- ============================================
-- SUBSCRIPTIONS TABLE (Payment tracking)
-- ============================================
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    plan_name VARCHAR(100) DEFAULT 'monthly', -- monthly, annual, etc.
    amount DECIMAL(10,2) NOT NULL DEFAULT 29.00, -- $29/month default
    currency VARCHAR(10) DEFAULT 'USD',
    status VARCHAR(50) DEFAULT 'pending', -- pending, paid, failed, refunded
    payment_provider VARCHAR(50), -- stripe, razorpay, etc.
    payment_id VARCHAR(255), -- External payment ID
    billing_period_start TIMESTAMP WITH TIME ZONE,
    billing_period_end TIMESTAMP WITH TIME ZONE,
    paid_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- SUPER ADMIN USERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS super_admins (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    can_access_all_tenants BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- ADD TENANT_ID TO ALL EXISTING TABLES
-- ============================================

-- Add tenant_id to customers (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customers') THEN
        ALTER TABLE customers ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to vehicles (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicles') THEN
        ALTER TABLE vehicles ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to vehicle_inward (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicle_inward') THEN
        ALTER TABLE vehicle_inward ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to work_orders (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'work_orders') THEN
        ALTER TABLE work_orders ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to invoices (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'invoices') THEN
        ALTER TABLE invoices ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to service_trackers (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'service_trackers') THEN
        ALTER TABLE service_trackers ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to follow_ups (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'follow_ups') THEN
        ALTER TABLE follow_ups ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to requirements (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'requirements') THEN
        ALTER TABLE requirements ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to payments (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'payments') THEN
        ALTER TABLE payments ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to profiles (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'profiles') THEN
        ALTER TABLE profiles ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE SET NULL;
    END IF;
END $$;

-- Add tenant_id to system_settings (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'system_settings') THEN
        ALTER TABLE system_settings ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to locations (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'locations') THEN
        ALTER TABLE locations ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to vehicle_types (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicle_types') THEN
        ALTER TABLE vehicle_types ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- Add tenant_id to departments (if exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'departments') THEN
        ALTER TABLE departments ADD COLUMN IF NOT EXISTS tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
    END IF;
END $$;

-- ============================================
-- CREATE INDEXES FOR PERFORMANCE
-- ============================================

-- Tenant indexes
CREATE INDEX IF NOT EXISTS idx_tenants_workspace_url ON tenants(workspace_url);
CREATE INDEX IF NOT EXISTS idx_tenants_is_active ON tenants(is_active);
CREATE INDEX IF NOT EXISTS idx_tenants_subscription_status ON tenants(subscription_status);

-- Tenant users indexes
CREATE INDEX IF NOT EXISTS idx_tenant_users_tenant_id ON tenant_users(tenant_id);
CREATE INDEX IF NOT EXISTS idx_tenant_users_user_id ON tenant_users(user_id);
CREATE INDEX IF NOT EXISTS idx_tenant_users_role ON tenant_users(role);

-- Subscription indexes
CREATE INDEX IF NOT EXISTS idx_subscriptions_tenant_id ON subscriptions(tenant_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_billing_period ON subscriptions(billing_period_start, billing_period_end);

-- Super admin index
CREATE INDEX IF NOT EXISTS idx_super_admins_user_id ON super_admins(user_id);
CREATE INDEX IF NOT EXISTS idx_super_admins_email ON super_admins(email);

-- Data isolation indexes (tenant_id on all tables - only if table exists)
DO $$ 
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customers') THEN
        CREATE INDEX IF NOT EXISTS idx_customers_tenant_id ON customers(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicles') THEN
        CREATE INDEX IF NOT EXISTS idx_vehicles_tenant_id ON vehicles(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'vehicle_inward') THEN
        CREATE INDEX IF NOT EXISTS idx_vehicle_inward_tenant_id ON vehicle_inward(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'work_orders') THEN
        CREATE INDEX IF NOT EXISTS idx_work_orders_tenant_id ON work_orders(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'invoices') THEN
        CREATE INDEX IF NOT EXISTS idx_invoices_tenant_id ON invoices(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'service_trackers') THEN
        CREATE INDEX IF NOT EXISTS idx_service_trackers_tenant_id ON service_trackers(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'follow_ups') THEN
        CREATE INDEX IF NOT EXISTS idx_follow_ups_tenant_id ON follow_ups(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'requirements') THEN
        CREATE INDEX IF NOT EXISTS idx_requirements_tenant_id ON requirements(tenant_id);
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'payments') THEN
        CREATE INDEX IF NOT EXISTS idx_payments_tenant_id ON payments(tenant_id);
    END IF;
END $$;

-- ============================================
-- CREATE TRIGGERS FOR UPDATED_AT
-- ============================================
-- Drop existing triggers if they exist, then create new ones

DROP TRIGGER IF EXISTS update_tenants_updated_at ON tenants;
CREATE TRIGGER update_tenants_updated_at BEFORE UPDATE ON tenants 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_tenant_users_updated_at ON tenant_users;
CREATE TRIGGER update_tenant_users_updated_at BEFORE UPDATE ON tenant_users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_subscriptions_updated_at ON subscriptions;
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- CREATE DEFAULT TENANT (RS Car Accessories • Nagpur)
-- ============================================
-- This will be the free tenant
INSERT INTO tenants (id, name, workspace_url, tenant_code, is_active, is_free, subscription_status)
VALUES (
    '00000000-0000-0000-0000-000000000001'::uuid,
    'RS Car Accessories • Nagpur',
    'rs-car-accessories-nagpur',
    'Z01',
    true,
    true,
    'active'
)
ON CONFLICT (workspace_url) DO UPDATE SET tenant_code = COALESCE(tenants.tenant_code, 'Z01');

-- ============================================
-- HELPER FUNCTIONS (MUST BE CREATED BEFORE POLICIES)
-- ============================================

-- Function to check if user is super admin
-- Returns true if user is in super_admins table OR is admin in RS Car Accessories tenant
-- Uses SECURITY DEFINER to bypass RLS and prevent infinite recursion
CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
DECLARE
    RS_CAR_TENANT_ID UUID := '00000000-0000-0000-0000-000000000001'::uuid;
BEGIN
    -- Check if user is in super_admins table (bypasses RLS due to SECURITY DEFINER)
    IF EXISTS (
        SELECT 1 FROM super_admins 
        WHERE user_id = auth.uid()
    ) THEN
        RETURN true;
    END IF;
    
    -- Check if user is admin in RS Car Accessories tenant (bypasses RLS due to SECURITY DEFINER)
    IF EXISTS (
        SELECT 1 FROM tenant_users 
        WHERE user_id = auth.uid() 
        AND tenant_id = RS_CAR_TENANT_ID 
        AND role = 'admin'
    ) THEN
        RETURN true;
    END IF;
    
    RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Helper function to get user's tenant IDs (bypasses RLS)
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

-- Function to get current user's tenant_id
CREATE OR REPLACE FUNCTION get_user_tenant_id()
RETURNS UUID AS $$
DECLARE
    tenant_uuid UUID;
BEGIN
    SELECT tenant_id INTO tenant_uuid
    FROM tenant_users
    WHERE user_id = auth.uid()
    LIMIT 1;
    
    RETURN tenant_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user's tenants (for super admin, returns all)
CREATE OR REPLACE FUNCTION get_user_tenants()
RETURNS TABLE (
    tenant_id UUID,
    tenant_name VARCHAR,
    workspace_url VARCHAR,
    role VARCHAR,
    is_primary_admin BOOLEAN
) AS $$
BEGIN
    IF is_super_admin() THEN
        RETURN QUERY
        SELECT 
            t.id as tenant_id,
            t.name as tenant_name,
            t.workspace_url,
            'super_admin'::VARCHAR as role,
            false as is_primary_admin
        FROM tenants t
        WHERE t.is_active = true;
    ELSE
        RETURN QUERY
        SELECT 
            tu.tenant_id,
            t.name as tenant_name,
            t.workspace_url,
            tu.role,
            tu.is_primary_admin
        FROM tenant_users tu
        JOIN tenants t ON t.id = tu.tenant_id
        WHERE tu.user_id = auth.uid() AND t.is_active = true;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================
-- Enable RLS on tenant tables
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE super_admins ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist, then create new ones
DROP POLICY IF EXISTS "Users can view their tenants" ON tenants;
DROP POLICY IF EXISTS "Super admins can view all tenants" ON tenants;
DROP POLICY IF EXISTS "Users can view their tenant_users" ON tenant_users;
DROP POLICY IF EXISTS "Super admins can view all subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Tenant admins can view their subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Super admins can view all super admins" ON super_admins;

-- Policy: Users can only see tenants they belong to
-- Also allows RS Car Accessories admins and super admins to see all tenants
-- Uses is_super_admin() function to avoid infinite recursion
CREATE POLICY "Users can view their tenants" ON tenants
    FOR SELECT
    USING (
        id = ANY(get_user_tenant_ids())
        OR is_super_admin()
    );

-- Policy: Super admins and RS Car Accessories admins can view all tenants
-- Uses is_super_admin() function to avoid infinite recursion
CREATE POLICY "Super admins can view all tenants" ON tenants
    FOR SELECT
    USING (is_super_admin());

-- Policy: Users can view their tenant_users relationships
-- Also allows RS Car Accessories admins and super admins to view all
-- Uses is_super_admin() and get_user_tenant_ids() functions to avoid infinite recursion
CREATE POLICY "Users can view their tenant_users" ON tenant_users
    FOR SELECT
    USING (
        user_id = auth.uid()
        OR tenant_id = ANY(get_user_tenant_ids())
        OR is_super_admin()
    );

-- Policy: Super admins and RS Car Accessories admins can view all subscriptions
-- Uses is_super_admin() function to avoid infinite recursion
CREATE POLICY "Super admins can view all subscriptions" ON subscriptions
    FOR SELECT
    USING (is_super_admin());

-- Policy: Users can view their tenant's subscriptions
-- Uses get_user_tenant_ids() function to avoid infinite recursion
CREATE POLICY "Tenant admins can view their subscriptions" ON subscriptions
    FOR SELECT
    USING (tenant_id = ANY(get_user_tenant_ids()));

-- Policy: Super admins can view all super_admins
-- Uses is_super_admin() function to avoid infinite recursion
CREATE POLICY "Super admins can view all super admins" ON super_admins
    FOR SELECT
    USING (is_super_admin());

-- Note: Helper functions are now defined BEFORE the RLS policies section above

