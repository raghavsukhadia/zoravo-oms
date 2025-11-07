# Subdomain-Based Tenant Routing Setup

This document explains how to set up subdomain-based routing for multi-tenant access.

## URL Format

Each tenant can access their dashboard using their workspace URL as a subdomain:

- **RS Car Accessories**: `rs-car-accessories-nagpur.zoravo-oms.vercel.app/dashboard`
- **ABC Car Accessories**: `abc-car-accessories.zoravo-oms.vercel.app/dashboard`
- **Main Domain**: `zoravo-oms.vercel.app` (for login, homepage, admin)

## How It Works

### 1. Subdomain Detection

The middleware (`middleware.ts`) automatically detects the workspace URL from the subdomain:

- Extracts the first part of the hostname as the workspace URL
- Examples:
  - `rs-car-accessories-nagpur.zoravo-oms.vercel.app` → workspace: `rs-car-accessories-nagpur`
  - `abc-car-accessories.zoravo-oms.vercel.app` → workspace: `abc-car-accessories`

### 2. Tenant Context Initialization

When a user visits a subdomain URL:

1. **Middleware** detects the workspace URL from the subdomain
2. **Dashboard Layout** calls `initializeTenantFromWorkspace()` to:
   - Look up the tenant by workspace URL
   - Set `current_tenant_id` and `current_workspace_url` in sessionStorage
   - Ensure the tenant is active

### 3. Data Isolation

Once tenant context is set, all database queries automatically filter by `tenant_id`:

```typescript
import { getCurrentTenantId } from '@/lib/tenant-context'

const tenantId = getCurrentTenantId()
const { data } = await supabase
  .from('vehicles')
  .select('*')
  .eq('tenant_id', tenantId)
```

## Vercel Configuration

### Option 1: Wildcard Subdomain (Recommended)

1. **Add Wildcard Domain** in Vercel:
   - Go to your project settings → Domains
   - Add `*.zoravo-oms.vercel.app` (wildcard subdomain)
   - This allows any subdomain to work automatically

2. **DNS Configuration** (if using custom domain):
   - Add a wildcard A record: `*.yourdomain.com` → Vercel's IP
   - Or use CNAME: `*.yourdomain.com` → `cname.vercel-dns.com`

### Option 2: Individual Subdomains

If you prefer to add subdomains individually:

1. Go to Vercel project settings → Domains
2. Add each workspace URL as a subdomain:
   - `rs-car-accessories-nagpur.zoravo-oms.vercel.app`
   - `abc-car-accessories.zoravo-oms.vercel.app`
   - etc.

**Note**: This requires manual addition for each new tenant.

## Development Setup

For local development, subdomain routing works differently:

### Option 1: Use Query Parameter

Access tenant dashboard with workspace in query:
```
http://localhost:3000/dashboard?workspace=rs-car-accessories-nagpur
```

### Option 2: Modify Hosts File

1. Edit `/etc/hosts` (Mac/Linux) or `C:\Windows\System32\drivers\etc\hosts` (Windows)
2. Add entries:
   ```
   127.0.0.1 rs-car-accessories-nagpur.localhost
   127.0.0.1 abc-car-accessories.localhost
   ```
3. Access: `http://rs-car-accessories-nagpur.localhost:3000/dashboard`

### Option 3: Use ngrok or Similar

Use a tunneling service that supports subdomains for testing.

## Login Flow

### Tenant Login via Subdomain

1. User visits: `rs-car-accessories-nagpur.zoravo-oms.vercel.app/login`
2. Workspace URL is auto-filled from subdomain
3. User enters email and password
4. System validates user belongs to that tenant
5. Redirects to `/dashboard` (tenant context already set)

### Regular Login (Main Domain)

1. User visits: `zoravo-oms.vercel.app/login`
2. User selects "Tenant Login" tab
3. User enters workspace URL manually
4. System validates and sets tenant context
5. Redirects to `/dashboard`

## API Routes

API routes automatically receive workspace context via:
- **Query parameter**: `?workspace=rs-car-accessories-nagpur`
- **Header**: `x-workspace-url` (set by middleware)

Example API route:
```typescript
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url)
  const workspaceUrl = searchParams.get('workspace') || 
                       request.headers.get('x-workspace-url')
  
  // Look up tenant and filter data
}
```

## Security Considerations

1. **Tenant Validation**: Always validate that the user belongs to the tenant
2. **Active Status**: Check `tenant.is_active` before allowing access
3. **RLS Policies**: Database RLS policies enforce tenant isolation
4. **Session Storage**: Tenant context is stored client-side in sessionStorage

## Troubleshooting

### Subdomain Not Working

1. **Check Vercel Configuration**:
   - Ensure wildcard domain is added
   - Verify DNS settings if using custom domain

2. **Check Middleware**:
   - Verify middleware is running (check Vercel logs)
   - Ensure workspace URL extraction logic is correct

3. **Check Tenant Setup**:
   - Verify tenant exists in database
   - Ensure `workspace_url` matches subdomain exactly (case-insensitive)

### Tenant Context Not Set

1. **Check Browser Console**: Look for errors in `initializeTenantFromWorkspace()`
2. **Check SessionStorage**: Verify `current_tenant_id` is set
3. **Check Network Tab**: Verify API calls include tenant filtering

## Example URLs

- **Homepage**: `zoravo-oms.vercel.app`
- **Login**: `zoravo-oms.vercel.app/login`
- **Tenant Dashboard**: `rs-car-accessories-nagpur.zoravo-oms.vercel.app/dashboard`
- **Admin Dashboard**: `zoravo-oms.vercel.app/admin` (no subdomain)

## Migration Notes

Existing tenants can continue using:
- Query parameter: `/dashboard?tenant=<tenant-id>`
- SessionStorage: If already logged in, context persists

New tenants should use subdomain URLs for better UX.

