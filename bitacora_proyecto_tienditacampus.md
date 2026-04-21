# Bitácora de Proyecto: TienditaCampus (Production Suite)

Este documento sirve como el "Cuaderno de Seguimiento" solicitado para registrar los avances, soluciones y el estado actual del despliegue en producción.

## 🚀 Despliegues de Infraestructura

| Componente | Plataforma | URL / Endpoint | Estado |
| :--- | :--- | :--- | :--- |
| **Frontend** | Vercel | [https://frontend-one-zeta-45.vercel.app/](https://frontend-one-zeta-45.vercel.app/) | ✅ Operativo |
| **Backend** | AWS EC2 | `http://52.201.136.58:3001/api` | ✅ Operativo |
| **Bases de Datos** | AWS EC2 (Postgres) | Host: `localhost` (Internal EC2) | ✅ Operativo |

---

## 📚 Rubricas y Conceptos Implementados

### 1. Seguridad y Mix Content (HTTPS -> HTTP)
*   **Problema**: Vercel (HTTPS) bloqueaba peticiones al Backend (HTTP) por seguridad.
*   **Solución**: Se configuró un **Proxy de Vercel** en `vercel.json`. Ahora el frontend llama a `/api` y Vercel lo redirige internamente al servidor AWS, eliminando el error de "Mixed Content".

### 2. Base de Datos Avanzada (BDA / Analíticas)
*   **Vistas de Negocio**: Creamos `vw_seller_roi` para calcular el Retorno de Inversión global por vendedor directamente en SQL.
*   **Vistas Temporales**: Creamos `vw_weekday_analytics` para graficar tendencias de ventas por día de la semana.
*   **Simulación Masiva**: Implementamos un script `seed_generator.js` que genera **2 meses (60 días)** de historial realista para múltiples vendedores.

### 3. Funcionalidad de Marketplace
*   Se restauró la página `/marketplace` que faltaba en el frontend, permitiendo la visualización pública de productos.

---

## 🛠️ Problemas Solucionados y "Glitches"

1.  **Error 404 Marketplace**: Resuelto creando la página `frontend/src/app/marketplace/page.tsx`.
2.  **Base URL Fix**: Se forzó la URL del API a `/api` en `frontend/src/services/api.ts` para que funcionara con el proxy de Vercel.
3.  **Restricciones de Truncamiento**: Se ajustó el seed para usar `TRUNCATE TABLE ... CASCADE` para poder limpiar la base de datos sin errores de llaves foráneas.

---

## 🚦 ¿En qué paso nos quedamos? (Pendientes)

> [!IMPORTANT]
> **Estado Actual: Fase de Simulación Final**

1.  **Carga de Inventario**: El seed V3.1 funcionó pero los productos no se veían en el marketplace porque faltaban "Inventory Records". Ya actualizamos el script para incluir stock inicial.
2.  **Verificación de Dashboard**: Necesitamos entrar con el usuario `master@tienditacampus.com` para confirmar que las gráficas de ROI y ventas muestran los datos de los 60 días simulados.
3.  **Ajuste de Credenciales**: Durante la última prueba, el login falló (401). Estamos re-ejecutando el seed para asegurar que la contraseña `admin_password_123` esté correctamente hasheada en la BD.

---

## 📝 Próximos Pasos (TODO)
- [ ] Ejecutar Seed V4 (con inventario y limpieza total de usuarios).
- [ ] Validar Login del usuario Admin.
- [ ] Captura de pantalla final del Dashboard con gráficas pobladas.
- [ ] Entrega final del proyecto.

**Nombre del Documento:** `bitacora_proyecto_tienditacampus.md`
