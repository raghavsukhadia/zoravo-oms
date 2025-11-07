# Tenant-Specific Settings Fix

## Problem Identified

1. **Company Information** was showing the same data for all tenants (RS Car Accessories data)
2. **WhatsApp Notifications** was showing the same configuration for all tenants
3. Settings were not tenant-specific - all tenants saw the same values

## Root Cause

- `system_settings` table had a unique constraint on `setting_key` only, not including `tenant_id`
- Settings queries didn't filter by `tenant_id`
- Settings saves didn't include `tenant_id`
- Tenant creation didn't initialize company settings

## Solution Implemented

### 1. Database Schema Update

**File**: `database/fix_system_settings_tenant.sql`

- Removed old unique constraint on `setting_key` only
- Created new unique index on `(setting_key, tenant_id)` to allow same setting_key for different tenants
- Added index on `tenant_id` for faster filtering

### 2. Company Information - Tenant-Specific

**File**: `app/(dashboard)/settings/page.tsx`

**Changes**:
- `fetchSystemSettings()`:
  - Loads company name from `tenants` table first (most accurate)
  - Filters `system_settings` by `tenant_id` when loading
  - Falls back to tenant name if no settings found
  
- `saveCompanySettings()`:
  - Includes `tenant_id` when saving all company settings
  - Updates `tenants.name` if company name changes
  - Uses check-then-update/insert pattern (since Supabase doesn't support composite unique in upsert)

### 3. WhatsApp Notifications - Tenant-Specific

**File**: `lib/whatsapp-service.ts`
- Updated `loadConfig()` to accept `tenantId` parameter
- Filters settings by `tenant_id` when loading

**File**: `app/(dashboard)/settings/page.tsx`
- `fetchWhatsappSettings()`: Passes `tenantId` to `loadConfig()`
- `saveWhatsappSettings()`: Includes `tenant_id` when saving all WhatsApp settings
- Uses check-then-update/insert pattern for proper isolation

### 4. Tenant Creation - Initialize Company Settings

**File**: `app/api/tenants/create/route.ts`

- When creating a new tenant, automatically initializes company settings:
  - `company_name` = organization name (from tenant creation form)
  - `company_email` = admin email (from tenant creation form)
  - Other fields initialized with defaults (empty or standard values)
- All settings are linked to the new tenant via `tenant_id`

## How It Works Now

### Company Information:
1. **On Load**:
   - First loads tenant name from `tenants` table
   - Then loads company settings from `system_settings` filtered by `tenant_id`
   - Merges both sources
   
2. **On Save**:
   - Updates `tenants.name` if company name changed
   - Saves all company settings with `tenant_id`
   - Each tenant has their own company information

### WhatsApp Notifications:
1. **On Load**:
   - Loads WhatsApp settings filtered by `tenant_id`
   - Each tenant has their own WhatsApp configuration
   
2. **On Save**:
   - Saves WhatsApp settings with `tenant_id`
   - Each tenant can configure their own WhatsApp provider, API keys, etc.

### Tenant Creation:
- When a new tenant is created:
  - Company name is set from organization name
  - Company email is set from admin email
  - Other fields are initialized with defaults
  - All settings are tenant-specific from day one

## Database Migration Required

**IMPORTANT**: Run this SQL script in Supabase SQL Editor:

```sql
-- File: database/fix_system_settings_tenant.sql
```

This script:
1. Drops the old unique constraint
2. Creates a new unique index that includes `tenant_id`
3. Adds index on `tenant_id` for performance

## Testing Checklist

1. ✅ **Create New Tenant**:
   - Create a new tenant account
   - Company Information should show the organization name you entered
   - WhatsApp Notifications should be empty (no config yet)

2. ✅ **Update Company Information**:
   - Log in as tenant admin
   - Go to Settings → Company
   - Update company details
   - Save
   - Should save successfully
   - Other tenants should NOT see these changes

3. ✅ **Update WhatsApp Notifications**:
   - Log in as tenant admin
   - Go to Settings → Notifications
   - Configure WhatsApp settings
   - Save
   - Should save successfully
   - Other tenants should NOT see these settings

4. ✅ **Verify Isolation**:
   - Tenant A configures WhatsApp with API key "ABC123"
   - Tenant B configures WhatsApp with API key "XYZ789"
   - Each tenant should see only their own configuration

## Files Modified

1. `app/(dashboard)/settings/page.tsx` - Tenant-specific loading and saving
2. `lib/whatsapp-service.ts` - Tenant-aware config loading
3. `app/api/tenants/create/route.ts` - Initialize company settings on tenant creation
4. `database/fix_system_settings_tenant.sql` - Database migration script

## Important Notes

- **Super Admins**: See global settings (where `tenant_id` is NULL)
- **Tenant Admins**: See only their tenant's settings (where `tenant_id` matches their tenant)
- **Settings Isolation**: Each tenant's settings are completely isolated
- **Company Name Sync**: Company name in Settings syncs with `tenants.name` table

