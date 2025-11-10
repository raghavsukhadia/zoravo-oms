'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { 
  Car, 
  Wrench, 
  Users, 
  BarChart3, 
  Shield, 
  Clock,
  CheckCircle,
  ArrowRight,
  Star,
  TrendingUp,
  Settings,
  FileText,
  X,
  AlertCircle,
  Briefcase,
  User,
  HelpCircle,
  Mail
} from 'lucide-react'
import Logo from '@/components/Logo'

export default function LandingPage() {
  const router = useRouter()
  const [showCreateAccount, setShowCreateAccount] = useState(false)


  const features = [
    {
      icon: Car,
      title: 'Vehicle Management',
      description: 'Complete vehicle tracking from intake to delivery with detailed history and status updates.'
    },
    {
      icon: Wrench,
      title: 'Service Tracking',
      description: 'Real-time work order management with installer assignments and progress monitoring.'
    },
    {
      icon: Users,
      title: 'Customer Relations',
      description: 'Comprehensive customer database with service history and communication tracking.'
    },
    {
      icon: BarChart3,
      title: 'Analytics & Reports',
      description: 'Detailed insights into business performance with customizable reports and KPIs.'
    },
    {
      icon: Shield,
      title: 'Role-Based Access',
      description: 'Secure multi-role system ensuring appropriate access levels for different team members.'
    },
    {
      icon: Clock,
      title: 'Real-Time Updates',
      description: 'Live status updates and notifications to keep everyone informed of progress.'
    }
  ]

  const stats = [
    { label: 'Vehicles Processed', value: '2,500+', icon: Car },
    { label: 'Happy Customers', value: '1,800+', icon: Users },
    { label: 'Services Completed', value: '5,200+', icon: CheckCircle },
    { label: 'Team Members', value: '50+', icon: Settings }
  ]

  return (
    <div style={{ fontFamily: 'Inter, system-ui, sans-serif' }}>
      <style jsx global>{`
        @keyframes float {
          0%, 100% { transform: translate(0, 0) rotate(0deg); }
          33% { transform: translate(30px, -30px) rotate(120deg); }
          66% { transform: translate(-20px, 20px) rotate(240deg); }
        }
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(30px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        @keyframes gradientShift {
          0%, 100% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
        }
      `}</style>
      {/* Navigation */}
      <nav style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        zIndex: 50,
        backgroundColor: '#ffffff',
        borderBottom: '1px solid #e5e7eb',
        padding: '1rem 0',
        boxShadow: '0 1px 3px rgba(0,0,0,0.05)'
      }}>
        <div style={{
          maxWidth: '1400px',
          margin: '0 auto',
          padding: '0 2rem',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}>
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <Logo size="medium" showText={true} variant="dark" />
          </div>
          
          <div style={{ display: 'flex', gap: '0.75rem', alignItems: 'center' }}>
            <button
              onClick={() => router.push('/login')}
              style={{
                padding: '0.625rem 1.5rem',
                backgroundColor: 'transparent',
                color: '#2563eb',
                border: '1.5px solid #2563eb',
                borderRadius: '0.5rem',
                fontWeight: '600',
                fontSize: '0.875rem',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                display: 'flex',
                alignItems: 'center',
                gap: '0.5rem'
              }}
              onMouseEnter={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.backgroundColor = '#eff6ff'
                e.currentTarget.style.borderColor = '#1d4ed8'
              }}
              onMouseLeave={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.backgroundColor = 'transparent'
                e.currentTarget.style.borderColor = '#2563eb'
              }}
            >
              Sign In
            </button>
            <button
              onClick={() => setShowCreateAccount(true)}
              style={{
                padding: '0.625rem 1.5rem',
                backgroundColor: '#2563eb',
                color: 'white',
                border: 'none',
                borderRadius: '0.5rem',
                fontWeight: '600',
                fontSize: '0.875rem',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                display: 'flex',
                alignItems: 'center',
                gap: '0.5rem',
                boxShadow: '0 1px 2px rgba(37, 99, 235, 0.2)'
              }}
              onMouseEnter={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.backgroundColor = '#1d4ed8'
                e.currentTarget.style.boxShadow = '0 2px 4px rgba(37, 99, 235, 0.3)'
              }}
              onMouseLeave={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.backgroundColor = '#2563eb'
                e.currentTarget.style.boxShadow = '0 1px 2px rgba(37, 99, 235, 0.2)'
              }}
            >
              Create Account
            </button>
            <a
              href="mailto:piyush@sunkool.in"
              style={{
                padding: '0.625rem 1.5rem',
                backgroundColor: '#f8fafc',
                color: '#64748b',
                border: '1px solid #e2e8f0',
                borderRadius: '0.5rem',
                fontWeight: '600',
                fontSize: '0.875rem',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                display: 'flex',
                alignItems: 'center',
                gap: '0.5rem',
                textDecoration: 'none'
              }}
              onMouseEnter={(e: React.MouseEvent<HTMLAnchorElement>) => {
                e.currentTarget.style.backgroundColor = '#f1f5f9'
                e.currentTarget.style.borderColor = '#cbd5e1'
                e.currentTarget.style.color = '#475569'
              }}
              onMouseLeave={(e: React.MouseEvent<HTMLAnchorElement>) => {
                e.currentTarget.style.backgroundColor = '#f8fafc'
                e.currentTarget.style.borderColor = '#e2e8f0'
                e.currentTarget.style.color = '#64748b'
              }}
            >
              <HelpCircle style={{ width: '1rem', height: '1rem' }} />
              Support
            </a>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section style={{
        minHeight: '100vh',
        backgroundColor: '#f8fafc',
        display: 'flex',
        alignItems: 'center',
        paddingTop: '5rem',
        position: 'relative',
        overflow: 'hidden'
      }}>
        {/* Subtle Background Pattern */}
        <div style={{
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'linear-gradient(135deg, rgba(37, 99, 235, 0.03) 0%, rgba(15, 23, 42, 0.02) 100%)',
          zIndex: 0
        }}></div>
        <div style={{
          maxWidth: '1200px',
          margin: '0 auto',
          padding: '0 2rem',
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          gap: '4rem',
          alignItems: 'center',
          position: 'relative',
          zIndex: 1
        }}>
          {/* Left Content */}
          <div style={{ animation: 'fadeInUp 0.8s ease-out' }}>
            <div style={{
              display: 'inline-block',
              padding: '0.5rem 1rem',
              background: '#eff6ff',
              borderRadius: '0.5rem',
              marginBottom: '1.5rem',
              fontSize: '0.875rem',
              color: '#2563eb',
              fontWeight: '600',
              border: '1px solid #dbeafe'
            }}>
              🚀 Trusted by 200+ Car Accessories Businesses
            </div>
            <h1 style={{
              fontSize: '3.5rem',
              fontWeight: '800',
              color: '#0f172a',
              margin: '0 0 1.5rem 0',
              lineHeight: '1.1',
              letterSpacing: '-0.02em'
            }}>
              Transform Your Business with
              <br />
              <span style={{ 
                color: '#2563eb'
              }}>
                Smart Operations Management
              </span>
            </h1>
            <p style={{
              fontSize: '1.25rem',
              color: '#64748b',
              margin: '0 0 2rem 0',
              lineHeight: '1.7',
              fontWeight: '400'
            }}>
              Zoravo OMS digitizes your entire workflow—from vehicle intake to delivery, installation tracking, invoicing, and service follow-ups. Run your operations with <strong style={{ color: '#1e293b' }}>speed, clarity, and complete control</strong>.
            </p>
            
            {/* Key Benefits */}
            <div style={{
              display: 'flex',
              flexDirection: 'column',
              gap: '0.75rem',
              marginBottom: '2rem'
            }}>
              {[
                { icon: '✓', text: 'Complete vehicle lifecycle management' },
                { icon: '✓', text: 'Real-time installation tracking' },
                { icon: '✓', text: 'Automated invoicing & payments' },
                { icon: '✓', text: 'Multi-tenant support for franchises' }
              ].map((benefit, idx) => (
                <div key={idx} style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.75rem',
                  color: '#475569',
                  fontSize: '1rem'
                }}>
                  <span style={{
                    width: '1.5rem',
                    height: '1.5rem',
                    borderRadius: '50%',
                    background: '#dcfce7',
                    color: '#059669',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: '0.875rem',
                    fontWeight: 'bold'
                  }}>{benefit.icon}</span>
                  <span>{benefit.text}</span>
                </div>
              ))}
            </div>
            
            <div style={{ display: 'flex', gap: '1rem', marginBottom: '2rem', flexWrap: 'wrap' }}>
              <button
                onClick={() => setShowCreateAccount(true)}
                style={{
                  padding: '1rem 2rem',
                  backgroundColor: '#2563eb',
                  color: 'white',
                  border: 'none',
                  borderRadius: '0.5rem',
                  fontWeight: '600',
                  fontSize: '1rem',
                  cursor: 'pointer',
                  transition: 'all 0.2s ease',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.75rem',
                  boxShadow: '0 2px 4px rgba(37, 99, 235, 0.2)'
                }}
                onMouseEnter={(e: React.MouseEvent<HTMLButtonElement>) => {
                  e.currentTarget.style.backgroundColor = '#1d4ed8'
                  e.currentTarget.style.boxShadow = '0 4px 8px rgba(37, 99, 235, 0.3)'
                  e.currentTarget.style.transform = 'translateY(-1px)'
                }}
                onMouseLeave={(e: React.MouseEvent<HTMLButtonElement>) => {
                  e.currentTarget.style.backgroundColor = '#2563eb'
                  e.currentTarget.style.boxShadow = '0 2px 4px rgba(37, 99, 235, 0.2)'
                  e.currentTarget.style.transform = 'translateY(0)'
                }}
              >
                Start Your Business
                <ArrowRight style={{ width: '1.25rem', height: '1.25rem' }} />
              </button>
              
              <button
                onClick={() => router.push('/login')}
                style={{
                  padding: '1rem 2rem',
                  backgroundColor: 'white',
                  color: '#2563eb',
                  border: '1.5px solid #2563eb',
                  borderRadius: '0.5rem',
                  fontWeight: '600',
                  fontSize: '1rem',
                  cursor: 'pointer',
                  transition: 'all 0.2s ease',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.75rem'
                }}
                onMouseEnter={(e: React.MouseEvent<HTMLButtonElement>) => {
                  e.currentTarget.style.backgroundColor = '#eff6ff'
                  e.currentTarget.style.borderColor = '#1d4ed8'
                  e.currentTarget.style.color = '#1d4ed8'
                  e.currentTarget.style.transform = 'translateY(-1px)'
                }}
                onMouseLeave={(e: React.MouseEvent<HTMLButtonElement>) => {
                  e.currentTarget.style.backgroundColor = 'white'
                  e.currentTarget.style.borderColor = '#2563eb'
                  e.currentTarget.style.color = '#2563eb'
                  e.currentTarget.style.transform = 'translateY(0)'
                }}
              >
                Sign In
              </button>
            </div>

          </div>

          {/* Right Content - Dashboard Preview */}
          <div style={{
            position: 'relative',
            backgroundColor: 'white',
            borderRadius: '0.75rem',
            padding: '2rem',
            border: '1px solid #e5e7eb',
            boxShadow: '0 4px 6px rgba(0,0,0,0.05)'
          }}>
            <div style={{
              backgroundColor: 'transparent',
              borderRadius: '0.5rem',
              padding: '0'
            }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginBottom: '1.5rem' }}>
                <div style={{
                  width: '2rem',
                  height: '2rem',
                  borderRadius: '0.25rem',
                  background: 'linear-gradient(135deg, #2563eb 0%, #4f46e5 100%)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center'
                }}>
                  <BarChart3 style={{ color: 'white', width: '1rem', height: '1rem' }} />
                </div>
                <h3 style={{ margin: 0, fontSize: '1.25rem', fontWeight: '600', color: '#1f2937' }}>
                  Dashboard Overview
                </h3>
              </div>
              
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1.5rem' }}>
                {[
                  { label: 'Vehicles in Workshop', value: '12', color: '#2563eb' },
                  { label: 'Jobs in Progress', value: '8', color: '#059669' },
                  { label: "Today's Intakes", value: '5', color: '#dc2626' },
                  { label: 'Monthly Revenue', value: '₹2.4L', color: '#7c3aed' }
                ].map((stat, index) => (
                  <div key={index} style={{
                    padding: '1rem',
                    backgroundColor: '#f9fafb',
                    borderRadius: '0.5rem',
                    border: '1px solid #e5e7eb'
                  }}>
                    <div style={{ fontSize: '1.5rem', fontWeight: 'bold', color: stat.color, marginBottom: '0.25rem' }}>
                      {stat.value}
                    </div>
                    <div style={{ fontSize: '0.75rem', color: '#6b7280' }}>
                      {stat.label}
                    </div>
                  </div>
                ))}
              </div>
              
              <div style={{
                height: '120px',
                backgroundColor: '#f3f4f6',
                borderRadius: '0.5rem',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: '#6b7280',
                fontSize: '0.875rem'
              }}>
                📊 Revenue Chart Preview
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Modules Section */}
      <section style={{ padding: '4rem 2rem', backgroundColor: '#ffffff' }}>
        <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
          <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
            <h2 style={{ fontSize: '2rem', fontWeight: 800, color: '#0f172a', margin: 0 }}>Purpose‑Built Modules</h2>
            <p style={{ color: '#64748b', marginTop: '0.5rem' }}>Everything your team needs—connected in one place.</p>
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: '1rem' }}>
            {[{label:'Recent Vehicles',desc:'Live workshop view for installers and coordinators.'},{label:'Recent Invoices',desc:'Accountant‑ready invoice previews and totals.'},{label:'Trackers',desc:'Call follow‑ups and service tracker for after‑sales.'},{label:'Settings',desc:'Locations, departments, users and company profile.'}].map((m,i)=> (
              <div key={i} style={{ border:'1px solid #e5e7eb', borderRadius:'0.75rem', padding:'1rem', background:'#f9fafb' }}>
                <div style={{ fontWeight:700, color:'#111827', marginBottom:'0.25rem' }}>{m.label}</div>
                <div style={{ color:'#6b7280', fontSize:'0.9rem' }}>{m.desc}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section style={{
        padding: '4rem 2rem',
        backgroundColor: '#f8fafc'
      }}>
        <div style={{
          maxWidth: '1200px',
          margin: '0 auto',
          display: 'grid',
          gridTemplateColumns: 'repeat(4, 1fr)',
          gap: '2rem'
        }}>
          {stats.map((stat, index) => (
            <div key={index} style={{
              textAlign: 'center',
              padding: '2rem',
              backgroundColor: 'white',
              borderRadius: '1rem',
              boxShadow: '0 4px 6px rgba(0,0,0,0.05)',
              border: '1px solid #e5e7eb'
            }}>
              <div style={{
                width: '3rem',
                height: '3rem',
                margin: '0 auto 1rem auto',
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #2563eb 0%, #4f46e5 100%)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center'
              }}>
                <stat.icon style={{ color: 'white', width: '1.5rem', height: '1.5rem' }} />
              </div>
              <div style={{ fontSize: '2rem', fontWeight: 'bold', color: '#1f2937', marginBottom: '0.5rem' }}>
                {stat.value}
              </div>
              <div style={{ fontSize: '0.875rem', color: '#6b7280' }}>
                {stat.label}
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Features Section */}
      <section id="features" style={{
        padding: '6rem 2rem',
        backgroundColor: '#ffffff'
      }}>
        <div style={{
          maxWidth: '1200px',
          margin: '0 auto'
        }}>
          <div style={{ textAlign: 'center', marginBottom: '4rem' }}>
            <h2 style={{
              fontSize: '2.5rem',
              fontWeight: 'bold',
              color: '#1f2937',
              margin: '0 0 1rem 0'
            }}>
              Everything You Need to Manage Your Business
            </h2>
            <p style={{
              fontSize: '1.125rem',
              color: '#6b7280',
              maxWidth: '600px',
              margin: '0 auto'
            }}>
              Our comprehensive platform provides all the tools you need to efficiently manage 
              your car accessories business from start to finish.
            </p>
          </div>

          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(3, 1fr)',
            gap: '2rem'
          }}>
            {features.map((feature, index) => (
              <div key={index} style={{
                padding: '2rem',
                backgroundColor: '#f9fafb',
                borderRadius: '1rem',
                border: '1px solid #e5e7eb',
                transition: 'all 0.2s',
                cursor: 'pointer'
              }}
              onMouseEnter={(e: React.MouseEvent<HTMLDivElement>) => {
                e.currentTarget.style.transform = 'translateY(-4px)'
                e.currentTarget.style.boxShadow = '0 10px 25px rgba(0,0,0,0.1)'
                e.currentTarget.style.borderColor = '#2563eb'
              }}
              onMouseLeave={(e: React.MouseEvent<HTMLDivElement>) => {
                e.currentTarget.style.transform = 'translateY(0)'
                e.currentTarget.style.boxShadow = 'none'
                e.currentTarget.style.borderColor = '#e5e7eb'
              }}
              >
                <div style={{
                  width: '3rem',
                  height: '3rem',
                  borderRadius: '0.75rem',
                  background: 'linear-gradient(135deg, #2563eb 0%, #4f46e5 100%)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  marginBottom: '1.5rem'
                }}>
                  <feature.icon style={{ color: 'white', width: '1.5rem', height: '1.5rem' }} />
                </div>
                <h3 style={{
                  fontSize: '1.25rem',
                  fontWeight: '600',
                  color: '#1f2937',
                  margin: '0 0 0.75rem 0'
                }}>
                  {feature.title}
                </h3>
                <p style={{
                  fontSize: '0.875rem',
                  color: '#6b7280',
                  lineHeight: '1.6',
                  margin: '0'
                }}>
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section style={{
        padding: '6rem 2rem',
        backgroundColor: '#0f172a',
        color: 'white'
      }}>
        <div style={{
          maxWidth: '800px',
          margin: '0 auto',
          textAlign: 'center'
        }}>
          <h2 style={{
            fontSize: '2.5rem',
            fontWeight: 'bold',
            margin: '0 0 1.5rem 0'
          }}>
            Ready to Transform Your Business?
          </h2>
          <p style={{
            fontSize: '1.125rem',
            color: 'rgba(255,255,255,0.8)',
            margin: '0 0 2rem 0',
            lineHeight: '1.6'
          }}>
            Join hundreds of car accessories businesses already using Zoravo OMS 
            to streamline their operations and grow their revenue.
          </p>
          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <button
              onClick={() => setShowCreateAccount(true)}
              style={{
                padding: '1.125rem 2.5rem',
                background: 'linear-gradient(135deg, #2563eb 0%, #4f46e5 100%)',
                color: 'white',
                border: 'none',
                borderRadius: '0.75rem',
                fontWeight: '700',
                fontSize: '1.125rem',
                cursor: 'pointer',
                transition: 'all 0.3s ease',
                display: 'inline-flex',
                alignItems: 'center',
                gap: '0.75rem',
                boxShadow: '0 10px 30px rgba(37, 99, 235, 0.4)'
              }}
              onMouseEnter={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.transform = 'translateY(-3px)'
                e.currentTarget.style.boxShadow = '0 15px 40px rgba(37, 99, 235, 0.5)'
              }}
              onMouseLeave={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.transform = 'translateY(0)'
                e.currentTarget.style.boxShadow = '0 10px 30px rgba(37, 99, 235, 0.4)'
              }}
            >
              Start Your Business
              <ArrowRight style={{ width: '1.5rem', height: '1.5rem' }} />
            </button>
            <button
              onClick={() => router.push('/login')}
              style={{
                padding: '1.125rem 2.5rem',
                backgroundColor: 'transparent',
                color: 'white',
                border: '2px solid white',
                borderRadius: '0.75rem',
                fontWeight: '600',
                fontSize: '1.125rem',
                cursor: 'pointer',
                transition: 'all 0.3s ease'
              }}
              onMouseEnter={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.backgroundColor = 'rgba(255,255,255,0.1)'
                e.currentTarget.style.transform = 'translateY(-2px)'
              }}
              onMouseLeave={(e: React.MouseEvent<HTMLButtonElement>) => {
                e.currentTarget.style.backgroundColor = 'transparent'
                e.currentTarget.style.transform = 'translateY(0)'
              }}
            >
              Sign In
            </button>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer style={{
        padding: '2rem',
        backgroundColor: '#111827',
        color: 'white',
        textAlign: 'center'
      }}>
        <div style={{
          maxWidth: '1200px',
          margin: '0 auto',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}>
          <Logo size="medium" showText={true} variant="light" />
          <p style={{ margin: 0, fontSize: '0.875rem', color: '#9ca3af' }}>
            © 2024 Zoravo OMS. All rights reserved.
          </p>
        </div>
      </footer>

      {/* Create Account Modal */}
      {showCreateAccount && <CreateAccountModal onClose={() => setShowCreateAccount(false)} />}
    </div>
  )
}

// Create Account Modal Component
function CreateAccountModal({ onClose }: { onClose: () => void }) {
  const [formData, setFormData] = useState({
    organizationName: '',
    adminName: '',
    adminEmail: '',
    adminPhone: '',
    adminPassword: '',
    confirmPassword: ''
  })
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState(false)
  const router = useRouter()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    // Validation
    if (formData.adminPassword !== formData.confirmPassword) {
      setError('Passwords do not match')
      setLoading(false)
      return
    }

    if (formData.adminPassword.length < 8) {
      setError('Password must be at least 8 characters long')
      setLoading(false)
      return
    }

    try {
      const response = await fetch('/api/tenants/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          organizationName: formData.organizationName,
          adminName: formData.adminName,
          adminEmail: formData.adminEmail,
          adminPhone: formData.adminPhone,
          adminPassword: formData.adminPassword
        })
      })

      const data = await response.json()

      if (!response.ok) {
        setError(data.error || 'Failed to create account')
        setLoading(false)
        return
      }

      setSuccess(true)
      setTimeout(() => {
        onClose()
        router.push(`/login?tenant=${data.tenant_code}`)
      }, 2000)
    } catch (err: any) {
      setError(err.message || 'An unexpected error occurred')
      setLoading(false)
    }
  }

  return (
    <div style={{
      position: 'fixed',
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      backgroundColor: 'rgba(0, 0, 0, 0.6)',
      backdropFilter: 'blur(4px)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      zIndex: 1000,
      padding: '1rem',
      animation: 'fadeIn 0.2s ease-in'
    }}
    onClick={(e) => {
      if (e.target === e.currentTarget) onClose()
    }}
    >
      <style jsx>{`
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideUp {
          from { transform: translateY(20px); opacity: 0; }
          to { transform: translateY(0); opacity: 1; }
        }
        @keyframes spin {
          from { transform: rotate(0deg); }
          to { transform: rotate(360deg); }
        }
        @media (max-width: 768px) {
          .modal-container {
            grid-template-columns: 1fr !important;
          }
          .marketing-side {
            display: none !important;
          }
        }
      `}</style>
      <div style={{
        backgroundColor: 'white',
        borderRadius: '1.5rem',
        maxWidth: '900px',
        width: '100%',
        maxHeight: '95vh',
        overflow: 'hidden',
        boxShadow: '0 25px 50px rgba(0,0,0,0.3)',
        display: 'grid',
        gridTemplateColumns: '1fr 1fr',
        animation: 'slideUp 0.3s ease-out'
      }}
      className="modal-container"
      onClick={(e) => e.stopPropagation()}
      >
        {/* Left Side - Marketing Content */}
        <div className="marketing-side" style={{
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          padding: '3rem 2.5rem',
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'space-between',
          color: 'white',
          position: 'relative',
          overflow: 'hidden'
        }}>
          <div style={{ position: 'absolute', top: '-50px', right: '-50px', width: '200px', height: '200px', borderRadius: '50%', background: 'rgba(255,255,255,0.1)', zIndex: 0 }}></div>
          <div style={{ position: 'absolute', bottom: '-100px', left: '-100px', width: '300px', height: '300px', borderRadius: '50%', background: 'rgba(255,255,255,0.1)', zIndex: 0 }}></div>
          
          <div style={{ position: 'relative', zIndex: 1 }}>
            <button
              onClick={onClose}
              style={{
                position: 'absolute',
                top: '-1rem',
                right: '-1rem',
                background: 'rgba(255,255,255,0.2)',
                border: 'none',
                borderRadius: '50%',
                width: '2.5rem',
                height: '2.5rem',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: 'white',
                backdropFilter: 'blur(10px)'
              }}
            >
              <X style={{ width: '1.25rem', height: '1.25rem' }} />
            </button>

            <div style={{ marginBottom: '2rem' }}>
              <div style={{ fontSize: '2.5rem', fontWeight: '800', lineHeight: '1.1', marginBottom: '1rem' }}>
                Start Your Business Journey
              </div>
              <div style={{ fontSize: '1.125rem', opacity: 0.95, lineHeight: '1.6' }}>
                Join hundreds of car accessories businesses already using Zoravo OMS to streamline operations and grow revenue.
              </div>
            </div>

            <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem', marginBottom: '2rem' }}>
              {[
                { icon: '🚀', title: 'Get Started in Minutes', desc: 'Quick setup, no technical knowledge required' },
                { icon: '📊', title: 'Complete Business Management', desc: 'All tools in one place' },
                { icon: '💰', title: 'Affordable Pricing', desc: '₹12,000/year - Best value in the market' },
                { icon: '🛡️', title: '24-Hour Free Trial', desc: 'Try before you commit' }
              ].map((feature, idx) => (
                <div key={idx} style={{ display: 'flex', gap: '1rem', alignItems: 'flex-start' }}>
                  <div style={{ fontSize: '2rem', flexShrink: 0 }}>{feature.icon}</div>
                  <div>
                    <div style={{ fontSize: '1rem', fontWeight: '600', marginBottom: '0.25rem' }}>{feature.title}</div>
                    <div style={{ fontSize: '0.875rem', opacity: 0.9 }}>{feature.desc}</div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div style={{ position: 'relative', zIndex: 1, padding: '1.5rem', background: 'rgba(255,255,255,0.15)', borderRadius: '1rem', backdropFilter: 'blur(10px)' }}>
            <div style={{ fontSize: '0.875rem', opacity: 0.95, marginBottom: '0.5rem' }}>✨ Trusted by 200+ Businesses</div>
            <div style={{ fontSize: '1.5rem', fontWeight: '700' }}>₹12,000<span style={{ fontSize: '1rem', fontWeight: '400' }}>/year</span></div>
            <div style={{ fontSize: '0.875rem', opacity: 0.9, marginTop: '0.25rem' }}>Just ₹1,000/month • No hidden fees</div>
          </div>
        </div>

        {/* Right Side - Form */}
        <div style={{
          padding: '2.5rem',
          overflowY: 'auto',
          maxHeight: '95vh'
        }}>
          <div style={{
            marginBottom: '2rem'
          }}>
            <h2 style={{
              fontSize: '1.75rem',
              fontWeight: '700',
              color: '#1f2937',
              margin: '0 0 0.5rem 0'
            }}>
              Create Your Account
            </h2>
            <p style={{
              fontSize: '0.875rem',
              color: '#6b7280',
              margin: 0
            }}>
              Fill in your details to get started
            </p>
          </div>

          {success ? (
            <div style={{ textAlign: 'center', padding: '3rem 0' }}>
              <div style={{
                width: '5rem',
                height: '5rem',
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                margin: '0 auto 1.5rem',
                boxShadow: '0 10px 25px rgba(16, 185, 129, 0.3)'
              }}>
                <CheckCircle style={{ width: '3rem', height: '3rem', color: 'white' }} />
              </div>
              <h3 style={{ fontSize: '1.5rem', fontWeight: '700', marginBottom: '0.75rem', color: '#1f2937' }}>
                Account Created Successfully! 🎉
              </h3>
              <p style={{ color: '#6b7280', marginBottom: '1rem', fontSize: '1rem' }}>
                Your account is under review. You'll receive your tenant number shortly.
              </p>
              <div style={{
                padding: '1rem',
                background: '#f0fdf4',
                border: '1px solid #86efac',
                borderRadius: '0.75rem',
                marginTop: '1.5rem'
              }}>
                <p style={{ color: '#059669', fontWeight: '600', fontSize: '0.875rem', margin: 0 }}>
                  ⏰ Your account will be active for 24 hours. Please submit payment proof to continue.
                </p>
              </div>
            </div>
          ) : (
            <form onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1.25rem' }}>
              {error && (
                <div style={{
                  backgroundColor: '#fef2f2',
                  border: '1px solid #fecaca',
                  color: '#dc2626',
                  padding: '1rem',
                  borderRadius: '0.75rem',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.75rem',
                  fontSize: '0.875rem',
                  fontWeight: '500'
                }}>
                  <AlertCircle style={{ width: '1.25rem', height: '1.25rem', flexShrink: 0 }} />
                  <span>{error}</span>
                </div>
              )}

              {/* Company Information Section */}
              <div style={{
                padding: '1.5rem',
                background: 'linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%)',
                borderRadius: '0.75rem',
                border: '1px solid #bae6fd'
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '1rem' }}>
                  <Briefcase style={{ width: '1.25rem', height: '1.25rem', color: '#0369a1' }} />
                  <h3 style={{ fontSize: '1rem', fontWeight: '600', color: '#0369a1', margin: 0 }}>
                    Company Information
                  </h3>
                </div>
                <div>
                  <label style={{
                    display: 'block',
                    fontSize: '0.875rem',
                    fontWeight: '600',
                    color: '#374151',
                    marginBottom: '0.5rem'
                  }}>
                    Company Name *
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.organizationName}
                    onChange={(e) => setFormData({ ...formData, organizationName: e.target.value })}
                    placeholder="e.g., ABC Car Accessories"
                    style={{
                      width: '100%',
                      padding: '0.875rem',
                      border: '2px solid #d1d5db',
                      borderRadius: '0.5rem',
                      fontSize: '0.875rem',
                      transition: 'all 0.2s',
                      outline: 'none'
                    }}
                    onFocus={(e) => {
                      e.target.style.borderColor = '#2563eb'
                      e.target.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)'
                    }}
                    onBlur={(e) => {
                      e.target.style.borderColor = '#d1d5db'
                      e.target.style.boxShadow = 'none'
                    }}
                  />
                </div>
              </div>

              {/* Admin Account Section */}
              <div style={{
                padding: '1.5rem',
                background: 'linear-gradient(135deg, #fef3c7 0%, #fde68a 100%)',
                borderRadius: '0.75rem',
                border: '1px solid #fcd34d'
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', marginBottom: '1rem' }}>
                  <User style={{ width: '1.25rem', height: '1.25rem', color: '#92400e' }} />
                  <h3 style={{ fontSize: '1rem', fontWeight: '600', color: '#92400e', margin: 0 }}>
                    Admin Account Details
                  </h3>
                </div>

                <div style={{ display: 'grid', gap: '1rem' }}>
                  <div>
                    <label style={{
                      display: 'block',
                      fontSize: '0.875rem',
                      fontWeight: '600',
                      color: '#374151',
                      marginBottom: '0.5rem'
                    }}>
                      Full Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.adminName}
                      onChange={(e) => setFormData({ ...formData, adminName: e.target.value })}
                      placeholder="John Doe"
                      style={{
                        width: '100%',
                        padding: '0.875rem',
                        border: '2px solid #d1d5db',
                        borderRadius: '0.5rem',
                        fontSize: '0.875rem',
                        transition: 'all 0.2s',
                        outline: 'none'
                      }}
                      onFocus={(e) => {
                        e.target.style.borderColor = '#2563eb'
                        e.target.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)'
                      }}
                      onBlur={(e) => {
                        e.target.style.borderColor = '#d1d5db'
                        e.target.style.boxShadow = 'none'
                      }}
                    />
                  </div>

                  <div>
                    <label style={{
                      display: 'block',
                      fontSize: '0.875rem',
                      fontWeight: '600',
                      color: '#374151',
                      marginBottom: '0.5rem'
                    }}>
                      Email Address *
                    </label>
                    <input
                      type="email"
                      required
                      value={formData.adminEmail}
                      onChange={(e) => setFormData({ ...formData, adminEmail: e.target.value })}
                      placeholder="admin@example.com"
                      style={{
                        width: '100%',
                        padding: '0.875rem',
                        border: '2px solid #d1d5db',
                        borderRadius: '0.5rem',
                        fontSize: '0.875rem',
                        transition: 'all 0.2s',
                        outline: 'none'
                      }}
                      onFocus={(e) => {
                        e.target.style.borderColor = '#2563eb'
                        e.target.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)'
                      }}
                      onBlur={(e) => {
                        e.target.style.borderColor = '#d1d5db'
                        e.target.style.boxShadow = 'none'
                      }}
                    />
                  </div>

                  <div>
                    <label style={{
                      display: 'block',
                      fontSize: '0.875rem',
                      fontWeight: '600',
                      color: '#374151',
                      marginBottom: '0.5rem'
                    }}>
                      Phone Number *
                    </label>
                    <input
                      type="tel"
                      required
                      value={formData.adminPhone}
                      onChange={(e) => setFormData({ ...formData, adminPhone: e.target.value })}
                      placeholder="+91 9876543210"
                      style={{
                        width: '100%',
                        padding: '0.875rem',
                        border: '2px solid #d1d5db',
                        borderRadius: '0.5rem',
                        fontSize: '0.875rem',
                        transition: 'all 0.2s',
                        outline: 'none'
                      }}
                      onFocus={(e) => {
                        e.target.style.borderColor = '#2563eb'
                        e.target.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)'
                      }}
                      onBlur={(e) => {
                        e.target.style.borderColor = '#d1d5db'
                        e.target.style.boxShadow = 'none'
                      }}
                    />
                  </div>

                  <div>
                    <label style={{
                      display: 'block',
                      fontSize: '0.875rem',
                      fontWeight: '600',
                      color: '#374151',
                      marginBottom: '0.5rem'
                    }}>
                      Password *
                    </label>
                    <input
                      type="password"
                      required
                      value={formData.adminPassword}
                      onChange={(e) => setFormData({ ...formData, adminPassword: e.target.value })}
                      placeholder="At least 8 characters"
                      style={{
                        width: '100%',
                        padding: '0.875rem',
                        border: '2px solid #d1d5db',
                        borderRadius: '0.5rem',
                        fontSize: '0.875rem',
                        transition: 'all 0.2s',
                        outline: 'none'
                      }}
                      onFocus={(e) => {
                        e.target.style.borderColor = '#2563eb'
                        e.target.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)'
                      }}
                      onBlur={(e) => {
                        e.target.style.borderColor = '#d1d5db'
                        e.target.style.boxShadow = 'none'
                      }}
                    />
                  </div>

                  <div>
                    <label style={{
                      display: 'block',
                      fontSize: '0.875rem',
                      fontWeight: '600',
                      color: '#374151',
                      marginBottom: '0.5rem'
                    }}>
                      Confirm Password *
                    </label>
                    <input
                      type="password"
                      required
                      value={formData.confirmPassword}
                      onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
                      placeholder="Re-enter your password"
                      style={{
                        width: '100%',
                        padding: '0.875rem',
                        border: '2px solid #d1d5db',
                        borderRadius: '0.5rem',
                        fontSize: '0.875rem',
                        transition: 'all 0.2s',
                        outline: 'none'
                      }}
                      onFocus={(e) => {
                        e.target.style.borderColor = '#2563eb'
                        e.target.style.boxShadow = '0 0 0 3px rgba(37, 99, 235, 0.1)'
                      }}
                      onBlur={(e) => {
                        e.target.style.borderColor = '#d1d5db'
                        e.target.style.boxShadow = 'none'
                      }}
                    />
                  </div>
                </div>
              </div>

              {/* Pricing & Info Cards */}
              <div style={{
                display: 'grid',
                gap: '0.75rem'
              }}>
                <div style={{
                  background: 'linear-gradient(135deg, #10b981 0%, #059669 100%)',
                  padding: '1rem',
                  borderRadius: '0.75rem',
                  color: 'white',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between'
                }}>
                  <div>
                    <div style={{ fontSize: '0.75rem', opacity: 0.9, marginBottom: '0.25rem' }}>Special Launch Price</div>
                    <div style={{ fontSize: '1.5rem', fontWeight: '700' }}>₹12,000<span style={{ fontSize: '1rem', fontWeight: '400' }}>/year</span></div>
                  </div>
                  <div style={{ fontSize: '0.875rem', opacity: 0.9 }}>Just ₹1,000/month</div>
                </div>
                
                <div style={{
                  backgroundColor: '#fef3c7',
                  border: '1px solid #fcd34d',
                  padding: '1rem',
                  borderRadius: '0.75rem',
                  fontSize: '0.875rem',
                  color: '#92400e',
                  display: 'flex',
                  alignItems: 'flex-start',
                  gap: '0.75rem'
                }}>
                  <Clock style={{ width: '1.25rem', height: '1.25rem', flexShrink: 0, marginTop: '0.125rem' }} />
                  <div>
                    <strong>24-Hour Free Trial:</strong> Your account will be active for 24 hours. Submit payment proof in settings to activate permanently.
                  </div>
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                style={{
                  width: '100%',
                  padding: '1rem',
                  background: loading 
                    ? 'linear-gradient(135deg, #9ca3af 0%, #6b7280 100%)' 
                    : 'linear-gradient(135deg, #2563eb 0%, #4f46e5 100%)',
                  color: 'white',
                  border: 'none',
                  borderRadius: '0.75rem',
                  fontWeight: '700',
                  fontSize: '1rem',
                  cursor: loading ? 'not-allowed' : 'pointer',
                  transition: 'all 0.3s',
                  boxShadow: loading ? 'none' : '0 10px 25px rgba(37, 99, 235, 0.3)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '0.5rem'
                }}
                onMouseEnter={(e) => {
                  if (!loading) {
                    e.currentTarget.style.transform = 'translateY(-2px)'
                    e.currentTarget.style.boxShadow = '0 15px 35px rgba(37, 99, 235, 0.4)'
                  }
                }}
                onMouseLeave={(e) => {
                  if (!loading) {
                    e.currentTarget.style.transform = 'translateY(0)'
                    e.currentTarget.style.boxShadow = '0 10px 25px rgba(37, 99, 235, 0.3)'
                  }
                }}
              >
                {loading ? (
                  <>
                    <div style={{
                      width: '1.25rem',
                      height: '1.25rem',
                      border: '2px solid white',
                      borderTop: '2px solid transparent',
                      borderRadius: '50%',
                      animation: 'spin 1s linear infinite'
                    }}></div>
                    Creating Account...
                  </>
                ) : (
                  <>
                    Get Started Now
                    <ArrowRight style={{ width: '1.25rem', height: '1.25rem' }} />
                  </>
                )}
              </button>

              <p style={{
                fontSize: '0.75rem',
                color: '#9ca3af',
                textAlign: 'center',
                margin: 0
              }}>
                By creating an account, you agree to our Terms of Service and Privacy Policy
              </p>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}
