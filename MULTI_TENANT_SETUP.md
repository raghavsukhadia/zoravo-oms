# Multi-Tenant SaaS Setup Guide

This document explains how to set up and use the multi-tenant SaaS functionality for Zoravo OMS.

## Overview

Zoravo OMS has been converted to a multi-tenant SaaS application where:
- **RS Car Accessories • Nagpur** is the default free tenant
- Other tenants pay $29/month (with 14-day free trial)
- Each tenant has isolated data
- Super admin can manage all tenants

## Database Setup

### Step 1: Apply Multi-Tenant Schema

Run the multi-tenant schema migration:

```sql
-- Run this file in your Supabase SQL editor
database/multi_tenant_schema.sql
```

This will:
- Create `tenants`, `tenant_users`, `subscriptions`, and `super_admins` tables
- Add `tenant_id` column to all existing tables
- Set up indexes and RLS policies
- Create helper functions

### Step 2: Setup Default Tenant and Migrate Data

Run the setup script:

```sql
-- Run this file in your Supabase SQL editor
database/setup_multi_tenant.sql
```

This will:
- Create the default tenant (RS Car Accessories • Nagpur)
- Migrate all existing data to the default tenant
- Link existing users to the default tenant

### Step 3: Create Super Admin

To create a super admin for `raghav@sunkool.in`:

1. First, find the user ID:
```sql
SELECT id, email FROM auth.users WHERE email = 'raghav@sunkool.in';
```

2. Then create the super admin record:
```sql
INSERT INTO super_admins (user_id, email, can_access_all_tenants)
VALUES ('USER_ID_FROM_STEP_1', 'raghav@sunkool.in', true);
```

Or use the API endpoint:
```bash
POST /api/admin/setup-super-admin
{
  "email": "raghav@sunkool.in"
}
```

## Features

### 1. Tenant Creation

**Homepage**: Click "Create Account" button
- Fill in organization details (name, workspace URL)
- Fill in admin account details (name, email, password)
- Workspace URL must be unique and contain only lowercase letters, numbers, and hyphens
- Example: `abc-car-accessories` → `abc-car-accessories.zoravo.com`

**API Endpoint**: `POST /api/tenants/create`
```json
{
  "organizationName": "ABC Car Accessories",
  "workspaceUrl": "abc-car-accessories",
  "adminName": "John Doe",
  "adminEmail": "admin@abc.com",
  "adminPassword": "securepassword123"
}
```

### 2. Tenant Login

**Workspace URL Login**:
1. Go to `/login`
2. Select "Tenant Login" tab
3. Enter workspace URL (e.g., `abc-car-accessories`)
4. Enter email and password
5. System validates user belongs to that tenant

**Super Admin Login**:
1. Go to `/login`
2. Select "Super Admin" tab
3. Enter email and password
4. If user has multiple tenants, they'll see tenant selection
5. For `raghav@sunkool.in`, they can choose:
   - RS Car Accessories • Nagpur (default tenant)
   - ZORAVO Admin (super admin dashboard)

### 3. ZORAVO Admin Dashboard

**Access**: `/admin` (requires super admin access)

**Features**:
- View all tenants
- See tenant statistics (total, active, trial, revenue)
- Search and filter tenants
- View tenant details
- Manage subscriptions
- Monitor tenant activity

### 4. Data Isolation

All database queries should include tenant filtering:

```typescript
import { addTenantFilter, getCurrentTenantId } from '@/lib/tenant-context'

// Client-side
const tenantId = getCurrentTenantId()
const { data } = await supabase
  .from('vehicles')
  .select('*')
  .eq('tenant_id', tenantId)

// Server-side with helper
const query = supabase.from('vehicles').select('*')
const filteredQuery = addTenantFilter(query, tenantId, isSuperAdmin)
```

## Tenant Context

Tenant context is stored in `sessionStorage`:
- `current_tenant_id`: Current tenant UUID
- `current_workspace_url`: Current workspace URL
- `is_super_admin`: Boolean flag for super admin

## Subscription Management

### Subscription Statuses:
- `trial`: 14-day free trial
- `active`: Active paid subscription
- `suspended`: Temporarily suspended
- `cancelled`: Cancelled subscription

### Payment Flow:
1. Tenant signs up → Gets 14-day trial
2. Trial ends → Subscription status changes to `pending`
3. Payment confirmed → Status changes to `active`
4. Monthly billing → Create new subscription record

## Security

### Row Level Security (RLS)
- All tenant tables have RLS enabled
- Users can only access data from their tenant
- Super admins can access all data
- Policies are enforced at the database level

### Tenant Validation
- All API endpoints should validate tenant access
- Use `validateTenantAccess()` helper function
- Check tenant is active before allowing access

## Migration Checklist

- [ ] Run `multi_tenant_schema.sql`
- [ ] Run `setup_multi_tenant.sql`
- [ ] Create super admin user
- [ ] Test tenant creation flow
- [ ] Test tenant login
- [ ] Test super admin login
- [ ] Verify data isolation
- [ ] Update all database queries to include tenant_id
- [ ] Test subscription management
- [ ] Set up payment processing (Stripe/Razorpay)

## API Endpoints

### Tenant Management
- `POST /api/tenants/create` - Create new tenant
- `GET /api/admin/tenants` - List all tenants (super admin)
- `GET /api/admin/tenants/:id` - Get tenant details

### Super Admin
- `POST /api/admin/setup-super-admin` - Create super admin
- `GET /api/admin/stats` - Get admin statistics

## Troubleshooting

### Issue: User can't login to tenant
- Check if user exists in `tenant_users` table
- Verify tenant is active
- Check workspace URL is correct

### Issue: Data not showing
- Verify `tenant_id` is set on records
- Check RLS policies
- Ensure queries include tenant filtering

### Issue: Super admin can't access admin dashboard
- Verify user exists in `super_admins` table
- Check user ID matches auth.users

## Next Steps

1. **Payment Integration**: Integrate Stripe or Razorpay for subscription payments
2. **Email Notifications**: Send welcome emails, trial expiration warnings
3. **Usage Analytics**: Track tenant usage and limits
4. **Billing Automation**: Automate monthly billing and subscription renewals
5. **Tenant Settings**: Allow tenants to customize their workspace
6. **API Rate Limiting**: Implement per-tenant rate limiting

## Support

For issues or questions, contact the development team.

