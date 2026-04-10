const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

// Dates configuration
const today = new Date('2026-04-08');
const startDate = new Date('2026-02-08'); // Exactly 2 months ago

const sql = [];

// Helper to escape strings
const esc = (str) => str.replace(/'/g, "''");

// Password hash for 'admin_password_123'
const HASH = '$argon2id$v=19$m=65536,t=3,p=4$6m4Lg7S7Kvz/nQ+J3F8A/A$GqB0lT7Y3g4m5Y6h7j8k9l0m1n2o3p4q5r6s7t8u9v0';

// Users configuration
const users = [
    { email: 'master@tienditacampus.com', role: 'admin', firstName: 'Admin', lastName: 'Master', active: true },
    { email: 'antonio.hoyos@campus.com', role: 'seller', firstName: 'Antonio', lastName: 'de Hoyos', active: true },
    { email: 'vendedor1@campus.com', role: 'seller', firstName: 'Juan', lastName: 'Perez', active: true },
    { email: 'vendedor2@campus.com', role: 'seller', firstName: 'Maria', lastName: 'Gomez', active: true },
    { email: 'vendedor3@campus.com', role: 'seller', firstName: 'Luis', lastName: 'Rodriguez', active: true },
    { email: 'comprador1@campus.com', role: 'buyer', firstName: 'Estudiante', lastName: 'Prueba', active: true },
];

for (let i = 1; i <= 36; i++) {
    users.push({ 
        email: `user${i}@inactive.com`, 
        role: 'buyer', 
        firstName: `User`, 
        lastName: `${i}`, 
        active: false 
    });
}

const userMap = {};

// 1. DDL for Views (extracted from backend/infrastructure/database/views)
const VIEW_ROI = `
CREATE OR REPLACE VIEW vw_seller_roi AS
SELECT
    seller_id,
    SUM(total_investment) as global_investment,
    SUM(total_revenue) as global_revenue,
    (SUM(total_revenue) - SUM(total_investment)) as global_net_profit,
    CASE 
        WHEN SUM(total_investment) > 0 THEN ((SUM(total_revenue) - SUM(total_investment)) / SUM(total_investment)) * 100 
        ELSE 0 
    END as global_roi_pct
FROM daily_sales
GROUP BY seller_id;
`;

const VIEW_WEEKDAY = `
CREATE OR REPLACE VIEW vw_weekday_analytics AS
SELECT
    seller_id,
    EXTRACT(DOW FROM CAST(sale_date AS DATE)) as weekday_index,
    TO_CHAR(CAST(sale_date AS DATE), 'Day') as weekday_name,
    AVG(total_revenue) as avg_revenue,
    AVG(total_investment) as avg_investment,
    SUM(units_sold) as total_units_sold,
    SUM(units_lost) as total_units_lost
FROM daily_sales
GROUP BY seller_id, weekday_index, weekday_name;
`;

// Categories
const catFoodId = uuidv4();
const catDrinkId = uuidv4();
const catSnackId = uuidv4();

sql.push('-- MASSIVE DATA SEED V3.1 - CLEAN START');
sql.push('BEGIN;');
sql.push('TRUNCATE TABLE sale_details, daily_sales, inventory_records, products, categories, users CASCADE;');

// Views Creation
sql.push(VIEW_ROI);
sql.push(VIEW_WEEKDAY);

// Insert Users
users.forEach(u => {
    const id = uuidv4();
    userMap[u.email] = id;
    sql.push(`INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified, created_at) 
              VALUES ('${id}', '${u.email}', '${HASH}', '${esc(u.firstName)}', '${esc(u.lastName)}', '${u.role}', ${u.active}, true, '${startDate.toISOString()}');`);
});

// Insert Categories
sql.push(`INSERT INTO categories (id, name, description) VALUES ('${catFoodId}', 'Comida Preparada', 'Platillos caseros hechos por alumnos');`);
sql.push(`INSERT INTO categories (id, name, description) VALUES ('${catDrinkId}', 'Bebidas', 'Refrigerios fríos y calientes');`);
sql.push(`INSERT INTO categories (id, name, description) VALUES ('${catSnackId}', 'Snacks', 'Botanas y golosinas');`);

// Products Variety
const products_list = [
    { id: uuidv4(), name: 'Burritos Mixtos', price: 70, cost: 45, seller: 'antonio.hoyos@campus.com', cat: catFoodId, desc: 'Frijoles con queso y guisado' },
    { id: uuidv4(), name: 'Coca-Cola 600ml', price: 20, cost: 14, seller: 'vendedor1@campus.com', cat: catDrinkId, desc: 'Muy fría' },
    { id: uuidv4(), name: 'Torta de Chilaquiles', price: 85, cost: 50, seller: 'vendedor2@campus.com', cat: catFoodId, desc: 'Picositas y ricas' },
    { id: uuidv4(), name: 'Café Americano', price: 25, cost: 8, seller: 'vendedor3@campus.com', cat: catDrinkId, desc: 'Café de grano recién hecho' },
    { id: uuidv4(), name: 'Papas Caseras', price: 35, cost: 15, seller: 'antonio.hoyos@campus.com', cat: catSnackId, desc: 'Con sal y limón' },
    { id: uuidv4(), name: 'Agua de Horchata', price: 30, cost: 12, seller: 'vendedor1@campus.com', cat: catDrinkId, desc: '100% natural' },
    { id: uuidv4(), name: 'Brownie de Chocolate', price: 40, cost: 18, seller: 'vendedor2@campus.com', cat: catSnackId, desc: 'Horneados hoy mismo' },
    { id: uuidv4(), name: 'Ensalada de Frutas', price: 50, cost: 25, seller: 'vendedor3@campus.com', cat: catFoodId, desc: 'Fresca y variada' }
];

products_list.forEach(p => {
    sql.push(`INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_active, created_at, is_perishable) 
              VALUES ('${p.id}', '${userMap[p.seller]}', '${p.cat}', '${esc(p.name)}', '${esc(p.desc)}', ${p.cost}, ${p.price}, true, '${startDate.toISOString()}', true);`);
    
    // Initial inventory to make products visible in marketplace
    sql.push(`INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, status, created_at) 
              VALUES ('${uuidv4()}', '${p.id}', 100, 50, ${p.cost}, 'active', NOW());`);
});

// DAILY TRANSACTIONS
let currentDate = new Date(startDate);
while (currentDate <= today) {
    const dateStr = currentDate.toISOString().split('T')[0];
    
    // Process each seller
    const activeSellers = ['antonio.hoyos@campus.com', 'vendedor1@campus.com', 'vendedor2@campus.com', 'vendedor3@campus.com'];
    
    activeSellers.forEach(email => {
        const sellerId = userMap[email];
        const sellerProducts = products_list.filter(p => p.seller === email);
        
        let dayInvestment = 0;
        let dayRevenue = 0;
        let daySold = 0;
        let dayLost = 0;
        let dayWasteCost = 0;
        const dailyId = uuidv4();
        
        const detailQueries = [];
        
        sellerProducts.forEach(p => {
            const qty = Math.floor(Math.random() * 8) + 5; // 5-12 items
            const sold = qty - (Math.random() > 0.85 ? 1 : 0); // ~15% loss
            const lost = qty - sold;
            
            dayInvestment += qty * p.cost;
            dayRevenue += sold * p.price;
            daySold += sold;
            dayLost += lost;
            dayWasteCost += lost * p.cost;
            
            detailQueries.push(`INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_cost, unit_price, waste_cost, waste_reason) 
                                VALUES ('${uuidv4()}', '${dailyId}', '${p.id}', ${qty}, ${sold}, ${lost}, ${p.cost}, ${p.price}, ${lost * p.cost}, ${lost > 0 ? "'expired'" : 'NULL'});`);
        });
        
        sql.push(`INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, units_sold, units_lost, total_waste_cost, is_closed) 
                  VALUES ('${dailyId}', '${sellerId}', '${dateStr}', ${dayInvestment}, ${dayRevenue}, ${daySold}, ${dayLost}, ${dayWasteCost}, true);`);
        
        detailQueries.forEach(dq => sql.push(dq));
    });

    currentDate.setDate(currentDate.getDate() + 1);
}

sql.push('COMMIT;');

fs.writeFileSync('massive_seed.sql', sql.join('\n'));
console.log('SQL generated: massive_seed.sql (V3 with Analytics Views)');
