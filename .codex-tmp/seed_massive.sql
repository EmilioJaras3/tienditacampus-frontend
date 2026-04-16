-- ============================================================
-- SEED MASIVO - TienditaCampus Production
-- Pobla: inventory_records, audit_logs, daily_inventory_snapshots
-- ============================================================

-- Admin user ID para referencia
-- 260439aa-3139-4c78-9850-e5e21490cbeb = jarassanchezl@gmail.com (admin)

-- Sellers existentes:
-- b55a3a64 = anagarpep14 (seller)
-- 70cc8c20 = diegoramiraasa2 (seller)  
-- 1167a03f = elenaaaszgomezr (seller)
-- 2a75a981 = carlospereeezagui23 (seller)
-- 0b509ac3 = sofialaaaaaar2535 (seller)

-- Buyers existentes:
-- 3173083d = juandiaz291 (buyer)
-- 21d546d5 = pedrovarguitaslas (buyer)
-- c9466a52 = mariamora12 (buyer)
-- 5f660a50 = luisarmr2castro (buyer)
-- e39f9c3d = laurortiiiiz (buyer)

-- ============================================================
-- 1. INVENTORY RECORDS (stock para los 20 productos)
-- ============================================================

-- Seller: anagarpep14 (b55a3a64)
INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, unit_cost, status, expires_at) VALUES
(gen_random_uuid(), 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'e66706b7-638d-4264-b53d-91ec84f67728', '2026-04-10', 50, 32, 769.00, 15.38, 'active', '2026-04-17'),
(gen_random_uuid(), 'b55a3a64-d409-454f-848e-8b2dbb7dea01', '1a49f936-586b-4ddd-90d5-a83e5608912e', '2026-04-10', 40, 18, 746.80, 18.67, 'active', '2026-04-18'),
(gen_random_uuid(), 'b55a3a64-d409-454f-848e-8b2dbb7dea01', '62b5ee34-2747-4924-84ea-9226d2274ace', '2026-04-11', 60, 42, 609.60, 10.16, 'active', NULL),
(gen_random_uuid(), 'b55a3a64-d409-454f-848e-8b2dbb7dea01', '7574221b-4b15-4e7f-9e34-80cc14cefb84', '2026-04-11', 100, 75, 561.00, 5.61, 'active', NULL),
-- Lotes cerrados (ya vendidos)
(gen_random_uuid(), 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'e66706b7-638d-4264-b53d-91ec84f67728', '2026-03-25', 30, 0, 461.40, 15.38, 'sold_out', '2026-04-01'),
(gen_random_uuid(), 'b55a3a64-d409-454f-848e-8b2dbb7dea01', '1a49f936-586b-4ddd-90d5-a83e5608912e', '2026-03-20', 25, 3, 466.75, 18.67, 'expired', '2026-03-27');

-- Obtener product IDs del seller 70cc8c20 para inventory
-- Primero veamos qué productos tiene cada seller
-- Insertamos para todos los sellers con sus productos directamente vía subquery

INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, unit_cost, status, expires_at)
SELECT gen_random_uuid(), p.seller_id, p.id, 
       '2026-04-08'::date + (row_number() over (partition by p.seller_id order by p.name)) * interval '1 day',
       CASE WHEN p.is_perishable THEN 30 + floor(random()*20) ELSE 50 + floor(random()*50) END,
       CASE WHEN p.is_perishable THEN 10 + floor(random()*15) ELSE 25 + floor(random()*40) END,
       CASE WHEN p.is_perishable THEN (30 + floor(random()*20)) * p.unit_cost ELSE (50 + floor(random()*50)) * p.unit_cost END,
       p.unit_cost,
       'active',
       CASE WHEN p.is_perishable THEN ('2026-04-08'::date + (row_number() over (partition by p.seller_id order by p.name)) * interval '1 day' + interval '7 days')::date ELSE NULL END
