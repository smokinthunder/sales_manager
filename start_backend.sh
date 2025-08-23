#!/bin/bash

echo -e "\e[32mStarting Sales Manager Backend Services...\e[0m"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "\e[31mError: Docker is not running. Please start the Docker daemon first.\e[0m"
    exit 1
else
    echo -e "\e[32mDocker is running\e[0m"
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo -e "\e[31mError: Docker Compose is not installed. Please install it.\e[0m"
    exit 1
else
    echo -e "\e[32mDocker Compose is available\e[0m"
fi

# Navigate to the script directory
cd "$(dirname "$0")" || exit 1

# Create .env if it doesn't exist
if [ ! -f backend/.env ]; then
    echo -e "\e[33mCreating .env file from template...\e[0m"
    cp backend/env.example backend/.env
    echo -e "\e[33mPlease edit backend/.env with your configuration before continuing.\e[0m"
    read -n1 -r -p "Press any key to continue..." key
fi

# Start services
echo -e "\e[32mStarting services with Docker Compose...\e[0m"
docker-compose up -d

# Wait for services to be healthy
echo -e "\e[33mWaiting for services to be healthy...\e[0m"
sleep 30

# Check service status
echo -e "\e[32mChecking service status...\e[0m"
docker-compose ps

# Display service URLs
echo -e "\n\e[36mService URLs:\e[0m"
echo -e "\e[37mBackend API:     http://localhost:8000\e[0m"
echo -e "\e[37mAPI Docs:        http://localhost:8000/docs\e[0m"
echo -e "\e[37mHealth Check:    http://localhost:8000/health\e[0m"
echo -e "\e[37mMock Client API: http://localhost:8002\e[0m"
echo -e "\e[37mData Layer:      http://localhost:8001\e[0m"

echo -e "\n\e[32mBackend services started successfully!\e[0m"
echo -e "\e[33mUse 'docker-compose logs -f' to view logs\e[0m"
echo -e "\e[33mUse 'docker-compose down' to stop services\e[0m"
