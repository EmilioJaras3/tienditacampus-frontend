#!/bin/bash
set -e
cd ~/tiendita/frontend
npm install
npm run build
pm2 delete frontend || true
pm2 start npm --name "frontend" -- start
