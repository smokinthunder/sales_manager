@echo off
REM Simple script to seed the database using existing docker-compose.yml
REM Usage: seed.bat

echo 🌱 Starting database seeding with existing docker-compose...

REM Check if docker-compose is running
docker-compose ps | findstr "sales_manager_mysql.*Up" >nul
if %errorlevel% neq 0 (
    echo ❌ MySQL container is not running. Starting docker-compose first...
    docker-compose up -d mysql
    echo ⏳ Waiting for MySQL to be ready...
    timeout /t 10 /nobreak >nul
)

REM Run the seeding service
echo 🚀 Running database seeding...
docker-compose --profile seed up db-seeder

echo ✅ Seeding completed!
echo.
echo 🎉 Analytics system is ready for testing!
echo.
echo Test users available:
echo    - SUPERADMIN: +1234567890 (Platform Owner)
echo    - CLIENT_ADMIN: +1111111111 (AquaStar Admin)
echo    - AREA_MANAGER: +1111111112 (AquaStar North Manager)
echo    - SALES_EXECUTIVE: +1111111121 (Alex Thompson)
echo.
echo You can now start the full system with: docker-compose up -d

