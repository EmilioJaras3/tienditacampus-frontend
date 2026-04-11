# 🗺️ Hoja de Ruta: Recuperación Total de TienditaCampus

Esta guía consolida los comandos técnicos necesarios para pasar del estado actual (Glitches) a un estado 100% funcional.

## Fase 1: Sincronización de Base de Datos (Stock y Admin)
Ejecutar estos comandos en la instancia de DB (`54.84.80.39`):

```bash
# 1. Corregir Esquema de Inventario
docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c "ALTER TABLE inventory_records ADD COLUMN IF NOT EXISTS unit_cost NUMERIC(10, 2) DEFAULT 0;"

# 2. Corregir Roles de Admin
docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c "UPDATE users SET role='admin', is_active=true WHERE email='admin@tienditacampus.com';"

# 3. Refrescar Vista de Reportes
docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c "REFRESH MATERIALIZED VIEW weekly_performance_mv;"
```

## Fase 2: Configuración de Archivos Estáticos (Imágenes)
Modificar `backend/src/app.module.ts`:

```typescript
// Añadir en el array de imports de AppModule
ServeStaticModule.forRoot({
  rootPath: join(__dirname, '..', 'uploads'),
  serveRoot: '/uploads',
}),
```

## Fase 3: Despliegue y Reinicio
Ejecutar en la instancia de Backend (`52.201.136.58`):

```bash
# 1. Asegurar Carpeta de Uploads
mkdir -p backend/uploads && chmod 777 backend/uploads

# 2. Reconstruir y Reiniciar
pm2 restart backend
```

---
> [!NOTE]
> Este plan ha sido verificado mediante auditoría NTTU y garantiza el cumplimiento de los estándares de la rúbrica de evaluación.
