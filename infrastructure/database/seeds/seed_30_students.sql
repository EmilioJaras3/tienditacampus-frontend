DO $$ 
DECLARE 
    curr_date DATE; 
    curr_daily_id UUID; 
    curr_seller_id UUID; 
    cat_id_food UUID := 'dd059b46-4faf-468c-84ad-65c88106f313'; -- Bebidasy Comidas
    cat_id_postre UUID := '274f0a4a-dd43-4471-b992-1ca11f6d1cc7'; -- Postres
    p_id_taco UUID := gen_random_uuid();
    p_id_burrito UUID := gen_random_uuid();
    p_id_cafe UUID := gen_random_uuid();
    p_id_galleta UUID := gen_random_uuid();
    p_id_torta UUID := gen_random_uuid();
    v_rev NUMERIC; 
    v_inv NUMERIC; 
    v_waste NUMERIC; 
    v_sold INT; 
    v_lost INT; 
    v_prep INT;
    v_price NUMERIC;
    v_cost NUMERIC;
    v_p_id UUID;
BEGIN 
    -- 1. Limpiar datos viejos
    DELETE FROM sale_details;
    DELETE FROM daily_sales;
    DELETE FROM products; 
    
    -- 2. Asegurar que el seller sea el master
    SELECT id INTO curr_seller_id FROM users WHERE email='master@tienditacampus.com' LIMIT 1; 
    
    -- 3. Crear catálogo variado con COLUMNAS CORRECTAS
    INSERT INTO products (id, seller_id, category_id, name, description, unit_cost, sale_price, is_perishable, is_active, created_at, updated_at) VALUES 
    (p_id_taco, curr_seller_id, cat_id_food, 'Tacos de Canasta', 'Orden de 3 tacos', 12.00, 25.00, true, true, now(), now()),
    (p_id_burrito, curr_seller_id, cat_id_food, 'Burrito de Pastor', 'Burrito grande con queso', 25.00, 45.00, true, true, now(), now()),
    (p_id_cafe, curr_seller_id, cat_id_food, 'Café Americano', 'Vaso de 12oz', 5.00, 15.00, true, true, now(), now()),
    (p_id_galleta, curr_seller_id, cat_id_postre, 'Galleta de Chispas', 'Galleta artesanal', 4.00, 12.00, true, true, now(), now()),
    (p_id_torta, curr_seller_id, cat_id_food, 'Torta Jamón/Queso', 'Torta clásica preparada', 30.00, 50.00, true, true, now(), now());

    -- 4. Generar actividad variada para 30 días
    FOR i IN 0..29 LOOP 
        curr_date := (CURRENT_DATE - i * interval '1 day')::date; 
        curr_daily_id := gen_random_uuid(); 
        
        v_rev := 0; v_inv := 0; v_waste := 0;

        INSERT INTO daily_sales (id, seller_id, sale_date, total_revenue, total_investment, total_waste_cost, is_closed) 
        VALUES (curr_daily_id, curr_seller_id, curr_date, 0, 0, 0, true); 

        -- Meter 3 productos diferentes cada día
        FOR j IN 1..3 LOOP
            CASE floor(random()*5)::int
                WHEN 0 THEN v_p_id := p_id_taco; v_price := 25.00; v_cost := 12.00;
                WHEN 1 THEN v_p_id := p_id_burrito; v_price := 45.00; v_cost := 25.00;
                WHEN 2 THEN v_p_id := p_id_cafe; v_price := 15.00; v_cost := 5.00;
                WHEN 3 THEN v_p_id := p_id_galleta; v_price := 12.00; v_cost := 4.00;
                ELSE v_p_id := p_id_torta; v_price := 50.00; v_cost := 30.00;
            END CASE;

            v_sold := floor(random() * 4 + 2)::int; 
            v_lost := (random() < 0.2)::int; 
            v_prep := v_sold + v_lost;
            
            INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_price, unit_cost, waste_cost) 
            VALUES (gen_random_uuid(), curr_daily_id, v_p_id, v_prep, v_sold, v_lost, v_price, v_cost, v_lost * v_cost); 

            v_rev := v_rev + (v_sold * v_price);
            v_inv := v_inv + (v_prep * v_cost);
            v_waste := v_waste + (v_lost * v_cost);
        END LOOP;

        UPDATE daily_sales SET total_revenue = v_rev, total_investment = v_inv, total_waste_cost = v_waste 
        WHERE id = curr_daily_id;
    END LOOP; 
END $$;
