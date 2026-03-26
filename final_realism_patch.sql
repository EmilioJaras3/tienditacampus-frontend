UPDATE products SET name = 'Chilaquiles Verdes' WHERE id IN (SELECT id FROM products WHERE name LIKE '%Producto%' AND sale_price > 70 LIMIT 1);
UPDATE products SET name = 'Café Americano' WHERE id IN (SELECT id FROM products WHERE name LIKE '%Producto%' AND sale_price BETWEEN 20 AND 35 LIMIT 1);
UPDATE products SET name = 'Torta de Chilaquil' WHERE id IN (SELECT id FROM products WHERE name LIKE '%Producto%' AND sale_price BETWEEN 40 AND 60 LIMIT 1);
UPDATE products SET name = 'Burrito Mixto' WHERE id IN (SELECT id FROM products WHERE id NOT IN (SELECT id FROM products WHERE name IN ('Chilaquiles Verdes', 'Café Americano', 'Torta de Chilaquil')) AND sale_price > 30 LIMIT 5);
UPDATE daily_sales SET total_waste_cost = total_revenue * 0.18 WHERE sale_date = CURRENT_DATE - INTERVAL '1 day';
UPDATE daily_sales SET total_waste_cost = total_revenue * 0.22 WHERE sale_date = CURRENT_DATE - INTERVAL '4 days';
