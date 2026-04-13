const argon2 = require('@node-rs/argon2');
const { Client } = require('pg');

(async () => {
    try {
        const hash = await argon2.hash('Pass1234!');
        const client = new Client({ host: 'db', port: 5432, user: 'postgres', password: 'postgres', database: 'tienditacampus' });
        await client.connect();
        await client.query("DELETE FROM users WHERE email='master@tienditacampus.com'");
        await client.query("INSERT INTO users (id, email, password_hash, first_name, last_name, role) VALUES (gen_random_uuid(), 'master@tienditacampus.com', $1, 'Super', 'Admin', 'admin')", [hash]);
        console.log("SUCCESS_HASH_INJECTED");
        process.exit(0);
    } catch(e) {
        console.error(e);
        process.exit(1);
    }
})();
