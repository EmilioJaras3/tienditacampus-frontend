-- ============================================================
-- SCRIPT DE POBLAMIENTO TOTAL PARA GRÁFICAS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Limpieza total
TRUNCATE order_items, orders, products, inventory_records, sale_details, daily_sales RESTART IDENTITY CASCADE;
DELETE FROM users WHERE email NOT LIKE 'jaras%';

-- 2. Sellers con UUIDs fijos
INSERT INTO users (id, email, password_hash, first_name, last_name, role) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'antonio@campus.edu', 'pass', 'Antonio', 'Hoyos', 'seller'),
('550e8400-e29b-41d4-a716-446655440002', 'ana@campus.edu', 'pass', 'Ana', 'García', 'seller');

-- 3. Buyers dinámicos
DO $$ 
BEGIN 
    FOR i IN 1..25 LOOP 
        INSERT INTO users (id, email, password_hash, first_name, last_name, role) 
        VALUES (gen_random_uuid(), 'estudiante' || i || '@campus.edu', 'pass', 'Estudiante', TO_CHAR(i, '00'), 'buyer'); 
    END LOOP; 
END $$;

-- 4. Producto (usando el ID que el backend espera o uno nuevo)
INSERT INTO products (id, seller_id, name, description, sale_price, unit_cost) VALUES 
('45391111-1111-439c-83d8-a50237084baa', '550e8400-e29b-41d4-a716-446655440001', 'Burritos Mixtos', 'Guisado del día', 70.00, 35.00);

-- 5. Generación de 100 órdenes históricas (30 días)
DO $$ 
DECLARE 
    curr_buyer_id UUID; 
    curr_product_id UUID; 
    curr_seller_id UUID; 
    curr_order_id UUID; 
    curr_price NUMERIC; 
BEGIN 
    SELECT id INTO curr_seller_id FROM users WHERE role = 'seller' LIMIT 1; 
    SELECT id, sale_price INTO curr_product_id, curr_price FROM products LIMIT 1; 
    
    FOR i IN 1..100 LOOP 
        -- Seleccionar comprador al azar de los 25 insertados
        SELECT id INTO curr_buyer_id FROM users WHERE role = 'buyer' ORDER BY random() LIMIT 1; 
        
        IF curr_buyer_id IS NOT NULL THEN
            curr_order_id := gen_random_uuid(); 
            
            -- Insertar Orden con fecha aleatoria en los últimos 30 días
            INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
            VALUES (curr_order_id, curr_buyer_id, curr_seller_id, curr_price, 'completed', NOW() - (floor(random() * 30)::int || ' days')::interval); 
            
            -- Insertar Item correspondiente
            INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal) 
            VALUES (gen_random_uuid(), curr_order_id, curr_product_id, 1, curr_price, curr_price); 
        END IF;
    END LOOP; 
END $$;
