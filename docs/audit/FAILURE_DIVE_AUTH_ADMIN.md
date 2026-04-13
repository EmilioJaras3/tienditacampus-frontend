# 🕵️ Análisis de Fallo: Autenticación y Cuenta Admin

## 1. Síntoma
El usuario reporta que "no funciona la cuenta admin". Al intentar el login, se reciben errores 400 o 401, y el acceso a rutas protegidas (`/api/benchmarking`, `/api/admin/*`) está bloqueado.

## 2. Diagnóstico NTTU (No Supongas)
Tras auditar el código y la base de datos de producción (`54.84.80.39`), se identificaron las siguientes causas:
*   **Schema Drift**: En la base de datos de producción falta la columna `status` que algunos scripts heredados intentan consultar. La columna real en la entidad es `is_active`.
*   **Desajuste de Role**: El decorador `@Roles('admin')` en los controladores está fallando si el usuario no tiene exactamente el string 'admin' en la base de datos.
*   **Hash Mismatch**: En la última migración, el usuario administrador no fue re-hasheado tras el cambio de la entidad `User`.

## 3. Plan de Recuperación (Comandos)

Para restaurar el acceso administrativo sin comprometer la seguridad:

```bash
# 1. Verificar el estado del usuario en la DB
docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c "SELECT email, role, is_active FROM users WHERE email='admin@tienditacampus.com';"

# 2. Corregir el Rol y Activar cuenta (si es necesario)
docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c "UPDATE users SET role='admin', is_active=true WHERE email='admin@tienditacampus.com';"

# 3. Forzar cambio de contraseña (Nueva: admin_password_final)
# Se debe generar el hash con bcrypt antes de ejecutar este comando.
docker exec tc-prod-postgres psql -U tiendita_user -d tienditacampus -c "UPDATE users SET password_hash='\$2b\$10\$...HASH_AQUI...' WHERE email='admin@tienditacampus.com';"
```

> [!IMPORTANT]
> Se recomienda cambiar la validación del controlador para que use el decorador `@UseGuards(JwtAuthGuard, RolesGuard)` de forma estricta.
