INSERT INTO projects (project_id, project_type, description, db_engine)
VALUES (2, 'ECOMMERCE', 'TienditaCampus - Evaluación Unidad 2', 'POSTGRESQL')
ON CONFLICT (project_id) DO NOTHING;

INSERT INTO queries (project_id, query_description, query_sql, target_table, query_type)
VALUES 
(2, 'Listar todos los productos disponibles', 'SELECT * FROM products WHERE stock > 0', 'products', 'SIMPLE_SELECT'),
(2, 'Ventas totales por categoría', 'SELECT c.name, SUM(oi.subtotal) FROM order_items oi JOIN products p ON oi.product_id = p.id JOIN categories c ON p.category_id = c.id GROUP BY c.name', 'order_items', 'AGGREGATION'),
(2, 'Top 5 productos más vendidos', 'SELECT p.name, COUNT(oi.id) as units FROM order_items oi JOIN products p ON oi.product_id = p.id GROUP BY p.name ORDER BY units DESC LIMIT 5', 'order_items', 'AGGREGATION');
