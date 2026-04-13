const { Client } = require('pg');

async function injectMaster() {
    const client = new Client({
        host: 'localhost',
        port: 5433,
        user: 'postgres',
        password: 'postgres',
        database: 'tienditacampus'
    });

    try {
        await client.connect();
        console.log('Connectado a la DB...');

        // Verify if users table exists
        const res = await client.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_name = 'users'
            );
        `);
        
        if (!res.rows[0].exists) {
            console.log('🚨 Error: La tabla "users" aún no existe. Espera a que NestJS termine de arrancar e inténtalo de nuevo.');
            process.exit(1);
        }

        // We use the hash from master_seed.sql which equals 'pass' 
        const hashPass = '$argon2id$v=19$m=19456,t=2,p=1$eEuPX0rncbrhqyauxqwjFg$re8m+2AptH43M1r19yD0Xf8C9dM2WdHxIU+/7Bh';
        
        // Remove old master if exists
        await client.query("DELETE FROM users WHERE email = 'master@tienditacampus.com'");

        // Insert new master
        const insertQuery = `
            INSERT INTO users (id, email, password_hash, first_name, last_name, role) 
            VALUES (gen_random_uuid(), 'master@tienditacampus.com', $1, 'Super', 'Admin', 'admin')
            RETURNING *;
        `;
        
        const result = await client.query(insertQuery, [hashPass]);
        console.log('✅ Usuario master inyectado con éxito:');
        console.log(`Email: master@tienditacampus.com`);
        console.log(`Password: pass`);

    } catch (err) {
        console.error('Error inyectando el admin:', err);
    } finally {
        await client.end();
    }
}

injectMaster();
