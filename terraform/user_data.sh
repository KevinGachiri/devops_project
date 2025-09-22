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

# #!/bin/bash
# apt-get update -y
# apt-get install -y docker.io
# systemctl start docker
# systemctl enable docker
# docker login -u ${dockerhub_username} -p ${dockerhub_token}
# docker run -d --name ecommerce-app -p 80:3000 ${dockerhub_username}/ecommerce-app:latest


# # Update and install Docker on Amazon Linux 2
# yum update -y
# amazon-linux-extras install docker -y
# service docker start
# usermod -a -G docker ec2-user

# # Enable Docker service on boot
# systemctl enable docker

# Note: Application deployment is handled by the CI/CD pipeline.  This user data
# only prepares the EC2 instance by installing Docker.