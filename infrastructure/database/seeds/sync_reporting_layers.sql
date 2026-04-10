-- Sincronización de Capas de Reporte (Analytics)
-- Este script convierte las órdenes inyectadas en registros de daily_sales y sale_details

-- 1. Limpiar datos previos de dashboard (para evitar duplicados en esta fase de seeding)
DELETE FROM sale_details WHERE daily_sale_id IN (SELECT id FROM daily_sales);
DELETE FROM daily_sales;

-- 2. Poblar daily_sales basado en orders completadas
INSERT INTO daily_sales (id, seller_id, sale_date, total_revenue, total_investment, total_waste_cost, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    o.seller_id,
    o.created_at::date as sale_date,
    SUM(o.total_amount) as total_revenue,
    SUM(o.total_amount * 0.6) as total_investment, -- Asumimos 60% de costo
    SUM(o.total_amount * 0.05) as total_waste_cost, -- 5% de merma base
    MIN(o.created_at),
    MAX(o.created_at)
FROM orders o
WHERE o.status = 'completed'
GROUP BY o.seller_id, o.created_at::date;

-- 3. Poblar sale_details (desglose por producto real)
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, unit_cost, unit_price, waste_cost, created_at)
SELECT 
    gen_random_uuid(),
    ds.id,
    oi.product_id,
    SUM(oi.quantity) as quantity_prepared,
    SUM(oi.quantity) as quantity_sold,
    AVG(oi.unit_price * 0.6) as unit_cost,
    AVG(oi.unit_price) as unit_price,
    SUM(oi.unit_price * 0.05) as waste_cost,
    ds.created_at
FROM daily_sales ds
JOIN orders o ON o.seller_id = ds.seller_id AND o.created_at::date = ds.sale_date
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY ds.id, oi.product_id, ds.created_at;

-- 4. PATCH DE REALISMO: Renombrar productos genéricos
UPDATE products SET name = 'Chilaquiles Verdes Especiales' WHERE name LIKE '%Producto%' AND price > 80 LIMIT 1;
UPDATE products SET name = 'Café Americano 12oz' WHERE name LIKE '%Producto%' AND price BETWEEN 20 AND 35 LIMIT 1;
UPDATE products SET name = 'Torta de Chilaquil' WHERE name LIKE '%Producto%' AND price BETWEEN 40 AND 60 LIMIT 1;
UPDATE products SET name = 'Galletas de Avena (Venta Individual)' WHERE name LIKE '%Producto%' AND price < 20 LIMIT 1;
UPDATE products SET name = 'Impresiones B/N c/u' WHERE name LIKE '%Producto%' AND price < 5 LIMIT 1;
UPDATE products SET name = 'Burrito de Deshebrada' WHERE name LIKE '%Producto%' AND price > 30 LIMIT 5;
UPDATE products SET name = 'Refresco 600ml' WHERE name LIKE '%Producto%' AND price BETWEEN 15 AND 25 LIMIT 2;

-- 5. Ajuste de Hipótesis: Introducir variabilidad en la merma (Waste)
-- Queremos que algunos días tengan mucha merma para validar la hipótesis de control
UPDATE daily_sales 
SET total_waste_cost = total_revenue * (0.15 + random() * 0.1) 
WHERE sale_date IN (CURRENT_DATE - INTERVAL '3 days', CURRENT_DATE - INTERVAL '7 days');
