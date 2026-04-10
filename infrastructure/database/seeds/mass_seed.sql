-- ============================================================
-- SCRIPT DE MASA FOTO-VALIDACIÓN FINAL
-- ============================================================

DO $$ 
DECLARE 
    buyer_id UUID; 
    product_id UUID; 
    seller_id UUID; 
    order_id UUID; 
    price NUMERIC; 
BEGIN 
    -- Obtener el primer seller y el primer producto (insertados antes)
    SELECT id INTO seller_id FROM users WHERE role = 'seller' LIMIT 1; 
    SELECT id, sale_price INTO product_id, price FROM products LIMIT 1; 
    
    FOR i IN 1..50 LOOP 
        -- Comprador aleatorio
        SELECT id INTO buyer_id FROM users WHERE role = 'buyer' ORDER BY random() LIMIT 1; 
        
        IF buyer_id IS NOT NULL THEN
            order_id := gen_random_uuid(); 
            
            -- Insertar Orden
            INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at) 
            VALUES (order_id, buyer_id, seller_id, price, 'completed', NOW() - (floor(random() * 30)::int || ' days')::interval); 
            
            -- Insertar Item
            INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal) 
            VALUES (gen_random_uuid(), order_id, product_id, 1, price, price); 
        END IF;
    END LOOP; 
END $$;
