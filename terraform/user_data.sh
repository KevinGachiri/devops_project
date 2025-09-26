#!/bin/bash
# Update packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Install Docker (latest from Docker’s official repo)
curl -fsSL https://get.docker.com | sh

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Install curl (for health checks in pipeline)
sudo apt-get install -y curl

# Verify installation
docker --version

# ---------------------------
# Deploy containers
# ---------------------------

# Login to Docker Hub (Terraform injects creds)
docker login -u ${dockerhub_username} -p ${dockerhub_token}

# Run ecommerce app
docker run -d --name ecommerce-app -p 80:3000 ${dockerhub_username}/ecommerce-app:latest

# Run Prometheus
docker run -d \
  --name prometheus \
  -p 9090:9090 \
  prom/prometheus

# Run Grafana
docker run -d \
  --name grafana \
  -p 3001:3000 \
  grafana/grafana
# ---------------------------
# #!/bin/bash
# # Update packages
# sudo apt-get update -y
# sudo apt-get upgrade -y

# # Install dependencies
# sudo apt-get install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     software-properties-common

# # Install Docker (latest from Docker’s official repo)
# curl -fsSL https://get.docker.com | sh

# # Add ubuntu user to docker group
# sudo usermod -aG docker ubuntu

# # Enable and start Docker
# sudo systemctl enable docker
# sudo systemctl start docker

# # Install curl (for health checks in pipeline)
# sudo apt-get install -y curl

# # Verify installation
# docker --version