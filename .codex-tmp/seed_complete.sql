-- ============================================================
-- SEED COMPLETO TIENDITACAMPUS - DATOS REALISTAS
-- 13 usuarios, 6 productos, cronología coherente
-- Periodo muerto: 25 mar - 10 abr | Horario: 08:00-16:00
-- ============================================================
BEGIN;

-- ============================================================
-- PASO 0: LIMPIAR TODO excepto admin
-- ============================================================
DELETE FROM audit_logs;
DELETE FROM sale_details;
DELETE FROM daily_sales;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM inventory_records;
DELETE FROM two_factor_codes;
DELETE FROM products;
DELETE FROM categories WHERE true;
DELETE FROM users WHERE email != 'jarassanchezl@gmail.com';

-- ============================================================
-- PASO 1: USUARIOS (12 nuevos + admin existente = 13)
-- Contraseña de todos: Campus2026!
-- ============================================================
-- Hash: $argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo

-- SELLERS (6) - IDs fijos para referencia
INSERT INTO users (id, email, password_hash, first_name, last_name, phone, role, is_active, is_email_verified, failed_login_attempts, login_count, major, campus_location, created_at, updated_at) VALUES
('aa000001-0000-0000-0000-000000000001', 'antdehoyos@gmail.com',   '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Antonio', 'De Hoyos', '6141234501', 'seller', true, true, 0, 12, 'Ing. Industrial', 'Campus Norte', '2026-03-01 08:30:00-06', '2026-04-15 10:00:00-06'),
('aa000001-0000-0000-0000-000000000002', 'marilopz.tc@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Mariana', 'López',    '6141234502', 'seller', true, true, 0, 10, 'Administración',  'Campus Norte', '2026-03-04 09:00:00-06', '2026-04-14 11:00:00-06'),
('aa000001-0000-0000-0000-000000000003', 'carlruiz98@gmail.com',   '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Carlos',  'Ruiz',     '6141234503', 'seller', true, true, 0, 8,  'Mercadotecnia',   'Campus Sur',   '2026-03-06 10:00:00-06', '2026-04-13 09:30:00-06'),
('aa000001-0000-0000-0000-000000000004', 'sofvega.uni@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Sofía',   'Vega',     '6141234504', 'seller', true, true, 0, 6,  'Gastronomía',     'Campus Norte', '2026-02-25 09:00:00-06', '2026-03-22 16:00:00-06'),
('aa000001-0000-0000-0000-000000000005', 'diegomora.v@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Diego',   'Mora',     '6141234505', 'seller', true, true, 0, 4,  'Contaduría',      'Campus Sur',   '2026-02-20 10:00:00-06', '2026-03-15 14:00:00-06'),
('aa000001-0000-0000-0000-000000000006', 'elrios.campus@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Elena',   'Ríos',     '6141234506', 'seller', true, true, 0, 2,  'Nutrición',       'Campus Norte', '2026-02-15 08:30:00-06', '2026-03-05 15:00:00-06');

-- BUYERS (6)
INSERT INTO users (id, email, password_hash, first_name, last_name, phone, role, is_active, is_email_verified, failed_login_attempts, login_count, major, campus_location, created_at, updated_at) VALUES
('bb000001-0000-0000-0000-000000000001', 'pedsanch.22@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Pedro',   'Sánchez',  '6149876501', 'buyer', true, true, 0, 9,  'Ing. Software',   'Campus Norte', '2026-03-08 08:30:00-06', '2026-04-14 12:00:00-06'),
('bb000001-0000-0000-0000-000000000002', 'laurgrcia@gmail.com',    '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Laura',   'García',   '6149876502', 'buyer', true, true, 0, 7,  'Psicología',      'Campus Sur',   '2026-03-10 09:00:00-06', '2026-04-13 10:00:00-06'),
('bb000001-0000-0000-0000-000000000003', 'juanmndz.tc@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Juan',    'Méndez',   '6149876503', 'buyer', true, true, 0, 5,  'Derecho',         'Campus Norte', '2026-03-07 10:00:00-06', '2026-03-20 13:00:00-06'),
('bb000001-0000-0000-0000-000000000004', 'anatorres.u@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Ana',     'Torres',   '6149876504', 'buyer', true, true, 0, 3,  'Comunicación',    'Campus Sur',   '2026-03-02 09:00:00-06', '2026-03-12 15:00:00-06'),
('bb000001-0000-0000-0000-000000000005', 'robdiaz.uni@gmail.com',  '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Roberto', 'Díaz',     '6149876505', 'buyer', true, true, 0, 2,  'Arquitectura',    'Campus Norte', '2026-02-22 11:30:00-06', '2026-03-03 10:30:00-06'),
('bb000001-0000-0000-0000-000000000006', 'camilahrr@gmail.com',    '$argon2id$v=19$m=19456,t=2,p=1$vr3+6ePGYbIRavHExWAwBQ$YIoKPDNZic4WVwtLd56t405mfhkTtJ5SEE1/v41Pobo', 'Camila',  'Herrera',  '6149876506', 'buyer', true, true, 0, 1,  'Diseño Gráfico',  'Campus Sur',   '2026-02-17 09:15:00-06', '2026-02-27 14:00:00-06');

-- ============================================================
-- PASO 2: CATEGORÍAS (3 limpias)
-- ============================================================
INSERT INTO categories (id, name, description, icon, is_active) VALUES
('cc000001-0000-0000-0000-000000000001', 'Comida Preparada', 'Alimentos hechos en casa listos para comer', 'utensils', true),
('cc000001-0000-0000-0000-000000000002', 'Bebidas',          'Agua, refrescos y bebidas frías',            'cup',      true),
('cc000001-0000-0000-0000-000000000003', 'Snacks',           'Botanas, dulces y postres',                  'cookie',   true);

