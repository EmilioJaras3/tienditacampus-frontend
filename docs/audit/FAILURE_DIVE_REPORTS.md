# 📊 Análisis de Fallo: Auditoría y Generación de Reportes

## 1. Síntoma
El usuario reporta que "no funciona la generación de reportes". Al intentar generar el reporte semanal, la petición da timeout o devuelve un objeto vacío.

## 2. Diagnóstico NTTU (No Supongas)
*   **Query Complexity**: El método `generateWeeklyReport` utiliza una consulta SQL de alta complejidad (líneas 16-96 de `ReportsService`) que depende de cálculos al vuelo de `daily_sales` y `sale_details`.
*   **Data Integrity Failure**: Las tablas de analíticas pobladas por el seeder manual no coinciden con los tipos esperados por la función agregada (Ej: `total_revenue` es esperado como `numeric(10,2)` pero la tabla tiene tipos incompatibles por un error en la migración V009).
*   **Missing View**: La vista materializada `weekly_performance_mv` es necesaria para las gráficas del dashboard, pero no se ha refrescado manualmente desde el despliegue.

## 3. Plan de Recuperación (Comandos)

```bash
# 1. Refrescar la Vista Materializada de Rendimiento Semanal
ssh -i "bd.tienditacampus.pem" ubuntu@54.84.80.39 "docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c 'REFRESH MATERIALIZED VIEW weekly_performance_mv;'"

# 2. Corregir tipos de datos en la tabla de reportes
ssh -i "bd.tienditacampus.pem" ubuntu@54.84.80.39 "docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c 'ALTER TABLE weekly_reports ALTER COLUMN total_revenue TYPE numeric(12,2);'"
```

> [!TIP]
> Para asegurar el funcionamiento, se recomienda ejecutar el script de seeder actualizado `massive_seed.sql` una vez corregido el esquema.
