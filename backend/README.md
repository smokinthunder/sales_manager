# Sales Manager Backend

FastAPI-based backend for the Sales Executive Management Platform implementing Clean Architecture with multi-tenant support and three-layer deployment model.

## Architecture Overview

This backend implements the three-layer architecture described in the system documentation:

1. **Public API Layer (FastAPI)** - Handles authentication, RBAC, validation, and rate limiting
2. **Private Data Layer (Middleware)** - Manages database operations and ETL processes
3. **Database Layer (MySQL)** - Stores business data with tenant isolation

## Features

- **Multi-tenant Architecture** - Secure tenant isolation with role-based access control
- **JWT Authentication** - Secure token-based authentication with OTP verification
- **RBAC System** - Role-based access control with hierarchical permissions
- **Clean Architecture** - Separation of concerns with domain-driven design
- **Structured Logging** - Comprehensive logging with correlation IDs
- **Database Schema** - Complete MySQL schema with indexes and relationships
- **Docker Support** - Containerized deployment with docker-compose
- **Development Mode** - Console OTP logging for development environments
- **Mock APIs** - Development-friendly mock client finance API
- **Windows PowerShell Scripts** - Automated service startup for Windows

## Technology Stack

- **FastAPI** - High-performance async web framework
- **SQLModel** - SQL database integration with Pydantic models
- **MySQL** - Primary database with connection pooling
- **Redis** - Caching and session storage
- **JWT** - JSON Web Token authentication
- **Structlog** - Structured logging
- **Pydantic** - Data validation and settings management

## Project Structure

```
backend/
├── app/
│   ├── api/                 # API layer (routes, dependencies)
│   │   └── deps.py         # Authentication and authorization dependencies
│   ├── core/                # Core configuration and utilities
│   │   ├── config.py        # Environment-based settings management
│   │   ├── database.py      # Database connection and session management
│   │   ├── security.py      # JWT authentication and security utilities
│   │   └── logging.py       # Structured logging configuration
│   ├── domain/              # Domain models and business logic
│   │   └── models/          # SQLModel-based business entities
│   │       ├── user.py      # User model with RBAC
│   │       └── tenant.py    # Multi-tenant configuration
│   └── main.py             # FastAPI application entry point
├── tests/                   # Test suite
│   ├── conftest.py          # Pytest configuration and fixtures
│   └── test_main.py         # Basic application tests
├── Dockerfile              # Production container
├── requirements.txt         # Python dependencies
├── init.sql                # Database initialization schema
├── env.example             # Environment configuration template
└── README.md               # This file
```

## Quick Start

### Prerequisites

- Python 3.11+
- Docker and Docker Compose
- MySQL 8.0+
- Redis 7.0+

### Development Setup

1. **Clone and setup environment:**
   ```bash
   cd backend
   cp env.example .env
   # Edit .env with your configuration
   ```

