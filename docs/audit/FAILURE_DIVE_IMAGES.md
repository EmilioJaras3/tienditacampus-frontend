# 🖼️ Análisis de Fallo: Orquestación y Carga de Imágenes

## 1. Síntoma
Las imágenes en el Marketplace no cargan o aparecen como "roto". Al subir un producto, la imagen no se visualiza.

## 2. Diagnóstico NTTU (No Supongas)
*   **Missing ServeStaticModule**: El archivo `backend/src/app.module.ts` no importa el módulo encargado de servir archivos estáticos.
*   **Missing API Config**: `backend/src/main.ts` no tiene el helper encargado de mapear la ruta física de `/uploads` con la ruta virtual `/api/uploads`.
*   **Diagnosis**: En producción (AWS EC2), los archivos se guardan en el disco pero el servidor NestJS no tiene ninguna "ruta" expuesta para devolver esos bits al navegador.

## 3. Plan de Recuperación (Comandos y Código)

### A. Modificación de Código (Fix Logístico)
Se debe añadir lo siguiente a `app.module.ts`:
```typescript
ServeStaticModule.forRoot({
  rootPath: join(__dirname, '..', 'uploads'),
  serveRoot: '/uploads',
}),
```

### B. Comandos de Infraestructura
```bash
# 1. Crear la carpeta de uploads con permisos correctos en AWS
ssh -i "bd.tienditacampus.pem" ubuntu@52.201.136.58 "mkdir -p backend/uploads && chmod 777 backend/uploads"

# 2. Reiniciar el backend para aplicar el middleware estático
ssh -i "bd.tienditacampus.pem" ubuntu@52.201.136.58 "pm2 restart backend"
```
