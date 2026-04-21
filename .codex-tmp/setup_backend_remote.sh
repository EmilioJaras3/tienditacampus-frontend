#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get install -y curl build-essential

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2

cd ~/backend
npm install
export NODE_OPTIONS='--max-old-space-size=1536'
npm run build
pm2 delete backend || true
pm2 start dist/src/main.js --name backend
pm2 save
pm2 status backend
