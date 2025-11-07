-- Add tenant_id to customer_requirements table and related tables for multi-tenancy support
-- This script ensures all customer_requirements related tables have tenant_id column

DO $$ 
BEGIN
    -- Check if customer_requirements table exists
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements') THEN
        -- Add tenant_id column if it doesn't exist
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'customer_requirements' 
            AND column_name = 'tenant_id'
        ) THEN
            ALTER TABLE customer_requirements 
            ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
            
            RAISE NOTICE 'Added tenant_id column to customer_requirements table';
        ELSE
            RAISE NOTICE 'tenant_id column already exists in customer_requirements table';
        END IF;
        
        -- Create index on tenant_id for better performance
        CREATE INDEX IF NOT EXISTS idx_customer_requirements_tenant_id ON customer_requirements(tenant_id);
        
        RAISE NOTICE 'Created index on tenant_id for customer_requirements table';
    ELSE
        RAISE NOTICE 'customer_requirements table does not exist - skipping';
    END IF;
    
    -- Also add tenant_id to customer_requirements_comments if it exists
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements_comments') THEN
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'customer_requirements_comments' 
            AND column_name = 'tenant_id'
        ) THEN
            ALTER TABLE customer_requirements_comments 
            ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
            
            CREATE INDEX IF NOT EXISTS idx_customer_requirements_comments_tenant_id ON customer_requirements_comments(tenant_id);
            
            RAISE NOTICE 'Added tenant_id column to customer_requirements_comments table';
        END IF;
    END IF;
    
    -- Also add tenant_id to customer_requirements_attachments if it exists
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements_attachments') THEN
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'customer_requirements_attachments' 
            AND column_name = 'tenant_id'
        ) THEN
            ALTER TABLE customer_requirements_attachments 
            ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
            
            CREATE INDEX IF NOT EXISTS idx_customer_requirements_attachments_tenant_id ON customer_requirements_attachments(tenant_id);
            
            RAISE NOTICE 'Added tenant_id column to customer_requirements_attachments table';
        END IF;
    END IF;
    
    -- Also add tenant_id to customer_requirements_comment_attachments if it exists
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements_comment_attachments') THEN
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'customer_requirements_comment_attachments' 
            AND column_name = 'tenant_id'
        ) THEN
            ALTER TABLE customer_requirements_comment_attachments 
            ADD COLUMN tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE;
            
            CREATE INDEX IF NOT EXISTS idx_customer_requirements_comment_attachments_tenant_id ON customer_requirements_comment_attachments(tenant_id);
            
            RAISE NOTICE 'Added tenant_id column to customer_requirements_comment_attachments table';
        END IF;
    END IF;
END $$;

-- Update existing records to default tenant (if any exist without tenant_id)
-- Only update if there's a default tenant
DO $$ 
DECLARE
    default_tenant_id UUID;
BEGIN
    -- Get the default tenant ID (RS Car Accessories)
    SELECT id INTO default_tenant_id 
    FROM tenants 
    WHERE tenant_code = 'Z01' OR name LIKE '%RS Car Accessories%'
    LIMIT 1;
    
    -- If default tenant exists, update NULL tenant_ids in all related tables
    IF default_tenant_id IS NOT NULL THEN
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements') THEN
            UPDATE customer_requirements 
            SET tenant_id = default_tenant_id 
            WHERE tenant_id IS NULL;
            
            RAISE NOTICE 'Updated existing customer_requirements records to default tenant';
        END IF;
        
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements_comments') THEN
            UPDATE customer_requirements_comments 
            SET tenant_id = default_tenant_id 
            WHERE tenant_id IS NULL;
        END IF;
        
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements_attachments') THEN
            UPDATE customer_requirements_attachments 
            SET tenant_id = default_tenant_id 
            WHERE tenant_id IS NULL;
        END IF;
        
        IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'customer_requirements_comment_attachments') THEN
            UPDATE customer_requirements_comment_attachments 
            SET tenant_id = default_tenant_id 
            WHERE tenant_id IS NULL;
        END IF;
    END IF;
END $$;

