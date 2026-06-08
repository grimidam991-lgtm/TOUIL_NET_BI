import { useState } from 'react';
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip,
  PieChart, Pie, Cell, Legend, ResponsiveContainer,
} from 'recharts';
import KPICard from '../components/KPICard';
import useApi from '../hooks/useApi';
import FilterBar, { buildQS, defaultFilters } from '../components/FilterBar';

function SectionHeader({ title }) {
  return (
    <div className="section-header">
      <div className="section-header-bar" />
      <span className="section-header-text">{title}</span>
      <div className="section-header-line" />
    </div>
  );
}

export default function Users() {
  const [filters, setFilters] = useState(defaultFilters);
  const qs = buildQS(filters);

  const { data: revenu }    = useApi(`/api/business/revenu-plan${qs}`,  []);
  const { data: desabo }    = useApi(`/api/business/desabo-plan${qs}`,  []);
  const { data: topClients }= useApi(`/api/business/top-clients${qs}`,  []);
  const { data: paiement }  = useApi(`/api/business/mode-paiement${qs}`,[]);
  const { data: kpis }      = useApi(`/api/business/kpis${qs}`,         {});

  const revenueMax = revenu.length ? Math.max(...revenu.map(r => r.revenu)) * 1.15 : 100000;
  const tauxActif  = kpis.actifs && kpis.total_abonnements
    ? ((Number(kpis.actifs) / Number(kpis.total_abonnements)) * 100).toFixed(1)
    : null;

  return (
    <>
      <div className="page-banner">
        <div>
          <div className="page-banner-title">TouilNet | Monétisation</div>
          <div className="page-banner-sub">ARPU · Abonnements · Revenus · Désabonnements par plan</div>
        </div>
        <div className="page-banner-right">
          Données en temps réel<br />Entrepôt PostgreSQL
        </div>
      </div>

      <FilterBar filters={filters} onChange={setFilters} showPlan={true} />

      <SectionHeader title="💰 KPI — PERFORMANCE FINANCIÈRE" />
      <div className="kpi-grid" style={{ marginBottom: 24 }}>
        <KPICard label="💸 ARPU"
          value={kpis.arpu ? `${Number(kpis.arpu).toLocaleString('fr-TN')} TND` : '—'}
          sub="Revenu/Client" subColor="#9ca3af"
          iconBg="#fef3c7" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#d97706" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>} />

        <KPICard label="📋 TOTAL ABONNEMENTS"
          value={kpis.total_abonnements || '—'}
          sub="Tous statuts" subColor="#9ca3af"
          iconBg="#dbeafe" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2563eb" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>} />

        <KPICard label="✅ TAUX ACTIF %"
          value={tauxActif ? `${tauxActif}%` : '—'}
          sub="Sous l'optimum" subColor="#d97706"
          iconBg="#d1fae5" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#059669" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>} />

        <KPICard label="📉 NB CHURN"
          value={kpis.churns || '—'}
          sub="Très élevé" subColor="#dc2626"
          iconBg="#fee2e2" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#dc2626" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="23 18 13.5 8.5 8.5 13.5 1 6"/><polyline points="17 18 23 18 23 12"/></svg>} />
      </div>

      <SectionHeader title="📊 ANALYSES REVENUS" />
      <div className="chart-grid">
        <div className="chart-card">
          <div className="chart-card-title">💰 Revenu par Plan</div>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={revenu} margin={{ top: 4, right: 8, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
              <XAxis dataKey="plan" tick={{ fontSize: 11, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 10, fill: '#9ca3af' }} axisLine={false} tickLine={false}
                domain={[0, revenueMax]} tickFormatter={v => `${(v/1000).toFixed(0)}K`} />
              <Tooltip formatter={(v) => [`${Number(v).toLocaleString('fr-TN')} TND`, 'Revenu']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
              <Bar dataKey="revenu" fill="#1e3a8a" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <div className="chart-card-title">🍩 Désabonnements par Plan</div>
          <ResponsiveContainer width="100%" height={220}>
            <PieChart>
              <Pie data={desabo} cx="50%" cy="48%" innerRadius={58} outerRadius={88}
                dataKey="value" paddingAngle={2} label={false} labelLine={false}>
                {desabo.map((e, i) => <Cell key={i} fill={e.color} stroke="none" />)}
              </Pie>
              <Legend iconType="circle" iconSize={10} wrapperStyle={{ fontSize: 12, paddingTop: 8 }}
                formatter={(value, entry) => (
                  <span style={{ color: '#374151' }}>
                    {value}&nbsp;
                    <span style={{ color: '#dc2626', fontWeight: 700 }}>{entry.payload.value}%</span>
                  </span>
                )} />
              <Tooltip formatter={(v) => [`${v}%`, 'Churn']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="chart-grid">
        <div className="chart-card">
          <div className="chart-card-title">🏆 Top 10 Clients par Revenu</div>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={topClients} layout="vertical" margin={{ top: 4, right: 60, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" horizontal={false} />
              <XAxis type="number" tick={{ fontSize: 10, fill: '#9ca3af' }} axisLine={false} tickLine={false}
                tickFormatter={v => `${(v/1000).toFixed(0)}K`} />
              <YAxis dataKey="nom" type="category" tick={{ fontSize: 11, fill: '#374151' }}
                axisLine={false} tickLine={false} width={70} />
              <Tooltip formatter={(v) => [`${Number(v).toLocaleString('fr-TN')} TND`, 'Revenu']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
              <Bar dataKey="revenu" fill="#1e3a8a" radius={[0, 4, 4, 0]}
                label={{ position: 'right', fontSize: 10, fill: '#374151', formatter: v => `${(v/1000).toFixed(0)}K` }} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <div className="chart-card-title">💳 Abonnements par Mode de Paiement</div>
          <ResponsiveContainer width="100%" height={220}>
            <BarChart data={paiement} layout="vertical" margin={{ top: 4, right: 40, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" horizontal={false} />
              <XAxis type="number" tick={{ fontSize: 10, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
              <YAxis dataKey="mode" type="category" tick={{ fontSize: 11, fill: '#374151' }}
                axisLine={false} tickLine={false} width={70} />
              <Tooltip formatter={(v) => [v, 'Abonnements']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
              <Bar dataKey="total" fill="#1e3a8a" radius={[0, 4, 4, 0]}
                label={{ position: 'right', fontSize: 10, fill: '#374151' }} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </>
  );
}
