#!/bin/bash
# Update and install Docker on Amazon Linux 2
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Enable Docker service on boot
systemctl enable docker

# Note: Application deployment is handled by the CI/CD pipeline.  This user data
# only prepares the EC2 instance by installing Docker.