2. **Start services with Docker Compose:**
   ```bash
   # Option 1: Manual startup
   docker-compose up -d
   
   # Option 2: Windows PowerShell script (recommended)
   .\start_backend.ps1
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application:**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

5. **Access the API:**
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Health Check: http://localhost:8000/health
   - Mock Client API: http://localhost:8002
   - Data Layer: http://localhost:8001

### Production Deployment

1. **Build the container:**
   ```bash
   docker build -t sales-manager-backend .
   ```

2. **Run with proper environment variables:**
   ```bash
   docker run -d \
     --name sales-manager-backend \
     -p 8000:8000 \
     --env-file .env \
     sales-manager-backend
   ```

## Configuration

### Environment Variables

Key configuration options in `.env`:

- **Database**: Connection settings for MySQL with connection pooling
- **Security**: JWT secrets, token expiration, and OTP settings
- **SMS**: Provider configuration (in-house for production, console for development)
- **Features**: Module enable/disable flags and rate limiting
- **Data Layer**: Private middleware service URL and mTLS configuration
- **Redis**: Caching and session storage settings

### Feature Flags

- `ENABLE_ANALYTICS` - Enable analytics module
- `ENABLE_FILE_UPLOADS` - Enable file upload functionality
- `ENABLE_SYNC` - Enable data synchronization
- `ENABLE_APPROVALS` - Enable approval workflows

## API Endpoints

### Authentication
- `POST /api/v1/auth/request-otp` - Request OTP for phone number
- `POST /api/v1/auth/verify-otp` - Verify OTP and get tokens
- `POST /api/v1/auth/refresh` - Refresh access token

### Users
- `GET /api/v1/users/me` - Get current user profile
- `PUT /api/v1/users/me` - Update current user profile
- `GET /api/v1/users` - List users (admin only)

### Tenants
- `GET /api/v1/tenants/me` - Get current tenant info
- `PUT /api/v1/tenants/me` - Update tenant settings (admin only)

### Territories & Routes
- `GET /api/v1/territories` - List territories
- `POST /api/v1/routes` - Create route plan
- `GET /api/v1/routes` - List routes

### Visits
- `POST /api/v1/visits/checkin` - Check-in to shop
- `POST /api/v1/visits/checkout` - Check-out from shop
- `GET /api/v1/visits` - List visits

## Development

### Adding New Features

1. **Create domain models** in `app/domain/models/`
2. **Add API routes** in `app/api/v1/`
3. **Implement business logic** in domain services
4. **Add tests** in `tests/` directory

### Database Schema

The application includes a complete MySQL schema in `init.sql` with:
- Multi-tenant table structure with proper indexing
- User management and role-based access control
- Territory, shop, and route management
- Visit tracking with geolocation support
- Finance data tables (read-only from client systems)
- Approval workflows and audit logging

### Testing

Run the test suite:
```bash
pytest tests/ -v
```

The test suite includes:
- SQLite test database configuration
- FastAPI test client setup
- Basic endpoint and configuration tests
- Fixtures for common test data

## Security Features

- **JWT Authentication** - Secure token-based auth
- **Role-based Access Control** - Hierarchical permission system
- **Tenant Isolation** - Data separation between organizations
- **Input Validation** - Comprehensive request validation
- **Rate Limiting** - API abuse prevention
- **Audit Logging** - Complete action tracking

## Monitoring & Observability

- **Structured Logging** - JSON-formatted logs with correlation IDs
- **Health Checks** - Service health monitoring with Docker health checks
- **Performance Metrics** - Request timing and response codes via middleware
- **Audit Trails** - Complete user action logging and approval workflows
- **Request Logging** - Comprehensive request/response logging with performance metrics

## Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Check MySQL service is running
   - Verify connection credentials in `.env`
   - Ensure network connectivity

2. **OTP Not Working**
   - In development: Check console logs for OTP (no SMS sent)
   - In production: Verify SMS service configuration
   - Ensure `IS_DEVELOPMENT=true` in development

3. **Permission Denied**
   - Check user role and tenant access
   - Verify JWT token is valid and not expired
   - Check tenant status and user account status

4. **Docker Services Not Starting**
   - Ensure Docker Desktop is running
   - Check port conflicts (8000, 8001, 8002, 3306, 6379)
   - Use `docker-compose logs` to view service logs

### Logs

Application logs are available in:
- **Development**: Console output with structlog formatting
- **Production**: JSON-formatted logs for log aggregation
- **Docker**: Use `docker-compose logs -f [service-name]` for real-time logs

## Contributing

1. Follow Clean Architecture principles with proper separation of concerns
2. Add comprehensive tests for new features using the existing test infrastructure
3. Update documentation for API changes and new endpoints
4. Use conventional commit messages and follow the established code style
5. Ensure all tests pass before submitting changes
6. Follow the established security patterns for authentication and authorization

## Development Environment

### Mock Services

The development environment includes several mock services for testing:

1. **Mock Client Finance API** (`mock_client_api/`)
   - Simulates client's Tally-like finance system
   - Provides test data for products, shops, orders, payments, and outstandings
   - Implements the documented API contract for development

2. **Data Layer Service** (Port 8001)
   - Mock implementation of the private middleware service
   - Handles database operations and ETL processes
   - Provides the three-layer architecture separation

### Windows PowerShell Support

- **`start_backend.ps1`** - Automated service startup script
- Checks Docker availability and creates environment files
- Monitors service health and displays service URLs
- Provides Windows-friendly development experience

### Service Architecture

The development setup implements the three-layer architecture:
- **Public API Layer** (Port 8000) - FastAPI with authentication and RBAC
- **Private Data Layer** (Port 8001) - Mock middleware service
- **Database Layer** (Port 3306) - MySQL with tenant isolation
- **Mock Client API** (Port 8002) - Simulated finance system
- **Redis** (Port 6379) - Caching and session storage

## License

This project is proprietary software. All rights reserved.
