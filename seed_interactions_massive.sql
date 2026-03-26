-- ==========================================
-- SEED DATA MASSIVE (INTERACTIONS)
-- ==========================================

-- 1. Asegurar que existan categorías (usar las existentes o crear)
INSERT INTO categories (id, name, description, is_active) 
VALUES 
    ('c1b1a1a1-1111-4444-8888-aaaaaaaaaaaa', 'Tecnología', 'Artículos electrónicos', true),
    ('c2b2a2a2-2222-4444-8888-bbbbbbbbbbbb', 'Papelería', 'Útiles escolares', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Insertar 25 nuevos estudiantes (Vendedores y Compradores)
-- PasswordHash para 'Password123!': $argon2id$v=19$m=19456,t=2,p=1$r42TFlHxL4r1rIJhrr4daQ$69z4Pq8MqIAf64o6pjQSd6pQ5/H0S5DiAzVn5OvJW+Y

DO $$
DECLARE
    new_user_id_var UUID;
    cat_id_var UUID;
    prod_id_var UUID;
    order_id_var UUID;
    i INTEGER;
    j INTEGER;
    k INTEGER;
    roles TEXT[] := ARRAY['buyer', 'seller'];
    first_names TEXT[] := ARRAY['Jesús', 'Elena', 'Roberto', 'Paola', 'Miguel', 'Lucía', 'Carlos', 'Sofía', 'Daniel', 'Valentina', 'Andrés', 'Ximena', 'Óscar', 'Renata', 'Hugo', 'Isabel', 'Raúl', 'Camila', 'Felipe', 'Mariana', 'Esteban', 'Gloria', 'Iván', 'Beatriz', 'Héctor'];
    last_names TEXT[] := ARRAY['Soto', 'Mejía', 'Luna', 'Vargas', 'Reyes', 'Torres', 'López', 'García', 'Pérez', 'Ruiz', 'Díaz', 'Morales', 'Méndez', 'Ortiz', 'Castillo', 'Flores', 'Gómez', 'Jiménez', 'Salazar', 'Rojas', 'Navarro', 'Castro', 'Herrera', 'Silva', 'Medina'];
BEGIN
    FOR i IN 1..25 LOOP
        new_user_id_var := gen_random_uuid();
        
        -- Insertar Usuario
        INSERT INTO users (id, email, password_hash, first_name, last_name, role, is_active, is_email_verified)
        VALUES (
            new_user_id_var,
            LOWER(first_names[i]) || '.' || LOWER(last_names[i]) || i || '@campus.edu.mx',
            '$argon2id$v=19$m=19456,t=2,p=1$r42TFlHxL4r1rIJhrr4daQ$69z4Pq8MqIAf64o6pjQSd6pQ5/H0S5DiAzVn5OvJW+Y',
            first_names[i],
            last_names[i],
            roles[(i % 2) + 1]::user_role,
            true,
            true
        );

        -- Si es vendedor, crear 3-5 productos
        IF roles[(i % 2) + 1] = 'seller' THEN
            FOR j IN 1..4 LOOP
                prod_id_var := gen_random_uuid();
                -- Alternar categorías
                IF j % 2 = 0 THEN
                   cat_id_var := '96a6da6d-d8a1-4635-8912-26b047979bb9'; -- Comida
                ELSE
                   cat_id_var := 'eb95e35d-c40d-4207-a86c-5b337d92c901'; -- Bebidas
                END IF;

                INSERT INTO products (id, seller_id, category_id, name, unit_cost, sale_price, is_perishable, is_active, image_url)
                VALUES (
                    prod_id_var,
                    new_user_id_var,
                    cat_id_var,
                    'Producto ' || first_names[i] || ' ' || j,
                    (RANDOM() * 20 + 5)::NUMERIC(10,2),
                    (RANDOM() * 50 + 25)::NUMERIC(10,2),
                    true,
                    true,
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500'
                );
            END LOOP;
        END IF;
    END LOOP;

    -- Generar 200 interacciones (órdenes) entre el 10 de Marzo y el 26 de Marzo 2026
    FOR k IN 1..200 LOOP
        order_id_var := gen_random_uuid();
        
        -- Seleccionar un comprador aleatorio (solo de los que tengan rol 'buyer')
        -- Y un producto aleatorio
        INSERT INTO orders (id, buyer_id, seller_id, total_amount, status, created_at, updated_at)
        SELECT 
            order_id_var,
            b.id,
            p.seller_id,
            0, -- Se actualizará luego
            (ARRAY['completed', 'completed', 'completed', 'cancelled', 'pending'])[floor(random()*5)+1],
            NOW() - (random() * (interval '16 days')),
            NOW()
        FROM users b
        CROSS JOIN products p
        WHERE b.role = 'buyer'
        ORDER BY RANDOM()
        LIMIT 1;

        -- Insertar 1-3 items por orden
        INSERT INTO order_items (id, order_id, product_id, quantity, unit_price, subtotal, created_at)
        SELECT 
            gen_random_uuid(),
            order_id_var,
            p.id,
            (floor(random()*3)+1)::INT,
            p.sale_price,
            (p.sale_price * (floor(random()*3)+1)),
            NOW()
        FROM products p
        ORDER BY RANDOM()
        LIMIT (floor(random()*2)+1)::INT
        ON CONFLICT DO NOTHING;

        -- Actualizar el total de la orden
        UPDATE orders SET total_amount = (SELECT SUM(subtotal) FROM order_items WHERE order_items.order_id = orders.id)
        WHERE orders.id = order_id_var;
    END LOOP;
END $$;
