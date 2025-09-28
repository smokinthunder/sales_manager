# Sales Manager Platform - Comprehensive Documentation

> **Complete Guide to Understanding the Sales Executive Management Platform**

## Table of Contents

1. [Project Overview](#project-overview)
2. [System Architecture](#system-architecture)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Database Schema & Tables](#database-schema--tables)
6. [API Endpoints](#api-endpoints)
7. [Core Modules & Functionality](#core-modules--functionality)
8. [Three-Layer Architecture Implementation](#three-layer-architecture-implementation)
9. [Security & Authentication](#security--authentication)
10. [Multi-Tenancy](#multi-tenancy)
11. [Development & Deployment](#development--deployment)
12. [Frontend Architecture](#frontend-architecture)
13. [Testing Strategy](#testing-strategy)
14. [Getting Started](#getting-started)

---

## Project Overview

The **Sales Manager Platform** is a comprehensive multi-tenant solution designed to manage sales executives, territories, routes, and shop visits. It follows a three-layer architecture with strict separation of concerns and implements industry-standard security practices.

### Key Features
- **Multi-tenant Architecture**: Complete tenant isolation with secure data separation
- **Role-based Access Control**: Superadmin, Client-admin, Area Manager, Sales Executive
- **Territory Management**: Hierarchical territory assignment and management
- **Route Planning**: Advanced route planning with shop assignments
- **Visit Tracking**: GPS-enabled check-in/check-out with offline support
- **Analytics Dashboard**: Real-time analytics and performance metrics
- **Finance Integration**: Read-only integration with client finance systems
- **OTP Authentication**: Phone-based authentication with SMS integration

### Business Roles
- **SUPERADMIN**: Platform owner managing all client tenants
- **CLIENT-ADMIN**: Manages area managers and sales executives
- **AREA MANAGER**: Manages territories, routes, and team performance
- **SALES EXECUTIVE**: Visits shops, records check-ins, and tracks performance

---

## System Architecture

The system implements a **Three-Layer Architecture** for maximum security and scalability:

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

### Layer Responsibilities

#### Server A: Database Layer (MySQL)
- **Purpose**: Primary data storage
- **Access**: Only accessible from Server B (Data Layer)
- **Security**: Complete network isolation, no direct external access

#### Server B: Data Layer Service
- **Purpose**: Database access and business logic
- **Technology**: FastAPI (Python)
- **Port**: 8001 (external), 8000 (internal)
- **Networks**: Both database_network and backend_network

#### Server C: Backend API Gateway
- **Purpose**: Public API endpoints, authentication, request routing
- **Technology**: FastAPI (Python)
- **Port**: 8000
- **Networks**: backend_network only

---

## Technology Stack

### Backend
- **Framework**: FastAPI (Python 3.11)
- **Database**: MySQL 8.0
- **Cache**: Redis 7
- **ORM**: SQLAlchemy with SQLModel
- **Authentication**: JWT tokens
- **API Documentation**: Swagger/OpenAPI
- **Container**: Docker & Docker Compose

### Frontend
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Architecture**: MVVM + Clean Architecture
- **Routing**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Offline Support**: Hive/SQLite

### Infrastructure
- **Container Orchestration**: Docker Compose
- **Reverse Proxy**: Nginx (production)
- **Load Balancer**: Application Load Balancer
- **Monitoring**: Prometheus & Grafana
- **Logging**: ELK Stack

---

## Project Structure

```
sales_manager/
├── backend/                           # Server C: Backend API Gateway
│   ├── app/
│   │   ├── api/                      # API endpoints
│   │   │   └── v1/
│   │   │       ├── auth.py           # Authentication endpoints
│   │   │       ├── users.py          # User management endpoints
│   │   │       ├── territories.py    # Territory management endpoints
│   │   │       ├── routes.py         # Route planning endpoints
│   │   │       ├── shops.py          # Shop management endpoints
│   │   │       ├── analytics.py      # Analytics endpoints
│   │   │       ├── sync.py           # Data synchronization endpoints
│   │   │       └── outstanding.py    # Outstanding payments endpoints
│   │   ├── core/                     # Core configuration
│   │   │   ├── config.py            # Application configuration
│   │   │   ├── security.py          # Security utilities
│   │   │   ├── errors.py            # Custom error classes
│   │   │   └── logging.py           # Logging configuration
│   │   ├── domain/                   # Domain models
│   │   │   └── models/
│   │   │       ├── user.py          # User domain models
│   │   │       ├── territory.py     # Territory domain models
│   │   │       ├── route.py         # Route domain models
│   │   │       ├── shop.py          # Shop domain models
│   │   │       └── visit.py         # Visit domain models
│   │   └── services/                 # Service layer
│   │       └── data_layer_client.py  # Data Layer communication client
│   ├── tests/                        # Backend tests
│   ├── alembic/                      # Database migrations
│   └── requirements.txt              # Python dependencies
│
├── data-layer/                       # Server B: Data Layer Service
│   ├── app/
│   │   └── main.py                  # Data Layer FastAPI application
│   ├── requirements.txt             # Data Layer dependencies
│   └── Dockerfile                   # Data Layer container
│
├── frontend/                         # Flutter Mobile/Web Application
│   ├── lib/
│   │   ├── config/                  # App configuration
│   │   │   └── dependencies.dart    # Dependency injection
│   │   ├── data/                    # Data layer
│   │   │   └── repositories/        # Repository implementations
│   │   ├── domain/                  # Domain layer
│   │   │   ├── entities/           # Business entities
│   │   │   └── usecases/           # Business use cases
│   │   ├── ui/                      # Presentation layer
│   │   │   ├── auth/               # Authentication screens
│   │   │   ├── dashboard/          # Dashboard screens
│   │   │   ├── routes/             # Route management screens
│   │   │   ├── shops/              # Shop management screens
│   │   │   └── analytics/          # Analytics screens
│   │   ├── routing/                 # App routing
│   │   └── utils/                   # Utility functions
│   ├── assets/                      # Static assets
│   └── pubspec.yaml                 # Flutter dependencies
│
├── mock_client_api/                  # Mock Client Finance System
│   └── main.py                      # Mock API endpoints
│
├── docker-compose.yml               # Service orchestration
├── SYSTEM_ARCHITECTURE.md           # System architecture documentation
├── THREE_LAYER_ARCHITECTURE.md      # Three-layer implementation details
├── PROJECT_STRUCTURE.md             # Project structure overview
└── COMPREHENSIVE_PROJECT_DOCUMENTATION.md  # This file
```

---

## Database Schema & Tables

### Core Business Tables

#### Users Table
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    role ENUM('superadmin', 'client_admin', 'area_manager', 'sales_executive') NOT NULL,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    tenant_id VARCHAR(50) NOT NULL,
    territory_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_phone (tenant_id, phone),
    INDEX idx_role_status (role, status),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);
```

#### Territories Table
```sql
CREATE TABLE territories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    territory_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL,
    description TEXT,
    area_manager_id INT,
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    UNIQUE KEY uk_tenant_territory (tenant_id, territory_id),
    UNIQUE KEY uk_tenant_code (tenant_id, code),
    INDEX idx_area_manager (area_manager_id),
    FOREIGN KEY (area_manager_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);
```

#### Shops Table
```sql
CREATE TABLE shops (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shop_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20),
    status ENUM('active', 'inactive') DEFAULT 'active',
    address TEXT,
    phone VARCHAR(20),
    contact_person VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    territory_id VARCHAR(50),
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    UNIQUE KEY uk_tenant_shop (tenant_id, shop_id),
    INDEX idx_territory (territory_id),
    INDEX idx_location (latitude, longitude),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);
```

#### Routes Table
```sql
CREATE TABLE routes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    route_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    territory_id VARCHAR(50) NOT NULL,
    week_start_date DATE NOT NULL,
    status ENUM('planned', 'active', 'completed', 'cancelled') DEFAULT 'planned',
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    UNIQUE KEY uk_tenant_route (tenant_id, route_id),
    INDEX idx_territory_week (territory_id, week_start_date),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);
```

#### Route Assignments Table
```sql
CREATE TABLE route_assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    route_id INT NOT NULL,
    shop_id VARCHAR(50) NOT NULL,
    sales_executive_id INT NOT NULL,
    planned_date DATE NOT NULL,
    planned_time TIME,
    sequence_order INT,
    status ENUM('planned', 'completed', 'skipped') DEFAULT 'planned',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_route_date (route_id, planned_date),
    INDEX idx_executive_date (sales_executive_id, planned_date),
    FOREIGN KEY (route_id) REFERENCES routes(id) ON DELETE CASCADE,
    FOREIGN KEY (sales_executive_id) REFERENCES users(id)
);
```

#### Visits Table
```sql
CREATE TABLE visits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    visit_id VARCHAR(50) NOT NULL,
    shop_id VARCHAR(50) NOT NULL,
    executive_id VARCHAR(10) NOT NULL,
    route_id VARCHAR(50),
    checkin_time TIMESTAMP NOT NULL,
    checkout_time TIMESTAMP,
    location_lat DECIMAL(10, 8) NOT NULL,
    location_lng DECIMAL(11, 8) NOT NULL,
    remarks TEXT,
    status ENUM('checked_in', 'checked_out', 'incomplete') DEFAULT 'checked_in',
    tenant_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_executive_date (executive_id, checkin_time),
    INDEX idx_route (route_id)
);
```

### Financial Integration Tables

#### Outstanding/Due Data Table
```sql
CREATE TABLE due_data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shop_id VARCHAR(50) NOT NULL,
    shop_name VARCHAR(100) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('current', 'upcoming', 'overdue') NOT NULL,
    sales_executive_id INT,
    territory_id VARCHAR(50),
    tenant_id VARCHAR(50) NOT NULL,
    original_amount DECIMAL(15, 2),
    days_overdue INT DEFAULT 0,
    last_payment_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_status_amount (status, amount),
    INDEX idx_due_date (due_date),
    FOREIGN KEY (sales_executive_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
);
```

#### Orders Table (Read-only from Client API)
```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    shop_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    order_amount DECIMAL(15, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'delivered', 'cancelled') DEFAULT 'pending',
    tenant_id VARCHAR(50) NOT NULL,
    sync_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tenant_shop (tenant_id, shop_id),
    INDEX idx_order_date (order_date),
    UNIQUE KEY uk_tenant_order (tenant_id, order_id)
);
```

#### Order Lines Table
```sql
CREATE TABLE order_lines (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_amount DECIMAL(15, 2) NOT NULL,
    quantity INT DEFAULT 1,
    unit_price DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_order (order_id)
);
```

---

## API Endpoints

### Authentication Endpoints (`/api/v1/auth`)

#### Request Authentication Code
```http
POST /api/v1/auth/request-code?phone=+919876543210&tenant_id=example_tenant&device_id=device123
```

**Query Parameters:**
- `phone` (string, required): Phone number with country code
- `tenant_id` (string, required): Tenant identifier
- `device_id` (string, optional): Device identifier for security

**Request Body:** None

**Response:**
```json
{
  "message": "OTP sent successfully"
}
```

#### Verify Authentication Code
```http
POST /api/v1/auth/verify-code?phone=+919876543210&tenant_id=example_tenant&otp=123456&device_id=device123
```

**Query Parameters:**
- `phone` (string, required): Phone number with country code
- `tenant_id` (string, required): Tenant identifier
- `otp` (string, required): OTP code received via SMS
- `device_id` (string, optional): Device identifier for security

**Request Body:** None

**Response:**
```json
{
  "access_token": "jwt-token-here",
  "token_type": "bearer",
  "expires_in": 3600,
  "user": {
    "id": 1,
    "phone": "+919876543210",
    "full_name": "John Doe",
    "role": "sales_executive",
    "tenant_id": "example_tenant",
    "territory_id": "TERR001",
    "is_active": true,
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### User Management Endpoints (`/api/v1/users`)

#### Get Current User Profile
```http
GET /api/v1/users/me?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Response:**
```json
{
  "id": 1,
  "phone": "+919876543210",
  "full_name": "John Doe",
  "email": "john@example.com",
  "role": "sales_executive",
  "tenant_id": "example_tenant",
  "territory_id": "TERR001",
  "is_active": true,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

#### Create New User
```http
POST /api/v1/users?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "phone": "+918888888888",
  "full_name": "Jane Smith",
  "email": "jane@example.com",
  "role": "sales_executive",
  "territory_id": "TERR002"
}
```

**Response:**
```json
{
  "id": 2,
  "phone": "+918888888888",
  "full_name": "Jane Smith",
  "email": "jane@example.com",
  "role": "sales_executive",
  "tenant_id": "example_tenant",
  "territory_id": "TERR002",
  "is_active": true,
  "created_at": "2024-01-16T09:00:00Z",
  "updated_at": "2024-01-16T09:00:00Z"
}
```

#### Get All Users
```http
GET /api/v1/users?tenant_id=example_tenant&role=sales_executive&territory_id=TERR001
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `role` (string, optional): Filter by user role
- `territory_id` (string, optional): Filter by territory ID

**Response:**
```json
[
  {
    "id": 1,
    "phone": "+919876543210",
    "full_name": "John Doe",
    "email": "john@example.com",
    "role": "sales_executive",
    "tenant_id": "example_tenant",
    "territory_id": "TERR001",
    "is_active": true,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
]
```

#### Update User
```http
PUT /api/v1/users/2?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Path Parameters:**
- `user_id` (integer, required): User ID to update

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "full_name": "Jane Doe Smith",
  "role": "area_manager",
  "territory_id": "TERR003"
}
```

**Response:**
```json
{
  "id": 2,
  "phone": "+918888888888",
  "full_name": "Jane Doe Smith",
  "email": "jane@example.com",
  "role": "area_manager",
  "tenant_id": "example_tenant",
  "territory_id": "TERR003",
  "is_active": true,
  "created_at": "2024-01-16T09:00:00Z",
  "updated_at": "2024-01-16T11:30:00Z"
}
```
```

#### Delete User
```http
DELETE /api/v1/users/{tenant_id}/{user_id}
Authorization: Bearer <jwt-token>

Path Parameters:
- tenant_id: TNT_123
- user_id: 2

Response:
{
  "message": "User deleted successfully",
  "user_id": 2,
  "deleted_at": "2025-09-28T11:30:00Z"
}
```

### Territory Management Endpoints (`/api/v1/territories`)

#### Create Territory
```http
POST /api/v1/territories?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "territory_id": "TERR003",
  "name": "Ernakulam District",
  "code": "EKM",
  "description": "Ernakulam district territory including Kochi metro",
  "area_manager_id": 3
}
```

**Response:**
```json
{
  "id": 1,
  "territory_id": "TERR003",
  "name": "Ernakulam District",
  "code": "EKM",
  "description": "Ernakulam district territory including Kochi metro",
  "area_manager_id": 3,
  "tenant_id": "example_tenant",
  "created_at": "2024-01-16T10:00:00Z",
  "updated_at": "2024-01-16T10:00:00Z"
}
```

#### Get All Territories
```http
GET /api/v1/territories?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Response:**
```json
[
  {
    "id": 1,
    "territory_id": "TERR003",
    "name": "Ernakulam District",
    "code": "EKM",
    "description": "Ernakulam district territory including Kochi metro",
    "area_manager_id": 3,
    "tenant_id": "example_tenant",
    "created_at": "2024-01-16T10:00:00Z",
    "updated_at": "2024-01-16T10:00:00Z"
  }
]
```

#### Get Territory by ID
```http
GET /api/v1/territories/TERR003?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
```

**Path Parameters:**
- `territory_id` (string, required): Territory identifier

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Response:**
```json
{
  "id": 1,
  "territory_id": "TERR003",
  "name": "Ernakulam District",
  "code": "EKM",
  "description": "Ernakulam district territory including Kochi metro",
  "area_manager_id": 3,
  "tenant_id": "example_tenant",
  "created_at": "2024-01-16T10:00:00Z",
  "updated_at": "2024-01-16T10:00:00Z"
}
```
```http
GET /api/v1/territories/{tenant_id}
Authorization: Bearer <jwt-token>

Path Parameters:
- tenant_id: TNT_123

Query Parameters:
- area_manager_id (optional): 3
- status (optional): active

Example: GET /api/v1/territories/TNT_123?area_manager_id=3

Response:
[
  {
    "id": 1,
    "territory_id": "KL-EKM-001",
    "name": "Ernakulam District",
    "code": "EKM",
    "description": "Ernakulam district territory including Kochi metro",
    "area_manager_id": 3,
    "tenant_id": "TNT_123",
    "created_at": "2025-09-28T10:00:00Z",
    "updated_at": "2025-09-28T10:00:00Z"
  }
]
```

### Shop Management Endpoints (`/api/v1/shops`)

#### Create Shop
```http
POST /api/v1/shops?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "shop_id": "SHOP001",
  "shop_name": "Metro Store Kochi",
  "address": "MG Road, Kochi, Kerala 682016",
  "phone": "+910484-1234567",
  "contact_person": "Rajesh Kumar",
  "latitude": 9.9674,
  "longitude": 76.2458,
  "territory_id": "TERR001",
  "sales_executive_id": 5
}
```

**Response:**
```json
{
  "id": 1,
  "shop_id": "SHOP001",
  "shop_name": "Metro Store Kochi",
  "address": "MG Road, Kochi, Kerala 682016",
  "phone": "+910484-1234567",
  "contact_person": "Rajesh Kumar",
  "latitude": 9.9674,
  "longitude": 76.2458,
  "territory_id": "TERR001",
  "sales_executive_id": 5,
  "tenant_id": "example_tenant",
  "is_active": true,
  "created_at": "2024-01-16T10:00:00Z",
  "updated_at": "2024-01-16T10:00:00Z"
}
```

#### Get All Shops
```http
GET /api/v1/shops?tenant_id=example_tenant&territory_id=TERR001&sales_executive_id=5
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `territory_id` (string, optional): Filter by territory
- `sales_executive_id` (integer, optional): Filter by sales executive
- `shop_search` (string, optional): Search by shop name
- `is_active` (boolean, optional): Filter by active status

**Response:**
```json
[
  {
    "id": 1,
    "shop_id": "SHOP001",
    "shop_name": "Metro Store Kochi",
    "address": "MG Road, Kochi, Kerala 682016",
    "phone": "+910484-1234567",
    "contact_person": "Rajesh Kumar",
    "latitude": 9.9674,
    "longitude": 76.2458,
    "territory_id": "TERR001",
    "sales_executive_id": 5,
    "tenant_id": "example_tenant",
    "is_active": true,
    "created_at": "2024-01-16T10:00:00Z",
    "updated_at": "2024-01-16T10:00:00Z"
  }
]
```

### Route Management Endpoints (`/api/v1/routes`)

#### Create Route
```http
POST /api/v1/routes?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "route_name": "Downtown Route A",
  "territory_id": "TERR001",
  "sales_executive_id": 5,
  "shop_ids": ["SHOP001", "SHOP002", "SHOP003"],
  "expected_duration_hours": 6,
  "route_type": "daily",
  "week_start_date": "2024-10-01"
}
```

**Response:**
```json
{
  "id": 1,
  "route_id": "ROUTE001",
  "route_name": "Downtown Route A",
  "territory_id": "TERR001",
  "sales_executive_id": 5,
  "expected_duration_hours": 6,
  "route_type": "daily",
  "week_start_date": "2024-10-01",
  "status": "planned",
  "tenant_id": "example_tenant",
  "created_at": "2024-01-16T10:00:00Z",
  "updated_at": "2024-01-16T10:00:00Z"
}
```

#### Get All Routes
```http
GET /api/v1/routes?tenant_id=example_tenant&territory_id=TERR001&sales_executive_id=5
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `territory_id` (string, optional): Filter by territory
- `sales_executive_id` (integer, optional): Filter by sales executive
- `status` (string, optional): Filter by route status

#### Get All Route Assignments
```http
GET /api/v1/routes/assignments?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
```

**Access Control:**
- Sales executives can only retrieve routes assigned to them (filtered automatically)
- Area managers, client admins, and superadmins can retrieve all assignments

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `sales_executive_id` (integer, optional): Filter by sales executive ID
- `territory_id` (string, optional): Filter by territory ID
- `route_id` (string, optional): Filter by route ID
- `shop_id` (string, optional): Filter by shop ID
- `planned_date_from` (string, optional): Filter by planned date from (YYYY-MM-DD)
- `planned_date_to` (string, optional): Filter by planned date to (YYYY-MM-DD)
- `assignment_status` (string, optional): Filter by assignment status (planned, completed, skipped)

**Response:**
```json
[
  {
    "id": 2,
    "route_id": "RT-001",
    "shop_id": "SHOP-TRV-001",
    "sales_executive_id": 5,
    "planned_date": "2025-09-28",
    "planned_time": "10:00:00",
    "sequence_order": 1,
    "status": "planned",
    "created_at": "2025-09-27T17:45:41",
    "updated_at": "2025-09-27T17:45:41"
  },
  {
    "id": 3,
    "route_id": "RT-002",
    "shop_id": "SHOP-TRV-002", 
    "sales_executive_id": 5,
    "planned_date": "2025-09-28",
    "planned_time": "14:00:00",
    "sequence_order": 1,
    "status": "planned",
    "created_at": "2025-09-27T17:46:13",
    "updated_at": "2025-09-27T17:46:13"
  }
]
```

**Key Features:**
- **Role-based Filtering**: Sales executives automatically see only their assignments
- **Comprehensive Filtering**: Support for multiple filter criteria
- **Real-time Data**: Returns up-to-date assignment information
- **Security**: Tenant isolation and authentication required

### Outstanding Management Endpoints (`/api/v1/outstanding`)

#### Create Outstanding Payment Record
```http
POST /api/v1/outstanding?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "shop_id": "SHOP001",
  "shop_name": "ABC Electronics Store",
  "amount": 15000.00,
  "due_date": "2024-02-15",
  "sales_executive_id": 5,
  "territory_id": "TERR001",
  "original_amount": 15000.00,
  "last_payment_date": "2024-01-15",
  "notes": "Payment due for January orders"
}
```

**Response:**
```json
{
  "id": 456,
  "shop_id": "SHOP001",
  "shop_name": "ABC Electronics Store",
  "amount": 15000.00,
  "due_date": "2024-02-15",
  "status": "upcoming",
  "sales_executive_id": 5,
  "territory_id": "TERR001",
  "tenant_id": "example_tenant",
  "days_overdue": null,
  "original_amount": 15000.00,
  "last_payment_date": "2024-01-15",
  "notes": "Payment due for January orders",
  "created_at": "2024-01-16T10:30:00Z",
  "updated_at": "2024-01-16T10:30:00Z",
  "created_by": 7,
  "updated_by": 7
}
```

#### Get Outstanding Payments with Filters
```http
GET /api/v1/outstanding?tenant_id=example_tenant&status=overdue&territory_id=TERR001&min_amount=5000
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `sales_executive_id` (integer, optional): Filter by sales executive
- `territory_id` (string, optional): Filter by territory
- `status` (string, optional): Filter by status (current, upcoming, overdue)
- `start_date` (date, optional): Filter by start date
- `end_date` (date, optional): Filter by end date
- `shop_search` (string, optional): Search by shop name
- `min_amount` (float, optional): Minimum amount filter
- `max_amount` (float, optional): Maximum amount filter

**Response:**
```json
[
  {
    "id": 456,
    "shop_id": "SHOP001",
    "shop_name": "ABC Electronics Store",
    "amount": 15000.00,
    "due_date": "2024-02-15",
    "status": "overdue",
    "sales_executive_id": 5,
    "territory_id": "TERR001",
    "tenant_id": "example_tenant",
    "days_overdue": 5,
    "created_at": "2024-01-16T10:30:00Z"
  }
]
```

### Analytics Endpoints (`/api/v1/analytics`)

#### Get Sales Summary
```http
GET /api/v1/analytics/sales-summary?tenant_id=example_tenant&start_date=2024-01-01&end_date=2024-01-31&territory_id=TERR001
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `start_date` (date, optional): Start date for analysis
- `end_date` (date, optional): End date for analysis
- `territory_id` (string, optional): Filter by territory
- `sales_executive_id` (integer, optional): Filter by sales executive

**Response:**
```json
{
  "total_sales": 125000.00,
  "total_orders": 45,
  "average_order_value": 2777.78,
  "territory_breakdown": [
    {
      "territory_id": "TERR001",
      "territory_name": "Downtown",
      "sales": 75000.00,
      "orders": 27
    }
  ],
  "sales_executive_performance": [
    {
      "executive_id": 5,
      "executive_name": "John Doe",
      "sales": 50000.00,
      "orders": 18
    }
  ],
  "period": {
    "start_date": "2024-01-01",
    "end_date": "2024-01-31"
  }
}
```

#### Get Outstanding Summary
```http
GET /api/v1/analytics/outstanding-summary?tenant_id=example_tenant&territory_id=TERR001
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier
- `territory_id` (string, optional): Filter by territory
- `sales_executive_id` (integer, optional): Filter by sales executive

**Response:**
```json
{
  "total_outstanding": 250000.00,
  "current_outstanding": 100000.00,
  "upcoming_outstanding": 75000.00,
  "overdue_outstanding": 75000.00,
  "outstanding_by_status": {
    "current": {
      "amount": 100000.00,
      "count": 15
    },
    "upcoming": {
      "amount": 75000.00,
      "count": 10
    },
    "overdue": {
      "amount": 75000.00,
      "count": 8
    }
  },
  "territory_breakdown": [
    {
      "territory_id": "TERR001",
      "territory_name": "Downtown",
      "outstanding": 150000.00
    }
  ]
}
```

### Data Synchronization Endpoints (`/api/v1/sync`)

#### Sync Client Data
```http
POST /api/v1/sync/client-data?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
Content-Type: application/json
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Request Body:**
```json
{
  "client_api_url": "https://client.example.com/api",
  "force_sync": false
}
```

**Response:**
```json
{
  "status": "success",
  "message": "Data synchronized successfully",
  "shops_processed": 25,
  "orders_processed": 150,
  "products_processed": 500,
  "sync_timestamp": "2024-01-16T12:00:00Z"
}
```

#### Get Sync Status
```http
GET /api/v1/sync/status?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Response:**
```json
{
  "status": "completed",
  "message": "Last sync completed successfully",
  "last_sync_date": "2024-01-16T12:00:00Z",
  "shops_count": 25,
  "orders_count": 150,
  "products_count": 500
}
```

#### Get Payment Summary
```http
GET /api/v1/sync/payment-summary?tenant_id=example_tenant
Authorization: Bearer <jwt-token>
```

**Query Parameters:**
- `tenant_id` (string, required): Tenant identifier

**Response:**
```json
{
  "total_current_payment": 100000.00,
  "total_upcoming_payment": 75000.00,
  "total_overdue_payment": 75000.00,
  "total_payment": 250000.00,
  "shops_count": 25,
  "summary_date": "2024-01-16T12:00:00Z"
}
```
  "route_id": "RT-KOC-001",
  "shop_id": "SHOP-KOC-005",
  "sales_executive_id": 2,
  "planned_date": "2025-10-01",
  "planned_time": "10:00:00",
  "sequence_order": 1,
  "status": "planned",
  "created_at": "2025-09-28T10:00:00Z",
  "updated_at": "2025-09-28T10:00:00Z"
}
```

### Visit Management Endpoints (`/api/v1/visits`)

#### Create Visit (Check-in)
```http
POST /api/v1/visits/{tenant_id}
Authorization: Bearer <jwt-token>
Content-Type: application/json

Path Parameters:
- tenant_id: TNT_123

Request Body:
{
  "shop_id": "SHOP-KOC-005",
  "executive_id": "2",
  "route_id": "RT-KOC-001",
  "location_lat": 9.9674,
  "location_lng": 76.2458,
  "remarks": "Started shop visit"
}

Response:
{
  "id": 1,
  "visit_id": "VISIT-001",
  "shop_id": "SHOP-KOC-005",
  "executive_id": "2",
  "route_id": "RT-KOC-001",
  "checkin_time": "2025-09-28T10:30:00Z",
  "checkout_time": null,
  "location_lat": 9.9674,
  "location_lng": 76.2458,
  "remarks": "Started shop visit",
  "status": "checked_in",
  "tenant_id": "TNT_123",
  "created_at": "2025-09-28T10:30:00Z",
  "updated_at": "2025-09-28T10:30:00Z"
}
```

#### Update Visit (Check-out)
```http
PUT /api/v1/visits/{tenant_id}/{visit_id}
Authorization: Bearer <jwt-token>
Content-Type: application/json

Path Parameters:
- tenant_id: TNT_123
- visit_id: VISIT-001

Request Body:
{
  "checkout_time": "2025-09-28T11:15:00Z",
  "remarks": "Completed shop visit. Discussed new products.",
  "status": "checked_out"
}

Response:
{
  "id": 1,
  "visit_id": "VISIT-001",
  "shop_id": "SHOP-KOC-005",
  "executive_id": "2",
  "route_id": "RT-KOC-001",
  "checkin_time": "2025-09-28T10:30:00Z",
  "checkout_time": "2025-09-28T11:15:00Z",
  "location_lat": 9.9674,
  "location_lng": 76.2458,
  "remarks": "Completed shop visit. Discussed new products.",
  "status": "checked_out",
  "tenant_id": "TNT_123",
  "updated_at": "2025-09-28T11:15:00Z"
}
```

#### Get Visits
```http
GET /api/v1/visits/{tenant_id}
Authorization: Bearer <jwt-token>

Path Parameters:
- tenant_id: TNT_123

Query Parameters:
- shop_id (optional): SHOP-KOC-005
- executive_id (optional): 2
- route_id (optional): RT-KOC-001
- date_from (optional): 2025-09-01
- date_to (optional): 2025-09-30
- status (optional): checked_out
- limit (optional): 50
- offset (optional): 0

Example: GET /api/v1/visits/TNT_123?shop_id=SHOP-KOC-005&date_from=2025-09-01

Response:
[
  {
    "id": 1,
    "visit_id": "VISIT-001",
    "shop_id": "SHOP-KOC-005",
    "executive_id": "2",
    "route_id": "RT-KOC-001",
    "checkin_time": "2025-09-28T10:30:00Z",
    "checkout_time": "2025-09-28T11:15:00Z",
    "location_lat": 9.9674,
    "location_lng": 76.2458,
    "remarks": "Completed shop visit. Discussed new products.",
    "status": "checked_out",
    "tenant_id": "TNT_123",
    "created_at": "2025-09-28T10:30:00Z",
    "updated_at": "2025-09-28T11:15:00Z"
  }
]
```

### Outstanding Management Endpoints (`/api/v1/outstanding`)

#### Get Outstanding Data
```http
GET /api/v1/outstanding/{tenant_id}
Authorization: Bearer <jwt-token>

Path Parameters:
- tenant_id: TNT_123

Query Parameters:
- status (optional): overdue
- territory_id (optional): KL-EKM-001
- sales_executive_id (optional): 2
- start_date (optional): 2025-09-01
- end_date (optional): 2025-09-30
- min_amount (optional): 1000.00
- max_amount (optional): 50000.00
- shop_search (optional): "Metro Store"

Example: GET /api/v1/outstanding/TNT_123?status=overdue&territory_id=KL-EKM-001

Response:
[
  {
    "id": 1,
    "shop_id": "SHOP-KOC-005",
    "shop_name": "Metro Store Kochi",
    "amount": 15000.00,
    "due_date": "2025-09-15",
    "status": "overdue",
    "sales_executive_id": 2,
    "territory_id": "KL-EKM-001",
    "tenant_id": "TNT_123",
    "days_overdue": 13,
    "original_amount": 15000.00,
    "notes": "Follow up required",
    "created_at": "2025-09-28T10:00:00Z",
    "updated_at": "2025-09-28T10:00:00Z"
  }
]
```

#### Create Outstanding Record
```http
POST /api/v1/outstanding/{tenant_id}
Authorization: Bearer <jwt-token>
Content-Type: application/json

Path Parameters:
- tenant_id: TNT_123

Request Body:
{
  "shop_id": "SHOP-KOC-005",
  "shop_name": "Metro Store Kochi",
  "amount": 15000.00,
  "due_date": "2025-10-15",
  "status": "upcoming",
  "sales_executive_id": 2,
  "territory_id": "KL-EKM-001",
  "notes": "October payment due"
}

Response:
{
  "id": 2,
  "shop_id": "SHOP-KOC-005",
  "shop_name": "Metro Store Kochi",
  "amount": 15000.00,
  "due_date": "2025-10-15",
  "status": "upcoming",
  "sales_executive_id": 2,
  "territory_id": "KL-EKM-001",
  "tenant_id": "TNT_123",
  "notes": "October payment due",
  "created_at": "2025-09-28T10:00:00Z",
  "updated_at": "2025-09-28T10:00:00Z"
}
```

### Analytics Endpoints (`/api/v1/analytics`)

#### Get Shop Performance Analytics
```http
GET /api/v1/analytics/shop-performance/{tenant_id}
Authorization: Bearer <jwt-token>

Path Parameters:
- tenant_id: TNT_123

Query Parameters:
- territory_id (optional): KL-EKM-001
- sales_executive_id (optional): 2
- date_from (optional): 2025-09-01
- date_to (optional): 2025-09-30
- limit (optional): 50
- offset (optional): 0

Example: GET /api/v1/analytics/shop-performance/TNT_123?territory_id=KL-EKM-001

Response:
[
  {
    "shop_id": "SHOP-KOC-005",
    "shop_name": "Metro Store Kochi",
    "total_visits": 12,
    "last_visit_date": "2025-09-25",
    "outstanding_amount": 15000.00,
    "days_overdue": 13,
    "monthly_sales": 45000.00
  }
]
```

### Sync Endpoints (`/api/v1/sync`)

#### Sync Client Data
```http
POST /api/v1/sync/client-data
Authorization: Bearer <jwt-token>
Content-Type: application/json

Request Body:
{
  "tenant_id": "TNT_123",
  "sync_data": {
    "orders": [
      {
        "order_id": "ORD-001",
        "shop_id": "SHOP-KOC-005",
        "order_date": "2025-09-25",
        "order_amount": 15000.00,
        "status": "delivered"
      }
    ],
    "products": [
      {
        "product_name": "Coca Cola 500ml",
        "product_amount": 25.00
      }
    ],
    "payments": [
      {
        "payment_id": "PAY-001",
        "shop_id": "SHOP-KOC-005",
        "amount": 10000.00,
        "payment_date": "2025-09-20"
      }
    ]
  }
}

Response:
{
  "status": "success",
  "message": "Data sync completed",
  "records_processed": 150,
  "sync_timestamp": "2025-09-28T10:00:00Z"
}
```

---

## Core Modules & Functionality

### 1. Authentication & Authorization Module

#### Features
- **OTP-based Authentication**: Phone number + OTP verification
- **JWT Token Management**: Secure token generation and validation
- **Role-based Access Control**: Granular permissions per role
- **Multi-tenant Security**: Tenant isolation in all operations

#### Key Components
- `AuthService`: Handles OTP generation and verification
- `SecurityService`: JWT token management
- `PermissionService`: Role-based access control

### 2. User Management Module

#### Features
- **User CRUD Operations**: Create, read, update, delete users
- **Role Assignment**: Assign roles with territory restrictions
- **Status Management**: Active, inactive, pending status handling
- **Territory Association**: Link users to specific territories

#### Key Components
- `UserService`: Business logic for user operations
- `UserRepository`: Data access layer for users
- `UserValidator`: Input validation and business rules

### 3. Territory Management Module

#### Features
- **Hierarchical Territory Structure**: Nested territory organization
- **Area Manager Assignment**: Assign area managers to territories
- **Geographic Boundaries**: GPS coordinates and boundary definition
- **Territory Analytics**: Performance metrics per territory

#### Key Components
- `TerritoryService`: Territory business logic
- `TerritoryRepository`: Territory data operations
- `GeographicService`: Location-based calculations

### 4. Shop Management Module

#### Features
- **Shop Registration**: Register shops with location data
- **Contact Information**: Store contact persons and details
- **Territory Assignment**: Associate shops with territories
- **Status Tracking**: Active/inactive shop status management

#### Key Components
- `ShopService`: Shop business logic
- `ShopRepository`: Shop data operations
- `LocationService`: GPS and mapping functionality

### 5. Route Planning Module

#### Features
- **Weekly Route Planning**: Plan routes for sales executives
- **Shop Assignment**: Assign shops to specific routes
- **Schedule Management**: Time-based visit scheduling
- **Route Optimization**: Suggest optimal visit sequences

#### Key Components
- `RouteService`: Route planning business logic
- `RouteAssignmentService`: Shop-to-route assignment logic
- `OptimizationService`: Route optimization algorithms

### 6. Visit Tracking Module

#### Features
- **GPS Check-in/Check-out**: Location-verified visit tracking
- **Visit Duration Tracking**: Calculate time spent at each shop
- **Offline Support**: Queue visits when offline
- **Photo Attachments**: Upload visit photos and documents

#### Key Components
- `VisitService`: Visit tracking business logic
- `LocationService`: GPS verification and tracking
- `OfflineService`: Offline data synchronization

### 7. Analytics & Reporting Module

#### Features
- **Performance Dashboards**: Real-time performance metrics
- **Sales Analytics**: Sales performance by executive/territory
- **Visit Analytics**: Visit frequency and pattern analysis
- **Outstanding Reports**: Payment due and overdue analysis

#### Key Components
- `AnalyticsService`: Analytics calculation and aggregation
- `ReportingService`: Report generation and formatting
- `MetricsService`: Performance metrics calculation

### 8. Financial Integration Module

#### Features
- **Client API Integration**: Sync with client finance systems
- **Outstanding Management**: Track and manage dues
- **Payment Status Tracking**: Monitor payment statuses
- **30-day Payment Policy**: Automated due date calculations

#### Key Components
- `SyncService`: External API integration and data sync
- `FinanceService`: Financial calculations and tracking
- `PaymentPolicyService`: Payment policy enforcement

---

## Three-Layer Architecture Implementation

### Network Isolation

The system enforces strict network isolation through Docker networks:

```yaml
networks:
  database_network:      # Only MySQL and Data Layer
    name: sales_manager_database_network
    driver: bridge
  backend_network:       # Backend, Data Layer, Redis, Mock Client API
    name: sales_manager_backend_network
    driver: bridge
```

### Service Communication

#### Backend → Data Layer
```python
class DataLayerClient:
    def __init__(self, base_url: str):
        self.base_url = base_url
        self.session = httpx.AsyncClient()
    
    async def get_users(self, tenant_id: str) -> List[Dict[str, Any]]:
        response = await self.session.get(f"{self.base_url}/api/users/{tenant_id}")
        return response.json()
    
    async def create_user(self, tenant_id: str, user_data: Dict[str, Any]) -> Dict[str, Any]:
        response = await self.session.post(
            f"{self.base_url}/api/users/{tenant_id}", 
            json=user_data
        )
        return response.json()
```

#### Data Layer → Database
```python
# Direct database access only in Data Layer
engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

async def get_users(tenant_id: str, db: Session) -> List[UserResponse]:
    query = text("""
        SELECT id, phone, name, email, role, status, tenant_id, territory_id
        FROM users WHERE tenant_id = :tenant_id
    """)
    result = db.execute(query, {"tenant_id": tenant_id})
    # Convert to response models
```

### Security Benefits

1. **Database Isolation**: Database credentials never leave Data Layer
2. **Network Segmentation**: No direct database access from Backend
3. **Controlled API Access**: All database operations through vetted endpoints
4. **Audit Trail**: Complete request tracking across all layers

---

## Security & Authentication

### Authentication Flow

1. **OTP Generation**: User requests OTP with phone number and tenant_id
2. **OTP Verification**: User submits OTP for verification
3. **JWT Token Issue**: System issues JWT token with user claims
4. **Token Validation**: Every request validates JWT token
5. **Permission Check**: Role-based access control per endpoint

### Security Measures

#### JWT Token Structure
```json
{
  "sub": "user_id",
  "phone": "9999999999",
  "name": "John Doe",
  "role": "sales_executive",
  "tenant_id": "TNT_123",
  "territory_id": "KL-EKM-001",
  "exp": 1632150000,
  "iat": 1632146400
}
```

#### Role-based Permissions
```python
ROLE_PERMISSIONS = {
    "superadmin": ["*"],  # All permissions
    "client_admin": [
        "users:create", "users:read", "users:update", "users:delete",
        "territories:create", "territories:read", "territories:update", "territories:delete",
        "shops:create", "shops:read", "shops:update", "shops:delete",
        "routes:read", "analytics:read"
    ],
    "area_manager": [
        "users:read", "users:update",
        "territories:read",
        "shops:read", "shops:update",
        "routes:create", "routes:read", "routes:update", "routes:delete",
        "visits:read", "analytics:read"
    ],
    "sales_executive": [
        "shops:read",
        "routes:read",
        "visits:create", "visits:read", "visits:update",
        "analytics:read_own"
    ]
}
```

#### Tenant Isolation
```python
async def enforce_tenant_access(current_user: User, tenant_id: str):
    if current_user.role != "superadmin" and current_user.tenant_id != tenant_id:
        raise HTTPException(
            status_code=403, 
            detail="Access denied: Invalid tenant"
        )
```

---

## Multi-Tenancy

### Tenant Isolation Strategy

#### URL-based Tenant Identification
All API endpoints include tenant_id in the URL path:
```
/api/v1/users/{tenant_id}
/api/v1/shops/{tenant_id}
/api/v1/routes/{tenant_id}
```

#### Database-level Isolation
Every business table includes a `tenant_id` column with proper indexing:
```sql
-- All queries automatically filtered by tenant_id
SELECT * FROM users WHERE tenant_id = 'TNT_123';
SELECT * FROM shops WHERE tenant_id = 'TNT_123' AND territory_id = 'KL-EKM-001';
```

#### Tenant Configuration
```python
class TenantConfig:
    tenant_id: str
    name: str
    domain: str
    features_enabled: List[str]
    branding: Dict[str, str]
    payment_policy_days: int = 30
    max_users: int = 100
    max_territories: int = 20
```

### White-labeling Support
- **Custom Branding**: Logos, colors, and themes per tenant
- **Feature Toggles**: Enable/disable features per tenant  
- **Custom Domain**: Support for tenant-specific domains
- **Localization**: Multi-language support per tenant

---

## Development & Deployment

### Local Development Setup

#### Prerequisites
- Docker & Docker Compose
- Python 3.11+ (for backend development)
- Flutter SDK (for frontend development)
- Node.js (for tooling)

#### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd sales_manager

# Start all services
docker-compose up -d

# Check service health
docker-compose ps

# View logs
docker-compose logs -f backend
docker-compose logs -f data-layer
```

#### Service URLs
- **Backend API**: http://localhost:8000
- **Data Layer**: http://localhost:8001  
- **Mock Client API**: http://localhost:8002
- **API Documentation**: http://localhost:8000/docs

### Production Deployment

#### Infrastructure Requirements
- **Compute**: 3 separate servers or container instances
- **Database**: MySQL 8.0 with replication
- **Cache**: Redis cluster
- **Load Balancer**: Application Load Balancer
- **Storage**: Persistent volumes for data

#### Docker Production Configuration
```yaml
services:
  backend:
    image: sales-manager-backend:latest
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
    environment:
      - DEBUG=false
      - ENVIRONMENT=production
      - DATABASE_URL=mysql://...
      - REDIS_URL=redis://...
```

### CI/CD Pipeline

#### GitHub Actions Workflow
```yaml
name: Deploy to Production
on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Tests
        run: |
          docker-compose -f docker-compose.test.yml up --abort-on-container-exit
  
  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to Production
        run: |
          # Build and push Docker images
          # Deploy to production environment
```

---

## Frontend Architecture

### Flutter Project Structure

The Flutter frontend follows **Clean Architecture** principles with **MVVM pattern**:

```
lib/
├── config/                 # App configuration
│   ├── dependencies.dart   # Dependency injection setup
│   └── providers/          # Riverpod providers
├── data/                   # Data layer
│   ├── repositories/       # Repository implementations
│   ├── datasources/        # API and local data sources
│   └── models/             # Data transfer objects
├── domain/                 # Domain layer
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business use cases
├── ui/                     # Presentation layer
│   ├── auth/               # Authentication screens
│   ├── dashboard/          # Dashboard screens  
│   ├── routes/             # Route management screens
│   ├── shops/              # Shop management screens
│   ├── analytics/          # Analytics screens
│   └── widgets/            # Reusable UI components
├── routing/                # App routing configuration
└── utils/                  # Utility functions
```

### Key Flutter Features

#### State Management with Riverpod
```dart
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<List<User>> build() async {
    final repository = ref.read(userRepositoryProvider);
    return repository.getUsers();
  }
  
  Future<void> createUser(User user) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.createUser(user);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

#### HTTP Client with Dio
```dart
@riverpod
Dio dio(DioRef ref) {
  final dio = Dio();
  
  // Add authentication interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = ref.read(authTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  ));
  
  return dio;
}
```

#### Offline Support
```dart
class VisitRepository {
  final Dio _dio;
  final OfflineQueue _offlineQueue;
  
  Future<void> checkIn(Visit visit) async {
    try {
      await _dio.post('/api/v1/visits', data: visit.toJson());
    } catch (e) {
      // Queue for offline sync
      await _offlineQueue.add(visit);
    }
  }
  
  Future<void> syncOfflineData() async {
    final queuedItems = await _offlineQueue.getAll();
    for (final item in queuedItems) {
      try {
        await _dio.post('/api/v1/visits', data: item.toJson());
        await _offlineQueue.remove(item);
      } catch (e) {
        // Keep in queue for next sync attempt
      }
    }
  }
}
```

---

## Testing Strategy

### Backend Testing

#### Unit Tests
```python
# tests/services/test_user_service.py
import pytest
from app.services.user_service import UserService
from app.core.errors import ValidationError

@pytest.fixture
def user_service():
    return UserService()

def test_create_user_success(user_service):
    user_data = {
        "phone": "9999999999",
        "name": "Test User",
        "role": "sales_executive",
        "tenant_id": "TEST_TENANT"
    }
    
    user = user_service.create_user(user_data)
    assert user.phone == "9999999999"
    assert user.status == "active"

def test_create_user_invalid_phone(user_service):
    user_data = {
        "phone": "invalid",
        "name": "Test User",
        "role": "sales_executive"
    }
    
    with pytest.raises(ValidationError):
        user_service.create_user(user_data)
```

#### Integration Tests
```python
# tests/api/test_users.py
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_create_user_endpoint():
    response = client.post(
        "/api/v1/users/TEST_TENANT",
        json={
            "phone": "9999999999",
            "name": "Test User",
            "role": "sales_executive"
        },
        headers={"Authorization": "Bearer test-token"}
    )
    
    assert response.status_code == 201
    data = response.json()
    assert data["phone"] == "9999999999"
    assert data["status"] == "active"
```

#### End-to-End Tests
```python
# tests/e2e/test_user_workflow.py
import pytest
from tests.helpers import create_test_tenant, create_test_user

@pytest.mark.e2e
def test_complete_user_workflow():
    # Setup
    tenant = create_test_tenant()
    admin_user = create_test_user(role="client_admin", tenant_id=tenant.id)
    
    # Test user creation workflow
    response = client.post(
        f"/api/v1/users/{tenant.id}",
        json={"phone": "8888888888", "name": "New User", "role": "sales_executive"},
        headers={"Authorization": f"Bearer {admin_user.token}"}
    )
    assert response.status_code == 201
    
    # Test user can login
    otp_response = client.post("/api/v1/auth/otp/generate", 
        json={"phone": "8888888888", "tenant_id": tenant.id})
    assert otp_response.status_code == 200
```

### Frontend Testing

#### Widget Tests
```dart
// test/widgets/user_list_test.dart
void main() {
  testWidgets('UserList displays users correctly', (tester) async {
    final users = [
      User(id: 1, name: 'John Doe', phone: '9999999999', role: 'sales_executive'),
      User(id: 2, name: 'Jane Smith', phone: '8888888888', role: 'area_manager'),
    ];
    
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: UserList(users: users),
        ),
      ),
    );
    
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(2));
  });
}
```

#### Integration Tests
```dart
// integration_test/user_management_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('User Management Flow', () {
    testWidgets('Complete user creation flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to user creation
      await tester.tap(find.byKey(Key('add_user_button')));
      await tester.pumpAndSettle();
      
      // Fill form
      await tester.enterText(find.byKey(Key('phone_field')), '9999999999');
      await tester.enterText(find.byKey(Key('name_field')), 'Test User');
      
      // Submit form
      await tester.tap(find.byKey(Key('submit_button')));
      await tester.pumpAndSettle();
      
      // Verify success
      expect(find.text('User created successfully'), findsOneWidget);
    });
  });
}
```

### Test Data Management

#### Database Fixtures
```python
# tests/fixtures.py
@pytest.fixture
def db_session():
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.close()

