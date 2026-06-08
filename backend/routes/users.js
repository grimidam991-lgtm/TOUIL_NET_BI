const router = require('express').Router();
const db = require('../db');

const FR_MOIS = {
  January:'Jan', February:'Fév', March:'Mar', April:'Avr', May:'Mai',
  June:'Jun', July:'Jul', August:'Aoû', September:'Sep',
  October:'Oct', November:'Nov', December:'Déc',
};
const label = (r) => `${FR_MOIS[r.nom_mois] || r.nom_mois} ${String(r.annee).slice(2)}`;

/* KPIs utilisateurs + engagement (matches Power BI Engagement page) */
router.get('/kpis', async (_, res) => {
  try {
    const [u, s] = await Promise.all([
      db.query(`
        SELECT COUNT(*) AS total_users,
               SUM(CASE WHEN est_payant = 1 THEN 1 ELSE 0 END) AS users_payants,
               COUNT(DISTINCT pays) AS nb_pays
        FROM technova_dw.dim_user WHERE user_sk > 0`),
      db.query(`
        SELECT COUNT(DISTINCT user_sk)                              AS mau,
               ROUND(100.0*SUM(bounce)/NULLIF(COUNT(*),0), 2)      AS bounce_pct,
               ROUND(AVG(duree_minutes)::numeric, 2)               AS duree_moy_min,
               COUNT(*)                                            AS nb_sessions
        FROM technova_dw.fact_sessions`),
    ]);
    res.json({ ...u.rows[0], ...s.rows[0] });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Sessions par device */
router.get('/sessions-device', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT device, COUNT(*) AS nb
      FROM technova_dw.fact_sessions
      GROUP BY device ORDER BY nb DESC
    `);
    res.json(rows.map(r => ({ device: r.device, nb: Number(r.nb), color: '#2196F3' })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Sessions par OS */
router.get('/sessions-os', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT os AS name, COUNT(*) AS value
      FROM technova_dw.fact_sessions
      GROUP BY os ORDER BY value DESC
    `);
    const total = rows.reduce((s, r) => s + Number(r.value), 0);
    const colors = ['#2196F3','#1A237E','#FF9800','#9C27B0','#E91E63'];
    res.json(rows.map((r, i) => ({
      name: r.name, value: Number(r.value),
      pct: Number(((r.value / total) * 100).toFixed(2)),
      color: colors[i] || '#607D8B',
    })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Sessions par navigateur */
router.get('/sessions-navigateur', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT navigateur AS nav, COUNT(*) AS nb
      FROM technova_dw.fact_sessions
      GROUP BY navigateur ORDER BY nb DESC
    `);
    res.json(rows.map(r => ({ nav: r.nav, nb: Number(r.nb) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Sessions par pays (via dim_user) */
router.get('/sessions-pays', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT u.pays, COUNT(*) AS nb
      FROM technova_dw.fact_sessions s
      JOIN technova_dw.dim_user u ON u.user_sk = s.user_sk
      WHERE u.pays IS NOT NULL AND u.user_sk > 0
      GROUP BY u.pays ORDER BY nb DESC LIMIT 10
    `);
    res.json(rows.map(r => ({ pays: r.pays, nb: Number(r.nb) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Sessions mensuelles */
router.get('/sessions-monthly', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT t.nom_mois, t.annee, t.mois, COUNT(*) AS nb
      FROM technova_dw.fact_sessions s
      JOIN technova_dw.dim_time t ON t.date_sk = s.date_sk
      GROUP BY t.annee, t.mois, t.nom_mois
      ORDER BY t.annee, t.mois
    `);
    res.json(rows.map(r => ({ mois: label(r), nb: Number(r.nb) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Top pages — top_page_categorie direct from fact_sessions (matches Power BI) */
router.get('/top-pages', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT top_page_categorie AS page, COUNT(*) AS nb
      FROM technova_dw.fact_sessions
      WHERE top_page_categorie IS NOT NULL
      GROUP BY top_page_categorie ORDER BY nb DESC LIMIT 6
    `);
    res.json(rows.map(r => ({ page: r.page, nb: Number(r.nb) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Utilisateurs par plan */
router.get('/users-plan', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT plan AS name, COUNT(*) AS value
      FROM technova_dw.dim_user
      WHERE user_sk > 0
      GROUP BY plan ORDER BY value DESC
    `);
    const total = rows.reduce((s, r) => s + Number(r.value), 0);
    const colors = { Premium: '#2196F3', Standard: '#FF9800', Entreprise: '#1A237E' };
    res.json(rows.map(r => ({
      name: r.name, value: Number(r.value),
      pct: Number(((r.value / total) * 100).toFixed(2)),
      color: colors[r.name] || '#9C27B0',
    })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
