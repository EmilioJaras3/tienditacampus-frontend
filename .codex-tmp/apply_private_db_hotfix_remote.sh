cd /home/ubuntu/backend
set -a
source .env
cat > /home/ubuntu/backend/apply_private_db_hotfix.js <<'NODE'
const { Client } = require("pg");
(async () => {
  const client = new Client({
    host: process.env.POSTGRES_HOST,
    port: Number(process.env.POSTGRES_PORT),
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB,
  });
  await client.connect();
  await client.query("ALTER TABLE products ALTER COLUMN image_url TYPE text");
  await client.query("ALTER TABLE inventory_records ADD COLUMN IF NOT EXISTS unit_cost numeric(10,2)");
  await client.query("UPDATE inventory_records SET unit_cost = CASE WHEN quantity_initial > 0 THEN ROUND((investment_amount / quantity_initial)::numeric, 2) ELSE 0 END WHERE unit_cost IS NULL OR unit_cost = 0");
  await client.query("ALTER TABLE inventory_records ALTER COLUMN unit_cost SET DEFAULT 0");
  await client.query("UPDATE inventory_records SET unit_cost = 0 WHERE unit_cost IS NULL");
  await client.query("ALTER TABLE inventory_records ALTER COLUMN unit_cost SET NOT NULL");
  console.log("private DB hotfix applied");
  await client.end();
})().catch((err) => { console.error(err); process.exit(1); });
NODE
node /home/ubuntu/backend/apply_private_db_hotfix.js
rm -f /home/ubuntu/backend/apply_private_db_hotfix.js