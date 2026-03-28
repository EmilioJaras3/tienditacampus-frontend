UPDATE products SET name = 'Chilaquiles Suizos' WHERE name LIKE 'Producto%' AND sale_price >= 80;
UPDATE products SET name = 'Torta de Pierna' WHERE name LIKE 'Producto%' AND sale_price BETWEEN 50 AND 79.99;
UPDATE products SET name = 'Café Capuchino' WHERE name LIKE 'Producto%' AND sale_price BETWEEN 30 AND 49.99;
UPDATE products SET name = 'Jugo Natural' WHERE name LIKE 'Producto%' AND sale_price < 30;
UPDATE users SET role = 'admin' WHERE email IN ('jarassabchezl@gmail.com', 'jarassanchezl@gmail.com');
