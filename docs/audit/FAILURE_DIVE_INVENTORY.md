# 📈 Análisis de Fallo: Inventario y Sincronización de Stock

## 1. Síntoma
Los productos aparecen sin stock en el marketplace, y al intentar actualizar el inventario el servidor devuelve errores de base de datos. "No funciona el stock".

## 2. Diagnóstico NTTU (No Supongas)
Se identificó un **Schema Drift** crítico entre el código (TypeORM) y la base de datos de producción (`tc-prod-postgres`):
*   **Missing Column**: La columna `unit_cost` falta físicamente en la tabla `inventory_records`. El código intenta realizar cálculos financieros (Investment Amount) pero la base de datos rechaza la operación.
*   **Migration Desync**: La migración `V011__add_waste_traceability_and_breakeven.sql` parece no haberse ejecutado o haber fallado silenciosamente en la instancia remota de AWS.

## 3. Plan de Recuperación (Comandos SQL)

Se debe forzar la sincronización del esquema sin perder los datos de ventas existentes:

```sql
-- 1. Acceder a la instancia de DB y ejecutar vía psql:
ALTER TABLE inventory_records ADD COLUMN IF NOT EXISTS unit_cost NUMERIC(10, 2) DEFAULT 0;

-- 2. Corregir registros huérfanos de inversión (Cálculo sugerido)
UPDATE inventory_records SET investment_amount = quantity_initial * unit_cost WHERE investment_amount IS NULL;

-- 3. Activar el disparador de actualización de stock (Recovery Trigger)
-- Asegurarse de que el procedimiento almacenado sp_update_stock_on_sale existe.
```

### Comandos de Ejecución Remota
```bash
ssh -i "bd.tienditacampus.pem" ubuntu@54.84.80.39 "docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c 'ALTER TABLE inventory_records ADD COLUMN IF NOT EXISTS unit_cost NUMERIC(10, 2) DEFAULT 0;'"
```