-- ============================================================
-- PASO 3: PRODUCTOS (6 total)
-- ============================================================
INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_perishable, shelf_life_days, image_url, is_active, created_at, updated_at) VALUES
('a0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'cc000001-0000-0000-0000-000000000001', 'Burritos de Machaca', 'Burritos caseros de machaca con frijoles, hechos cada mañana', 18.00, 35.00, true, 2, 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&q=80', true, '2026-03-03 09:00:00-06', '2026-04-14 08:30:00-06'),
('a0000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 'cc000001-0000-0000-0000-000000000002', 'Agua y Refrescos',    'Botellas de agua 600ml y refrescos fríos variados',           8.00,  15.00, false, NULL, 'https://images.unsplash.com/photo-1527960471264-932f39eb5846?w=400&q=80', true, '2026-03-05 10:30:00-06', '2026-04-11 10:00:00-06'),
('a0000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000003', 'cc000001-0000-0000-0000-000000000003', 'Bolsas de Papas',     'Papas Sabritas, Takis y Doritos tamaño individual',           12.00, 20.00, false, NULL, 'https://images.unsplash.com/photo-1600952841320-db92ec4047ca?w=400&q=80', true, '2026-03-07 11:00:00-06', '2026-04-12 09:00:00-06'),
('a0000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000004', 'cc000001-0000-0000-0000-000000000003', 'Brownies Caseros',    'Brownies de chocolate con nuez, horneados en casa',           10.00, 25.00, true, 3, 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&q=80', true, '2026-02-27 09:30:00-06', '2026-03-20 11:00:00-06'),
('a0000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 'cc000001-0000-0000-0000-000000000001', 'Sándwich de Jamón',   'Sándwich de jamón y queso en pan blanco con mayonesa',        15.00, 28.00, true, 1, 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&q=80', true, '2026-02-22 10:00:00-06', '2026-03-14 09:30:00-06'),
('a0000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000006', 'cc000001-0000-0000-0000-000000000001', 'Fruta con Chile',     'Vaso de fruta fresca (mango, sandía, jícama) con chile y limón', 12.00, 22.00, true, 1, 'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=400&q=80', true, '2026-02-26 11:00:00-06', '2026-03-04 14:00:00-06');

-- ============================================================
-- PASO 4: INVENTARIO
-- ============================================================
INSERT INTO inventory_records (id, seller_id, product_id, record_date, quantity_initial, quantity_remaining, investment_amount, status, expires_at, created_at, updated_at) VALUES
-- Antonio - Burritos (activo, múltiples lotes)
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', '2026-03-10', 15, 0,  270.00, 'sold_out', '2026-03-12', '2026-03-10 08:00:00-06', '2026-03-11 15:00:00-06'),
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', '2026-03-17', 20, 0,  360.00, 'sold_out', '2026-03-19', '2026-03-17 08:00:00-06', '2026-03-19 14:00:00-06'),
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', '2026-04-14', 12, 5,  216.00, 'active',   '2026-04-16', '2026-04-14 08:00:00-06', '2026-04-15 12:00:00-06'),
-- Mariana - Refrescos (activo)
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000002', '2026-03-10', 30, 0,  240.00, 'sold_out', NULL, '2026-03-10 09:00:00-06', '2026-03-22 15:00:00-06'),
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000002', '2026-04-11', 24, 10, 192.00, 'active',   NULL, '2026-04-11 09:00:00-06', '2026-04-15 11:00:00-06'),
-- Carlos - Papas (activo)
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000003', '2026-03-10', 40, 0,  480.00, 'sold_out', NULL, '2026-03-10 10:00:00-06', '2026-03-24 14:00:00-06'),
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000003', '2026-04-12', 25, 15, 300.00, 'active',   NULL, '2026-04-12 09:00:00-06', '2026-04-15 10:00:00-06'),
-- Sofía - Brownies (inactiva - último lote expiró)
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000004', '2026-03-05', 10, 0,  100.00, 'sold_out', '2026-03-08', '2026-03-05 08:00:00-06', '2026-03-07 14:00:00-06'),
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000004', '2026-03-18', 8,  3,  80.00,  'expired',  '2026-03-21', '2026-03-18 09:00:00-06', '2026-03-22 16:00:00-06'),
-- Diego - Sándwiches (inactivo)
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000005', 'a0000001-0000-0000-0000-000000000005', '2026-03-01', 10, 0,  150.00, 'sold_out', '2026-03-02', '2026-03-01 08:00:00-06', '2026-03-02 14:00:00-06'),
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000005', 'a0000001-0000-0000-0000-000000000005', '2026-03-10', 8,  2,  120.00, 'expired',  '2026-03-11', '2026-03-10 08:00:00-06', '2026-03-15 14:00:00-06'),
-- Elena - Fruta (inactiva - único lote)
(gen_random_uuid(), 'aa000001-0000-0000-0000-000000000006', 'a0000001-0000-0000-0000-000000000006', '2026-02-28', 8,  1,  96.00,  'expired',  '2026-03-01', '2026-02-28 08:00:00-06', '2026-03-05 15:00:00-06');

-- ============================================================
-- PASO 5: VENTAS DIARIAS (pocas, máx 2/día, no todos los días)
-- ============================================================

-- IDs fijos para poder referenciar en sale_details
-- Pre-periodo muerto: Mar 10 - Mar 24
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, profit_margin, units_sold, units_lost, total_waste_cost, is_closed, notes, created_at, updated_at) VALUES
-- Antonio - Burritos
('b0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', '2026-03-10', 90.00,  140.00, 55.56, 4, 1, 18.00, true,  'Primer día de ventas',        '2026-03-10 08:30:00-06', '2026-03-10 15:00:00-06'),
('b0000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', '2026-03-12', 126.00, 210.00, 66.67, 6, 1, 18.00, true,  'Buen día, se vendió casi todo','2026-03-12 09:00:00-06', '2026-03-12 15:30:00-06'),
('b0000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000001', '2026-03-17', 144.00, 245.00, 70.14, 7, 1, 18.00, true,  NULL,                          '2026-03-17 08:00:00-06', '2026-03-17 14:00:00-06'),
('b0000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000001', '2026-03-19', 180.00, 280.00, 55.56, 8, 2, 36.00, true,  'Sobraron 2, se echaron a perder','2026-03-19 08:30:00-06', '2026-03-19 16:00:00-06'),
-- Mariana - Refrescos
('b0000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000002', '2026-03-11', 64.00,  105.00, 64.06, 7, 1, 8.00,  true,  NULL,                          '2026-03-11 09:30:00-06', '2026-03-11 14:00:00-06'),
('b0000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000002', '2026-03-14', 80.00,  135.00, 68.75, 9, 1, 8.00,  true,  NULL,                          '2026-03-14 10:00:00-06', '2026-03-14 15:00:00-06'),
('b0000001-0000-0000-0000-000000000007', 'aa000001-0000-0000-0000-000000000002', '2026-03-20', 48.00,  75.00,  56.25, 5, 1, 8.00,  true,  'Día flojo',                   '2026-03-20 09:00:00-06', '2026-03-20 15:30:00-06'),
-- Carlos - Papas
('b0000001-0000-0000-0000-000000000008', 'aa000001-0000-0000-0000-000000000003', '2026-03-10', 120.00, 180.00, 50.00, 9, 1, 12.00, true,  NULL,                          '2026-03-10 10:30:00-06', '2026-03-10 15:00:00-06'),
('b0000001-0000-0000-0000-000000000009', 'aa000001-0000-0000-0000-000000000003', '2026-03-13', 96.00,  160.00, 66.67, 8, 0, 0.00,  true,  'Sin merma hoy',               '2026-03-13 09:00:00-06', '2026-03-13 16:00:00-06'),
('b0000001-0000-0000-0000-000000000010', 'aa000001-0000-0000-0000-000000000003', '2026-03-21', 60.00,  100.00, 66.67, 5, 0, 0.00,  true,  NULL,                          '2026-03-21 10:00:00-06', '2026-03-21 14:30:00-06'),
-- Sofía - Brownies
('b0000001-0000-0000-0000-000000000011', 'aa000001-0000-0000-0000-000000000004', '2026-03-06', 50.00,  100.00, 100.0, 4, 1, 10.00, true,  'Primer día, se vendieron bien','2026-03-06 09:00:00-06', '2026-03-06 13:00:00-06'),
('b0000001-0000-0000-0000-000000000012', 'aa000001-0000-0000-0000-000000000004', '2026-03-19', 40.00,  75.00,  87.50, 3, 2, 20.00, true,  'Sobraron brownies',           '2026-03-19 08:30:00-06', '2026-03-19 15:00:00-06'),
-- Diego - Sándwiches
('b0000001-0000-0000-0000-000000000013', 'aa000001-0000-0000-0000-000000000005', '2026-03-03', 75.00,  112.00, 49.33, 4, 1, 15.00, true,  NULL,                          '2026-03-03 08:00:00-06', '2026-03-03 14:00:00-06'),
('b0000001-0000-0000-0000-000000000014', 'aa000001-0000-0000-0000-000000000005', '2026-03-12', 60.00,  84.00,  40.00, 3, 1, 15.00, true,  NULL,                          '2026-03-12 08:30:00-06', '2026-03-12 14:00:00-06'),
-- Elena - Fruta
('b0000001-0000-0000-0000-000000000015', 'aa000001-0000-0000-0000-000000000006', '2026-03-03', 48.00,  66.00,  37.50, 3, 1, 12.00, true,  'Primer y único día de fruta', '2026-03-03 10:00:00-06', '2026-03-03 14:30:00-06');

-- Post-periodo muerto: Apr 11 - Apr 15 (solo activos: Antonio, Mariana, Carlos)
INSERT INTO daily_sales (id, seller_id, sale_date, total_investment, total_revenue, profit_margin, units_sold, units_lost, total_waste_cost, is_closed, notes, created_at, updated_at) VALUES
('b0000001-0000-0000-0000-000000000016', 'aa000001-0000-0000-0000-000000000001', '2026-04-14', 108.00, 175.00, 62.04, 5, 1, 18.00, true,  'Regresamos después de vacaciones', '2026-04-14 08:30:00-06', '2026-04-14 15:00:00-06'),
('b0000001-0000-0000-0000-000000000017', 'aa000001-0000-0000-0000-000000000002', '2026-04-14', 56.00,  90.00,  60.71, 6, 1, 8.00,  true,  NULL,                              '2026-04-14 09:00:00-06', '2026-04-14 14:30:00-06'),
('b0000001-0000-0000-0000-000000000018', 'aa000001-0000-0000-0000-000000000003', '2026-04-14', 48.00,  80.00,  66.67, 4, 0, 0.00,  true,  'Sin merma',                       '2026-04-14 10:00:00-06', '2026-04-14 15:00:00-06'),
('b0000001-0000-0000-0000-000000000019', 'aa000001-0000-0000-0000-000000000001', '2026-04-15', 90.00,  140.00, 55.56, 4, 0, 0.00,  false, 'Venta del día en curso',          '2026-04-15 08:00:00-06', '2026-04-15 12:00:00-06');

-- ============================================================
-- PASO 6: DETALLES DE VENTA
-- (no insertar en subtotal - es columna generada)
-- ============================================================
INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, waste_reason, unit_cost, unit_price, created_at) VALUES
-- Venta 1: Antonio Mar 10
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', 5, 4, 1, 'expired', 18.00, 35.00, '2026-03-10 08:30:00-06'),
-- Venta 2: Antonio Mar 12
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000001', 7, 6, 1, 'damaged', 18.00, 35.00, '2026-03-12 09:00:00-06'),
-- Venta 3: Antonio Mar 17
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000001', 8, 7, 1, 'expired', 18.00, 35.00, '2026-03-17 08:00:00-06'),
-- Venta 4: Antonio Mar 19
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000001', 10, 8, 2, 'expired', 18.00, 35.00, '2026-03-19 08:30:00-06'),
-- Venta 5: Mariana Mar 11
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000005', 'a0000001-0000-0000-0000-000000000002', 8, 7, 1, 'damaged', 8.00, 15.00, '2026-03-11 09:30:00-06'),
-- Venta 6: Mariana Mar 14
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000006', 'a0000001-0000-0000-0000-000000000002', 10, 9, 1, 'other', 8.00, 15.00, '2026-03-14 10:00:00-06'),
-- Venta 7: Mariana Mar 20
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000007', 'a0000001-0000-0000-0000-000000000002', 6, 5, 1, 'damaged', 8.00, 15.00, '2026-03-20 09:00:00-06'),
-- Venta 8: Carlos Mar 10
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000008', 'a0000001-0000-0000-0000-000000000003', 10, 9, 1, 'damaged', 12.00, 20.00, '2026-03-10 10:30:00-06'),
-- Venta 9: Carlos Mar 13
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000009', 'a0000001-0000-0000-0000-000000000003', 8, 8, 0, NULL, 12.00, 20.00, '2026-03-13 09:00:00-06'),
-- Venta 10: Carlos Mar 21
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000010', 'a0000001-0000-0000-0000-000000000003', 5, 5, 0, NULL, 12.00, 20.00, '2026-03-21 10:00:00-06'),
-- Venta 11: Sofía Mar 6
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000011', 'a0000001-0000-0000-0000-000000000004', 5, 4, 1, 'expired', 10.00, 25.00, '2026-03-06 09:00:00-06'),
-- Venta 12: Sofía Mar 19
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000012', 'a0000001-0000-0000-0000-000000000004', 5, 3, 2, 'expired', 10.00, 25.00, '2026-03-19 08:30:00-06'),
-- Venta 13: Diego Mar 3
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000013', 'a0000001-0000-0000-0000-000000000005', 5, 4, 1, 'expired', 15.00, 28.00, '2026-03-03 08:00:00-06'),
-- Venta 14: Diego Mar 12
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000014', 'a0000001-0000-0000-0000-000000000005', 4, 3, 1, 'damaged', 15.00, 28.00, '2026-03-12 08:30:00-06'),
-- Venta 15: Elena Mar 3
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000015', 'a0000001-0000-0000-0000-000000000006', 4, 3, 1, 'expired', 12.00, 22.00, '2026-03-03 10:00:00-06'),
-- Post-vacaciones: Venta 16: Antonio Apr 14
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000016', 'a0000001-0000-0000-0000-000000000001', 6, 5, 1, 'expired', 18.00, 35.00, '2026-04-14 08:30:00-06'),
-- Venta 17: Mariana Apr 14
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000017', 'a0000001-0000-0000-0000-000000000002', 7, 6, 1, 'other', 8.00, 15.00, '2026-04-14 09:00:00-06'),
-- Venta 18: Carlos Apr 14
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000018', 'a0000001-0000-0000-0000-000000000003', 4, 4, 0, NULL, 12.00, 20.00, '2026-04-14 10:00:00-06'),
-- Venta 19: Antonio Apr 15 (en curso)
(gen_random_uuid(), 'b0000001-0000-0000-0000-000000000019', 'a0000001-0000-0000-0000-000000000001', 5, 4, 0, NULL, 18.00, 35.00, '2026-04-15 08:00:00-06');

