# TouilNet BI — Plateforme d'Analytics

> PFE 2025 · ESPRIT · Mansour  
> **Stack** : React 18 · Node.js/Express · PostgreSQL · Recharts

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   NAVIGATEUR                        │
│           React 18  +  Recharts                     │
└──────────────────────┬──────────────────────────────┘
                       │  HTTP /api/*
                       ▼
┌─────────────────────────────────────────────────────┐
│              Node.js / Express                      │
│   /api/business  /api/support                       │
│   /api/users     /api/performance                   │
└──────────────────────┬──────────────────────────────┘
                       │  SQL
                       ▼
┌─────────────────────────────────────────────────────┐
│           PostgreSQL — technova_dw                  │
│  fact_subscriptions   fact_support                  │
│  fact_sessions        fact_serverperformance        │
└─────────────────────────────────────────────────────┘
```

---

## Flux de données

```
1. Utilisateur ouvre l'app → page Login
         │
         ▼
2. Connexion (admin / manager / viewer)
   → App.jsx stocke l'utilisateur en state React
         │
         ▼
3. Dashboard s'affiche (Vue Exécutive par défaut)
   → Chaque page appelle useApi('/api/...')
         │
         ▼
4. useApi.js exécute fetch('/api/business/kpis')
   → Proxy redirige vers Express (port 5000)
         │
         ▼
5. Express reçoit la requête
   → Exécute une requête SQL sur PostgreSQL
   → Ex : SELECT AVG(csat_score) FROM fact_support
         │
         ▼
6. PostgreSQL retourne les données
   → Express formate en JSON → res.json(...)
         │
         ▼
7. React reçoit le JSON → met à jour le state
   → Recharts dessine les graphiques
   → KPICard affiche les valeurs
```

---

## Pages

| Page | Données sources |
|------|----------------|
| Vue Exécutive | fact_subscriptions + fact_support + fact_serverperformance |
| Monétisation | fact_subscriptions |
| Engagement | fact_sessions |
| Support Client | fact_support |
| Performance Serveur | fact_serverperformance |
| Prédiction ML | Modèles locaux (Rég. Log., Random Forest, XGBoost, ANN) |

---

## KPIs clés

| KPI | Valeur | Source |
|-----|--------|--------|
| MRR | 11 896 TND | `SUM(prix_mensuel_tnd) WHERE est_actif = 1` |
| Churn % | 2.41 % | Taux mensuel |
| CSAT | 2.95 / 5 | `AVG(csat_score) WHERE est_resolu = 1` |
| SLA % | 92.02 % | `SUM(est_sla_respecte) / SUM(est_resolu)` |
| Uptime % | 98.25 % | `SUM(statut='OK') / COUNT(*)` |
