-- Audit Enrichment Script - Realistic Business History
BEGIN;

-- 1. Create Actions for Sellers (Antonio, Marian, Pablo, Lucia, Diego)
INSERT INTO audit_logs (id, action, user_id, description, level, created_at, entity_type, entity_id)
SELECT 
    gen_random_uuid(),
    'CLOSE_DAY',
    u.id,
    'Cierre de jornada operativa: Venta diaria procesada exitosamente',
    'info',
    ds.sale_date::timestamp + interval '16 hours', -- Closed at 4 PM
    'daily_sales',
    ds.id
FROM users u
JOIN daily_sales ds ON u.id = ds.seller_id
WHERE u.role = 'seller'
LIMIT 50;

-- 2. Create Restock Events (Sellers)
INSERT INTO audit_logs (id, action, user_id, description, level, created_at, entity_type, entity_id)
SELECT 
    gen_random_uuid(),
    'INVENTORY_RESTOCK',
    u.id,
    'Abastecimiento de stock realizado para el producto: ' || p.name,
    'info',
    p.created_at + interval '1 day',
    'inventory_records',
    p.id
FROM users u
JOIN products p ON u.id = p.seller_id
WHERE u.role = 'seller';

-- 3. Create Product Creation Events
INSERT INTO audit_logs (id, action, user_id, description, level, created_at, entity_type, entity_id)
SELECT 
    gen_random_uuid(),
    'PRODUCT_CREATED',
    u.id,
    'Nuevo producto registrado en el catálogo: ' || p.name,
    'info',
    p.created_at,
    'products',
    p.id
FROM users u
JOIN products p ON u.id = p.seller_id
WHERE u.role = 'seller';

-- 4. Create Admin Actions (Isaac)
INSERT INTO audit_logs (id, action, user_id, description, level, created_at)
VALUES 
(gen_random_uuid(), 'SECURITY_SETTINGS_UPDATED', '7d1a78d2-596b-4041-abf8-8cd10f21216f', 'Configuración global de 2FA reforzada', 'warn', '2026-03-15 10:00:00+00'),
(gen_random_uuid(), 'UPDATE_ROLE', '7d1a78d2-596b-4041-abf8-8cd10f21216f', 'Rol de usuario actualizado a Seller para Marian Perez', 'info', '2026-02-20 12:00:00+00'),
(gen_random_uuid(), 'DATABASE_OPTIMIZATION', '7d1a78d2-596b-4041-abf8-8cd10f21216f', 'Mantenimiento preventivo de índices en RDS', 'info', '2026-04-01 03:00:00+00');

COMMIT;
