# Contexto del Proyecto - TienditaCampus

Documento maestro resumido para el estado actual de este checkout.

## Que es

TienditaCampus es una plataforma web para ventas universitarias con enfoque en:

- productos e inventario,
- ventas diarias,
- reportes y benchmarking,
- marketplace publico,
- experiencia PWA.

## Stack actual

| Capa | Tecnologia | Puerto |
|---|---|---|
| Frontend | Next.js 14 + TypeScript | 3000 |
| Backend | NestJS 10 + TypeORM | 3001 |
| Base de datos | PostgreSQL 16 | 5432 |

## Estado real del repo

- Frontend activo: raiz del repo (`src/`, `public/`, `package.json`).
- Backend activo: `backend/`.
- SQL/migraciones base: `database/`.
- Backup historico: `pi_privado_backup/`.
- Carpeta `frontend/`: presente pero no activa en este checkout.

## Como levantarlo

### Docker

```bash
cp .env.example .env
docker compose up --build
```

### Local

```bash
# Terminal 1
cd backend && npm install && npm run start:dev

# Terminal 2
npm install && npm run dev
```

## Variables importantes

```env
NEXT_PUBLIC_API_URL=/api
BACKEND_PROXY_URL=http://localhost:3001/api
FRONTEND_URL=http://localhost:3000,http://localhost:8080
BACKEND_PORT=3001
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=tienditacampus
POSTGRES_USER=tc_admin
POSTGRES_PASSWORD=replace-with-a-secure-password
JWT_SECRET=replace-with-a-secure-random-secret
```

## Modulos backend observados

- `auth`
- `users`
- `products`
- `inventory`
- `sales`
- `orders`
- `reports`
- `dashboard`
- `break-even`
- `forecast`
- `audit`
- `benchmarking`
- `expiration`

## Observaciones clave

- El frontend consume siempre `/api` y depende del proxy server-side de Next.js.
- `BACKEND_PROXY_URL` es obligatoria para que el frontend reenvie peticiones al backend.
- Hay documentacion historica en el repo que ya no coincide con este estado actual.
