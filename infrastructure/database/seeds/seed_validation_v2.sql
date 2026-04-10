-- ============================================================
-- SCRIPT DE POBLAMIENTO DE VALIDACIÓN FINAL V2
-- ============================================================

BEGIN;

-- 1. Limpieza segura
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM products;
DELETE FROM users WHERE email NOT LIKE 'jaras%'; -- Mantener solo al admin actual

-- 2. Usuarios (Sellers y Buyers)
INSERT INTO users (id, email, password, first_name, last_name, role) VALUES
('u-seller-antonio', 'antonio.hoyos@campus.edu', 'pass', 'Antonio', 'de Hoyos', 'seller'),
('u-seller-ana', 'ana.garcia@campus.edu', 'pass', 'Ana', 'García', 'seller'),
('u-seller-diego', 'diego.ramirez@campus.edu', 'pass', 'Diego', 'Ramírez', 'seller');

DO $$
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO users (id, email, password, first_name, last_name, role)
        VALUES ('u-buyer-' || i, 'student' || i || '@campus.edu', 'pass' || i, 'Estudiante', TO_CHAR(i, '00'), 'buyer');
    END LOOP;
END $$;

-- 3. Products (usando userId para el seller)
INSERT INTO products (id, "userId", name, description, price, unit_cost, stock, category_id, is_active) VALUES
('p-burrito', 'u-seller-antonio', 'Burritos Caseros', 'Guisado', 70.00, 38.50, 50, 1, true),
('p-papas', 'u-seller-ana', 'Papas', 'Salsa', 35.00, 15.00, 40, 2, true),
('p-torta', 'u-seller-diego', 'Torta', 'Jamón', 55.00, 28.00, 30, 1, true);

-- 4. Orders
-- Generar órdenes para el reporte dashboard
INSERT INTO orders (id, "userId", "sellerId", total_amount, status, created_at)
SELECT 'o-s1-' || i, 'u-buyer-' || (floor(random() * 19 + 1)::int), 'u-seller-antonio', 70.00, 'completed', NOW() - (floor(random() * 30)::int || ' days')::interval
FROM generate_series(1, 40) s(i);

-- 5. Items
INSERT INTO order_items (id, order_id, product_id, quantity, price)
SELECT 'item-' || id, id, 'p-burrito', 1, 70.00 FROM orders;

COMMIT;