-- ============================================================
-- PASO 7: ÓRDENES DE COMPRA (15 total)
-- (no insertar en subtotal de order_items - es columna generada)
-- ============================================================
INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, delivery_message, created_at, updated_at) VALUES
-- Pre-periodo muerto
('c0000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 70.00,  'completed', 'En el edificio A planta baja', '2026-03-10 10:00:00-06', '2026-03-10 12:00:00-06'),
('c0000001-0000-0000-0000-000000000002', 'bb000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000001', 35.00,  'completed', NULL,                          '2026-03-11 09:30:00-06', '2026-03-11 10:30:00-06'),
('c0000001-0000-0000-0000-000000000003', 'bb000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 45.00,  'completed', 'Biblioteca segundo piso',     '2026-03-12 11:00:00-06', '2026-03-12 12:00:00-06'),
('c0000001-0000-0000-0000-000000000004', 'bb000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000003', 40.00,  'completed', NULL,                          '2026-03-12 10:30:00-06', '2026-03-12 11:30:00-06'),
('c0000001-0000-0000-0000-000000000005', 'bb000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 56.00,  'completed', 'Estacionamiento',             '2026-03-03 09:00:00-06', '2026-03-03 10:00:00-06'),
('c0000001-0000-0000-0000-000000000006', 'bb000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000004', 50.00,  'completed', NULL,                          '2026-03-06 10:00:00-06', '2026-03-06 11:00:00-06'),
('c0000001-0000-0000-0000-000000000007', 'bb000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000003', 60.00,  'completed', 'Cafetería central',           '2026-03-14 09:30:00-06', '2026-03-14 10:30:00-06'),
('c0000001-0000-0000-0000-000000000008', 'bb000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000002', 30.00,  'completed', NULL,                          '2026-03-17 08:30:00-06', '2026-03-17 09:30:00-06'),
('c0000001-0000-0000-0000-000000000009', 'bb000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 105.00, 'completed', 'Edificio B tercer piso',       '2026-03-19 10:00:00-06', '2026-03-19 11:00:00-06'),
('c0000001-0000-0000-0000-000000000010', 'bb000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', 70.00,  'completed', NULL,                          '2026-03-20 08:30:00-06', '2026-03-20 09:30:00-06'),
('c0000001-0000-0000-0000-000000000011', 'bb000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000004', 25.00,  'cancelled', 'Ya no pude pasar',            '2026-03-20 11:00:00-06', '2026-03-20 13:00:00-06'),
-- Post-periodo muerto
('c0000001-0000-0000-0000-000000000012', 'bb000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 70.00,  'completed', 'Mismo lugar de siempre',      '2026-04-14 09:00:00-06', '2026-04-14 10:00:00-06'),
('c0000001-0000-0000-0000-000000000013', 'bb000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 30.00,  'completed', NULL,                          '2026-04-14 10:30:00-06', '2026-04-14 11:30:00-06'),
('c0000001-0000-0000-0000-000000000014', 'bb000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000003', 40.00,  'completed', 'Para clase de 12',            '2026-04-15 08:30:00-06', '2026-04-15 09:30:00-06'),
('c0000001-0000-0000-0000-000000000015', 'bb000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', 35.00,  'requested', 'Paso por ellos a la 1',       '2026-04-15 11:00:00-06', '2026-04-15 11:00:00-06');

-- Order items
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at) VALUES
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000001', 'a0000001-0000-0000-0000-000000000001', 2, 35.00, 70.00, '2026-03-10 10:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000002', 'a0000001-0000-0000-0000-000000000001', 1, 35.00, 35.00, '2026-03-11 09:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000003', 'a0000001-0000-0000-0000-000000000002', 3, 15.00, 45.00, '2026-03-12 11:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000004', 'a0000001-0000-0000-0000-000000000003', 2, 20.00, 40.00, '2026-03-12 10:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000005', 'a0000001-0000-0000-0000-000000000005', 2, 28.00, 56.00, '2026-03-03 09:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000006', 'a0000001-0000-0000-0000-000000000004', 2, 25.00, 50.00, '2026-03-06 10:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000007', 'a0000001-0000-0000-0000-000000000003', 3, 20.00, 60.00, '2026-03-14 09:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000008', 'a0000001-0000-0000-0000-000000000002', 2, 15.00, 30.00, '2026-03-17 08:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000009', 'a0000001-0000-0000-0000-000000000001', 3, 35.00, 105.00, '2026-03-19 10:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000010', 'a0000001-0000-0000-0000-000000000001', 2, 35.00, 70.00, '2026-03-20 08:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000011', 'a0000001-0000-0000-0000-000000000004', 1, 25.00, 25.00, '2026-03-20 11:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000012', 'a0000001-0000-0000-0000-000000000001', 2, 35.00, 70.00, '2026-04-14 09:00:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000013', 'a0000001-0000-0000-0000-000000000002', 2, 15.00, 30.00, '2026-04-14 10:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000014', 'a0000001-0000-0000-0000-000000000003', 2, 20.00, 40.00, '2026-04-15 08:30:00-06'),
(gen_random_uuid(), 'c0000001-0000-0000-0000-000000000015', 'a0000001-0000-0000-0000-000000000001', 1, 35.00, 35.00, '2026-04-15 11:00:00-06');

-- ============================================================
-- PASO 8: AUDITORÍA COMPLETA (TODAS las acciones del sistema)
-- Flujo: registro → login → crear producto → inventario → venta → compra
-- Horario: 08:00-16:00 | Periodo muerto: Mar 25 - Apr 10
-- ============================================================

INSERT INTO audit_logs (id, action, entity_type, entity_id, user_id, level, description, ip_address, metadata, created_at) VALUES

-- ═══ FEBRERO: Primeros registros ═══
(gen_random_uuid(), 'user.register',   'user', 'aa000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000006', 'info', 'Nuevo usuario registrado: elrios.campus@gmail.com',  '187.190.52.10', '{"email":"elrios.campus@gmail.com","role":"seller"}',  '2026-02-15 08:30:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'bb000001-0000-0000-0000-000000000006', 'bb000001-0000-0000-0000-000000000006', 'info', 'Nuevo usuario registrado: camilahrr@gmail.com',      '189.203.11.10', '{"email":"camilahrr@gmail.com","role":"buyer"}',       '2026-02-17 09:15:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'aa000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 'info', 'Nuevo usuario registrado: diegomora.v@gmail.com',    '200.68.131.10', '{"email":"diegomora.v@gmail.com","role":"seller"}',    '2026-02-20 10:00:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'bb000001-0000-0000-0000-000000000005', 'bb000001-0000-0000-0000-000000000005', 'info', 'Nuevo usuario registrado: robdiaz.uni@gmail.com',    '187.190.52.11', '{"email":"robdiaz.uni@gmail.com","role":"buyer"}',     '2026-02-22 11:30:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'aa000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000004', 'info', 'Nuevo usuario registrado: sofvega.uni@gmail.com',    '189.203.11.11', '{"email":"sofvega.uni@gmail.com","role":"seller"}',    '2026-02-25 09:00:00-06'),

-- Primeros logins de feb
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000006', 'info', 'Login 2FA exitoso: elrios.campus@gmail.com',          '187.190.52.10', '{"email":"elrios.campus@gmail.com","loginCount":1}',   '2026-02-15 08:35:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000006', 'bb000001-0000-0000-0000-000000000006', 'info', 'Login 2FA exitoso: camilahrr@gmail.com',              '189.203.11.10', '{"email":"camilahrr@gmail.com","loginCount":1}',       '2026-02-17 09:20:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 'info', 'Login 2FA exitoso: diegomora.v@gmail.com',            '200.68.131.10', '{"email":"diegomora.v@gmail.com","loginCount":1}',     '2026-02-20 10:05:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000005', 'bb000001-0000-0000-0000-000000000005', 'info', 'Login 2FA exitoso: robdiaz.uni@gmail.com',            '187.190.52.11', '{"email":"robdiaz.uni@gmail.com","loginCount":1}',     '2026-02-22 11:35:00-06'),

-- Diego crea su producto (sándwiches)
(gen_random_uuid(), 'product.create',  'product', 'a0000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 'info', 'Producto creado: Sándwich de Jamón ($28.00)',      '200.68.131.10', '{"productName":"Sándwich de Jamón","salePrice":28.00,"unitCost":15.00}', '2026-02-22 10:00:00-06'),
-- Sofía crea brownies
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000004', 'info', 'Login 2FA exitoso: sofvega.uni@gmail.com',            '189.203.11.11', '{"email":"sofvega.uni@gmail.com","loginCount":1}',     '2026-02-25 09:05:00-06'),
(gen_random_uuid(), 'product.create',  'product', 'a0000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000006', 'info', 'Producto creado: Fruta con Chile ($22.00)',         '187.190.52.10', '{"productName":"Fruta con Chile","salePrice":22.00,"unitCost":12.00}', '2026-02-26 11:00:00-06'),
(gen_random_uuid(), 'product.create',  'product', 'a0000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000004', 'info', 'Producto creado: Brownies Caseros ($25.00)',        '189.203.11.11', '{"productName":"Brownies Caseros","salePrice":25.00,"unitCost":10.00}', '2026-02-27 09:30:00-06'),
-- Camila ultimo login
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000006', 'bb000001-0000-0000-0000-000000000006', 'info', 'Login 2FA exitoso: camilahrr@gmail.com',              '189.203.11.10', '{"email":"camilahrr@gmail.com","loginCount":1}',       '2026-02-27 14:00:00-06'),

-- ═══ MARZO: Crecimiento progresivo ═══
-- Registro de nuevos usuarios
(gen_random_uuid(), 'user.register',   'user', 'aa000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Nuevo usuario registrado: antdehoyos@gmail.com',     '187.190.52.20', '{"email":"antdehoyos@gmail.com","role":"seller"}',     '2026-03-01 08:30:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Login 2FA exitoso: antdehoyos@gmail.com',             '187.190.52.20', '{"email":"antdehoyos@gmail.com","loginCount":1}',      '2026-03-01 08:35:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'bb000001-0000-0000-0000-000000000004', 'bb000001-0000-0000-0000-000000000004', 'info', 'Nuevo usuario registrado: anatorres.u@gmail.com',    '200.68.131.20', '{"email":"anatorres.u@gmail.com","role":"buyer"}',     '2026-03-02 09:00:00-06'),
-- Roberto último login
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000005', 'bb000001-0000-0000-0000-000000000005', 'info', 'Login 2FA exitoso: robdiaz.uni@gmail.com',            '187.190.52.11', '{"email":"robdiaz.uni@gmail.com","loginCount":2}',     '2026-03-03 10:30:00-06'),
-- Antonio crea burritos
(gen_random_uuid(), 'product.create',  'product', 'a0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Producto creado: Burritos de Machaca ($35.00)',     '187.190.52.20', '{"productName":"Burritos de Machaca","salePrice":35.00,"unitCost":18.00}', '2026-03-03 09:00:00-06'),
-- Ventas de Diego y Elena Mar 3
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000013', 'aa000001-0000-0000-0000-000000000005', 'info', 'Venta diaria registrada: 2026-03-03 - Inversión $75 / Ingreso $112',  '200.68.131.10', '{"saleDate":"2026-03-03","totalInvestment":75,"totalRevenue":112}', '2026-03-03 08:00:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000015', 'aa000001-0000-0000-0000-000000000006', 'info', 'Venta diaria registrada: 2026-03-03 - Inversión $48 / Ingreso $66',   '187.190.52.10', '{"saleDate":"2026-03-03","totalInvestment":48,"totalRevenue":66}',  '2026-03-03 10:00:00-06'),
-- Orden de Roberto
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000005', 'bb000001-0000-0000-0000-000000000005', 'info', 'Orden de compra creada por $56.00 - Estado: completed', '187.190.52.11', '{"totalAmount":56.00,"status":"completed"}', '2026-03-03 09:00:00-06'),
(gen_random_uuid(), 'order.complete',  'order', 'c0000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 'info', 'Orden completada y entregada - Monto: $56.00',       '200.68.131.10', '{"totalAmount":56.00}', '2026-03-03 10:00:00-06'),
-- Más registros
(gen_random_uuid(), 'user.register',   'user', 'aa000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 'info', 'Nuevo usuario registrado: marilopz.tc@gmail.com',    '189.203.11.20', '{"email":"marilopz.tc@gmail.com","role":"seller"}',    '2026-03-04 09:00:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 'info', 'Login 2FA exitoso: marilopz.tc@gmail.com',            '189.203.11.20', '{"email":"marilopz.tc@gmail.com","loginCount":1}',     '2026-03-04 09:05:00-06'),
-- Elena último login y actividad Mar 5
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000006', 'info', 'Login 2FA exitoso: elrios.campus@gmail.com',          '187.190.52.10', '{"email":"elrios.campus@gmail.com","loginCount":2}',   '2026-03-05 11:00:00-06'),
-- Mariana crea refrescos
(gen_random_uuid(), 'product.create',  'product', 'a0000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 'info', 'Producto creado: Agua y Refrescos ($15.00)',          '189.203.11.20', '{"productName":"Agua y Refrescos","salePrice":15.00,"unitCost":8.00}', '2026-03-05 10:30:00-06'),
-- Sofía venta Mar 6
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000004', 'info', 'Login 2FA exitoso: sofvega.uni@gmail.com',            '189.203.11.11', '{"email":"sofvega.uni@gmail.com","loginCount":2}',     '2026-03-06 08:45:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000011', 'aa000001-0000-0000-0000-000000000004', 'info', 'Venta diaria registrada: 2026-03-06 - Inversión $50 / Ingreso $100', '189.203.11.11', '{"saleDate":"2026-03-06","totalInvestment":50,"totalRevenue":100}', '2026-03-06 09:00:00-06'),
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000006', 'bb000001-0000-0000-0000-000000000006', 'info', 'Orden de compra creada por $50.00 - Estado: completed', '189.203.11.10', '{"totalAmount":50.00,"status":"completed"}', '2026-03-06 10:00:00-06'),
-- Más registros de usuarios
(gen_random_uuid(), 'user.register',   'user', 'aa000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000003', 'info', 'Nuevo usuario registrado: carlruiz98@gmail.com',     '200.68.131.30', '{"email":"carlruiz98@gmail.com","role":"seller"}',     '2026-03-06 10:00:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'bb000001-0000-0000-0000-000000000003', 'bb000001-0000-0000-0000-000000000003', 'info', 'Nuevo usuario registrado: juanmndz.tc@gmail.com',    '187.190.52.30', '{"email":"juanmndz.tc@gmail.com","role":"buyer"}',     '2026-03-07 10:00:00-06'),
-- Carlos crea papas
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000003', 'info', 'Login 2FA exitoso: carlruiz98@gmail.com',             '200.68.131.30', '{"email":"carlruiz98@gmail.com","loginCount":1}',      '2026-03-06 10:05:00-06'),
(gen_random_uuid(), 'product.create',  'product', 'a0000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000003', 'info', 'Producto creado: Bolsas de Papas ($20.00)',           '200.68.131.30', '{"productName":"Bolsas de Papas","salePrice":20.00,"unitCost":12.00}', '2026-03-07 11:00:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'bb000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001', 'info', 'Nuevo usuario registrado: pedsanch.22@gmail.com',    '200.68.131.40', '{"email":"pedsanch.22@gmail.com","role":"buyer"}',     '2026-03-08 08:30:00-06'),
(gen_random_uuid(), 'user.register',   'user', 'bb000001-0000-0000-0000-000000000002', 'bb000001-0000-0000-0000-000000000002', 'info', 'Nuevo usuario registrado: laurgrcia@gmail.com',      '189.203.11.40', '{"email":"laurgrcia@gmail.com","role":"buyer"}',       '2026-03-10 09:00:00-06'),

-- Mar 10-24: Actividad normal, ventas, compras
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Login 2FA exitoso: antdehoyos@gmail.com',             '187.190.52.20', '{"loginCount":2}',  '2026-03-10 08:25:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta diaria registrada: 2026-03-10 - Inversión $90 / Ingreso $140',  '187.190.52.20', '{"saleDate":"2026-03-10"}', '2026-03-10 08:30:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000008', 'aa000001-0000-0000-0000-000000000003', 'info', 'Venta diaria registrada: 2026-03-10 - Inversión $120 / Ingreso $180', '200.68.131.30', '{"saleDate":"2026-03-10"}', '2026-03-10 10:30:00-06'),
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001', 'info', 'Orden de compra creada por $70.00', '200.68.131.40', '{"totalAmount":70.00}', '2026-03-10 10:00:00-06'),
(gen_random_uuid(), 'order.complete',  'order', 'c0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Orden completada - Monto: $70.00',  '187.190.52.20', '{"totalAmount":70.00}', '2026-03-10 12:00:00-06'),
(gen_random_uuid(), 'inventory.waste', 'sale_detail', gen_random_uuid(), 'aa000001-0000-0000-0000-000000000001', 'warn', 'Merma detectada: 1 burrito expirado - Costo: $18.00', '187.190.52.20', '{"quantityLost":1,"wasteReason":"expired","wasteCost":18.00}', '2026-03-10 15:00:00-06'),
-- Ana último login
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000004', 'bb000001-0000-0000-0000-000000000004', 'info', 'Login 2FA exitoso: anatorres.u@gmail.com',            '200.68.131.20', '{"loginCount":3}',  '2026-03-12 15:00:00-06'),
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000004', 'bb000001-0000-0000-0000-000000000004', 'info', 'Orden de compra creada por $40.00', '200.68.131.20', '{"totalAmount":40.00}', '2026-03-12 10:30:00-06'),
-- Antonio edita imagen de producto
(gen_random_uuid(), 'product.update',  'product', 'a0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Producto actualizado: Burritos de Machaca - Imagen actualizada', '187.190.52.20', '{"productName":"Burritos de Machaca","field":"imageUrl","action":"image_updated"}', '2026-03-13 09:30:00-06'),
-- Ventas Mar 12-14
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta diaria registrada: 2026-03-12', '187.190.52.20', '{"saleDate":"2026-03-12"}', '2026-03-12 09:00:00-06'),
(gen_random_uuid(), 'sale.close',      'daily_sale', 'b0000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta cerrada: 2026-03-12 - Ganancia: $84.00',       '187.190.52.20', '{"saleDate":"2026-03-12","profit":84.00}', '2026-03-12 15:30:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000006', 'aa000001-0000-0000-0000-000000000002', 'info', 'Venta diaria registrada: 2026-03-14', '189.203.11.20', '{"saleDate":"2026-03-14"}', '2026-03-14 10:00:00-06'),
-- Diego último login Mar 15
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000005', 'aa000001-0000-0000-0000-000000000005', 'info', 'Login 2FA exitoso: diegomora.v@gmail.com',            '200.68.131.10', '{"loginCount":4}',  '2026-03-15 14:00:00-06'),
-- Forecast request (predicción)
(gen_random_uuid(), 'forecast.request','product', 'a0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Pronóstico solicitado: Burritos de Machaca para Lunes', '187.190.52.20', '{"productName":"Burritos de Machaca","dayOfWeek":"Monday","predictedDemand":8}', '2026-03-17 08:00:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta diaria: 2026-03-17', '187.190.52.20', '{}', '2026-03-17 08:00:00-06'),
-- Break-even calculation
(gen_random_uuid(), 'breakeven.calculate', 'product', 'a0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Punto de equilibrio calculado: Burritos - 18/35 = 6 unidades mín.', '187.190.52.20', '{"unitCost":18,"salePrice":35,"breakEvenUnits":6}', '2026-03-18 10:00:00-06'),
-- Sofía y Mariana Mar 19-20
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta diaria: 2026-03-19', '187.190.52.20', '{}', '2026-03-19 08:30:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000012', 'aa000001-0000-0000-0000-000000000004', 'info', 'Venta diaria: 2026-03-19 - Brownies', '189.203.11.11', '{}', '2026-03-19 08:30:00-06'),
(gen_random_uuid(), 'inventory.waste', 'sale_detail', gen_random_uuid(), 'aa000001-0000-0000-0000-000000000004', 'warn', 'Merma: 2 brownies expirados - Costo: $20.00', '189.203.11.11', '{"quantityLost":2,"wasteReason":"expired","wasteCost":20.00}', '2026-03-19 15:00:00-06'),
-- Juan último login Mar 20
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000003', 'bb000001-0000-0000-0000-000000000003', 'info', 'Login 2FA exitoso: juanmndz.tc@gmail.com',            '187.190.52.30', '{"loginCount":5}',  '2026-03-20 13:00:00-06'),
(gen_random_uuid(), 'order.cancel',    'order', 'c0000001-0000-0000-0000-000000000011', 'bb000001-0000-0000-0000-000000000003', 'info', 'Orden cancelada por el comprador - $25.00',           '187.190.52.30', '{"totalAmount":25.00,"reason":"Ya no pude pasar"}', '2026-03-20 13:00:00-06'),
-- Mariana edita imagen
(gen_random_uuid(), 'product.update',  'product', 'a0000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 'info', 'Producto actualizado: Agua y Refrescos - Imagen cambiada', '189.203.11.20', '{"productName":"Agua y Refrescos","field":"imageUrl","action":"image_updated"}', '2026-03-20 14:00:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000010', 'aa000001-0000-0000-0000-000000000003', 'info', 'Venta diaria: 2026-03-21', '200.68.131.30', '{}', '2026-03-21 10:00:00-06'),
-- Sofía ultimo login Mar 22
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000004', 'aa000001-0000-0000-0000-000000000004', 'info', 'Login 2FA exitoso: sofvega.uni@gmail.com',            '189.203.11.11', '{"loginCount":6}',  '2026-03-22 16:00:00-06'),
-- Report generado por admin
(gen_random_uuid(), 'report.generate', 'weekly_report', gen_random_uuid(), '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Reporte semanal generado: Semana del 10 al 16 de Marzo', '187.190.52.50', '{"weekStart":"2026-03-10","weekEnd":"2026-03-16"}', '2026-03-23 09:00:00-06'),
-- Expiración alert
(gen_random_uuid(), 'expiration.alert','inventory', gen_random_uuid(), '260439aa-3139-4c78-9850-e5e21490cbeb', 'warn', 'Alerta: 2 lotes próximos a vencer en 48 horas', '187.190.52.50', '{"productsExpiring":2}', '2026-03-24 08:00:00-06'),

-- ═══ MAR 25 - ABR 10: PERIODO MUERTO (0 entradas) ═══

-- ═══ ABRIL: Regreso gradual (solo 6 activos) ═══
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Login 2FA exitoso: antdehoyos@gmail.com',             '187.190.52.20', '{"loginCount":10}', '2026-04-11 09:00:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000002', 'aa000001-0000-0000-0000-000000000002', 'info', 'Login 2FA exitoso: marilopz.tc@gmail.com',            '189.203.11.20', '{"loginCount":8}',  '2026-04-11 10:00:00-06'),
-- Mariana recarga inventario
(gen_random_uuid(), 'inventory.create','inventory', gen_random_uuid(), 'aa000001-0000-0000-0000-000000000002', 'info', 'Inventario creado: Agua y Refrescos - 24 unidades', '189.203.11.20', '{"productName":"Agua y Refrescos","quantity":24}', '2026-04-11 10:30:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000003', 'info', 'Login 2FA exitoso: carlruiz98@gmail.com',             '200.68.131.30', '{"loginCount":7}',  '2026-04-12 08:30:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000001', 'bb000001-0000-0000-0000-000000000001', 'info', 'Login 2FA exitoso: pedsanch.22@gmail.com',            '200.68.131.40', '{"loginCount":8}',  '2026-04-12 09:00:00-06'),
-- Carlos edita precio de papas
(gen_random_uuid(), 'product.update',  'product', 'a0000001-0000-0000-0000-000000000003', 'aa000001-0000-0000-0000-000000000003', 'info', 'Producto actualizado: Bolsas de Papas - Precio $18→$20', '200.68.131.30', '{"productName":"Bolsas de Papas","field":"salePrice","oldValue":18,"newValue":20}', '2026-04-12 09:30:00-06'),
(gen_random_uuid(), 'user.login_2fa',  'user', 'bb000001-0000-0000-0000-000000000002', 'bb000001-0000-0000-0000-000000000002', 'info', 'Login 2FA exitoso: laurgrcia@gmail.com',              '189.203.11.40', '{"loginCount":6}',  '2026-04-13 10:00:00-06'),
-- Forecast
(gen_random_uuid(), 'forecast.request','product', 'a0000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Pronóstico: Burritos para Miércoles - Demanda est. 6 unidades', '187.190.52.20', '{"predictedDemand":6}', '2026-04-13 10:30:00-06'),
-- Admin login
(gen_random_uuid(), 'user.login_2fa',  'user', '260439aa-3139-4c78-9850-e5e21490cbeb', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Login 2FA exitoso: jarassanchezl@gmail.com',          '187.190.52.50', '{"loginCount":5}',  '2026-04-13 11:00:00-06'),
(gen_random_uuid(), 'report.generate', 'weekly_report', gen_random_uuid(), '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Reporte semanal generado: Semana del 7 al 13 de Abril', '187.190.52.50', '{"weekStart":"2026-04-07","weekEnd":"2026-04-13"}', '2026-04-13 12:00:00-06'),
-- Ventas del 14 de abril
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Login 2FA exitoso: antdehoyos@gmail.com',             '187.190.52.20', '{"loginCount":11}', '2026-04-14 08:25:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000016', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta diaria registrada: 2026-04-14 - Burritos', '187.190.52.20', '{}', '2026-04-14 08:30:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000017', 'aa000001-0000-0000-0000-000000000002', 'info', 'Venta diaria registrada: 2026-04-14 - Refrescos', '189.203.11.20', '{}', '2026-04-14 09:00:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000018', 'aa000001-0000-0000-0000-000000000003', 'info', 'Venta diaria registrada: 2026-04-14 - Papas', '200.68.131.30', '{}', '2026-04-14 10:00:00-06'),
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000012', 'bb000001-0000-0000-0000-000000000001', 'info', 'Orden creada por $70.00', '200.68.131.40', '{"totalAmount":70.00}', '2026-04-14 09:00:00-06'),
(gen_random_uuid(), 'order.complete',  'order', 'c0000001-0000-0000-0000-000000000012', 'aa000001-0000-0000-0000-000000000001', 'info', 'Orden completada - Monto: $70.00', '187.190.52.20', '{}', '2026-04-14 10:00:00-06'),
(gen_random_uuid(), 'sale.close',      'daily_sale', 'b0000001-0000-0000-0000-000000000016', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta cerrada: 2026-04-14 - Ganancia: $67.00', '187.190.52.20', '{}', '2026-04-14 15:00:00-06'),
-- Merma Apr 14
(gen_random_uuid(), 'inventory.waste', 'sale_detail', gen_random_uuid(), 'aa000001-0000-0000-0000-000000000001', 'warn', 'Merma: 1 burrito no vendido - Costo: $18.00', '187.190.52.20', '{"quantityLost":1,"wasteCost":18.00}', '2026-04-14 15:30:00-06'),
-- Apr 15 - hoy
(gen_random_uuid(), 'user.login_2fa',  'user', 'aa000001-0000-0000-0000-000000000001', 'aa000001-0000-0000-0000-000000000001', 'info', 'Login 2FA exitoso: antdehoyos@gmail.com',             '187.190.52.20', '{"loginCount":12}', '2026-04-15 08:00:00-06'),
(gen_random_uuid(), 'sale.create',     'daily_sale', 'b0000001-0000-0000-0000-000000000019', 'aa000001-0000-0000-0000-000000000001', 'info', 'Venta diaria: 2026-04-15 (en curso)', '187.190.52.20', '{}', '2026-04-15 08:00:00-06'),
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000014', 'bb000001-0000-0000-0000-000000000001', 'info', 'Orden creada por $40.00 - Papas', '200.68.131.40', '{"totalAmount":40.00}', '2026-04-15 08:30:00-06'),
(gen_random_uuid(), 'order.create',    'order', 'c0000001-0000-0000-0000-000000000015', 'bb000001-0000-0000-0000-000000000002', 'info', 'Orden creada por $35.00 - Burritos (pendiente)', '189.203.11.40', '{"totalAmount":35.00,"status":"requested"}', '2026-04-15 11:00:00-06'),
-- Login failed (intento fallido de un buyer inactivo)
(gen_random_uuid(), 'user.login_failed','user', 'bb000001-0000-0000-0000-000000000003', 'bb000001-0000-0000-0000-000000000003', 'warn', 'Intento de login fallido para juanmndz.tc@gmail.com', '187.190.52.30', '{"email":"juanmndz.tc@gmail.com","failedAttempts":1}', '2026-04-15 12:00:00-06'),
-- Admin review de hoy
(gen_random_uuid(), 'user.login_2fa',  'user', '260439aa-3139-4c78-9850-e5e21490cbeb', '260439aa-3139-4c78-9850-e5e21490cbeb', 'info', 'Login 2FA exitoso: jarassanchezl@gmail.com', '187.190.52.50', '{"loginCount":6}', '2026-04-15 15:00:00-06');

-- ============================================================
-- VERIFICACIÓN FINAL
-- ============================================================
SELECT '=== RESUMEN FINAL ===' as info;
SELECT 'users' as tabla, COUNT(*) as total FROM users
UNION ALL SELECT 'categories', COUNT(*) FROM categories
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'inventory_records', COUNT(*) FROM inventory_records
UNION ALL SELECT 'daily_sales', COUNT(*) FROM daily_sales
UNION ALL SELECT 'sale_details', COUNT(*) FROM sale_details
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'audit_logs', COUNT(*) FROM audit_logs
ORDER BY tabla;

COMMIT;
