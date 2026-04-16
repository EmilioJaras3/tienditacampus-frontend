# Auditoria de Integracion Frontend Backend DB

Fecha de revision: 2026-04-15

## Resumen ejecutivo

El backend compila y la arquitectura general es coherente, pero el proyecto tiene una desalineacion importante entre:

- codigo activo del frontend,
- `docker-compose`,
- variables de entorno del proxy,
- y documentacion operativa.

## Hallazgos priorizados

### 1. Riesgo critico de seguridad

- El archivo `.env` del repo contiene credenciales SMTP reales.
- Impacto: exposicion de secreto y posible abuso de cuenta.
- Accion recomendada: rotar la app password y reemplazar `.env` por valores locales no versionados.

### 2. Frontend activo distinto al documentado

- El frontend actual usa `src/`, `public/`, `package.json` y `next.config.mjs` en la raiz.
- `frontend/` esta vacia en este checkout.
- Impacto: `docker-compose` y varias guias apuntaban a la carpeta equivocada.

### 3. Proxy de Next.js dependia de variables no pasadas por Docker

- El frontend llama siempre a `/api` y delega al proxy server-side.
- El proxy requiere `BACKEND_PROXY_URL`.
- `docker-compose.yml` y `docker-compose.api.yml` no estaban pasando esa variable al frontend.
- Impacto: errores 500 en cualquier llamada `/api/*` cuando el bridge no conoce el backend destino.

### 4. Contrato roto en benchmarking

- Frontend: `src/services/benchmarking.service.ts` llama `POST /benchmarking/verify-status`.
- Backend activo: no existe ese endpoint en el controlador registrado.
- Impacto: funcionalidad del frontend sin implementacion correspondiente.

### 5. Documentacion mezclada entre estados viejos y actuales

- Hay documentos que siguen describiendo `pi_privado_backup/` como punto de arranque.
- Hay documentos que usan rutas `/api/v1/*` que ya no corresponden al backend actual.
- Hay inventarios de endpoints viejos que no reflejan `sales/today`, `sales/prepare`, `sales/track`, `dashboard/comparison`, `forecast`, `orders`, `audit`, `benchmarking`, etc.

## Verificaciones realizadas

- `backend/npm run build`: correcto.
- `frontend/npm run build`: no verificable por instalacion local inconsistente de `next` en `node_modules`; falla antes del build real.

## Estado por capa

### Frontend

- Patron de acceso HTTP centralizado y razonable.
- Rewrites locales ya existen en `next.config.mjs`.
- Dependencia fuerte del bridge `/api/proxy`.

### Backend

- Compila correctamente.
- Modulos activos claros en `AppModule`.
- Persisten restos de codigo duplicado en benchmarking que no ayudan al mantenimiento.

### Base de datos

- La capa SQL tiene bastante mas historia que el ORM.
- Hay varios seeds heredados y heterogeneos; no todos parecen representar el mismo modelo vigente.
- Conviene separar seeds "historicos", "validacion" y "produccion" con mayor disciplina.

## Recomendaciones concretas

1. Consolidar oficialmente este repo como monorepo operativo o, si no, limpiar la documentacion para distinguir repo actual vs repos externos.
2. Eliminar o archivar `frontend/` vacia y `temp_backend/` si ya no son necesarios.
3. Mantener `BACKEND_PROXY_URL` como variable obligatoria del frontend en cualquier despliegue.
4. Corregir o eliminar `verify-status` del frontend hasta que exista backend real.
5. Rotar credenciales SMTP y evitar cualquier secreto real dentro del repo.
