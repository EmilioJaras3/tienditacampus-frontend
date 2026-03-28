#!/bin/bash
set -e

echo "=== 1. Stopping Services and Cleaning Up ==="
pm2 delete backend || true
pm2 delete frontend || true

# Explicit clean wipe of build targets
sudo rm -rf ~/tiendita/backend/dist
sudo rm -rf ~/tiendita/frontend/.next

echo "=== 2. Recreating Directory Structure ==="
mkdir -p ~/tiendita/backend/dist
mkdir -p ~/tiendita/frontend/.next/standalone

echo "=== 3. Extracting Backend Artifacts (v3) ==="
# unzip contents directly into the dist folder
sudo unzip -o ~/backend_dist_v3.zip -d ~/tiendita/backend/dist/

echo "=== 4. Extracting Frontend Artifacts (v3) ==="
# unzip contents directly into the standalone folder
sudo unzip -o ~/frontend_standalone_v3.zip -d ~/tiendita/frontend/.next/standalone/

echo "=== 5. Fixing Permissions ==="
sudo chown -R ubuntu:ubuntu ~/tiendita

echo "=== 6. Setting up Environment Variables ==="
# Backend .env (Postgres connection, JWT, etc.)
cd ~/tiendita/backend
cat > .env << 'ENVEOF'
NODE_ENV=production
TZ=America/Mexico_City
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_DB=tienditacampus
POSTGRES_USER=tienditacampus_user
POSTGRES_PASSWORD=tienditacampus_pass123
BACKEND_PORT=3001
PORT=3001
JWT_SECRET=tu_jwt_secret_muy_seguro_aqui_123456789
JWT_EXPIRATION=7d
ARGON2_MEMORY_COST=65536
ARGON2_TIME_COST=3
ARGON2_PARALLELISM=4
DEFAULT_ADMIN_EMAIL=jarassanchezl@gmail.com
DEFAULT_ADMIN_PASSWORD=TEST1234
ENVEOF

# Frontend .env.local
cd ~/tiendita/frontend
echo 'NEXT_PUBLIC_API_URL=http://98.82.69.208:3001/api' > .env.local

echo "=== 7. Starting Services ==="
cd ~/tiendita/backend
pm2 start dist/main.js --name backend

cd ~/tiendita/frontend
# Relative path from frontend root
pm2 start .next/standalone/server.js --name frontend --env PORT=3000

echo "=== 8. Verification ==="
sleep 5
pm2 list
curl -s http://localhost:3001/api/health && echo "Backend is UP"
curl -s http://localhost:3000 | head -c 200 && echo "Frontend is UP"
pm2 save
