#!/bin/bash
EMAIL="jarassanchezl@gmail.com"
PW="TienditaAdmin2026Secure"

echo "Triggering login for $EMAIL..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\", \"password\":\"$PW\"}")

echo "API Response: $LOGIN_RESPONSE"

echo "Waiting for mail logs..."
sleep 5
pm2 logs backend --lines 30 --no-daemon
