#!/bin/bash
set -e

echo "=== 1. Backup and Cleanup ==="
cd ~/tiendita
mkdir -p backups
[ -d backend/dist ] && mv backend/dist backups/backend_dist_$(date +%Y%m%d_%H%M%S) || true
[ -d frontend/.next ] && mv frontend/.next backups/frontend_next_$(date +%Y%m%d_%H%M%S) || true
sudo rm -rf backend/dist frontend/.next

echo "=== 2. Extracting Backend Artifacts ==="
mkdir -p backend/dist
cd ~/tiendita/backend
sudo unzip -o ~/backend_dist.zip -d .
sudo chown -R ubuntu:ubuntu .

echo "=== 3. Extracting Frontend Artifacts ==="
mkdir -p frontend/.next/standalone
cd ~/tiendita/frontend
sudo unzip -o ~/frontend_standalone.zip -d .next/standalone/
sudo chown -R ubuntu:ubuntu .

echo "=== 4. Setting up Environment ==="
# Backend .env
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

# Frontend .env
cd ~/tiendita/frontend
echo 'NEXT_PUBLIC_API_URL=http://98.82.69.208:3001/api' > .env.local

echo "=== 5. Restarting Services ==="
pm2 delete backend || true
pm2 delete frontend || true

cd ~/tiendita/backend
pm2 start dist/main.js --name backend

cd ~/tiendita/frontend
pm2 start .next/standalone/server.js --name frontend --env PORT=3000

echo "=== 6. Verification ==="
sleep 5
pm2 list
curl -s http://localhost:3001/api/health && echo "Backend is UP"
curl -s http://localhost:3000 | head -c 200 && echo "Frontend is UP"
pm2 save
