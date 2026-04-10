-- ============================================================
-- TienditaCampus - Consultas para Análisis de Datos
-- ============================================================

-- 1. Análisis General de Ventas por Semana
SELECT 
    DATE_TRUNC('week', sale_date)::DATE AS semana_inicio,
    (DATE_TRUNC('week', sale_date) + INTERVAL '6 days')::DATE AS semana_fin,
    COUNT(*) AS total_dias_con_ventas,
    SUM(total_investment) AS inversion_total,
    SUM(total_revenue) AS ingresos_totales,
    SUM(total_profit) AS ganancia_total,
    AVG(profit_margin) AS margen_promedio,
    SUM(units_sold) AS unidades_vendidas,
    SUM(units_lost) AS unidades_perdidas,
    SUM(total_waste_cost) AS costo_perdidas
FROM daily_sales 
WHERE is_closed = true
GROUP BY DATE_TRUNC('week', sale_date)
ORDER BY semana_inicio DESC;

-- 2. Rendimiento por Categoría de Producto
SELECT 
    c.name AS categoria,
    COUNT(p.id) AS total_productos,
    COALESCE(SUM(sd.quantity_sold), 0) AS unidades_vendidas,
    COALESCE(SUM(sd.quantity_lost), 0) AS unidades_perdidas,
    COALESCE(SUM(sd.subtotal), 0) AS ingresos_totales,
    COALESCE(SUM(sd.quantity_sold * sd.unit_cost), 0) AS costo_total,
    COALESCE(SUM(sd.subtotal - (sd.quantity_sold * sd.unit_cost)), 0) AS ganancia_total,
    CASE 
        WHEN COALESCE(SUM(sd.quantity_sold + sd.quantity_lost), 0) > 0 
        THEN (COALESCE(SUM(sd.quantity_lost), 0)::NUMERIC / SUM(sd.quantity_sold + sd.quantity_lost)) * 100 
        ELSE 0 
    END AS porcentaje_perdidas
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN sale_details sd ON p.id = sd.product_id
LEFT JOIN daily_sales ds ON sd.daily_sale_id = ds.id
WHERE c.is_active = true AND ds.is_closed = true
GROUP BY c.id, c.name
ORDER BY ingresos_totales DESC;

-- 3. Análisis de Rentabilidad por Producto
SELECT 
    p.name AS producto,
    c.name AS categoria,
    COUNT(sd.id) AS dias_vendido,
    SUM(sd.quantity_sold) AS total_unidades_vendidas,
    SUM(sd.quantity_lost) AS total_unidades_perdidas,
    AVG(sd.unit_price) AS precio_promedio_venta,
    AVG(sd.unit_cost) AS costo_promedio_unitario,
    SUM(sd.subtotal) AS ingresos_totales,
    SUM(sd.quantity_sold * sd.unit_cost) AS costo_total_ventas,
    SUM(sd.subtotal - (sd.quantity_sold * sd.unit_cost)) AS ganancia_total,
    CASE 
        WHEN SUM(sd.subtotal) > 0 
        THEN ((SUM(sd.subtotal - (sd.quantity_sold * sd.unit_cost)) / SUM(sd.subtotal)) * 100)
        ELSE 0 
    END AS margen_ganancia_porcentaje
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN sale_details sd ON p.id = sd.product_id
JOIN daily_sales ds ON sd.daily_sale_id = ds.id
WHERE p.is_active = true AND ds.is_closed = true
GROUP BY p.id, p.name, c.name
HAVING SUM(sd.quantity_sold) > 0
ORDER BY ganancia_total DESC;

-- 4. Análisis de Pérdidas por Motivo
SELECT 
    sd.waste_reason,
    COUNT(*) AS total_registros,
    SUM(sd.quantity_lost) AS unidades_perdidas,
    SUM(sd.waste_cost) AS costo_perdidas,
    AVG(sd.waste_cost) AS costo_promedio_perdida,
    c.name AS categoria_mas_afectada
FROM sale_details sd
JOIN products p ON sd.product_id = p.id
JOIN categories c ON p.category_id = c.id
WHERE sd.quantity_lost > 0 AND sd.waste_reason IS NOT NULL
GROUP BY sd.waste_reason, c.name
ORDER BY costo_perdidas DESC;

-- 5. Tendencia de Ventas Diarias (Últimos 30 días)
SELECT 
    sale_date,
    total_investment,
    total_revenue,
    total_profit,
    profit_margin,
    units_sold,
    units_lost,
    CASE 
        WHEN units_sold > 0 THEN (units_lost::NUMERIC / (units_sold + units_lost)) * 100
        ELSE 0 
    END AS waste_rate_pct
FROM daily_sales 
WHERE is_closed = true 
    AND sale_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY sale_date DESC;

-- 6. Análisis de Punto de Equilibrio
SELECT 
    p.name AS producto,
    AVG(ds.break_even_units) AS punto_equilibrio_promedio,
    SUM(sd.quantity_sold) AS unidades_vendidas_totales,
    CASE 
        WHEN SUM(sd.quantity_sold) >= AVG(ds.break_even_units) THEN 'SUPERA PUNTO EQUILIBRIO'
        ELSE 'NO ALCANZA PUNTO EQUILIBRIO'
    END AS estado_rentabilidad,
    (SUM(sd.quantity_sold) - AVG(ds.break_even_units)) AS unidades_sobre_equilibrio
