# Three-Layer Architecture Implementation

This document explains how the three-layer architecture is implemented in the Sales Manager platform.

## Architecture Overview

The system follows a strict three-layer architecture where each layer has specific responsibilities and access patterns:

```
┌─────────────────┐    HTTP/HTTPS    ┌─────────────────┐    gRPC/HTTPS    ┌─────────────────┐
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

## Layer Responsibilities

### Server A: Database Layer (MySQL)
- **Purpose**: Primary data storage
- **Access**: Only accessible from Server B (Data Layer)
- **Network**: Private network, no direct external access
- **Security**: Database credentials only known to Data Layer service

### Server B: Data Layer Service
- **Purpose**: Database access and business logic
- **Access**: Can access Server A (Database), exposes APIs to Server C
- **Network**: Bridge between private database network and backend network
- **Security**: Database credentials, exposes controlled API endpoints

### Server C: Backend API Gateway
- **Purpose**: Public API endpoints, authentication, business logic orchestration
- **Access**: Can only communicate with Server B (Data Layer), never directly with Server A
- **Network**: Public-facing, accessible from Flutter apps
- **Security**: No database credentials, communicates via HTTP with Data Layer

## Implementation Details

### Docker Compose Configuration

The architecture is implemented using Docker networks to enforce the separation:

```yaml
networks:
  database_network:      # Only MySQL and Data Layer
  backend_network:       # Backend, Data Layer, Redis, Mock Client API
```

**Network Isolation:**
- `mysql` service: Only on `database_network`
- `data-layer` service: On both `database_network` and `backend_network`
- `backend` service: Only on `backend_network`
- `redis` service: Only on `backend_network`

### Service Communication

#### Backend → Data Layer
```python
# Backend service (Server C)
from app.services import get_data_layer_client

async def get_users(tenant_id: str):
    data_layer = await get_data_layer_client()
    users = await data_layer.get_users(tenant_id)
    return users
```

#### Data Layer → Database
```python
# Data Layer service (Server B)
from sqlalchemy import create_engine, text

engine = create_engine(DATABASE_URL)
with engine.connect() as conn:
    result = conn.execute(text("SELECT * FROM users WHERE tenant_id = :tenant_id"))
```

### API Endpoints

#### Backend API (Server C)
- **Port**: 8000
- **Endpoints**: `/api/v1/users/*`, `/health`, etc.
- **Purpose**: Public API for Flutter apps

#### Data Layer API (Server B)
- **Port**: 8001
- **Endpoints**: `/api/users/*`, `/api/shops/*`, `/api/analytics/*`, etc.
- **Purpose**: Internal API for Backend service

#### Mock Client API
- **Port**: 8002
- **Endpoints**: `/api/sync`, `/health`
- **Purpose**: Simulates client's finance system

## Security Benefits

### 1. Database Isolation
- Database credentials never exposed to Backend service
- Database only accessible from Data Layer service
- Network-level isolation prevents unauthorized access

### 2. Controlled Data Access
- Backend cannot execute arbitrary SQL queries
- Data Layer enforces tenant isolation and access controls
- All database operations go through vetted API endpoints

### 3. Audit Trail
- Data Layer logs all database operations
- Backend logs all API requests
- Complete request tracing across layers

## Development vs Production

### Development Environment
- All services run on localhost with Docker
- Network isolation simulated with Docker networks
- Mock data and simplified security

### Production Environment
- **Server A**: Dedicated database server in private VPC
- **Server B**: Data Layer service in private subnet
- **Server C**: Backend API Gateway in public subnet
- **Network**: VPC with proper security groups and NACLs
- **Security**: mTLS between Backend and Data Layer

## Testing the Architecture

### 1. Start Services
```bash
docker-compose up -d
```

### 2. Verify Network Isolation
```bash
# Backend cannot access database directly
docker exec sales_manager_backend ping mysql
# Should fail - no network route

# Data Layer can access database
docker exec sales_manager_data_layer ping mysql
# Should succeed
```

### 3. Test API Flow
```bash
# Test Backend API (Server C)
curl http://localhost:8000/api/v1/users/TNT_123

# Test Data Layer API (Server B)
curl http://localhost:8001/api/users/TNT_123

# Test Mock Client API
curl http://localhost:8002/api/sync?tenant_id=TNT_123
```

## Monitoring and Health Checks

### Backend Health Check
```json
{
  "status": "healthy",
  "service": "backend-gateway",
  "data_layer": {
    "status": "healthy",
    "url": "http://data-layer:8000"
  }
}
```

### Data Layer Health Check
```json
{
  "status": "healthy",
  "service": "data-layer",
  "database": "connected"
}
```

## Benefits of This Architecture

1. **Security**: Database completely isolated from public-facing services
2. **Scalability**: Each layer can be scaled independently
3. **Maintainability**: Clear separation of concerns
4. **Compliance**: Meets strict security requirements for client data
5. **Flexibility**: Easy to swap out database or backend implementations

## Future Enhancements

1. **Service Mesh**: Implement Istio or similar for advanced traffic management
2. **Circuit Breakers**: Add resilience patterns for Data Layer communication
3. **Caching**: Implement Redis caching at Backend layer
4. **Load Balancing**: Add load balancers for each layer
5. **Monitoring**: Implement distributed tracing and metrics collection
