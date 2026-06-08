const router = require('express').Router();
const db = require('../db');

const FR_MOIS = {
  January:'Jan', February:'Fév', March:'Mar', April:'Avr', May:'Mai',
  June:'Jun', July:'Jul', August:'Aoû', September:'Sep',
  October:'Oct', November:'Nov', December:'Déc',
};
const label = (r) => `${FR_MOIS[r.nom_mois] || r.nom_mois} ${String(r.annee).slice(2)}`;

/* KPIs performance */
router.get('/kpis', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT
        ROUND(AVG(temps_reponse_ms)::numeric, 0)  AS temps_reponse_moyen,
        ROUND(AVG(taux_erreur_pct)::numeric, 2)   AS taux_erreur_moyen,
        ROUND(AVG(cpu_usage_pct)::numeric, 1)     AS cpu_moyen,
        ROUND(AVG(ram_usage_pct)::numeric, 1)     AS ram_moyen,
        SUM(nb_requetes)                           AS total_requetes,
        ROUND(100.0*SUM(CASE WHEN statut_serveur='OK' THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0),2) AS uptime_pct,
        SUM(CASE WHEN statut_serveur<>'OK' THEN 1 ELSE 0 END) AS nb_incidents
      FROM technova_dw.fact_serverperformance
    `);
    res.json(rows[0]);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* CPU & RAM mensuel */
router.get('/cpu-ram-monthly', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT t.nom_mois, t.annee, t.mois,
             ROUND(AVG(p.cpu_usage_pct)::numeric, 1) AS cpu,
             ROUND(AVG(p.ram_usage_pct)::numeric, 1) AS ram
      FROM technova_dw.fact_serverperformance p
      JOIN technova_dw.dim_time t ON t.date_sk = p.date_sk
      GROUP BY t.annee, t.mois, t.nom_mois
      ORDER BY t.annee, t.mois
    `);
    res.json(rows.map(r => ({ mois: label(r), cpu: Number(r.cpu), ram: Number(r.ram) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Temps de réponse mensuel */
router.get('/temps-reponse-monthly', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT t.nom_mois, t.annee, t.mois,
             ROUND(AVG(p.temps_reponse_ms)::numeric, 0) AS ms
      FROM technova_dw.fact_serverperformance p
      JOIN technova_dw.dim_time t ON t.date_sk = p.date_sk
      GROUP BY t.annee, t.mois, t.nom_mois
      ORDER BY t.annee, t.mois
    `);
    res.json(rows.map(r => ({ mois: label(r), ms: Number(r.ms) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* Charge serveur mensuelle */
router.get('/charge-monthly', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT t.nom_mois, t.annee, t.mois,
             SUM(p.nb_requetes)                          AS requetes,
             ROUND(AVG(p.taux_erreur_pct)::numeric, 2)  AS erreur
      FROM technova_dw.fact_serverperformance p
      JOIN technova_dw.dim_time t ON t.date_sk = p.date_sk
      GROUP BY t.annee, t.mois, t.nom_mois
      ORDER BY t.annee, t.mois
    `);
    res.json(rows.map(r => ({ mois: label(r), requetes: Number(r.requetes), erreur: Number(r.erreur) })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

/* État du serveur */
router.get('/etat-serveur', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT statut_serveur AS name, COUNT(*) AS value
      FROM technova_dw.fact_serverperformance
      GROUP BY statut_serveur ORDER BY value DESC
    `);
    const total = rows.reduce((s, r) => s + Number(r.value), 0);
    const colors = { OK: '#2196F3', 'En panne': '#1A237E', Dégradé: '#FF9800' };
    res.json(rows.map(r => ({
      name: r.name, value: Number(r.value),
      pct: Number(((r.value / total) * 100).toFixed(2)),
      color: colors[r.name] || '#607D8B',
    })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
