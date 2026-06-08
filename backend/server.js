const express = require('express');
const cors    = require('cors');

const app = express();
app.use(cors({ origin: 'http://localhost:3000' }));
app.use(express.json());

app.use('/api/business',    require('./routes/business'));
app.use('/api/users',       require('./routes/users'));
app.use('/api/support',     require('./routes/support'));
app.use('/api/performance', require('./routes/performance'));

/* Health check */
app.get('/api/health', async (_, res) => {
  try {
    const db = require('./db');
    await db.query('SELECT 1');
    res.json({ status: 'ok', db: 'connected' });
  } catch (e) {
    res.status(500).json({ status: 'error', db: e.message });
  }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`TechNova API → http://localhost:${PORT}`));
