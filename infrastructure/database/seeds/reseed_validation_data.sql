-- ============================================================
-- SCRIPT DE POBLAMIENTO DE VALIDACIÓN FINAL (30 USUARIOS)
-- ============================================================

BEGIN;

-- 1. Limpieza segura
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM daily_sales;
DELETE FROM sale_details;
DELETE FROM inventory_records;
DELETE FROM products;
DELETE FROM sellers;
DELETE FROM users WHERE email NOT LIKE 'jaras%'; -- Mantener solo al admin actual

-- 2. Usuarios adicionales (para llegar a 30)
INSERT INTO users (id, email, password, first_name, last_name, role) VALUES
('u-seller-antonio', 'antonio.hoyos@campus.edu', 'pass', 'Antonio', 'de Hoyos', 'seller'),
('u-seller-ana', 'ana.garcia@campus.edu', 'pass', 'Ana', 'García', 'seller'),
('u-seller-diego', 'diego.ramirez@campus.edu', 'pass', 'Diego', 'Ramírez', 'seller'),
('u-seller-elena', 'elena.gomez@campus.edu', 'pass', 'Elena', 'Gómez', 'seller'),
('u-seller-carlos', 'carlos.perez@campus.edu', 'pass', 'Carlos', 'Pérez', 'seller');

DO $$
BEGIN
    FOR i IN 1..24 LOOP
        INSERT INTO users (id, email, password, first_name, last_name, role)
        VALUES ('u-buyer-' || i, 'student' || i || '@campus.edu', 'pass' || i, 'Estudiante', TO_CHAR(i, '00'), 'buyer');
    END LOOP;
END $$;

-- 3. Sellers
INSERT INTO sellers (id, user_id, store_name, description, rating) VALUES
('s-antonio', 'u-seller-antonio', 'Burritos de Hoyos', 'Premium', 5.0),
('s-ana', 'u-seller-ana', 'Ana Snacks', 'Snacks', 4.8),
('s-diego', 'u-seller-diego', 'Diego Lunch', 'Lunch', 4.5),
('s-elena', 'u-seller-elena', 'Elena Postres', 'Postres', 4.9),
('s-carlos', 'u-seller-carlos', 'Carlos Drinks', 'Drinks', 4.2);

-- 4. Products
INSERT INTO products (id, seller_id, name, description, price, cost, stock, category_id, isActive) VALUES
('p-burrito', 's-antonio', 'Burritos Caseros', 'Guisado', 70.00, 38.50, 50, 1, true),
('p-papas', 's-ana', 'Papas', 'Salsa', 35.00, 15.00, 40, 2, true),
('p-torta', 's-diego', 'Torta', 'Jamón', 55.00, 28.00, 30, 1, true),
('p-gelatina', 's-elena', 'Gelatina', 'Mosaico', 25.00, 10.00, 45, 3, true),
('p-coca', 's-carlos', 'Coca Cola', 'Bebida', 22.00, 12.00, 60, 4, true);

-- 5. Inventory
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, cost_per_unit, status, created_at) VALUES
('inv-1', 'p-burrito', 100, 50, 38.50, 'active', '2026-03-09 08:00:00'),
('inv-2', 'p-papas', 100, 80, 15.00, 'active', '2026-03-09 08:00:00');

-- 6. Orders
INSERT INTO orders (id, buyer_id, seller_id, total, status, created_at)
SELECT 'o-s1-' || i, 'u-buyer-' || (floor(random() * 23 + 1)::int), 's-antonio', 70.00, 'completed', '2026-03-09 12:00:00'::timestamp + (floor(random() * 10)::int || ' days')::interval
FROM generate_series(1, 40) s(i);

-- 7. Items
INSERT INTO order_items (order_id, product_id, quantity, price)
SELECT id, 'p-burrito', 1, 70.00 FROM orders WHERE seller_id = 's-antonio';

COMMIT;
