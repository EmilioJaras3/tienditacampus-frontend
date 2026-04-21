cd /home/ubuntu/backend
set -a
source .env
cat > /home/ubuntu/backend/check_private_db_after.js <<'NODE'
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
  const res = await client.query("SELECT table_name, column_name, data_type, character_maximum_length, is_nullable FROM information_schema.columns WHERE table_name IN ('products','inventory_records') AND column_name IN ('image_url','unit_cost') ORDER BY table_name, column_name");
  console.log(JSON.stringify(res.rows, null, 2));
  await client.end();
})().catch((err) => { console.error(err); process.exit(1); });
NODE
node /home/ubuntu/backend/check_private_db_after.js
rm -f /home/ubuntu/backend/check_private_db_after.js