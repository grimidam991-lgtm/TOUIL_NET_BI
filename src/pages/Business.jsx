import {
  LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, PieChart, Pie, Cell, Legend,
} from 'recharts';
import KPICard from '../components/KPICard';
import useApi from '../hooks/useApi';

function SectionHeader({ title }) {
  return (
    <div className="section-header">
      <div className="section-header-bar" />
      <span className="section-header-text">{title}</span>
      <div className="section-header-line" />
    </div>
  );
}

export default function Business() {
  const { data: mrr }     = useApi('/api/business/mrr',               []);
  const { data: plans }   = useApi('/api/business/plan-distribution', []);
  const { data: tickets } = useApi('/api/support/tickets-categorie',  []);
  const { data: devices } = useApi('/api/users/sessions-device',      []);
  const { data: kpis }    = useApi('/api/business/kpis',              {});

  const mrrMax = mrr.length ? Math.max(...mrr.map(r => r.mrr)) * 1.2 : 2000;

  return (
    <>
      <div className="page-banner">
        <div>
          <div className="page-banner-title">TouilNet | Vue Exécutive</div>
          <div className="page-banner-sub">Tableau de bord stratégique — Indicateurs clés de performance</div>
        </div>
        <div className="page-banner-right">
          Données en temps réel<br />Entrepôt PostgreSQL
        </div>
      </div>

      <SectionHeader title="📊 KPI — INDICATEURS STRATÉGIQUES" />
      <div className="kpi-grid" style={{ gridTemplateColumns: 'repeat(5,1fr)', marginBottom: 24 }}>
        <KPICard label="📈 MRR"
          value={kpis.mrr_total ? `${Number(kpis.mrr_total).toLocaleString('fr-TN')} TND` : '—'}
          delta="+8.3% vs M-1" up={true}
          iconBg="#dbeafe" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2563eb" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>} />

        <KPICard label="📉 CHURN %"
          value={kpis.taux_churn ? `${kpis.taux_churn}%` : '—'}
          sub="niveau acceptable" subColor="#059669"
          iconBg="#fee2e2" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#dc2626" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="23 18 13.5 8.5 8.5 13.5 1 6"/><polyline points="17 18 23 18 23 12"/></svg>} />

        <KPICard label="😊 CSAT"
          value={kpis.csat || '—'}
          sub="Sous l'objectif (4)" subColor="#d97706"
          iconBg="#fef3c7" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#d97706" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><path d="M8 14s1.5 2 4 2 4-2 4-2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg>} />

        <KPICard label="🕐 SLA %"
          value={kpis.sla_pct ? `${kpis.sla_pct}%` : '—'}
          sub="Cible : >95%" subColor="#d97706"
          iconBg="#ede9fe" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#7c3aed" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>} />

        <KPICard label="💻 UPTIME %"
          value={kpis.uptime_pct ? `${kpis.uptime_pct}%` : '—'}
          sub="Cible : >99,5%" subColor="#d97706"
          iconBg="#d1fae5" icon={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#059669" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>} />
      </div>

      <SectionHeader title="📈 ANALYSES DÉTAILLÉES" />
      <div className="chart-grid">
        <div className="chart-card">
          <div className="chart-card-title">📈 Évolution du MRR</div>
          <ResponsiveContainer width="100%" height={220}>
            <LineChart data={mrr} margin={{ top: 4, right: 8, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
              <XAxis dataKey="mois" tick={{ fontSize: 9, fill: '#9ca3af' }} axisLine={false} tickLine={false} interval={3} />
              <YAxis tick={{ fontSize: 10, fill: '#9ca3af' }} axisLine={false} tickLine={false} domain={[0, mrrMax]} />
              <Tooltip formatter={(v) => [`${Number(v).toLocaleString('fr-TN')} TND`, 'MRR Mensuel']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
              <Line type="monotone" dataKey="mrr" stroke="#1e3a8a" strokeWidth={2} dot={false} activeDot={{ r: 4, fill: '#1e3a8a' }} />
            </LineChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <div className="chart-card-title">🍩 Répartition par Plan</div>
          <ResponsiveContainer width="100%" height={220}>
            <PieChart>
              <Pie data={plans} cx="50%" cy="48%" innerRadius={58} outerRadius={88}
                dataKey="value" paddingAngle={2} label={false} labelLine={false}>
                {plans.map((e, i) => <Cell key={i} fill={e.color} stroke="none" />)}
              </Pie>
              <Legend iconType="circle" iconSize={10} wrapperStyle={{ fontSize: 12, paddingTop: 8 }}
                formatter={(value, entry) => (
                  <span style={{ color: '#374151' }}>
                    {value}&nbsp;
                    <span style={{ color: '#1e3a8a', fontWeight: 700 }}>{entry.payload.value}</span>
                    <span style={{ color: '#9ca3af', marginLeft: 4 }}>({entry.payload.pct}%)</span>
                  </span>
                )} />
              <Tooltip formatter={(v, n) => [v, n]} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="chart-grid">
        <div className="chart-card">
          <div className="chart-card-title">📊 Tickets par Catégorie</div>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={tickets} layout="vertical" margin={{ top: 4, right: 24, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" horizontal={false} />
              <XAxis type="number" tick={{ fontSize: 10, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
              <YAxis dataKey="categorie" type="category" tick={{ fontSize: 11, fill: '#374151' }} axisLine={false} tickLine={false} width={100} />
              <Tooltip formatter={(v) => [v, 'Tickets']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
              <Bar dataKey="nb" fill="#1e3a8a" radius={[0, 4, 4, 0]}
                label={{ position: 'right', fontSize: 10, fill: '#374151' }} />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="chart-card">
          <div className="chart-card-title">📱 Sessions par Device</div>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={devices} margin={{ top: 4, right: 8, left: 0, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
              <XAxis dataKey="device" tick={{ fontSize: 11, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 10, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
              <Tooltip formatter={(v) => [v, 'Sessions']} contentStyle={{ fontSize: 11, borderRadius: 8 }} />
              <Bar dataKey="nb" fill="#1e3a8a" radius={[4, 4, 0, 0]}
                label={{ position: 'top', fontSize: 10, fill: '#374151' }} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </>
  );
}
