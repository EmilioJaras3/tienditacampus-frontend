#!/bin/bash
set -e

echo "🚀 Starting Database Instance Setup..."

# 1. Update system and install Docker
echo "📦 Installing Docker and dependencies..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 2. Configure Docker permissions
echo "👤 Configuring user permissions for Docker..."
sudo usermod -aG docker ubuntu || true

# 3. Start Database Service
echo "🏗️ Starting Database Containers..."
cd /home/ubuntu/database
sudo docker compose -f docker-compose.db.yml up -d

echo "✅ Database Instance Setup Complete!"
sudo docker ps
