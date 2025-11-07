'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import {
  Building2,
  Search,
  Filter,
  Eye,
  Edit,
  Trash2,
  Plus,
  CheckCircle,
  XCircle,
  Clock,
  Users as UsersIcon,
  DollarSign,
  MoreVertical
} from 'lucide-react'

interface Tenant {
  id: string
  name: string
  workspace_url: string
  is_active: boolean
  is_free: boolean
  subscription_status: string
  trial_ends_at: string | null
  created_at: string
  user_count?: number
  subscription?: {
    status: string
    amount: number
    billing_period_end: string | null
  }
}

export default function TenantsManagementPage() {
  const router = useRouter()
  const supabase = createClient()
  const [tenants, setTenants] = useState<Tenant[]>([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [filterStatus, setFilterStatus] = useState<string>('all')

  useEffect(() => {
    loadTenants()
  }, [])

  const loadTenants = async () => {
    try {
      setLoading(true)
      const { data: tenantsData, error } = await supabase
        .from('tenants')
        .select(`
          *,
          tenant_users(count),
          subscriptions(status, amount, billing_period_end)
        `)
        .order('created_at', { ascending: false })

      if (error) {
        console.error('Error loading tenants:', error)
        return
      }

      const transformedTenants = tenantsData?.map((tenant: any) => ({
        ...tenant,
        user_count: tenant.tenant_users?.[0]?.count || 0,
        subscription: tenant.subscriptions?.[0] || null
      })) || []

      setTenants(transformedTenants)
    } catch (error) {
      console.error('Error:', error)
    } finally {
      setLoading(false)
    }
  }

  const filteredTenants = tenants.filter(tenant => {
    const matchesSearch = tenant.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         tenant.workspace_url.toLowerCase().includes(searchQuery.toLowerCase())
    const matchesFilter = filterStatus === 'all' || 
                         (filterStatus === 'active' && tenant.is_active) ||
                         (filterStatus === 'inactive' && !tenant.is_active) ||
                         (filterStatus === 'trial' && tenant.subscription_status === 'trial') ||
                         (filterStatus === 'paid' && tenant.subscription_status === 'active')
    return matchesSearch && matchesFilter
  })

  const getStatusBadge = (tenant: Tenant) => {
    if (!tenant.is_active) {
      return { label: 'Inactive', color: '#dc2626', bg: '#fef2f2' }
    }
    if (tenant.is_free) {
      return { label: 'Free', color: '#059669', bg: '#d1fae5' }
    }
    if (tenant.subscription_status === 'trial') {
      return { label: 'Trial', color: '#f59e0b', bg: '#fef3c7' }
    }
    if (tenant.subscription_status === 'active') {
      return { label: 'Active', color: '#059669', bg: '#d1fae5' }
    }
    return { label: tenant.subscription_status, color: '#6b7280', bg: '#f3f4f6' }
  }

  const handleToggleActive = async (tenant: Tenant) => {
    const { error } = await supabase
      .from('tenants')
      .update({ is_active: !tenant.is_active })
      .eq('id', tenant.id)

    if (!error) {
      loadTenants()
    }
  }

  return (
    <div style={{ padding: '2rem' }}>
      {/* Page Header */}
      <div style={{ marginBottom: '2rem' }}>
        <h1 style={{
          fontSize: '1.875rem',
          fontWeight: '700',
          color: '#1f2937',
          margin: '0 0 0.5rem 0'
        }}>
          Tenant Management
        </h1>
        <p style={{ color: '#6b7280', margin: 0 }}>
          Manage all tenants, workspaces, and their configurations
        </p>
      </div>

      {/* Actions Bar */}
      <div style={{
        backgroundColor: 'white',
        padding: '1.5rem',
        borderRadius: '0.75rem',
        marginBottom: '1.5rem',
        display: 'flex',
        gap: '1rem',
        alignItems: 'center',
        flexWrap: 'wrap',
        border: '1px solid #e5e7eb'
      }}>
        <div style={{ position: 'relative', flex: 1, minWidth: '250px' }}>
          <Search style={{
            position: 'absolute',
            left: '0.75rem',
            top: '50%',
            transform: 'translateY(-50%)',
            width: '1rem',
            height: '1rem',
            color: '#9ca3af'
          }} />
          <input
            type="text"
            placeholder="Search tenants..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            style={{
              width: '100%',
              padding: '0.75rem 0.75rem 0.75rem 2.5rem',
              border: '1px solid #d1d5db',
              borderRadius: '0.5rem',
              fontSize: '0.875rem'
            }}
          />
        </div>
        <select
          value={filterStatus}
          onChange={(e) => setFilterStatus(e.target.value)}
          style={{
            padding: '0.75rem 1rem',
            border: '1px solid #d1d5db',
            borderRadius: '0.5rem',
            fontSize: '0.875rem',
            backgroundColor: 'white'
          }}
        >
          <option value="all">All Status</option>
          <option value="active">Active</option>
          <option value="inactive">Inactive</option>
          <option value="trial">Trial</option>
          <option value="paid">Paid</option>
        </select>
        <button
          onClick={() => router.push('/admin/tenants/new')}
          style={{
            padding: '0.75rem 1.5rem',
            backgroundColor: '#2563eb',
            color: 'white',
            border: 'none',
            borderRadius: '0.5rem',
            fontWeight: '500',
            cursor: 'pointer',
            fontSize: '0.875rem',
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem'
          }}
        >
          <Plus style={{ width: '1rem', height: '1rem' }} />
          Create Tenant
        </button>
      </div>

      {/* Tenants Table */}
      <div style={{
        backgroundColor: 'white',
        borderRadius: '0.75rem',
        overflow: 'hidden',
        border: '1px solid #e5e7eb'
      }}>
        {loading ? (
          <div style={{ padding: '3rem', textAlign: 'center', color: '#6b7280' }}>
            Loading tenants...
          </div>
        ) : filteredTenants.length === 0 ? (
          <div style={{ padding: '3rem', textAlign: 'center', color: '#6b7280' }}>
            No tenants found
          </div>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr style={{ backgroundColor: '#f9fafb', borderBottom: '1px solid #e5e7eb' }}>
                <th style={{ padding: '1rem', textAlign: 'left', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Tenant</th>
                <th style={{ padding: '1rem', textAlign: 'left', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Workspace</th>
                <th style={{ padding: '1rem', textAlign: 'left', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Status</th>
                <th style={{ padding: '1rem', textAlign: 'left', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Users</th>
                <th style={{ padding: '1rem', textAlign: 'left', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Subscription</th>
                <th style={{ padding: '1rem', textAlign: 'left', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Created</th>
                <th style={{ padding: '1rem', textAlign: 'right', fontSize: '0.875rem', fontWeight: '600', color: '#374151' }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredTenants.map((tenant, index) => {
                const statusBadge = getStatusBadge(tenant)
                return (
                  <tr key={tenant.id} style={{ borderBottom: index < filteredTenants.length - 1 ? '1px solid #e5e7eb' : 'none' }}>
                    <td style={{ padding: '1rem' }}>
                      <div style={{ fontWeight: '600', color: '#1f2937', marginBottom: '0.25rem' }}>
                        {tenant.name}
                      </div>
                    </td>
                    <td style={{ padding: '1rem' }}>
                      <div style={{ fontSize: '0.875rem', color: '#6b7280' }}>
                        {tenant.workspace_url + '.zoravo.com'}
                      </div>
                    </td>
                    <td style={{ padding: '1rem' }}>
                      <span style={{
                        display: 'inline-block',
                        padding: '0.25rem 0.75rem',
                        borderRadius: '9999px',
                        fontSize: '0.75rem',
                        fontWeight: '500',
                        color: statusBadge.color,
                        backgroundColor: statusBadge.bg
                      }}>
                        {statusBadge.label}
                      </span>
                    </td>
                    <td style={{ padding: '1rem', color: '#6b7280' }}>
                      {tenant.user_count || 0}
                    </td>
                    <td style={{ padding: '1rem' }}>
                      {tenant.is_free ? (
                        <span style={{ color: '#059669', fontSize: '0.875rem' }}>Free</span>
                      ) : tenant.subscription ? (
                        <div>
                          <div style={{ fontSize: '0.875rem', fontWeight: '500', color: '#1f2937' }}>
                            {'$' + tenant.subscription.amount + '/month'}
                          </div>
                          {tenant.subscription.billing_period_end && (
                            <div style={{ fontSize: '0.75rem', color: '#6b7280' }}>
                              Until {new Date(tenant.subscription.billing_period_end).toLocaleDateString()}
                            </div>
                          )}
                        </div>
                      ) : (
                        <span style={{ color: '#6b7280', fontSize: '0.875rem' }}>No subscription</span>
                      )}
                    </td>
                    <td style={{ padding: '1rem', color: '#6b7280', fontSize: '0.875rem' }}>
                      {new Date(tenant.created_at).toLocaleDateString()}
                    </td>
                    <td style={{ padding: '1rem', textAlign: 'right' }}>
                      <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                        <button
                          onClick={() => router.push(`/admin/tenants/${tenant.id}`)}
                          style={{
                            padding: '0.5rem',
                            backgroundColor: 'transparent',
                            border: 'none',
                            cursor: 'pointer',
                            color: '#6b7280'
                          }}
                          title="View Details"
                        >
                          <Eye style={{ width: '1rem', height: '1rem' }} />
                        </button>
                        <button
                          onClick={() => handleToggleActive(tenant)}
                          style={{
                            padding: '0.5rem',
                            backgroundColor: 'transparent',
                            border: 'none',
                            cursor: 'pointer',
                            color: tenant.is_active ? '#dc2626' : '#059669'
                          }}
                          title={tenant.is_active ? 'Deactivate' : 'Activate'}
                        >
                          {tenant.is_active ? (
                            <XCircle style={{ width: '1rem', height: '1rem' }} />
                          ) : (
                            <CheckCircle style={{ width: '1rem', height: '1rem' }} />
                          )}
                        </button>
                      </div>
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}

