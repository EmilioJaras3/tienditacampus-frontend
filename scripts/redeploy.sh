#!/bin/bash
set -e

echo "=== 1. Branch Management (Clean) ==="
cd ~/tiendita
git fetch --all
git reset --hard origin/main
git checkout main || git checkout -b main origin/main

echo "=== 2. Backend Setup & Fixes ==="
cd ~/tiendita/backend
npm install

# Environment variables for backend
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

echo "=== Building Backend ==="
export NODE_OPTIONS='--max-old-space-size=1536'
npm run build
pm2 delete backend || true
pm2 start dist/main.js --name backend

echo "=== 3. Frontend Setup ==="
cd ~/tiendita/frontend
npm install
echo 'NEXT_PUBLIC_API_URL=http://98.82.69.208:3001/api' > .env.local

echo "=== Building Frontend ==="
npm run build
pm2 delete frontend || true

# Check if standalone exists
if [ -f ".next/standalone/server.js" ]; then
    echo "Starting in standalone mode"
    cp -r .next/static .next/standalone/.next/static 2>/dev/null || true
    cp -r public .next/standalone/public 2>/dev/null || true
    pm2 start .next/standalone/server.js --name frontend --env PORT=3000
else
    echo "Starting with npm start"
    pm2 start npm --name frontend -- start
fi

echo "=== 4. Verification ==="
sleep 5
pm2 list
curl -s http://localhost:3001/api/health && echo "Backend is UP"
curl -s http://localhost:3000 | head -c 200 && echo "Frontend is UP"
pm2 save
