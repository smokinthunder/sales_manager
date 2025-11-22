# Sales Manager - Complete Multi-Tenant Sales Management System

A comprehensive sales management system built with a three-layer architecture, featuring a FastAPI backend, Flutter mobile app for sales executives, and an admin dashboard for management oversight.

## 🏗️ Project Architecture

This project follows a **three-layer architecture** for enhanced security and scalability:

- **Server A (MySQL Database)**: Isolated database server for data persistence
- **Server B (Data Layer)**: Direct database access layer with restricted network access
- **Server C (Backend API Gateway)**: Public-facing API that communicates with the Data Layer
- **Flutter Frontend**: Mobile application for sales executives
- **Admin Dashboard**: Web-based management interface for administrators

### Key Features

- 🔐 **Multi-tenant Architecture**: Support for multiple organizations with data isolation
- 👥 **Role-Based Access Control**: SUPERADMIN, CLIENT_ADMIN, AREA_MANAGER, SALES_EXECUTIVE
- 📊 **Analytics Dashboard**: Real-time sales metrics and performance tracking
- 🏪 **Shop Management**: Comprehensive shop assignment and territory management
- 📱 **Mobile-First Design**: Native Flutter apps for iOS and Android
- 🔄 **Data Synchronization**: Automatic sync with client finance systems (Tally-like)
- 📈 **Performance Tracking**: Sales executive performance monitoring and reporting
- 🎯 **Territory Management**: Geographic assignment and route optimization

## 📦 Technology Stack

### Backend
- **FastAPI** - Modern Python web framework
- **SQLAlchemy** - ORM for database management
- **MySQL 8.0** - Primary database
- **Redis** - Caching and session management
- **Alembic** - Database migrations
- **Pydantic** - Data validation
- **JWT** - Authentication & authorization

### Frontend (Mobile)
- **Flutter 3.8.1+** - Cross-platform mobile framework
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **FL Chart** - Data visualization
- **Flutter Secure Storage** - Secure local storage

### Admin Dashboard
- **Flutter Web** - Web-based admin interface
- **Syncfusion Gauges** - Advanced data visualization
- **Material Symbols Icons** - Modern iconography

### Infrastructure
- **Docker & Docker Compose** - Containerization
- **nginx** (optional) - Reverse proxy
- **APScheduler** - Background task scheduling

## 🚀 Getting Started

### Prerequisites

- **Docker** & **Docker Compose** (v2.0+)
- **Flutter SDK** (3.8.1 or higher)
- **Git**
- **Android Studio** / **Xcode** (for mobile development)

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/smokinthunder/sales_manager.git
cd sales_manager
```

#### 2. Backend Configuration

Create environment file from example:

```bash
cd backend
cp env.example .env
```

Edit `.env` file with your configuration. For development, the default values work fine.

#### 3. Start Backend Services with Docker

From the project root directory:

```bash
# Start all services (MySQL, Redis, Data Layer, Backend, Mock Client API)
docker-compose up -d

# View logs
docker-compose logs -f

# Check service health
docker-compose ps
```

The services will be available at:
- **Backend API**: http://localhost:8000
- **Data Layer**: http://localhost:8001
- **Mock Client API**: http://localhost:8002
- **MySQL**: localhost:3307
- **Redis**: localhost:6379

#### 4. Seed the Database (Optional)

To populate the database with sample data for testing:

```bash
# Run the database seeder
docker-compose --profile seed up db-seeder

# Or use the provided script
./seed_database.sh
```

This will create:
- Sample tenants (AquaStar, BeverageCo, etc.)
- Test users with different roles
- Shops with assignments
- Sample sales data and analytics

**Test Users:**
- SUPERADMIN: `+1234567890`
- CLIENT_ADMIN: `+1111111111`
- AREA_MANAGER: `+1111111112`
- SALES_EXECUTIVE: `+1111111121`

(OTP: `123456` in development mode)

#### 5. Verify Backend Installation

```bash
# Health check
curl http://localhost:8000/health

# API documentation
open http://localhost:8000/docs
```

## 📱 Running the Mobile App (Frontend)

### Setup

```bash
cd frontend

# Install dependencies
flutter pub get

# Generate code (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Create Environment File

Create `frontend/.env` file:

```env
API_BASE_URL=http://localhost:8000
API_VERSION=v1
ENABLE_LOGGING=true
```

### Run on Different Platforms

```bash
# iOS (requires macOS with Xcode)
flutter run -d ios

# Android (requires Android Studio and emulator/device)
flutter run -d android

# Web (for testing)
flutter run -d chrome

# List available devices
flutter devices
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

## 🖥️ Running the Admin Dashboard

### Setup

```bash
cd admin_dashboard

# Install dependencies
flutter pub get
```

### Run Dashboard

```bash
# Run on Chrome (recommended for web dashboard)
flutter run -d chrome

# Run on Edge
flutter run -d edge

