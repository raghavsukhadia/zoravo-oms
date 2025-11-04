'use client'

import Logo from '@/components/Logo'

export default function AboutPage() {
  return (
    <div style={{ padding: '2rem', backgroundColor: '#f8fafc', minHeight: '100vh' }}>
      {/* HERO */}
      <div
        style={{
          borderRadius: '1rem',
          padding: '2rem',
          marginBottom: '1.5rem',
          background:
            'radial-gradient(1200px 200px at 10% -20%, rgba(37,99,235,0.10), transparent), radial-gradient(1200px 200px at 90% -20%, rgba(16,185,129,0.12), transparent), white',
          border: '1px solid #e5e7eb',
          display: 'flex',
          alignItems: 'center',
          gap: '1.25rem'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', flexShrink: 0 }}>
          <Logo size="large" showText={true} variant="dark" />
        </div>
        <div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', marginBottom: '0.25rem' }}>
            <span style={{ padding: '0.25rem 0.5rem', backgroundColor: '#eff6ff', color: '#2563eb', border: '1px solid #bfdbfe', borderRadius: '9999px', fontSize: '0.75rem', fontWeight: 700 }}>Version 1.0</span>
            <span style={{ padding: '0.25rem 0.5rem', backgroundColor: '#ecfdf5', color: '#059669', border: '1px solid #a7f3d0', borderRadius: '9999px', fontSize: '0.75rem', fontWeight: 700 }}>Made in India</span>
          </div>
          <h1 style={{ fontSize: '1.9rem', fontWeight: 900, color: '#0f172a', margin: 0 }}>About Zoravo OMS</h1>
          <p style={{ color: '#475569', marginTop: '0.5rem', maxWidth: 900 }}>
            Zoravo OMS is a comprehensive, custom‑built Operations Management System (OMS) designed to digitize and streamline
            end‑to‑end workflows for automotive service and accessory businesses.
          </p>
          <p style={{ color: '#475569', maxWidth: 900 }}>
            It provides a single, centralized platform replacing manual tracking with an efficient, data‑driven solution.
            From vehicle intake and job tracking to finance and customer service—Zoravo OMS keeps your operation in one fast, reliable system.
          </p>
          <p style={{ color: '#475569', marginTop: '0.75rem', maxWidth: 900, fontWeight: 500 }}>
            Transform your automotive service business with powerful features designed for installers, coordinators, managers, and accountants.
          </p>
        </div>
      </div>

      {/* CTA STRIP */}
      <div style={{
        background: 'linear-gradient(90deg, rgba(37,99,235,0.06), rgba(16,185,129,0.06))',
        border: '1px solid #e5e7eb', borderRadius: '0.75rem', padding: '1rem 1.25rem', marginBottom: '1.5rem', display: 'flex', gap: '0.75rem', flexWrap: 'wrap'
      }}>
        <button title="Coming soon" disabled style={{ padding: '0.625rem 1.25rem', backgroundColor: '#94a3b8', color: 'white', border: 'none', borderRadius: '0.5rem', cursor: 'not-allowed' }}>Book a Demo</button>
        <a href="mailto:piyush@sunkool.in" style={{ textDecoration: 'none' }}>
          <button style={{ padding: '0.625rem 1.25rem', backgroundColor: '#2563eb', color: 'white', border: 'none', borderRadius: '0.5rem', cursor: 'pointer' }}>Contact Support</button>
        </a>
        <button title="Coming soon" disabled style={{ padding: '0.625rem 1.25rem', backgroundColor: '#94a3b8', color: 'white', border: 'none', borderRadius: '0.5rem', cursor: 'not-allowed' }}>Visit Website</button>
      </div>

      {/* FEATURES */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '1rem', marginBottom: '1.5rem' }}>
        <FeatureCard title="Dynamic Dashboard" emoji="📈" desc="Real-time KPIs including Total Revenue, Jobs in Progress, Daily Intakes, Monthly Revenue, Pending Payments, and comprehensive financial analytics with interactive charts." />
        <FeatureCard title="Vehicle Inward & Management" emoji="📋" desc="Complete vehicle intake system with customer details, service history tracking, and status workflow: Pending → In Progress → Under Installation → Installation Complete → Completed → Delivered." />
        <FeatureCard title="Job Sheet Printing" emoji="🖨️" desc="Professional job sheet generation for installers with complete vehicle and customer details—perfect for record keeping and workflow management (excludes pricing information)." />
        <FeatureCard title="Accounts & Finance" emoji="💰" desc="Comprehensive financial management: Track revenue, average order value, discounts, invoicing, payment tracking, P&L reports, and exportable financial reports (CSV/Excel)." />
        <FeatureCard title="Trackers Suite" emoji="📞" desc="Call Follow-up CRM for customer communication tracking and Service Tracker for warranties/complaints—ensuring every customer interaction and service action is traceable." />
        <FeatureCard title="Real-time Notifications" emoji="🔔" desc="Built-in notification system with bell icon alerts, status update notifications, assignment alerts, and priority-based notifications to keep your team informed." />
        <FeatureCard title="Comments & Attachments" emoji="💬" desc="Rich communication system allowing team members to add comments, attach files, and track progress on vehicle jobs with full audit trail." />
        <FeatureCard title="Installer Dashboard" emoji="🔧" desc="Dedicated dashboard for installers with assigned jobs, status update capabilities, progress tracking, and quick access to job details." />
        <FeatureCard title="Role-Based Access Control" emoji="⚙️" desc="Granular permissions system with five roles: Admin (full access), Manager, Coordinator, Installer, and Accountant—each with appropriate access levels and restrictions." />
        <FeatureCard title="WhatsApp Integration" emoji="📱" desc="Automated WhatsApp notifications for vehicle delivery, status updates, and customer communications—streamlining customer engagement." />
        <FeatureCard title="Customer Requirements" emoji="📝" desc="Track customer requirements, manage priorities, and ensure nothing falls through the cracks with comprehensive requirement management system." />
        <FeatureCard title="Export & Reporting" emoji="📊" desc="Export financial data, P&L reports, payment records, and expense reports in CSV format for further analysis and accounting integration." />
      </div>

      {/* KEY BENEFITS */}
      <div style={{ backgroundColor: 'white', border: '1px solid #e2e8f0', borderRadius: '0.75rem', padding: '2rem', marginBottom: '1.5rem' }}>
        <h2 style={{ fontSize: '1.5rem', fontWeight: 800, color: '#111827', marginTop: 0, marginBottom: '1.5rem' }}>Why Choose Zoravo OMS?</h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '1.5rem' }}>
          <BenefitItem 
            icon="⚡" 
            title="Lightning Fast" 
            desc="Built for speed with optimized database queries and real-time updates. No more waiting for pages to load." 
          />
          <BenefitItem 
            icon="🔒" 
            title="Secure & Reliable" 
            desc="Enterprise-grade security with Row Level Security (RLS), role-based access control, and encrypted data storage." 
          />
          <BenefitItem 
            icon="📱" 
            title="Mobile Friendly" 
            desc="Responsive design works seamlessly on desktop, tablet, and mobile devices—access your operations anywhere." 
          />
          <BenefitItem 
            icon="🎯" 
            title="Purpose Built" 
            desc="Specifically designed for automotive accessory businesses—no unnecessary features, just what you need." 
          />
          <BenefitItem 
            icon="📈" 
            title="Data Driven" 
            desc="Make informed decisions with comprehensive analytics, reports, and real-time insights into your business performance." 
          />
          <BenefitItem 
            icon="🔄" 
            title="Always Updated" 
            desc="Regular feature updates and improvements based on real-world usage and feedback from automotive service businesses." 
          />
        </div>
      </div>

      <div style={{ backgroundColor: 'white', border: '1px solid #e2e8f0', borderRadius: '0.75rem', padding: '2rem' }}>
        <h2 style={{ fontSize: '1.25rem', fontWeight: 800, color: '#111827', marginTop: 0, marginBottom: '1rem' }}>Project & Developer</h2>
        {/* Key details presented in a clean two-column details grid */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: '1fr 2fr',
          gap: '0.25rem 1rem',
          border: '1px solid #e5e7eb',
          borderRadius: '0.75rem',
          padding: '1rem',
          backgroundColor: '#f9fafb'
        }}>
          <DetailRow label="Application Name" value="Zoravo OMS" />
          <DetailRow label="Project Purpose" value="Primary OMS for RS Car Accessories, Nagpur—improving operational efficiency, financial transparency, and customer relationship management." />
          <DetailRow label="Developed By" value="Raghav Sukhadia" />
          <DetailRow label="Support Email" value={<a href="mailto:piyush@sunkool.in" style={{ color: '#2563eb', textDecoration: 'none' }}>piyush@sunkool.in</a>} />
          <DetailRow label="Office" value="Sunkool Solutions, Nagpur" />
          <DetailRow label="Social" value={
            <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
              <a href="#" style={{ color: '#2563eb', fontWeight: 700, textDecoration: 'none' }}>LinkedIn</a>
              <a href="#" style={{ color: '#2563eb', fontWeight: 700, textDecoration: 'none' }}>Instagram</a>
              <a href="#" style={{ color: '#2563eb', fontWeight: 700, textDecoration: 'none' }}>Facebook</a>
              <a href="#" style={{ color: '#2563eb', fontWeight: 700, textDecoration: 'none' }}>YouTube</a>
            </div>
          } />
        </div>

        <div style={{ marginTop: '1rem' }}>
          <Label>Developer's Note</Label>
          <Value>
            Zoravo OMS was engineered to solve the specific operational challenges of the automotive accessories industry.
            Built with modern web technologies and best practices, it delivers enterprise-grade functionality while remaining intuitive and user-friendly.
            The system is designed to scale with your business—from small shops to large operations—driving growth while simplifying day‑to‑day operations.
          </Value>
        </div>

        <div style={{ marginTop: '1.25rem', display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
          <Tag>Modern UI</Tag>
          <Tag>Real‑time Insights</Tag>
          <Tag>Role‑based Access</Tag>
          <Tag>Financial Reporting</Tag>
          <Tag>Customer‑centric</Tag>
          <Tag>Scalable Architecture</Tag>
          <Tag>WhatsApp Integration</Tag>
          <Tag>Print Support</Tag>
          <Tag>Export Capabilities</Tag>
          <Tag>Mobile Responsive</Tag>
          <Tag>Secure & Reliable</Tag>
          <Tag>Cloud Hosted</Tag>
        </div>
      </div>
    </div>
  )
}

