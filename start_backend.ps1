# Sales Manager Backend Startup Script for Windows PowerShell
# This script starts the backend services using Docker Compose

Write-Host "Starting Sales Manager Backend Services..." -ForegroundColor Green

# Check if Docker is running
try {
    docker version | Out-Null
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Host "Error: Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check if docker-compose is available
try {
    docker-compose version | Out-Null
    Write-Host "Docker Compose is available" -ForegroundColor Green
} catch {
    Write-Host "Error: Docker Compose is not available. Please install Docker Compose." -ForegroundColor Red
    exit 1
}

# Navigate to project root
Set-Location $PSScriptRoot

# Create .env file if it doesn't exist
if (-not (Test-Path "backend\.env")) {
    Write-Host "Creating .env file from template..." -ForegroundColor Yellow
    Copy-Item "backend\env.example" "backend\.env"
    Write-Host "Please edit backend\.env with your configuration before continuing." -ForegroundColor Yellow
    Write-Host "Press any key to continue..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Start services
Write-Host "Starting services with Docker Compose..." -ForegroundColor Green
docker-compose up -d

# Wait for services to be healthy
Write-Host "Waiting for services to be healthy..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Check service status
Write-Host "Checking service status..." -ForegroundColor Green
docker-compose ps

# Display service URLs
Write-Host "`nService URLs:" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:8000" -ForegroundColor White
Write-Host "API Docs: http://localhost:8000/docs" -ForegroundColor White
Write-Host "Health Check: http://localhost:8000/health" -ForegroundColor White
Write-Host "Mock Client API: http://localhost:8002" -ForegroundColor White
Write-Host "Data Layer: http://localhost:8001" -ForegroundColor White

Write-Host "`nBackend services started successfully!" -ForegroundColor Green
Write-Host "Use 'docker-compose logs -f' to view logs" -ForegroundColor Yellow
Write-Host "Use 'docker-compose down' to stop services" -ForegroundColor Yellow
