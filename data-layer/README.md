# Data Layer Service - Server B

This is the Data Layer service that runs on Server B in the three-layer architecture.

## Architecture Role

- **Server A**: MySQL Database (isolated, no direct external access)
- **Server B**: Data Layer Service (this service - has database access)
- **Server C**: Backend API Gateway (communicates with this service)

## Purpose

The Data Layer service acts as a secure intermediary between the database and the backend:
- Has direct access to the MySQL database
- Exposes controlled API endpoints for data access
- Enforces tenant isolation and access controls
- Provides a clean interface for the backend to request data

## API Endpoints

### Health Check
- `GET /health` - Service and database health status

### Data Access
- `GET /api/users/{tenant_id}` - Get users for a tenant
- `GET /api/shops/{tenant_id}` - Get shops for a tenant
- `GET /api/territories/{tenant_id}` - Get territories for a tenant
- `GET /api/visits/{tenant_id}` - Get visits for a tenant
- `GET /api/routes/{tenant_id}` - Get routes for a tenant
- `GET /api/analytics/shop-performance/{tenant_id}` - Get shop analytics

### Data Sync
- `POST /api/sync/client-data` - Sync data from client's finance system

## Database Schema

The service expects the following tables:
- `users` - User information
- `shops` - Shop/store information
- `territories` - Territory definitions
- `visits` - Executive visit records
- `routes` - Route planning
- `orders` - Order information
- `order_lines` - Order line items
- `outstandings` - Outstanding amounts

## Environment Variables

- `DB_HOST` - Database host (default: mysql)
- `DB_PORT` - Database port (default: 3306)
- `DB_USERNAME` - Database username (default: sales_user)
- `DB_PASSWORD` - Database password (default: sales_password)
- `DB_NAME` - Database name (default: sales_manager)

## Running the Service

### Development
```bash
cd data-layer
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Docker
```bash
cd data-layer
docker build -t sales-manager-data-layer .
docker run -p 8000:8000 sales-manager-data-layer
```

## Security

- Database credentials are only known to this service
- All database operations go through vetted SQL queries
- Tenant isolation is enforced at the API level
- No direct database access from external services
