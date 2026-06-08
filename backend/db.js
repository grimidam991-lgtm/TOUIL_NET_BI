const { Pool } = require('pg');

const pool = new Pool({
  host:     'localhost',
  port:     5432,
  user:     'postgres',
  password: 'mansour',
  database: 'technova_dw',
  options:  '-c search_path=technova_dw',
});

pool.on('error', (err) => {
  console.error('PostgreSQL pool error:', err.message);
});

module.exports = pool;
