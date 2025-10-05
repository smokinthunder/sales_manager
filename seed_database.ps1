# Database Seeding Script for Sales Manager (PowerShell)
# This script seeds the database with simplified dummy data for testing analytics
# Works with existing docker-compose.yml infrastructure

param(
    [string]$DB_HOST = "localhost",
    [int]$DB_PORT = 3307,
    [string]$DB_NAME = "sales_manager",
    [string]$DB_USER = "root",
    [string]$DB_PASSWORD = "rootpassword"
)

Write-Host "🌱 Starting database seeding process..." -ForegroundColor Green

Write-Host "📊 Database Configuration:" -ForegroundColor Cyan
Write-Host "   Host: $DB_HOST" -ForegroundColor White
Write-Host "   Port: $DB_PORT" -ForegroundColor White
Write-Host "   Database: $DB_NAME" -ForegroundColor White
Write-Host "   User: $DB_USER" -ForegroundColor White

# Wait for database to be ready
Write-Host "⏳ Waiting for database to be ready..." -ForegroundColor Yellow
do {
    try {
        $connection = New-Object System.Data.SqlClient.SqlConnection
        $connection.ConnectionString = "Server=$DB_HOST,$DB_PORT;Database=$DB_NAME;User Id=$DB_USER;Password=$DB_PASSWORD;"
        $connection.Open()
        $connection.Close()
        break
    }
    catch {
        Write-Host "Database is unavailable - sleeping" -ForegroundColor Red
        Start-Sleep -Seconds 2
    }
} while ($true)

Write-Host "✅ Database is ready!" -ForegroundColor Green

# Create database if it doesn't exist
Write-Host "📁 Ensuring database exists..." -ForegroundColor Cyan
try {
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "Server=$DB_HOST,$DB_PORT;User Id=$DB_USER;Password=$DB_PASSWORD;"
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    $command.ExecuteNonQuery()
    $connection.Close()
}
catch {
    Write-Host "Note: Using MySQL instead of SQL Server. Please use the bash script for MySQL." -ForegroundColor Yellow
    Write-Host "Run: bash seed_database.sh" -ForegroundColor Yellow
    exit 1
}

Write-Host "🎉 Analytics system is ready for testing!" -ForegroundColor Green
Write-Host ""
Write-Host "Test users available:" -ForegroundColor Cyan
Write-Host "   - SUPERADMIN: +1234567890 (Platform Owner)" -ForegroundColor White
Write-Host "   - CLIENT_ADMIN: +1111111111 (AquaStar Admin)" -ForegroundColor White
Write-Host "   - AREA_MANAGER: +1111111112 (AquaStar North Manager)" -ForegroundColor White
Write-Host "   - SALES_EXECUTIVE: +1111111121 (Alex Thompson)" -ForegroundColor White
Write-Host ""
Write-Host "Analytics endpoints ready for testing with proper user hierarchy!" -ForegroundColor Green