FROM products p
WHERE p.seller_id != 'b55a3a64-d409-454f-848e-8b2dbb7dea01'
AND NOT EXISTS (SELECT 1 FROM inventory_records ir WHERE ir.product_id = p.id AND ir.status = 'active');


-- ============================================================
-- 2. AUDIT LOGS MASIVOS - Toda la actividad del sistema
-- ============================================================

-- === REGISTROS DE USUARIOS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at) VALUES
(gen_random_uuid(), 'user.register', 'user', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Nuevo usuario registrado: anagarpep14@gmail.com', '187.190.52.101', '{"email":"anagarpep14@gmail.com","role":"seller","registeredAt":"2026-03-05T10:15:00Z"}', '2026-03-05 10:15:00'),
(gen_random_uuid(), 'user.register', 'user', '70cc8c20-4ecd-4b23-be5d-413a3f56589e', '70cc8c20-4ecd-4b23-be5d-413a3f56589e', 'info', 'Nuevo usuario registrado: diegoramiraasa2@gmail.com', '187.190.52.102', '{"email":"diegoramiraasa2@gmail.com","role":"seller","registeredAt":"2026-03-06T11:30:00Z"}', '2026-03-06 11:30:00'),
(gen_random_uuid(), 'user.register', 'user', '1167a03f-db17-407a-9350-96c84d1299b9', '1167a03f-db17-407a-9350-96c84d1299b9', 'info', 'Nuevo usuario registrado: elenaaaszgomezr@gmail.com', '200.68.131.45', '{"email":"elenaaaszgomezr@gmail.com","role":"seller","registeredAt":"2026-03-06T14:20:00Z"}', '2026-03-06 14:20:00'),
(gen_random_uuid(), 'user.register', 'user', '2a75a981-7955-4f44-8c17-a8d38943ac11', '2a75a981-7955-4f44-8c17-a8d38943ac11', 'info', 'Nuevo usuario registrado: carlospereeezagui23@gmail.com', '189.203.11.78', '{"email":"carlospereeezagui23@gmail.com","role":"seller","registeredAt":"2026-03-07T09:00:00Z"}', '2026-03-07 09:00:00'),
(gen_random_uuid(), 'user.register', 'user', '0b509ac3-8a29-442b-9e33-cd466ebb6126', '0b509ac3-8a29-442b-9e33-cd466ebb6126', 'info', 'Nuevo usuario registrado: sofialaaaaaar2535@gmail.com', '187.190.52.105', '{"email":"sofialaaaaaar2535@gmail.com","role":"seller","registeredAt":"2026-03-07T16:45:00Z"}', '2026-03-07 16:45:00'),
(gen_random_uuid(), 'user.register', 'user', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', 'info', 'Nuevo usuario registrado: juandiaz291@gmail.com', '200.68.131.50', '{"email":"juandiaz291@gmail.com","role":"buyer","registeredAt":"2026-03-08T08:30:00Z"}', '2026-03-08 08:30:00'),
(gen_random_uuid(), 'user.register', 'user', '21d546d5-a204-47d5-93ee-0b038dc26535', '21d546d5-a204-47d5-93ee-0b038dc26535', 'info', 'Nuevo usuario registrado: pedrovarguitaslas@gmail.com', '189.203.11.80', '{"email":"pedrovarguitaslas@gmail.com","role":"buyer","registeredAt":"2026-03-08T10:00:00Z"}', '2026-03-08 10:00:00'),
(gen_random_uuid(), 'user.register', 'user', 'c9466a52-5bc1-4f3a-8bb1-6d83e68ad493', 'c9466a52-5bc1-4f3a-8bb1-6d83e68ad493', 'info', 'Nuevo usuario registrado: mariamora12@gmail.com', '187.190.52.110', '{"email":"mariamora12@gmail.com","role":"buyer","registeredAt":"2026-03-09T12:15:00Z"}', '2026-03-09 12:15:00');

-- === LOGINS EXITOSOS (2FA) ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at) VALUES
(gen_random_uuid(), 'user.login_2fa', 'user', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Login 2FA exitoso: anagarpep14@gmail.com', '187.190.52.101', '{"email":"anagarpep14@gmail.com","role":"seller","loginCount":1}', '2026-03-09 08:00:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Login 2FA exitoso: anagarpep14@gmail.com', '187.190.52.101', '{"email":"anagarpep14@gmail.com","role":"seller","loginCount":2}', '2026-03-10 09:15:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '70cc8c20-4ecd-4b23-be5d-413a3f56589e', '70cc8c20-4ecd-4b23-be5d-413a3f56589e', 'info', 'Login 2FA exitoso: diegoramiraasa2@gmail.com', '187.190.52.102', '{"email":"diegoramiraasa2@gmail.com","role":"seller","loginCount":1}', '2026-03-10 10:00:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '1167a03f-db17-407a-9350-96c84d1299b9', '1167a03f-db17-407a-9350-96c84d1299b9', 'info', 'Login 2FA exitoso: elenaaaszgomezr@gmail.com', '200.68.131.45', '{"email":"elenaaaszgomezr@gmail.com","role":"seller","loginCount":1}', '2026-03-11 11:30:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '2a75a981-7955-4f44-8c17-a8d38943ac11', '2a75a981-7955-4f44-8c17-a8d38943ac11', 'info', 'Login 2FA exitoso: carlospereeezagui23@gmail.com', '189.203.11.78', '{"email":"carlospereeezagui23@gmail.com","role":"seller","loginCount":1}', '2026-03-12 08:45:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', 'info', 'Login 2FA exitoso: juandiaz291@gmail.com', '200.68.131.50', '{"email":"juandiaz291@gmail.com","role":"buyer","loginCount":1}', '2026-03-12 10:30:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '21d546d5-a204-47d5-93ee-0b038dc26535', '21d546d5-a204-47d5-93ee-0b038dc26535', 'info', 'Login 2FA exitoso: pedrovarguitaslas@gmail.com', '189.203.11.80', '{"email":"pedrovarguitaslas@gmail.com","role":"buyer","loginCount":1}', '2026-03-13 14:00:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', 'c9466a52-5bc1-4f3a-8bb1-6d83e68ad493', 'c9466a52-5bc1-4f3a-8bb1-6d83e68ad493', 'info', 'Login 2FA exitoso: mariamora12@gmail.com', '187.190.52.110', '{"email":"mariamora12@gmail.com","role":"buyer","loginCount":1}', '2026-03-14 09:20:00'),
-- Más logins recientes
(gen_random_uuid(), 'user.login_2fa', 'user', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Login 2FA exitoso: anagarpep14@gmail.com', '187.190.52.101', '{"email":"anagarpep14@gmail.com","role":"seller","loginCount":15}', '2026-04-14 08:00:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '70cc8c20-4ecd-4b23-be5d-413a3f56589e', '70cc8c20-4ecd-4b23-be5d-413a3f56589e', 'info', 'Login 2FA exitoso: diegoramiraasa2@gmail.com', '187.190.52.102', '{"email":"diegoramiraasa2@gmail.com","role":"seller","loginCount":12}', '2026-04-14 09:30:00'),
(gen_random_uuid(), 'user.login_2fa', 'user', '260439aa-3139-4c78-9850-e5e21490cbeb', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Login 2FA exitoso: jarassanchezl@gmail.com', '187.190.52.200', '{"email":"jarassanchezl@gmail.com","role":"admin","loginCount":8}', '2026-04-15 10:00:00');

-- === INTENTOS DE LOGIN FALLIDOS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at) VALUES
(gen_random_uuid(), 'user.login_failed', 'user', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', 'warn', 'Intento de login fallido para juandiaz291@gmail.com', '200.68.131.50', '{"email":"juandiaz291@gmail.com","failedAttempts":1}', '2026-03-15 20:30:00'),
(gen_random_uuid(), 'user.login_failed', 'user', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', '3173083d-0ddd-4562-b7a7-3a793b70c1a4', 'warn', 'Intento de login fallido para juandiaz291@gmail.com', '200.68.131.50', '{"email":"juandiaz291@gmail.com","failedAttempts":2}', '2026-03-15 20:31:00'),
(gen_random_uuid(), 'user.login_failed', 'user', 'c9466a52-5bc1-4f3a-8bb1-6d83e68ad493', 'c9466a52-5bc1-4f3a-8bb1-6d83e68ad493', 'warn', 'Intento de login fallido para mariamora12@gmail.com', '187.190.52.110', '{"email":"mariamora12@gmail.com","failedAttempts":1}', '2026-04-01 15:45:00');

-- === CREACIÓN DE PRODUCTOS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at)
SELECT gen_random_uuid(), 'product.create', 'product', p.id, p.seller_id, 'info', 
       'Producto creado: ' || p.name || ' ($' || p.sale_price || ')', '187.190.52.101',
       ('{"productName":"' || p.name || '","salePrice":' || p.sale_price || ',"unitCost":' || p.unit_cost || ',"category":"' || COALESCE(c.name,'Sin categoría') || '"}')::jsonb,
       p.created_at
FROM products p LEFT JOIN categories c ON p.category_id = c.id;

-- === EDICIÓN DE PRODUCTOS (simulamos cambios de precio) ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at) VALUES
(gen_random_uuid(), 'product.update', 'product', 'e66706b7-638d-4264-b53d-91ec84f67728', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Producto actualizado: Hamburguesa - Precio ajustado de $28.00 a $32.58', '187.190.52.101', '{"productName":"Hamburguesa","field":"salePrice","oldValue":28.00,"newValue":32.58}', '2026-03-15 10:00:00'),
(gen_random_uuid(), 'product.update', 'product', '1a49f936-586b-4ddd-90d5-a83e5608912e', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Producto actualizado: Chicharrines - Stock recargado', '187.190.52.101', '{"productName":"Chicharrines","field":"stock","addedQuantity":40}', '2026-03-20 11:30:00'),
(gen_random_uuid(), 'product.update', 'product', '62b5ee34-2747-4924-84ea-9226d2274ace', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Producto actualizado: Burritos - Descripción modificada', '187.190.52.101', '{"productName":"Burritos","field":"description","action":"updated"}', '2026-04-05 09:00:00'),
(gen_random_uuid(), 'product.update', 'product', '7574221b-4b15-4e7f-9e34-80cc14cefb84', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Producto actualizado: Chicles - Precio ajustado de $10.00 a $11.88', '187.190.52.101', '{"productName":"Chicles","field":"salePrice","oldValue":10.00,"newValue":11.88}', '2026-04-10 14:20:00');

-- === VENTAS REGISTRADAS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at)
SELECT gen_random_uuid(), 'sale.create', 'daily_sale', ds.id, ds.seller_id, 'info',
       'Venta diaria registrada: ' || ds.sale_date || ' - Inversión $' || ds.total_investment || ' / Ingreso $' || ds.total_revenue,
       '187.190.52.101',
       ('{"saleDate":"' || ds.sale_date || '","totalInvestment":' || ds.total_investment || ',"totalRevenue":' || ds.total_revenue || ',"unitsSold":' || ds.units_sold || ',"unitsLost":' || ds.units_lost || '}')::jsonb,
       ds.created_at
FROM daily_sales ds;

-- === VENTAS CERRADAS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at)
SELECT gen_random_uuid(), 'sale.close', 'daily_sale', ds.id, ds.seller_id, 'info',
       'Venta diaria cerrada: ' || ds.sale_date || ' - Ganancia neta: $' || ds.total_profit,
       '187.190.52.101',
       ('{"saleDate":"' || ds.sale_date || '","totalProfit":' || ds.total_profit || ',"profitMargin":' || ds.profit_margin || '%}')::jsonb,
       ds.created_at + interval '8 hours'
FROM daily_sales ds WHERE ds.is_closed = true;

-- === ÓRDENES/COMPRAS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at)
SELECT gen_random_uuid(), 'order.create', 'order', o.id, o.buyer_id, 'info',
       'Orden de compra creada por $' || o.total_amount || ' - Estado: ' || o.status,
       '187.190.52.' || (100 + (row_number() over ())::int % 50),
       ('{"totalAmount":' || o.total_amount || ',"status":"' || o.status || '","sellerId":"' || o.seller_id || '"}')::jsonb,
       o.created_at
FROM orders o;

-- === ÓRDENES COMPLETADAS ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at)
SELECT gen_random_uuid(), 'order.complete', 'order', o.id, o.seller_id, 'info',
       'Orden completada y entregada - Monto: $' || o.total_amount,
       '187.190.52.101',
       ('{"totalAmount":' || o.total_amount || ',"buyerId":"' || o.buyer_id || '","completedAt":"' || (o.updated_at)::text || '"}')::jsonb,
       o.updated_at
FROM orders o WHERE o.status = 'completed';

-- === MERMA DETECTADA ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at)
SELECT gen_random_uuid(), 'inventory.waste', 'sale_detail', sd.id, ds.seller_id, 'warn',
       'Merma detectada: ' || sd.quantity_lost || ' unidades perdidas (' || COALESCE(sd.waste_reason, 'sin especificar') || ') - Costo: $' || sd.waste_cost,
       '187.190.52.101',
       ('{"quantityLost":' || sd.quantity_lost || ',"wasteReason":"' || COALESCE(sd.waste_reason, 'other') || '","wasteCost":' || sd.waste_cost || ',"productId":"' || sd.product_id || '"}')::jsonb,
       ds.created_at + interval '6 hours'
FROM sale_details sd 
JOIN daily_sales ds ON sd.daily_sale_id = ds.id 
WHERE sd.quantity_lost > 0;

-- === ACTIVIDAD ADMINISTRATIVA ===
INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at) VALUES
(gen_random_uuid(), 'admin.category_create', 'category', 'eb95e35d-c40d-4207-a86c-5b337d92c901', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Categoría creada: Bebidas', '187.190.52.200', '{"categoryName":"Bebidas"}', '2026-03-05 08:00:00'),
(gen_random_uuid(), 'admin.category_create', 'category', '96a6da6d-d8a1-4635-8912-26b047979bb9', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Categoría creada: Comida Preparada', '187.190.52.200', '{"categoryName":"Comida Preparada"}', '2026-03-05 08:01:00'),
(gen_random_uuid(), 'admin.category_create', 'category', 'dd8b529b-3374-4e51-bdf1-82f599d03e73', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Categoría creada: Snacks', '187.190.52.200', '{"categoryName":"Snacks"}', '2026-03-05 08:02:00'),
(gen_random_uuid(), 'admin.category_create', 'category', 'a6ee02e9-d994-4d90-8948-3b5e5c87e233', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Categoría creada: Postres', '187.190.52.200', '{"categoryName":"Postres"}', '2026-03-05 08:03:00'),
-- Reportes generados
(gen_random_uuid(), 'report.generate', 'weekly_report', gen_random_uuid()::text, '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Reporte semanal generado: Semana del 10 al 16 de Marzo 2026', '187.190.52.200', '{"weekStart":"2026-03-10","weekEnd":"2026-03-16","totalSales":15,"totalRevenue":1250.75}', '2026-03-17 09:00:00'),
(gen_random_uuid(), 'report.generate', 'weekly_report', gen_random_uuid()::text, '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Reporte semanal generado: Semana del 17 al 23 de Marzo 2026', '187.190.52.200', '{"weekStart":"2026-03-17","weekEnd":"2026-03-23","totalSales":22,"totalRevenue":2180.30}', '2026-03-24 09:00:00'),
(gen_random_uuid(), 'report.generate', 'weekly_report', gen_random_uuid()::text, '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Reporte semanal generado: Semana del 7 al 13 de Abril 2026', '187.190.52.200', '{"weekStart":"2026-04-07","weekEnd":"2026-04-13","totalSales":35,"totalRevenue":3450.90}', '2026-04-14 09:00:00'),
-- Rescue admin
(gen_random_uuid(), 'user.rescue', 'user', '260439aa-3139-4c78-9850-e5e21490cbeb', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'RESCATE ADMINISTRATIVO ejecutado para: jarassanchezl@gmail.com', '187.190.52.200', '{"email":"jarassanchezl@gmail.com","timestamp":"2026-04-13T03:00:00Z"}', '2026-04-13 03:00:00'),
-- Login Google SSO
(gen_random_uuid(), 'user.login_google', 'user', '260439aa-3139-4c78-9850-e5e21490cbeb', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Login SSO exitoso (Google): jarassanchezl@gmail.com', '187.190.52.200', '{"email":"jarassanchezl@gmail.com","role":"admin","provider":"google"}', '2026-04-10 14:00:00'),
-- Break-even calculations
(gen_random_uuid(), 'breakeven.calculate', 'product', 'e66706b7-638d-4264-b53d-91ec84f67728', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Cálculo de punto de equilibrio: Hamburguesa - 15.38 costo / 32.58 venta = 9 unidades mínimas', '187.190.52.101', '{"productName":"Hamburguesa","unitCost":15.38,"salePrice":32.58,"breakEvenUnits":9}', '2026-04-12 11:00:00'),
(gen_random_uuid(), 'breakeven.calculate', 'product', '1a49f936-586b-4ddd-90d5-a83e5608912e', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Cálculo de punto de equilibrio: Chicharrines - 18.67 costo / 39.55 venta = 12 unidades mínimas', '187.190.52.101', '{"productName":"Chicharrines","unitCost":18.67,"salePrice":39.55,"breakEvenUnits":12}', '2026-04-12 11:05:00'),
-- Forecast requests
(gen_random_uuid(), 'forecast.request', 'product', 'e66706b7-638d-4264-b53d-91ec84f67728', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Pronóstico de demanda solicitado: Hamburguesa para Lunes', '187.190.52.101', '{"productName":"Hamburguesa","dayOfWeek":"Monday","predictedDemand":25}', '2026-04-13 10:00:00'),
(gen_random_uuid(), 'forecast.request', 'product', '62b5ee34-2747-4924-84ea-9226d2274ace', 'b55a3a64-d409-454f-848e-8b2dbb7dea01', 'info', 'Pronóstico de demanda solicitado: Burritos para Miércoles', '187.190.52.101', '{"productName":"Burritos","dayOfWeek":"Wednesday","predictedDemand":18}', '2026-04-13 10:05:00'),
-- Expiration alerts
(gen_random_uuid(), 'expiration.alert', 'inventory', gen_random_uuid()::text, '260439aa-3139-4c78-9850-e5e21490cbeb', 'warn', 'Alerta de caducidad: 3 productos próximos a vencer en las próximas 48 horas', '187.190.52.200', '{"productsExpiring":3,"urgencyLevel":"high"}', '2026-04-14 06:00:00'),
(gen_random_uuid(), 'expiration.alert', 'inventory', gen_random_uuid()::text, '260439aa-3139-4c78-9850-e5e21490cbeb', 'warn', 'Alerta de caducidad: 1 lote de Chicharrines expirado - Merma registrada automáticamente', '187.190.52.200', '{"productName":"Chicharrines","quantityExpired":3,"wasteCost":56.01}', '2026-03-28 00:00:00');

-- ============================================================
-- 3. Verificación final
-- ============================================================
SELECT 'inventory_records' as tabla, COUNT(*) as total FROM inventory_records
UNION ALL SELECT 'audit_logs', COUNT(*) FROM audit_logs
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'daily_sales', COUNT(*) FROM daily_sales
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'users', COUNT(*) FROM users;
