const MOIS_FR = [
  { v: 1,  l: 'Jan' }, { v: 2,  l: 'Fév' }, { v: 3,  l: 'Mar' },
  { v: 4,  l: 'Avr' }, { v: 5,  l: 'Mai' }, { v: 6,  l: 'Jun' },
  { v: 7,  l: 'Jul' }, { v: 8,  l: 'Aoû' }, { v: 9,  l: 'Sep' },
  { v: 10, l: 'Oct' }, { v: 11, l: 'Nov' }, { v: 12, l: 'Déc' },
];

const PLANS = ['Premium', 'Standard', 'Entreprise'];
const CATS  = ['Bug', 'Fonctionnalité', 'Performance', 'Facturation', 'Sécurité', 'Autre'];
const PRIOS = ['Critique', 'Haute', 'Moyenne', 'Basse'];

function ChipGroup({ label, options, active, onToggle }) {
  return (
    <div className="fc-group">
      <span className="fc-group-label">{label}</span>
      <div className="fc-chips">
        {options.map(o => {
          const val  = String(o.v ?? o);
          const text = o.l ?? o;
          const on   = active === val;
          return (
            <button key={val} className={`fc-chip${on ? ' active' : ''}`} onClick={() => onToggle(on ? '' : val)}>
              {text}
            </button>
          );
        })}
      </div>
    </div>
  );
}

export default function FilterBar({
  filters, onChange, annees = [],
  showPlan = false, showCategorie = false, showPriorite = false,
}) {
  const activeCount = Object.values(filters).filter(v => v !== '').length;
  const set = (key) => (val) => onChange({ ...filters, [key]: val });
  const reset = () => onChange({ annee: '', mois: '', plan: '', categorie: '', priorite: '' });

  return (
    <div className="filter-bar-chips">
      <div className="fc-header">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#1e3a8a" strokeWidth="2.5">
          <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/>
        </svg>
        <span className="fc-title">Filtres</span>
        {activeCount > 0 && <span className="fc-badge">{activeCount}</span>}
      </div>

      <div className="fc-divider" />

      <div className="fc-body">
        {annees.length > 0 && (
          <ChipGroup label="Année" options={annees.map(a => ({ v: a, l: String(a) }))}
            active={filters.annee} onToggle={set('annee')} />
        )}

        <ChipGroup label="Mois" options={MOIS_FR} active={filters.mois} onToggle={set('mois')} />

        {showPlan && (
          <ChipGroup label="Plan" options={PLANS} active={filters.plan} onToggle={set('plan')} />
        )}

        {showCategorie && (
          <ChipGroup label="Catégorie" options={CATS} active={filters.categorie} onToggle={set('categorie')} />
        )}

        {showPriorite && (
          <ChipGroup label="Priorité" options={PRIOS} active={filters.priorite} onToggle={set('priorite')} />
        )}
      </div>

      {activeCount > 0 && (
        <div className="fc-divider" />
      )}
      {activeCount > 0 && (
        <button className="fc-reset" onClick={reset}>
          <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
            <polyline points="1 4 1 10 7 10"/>
            <path d="M3.51 15a9 9 0 1 0 .49-3.65"/>
          </svg>
          Réinitialiser
        </button>
      )}
    </div>
  );
}

export function buildQS(filters) {
  const p = new URLSearchParams();
  if (filters.annee)     p.set('annee',     filters.annee);
  if (filters.mois)      p.set('mois',      filters.mois);
  if (filters.plan)      p.set('plan',      filters.plan);
  if (filters.categorie) p.set('categorie', filters.categorie);
  if (filters.priorite)  p.set('priorite',  filters.priorite);
  const qs = p.toString();
  return qs ? `?${qs}` : '';
}

export const defaultFilters = { annee: '', mois: '', plan: '', categorie: '', priorite: '' };
