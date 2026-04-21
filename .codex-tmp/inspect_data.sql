-- Buscar admin
SELECT id, email, role FROM users WHERE email = 'jarassanchezl@gmail.com';
SELECT id, email, role FROM users WHERE role = 'admin';

-- Ver estructura de productos existentes
SELECT p.id, p.name, p.seller_id, p.unit_cost, p.sale_price, p.is_perishable, p.shelf_life_days, p.category_id 
FROM products p LIMIT 5;

-- Ver estructura de ventas existentes
SELECT ds.id, ds.seller_id, ds.sale_date, ds.total_investment, ds.total_revenue, ds.units_sold, ds.units_lost, ds.is_closed
FROM daily_sales ds LIMIT 3;

-- Ver detalles de venta
SELECT sd.id, sd.daily_sale_id, sd.product_id, sd.quantity_prepared, sd.quantity_sold, sd.quantity_lost, sd.waste_reason
FROM sale_details sd LIMIT 5;

-- Ver órdenes
SELECT o.id, o.buyer_id, o.seller_id, o.total_amount, o.status
FROM orders o LIMIT 5;

-- Ver auditoría
SELECT al.id, al.action, al.entity_type, al.description, al.level, al.created_at
FROM audit_logs al ORDER BY al.created_at DESC LIMIT 5;

-- Tablas del enumtype waste_reason
SELECT typname, enumlabel FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid WHERE t.typname = 'waste_reason_type';
