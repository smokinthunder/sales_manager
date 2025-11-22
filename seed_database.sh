#!/bin/bash

# Database Seeding Script for Sales Manager
# This script seeds the database with simplified dummy data for testing analytics
# Works with existing docker-compose.yml infrastructure

set -e

echo "🌱 Starting database seeding process..."

# Database connection parameters (matching your docker-compose.yml)
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3307}
DB_NAME=${DB_NAME:-sales_manager}
DB_USER=${DB_USER:-sales_user}
DB_PASSWORD=${DB_PASSWORD:-sales_password}

echo "📊 Database Configuration:"
echo "   Host: $DB_HOST"
echo "   Port: $DB_PORT"
echo "   Database: $DB_NAME"
echo "   User: $DB_USER"

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
until mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" > /dev/null 2>&1; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "✅ Database is ready!"

# Create database if it doesn't exist
echo "📁 Ensuring database exists..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Run initialization script
echo "🏗️ Running database initialization..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < ./backend/init.sql

# Run simplified dummy data
echo "👥 Seeding users and tenants..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < ./backend/simplified_dummy_data.sql

# Run shops data
echo "🏪 Seeding shops..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < ./backend/simplified_shops_data.sql

# Run assignments
echo "👥 Seeding sales executive assignments..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < ./backend/simplified_assignments.sql

# Run synced data
echo "📊 Seeding sales data and analytics..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < ./backend/simplified_synced_data.sql

# Verify data was inserted
echo "🔍 Verifying data insertion..."
TENANT_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM tenants;")
USER_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM users;")
SHOP_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM shops;")
ASSIGNMENT_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM sales_executive_assignments;")
ORDER_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM synced_orders;")
PRODUCT_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM synced_products;")
DUE_COUNT=$(mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s -N -e "SELECT COUNT(*) FROM due_data;")

echo "📈 Database seeding completed successfully!"
echo "   - Tenants: $TENANT_COUNT"
echo "   - Users: $USER_COUNT"
echo "   - Shops: $SHOP_COUNT"
echo "   - Assignments: $ASSIGNMENT_COUNT"
echo "   - Orders: $ORDER_COUNT"
echo "   - Products: $PRODUCT_COUNT"
echo "   - Due Data: $DUE_COUNT"

echo "🎉 Analytics system is ready for testing!"
echo ""
echo "Test users available:"
echo "   - SUPERADMIN: +1234567890 (Platform Owner)"
echo "   - CLIENT_ADMIN: +1111111111 (AquaStar Admin)"
echo "   - AREA_MANAGER: +1111111112 (AquaStar North Manager)"
echo "   - SALES_EXECUTIVE: +1111111121 (Alex Thompson)"
echo ""
echo "Analytics endpoints ready for testing with proper user hierarchy!"