FROM products p
JOIN sale_details sd ON p.id = sd.product_id
JOIN daily_sales ds ON sd.daily_sale_id = ds.id
WHERE ds.is_closed = true AND ds.break_even_units IS NOT NULL
GROUP BY p.id, p.name
ORDER BY unidades_sobre_equilibrio DESC NULLS LAST;

-- 7. Resumen Semanal Consolidado (Materialized View)
SELECT 
    TO_CHAR(week_start, 'DD/MM/YYYY') AS semana_inicio,
    TO_CHAR(week_end, 'DD/MM/YYYY') AS semana_fin,
    ROUND(total_investment::NUMERIC, 2) AS inversion_semanal,
    ROUND(total_revenue::NUMERIC, 2) AS ingresos_semanales,
    ROUND(total_profit::NUMERIC, 2) AS ganancia_semanal,
    ROUND(AVG(profit_margin)::NUMERIC, 2) AS margen_promedio,
    total_units_sold AS unidades_vendidas,
    total_units_lost AS unidades_perdidas,
    ROUND(waste_rate_pct::NUMERIC, 2) AS tasa_perdidas,
    CASE 
        WHEN total_profit > 0 THEN 'RENTABLE'
        ELSE 'NO RENTABLE'
    END AS estado_semana
FROM weekly_performance_mv
ORDER BY week_start DESC;

-- 8. Análisis de Eficiencia Operativa
SELECT 
    COUNT(DISTINCT ds.seller_id) AS total_vendedores,
    COUNT(DISTINCT ds.sale_date) AS dias_operacion,
    SUM(ds.total_investment) AS inversion_total,
    SUM(ds.total_revenue) AS ingresos_totales,
    SUM(ds.total_profit) AS ganancia_total,
    AVG(ds.profit_margin) AS margen_promedio_general,
    SUM(ds.units_sold) AS total_unidades_vendidas,
    SUM(ds.units_lost) AS total_unidades_perdidas,
    ROUND((SUM(ds.units_lost)::NUMERIC / NULLIF(SUM(ds.units_sold + ds.units_lost), 0)) * 100, 2) AS tasa_perdidas_global,
    ROUND(AVG(ds.break_even_units), 2) AS punto_equilibrio_promedio_general
FROM daily_sales ds
WHERE ds.is_closed = true;

-- 9. Top 5 Productos Más Rentables
SELECT 
    p.name AS producto,
    c.name AS categoria,
    SUM(sd.subtotal) AS ingresos_totales,
    SUM(sd.quantity_sold * sd.unit_cost) AS costo_total,
    SUM(sd.subtotal - (sd.quantity_sold * sd.unit_cost)) AS ganancia_neta,
    ROUND(((SUM(sd.subtotal - (sd.quantity_sold * sd.unit_cost)) / NULLIF(SUM(sd.subtotal), 0)) * 100), 2) AS margen_rentabilidad,
    SUM(sd.quantity_sold) AS unidades_vendidas
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN sale_details sd ON p.id = sd.product_id
JOIN daily_sales ds ON sd.daily_sale_id = ds.id
WHERE ds.is_closed = true
GROUP BY p.id, p.name, c.name
ORDER BY ganancia_neta DESC
LIMIT 5;

-- 10. Análisis de Sostenibilidad del Negocio
SELECT 
    'MARGEN PROMEDIO' AS metrica,
    ROUND(AVG(profit_margin), 2) AS valor,
    '%' AS unidad,
    CASE 
        WHEN AVG(profit_margin) >= 50 THEN 'EXCELENTE'
        WHEN AVG(profit_margin) >= 30 THEN 'BUENO'
        WHEN AVG(profit_margin) >= 20 THEN 'ACEPTABLE'
        ELSE 'MEJORAR'
    END AS evaluacion
FROM daily_sales WHERE is_closed = true

UNION ALL

SELECT 
    'TASA PÉRDIDAS' AS metrica,
    ROUND((SUM(units_lost)::NUMERIC / NULLIF(SUM(units_sold + units_lost), 0)) * 100, 2) AS valor,
    '%' AS unidad,
    CASE 
        WHEN (SUM(units_lost)::NUMERIC / NULLIF(SUM(units_sold + units_lost), 0)) * 100 <= 5 THEN 'EXCELENTE'
        WHEN (SUM(units_lost)::NUMERIC / NULLIF(SUM(units_sold + units_lost), 0)) * 100 <= 10 THEN 'BUENO'
        WHEN (SUM(units_lost)::NUMERIC / NULLIF(SUM(units_sold + units_lost), 0)) * 100 <= 15 THEN 'ACEPTABLE'
        ELSE 'CRÍTICO'
    END AS evaluacion
FROM daily_sales WHERE is_closed = true

UNION ALL

SELECT 
    'DÍAS RENTABLES' AS metrica,
    COUNT(CASE WHEN total_profit > 0 THEN 1 END)::NUMERIC AS valor,
    'días' AS unidad,
    CASE 
        WHEN COUNT(CASE WHEN total_profit > 0 THEN 1 END) / COUNT(*) >= 0.8 THEN 'EXCELENTE'
        WHEN COUNT(CASE WHEN total_profit > 0 THEN 1 END) / COUNT(*) >= 0.6 THEN 'BUENO'
        WHEN COUNT(CASE WHEN total_profit > 0 THEN 1 END) / COUNT(*) >= 0.4 THEN 'ACEPTABLE'
        ELSE 'CRÍTICO'
    END AS evaluacion
FROM daily_sales WHERE is_closed = true;