@pytest.fixture
def sample_tenant(db_session):
    tenant = Tenant(id="TEST_TENANT", name="Test Tenant")
    db_session.add(tenant)
    db_session.commit()
    return tenant

@pytest.fixture
def sample_user(db_session, sample_tenant):
    user = User(
        phone="9999999999",
        name="Test User",
        role="sales_executive",
        tenant_id=sample_tenant.id
    )
    db_session.add(user)
    db_session.commit()
    return user
```

---

## Getting Started

### Quick Start Guide

#### 1. Clone and Setup
```bash
git clone <repository-url>
cd sales_manager
```

#### 2. Environment Configuration
```bash
# Copy environment files
cp backend/env.example backend/.env
cp frontend/.env.example frontend/.env

# Update configuration as needed
vim backend/.env
```

#### 3. Start Services
```bash
# Start all services with Docker Compose
docker-compose up -d

# Check service status
docker-compose ps

# View service logs
docker-compose logs -f
```

#### 4. Initialize Database
```bash
# Run database migrations
docker exec -it sales_manager_backend alembic upgrade head

# Insert sample data
docker exec -i sales_manager_mysql mysql -u root -prootpassword sales_manager < insert.sql
```

#### 5. Verify Installation
```bash
# Check Backend API
curl http://localhost:8000/health

