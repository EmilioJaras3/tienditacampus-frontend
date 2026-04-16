# Guia de Despliegue - TienditaCampus

## Despliegue manual

```bash
cp .env.example .env
docker compose -f docker-compose.yml build --no-cache
docker compose -f docker-compose.yml up -d
```

## Variables obligatorias

- `BACKEND_PROXY_URL` debe apuntar al backend real con prefijo `/api`.
- `NEXT_PUBLIC_API_URL` debe mantenerse en `/api`.
- `FRONTEND_URL` debe incluir los origenes autorizados por CORS del backend.

## Notas de despliegue

- En este checkout el Dockerfile del frontend activo es el `Dockerfile` de la raiz.
- No uses `context: ./frontend` para construir el frontend actual.
- Si desplegas el backend por separado, verifica `POSTGRES_*`, `JWT_SECRET` y SMTP antes de levantar.

## Verificacion

```bash
bash devops/scripts/health-check.sh
```
