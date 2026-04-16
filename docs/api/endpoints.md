# API Endpoints - TienditaCampus

## Estado del documento

Este archivo describe el backend observado en este checkout. Si contradice documentos historicos como `technical_specification.tex`, este archivo tiene prioridad operativa.

## Base URL

`/api`

## Autenticacion

| Metodo | Endpoint |
|---|---|
| POST | `/api/auth/register` |
| POST | `/api/auth/login` |
| POST | `/api/auth/verify-2fa` |
| POST | `/api/auth/resend-2fa` |
| POST | `/api/auth/google` |
| GET | `/api/auth/profile` |

## Productos y catalogo

| Metodo | Endpoint |
|---|---|
| GET | `/api/categories` |
| GET | `/api/products/marketplace` |
| GET | `/api/products/marketplace/:id` |
| GET | `/api/products` |
| POST | `/api/products` |
| GET | `/api/products/:id` |
| PATCH | `/api/products/:id` |
| DELETE | `/api/products/:id` |
| GET | `/api/users/public/:id` |

## Inventario, ventas y reportes

| Metodo | Endpoint |
|---|---|
| POST | `/api/inventory` |
| GET | `/api/inventory/product/:id` |
| GET | `/api/sales/today` |
| POST | `/api/sales/prepare` |
| POST | `/api/sales/track` |
| POST | `/api/sales/close-day` |
| GET | `/api/sales/roi` |
| GET | `/api/sales/history` |
| GET | `/api/sales/analytics/by-weekday` |
| GET | `/api/sales/prediction` |
| POST | `/api/reports/weekly/generate` |
| GET | `/api/reports/weekly` |
| GET | `/api/reports/weekly/:id` |
| DELETE | `/api/reports/weekly/:id` |
| GET | `/api/dashboard/comparison` |
| POST | `/api/break-even/calculate` |
| GET | `/api/forecast/:productId/day/:dayOfWeek` |

## Ordenes, auditoria y benchmarking

| Metodo | Endpoint |
|---|---|
| POST | `/api/orders/purchase` |
| GET | `/api/orders/my-purchases` |
| GET | `/api/orders/seller-sales` |
| PATCH | `/api/orders/:id/accept` |
| PATCH | `/api/orders/:id/reject` |
| PATCH | `/api/orders/:id/deliver` |
| GET | `/api/audit/my-activity` |
| GET | `/api/audit/recent` |
| GET | `/api/audit/search` |
| GET | `/api/benchmarking/project` |
| GET | `/api/benchmarking/metrics` |
| POST | `/api/benchmarking/run-queries` |
| POST | `/api/benchmarking/snapshot` |
| POST | `/api/benchmarking/snapshot/historical` |
| POST | `/api/benchmarking/verify-status` |
| POST | `/api/benchmarking/snapshots/execute` |
| GET | `/api/benchmarking/auth/google` |
| GET | `/api/benchmarking/auth/callback` |
| GET | `/api/benchmarking/snapshots/export/:projectId` |
| POST | `/api/expiration/run-manual` |
| GET | `/api/health` |