# Check Data Layer
curl http://localhost:8001/health

# Check API Documentation
open http://localhost:8000/docs
```

### Sample API Calls

#### 1. Generate OTP
```bash
curl -X POST "http://localhost:8000/api/v1/auth/otp/generate" \
  -H "Content-Type: application/json" \
  -d '{"phone": "5555555555", "tenant_id": "default"}'
```

#### 2. Verify OTP (Use OTP from backend logs)
```bash
curl -X POST "http://localhost:8000/api/v1/auth/otp/verify" \
  -H "Content-Type: application/json" \
  -d '{"phone": "5555555555", "otp": "123456", "otp_id": "uuid-from-step1"}'
```

#### 3. Get Users (Use JWT token from step 2)
```bash
curl -X GET "http://localhost:8000/api/v1/users/default" \
  -H "Authorization: Bearer <jwt-token>"
```

#### 4. Get Shops
```bash
curl -X GET "http://localhost:8000/api/v1/shops/default" \
  -H "Authorization: Bearer <jwt-token>"
```

### Frontend Development

#### 1. Setup Flutter Environment
```bash
# Install Flutter dependencies
cd frontend
flutter pub get

# Generate code
flutter packages pub run build_runner build
```

#### 2. Run Flutter App
```bash
# Run on web
flutter run -d chrome

