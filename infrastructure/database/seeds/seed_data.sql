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
        
        v_sold := floor(random() * 20 + 10)::int; 
        v_lost := floor(random() * 3)::int; 
        v_rev := v_sold * 70.00; 
        v_inv := (v_sold + v_lost) * 35.00; 
        v_waste := v_lost * 35.00; 
        
        INSERT INTO daily_sales (id, seller_id, sale_date, total_revenue, total_investment, total_waste_cost, is_closed) 
        VALUES (curr_daily_id, curr_seller_id, curr_date, v_rev, v_inv, v_waste, true); 
        
        INSERT INTO sale_details (id, daily_sale_id, product_id, quantity_prepared, quantity_sold, quantity_lost, unit_price, unit_cost, waste_cost) 
        VALUES (gen_random_uuid(), curr_daily_id, curr_product_id, v_sold + v_lost, v_sold, v_lost, 70.00, 35.00, v_waste); 
    END LOOP; 
END $$;
