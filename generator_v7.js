const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

/**
 * MASSIVE DATA SEED V7 - "REALISMO CAMPUS"
 * Narrative: 
 * - 13 Total Users (1 Admin, 5 Sellers, 7 Buyers).
 * - Antonio de Hoyos sells burritos.
 * - Progressive Registration over 60 days.
 * - 8:00 AM - 4:00 PM operating hours.
 * - 2-week pause starting late March, resumes this Monday April 13.
 */

const sql = [];
const today = new Date('2026-04-14T19:00:00Z');
const startHistory = new Date('2026-02-14T08:00:00Z');
const pauseStart = new Date('2026-03-30T00:00:00Z');
const resumeDate = new Date('2026-04-13T08:00:00Z');

// Password hash for 'TienditaAdmin2026Secure'
const HASH = '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0'; 

const esc = (str) => str ? str.replace(/'/g, "''") : '';

// 1. Users Definition (13 Total)
const sellers = [
    { email: 'antonio.dehoyos@tienditacampus.com', firstName: 'Antonio', lastName: 'de Hoyos', role: 'seller', specialty: 'Burritos' },
    { email: 'marian.perez@campus.mx', firstName: 'Marian', lastName: 'Perez', role: 'seller', specialty: 'Postres' },
    { email: 'pablo.sanchez@campus.mx', firstName: 'Pablo', lastName: 'Sanchez', role: 'seller', specialty: 'Snacks' },
    { email: 'lucia.gomez@u.mx', firstName: 'Lucia', lastName: 'Gomez', role: 'seller', specialty: 'Bebidas' },
    { email: 'diego.martinez@u.mx', firstName: 'Diego', lastName: 'Martinez', role: 'seller', specialty: 'Tortas' },
];

const buyers = [
    { email: 'elena.rodriguez@u.mx', firstName: 'Elena', lastName: 'Rodriguez' },
    { email: 'rogelio.montes@u.mx', firstName: 'Rogelio', lastName: 'Montes' },
    { email: 'sofia.castro@u.mx', firstName: 'Sofia', lastName: 'Castro' },
    { email: 'mateo.valdez@u.mx', firstName: 'Mateo', lastName: 'Valdez' },
    { email: 'isabella.rios@u.mx', firstName: 'Isabella', lastName: 'Rios' },
    { email: 'javier.luna@u.mx', firstName: 'Javier', lastName: 'Luna' },
    { email: 'camila.solis@u.mx', firstName: 'Camila', lastName: 'Solis' },
];

const admin = { email: 'jarassanchezl@gmail.com', firstName: 'Isaac', lastName: 'Jaras', role: 'admin' };

const allUsers = [admin, ...sellers, ...buyers.map(b => ({ ...b, role: 'buyer' }))];
const userMap = {};

sql.push('-- MASSIVE DATA SEED V7 - REALISMO CAMPUS');
sql.push('BEGIN;');
sql.push('TRUNCATE TABLE audit_logs, sale_details, daily_sales, inventory_records, order_items, orders, products, categories, users CASCADE;');

// 2. Insert Users (Progressive Registration Logic)
allUsers.forEach((u, i) => {
    const id = uuidv4();
    userMap[u.email] = { id, data: u };
    
    // Spread registration over the first month
    const regDate = new Date(startHistory);
    regDate.setDate(regDate.getDate() + (i * 3)); // 2 per week approx
    
    sql.push(`INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('${id}', '${u.email}', '${HASH}', '${esc(u.firstName)}', '${esc(u.lastName)}', '${u.role}', true, true, '${regDate.toISOString()}');`);
    
    // Audit Login for registration
    sql.push(`INSERT INTO audit_logs (id, action, user_id, description, level, created_at) 
              VALUES ('${uuidv4()}', 'USER_REGISTERED', '${id}', 'Usuario ${u.email} registrado en el sistema', 'info', '${regDate.toISOString()}');`);
});

// 3. Categories
const catFoodId = uuidv4();
const catDrinkId = uuidv4();
const catSnackId = uuidv4();

sql.push(`INSERT INTO categories (id, name, description) VALUES ('${catFoodId}', 'Alimentos Preparados', 'Comidas calientes y snacks del día');`);
sql.push(`INSERT INTO categories (id, name, description) VALUES ('${catDrinkId}', 'Bebidas', 'Refrescos y jugos naturales');`);
sql.push(`INSERT INTO categories (id, name, description) VALUES ('${catSnackId}', 'Snacks y Dulces', 'Botanas empaquetadas');`);

// 4. Products Diversity
const products = [
    { id: uuidv4(), name: 'Burritos Mixtos (Antonio)', price: 75, cost: 40, seller: 'antonio.dehoyos@tienditacampus.com', cat: catFoodId, img: 'https://images.unsplash.com/photo-1584031036380-3fb6f2d51882?q=80&w=800' },
    { id: uuidv4(), name: 'Pastel de Chocolate', price: 45, cost: 20, seller: 'marian.perez@campus.mx', cat: catFoodId, img: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?q=80&w=800' },
    { id: uuidv4(), name: 'Papas Caseras', price: 30, cost: 12, seller: 'pablo.sanchez@campus.mx', cat: catSnackId, img: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?q=80&w=800' },
    { id: uuidv4(), name: 'Agua de Jamaica 1L', price: 25, cost: 8, seller: 'lucia.gomez@u.mx', cat: catDrinkId, img: 'https://images.unsplash.com/photo-1556881286-fc6915169721?q=80&w=800' },
    { id: uuidv4(), name: 'Torta de Jamón', price: 55, cost: 25, seller: 'diego.martinez@u.mx', cat: catFoodId, img: 'https://images.unsplash.com/photo-1553909489-cd47e0907980?q=80&w=800' },
];

products.forEach(p => {
    sql.push(`INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable, image_url) 
              VALUES ('${p.id}', '${userMap[p.seller].id}', '${p.cat}', '${esc(p.name)}', 'Producto premium de alta calidad', ${p.cost}, ${p.price}, true, '${startHistory.toISOString()}', true, '${p.img}');`);
});

// 5. DAILY SIMULATION LOGIC (8 AM - 4 PM)
let loopDate = new Date(startHistory);
while (loopDate <= today) {
    // Skip if in pause period
    if (loopDate >= pauseStart && loopDate < resumeDate) {
        loopDate.setDate(loopDate.getDate() + 1);
        continue;
    }

    // Skip Sundays
    if (loopDate.getDay() === 0) {
        loopDate.setDate(loopDate.getDate() + 1);
        continue;
    }

    products.forEach(p => {
        const sellerId = userMap[p.seller].id;
        
        // Random time between 8 AM and 10 AM for Login and Inventory
        const loginTime = new Date(loopDate);
        loginTime.setHours(8, Math.floor(Math.random() * 30), 0);
        
        sql.push(`INSERT INTO audit_logs (id, action, user_id, description, level, created_at) 
                  VALUES ('${uuidv4()}', 'USER_LOGIN', '${sellerId}', 'Vendedor inició sesión para jornada', 'info', '${loginTime.toISOString()}');`);

        // Create Daily Sale Record
        const dailyId = uuidv4();
        const dateStr = loopDate.toISOString().split('T')[0];
        
        // Sales Volume varies by time: 2-8 units per product per day
        const qtyPrepared = 10 + Math.floor(Math.random() * 5);
        const qtySold = qtyPrepared - Math.floor(Math.random() * 3);
        const qtyLost = qtyPrepared - qtySold;
        
        sql.push(`INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('${dailyId}', '${sellerId}', '${dateStr}', ${qtyPrepared * p.cost}, ${qtySold * p.price}, ${qtySold}, ${qtyLost}, ${qtyLost * p.cost}, true);`);
        
        sql.push(`INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                  VALUES ('${uuidv4()}', '${dailyId}', '${p.id}', ${qtyPrepared}, ${qtySold}, ${qtyLost}, ${p.cost}, ${p.price}, ${qtyLost * p.cost}, 'expired');`);

        // Individual Orders from 10 AM to 4 PM
        for (let j = 0; j < qtySold; j++) {
            const orderTime = new Date(loopDate);
            orderTime.setHours(10 + Math.floor(Math.random() * 6), Math.floor(Math.random() * 60));
            
            const buyer = buyers[Math.floor(Math.random() * buyers.length)];
            const buyerId = userMap[buyer.email].id;
            const orderId = uuidv4();
            
            sql.push(`INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
                      VALUES ('${orderId}', '${buyerId}', '${sellerId}', ${p.price}, 'completed', '${orderTime.toISOString()}');`);
            sql.push(`INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) 
                      VALUES ('${uuidv4()}', '${orderId}', '${p.id}', 1, ${p.price}, ${p.price}, '${orderTime.toISOString()}');`);
        }
    });

    loopDate.setDate(loopDate.getDate() + 1);
}

sql.push('COMMIT;');

fs.writeFileSync('massive_seed_v7.sql', sql.join('\n'));
console.log('--- GENERATOR V7 SUCCESS ---');
console.log('13 Users, 5 Sellers, Progressive History generated.');
console.log('Pause integrated (March 30 - April 13).');
console.log('SQL generated: massive_seed_v7.sql');
