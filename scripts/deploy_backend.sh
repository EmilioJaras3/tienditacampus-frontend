#!/bin/bash
set -e
cd ~/tiendita/backend
npm install
export NODE_OPTIONS='--max-old-space-size=1024'
npm run build
pm2 delete backend || true
pm2 start dist/main.js --name "backend"