# Build for production
flutter build web --release
```

The built web app will be in `admin_dashboard/build/web/`.

### Deploy Admin Dashboard

To deploy the admin dashboard to a web server:

```bash
# Build for production
cd admin_dashboard
flutter build web --release

# Copy built files to web server
cp -r build/web/* /var/www/admin-dashboard/

# Or use nginx, Apache, etc.
```

## 🐳 Docker Commands Reference

### Basic Operations

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Restart a specific service
docker-compose restart backend

# View logs
docker-compose logs -f backend

# Access service shell
docker-compose exec backend sh

# Rebuild after code changes
docker-compose up -d --build
```

### Development Workflow

```bash
# Watch mode (auto-reload on file changes)
docker-compose watch

# Remove all containers and volumes (clean slate)
docker-compose down -v

# View resource usage
docker stats
```

### Database Management

```bash
# Access MySQL CLI
docker-compose exec mysql mysql -u sales_user -p sales_manager

# Backup database
docker-compose exec mysql mysqldump -u sales_user -psales_password sales_manager > backup.sql

# Restore database
docker-compose exec -T mysql mysql -u sales_user -psales_password sales_manager < backup.sql
```

## 🔧 Development

### Backend Development

```bash
# Run backend locally (without Docker)
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations
alembic upgrade head

# Start development server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Flutter Development

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run custom lints
flutter pub run custom_lint

# Clean build artifacts
flutter clean
flutter pub get
```

## 📊 API Documentation

Once the backend is running, access interactive API documentation:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### Key API Endpoints

- `POST /api/v1/auth/login` - User authentication
- `GET /api/v1/users/profile` - Get user profile
- `GET /api/v1/shops` - List shops
- `GET /api/v1/analytics/dashboard` - Analytics data
- `POST /api/v1/sync/orders` - Sync order data
- `GET /api/v1/assignments` - Sales executive assignments

## 🏛️ Database Schema

Key tables:
- `tenants` - Multi-tenant organizations
- `users` - User accounts with role-based access
- `shops` - Customer shop information
- `sales_executive_assignments` - Territory assignments
- `synced_orders` - Order data from client systems
- `synced_products` - Product information
- `due_data` - Outstanding payment tracking

## 🔐 Security Features

- JWT-based authentication with refresh tokens
- Role-based access control (RBAC)
- Multi-tenant data isolation
- Encrypted password storage (bcrypt)
- Secure session management with Redis
- API rate limiting
- CORS configuration
- Request validation with Pydantic

## 🌐 Network Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Flutter Apps   │────▶│  Backend API    │────▶│  Data Layer     │
│  (Mobile/Web)   │     │  (Port 8000)    │     │  (Port 8001)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                                                          │
                                                          ▼
                        ┌─────────────────┐     ┌─────────────────┐
                        │     Redis       │     │     MySQL       │
                        │  (Port 6379)    │     │  (Port 3307)    │
                        └─────────────────┘     └─────────────────┘
```

## 📝 Project Structure

```
sales_manager/
├── backend/              # FastAPI backend service
│   ├── app/
│   │   ├── api/         # API routes and endpoints
│   │   ├── core/        # Core configuration and utilities
│   │   ├── domain/      # Domain models and schemas
│   │   ├── services/    # Business logic layer
│   │   └── main.py      # Application entry point
│   ├── alembic/         # Database migrations
│   ├── Dockerfile       # Backend container definition
│   └── requirements.txt # Python dependencies
├── data-layer/          # Data access layer service
│   ├── app/
│   └── Dockerfile
├── frontend/            # Flutter mobile application
│   ├── lib/
│   │   ├── domain/      # Business logic and models
│   │   ├── presentation/# UI components and screens
│   │   └── providers/   # State management
│   └── pubspec.yaml     # Flutter dependencies
├── admin_dashboard/     # Flutter web admin dashboard
│   ├── lib/
│   └── pubspec.yaml
├── mock_client_api/     # Mock Tally-like finance API
├── docker-compose.yml   # Docker orchestration
└── README.md           # This file
```

## 🐛 Troubleshooting

### Backend Issues

**Services not starting:**
```bash
# Check Docker daemon is running
docker ps

# Check logs for errors
docker-compose logs backend
docker-compose logs data-layer
docker-compose logs mysql
```

**Database connection errors:**
```bash
# Ensure MySQL is healthy
docker-compose ps mysql

# Check MySQL logs
docker-compose logs mysql

# Verify database exists
docker-compose exec mysql mysql -u sales_user -p -e "SHOW DATABASES;"
```

### Flutter Issues

**Dependencies not resolving:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

**Build errors:**
```bash
# Delete generated files
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete

# Regenerate
flutter pub run build_runner build --delete-conflicting-outputs
```

**Android build issues:**
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

## 📞 Support

For issues, questions, or contributions, please contact the development team or create an issue in the repository.

## 📄 License

Proprietary - All rights reserved

---

**Built with ❤️ for efficient sales management**
