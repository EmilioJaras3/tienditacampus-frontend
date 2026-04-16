# Guia de Desarrollo - TienditaCampus

## Estado del repo

- El frontend activo de este checkout vive en la raiz del repo.
- Las carpetas clave del frontend actual son `src/`, `public/`, `package.json` y `next.config.mjs`.
- La carpeta `frontend/` existe, pero no contiene la app activa.
- El backend vigente vive en `backend/`.

## Prerrequisitos

- Docker v20+ y Docker Compose v2+
- Node.js 20+ para correr sin Docker
- Git

## Setup rapido con Docker

```bash
cp .env.example .env
docker compose up --build
```

## Setup local sin Docker

```bash
# Backend
cd backend
npm install
npm run start:dev

# Frontend (desde la raiz del repo, en otra terminal)
cd ..
npm install
npm run dev
```

## Variables importantes

- `NEXT_PUBLIC_API_URL=/api`
- `BACKEND_PROXY_URL=http://localhost:3001/api`
- `FRONTEND_URL=http://localhost:3000,http://localhost:8080`

## URLs esperadas

| URL | Servicio |
|---|---|
| `http://localhost:3000` | Frontend local |
| `http://localhost:3001/api` | Backend local |
| `http://localhost:8080` | Stack via Docker |

## Nota importante sobre el proxy

El frontend llama a `/api/*` y el bridge server-side de Next.js reenvia esas peticiones al backend real usando `BACKEND_PROXY_URL`. Si esa variable no existe, el frontend respondera error 500 en las llamadas API.
