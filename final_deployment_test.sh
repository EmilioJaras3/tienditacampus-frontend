#!/bin/bash
# Test Final de Despliegue TienditaCampus
EMAIL="jarassanchezl@gmail.com"
PW="TienditaAdmin2026Secure"

echo "=== INICIANDO PRUEBA FINAL ==="
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\", \"password\":\"$PW\"}")

echo "Respuesta del Servidor: $LOGIN_RESPONSE"

if [[ $LOGIN_RESPONSE == *"requiresTwoFactor\":true"* ]]; then
    echo "Intento de login exitoso. Revisando logs de correo..."
    sleep 5
    pm2 logs backend --lines 30 --no-daemon
else
    echo "ERROR: El servidor no respondió como se esperaba."
    pm2 logs backend --lines 30 --no-daemon
fi
