-- ============================================================
-- MASTER SEED SCRIPT: AUTH + DASHBOARD CHARTS
-- ============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Limpieza total
TRUNCATE order_items, orders, products, inventory_records, sale_details, daily_sales RESTART IDENTITY CASCADE;
DELETE FROM users WHERE email NOT LIKE 'jaras%';

-- 2. Usuarios con Argon2 Hash para "pass"
-- Hash: $argon2id$v=19$m=19456,t=2,p=1$eEuPX0rncbrhqyauxqwjFg$re8m+2AptH43M1r19yD0Xf8C9dM2WdHxIU+/7Bh
INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'antonio@campus.edu', '$argon2id$v=19$m=19456,t=2,p=1$eEuPX0rncbrhqyauxqwjFg$re8m+2AptH43M1r19yD0Xf8C9dM2WdHxIU+/7Bh', 'Antonio', 'Hoyos', 'admin', true),
('550e8400-e29b-41d4-a716-446655440002', 'ana@campus.edu', '$argon2id$v=19$m=19456,t=2,p=1$eEuPX0rncbrhqyauxqwjFg$re8m+2AptH43M1r19yD0Xf8C9dM2WdHxIU+/7Bh', 'Ana', 'García', 'seller', true);

-- 3. Producto
INSERT INTO products (id, seller_id, name, description, sale_price, unit_cost, is_active) VALUES 
('45391111-1111-439c-83d8-a50237084baa', '550e8400-e29b-41d4-a716-446655440001', 'Burritos Mixtos', 'Guisado del día', 70.00, 35.00, true);

-- 4. Inventario records
INSERT INTO inventory_records (id, product_id, quantity_initial, quantity_remaining, unit_cost, sale_price, status) VALUES
(gen_random_uuid(), '45391111-1111-439c-83d8-a50237084baa', 5000, 2500, 35.00, 70.00, 'active');

-- 5. Generación de Daily Sales y Sale Details (30 días de historia)
DO $$ 
DECLARE 
    curr_date DATE; 
    curr_daily_id UUID; 
    curr_seller_id UUID; 
    curr_product_id UUID; 
    v_rev NUMERIC; 
    v_inv NUMERIC; 
    v_waste NUMERIC; 
    v_sold INT; 
    v_lost INT; 
BEGIN 
    SELECT id INTO curr_seller_id FROM users WHERE role = 'admin' LIMIT 1; 
    SELECT id INTO curr_product_id FROM products LIMIT 1; 
    
    FOR i IN 0..30 LOOP 
        curr_date := (CURRENT_DATE - i * interval '1 day')::date; 
        curr_daily_id := gen_random_uuid(); 
        
        -- Random stats for the day
        v_sold := floor(random() * 20 + 10)::int; 
        v_lost := floor(random() * 3)::int; 
        v_rev := v_sold * 70.00; 
        v_inv := (v_sold + v_lost) * 35.00; 
        v_waste := v_lost * 35.00; 
        
        -- Insert Daily Sale
        INSERT INTO daily_sales (id, seller_id, sale_date, total_revenue, total_investment, total_waste_cost, is_closed) 
        VALUES (curr_daily_id, curr_seller_id, curr_date, v_rev, v_inv, v_waste, true); 
        
        -- Insert Sale Detail
        INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_price, unit_cost, waste_cost) 
        VALUES (gen_random_uuid(), curr_daily_id, curr_product_id, v_sold + v_lost, v_sold, v_lost, 70.00, 35.00, v_waste); 
    END LOOP; 
END $$;
