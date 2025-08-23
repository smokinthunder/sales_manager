# Sales Manager Project Structure

This document explains the project structure and how it implements the three-layer architecture.

## Project Overview

The Sales Manager platform follows a strict three-layer architecture where each layer has specific responsibilities and access patterns:

```
┌─────────────────┐    HTTP/HTTPS    ┌─────────────────┐    HTTP/HTTPS    ┌─────────────────┐
│   Flutter Apps  │ ◄──────────────► │  Backend API    │ ◄──────────────► │  Data Layer     │
│   (Mobile/Web)  │                  │  (Server C)     │                  │  (Server B)     │
└─────────────────┘                  └─────────────────┘                  └─────────────────┘
                                               │                                      │
                                               │                                      │
                                               ▼                                      ▼
                                        ┌─────────────────┐                  ┌─────────────────┐
                                        │      Redis      │                  │     MySQL DB     │
                                        │   (Caching)     │                  │   (Server A)     │
                                        └─────────────────┘                  └─────────────────┘
```

## Directory Structure

```
sales_manager/
├── data-layer/                    # Server B: Data Layer Service
│   ├── app/
│   │   └── main.py               # Data Layer FastAPI application
│   ├── Dockerfile                 # Data Layer container definition
│   ├── requirements.txt           # Data Layer dependencies
│   └── README.md                  # Data Layer documentation
│
├── backend/                       # Server C: Backend API Gateway
│   ├── app/
│   │   ├── api/                  # API endpoints
│   │   │   └── v1/
│   │   │       ├── users.py      # User API endpoints
│   │   │       └── __init__.py
│   │   ├── core/                 # Core configuration
│   │   ├── domain/               # Domain models
│   │   ├── services/             # Service layer
│   │   │   ├── data_layer_client.py  # Client for Data Layer
│   │   │   └── __init__.py
│   │   └── main.py               # Backend FastAPI application
│   ├── Dockerfile.backend        # Backend container definition
│   ├── requirements.txt           # Backend dependencies
│   └── README.md                  # Backend documentation
│
├── mock-client-api/               # Mock client finance system
│   └── main.py                   # Mock API endpoints
│
├── docker-compose.yml             # Service orchestration
├── SYSTEM_ARCHITECTURE.md         # System architecture documentation
├── THREE_LAYER_ARCHITECTURE.md    # Three-layer implementation details
└── PROJECT_STRUCTURE.md           # This file
```

## Layer Responsibilities

### Server A: Database Layer (MySQL)
- **Location**: `mysql` service in docker-compose.yml
- **Purpose**: Primary data storage
- **Access**: Only accessible from Server B (Data Layer)
- **Network**: `database_network` only

### Server B: Data Layer Service
- **Location**: `data-layer/` directory
- **Purpose**: Database access and business logic
- **Access**: Can access Server A (Database), exposes APIs to Server C
- **Network**: Both `database_network` and `backend_network`
- **Port**: 8001 (external), 8000 (internal)

### Server C: Backend API Gateway
- **Location**: `backend/` directory
- **Purpose**: Public API endpoints, authentication, business logic orchestration
- **Access**: Can only communicate with Server B (Data Layer), never directly with Server A
- **Network**: `backend_network` only
- **Port**: 8000

## Service Communication

### Backend → Data Layer
The backend uses the `DataLayerClient` service to communicate with the data layer:

```python
# In backend/app/services/data_layer_client.py
class DataLayerClient:
    async def get_users(self, tenant_id: str) -> List[Dict[str, Any]]:
        return await self._make_request("GET", f"/api/users/{tenant_id}")
```

### Data Layer → Database
The data layer directly accesses the MySQL database using SQLAlchemy:

```python
# In data-layer/app/main.py
engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

## Development Workflow

### 1. Start Individual Services
```bash
# Start MySQL first
docker-compose up mysql -d

# Start Data Layer
docker-compose up data-layer -d

# Start Backend
docker-compose up backend -d

# Start all services
docker-compose up -d
```

### 2. Build Individual Services
```bash
# Build Data Layer
docker-compose build data-layer

# Build Backend
docker-compose build backend

# Build all services
docker-compose build
```

### 3. View Service Logs
```bash
# Data Layer logs
docker-compose logs data-layer

# Backend logs
docker-compose logs backend

# All logs
docker-compose logs -f
```

## Security Benefits

1. **Database Isolation**: Database credentials never exposed to Backend service
2. **Network Segmentation**: Docker networks enforce service isolation
3. **Controlled Access**: All database operations go through vetted Data Layer APIs
4. **Audit Trail**: Complete request tracing across layers

## Testing the Architecture

### Verify Network Isolation
```bash
# Backend cannot access database directly
docker exec sales_manager_backend ping mysql
# Should fail - no network route

# Data Layer can access database
docker exec sales_manager_data_layer ping mysql
# Should succeed
```

### Test API Flow
```bash
# Test Backend API (Server C)
curl http://localhost:8000/api/v1/users/TNT_123

# Test Data Layer API (Server B)
curl http://localhost:8001/api/users/TNT_123

# Test Mock Client API
curl http://localhost:8002/api/sync?tenant_id=TNT_123
```

## Benefits of This Structure

1. **Clear Separation**: Each service has its own directory and responsibilities
2. **Independent Development**: Teams can work on different layers independently
3. **Easy Deployment**: Each service can be deployed separately
4. **Scalability**: Each layer can be scaled independently
5. **Maintainability**: Clear boundaries make debugging and maintenance easier
6. **Security**: Strict network and access control enforcement
