const router = require('express').Router();
const db = require('../db');

/* Years present in the DW */
router.get('/annees', async (_, res) => {
  try {
    const { rows } = await db.query(`
      SELECT DISTINCT annee FROM technova_dw.dim_time
      ORDER BY annee ASC
    `);
    res.json(rows.map(r => Number(r.annee)));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

module.exports = router;