function FeatureCard({ title, emoji, desc }: { title: string; emoji: string; desc: string }) {
  return (
    <div style={{ backgroundColor: 'white', border: '1px solid #e2e8f0', borderRadius: '0.75rem', padding: '1.25rem' }}>
      <div style={{ fontSize: '1.5rem', lineHeight: 1, marginBottom: '0.5rem' }}>{emoji}</div>
      <div style={{ fontSize: '1rem', fontWeight: 700, color: '#111827', marginBottom: '0.25rem' }}>{title}</div>
      <div style={{ color: '#64748b', fontSize: '0.95rem' }}>{desc}</div>
    </div>
  )
}

function Label({ children }: { children: React.ReactNode }) {
  return <div style={{ fontSize: '0.8rem', color: '#64748b', marginBottom: '0.25rem' }}>{children}</div>
}

function Value({ children }: { children: React.ReactNode }) {
  return <div style={{ fontSize: '0.95rem', color: '#111827' }}>{children}</div>
}

function Tag({ children }: { children: React.ReactNode }) {
  return (
    <span
      style={{
        padding: '0.25rem 0.5rem',
        border: '1px solid #e5e7eb',
        borderRadius: '9999px',
        backgroundColor: '#f9fafb',
        color: '#374151',
        fontSize: '0.8rem',
        fontWeight: 600,
      }}
    >
      {children}
    </span>
  )
}

function DetailRow({ label, value }: { label: string; value: React.ReactNode }) {
  return (
    <>
      <div style={{ color: '#64748b', fontSize: '0.85rem', padding: '0.5rem 0' }}>{label}</div>
      <div style={{ color: '#0f172a', fontSize: '0.95rem', fontWeight: 600, padding: '0.5rem 0' }}>{value}</div>
    </>
  )
}

function BenefitItem({ icon, title, desc }: { icon: string; title: string; desc: string }) {
  return (
    <div style={{ padding: '1rem', backgroundColor: '#f9fafb', borderRadius: '0.5rem', border: '1px solid #e5e7eb' }}>
      <div style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>{icon}</div>
      <div style={{ fontSize: '1rem', fontWeight: 700, color: '#111827', marginBottom: '0.5rem' }}>{title}</div>
      <div style={{ color: '#64748b', fontSize: '0.875rem', lineHeight: '1.5' }}>{desc}</div>
    </div>
  )
}


