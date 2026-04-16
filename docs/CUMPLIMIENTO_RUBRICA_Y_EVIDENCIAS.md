# Cumplimiento de Rubrica y Evidencias

Fecha: 2026-04-15

## Objetivo

Este documento sirve para defender el proyecto frente a la rubrica compartida y para dejar evidencia clara de:

- arquitectura,
- pruebas,
- seguridad,
- base de datos,
- despliegue,
- y uso documentado de IA.

## 1. Lo que ya cumple el proyecto

### Proyecto funcionando

- Backend funcional con endpoints REST.
- Frontend con aviso de terminos y condiciones en el flujo de registro.
- 2FA implementado por correo con fallback a consola si SMTP no esta configurado.
- Separacion observable entre frontend, backend y base de datos.

### Backend y API

- Controladores, servicios y DTOs separados.
- Validacion de entrada con `class-validator`.
- Respuestas JSON y uso de codigos HTTP.
- Endpoints documentados en `docs/api/endpoints.md`.

### Base de datos

- Migraciones SQL versionadas.
- Entidades TypeORM y tablas relacionales.
- Uso de constraints, transacciones y vistas/materialized views en varias partes del sistema.

### Seguridad

- JWT.
- 2FA.
- Variables de entorno para secretos.
- CORS.
- Validacion de entradas.

## 2. Evidencia que deben mostrar en la evaluacion

### En vivo

1. `GET /api/health`
2. Registro de usuario con:
   - password fuerte,
   - aceptacion de terminos,
   - rol valido.
3. Login y, si aplica, verificacion 2FA.
4. Perfil autenticado.
5. Crear producto.
6. Agregar inventario.
7. Ver producto en marketplace o en listado propio.

### Documental

- Arquitectura y carpetas activas:
  `docs/CONTEXTO_PROYECTO.md`
  `docs/audit/CARPETAS_ACTIVAS_Y_REFERENCIAS.md`
- Endpoints vigentes:
  `docs/api/endpoints.md`
- Integracion frontend/backend/db:
  `docs/audit/INTEGRACION_FRONTEND_BACKEND_DB_2026-04-15.md`
- Variables de entorno:
  `.env.example`
  `docs/env-examples/`
- Pruebas manuales:
  `docs/api/TienditaCampus_Despliegue_Evaluacion.postman_collection.json`
  `docs/api/TienditaCampus_Despliegue_Evaluacion.postman_environment.json`

## 3. Huecos que deben cuidar antes de la defensa

- Rotar cualquier secreto que haya estado expuesto previamente.
- Tener datos reales o simulados bien justificados, no inventados sin trazabilidad.
- Explicar el codigo de BD, endpoints y consultas sin depender de lectura improvisada.
- Mostrar historial Git real y progresivo.

## 4. Declaracion de uso de IA y recursos externos

Se debe declarar de forma transparente:

- que se uso asistencia de IA como apoyo de documentacion, revision y refactorizacion,
- que el equipo entiende y puede defender el codigo resultante,
- y que toda decision tecnica final fue revisada y adaptada al proyecto.

## 5. Guion corto para defensa

1. Explicar la problematica y la hipotesis.
2. Mostrar arquitectura por capas.
3. Ejecutar 3 pruebas manuales en Postman.
4. Mostrar 1 flujo completo en la UI.
5. Enseñar modelo de datos, vistas, consultas y evidencia de resultados.
6. Explicar medidas de seguridad: password policy, 2FA, JWT, terminos y condiciones.
