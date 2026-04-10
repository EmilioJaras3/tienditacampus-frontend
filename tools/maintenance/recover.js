const argon2 = require('@node-rs/argon2');
const { Client } = require('pg');

async function repair() {
    try {
        console.log("Generating fresh hash natively...");
        const newHash = await argon2.hash('pass');
        console.log("New hash:", newHash);

        const client = new Client({
            host: 'db',
            port: 5432,
            user: 'postgres',
            password: 'postgres',
            database: 'tienditacampus'
        });
        await client.connect();
        
        await client.query(`
            UPDATE users 
            SET password_hash = $1 
            WHERE email = 'master@tienditacampus.com'
        `, [newHash]);
        
        console.log("Database perfectly patched with Native Hash!");
        await client.end();
    } catch(e) {
        console.error("Error:", e);
    }
}
repair();
