const { hash } = require('@node-rs/argon2');
const { Client } = require('pg');

async function run() {
  const password = 'TienditaAdmin2026Secure';
  // Use same parameters from .env
  const hashed = await hash(password, {
    memoryCost: 19456,
    timeCost: 2,
    parallelism: 1
  });

  const client = new Client({
    connectionString: 'postgresql://tiendita_user:tiendita_password@172.31.74.4:5432/tienditacampus'
  });

  await client.connect();
  const res = await client.query('UPDATE users SET password_hash = $1 WHERE email = $2 RETURNING email', [hashed, 'jarassanchezl@gmail.com']);
  console.log('Updated user:', res.rows[0]);
  await client.end();
}

run().catch(console.error);
