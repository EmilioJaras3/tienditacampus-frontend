cd /home/ubuntu/backend
set -a
source .env
cat > /home/ubuntu/backend/check_product_ids.js <<'NODE'
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
  const res = await client.query("SELECT id, name, seller_id, image_url IS NOT NULL AS has_image, is_active FROM products WHERE id IN ('7695e658-446a-4002-b271-99a76f791f05','2f8deb45-831b-4c8e-860c-e00c6817eed7')");
  console.log(JSON.stringify(res.rows, null, 2));
  await client.end();
})().catch((err) => { console.error(err); process.exit(1); });
NODE
node /home/ubuntu/backend/check_product_ids.js
rm -f /home/ubuntu/backend/check_product_ids.js