# Run on mobile device
flutter run

# Run with specific environment
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

### Development Workflow

#### 1. Backend Development
```bash
# Start backend services
docker-compose up mysql redis data-layer -d

# Run backend in development mode
cd backend
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

#### 2. Frontend Development
```bash
# Start backend services
docker-compose up -d

# Run Flutter in development mode
cd frontend
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
```

#### 3. Database Operations
```bash
# Create new migration
cd backend
alembic revision --autogenerate -m "Add new table"

# Apply migrations
alembic upgrade head

# View current migration status
alembic current

# Reset database (development only)
docker-compose down -v
docker-compose up mysql -d
```

### Troubleshooting

#### Common Issues

1. **Database Connection Failed**
   ```bash
   # Check MySQL service status
   docker-compose ps mysql
   
   # View MySQL logs
   docker-compose logs mysql
   
   # Restart MySQL
   docker-compose restart mysql
   ```

2. **Backend Service Unhealthy**
   ```bash
   # Check backend logs
   docker-compose logs backend
   
   # Verify Data Layer connection
   curl http://localhost:8001/health
   
   # Restart backend
   docker-compose restart backend
   ```

3. **Frontend Build Issues**
   ```bash
   # Clear Flutter cache
   flutter clean
   flutter pub get
   
   # Regenerate generated code
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Network Connectivity Issues**
   ```bash
   # Check Docker networks
   docker network ls
   
   # Inspect network configuration
   docker network inspect sales_manager_backend_network
   
   # Test service connectivity
   docker exec sales_manager_backend ping data-layer
   ```

---

## Conclusion

This comprehensive documentation provides a complete understanding of the Sales Manager Platform. The system implements modern software engineering practices with a focus on security, scalability, and maintainability.

### Key Takeaways

1. **Three-Layer Architecture**: Ensures security through strict separation of concerns
2. **Multi-Tenancy**: Complete tenant isolation with URL-based identification
3. **Role-based Security**: Granular permissions and access control
4. **RESTful API Design**: Consistent and well-documented API endpoints
5. **Modern Tech Stack**: FastAPI, Flutter, MySQL, Redis, Docker
6. **Comprehensive Testing**: Unit, integration, and end-to-end tests
7. **Production Ready**: Docker-based deployment with CI/CD pipeline

For additional information or support, refer to the individual documentation files or contact the development team.

---

**Last Updated**: September 28, 2025  
**Version**: 1.0.1  
**Authors**: Sales Manager Platform Development Team