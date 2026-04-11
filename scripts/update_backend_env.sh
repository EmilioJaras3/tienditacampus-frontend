#!/bin/bash
set -e

ENV_FILE="/home/ubuntu/backend/.env"
REMOTE_DB_IP="172.31.74.4"

echo "⚙️ Updating Backend Configuration..."

if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: .env file not found at $ENV_FILE"
    exit 1
fi

# Update POSTGRES_HOST
sed -i "s/^POSTGRES_HOST=.*/POSTGRES_HOST=$REMOTE_DB_IP/" "$ENV_FILE"

# Update DATABASE_URL (assuming format: postgres://user:pass@host:port/db)
# We use a regular expression to find the host part between '@' and ':' or '/'
sed -i "s/\(@\)[^:/]\+\(\(:\| \/\)\)/\1$REMOTE_DB_IP\2/" "$ENV_FILE"

echo "🔄 Restarting Backend with PM2..."
cd /home/ubuntu/backend
pm2 restart backend

echo "✅ Backend updated and restarted!"
pm2 status
