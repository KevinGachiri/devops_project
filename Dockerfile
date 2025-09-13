# syntax=docker/dockerfile:1

# Use the official Node.js LTS Alpine image as a lightweight base
FROM node:lts-alpine as base

# Create and set working directory
WORKDIR /usr/src/app

# Copy package manifests first to leverage cached Docker layers
COPY package*.json ./

# Install production dependencies (no dev dependencies in final image)
RUN npm install --production

# Copy source code
COPY . .

# Expose the port that the app listens on (default 3000)
EXPOSE 3000

# Define the default command to run the application
CMD ["npm", "start"]