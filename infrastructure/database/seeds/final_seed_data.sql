-- ============================================================
-- SCRIPT DE POBLAMIENTO FINAL (CORRECTED COLUMN NAMES)
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Limpieza
TRUNCATE order_items, orders, products, inventory_records, sale_details, daily_sales RESTART IDENTITY CASCADE;
DELETE FROM users WHERE email NOT LIKE 'jaras%';

-- 2. Sellers
INSERT INTO users (id, email, password_hash, first_name, last_name, role) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'antonio.hoyos@campus.edu', '$2b$10$abcdefghijklmnopqrstuv', 'Antonio', 'de Hoyos', 'seller'),
('550e8400-e29b-41d4-a716-446655440002', 'ana.garcia@campus.edu', '$2b$10$abcdefghijklmnopqrstuv', 'Ana', 'García', 'seller'),
('550e8400-e29b-41d4-a716-446655440003', 'diego.ramirez@campus.edu', '$2b$10$abcdefghijklmnopqrstuv', 'Diego', 'Ramírez', 'seller');

-- 3. Buyers
DO $$
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO users (id, email, password_hash, first_name, last_name, role)
        VALUES (gen_random_uuid(), 'student' || i || '@campus.edu', 'pass', 'Estudiante', TO_CHAR(i, '00'), 'buyer');
    END LOOP;
END $$;

-- 4. Products (uso de is_active snake_case)
INSERT INTO products (id, seller_id, name, description, sale_price, unit_cost, stock, is_active) VALUES
(gen_random_uuid(), '550e8400-e29b-41d4-a716-446655440001', 'Burritos Caseros', 'Guisado', 70.00, 38.50, 50, true),
(gen_random_uuid(), '550e8400-e29b-41d4-a716-446655440002', 'Papas', 'Salsa', 35.00, 15.00, 40, true),
(gen_random_uuid(), '550e8400-e29b-41d4-a716-446655440003', 'Torta', 'Jamón', 55.00, 28.00, 30, true);

-- 5. Orders
DO $$
DECLARE
    buyer_record RECORD;
    order_id UUID;
    product_record RECORD;
BEGIN
    FOR i IN 1..100 LOOP
        SELECT id INTO buyer_record FROM users WHERE role = 'buyer' ORDER BY random() LIMIT 1;
        SELECT id, sale_price, seller_id INTO product_record FROM products ORDER BY random() LIMIT 1;
        
        IF buyer_record.id IS NOT NULL AND product_record.id IS NOT NULL THEN
            order_id := gen_random_uuid();
            INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at)
            VALUES (order_id, buyer_record.id, product_record.seller_id, product_record.sale_price, 'completed', NOW() - (floor(random() * 30)::int || ' days')::interval);
            
            INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal)
            VALUES (gen_random_uuid(), order_id, product_record.id, 1, product_record.sale_price, product_record.sale_price);
        END IF;
    END LOOP;
END $$;
