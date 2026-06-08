# TouilNet BI — Plateforme d'Analytics

> Plateforme de Business Intelligence full-stack développée dans le cadre du PFE 2025 — ESPRIT  
> **Stack** : React 18 · Node.js/Express · PostgreSQL · Recharts

---

## Table des matières

1. [Architecture générale](#architecture-générale)
2. [Structure du projet](#structure-du-projet)
3. [Flux de données](#flux-de-données)
4. [Prérequis](#prérequis)
5. [Installation](#installation)
6. [Démarrage](#démarrage)
7. [Comptes de démonstration](#comptes-de-démonstration)
8. [Endpoints API](#endpoints-api)
9. [Pages du dashboard](#pages-du-dashboard)

---

## Architecture générale

```
┌─────────────────────────────────────────────────────┐
│                   NAVIGATEUR                        │
│           http://localhost:3000                     │
│                                                     │
│   React 18  +  Recharts  +  CSS                     │
└──────────────────────┬──────────────────────────────┘
                       │  HTTP /api/*  (proxy CRA)
                       ▼
┌─────────────────────────────────────────────────────┐
│              BACKEND  Node.js / Express             │
│               http://localhost:5000                 │
│                                                     │
│   routes/business.js   →  /api/business/*          │
│   routes/support.js    →  /api/support/*           │
│   routes/users.js      →  /api/users/*             │
│   routes/performance.js→  /api/performance/*       │
└──────────────────────┬──────────────────────────────┘
                       │  SQL (pg pool)
                       ▼
┌─────────────────────────────────────────────────────┐
│           PostgreSQL  —  technova_dw                │
│                  localhost:5432                     │
│                                                     │
│   fact_subscriptions     fact_support              │
│   fact_sessions          fact_serverperformance    │
│   dim_user               dim_time                  │
└─────────────────────────────────────────────────────┘
```

---

## Structure du projet

```
platfrom_technova/
│
├── backend/                    ← API Node.js/Express
│   ├── server.js               ← Point d'entrée, configuration CORS
│   ├── db.js                   ← Pool de connexion PostgreSQL
│   ├── routes/
│   │   ├── business.js         ← MRR, ARPU, Plans, KPIs exécutifs
│   │   ├── support.js          ← Tickets, CSAT, SLA, Délais
│   │   ├── users.js            ← Sessions, MAU, Bounce, OS, Pays
│   │   └── performance.js      ← CPU, RAM, Uptime, Incidents
│   └── package.json
│
├── src/                        ← Application React
│   ├── App.jsx                 ← Routeur principal + état auth
│   ├── index.css               ← Styles globaux
│   ├── pages/
│   │   ├── Login.jsx           ← Page de connexion (split layout)
│   │   ├── Business.jsx        ← Dashboard Vue Exécutive
│   │   ├── Users.jsx           ← Dashboard Monétisation
│   │   ├── Tech.jsx            ← Dashboard Engagement Utilisateurs
│   │   ├── Support.jsx         ← Dashboard Support Client
│   │   ├── Performance.jsx     ← Dashboard Performance Serveur
│   │   └── Prediction.jsx      ← Module Prédiction ML
│   ├── components/
│   │   ├── Sidebar.jsx         ← Navigation latérale
│   │   ├── Topbar.jsx          ← Barre supérieure + déconnexion
│   │   └── KPICard.jsx         ← Carte KPI réutilisable
│   └── hooks/
│       └── useApi.js           ← Hook de fetch (state + loading + error)
│
└── package.json                ← Config React + proxy → localhost:5000
```

---

## Flux de données

Voici le chemin complet d'une donnée depuis la base jusqu'à l'écran :

```
1. UTILISATEUR navigue vers un dashboard
         │
         ▼
2. React monte le composant (ex: Support.jsx)
   → useApi('/api/support/kpis') est appelé
         │
         ▼
3. useApi.js exécute fetch('/api/support/kpis')
   → Le proxy React (package.json) redirige vers
     http://localhost:5000/api/support/kpis
         │
         ▼
4. Express (server.js) reçoit la requête
   → route vers routes/support.js → handler /kpis
         │
         ▼
5. db.query(SQL) interroge PostgreSQL
   → SELECT COUNT(*), AVG(csat_score)...
     FROM technova_dw.fact_support
         │
         ▼
6. PostgreSQL retourne les rows[]
   → Express formate en JSON et répond
   → { total_tickets: 300, csat_moyen: 2.95, sla_pct: 92.02, ... }
         │
         ▼
7. useApi.js reçoit le JSON → setData(json)
   → React re-render avec les données réelles
         │
         ▼
8. Support.jsx affiche :
   → <KPICard value="300" label="NB TICKETS" />
   → <BarChart data={tickets} />
   → <PieChart data={priorite} />
```

---

## Prérequis

Avant d'installer le projet, assurez-vous d'avoir :

| Outil | Version minimale | Vérification |
|-------|-----------------|--------------|
| Node.js | 18+ | `node --version` |
| npm | 9+ | `npm --version` |
| PostgreSQL | 14+ | `psql --version` |

---

## Installation

### 1. Cloner / ouvrir le projet

```bash
cd "C:\Users\Nexus PC\Desktop\PFE\platfrom_technova"
```

### 2. Configurer la base de données PostgreSQL

Ouvrir pgAdmin ou psql et vérifier que la base existe :

```sql
-- Se connecter à PostgreSQL
psql -U postgres -h localhost

-- Vérifier la base de données
\l

-- Se connecter à technova_dw
\c technova_dw

-- Vérifier les tables
\dt technova_dw.*
```

Les tables requises :
- `technova_dw.fact_subscriptions`
- `technova_dw.fact_support`
- `technova_dw.fact_sessions`
- `technova_dw.fact_serverperformance`
- `technova_dw.dim_user`
- `technova_dw.dim_time`

### 3. Vérifier la configuration de connexion

Fichier `backend/db.js` — modifier si nécessaire :

```js
const pool = new Pool({
  host:     'localhost',   // adresse PostgreSQL
  port:     5432,          // port PostgreSQL
  user:     'postgres',    // nom d'utilisateur
  password: 'mansour',     // mot de passe
  database: 'technova_dw', // nom de la base
});
```

### 4. Installer les dépendances Backend

```bash
cd backend
npm install
```

Packages installés : `express`, `cors`, `pg`

### 5. Installer les dépendances Frontend

```bash
# Revenir à la racine du projet
cd ..

npm install
```

Packages installés : `react`, `react-dom`, `react-scripts`, `recharts`

---

## Démarrage

> ⚠️ **Important** : ouvrir **deux terminaux séparés** et démarrer le backend **en premier**.

### Terminal 1 — Backend API

```bash
cd "C:\Users\Nexus PC\Desktop\PFE\platfrom_technova\backend"
node server.js
```

Résultat attendu :
```
TechNova API → http://localhost:5000
```

Vérification : ouvrir http://localhost:5000/api/health  
Réponse attendue : `{ "status": "ok", "db": "connected" }`

### Terminal 2 — Frontend React

```bash
cd "C:\Users\Nexus PC\Desktop\PFE\platfrom_technova"
npm start
```

Résultat attendu :
```
Compiled successfully!
Local: http://localhost:3000
```

### Ouvrir l'application

```
http://localhost:3000
```

---

## Comptes de démonstration

Sur la page de connexion, trois comptes sont disponibles :

| Utilisateur | Mot de passe | Rôle |
|-------------|-------------|------|
| `admin` | `admin123` | Administrateur |
| `manager` | `manager123` | Manager |
| `viewer` | `viewer123` | Viewer |

> Les chips de démonstration sur la page login remplissent automatiquement les champs.

---

## Endpoints API

### `/api/business`

| Endpoint | Description |
|----------|-------------|
| `GET /kpis` | MRR, Churn %, CSAT, SLA %, Uptime % |
| `GET /mrr` | MRR mensuel (historique) |
| `GET /plan-distribution` | Répartition par plan (actifs) |
| `GET /revenu-plan` | Revenu total par plan |
| `GET /desabo-plan` | Taux de churn par plan |
| `GET /top-clients` | Top 6 clients par revenu |
| `GET /mode-paiement` | Abonnements par mode de paiement |

### `/api/support`

| Endpoint | Description |
|----------|-------------|
| `GET /kpis` | Nb tickets, résolution %, critiques, délai moyen |
| `GET /tickets-categorie` | Tickets groupés par catégorie |
| `GET /tickets-priorite` | Tickets groupés par priorité |
| `GET /csat-categorie` | CSAT moyen par catégorie |
| `GET /delai-priorite` | Délai résolution moyen par priorité |

### `/api/users`

| Endpoint | Description |
|----------|-------------|
| `GET /kpis` | Nb sessions, MAU, Bounce %, Durée moyenne |
| `GET /sessions-monthly` | Sessions par mois (historique) |
| `GET /sessions-os` | Sessions par système d'exploitation |
| `GET /sessions-navigateur` | Sessions par navigateur |
| `GET /sessions-pays` | Sessions par pays |
| `GET /sessions-device` | Sessions par type de device |
| `GET /top-pages` | Top 5 pages visitées |

### `/api/performance`

| Endpoint | Description |
|----------|-------------|
| `GET /kpis` | Temps réponse, RAM, CPU, nb incidents |
| `GET /cpu-ram-monthly` | Évolution CPU & RAM par mois |
| `GET /etat-serveur` | Répartition OK / Dégradé / Panne |
| `GET /charge-monthly` | Charge serveur & taux d'erreur par mois |
| `GET /temps-reponse-monthly` | Temps de réponse moyen par mois |

---

## Pages du dashboard

| Page | Route interne | Description |
|------|--------------|-------------|
| Vue Exécutive | `business` | KPIs stratégiques : MRR, Churn, CSAT, SLA, Uptime |
| Monétisation | `users` | ARPU, revenus par plan, top clients, churn |
| Engagement | `tech` | Sessions, MAU, OS, navigateurs, pays, pages |
| Support Client | `support` | Tickets, CSAT par catégorie, délais, priorités |
| Performance | `performance` | CPU, RAM, état serveur, charge, temps réponse |
| Prédiction ML | `prediction` | Modèles ML : Rég. Log., Random Forest, XGBoost, ANN |

---

## Valeurs KPI clés (base technova_dw)

| KPI | Valeur | Formule |
|-----|--------|---------|
| MRR | 11 896 TND | `SUM(prix_mensuel_tnd) WHERE est_actif = 1` |
| Churn % | 2.41 % | Taux mensuel |
| CSAT | 2.95 / 5 | `AVG(csat_score) WHERE est_resolu = 1` |
| SLA % | 92.02 % | `SUM(est_sla_respecte) / SUM(est_resolu)` |
| Uptime % | 98.25 % | `SUM(statut='OK') / COUNT(*)` |

---

*PFE 2025 · ESPRIT · Mansour*
