-- Add payment proof and approval request tables for tenant management

-- Table to store payment proof submissions from tenants
CREATE TABLE IF NOT EXISTS tenant_payment_proofs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    admin_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    payment_proof_url TEXT NOT NULL, -- URL to uploaded payment proof image/document
    amount DECIMAL(10,2) NOT NULL DEFAULT 12000.00, -- ₹12,000 INR per year
    currency VARCHAR(10) DEFAULT 'INR',
    payment_date DATE,
    transaction_id VARCHAR(255), -- Bank transaction ID or reference number
    notes TEXT,
    status VARCHAR(50) DEFAULT 'pending', -- pending, approved, rejected
    reviewed_by UUID REFERENCES auth.users(id), -- Super admin who reviewed
    reviewed_at TIMESTAMP WITH TIME ZONE,
    rejection_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table to store tenant approval requests (sent when new tenant is created)
CREATE TABLE IF NOT EXISTS tenant_approval_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    admin_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    admin_name VARCHAR(255) NOT NULL,
    admin_email VARCHAR(255) NOT NULL,
    admin_phone VARCHAR(50),
    company_name VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending', -- pending, approved, rejected
    reviewed_by UUID REFERENCES auth.users(id), -- Super admin who reviewed
    reviewed_at TIMESTAMP WITH TIME ZONE,
    rejection_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_payment_proofs_tenant_id ON tenant_payment_proofs(tenant_id);
CREATE INDEX IF NOT EXISTS idx_payment_proofs_status ON tenant_payment_proofs(status);
CREATE INDEX IF NOT EXISTS idx_approval_requests_tenant_id ON tenant_approval_requests(tenant_id);
CREATE INDEX IF NOT EXISTS idx_approval_requests_status ON tenant_approval_requests(status);

-- Add RLS policies
ALTER TABLE tenant_payment_proofs ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_approval_requests ENABLE ROW LEVEL SECURITY;

-- Policy: Tenants can view their own payment proofs
CREATE POLICY "Tenants can view their payment proofs" ON tenant_payment_proofs
    FOR SELECT
    USING (
        tenant_id IN (
            SELECT tenant_id FROM tenant_users WHERE user_id = auth.uid()
        )
    );

-- Policy: Tenant admins can insert their own payment proofs
CREATE POLICY "Tenant admins can insert payment proofs" ON tenant_payment_proofs
    FOR INSERT
    WITH CHECK (
        tenant_id IN (
            SELECT tenant_id FROM tenant_users 
            WHERE user_id = auth.uid() AND role = 'admin'
        )
    );

-- Policy: Super admins can view all payment proofs
CREATE POLICY "Super admins can view all payment proofs" ON tenant_payment_proofs
    FOR SELECT
    USING (is_super_admin());

-- Policy: Super admins can update payment proofs (approve/reject)
CREATE POLICY "Super admins can update payment proofs" ON tenant_payment_proofs
    FOR UPDATE
    USING (is_super_admin());

-- Policy: Super admins can view all approval requests
CREATE POLICY "Super admins can view all approval requests" ON tenant_approval_requests
    FOR SELECT
    USING (is_super_admin());

-- Policy: Super admins can update approval requests (approve/reject)
CREATE POLICY "Super admins can update approval requests" ON tenant_approval_requests
    FOR UPDATE
    USING (is_super_admin());

-- Add trigger for updated_at
CREATE TRIGGER update_payment_proofs_updated_at BEFORE UPDATE ON tenant_payment_proofs 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_approval_requests_updated_at BEFORE UPDATE ON tenant_approval_requests 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

