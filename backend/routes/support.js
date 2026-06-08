const router = require('express').Router();
const db = require('../db');

/* KPIs support */
router.get('/kpis', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT
        COUNT(*)                                              AS total_tickets,
        SUM(est_resolu)                                      AS resolus,
        COUNT(*) - SUM(est_resolu)                                   AS ouverts,
        ROUND(AVG(CASE WHEN est_resolu=1 THEN csat_score END)::numeric, 2) AS csat_moyen,
        ROUND(AVG(resolution_heures)::numeric, 1)                  AS delai_moyen_h,
        SUM(est_critique)                                          AS critiques,
        ROUND(100.0*SUM(est_resolu)/NULLIF(COUNT(*),0), 2)         AS taux_resolution_pct,
        ROUND(100.0*SUM(CASE WHEN est_resolu=1 THEN est_sla_respecte ELSE 0 END)/NULLIF(SUM(est_resolu),0), 2) AS sla_pct
      FROM technova_dw.fact_support
    `);
    res.json(rows[0]);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Tickets par catégorie */
router.get('/tickets-categorie', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT categorie, COUNT(*) AS nb
      FROM technova_dw.fact_support
      GROUP BY categorie ORDER BY nb DESC
    `);
    res.json(rows.map(r => ({ categorie: r.categorie, nb: Number(r.nb) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Tickets par priorité */
router.get('/tickets-priorite', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT priorite AS name, COUNT(*) AS value
      FROM technova_dw.fact_support
      GROUP BY priorite ORDER BY value DESC
    `);
    const total = rows.reduce((s, r) => s + Number(r.value), 0);
    const colors = { Moyenne: '#2196F3', Basse: '#1A237E', Haute: '#FF9800', Critique: '#9C27B0' };
    res.json(rows.map(r => ({
      name: r.name, value: Number(r.value),
      pct: Number(((r.value / total) * 100).toFixed(2)),
      color: colors[r.name] || '#607D8B',
    })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* CSAT moyen par catégorie */
router.get('/csat-categorie', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT categorie, ROUND(AVG(csat_score)::numeric, 2) AS csat
      FROM technova_dw.fact_support
      WHERE csat_score IS NOT NULL
      GROUP BY categorie ORDER BY csat DESC
    `);
    res.json(rows.map(r => ({ categorie: r.categorie, csat: Number(r.csat) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Délai résolution par priorité */
router.get('/delai-priorite', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT priorite, ROUND(AVG(resolution_heures)::numeric, 0) AS delai
      FROM technova_dw.fact_support
      WHERE resolution_heures IS NOT NULL
      GROUP BY priorite ORDER BY delai DESC
    `);
    res.json(rows.map(r => ({ priorite: r.priorite, delai: Number(r.delai) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
