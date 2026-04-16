# Carpetas Activas y Referencias

Fecha de revision: 2026-04-15

## Resumen

Este checkout no coincide por completo con la documentacion historica de "3 repos separados". La app activa esta repartida asi:

## Carpetas activas

| Carpeta | Estado | Uso real |
|---|---|---|
| `src/` | Activa | Frontend Next.js 14 actual |
| `public/` | Activa | Assets del frontend y PWA |
| `backend/` | Activa | Backend NestJS actual |
| `database/` | Activa | Migraciones y seeds SQL base |
| `devops/` | Activa | Scripts de operacion y soporte |
| `docs/` | Activa | Documentacion viva, aunque parcialmente desactualizada |
| `infrastructure/` | Activa parcial | Seeds y artefactos auxiliares de base de datos/logs |

## Carpetas de referencia, backup o ruido operativo

| Carpeta | Estado | Riesgo |
|---|---|---|
| `frontend/` | Inactiva / vacia | Confunde Docker y documentacion |
| `temp_backend/` | Duplicado temporal | Riesgo de editar el backend equivocado |
| `pi_privado_backup/` | Backup historico | La documentacion vieja todavia lo trata como fuente activa |
| `.next/` | Build artifact | No debe tratarse como fuente |
| `node_modules/` | Dependencias | No es fuente del proyecto |
| `skills/`, `.agents/`, `.qwen/` | Herramientas locales | No forman parte del producto TienditaCampus |
| `secrets/` | Sensible | No debe mezclarse con documentacion publica |
| `tools/` | Soporte puntual | Utilidad secundaria |

## Conclusiones

- El frontend real no esta en `frontend/`; esta en la raiz.
- El backend vigente es `backend/`; `temp_backend/` debe tratarse como copia temporal hasta confirmar lo contrario.
- `pi_privado_backup/` debe considerarse solo referencia historica.
- Cualquier documento operativo que diga `cd frontend` en este repo esta desalineado con el estado actual.
