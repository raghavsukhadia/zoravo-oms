-- Create subscription_plan_requests table for tenant subscription requests
CREATE TABLE IF NOT EXISTS subscription_plan_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE, -- Admin who requested
    plan_name VARCHAR(100) NOT NULL, -- Reference to plan from system_settings
    plan_display_name VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    billing_cycle VARCHAR(50), -- monthly, quarterly, annual
    status VARCHAR(50) DEFAULT 'pending', -- pending, approved, rejected
    requested_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    reviewed_by UUID REFERENCES auth.users(id), -- Super admin who reviewed
    reviewed_at TIMESTAMP WITH TIME ZONE,
    rejection_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add index for faster queries
CREATE INDEX IF NOT EXISTS idx_subscription_plan_requests_tenant_id ON subscription_plan_requests(tenant_id);
CREATE INDEX IF NOT EXISTS idx_subscription_plan_requests_status ON subscription_plan_requests(status);

-- Add RLS policies
ALTER TABLE subscription_plan_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Super admins can view all requests
CREATE POLICY "Super admins can view all subscription plan requests"
    ON subscription_plan_requests
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM super_admins
            WHERE super_admins.user_id = auth.uid()
        )
    );

-- Policy: Tenant admins can view their own tenant's requests
CREATE POLICY "Tenant admins can view their tenant's subscription plan requests"
    ON subscription_plan_requests
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM tenant_users
            WHERE tenant_users.user_id = auth.uid()
            AND tenant_users.tenant_id = subscription_plan_requests.tenant_id
            AND tenant_users.role = 'admin'
        )
    );

-- Policy: Tenant admins can create requests for their tenant
CREATE POLICY "Tenant admins can create subscription plan requests"
    ON subscription_plan_requests
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM tenant_users
            WHERE tenant_users.user_id = auth.uid()
            AND tenant_users.tenant_id = subscription_plan_requests.tenant_id
            AND tenant_users.role = 'admin'
        )
    );

-- Policy: Super admins can update requests
CREATE POLICY "Super admins can update subscription plan requests"
    ON subscription_plan_requests
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM super_admins
            WHERE super_admins.user_id = auth.uid()
        )
    );

