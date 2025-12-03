"""
Data Layer Service - Server B

This service runs on Server B and has direct access to the database.
The backend (Server C) communicates with this service via HTTP APIs.
This is a standalone version that doesn't depend on the core module.
"""

from fastapi import FastAPI, HTTPException, Depends, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import date, datetime, time
import os
import logging
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import SQLAlchemyError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Sales Manager Data Layer",
    description="Data Layer Service - Server B (Database Access Layer)",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database configuration
DB_HOST = os.getenv("DB_HOST", "mysql")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_USERNAME = os.getenv("DB_USERNAME", "sales_user")
DB_PASSWORD = os.getenv("DB_PASSWORD", "sales_password")
DB_NAME = os.getenv("DB_NAME", "sales_manager")

DATABASE_URL = f"mysql+pymysql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# Database engine and session
engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Data models for API responses
class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    role: Optional[str] = None
    status: Optional[str] = None
    territory_id: Optional[str] = None
    updated_by: Optional[int] = None

# Email Authentication Models
class UserAuthCreate(BaseModel):
    user_id: int
    email: str
    password_hash: str
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

class UserAuthResponse(BaseModel):
    id: int
    user_id: int
    email: str
    last_login: Optional[datetime] = None
    login_attempts: int
    locked_until: Optional[datetime] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class UserAuthUpdate(BaseModel):
    email: Optional[str] = None
    password_hash: Optional[str] = None
    reset_token: Optional[str] = None
    reset_token_expires: Optional[datetime] = None
    last_login: Optional[datetime] = None
    login_attempts: Optional[int] = None
    locked_until: Optional[datetime] = None
    updated_by: Optional[int] = None

class PasswordResetRequest(BaseModel):
    email: str
    reset_token: str
    reset_token_expires: datetime

class PasswordResetVerify(BaseModel):
    reset_token: str
    new_password_hash: str

class UserResponse(BaseModel):
    id: int
    phone: str
    name: str
    email: Optional[str] = None
    role: str
    status: str
    tenant_id: str
    territory_id: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

class ShopCreate(BaseModel):
    shop_id: str
    name: str
    status: str = "active"
    address: Optional[str] = None
    phone: Optional[str] = None
    contact_person: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    territory_id: Optional[str] = None
    pin_code: Optional[str] = None
    email: Optional[str] = None
    aadhaar_number: Optional[str] = None
    pan_number: Optional[str] = None
    location_name: Optional[str] = None
    gst_number: Optional[str] = None
    created_at: str
    updated_at: str
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

class ShopUpdate(BaseModel):
    name: Optional[str] = None
    status: Optional[str] = None
    address: Optional[str] = None
    phone: Optional[str] = None
    contact_person: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    territory_id: Optional[str] = None
    pin_code: Optional[str] = None
    email: Optional[str] = None
    aadhaar_number: Optional[str] = None
    pan_number: Optional[str] = None
    location_name: Optional[str] = None
    gst_number: Optional[str] = None
    updated_at: str
    updated_by: Optional[int] = None

class ShopResponse(BaseModel):
    id: int
    shop_id: str
    name: str
    status: str
    address: Optional[str] = None
    phone: Optional[str] = None
    contact_person: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    territory_id: Optional[str] = None
    pin_code: Optional[str] = None
    email: Optional[str] = None
    aadhaar_number: Optional[str] = None
    pan_number: Optional[str] = None
    location_name: Optional[str] = None
    gst_number: Optional[str] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

class TerritoryResponse(BaseModel):
    id: int
    territory_id: str
    name: str
    code: str
    description: Optional[str] = None
    area_manager_id: Optional[int] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

class VisitResponse(BaseModel):
    id: int
    visit_id: str
    shop_id: str
    executive_id: str
    route_id: Optional[str] = None
    checkin_time: datetime
    checkout_time: Optional[datetime]
    location_lat: float
    location_lng: float
    remarks: Optional[str]
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class RouteResponse(BaseModel):
    """Response model for route data."""
    id: int = Field(..., description="Database primary key")
    route_id: str = Field(..., description="Business-friendly route identifier")
    name: str = Field(..., description="Route name")
    territory_id: str = Field(..., description="Territory identifier")
    week_start_date: date = Field(..., description="Week start date for the route")
    status: str = Field(..., description="Route status")
    tenant_id: str = Field(..., description="Tenant identifier")
    created_at: datetime = Field(..., description="Route creation timestamp")
    updated_at: datetime = Field(..., description="Route last update timestamp")
    created_by: Optional[int] = Field(None, description="User ID who created the route")
    updated_by: Optional[int] = Field(None, description="User ID who last updated the route")


class RouteCreate(BaseModel):
    """Model for creating new routes."""
    route_id: Optional[str] = Field(None, description="Business-friendly route identifier (auto-generated if not provided)")
    name: str = Field(..., description="Route name")
    territory_id: str = Field(..., description="Territory identifier")
    week_start_date: date = Field(..., description="Week start date for the route")
    status: Optional[str] = Field("planned", description="Route status")
    created_by: Optional[int] = Field(None, description="User ID who created the route")
    updated_by: Optional[int] = Field(None, description="User ID who last updated the route")


class RouteUpdate(BaseModel):
    """Model for updating existing routes."""
    route_id: Optional[str] = Field(None, description="Business-friendly route identifier")
    name: Optional[str] = Field(None, description="Route name")
    territory_id: Optional[str] = Field(None, description="Territory identifier")
    week_start_date: Optional[date] = Field(None, description="Week start date for the route")
    status: Optional[str] = Field(None, description="Route status")
    updated_by: Optional[int] = Field(None, description="User ID who last updated the route")


class RouteAssignmentResponse(BaseModel):
    id: int
    route_id: str
    shop_id: str
    sales_executive_id: int
    planned_date: date
    planned_time: Optional[time] = None
    sequence_order: Optional[int] = None
    status: str
    created_at: datetime
    updated_at: datetime


class RouteAssignmentCreate(BaseModel):
    """Model for creating new route assignments."""
    route_id: str
    shop_id: str
    sales_executive_id: int
    planned_date: date
    planned_time: Optional[time] = None
    sequence_order: Optional[int] = None
    status: Optional[str] = "planned"


class RouteAssignmentUpdate(BaseModel):
    """Model for updating existing route assignments."""
    shop_id: Optional[str] = None
    sales_executive_id: Optional[int] = None
    planned_date: Optional[date] = None
    planned_time: Optional[datetime] = None
    sequence_order: Optional[int] = None
    status: Optional[str] = None

class AnalyticsResponse(BaseModel):
    shop_id: str
    shop_name: str
    total_visits: int
    last_visit_date: Optional[date]
    outstanding_amount: float
    days_overdue: int
    monthly_sales: float

# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        # Test database connection
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        return {
            "status": "healthy",
            "service": "data-layer",
            "database": "connected",
            "timestamp": datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        raise HTTPException(status_code=500, detail="Service unhealthy")

@app.get("/api/users/{tenant_id}", response_model=List[UserResponse])
async def get_users(tenant_id: str, db=Depends(get_db)):
    """Get users for a specific tenant"""
    try:
        query = text("""
            SELECT id, phone, name, email, role, status, tenant_id, territory_id, created_at, updated_at, created_by, updated_by
            FROM users 
            WHERE tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id})
        users = []
        
        for row in result:
            users.append(UserResponse(
                id=row[0],
                phone=row[1],
                name=row[2],
                email=row[3],
                role=row[4],
                status=row[5],
                tenant_id=row[6],
                territory_id=row[7],
                created_at=row[8],
                updated_at=row[9],
                created_by=row[10],
                updated_by=row[11]
            ))
        
        return users
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.delete("/api/users/{tenant_id}/{user_id}")
async def delete_user(tenant_id: str, user_id: str, db=Depends(get_db)):
    """Hard delete a user (completely removes from database)"""
    try:
        # Check if user exists
        check_query = text("""
            SELECT id FROM users 
            WHERE id = :user_id AND tenant_id = :tenant_id
        """)
        
        existing_user = db.execute(check_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not existing_user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Check if user has any dependencies (e.g., created routes, territories)
        dependencies_check_query = text("""
            SELECT 
                (SELECT COUNT(*) FROM routes WHERE created_by = :user_id AND tenant_id = :tenant_id) as routes_created,
                (SELECT COUNT(*) FROM territories WHERE created_by = :user_id AND tenant_id = :tenant_id) as territories_created
        """)
        
        dependencies_result = db.execute(dependencies_check_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if dependencies_result[0] > 0 or dependencies_result[1] > 0:
            raise HTTPException(
                status_code=400, 
                detail=f"Cannot delete user. They have created {dependencies_result[0]} routes and {dependencies_result[1]} territories."
            )
        
        # Hard delete the user
        delete_query = text("""
            DELETE FROM users 
            WHERE id = :user_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(delete_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        })
        
        db.commit()
        
        if result.rowcount == 0:
            raise HTTPException(status_code=500, detail="Failed to delete user")
        
        return {
            "message": "User deleted successfully",
            "user_id": user_id,
            "deleted_at": datetime.now().isoformat()
        }
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.put("/api/users/{tenant_id}/{user_id}")
async def update_user(tenant_id: str, user_id: str, user_data: UserUpdate, db=Depends(get_db)):
    """Update user data"""
    try:
        # Check if user exists
        check_query = text("""
            SELECT id FROM users 
            WHERE id = :user_id AND tenant_id = :tenant_id
        """)
        
        existing_user = db.execute(check_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not existing_user:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Build dynamic UPDATE query based on provided fields
        update_fields = []
        params = {"user_id": user_id, "tenant_id": tenant_id}
        
        if user_data.name is not None:
            update_fields.append("name = :name")
            params["name"] = user_data.name
        
        if user_data.email is not None:
            update_fields.append("email = :email")
            params["email"] = user_data.email
        
        if user_data.role is not None:
            update_fields.append("role = :role")
            params["role"] = user_data.role
        
        if user_data.status is not None:
            update_fields.append("status = :status")
            params["status"] = user_data.status
        
        if user_data.territory_id is not None:
            update_fields.append("territory_id = :territory_id")
            params["territory_id"] = user_data.territory_id
        
        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Add timestamp and updated_by if provided
        update_fields.append("updated_at = NOW()")
        if user_data.updated_by is not None:
            update_fields.append("updated_by = :updated_by")
            params["updated_by"] = user_data.updated_by
        
        update_query = text(f"""
            UPDATE users 
            SET {', '.join(update_fields)}
            WHERE id = :user_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(update_query, params)
        db.commit()
        
        if result.rowcount == 0:
            raise HTTPException(status_code=500, detail="Failed to update user")
        
        # Get the updated user
        select_query = text("""
            SELECT id, phone, name, email, role, status, tenant_id, created_at, updated_at, created_by, updated_by
            FROM users 
            WHERE id = :user_id
        """)
        
        user_result = db.execute(select_query, {"user_id": user_id})
        user_row = user_result.fetchone()
        
        return UserResponse(
            id=user_row[0],
            phone=user_row[1],
            name=user_row[2],
            email=user_row[3],
            role=user_row[4],
            status=user_row[5],
            tenant_id=user_row[6],
            territory_id=user_row[7],
            created_at=user_row[8],
            updated_at=user_row[9],
            created_by=user_row[10],
            updated_by=user_row[11]
        )
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


# Territory creation model
class TerritoryCreate(BaseModel):
    territory_id: str
    name: str
    code: str
    description: Optional[str] = None
    area_manager_id: Optional[int] = None
    created_by: Optional[int] = None
    # SECURITY: tenant_id is NOT allowed in request body - it's enforced via URL parameter

# Territory update model
class TerritoryUpdate(BaseModel):
    name: Optional[str] = None
    code: Optional[str] = None
    description: Optional[str] = None
    area_manager_id: Optional[int] = None
    updated_by: Optional[int] = None

# User creation model
class UserCreate(BaseModel):
    phone: str
    name: str
    email: Optional[str] = None
    role: str
    status: str = "active"
    territory_id: Optional[str] = None
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

@app.post("/api/users/{tenant_id}", response_model=UserResponse)
async def create_user(tenant_id: str, user_data: UserCreate, db=Depends(get_db)):
    """Create a new user for a specific tenant"""
    try:
        # Check if user with same phone already exists
        check_phone_query = text("""
            SELECT id FROM users 
            WHERE phone = :phone AND tenant_id = :tenant_id
        """)
        
        existing_user_by_phone = db.execute(check_phone_query, {
            "phone": user_data.phone,
            "tenant_id": tenant_id
        }).fetchone()
        
        if existing_user_by_phone:
            raise HTTPException(status_code=400, detail="User with this phone number already exists")
        
        # Note: Multiple users per tenant are allowed in multi-tenant system
        
        # Create new user
        insert_query = text("""
            INSERT INTO users (phone, name, email, role, tenant_id, status, territory_id, created_at, updated_at, created_by, updated_by)
            VALUES (:phone, :name, :email, :role, :tenant_id, :status, :territory_id, NOW(), NOW(), :created_by, :updated_by)
        """)
        
        result = db.execute(insert_query, {
            "phone": user_data.phone,
            "name": user_data.name,
            "email": getattr(user_data, 'email', None),
            "role": user_data.role,
            "tenant_id": tenant_id,
            "status": user_data.status,
            "territory_id": getattr(user_data, 'territory_id', None),
            "created_by": getattr(user_data, 'created_by', None),
            "updated_by": getattr(user_data, 'created_by', None)
        })
        
        db.commit()
        
        # Get the created user
        user_id = result.lastrowid
        select_query = text("""
            SELECT id, phone, name, email, role, status, tenant_id, territory_id, created_at, updated_at, created_by, updated_by
            FROM users 
            WHERE id = :user_id
        """)
        
        user_result = db.execute(select_query, {"user_id": user_id})
        user_row = user_result.fetchone()
        
        return UserResponse(
            id=user_row[0],
            phone=user_row[1],
            name=user_row[2],
            email=user_row[3],
            role=user_row[4],
            status=user_row[5],
            tenant_id=user_row[6],
            territory_id=user_row[7],
            created_at=user_row[8],
            updated_at=user_row[9],
            created_by=user_row[10],
            updated_by=user_row[11]
        )
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/api/shops/{tenant_id}", response_model=List[ShopResponse])
async def get_shops(
    tenant_id: str, 
    territory_id: Optional[str] = None, 
    status: Optional[str] = None,
    db=Depends(get_db)
):
    """Get shops for a specific tenant with optional filtering"""
    try:
        # Build query with optional filters
        where_conditions = ["tenant_id = :tenant_id"]
        params = {"tenant_id": tenant_id}
        
        if territory_id:
            where_conditions.append("territory_id = :territory_id")
            params["territory_id"] = territory_id
            
        if status:
            where_conditions.append("status = :status")
            params["status"] = status
        
        where_clause = " AND ".join(where_conditions)
        
        query = text(f"""
            SELECT id, shop_id, name, status, address, phone, contact_person, 
                   latitude, longitude, territory_id, tenant_id, created_at, updated_at, 
                   created_by, updated_by
            FROM shops 
            WHERE {where_clause}
            ORDER BY name
        """)
        
        result = db.execute(query, params)
        shops = []
        
        for row in result:
            shops.append(ShopResponse(
                id=row[0],
                shop_id=row[1],
                name=row[2],
                status=row[3],
                address=row[4],
                phone=row[5],
                contact_person=row[6],
                latitude=row[7],
                longitude=row[8],
                territory_id=row[9],
                tenant_id=row[10],
                created_at=row[11],
                updated_at=row[12],
                created_by=row[13],
                updated_by=row[14]
            ))
        
        return shops
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/shops/{tenant_id}/{shop_id}", response_model=ShopResponse)
async def get_shop(tenant_id: str, shop_id: str, db=Depends(get_db)):
    """Get a specific shop by tenant and shop_id"""
    try:
        query = text("""
            SELECT id, shop_id, name, status, address, phone, contact_person, 
                   latitude, longitude, territory_id, pin_code, email, aadhaar_number,
                   pan_number, location_name, gst_number, tenant_id, created_at, updated_at, 
                   created_by, updated_by
            FROM shops 
            WHERE tenant_id = :tenant_id AND shop_id = :shop_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id, "shop_id": shop_id})
        row = result.fetchone()
        
        if not row:
            raise HTTPException(status_code=404, detail="Shop not found")
        
        return ShopResponse(
            id=row[0],
            shop_id=row[1],
            name=row[2],
            status=row[3],
            address=row[4],
            phone=row[5],
            contact_person=row[6],
            latitude=row[7],
            longitude=row[8],
            territory_id=row[9],
            pin_code=row[10],
            email=row[11],
            aadhaar_number=row[12],
            pan_number=row[13],
            location_name=row[14],
            gst_number=row[15],
            tenant_id=row[16],
            created_at=row[17],
            updated_at=row[18],
            created_by=row[19],
            updated_by=row[20]
        )
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/shops/{tenant_id}", response_model=ShopResponse)
async def create_shop(tenant_id: str, shop_data: ShopCreate, db=Depends(get_db)):
    """Create a new shop for a specific tenant"""
    try:
        # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
        # This prevents users from creating resources in other tenants
        
        # Check if shop with same shop_id already exists
        check_query = text("""
            SELECT id FROM shops 
            WHERE shop_id = :shop_id AND tenant_id = :tenant_id
        """)
        
        existing = db.execute(check_query, {
            "shop_id": shop_data.shop_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if existing:
            raise HTTPException(status_code=409, detail="Shop with this ID already exists")
        
        # Validate territory_id if provided
        if shop_data.territory_id:
            territory_check = text("""
                SELECT id FROM territories WHERE territory_id = :territory_id AND tenant_id = :tenant_id
            """)
            territory_exists = db.execute(territory_check, {
                "territory_id": shop_data.territory_id,
                "tenant_id": tenant_id
            }).fetchone()
            
            if not territory_exists:
                raise HTTPException(status_code=400, detail="Invalid territory_id")
        
        # Insert new shop
        insert_query = text("""
            INSERT INTO shops (shop_id, name, code, status, address, phone, contact_person, 
                             latitude, longitude, territory_id, pin_code, email, aadhaar_number,
                             pan_number, location_name, gst_number, tenant_id, created_at, updated_at, 
                             created_by, updated_by)
            VALUES (:shop_id, :name, :code, :status, :address, :phone, :contact_person, 
                    :latitude, :longitude, :territory_id, :pin_code, :email, :aadhaar_number,
                    :pan_number, :location_name, :gst_number, :tenant_id, :created_at, :updated_at, 
                    :created_by, :updated_by)
        """)
        
        db.execute(insert_query, {
            "shop_id": shop_data.shop_id,
            "name": shop_data.name,
            "code": shop_data.shop_id,  # Use shop_id as code for now
            "status": shop_data.status,
            "address": shop_data.address,
            "phone": shop_data.phone,
            "contact_person": shop_data.contact_person,
            "latitude": shop_data.latitude,
            "longitude": shop_data.longitude,
            "territory_id": shop_data.territory_id,
            "pin_code": shop_data.pin_code,
            "email": shop_data.email,
            "aadhaar_number": shop_data.aadhaar_number,
            "pan_number": shop_data.pan_number,
            "location_name": shop_data.location_name,
            "gst_number": shop_data.gst_number,
            "tenant_id": tenant_id,  # Use URL parameter, not request body
            "created_at": shop_data.created_at,
            "updated_at": shop_data.updated_at,
            "created_by": shop_data.created_by,
            "updated_by": shop_data.updated_by
        })
        
        db.commit()
        
        # Return the created shop
        return await get_shop(tenant_id, shop_data.shop_id, db)
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.put("/api/shops/{tenant_id}/{shop_id}", response_model=ShopResponse)
async def update_shop(tenant_id: str, shop_id: str, shop_data: ShopUpdate, db=Depends(get_db)):
    """Update an existing shop"""
    try:
        # Check if shop exists
        existing_query = text("""
            SELECT id FROM shops 
            WHERE tenant_id = :tenant_id AND shop_id = :shop_id
        """)
        
        existing = db.execute(existing_query, {
            "tenant_id": tenant_id,
            "shop_id": shop_id
        }).fetchone()
        
        if not existing:
            raise HTTPException(status_code=404, detail="Shop not found")
        
        
        # Validate territory_id if provided
        if shop_data.territory_id:
            territory_check = text("""
                SELECT id FROM territories WHERE territory_id = :territory_id AND tenant_id = :tenant_id
            """)
            territory_exists = db.execute(territory_check, {
                "territory_id": shop_data.territory_id,
                "tenant_id": tenant_id
            }).fetchone()
            
            if not territory_exists:
                raise HTTPException(status_code=400, detail="Invalid territory_id")
        
        # Build update query dynamically
        update_fields = []
        params = {"tenant_id": tenant_id, "shop_id": shop_id}
        
        if shop_data.name is not None:
            update_fields.append("name = :name")
            params["name"] = shop_data.name
        
        
        if shop_data.status is not None:
            update_fields.append("status = :status")
            params["status"] = shop_data.status
        
        if shop_data.address is not None:
            update_fields.append("address = :address")
            params["address"] = shop_data.address
        
        if shop_data.phone is not None:
            update_fields.append("phone = :phone")
            params["phone"] = shop_data.phone
        
        if shop_data.contact_person is not None:
            update_fields.append("contact_person = :contact_person")
            params["contact_person"] = shop_data.contact_person
        
        if shop_data.latitude is not None:
            update_fields.append("latitude = :latitude")
            params["latitude"] = shop_data.latitude
        
        if shop_data.longitude is not None:
            update_fields.append("longitude = :longitude")
            params["longitude"] = shop_data.longitude
        
        if shop_data.territory_id is not None:
            update_fields.append("territory_id = :territory_id")
            params["territory_id"] = shop_data.territory_id
        
        # Always update audit fields
        update_fields.append("updated_at = :updated_at")
        update_fields.append("updated_by = :updated_by")
        params["updated_at"] = shop_data.updated_at
        params["updated_by"] = shop_data.updated_by
        
        if not update_fields:
            # No fields to update, return existing shop
            return await get_shop(tenant_id, shop_id, db)
        
        update_query = text(f"""
            UPDATE shops 
            SET {', '.join(update_fields)}
            WHERE tenant_id = :tenant_id AND shop_id = :shop_id
        """)
        
        db.execute(update_query, params)
        db.commit()
        
        # Return the updated shop
        return await get_shop(tenant_id, shop_id, db)
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.delete("/api/shops/{tenant_id}/{shop_id}")
async def delete_shop(tenant_id: str, shop_id: str, db=Depends(get_db)):
    """Delete a shop"""
    try:
        # Check if shop exists
        existing_query = text("""
            SELECT id FROM shops 
            WHERE tenant_id = :tenant_id AND shop_id = :shop_id
        """)
        
        existing = db.execute(existing_query, {
            "tenant_id": tenant_id,
            "shop_id": shop_id
        }).fetchone()
        
        if not existing:
            raise HTTPException(status_code=404, detail="Shop not found")
        
        # Check for dependencies (visits, orders, payments, outstandings)
        dependencies_query = text("""
            SELECT 
                (SELECT COUNT(*) FROM visits WHERE shop_id = :shop_id AND tenant_id = :tenant_id) as visit_count,
                (SELECT COUNT(*) FROM orders WHERE shop_id = :shop_id AND tenant_id = :tenant_id) as order_count,
                (SELECT COUNT(*) FROM payments WHERE shop_id = :shop_id AND tenant_id = :tenant_id) as payment_count,
                (SELECT COUNT(*) FROM outstandings WHERE shop_id = :shop_id AND tenant_id = :tenant_id) as outstanding_count
        """)
        
        dependencies = db.execute(dependencies_query, {
            "shop_id": shop_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if any(dependencies):
            raise HTTPException(
                status_code=400, 
                detail=f"Cannot delete shop. It has {dependencies[0]} visits, {dependencies[1]} orders, {dependencies[2]} payments, and {dependencies[3]} outstandings associated with it."
            )
        
        # Delete shop
        delete_query = text("""
            DELETE FROM shops 
            WHERE tenant_id = :tenant_id AND shop_id = :shop_id
        """)
        
        db.execute(delete_query, {"tenant_id": tenant_id, "shop_id": shop_id})
        db.commit()
        
        return {"message": "Shop deleted successfully"}
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/territories/{tenant_id}", response_model=List[TerritoryResponse])
async def get_territories(tenant_id: str, db=Depends(get_db)):
    """Get territories for a specific tenant"""
    try:
        query = text("""
            SELECT id, territory_id, name, code, description, area_manager_id, tenant_id, created_at, updated_at, created_by, updated_by
            FROM territories 
            WHERE tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id})
        territories = []
        
        for row in result:
            territories.append(TerritoryResponse(
                id=row[0],
                territory_id=row[1],
                name=row[2],
                code=row[3],
                description=row[4],
                area_manager_id=row[5],
                tenant_id=row[6],
                created_at=row[7],
                updated_at=row[8],
                created_by=row[9],
                updated_by=row[10]
            ))
        
        return territories
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/territories/{tenant_id}", response_model=TerritoryResponse)
async def create_territory(tenant_id: str, territory_data: TerritoryCreate, db=Depends(get_db)):
    """Create a new territory for a specific tenant"""
    try:
        # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
        # This prevents users from creating resources in other tenants
        
        # Check if territory with same territory_id or code already exists
        check_query = text("""
            SELECT id FROM territories 
            WHERE (territory_id = :territory_id OR code = :code) AND tenant_id = :tenant_id
        """)
        
        existing_territory = db.execute(check_query, {
            "territory_id": territory_data.territory_id,
            "code": territory_data.code,
            "tenant_id": tenant_id  # Use URL parameter, not request body
        }).fetchone()
        
        if existing_territory:
            raise HTTPException(status_code=400, detail="Territory with this ID or code already exists")
        
        # Create new territory - ALWAYS use URL parameter tenant_id
        insert_query = text("""
            INSERT INTO territories (territory_id, name, code, description, area_manager_id, tenant_id, created_at, updated_at, created_by, updated_by)
            VALUES (:territory_id, :name, :code, :description, :area_manager_id, :tenant_id, NOW(), NOW(), :created_by, :updated_by)
        """)
        
        result = db.execute(insert_query, {
            "territory_id": territory_data.territory_id,
            "name": territory_data.name,
            "code": territory_data.code,
            "description": territory_data.description,
            "area_manager_id": territory_data.area_manager_id,
            "tenant_id": tenant_id,  # Use URL parameter, not request body
            "created_by": territory_data.created_by,
            "updated_by": territory_data.created_by
        })
        
        db.commit()
        
        # Get the created territory
        territory_id = result.lastrowid
        select_query = text("""
            SELECT id, territory_id, name, code, description, area_manager_id, tenant_id, created_at, updated_at, created_by, updated_by
            FROM territories 
            WHERE id = :territory_id
        """)
        
        territory_result = db.execute(select_query, {"territory_id": territory_id})
        territory_row = territory_result.fetchone()
        
        return TerritoryResponse(
            id=territory_row[0],
            territory_id=territory_row[1],
            name=territory_row[2],
            code=territory_row[3],
            description=territory_row[4],
            area_manager_id=territory_row[5],
            tenant_id=territory_row[6],
            created_at=territory_row[7],
            updated_at=territory_row[8],
            created_by=territory_row[9],
            updated_by=territory_row[10]
        )
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.put("/api/territories/{tenant_id}/{territory_id}", response_model=TerritoryResponse)
async def update_territory(tenant_id: str, territory_id: str, territory_data: TerritoryUpdate, db=Depends(get_db)):
    """Update territory data"""
    try:
        # Check if territory exists
        check_query = text("""
            SELECT id FROM territories 
            WHERE territory_id = :territory_id AND tenant_id = :tenant_id
        """)
        
        existing_territory = db.execute(check_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not existing_territory:
            raise HTTPException(status_code=404, detail="Territory not found")
        
        # Build dynamic UPDATE query based on provided fields
        update_fields = []
        params = {"territory_id": territory_id, "tenant_id": tenant_id}
        
        if territory_data.name is not None:
            update_fields.append("name = :name")
            params["name"] = territory_data.name
        
        if territory_data.code is not None:
            update_fields.append("code = :code")
            params["code"] = territory_data.code
        
        if territory_data.description is not None:
            update_fields.append("description = :description")
            params["description"] = territory_data.description
        
        if territory_data.area_manager_id is not None:
            update_fields.append("area_manager_id = :area_manager_id")
            params["area_manager_id"] = territory_data.area_manager_id
        
        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Add timestamp and updated_by if provided
        update_fields.append("updated_at = NOW()")
        if territory_data.updated_by is not None:
            update_fields.append("updated_by = :updated_by")
            params["updated_by"] = territory_data.updated_by
        
        update_query = text(f"""
            UPDATE territories 
            SET {', '.join(update_fields)}
            WHERE territory_id = :territory_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(update_query, params)
        db.commit()
        
        if result.rowcount == 0:
            raise HTTPException(status_code=500, detail="Failed to update territory")
        
        # Get the updated territory
        select_query = text("""
            SELECT id, territory_id, name, code, description, area_manager_id, tenant_id, created_at, updated_at, created_by, updated_by
            FROM territories 
            WHERE territory_id = :territory_id
        """)
        
        territory_result = db.execute(select_query, {"territory_id": territory_id})
        territory_row = territory_result.fetchone()
        
        return TerritoryResponse(
            id=territory_row[0],
            territory_id=territory_row[1],
            name=territory_row[2],
            code=territory_row[3],
            description=territory_row[4],
            area_manager_id=territory_row[5],
            tenant_id=territory_row[6],
            created_at=territory_row[7],
            updated_at=territory_row[8],
            created_by=territory_row[9],
            updated_by=territory_row[10]
        )
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.delete("/api/territories/{tenant_id}/{territory_id}")
async def delete_territory(tenant_id: str, territory_id: str, db=Depends(get_db)):
    """Delete a territory (hard delete - completely removes from database)"""
    try:
        # Check if territory exists
        check_query = text("""
            SELECT id FROM territories 
            WHERE territory_id = :territory_id AND tenant_id = :tenant_id
        """)
        
        existing_territory = db.execute(check_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not existing_territory:
            raise HTTPException(status_code=404, detail="Territory not found")
        
        # Check if territory has associated shops or routes
        check_dependencies_query = text("""
            SELECT 
                (SELECT COUNT(*) FROM shops WHERE territory_id = :territory_id AND tenant_id = :tenant_id) as shop_count,
                (SELECT COUNT(*) FROM routes WHERE territory_id = :territory_id AND tenant_id = :tenant_id) as route_count
        """)
        
        dependencies_result = db.execute(check_dependencies_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if dependencies_result[0] > 0 or dependencies_result[1] > 0:
            raise HTTPException(
                status_code=400, 
                detail=f"Cannot delete territory. It has {dependencies_result[0]} shops and {dependencies_result[1]} routes associated with it."
            )
        
        # Delete territory
        delete_query = text("""
            DELETE FROM territories 
            WHERE territory_id = :territory_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(delete_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id
        })
        
        db.commit()
        
        if result.rowcount == 0:
            raise HTTPException(status_code=500, detail="Failed to delete territory")
        
        return {
            "message": "Territory deleted successfully",
            "territory_id": territory_id,
            "deleted_at": datetime.now().isoformat()
        }
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/api/visits/{tenant_id}", response_model=List[VisitResponse])
async def get_visits(
    tenant_id: str, 
    shop_id: Optional[str] = None,
    executive_id: Optional[str] = None,
    date_from: Optional[date] = None,
    db=Depends(get_db)
):
    """Get visits for a specific tenant with optional filters"""
    try:
        base_query = """
            SELECT id, visit_id, shop_id, executive_id, checkin_time, checkout_time, 
                   location_lat, location_lng, remarks, tenant_id, created_at, updated_at
            FROM visits 
            WHERE tenant_id = :tenant_id
        """
        params = {"tenant_id": tenant_id}
        
        if shop_id:
            base_query += " AND shop_id = :shop_id"
            params["shop_id"] = shop_id
        
        if executive_id:
            base_query += " AND executive_id = :executive_id"
            params["executive_id"] = executive_id
        
        if date_from:
            base_query += " AND DATE(checkin_time) >= :date_from"
            params["date_from"] = date_from
        
        base_query += " ORDER BY checkin_time DESC"
        
        result = db.execute(text(base_query), params)
        visits = []
        
        for row in result:
            visits.append(VisitResponse(
                id=row[0],
                visit_id=row[1],
                shop_id=row[2],
                executive_id=row[3],
                checkin_time=row[4],
                checkout_time=row[5],
                location_lat=row[6],
                location_lng=row[7],
                remarks=row[8],
                tenant_id=row[9],
                created_at=row[10],
                updated_at=row[11]
            ))
        
        return visits
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/api/routes/{tenant_id}", response_model=List[RouteResponse])
async def get_routes(
    tenant_id: str, 
    executive_id: Optional[str] = None,
    week_start: Optional[date] = None,
    db=Depends(get_db)
):
    """Get routes for a specific tenant with optional filters"""
    try:
        base_query = """
            SELECT id, route_id, name, territory_id, week_start_date, status, tenant_id, created_at, updated_at, created_by, updated_by
            FROM routes 
            WHERE tenant_id = :tenant_id
        """
        params = {"tenant_id": tenant_id}
        
        if executive_id:
            base_query += " AND executive_id = :executive_id"
            params["executive_id"] = executive_id
        
        if week_start:
            base_query += " AND week_start_date = :week_start"
            params["week_start"] = week_start
        
        base_query += " ORDER BY week_start_date DESC"
        
        result = db.execute(text(base_query), params)
        routes = []
        
        for row in result:
            routes.append(RouteResponse(
                id=row[0],
                route_id=row[1],
                name=row[2],
                territory_id=row[3],
                week_start_date=row[4],
                status=row[5],
                tenant_id=row[6],
                created_at=row[7],
                updated_at=row[8],
                created_by=row[9],
                updated_by=row[10]
            ))
        
        return routes
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/routes/{tenant_id}", response_model=RouteResponse)
async def create_route(
    tenant_id: str,
    route_data: RouteCreate,
    db=Depends(get_db)
):
    """Create a new route for a specific tenant"""
    try:
        # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
        insert_query = text("""
            INSERT INTO routes (route_id, name, territory_id, week_start_date, status, tenant_id, created_at, updated_at, created_by, updated_by)
            VALUES (:route_id, :name, :territory_id, :week_start_date, :status, :tenant_id, NOW(), NOW(), :created_by, :updated_by)
        """)
        
        route_dict = route_data.model_dump() if hasattr(route_data, 'model_dump') else dict(route_data)
        
        # Generate route_id if not provided
        if not route_dict.get("route_id"):
            # Simple fallback: use timestamp-based ID
            import time
            route_dict["route_id"] = f"RT-{int(time.time())}"
        
        db.execute(insert_query, {
            "route_id": route_dict["route_id"],
            "name": route_dict["name"],
            "territory_id": route_dict["territory_id"],
            "week_start_date": route_dict["week_start_date"],
            "status": route_dict.get("status", "planned"),
            "tenant_id": tenant_id,  # Use URL parameter, not request body
            "created_by": route_dict.get("created_by"),
            "updated_by": route_dict.get("updated_by")
        })
        
        db.commit()
        
        # Get the created route
        select_query = text("""
            SELECT id, route_id, name, territory_id, week_start_date, status, tenant_id, created_at, updated_at, created_by, updated_by
            FROM routes 
            WHERE route_id = :route_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(select_query, {
            "route_id": route_dict["route_id"],
            "tenant_id": tenant_id
        })
        created_route = result.fetchone()
        
        if created_route:
            return RouteResponse(
                id=created_route[0],
                route_id=created_route[1],
                name=created_route[2],
                territory_id=created_route[3],
                week_start_date=created_route[4],
                status=created_route[5],
                tenant_id=created_route[6],
                created_at=created_route[7],
                updated_at=created_route[8],
                created_by=created_route[9],
                updated_by=created_route[10]
            )
        else:
            raise HTTPException(status_code=500, detail="Failed to retrieve created route")
            
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/routes/{tenant_id}/{route_id}")
async def get_route_by_route_id(
    tenant_id: str,
    route_id: str,
    db=Depends(get_db)
):
    """Get a specific route by its business identifier (route_id) for a specific tenant"""
    try:
        query = text("""
            SELECT id, route_id, name, territory_id, week_start_date, status, tenant_id, created_at, updated_at, created_by, updated_by
            FROM routes 
            WHERE route_id = :route_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"route_id": route_id, "tenant_id": tenant_id})
        route = result.fetchone()
        
        if not route:
            raise HTTPException(status_code=404, detail="Route not found")
        
        return RouteResponse(
            id=route[0],
            route_id=route[1],
            name=route[2],
            territory_id=route[3],
            week_start_date=route[4],
            status=route[5],
            tenant_id=route[6],
            created_at=route[7],
            updated_at=route[8],
            created_by=route[9],
            updated_by=route[10]
        )
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error retrieving route: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.put("/api/routes/{tenant_id}/{route_id}")
async def update_route_by_route_id(
    tenant_id: str,
    route_id: str,
    route_data: RouteUpdate,
    db=Depends(get_db)
):
    """Update an existing route by its business identifier (route_id) for a specific tenant"""
    try:
        # First check if route exists
        check_query = text("""
            SELECT id FROM routes 
            WHERE route_id = :route_id AND tenant_id = :tenant_id
        """)
        
        existing_route = db.execute(check_query, {"route_id": route_id, "tenant_id": tenant_id}).fetchone()
        if not existing_route:
            raise HTTPException(status_code=404, detail="Route not found")
        
        route_db_id = existing_route[0]
        
        # Build update query dynamically based on provided fields
        route_dict = route_data.model_dump(exclude_unset=True) if hasattr(route_data, 'model_dump') else dict(route_data)
        
        if not route_dict:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Build dynamic UPDATE query
        set_clauses = []
        params = {"route_db_id": route_db_id, "tenant_id": tenant_id}
        
        for field, value in route_dict.items():
            if field in ["route_id", "name", "territory_id", "week_start_date", "status"]:
                set_clauses.append(f"{field} = :{field}")
                params[field] = value
        
        if set_clauses:
            set_clauses.append("updated_at = NOW()")
            if "updated_by" in route_dict:
                set_clauses.append("updated_by = :updated_by")
                params["updated_by"] = route_dict["updated_by"]
            
            update_query = text(f"""
                UPDATE routes 
                SET {', '.join(set_clauses)}
                WHERE id = :route_db_id AND tenant_id = :tenant_id
            """)
            
            db.execute(update_query, params)
            db.commit()
        
        # Get the updated route
        select_query = text("""
            SELECT id, route_id, name, territory_id, week_start_date, status, tenant_id, created_at, updated_at, created_by, updated_by
            FROM routes 
            WHERE id = :route_db_id
        """)
        
        result = db.execute(select_query, {"route_db_id": route_db_id})
        updated_route = result.fetchone()
        
        if updated_route:
            return RouteResponse(
                id=updated_route[0],
                route_id=updated_route[1],
                name=updated_route[2],
                territory_id=updated_route[3],
                week_start_date=updated_route[4],
                status=updated_route[5],
                tenant_id=updated_route[6],
                created_at=updated_route[7],
                updated_at=updated_route[8],
                created_by=updated_route[9],
                updated_by=updated_route[10]
            )
        else:
            raise HTTPException(status_code=500, detail="Failed to retrieve updated route")
            
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error updating route: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.delete("/api/routes/{tenant_id}/{route_id}")
async def delete_route_by_route_id(
    tenant_id: str,
    route_id: str,
    db=Depends(get_db)
):
    """Delete a route by its business identifier (route_id) for a specific tenant (hard delete)"""
    try:
        # First check if route exists
        check_query = text("""
            SELECT id FROM routes 
            WHERE route_id = :route_id AND tenant_id = :tenant_id
        """)
        
        existing_route = db.execute(check_query, {"route_id": route_id, "tenant_id": tenant_id}).fetchone()
        if not existing_route:
            raise HTTPException(status_code=404, detail="Route not found")
        
        route_db_id = existing_route[0]
        
        # Check if there are any route assignments (shops) linked to this route
        assignments_check_query = text("""
            SELECT COUNT(*) FROM route_assignments WHERE route_id = :route_db_id
        """)
        
        assignments_count = db.execute(assignments_check_query, {"route_db_id": route_db_id}).fetchone()[0]
        
        if assignments_count > 0:
            # Delete route assignments first (foreign key constraint)
            delete_assignments_query = text("""
                DELETE FROM route_assignments WHERE route_id = :route_db_id
            """)
            db.execute(delete_assignments_query, {"route_db_id": route_db_id})
        
        # Hard delete the route
        delete_route_query = text("""
            DELETE FROM routes WHERE id = :route_db_id AND tenant_id = :tenant_id
        """)
        
        db.execute(delete_route_query, {"route_db_id": route_db_id, "tenant_id": tenant_id})
        db.commit()
        
        return {"message": "Route deleted successfully"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error deleting route: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/routes/{tenant_id}/assignments", response_model=RouteAssignmentResponse)
async def create_route_assignment(
    tenant_id: str,
    assignment_data: RouteAssignmentCreate,
    db=Depends(get_db)
):
    """Create a new route assignment (add shop to route)"""
    try:
        # SECURITY: Always use the URL parameter tenant_id, ignore any tenant_id in request body
        insert_query = text("""
            INSERT INTO route_assignments (route_id, shop_id, sales_executive_id, planned_date, planned_time, sequence_order, status, created_at, updated_at)
            VALUES (:route_id, :shop_id, :sales_executive_id, :planned_date, :planned_time, :sequence_order, :status, NOW(), NOW())
        """)
        
        assignment_dict = assignment_data.model_dump() if hasattr(assignment_data, 'model_dump') else dict(assignment_data)
        
        # Validate that the route exists and belongs to the tenant
        route_check_query = text("""
            SELECT id FROM routes WHERE id = :route_id AND tenant_id = :tenant_id
        """)
        
        route_result = db.execute(route_check_query, {
            "route_id": assignment_dict["route_id"],
            "tenant_id": tenant_id
        })
        
        if not route_result.fetchone():
            raise HTTPException(status_code=404, detail="Route not found or access denied")
        
        db.execute(insert_query, {
            "route_id": assignment_dict["route_id"],
            "shop_id": assignment_dict["shop_id"],
            "sales_executive_id": assignment_dict["sales_executive_id"],
            "planned_date": assignment_dict["planned_date"],
            "planned_time": assignment_dict.get("planned_time"),
            "sequence_order": assignment_dict.get("sequence_order"),
            "status": assignment_dict.get("status", "planned")
        })
        
        db.commit()
        
        # Get the created assignment
        select_query = text("""
            SELECT id, route_id, shop_id, sales_executive_id, planned_date, planned_time, sequence_order, status, created_at, updated_at
            FROM route_assignments
            WHERE route_id = :route_id AND shop_id = :shop_id AND sales_executive_id = :sales_executive_id
        """)
        
        result = db.execute(select_query, {
            "route_id": assignment_dict["route_id"],
            "shop_id": assignment_dict["shop_id"],
            "sales_executive_id": assignment_dict["sales_executive_id"]
        })
        created_assignment = result.fetchone()
        
        if created_assignment:
            # Convert timedelta to time if needed
            planned_time_value = created_assignment[5]
            if planned_time_value and hasattr(planned_time_value, 'total_seconds'):
                # Convert timedelta to time
                total_seconds = int(planned_time_value.total_seconds())
                hours = total_seconds // 3600
                minutes = (total_seconds % 3600) // 60
                seconds = total_seconds % 60
                from datetime import time
                planned_time_value = time(hours, minutes, seconds)
            
            return RouteAssignmentResponse(
                id=created_assignment[0],
                route_id=created_assignment[1],
                shop_id=created_assignment[2],
                sales_executive_id=created_assignment[3],
                planned_date=created_assignment[4],
                planned_time=planned_time_value,
                sequence_order=created_assignment[6],
                status=created_assignment[7],
                created_at=created_assignment[8],
                updated_at=created_assignment[9]
            )
        else:
            raise HTTPException(status_code=500, detail="Failed to retrieve created assignment")
            
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.delete("/api/routes/{tenant_id}/assignments/{assignment_id}")
async def delete_route_assignment(
    tenant_id: str,
    assignment_id: str,
    db=Depends(get_db)
):
    """Delete a route assignment (remove shop from route)"""
    try:
        # Check if assignment exists
        check_query = text("""
            SELECT id FROM route_assignments 
            WHERE id = :assignment_id
        """)
        
        existing_assignment = db.execute(check_query, {"assignment_id": assignment_id}).fetchone()
        if not existing_assignment:
            raise HTTPException(status_code=404, detail="Route assignment not found")
        
        # Delete assignment
        delete_query = text("""
            DELETE FROM route_assignments 
            WHERE id = :assignment_id
        """)
        
        db.execute(delete_query, {"assignment_id": assignment_id})
        db.commit()
        
        return {
            "message": "Route assignment deleted successfully",
            "assignment_id": assignment_id
        }
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/routes/{tenant_id}/{route_id}/assignments", response_model=List[RouteAssignmentResponse])
async def get_route_assignments(
    tenant_id: str,
    route_id: str,
    db=Depends(get_db)
):
    """Get all shop assignments for a specific route"""
    try:
        # Check if route exists and belongs to tenant
        route_check_query = text("""
            SELECT id FROM routes 
            WHERE id = :route_id AND tenant_id = :tenant_id
        """)
        
        existing_route = db.execute(route_check_query, {"route_id": route_id, "tenant_id": tenant_id}).fetchone()
        if not existing_route:
            raise HTTPException(status_code=404, detail="Route not found")
        
        # Get assignments
        select_query = text("""
            SELECT id, route_id, shop_id, sales_executive_id, planned_date, planned_time, sequence_order, status, created_at, updated_at
            FROM route_assignments 
            WHERE route_id = :route_id
            ORDER BY sequence_order ASC, planned_date ASC
        """)
        
        result = db.execute(select_query, {"route_id": route_id})
        assignments = []
        
        for row in result:
            assignments.append(RouteAssignmentResponse(
                id=row[0],
                route_id=row[1],
                shop_id=row[2],
                sales_executive_id=row[3],
                planned_date=row[4],
                planned_time=row[5],
                sequence_order=row[6],
                status=row[7],
                created_at=row[8],
                updated_at=row[9]
            ))
        
        return assignments
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/route-assignments/{tenant_id}", response_model=List[RouteAssignmentResponse])
async def get_all_route_assignments(
    tenant_id: str,
    sales_executive_id: Optional[int] = None,
    territory_id: Optional[str] = None,
    route_id: Optional[str] = None,
    shop_id: Optional[str] = None,
    planned_date_from: Optional[date] = None,
    planned_date_to: Optional[date] = None,
    assignment_status: Optional[str] = None,
    db=Depends(get_db)
):
    """Get all route assignments for a tenant with optional filtering."""
    try:
        # Build base query with JOINs to get related data
        base_query = """
            SELECT DISTINCT
                ra.id,
                ra.route_id,
                ra.shop_id,
                ra.sales_executive_id,
                ra.planned_date,
                ra.planned_time,
                ra.sequence_order,
                ra.status,
                ra.created_at,
                ra.updated_at
            FROM route_assignments ra
            INNER JOIN routes r ON ra.route_id = r.id AND r.tenant_id = :tenant_id
            LEFT JOIN shops s ON ra.shop_id = s.shop_id AND s.tenant_id = :tenant_id
            LEFT JOIN users u ON ra.sales_executive_id = u.id AND u.tenant_id = :tenant_id
        """
        
        # Build WHERE conditions
        where_conditions = []
        params = {"tenant_id": tenant_id}
        
        if sales_executive_id:
            where_conditions.append("ra.sales_executive_id = :sales_executive_id")
            params["sales_executive_id"] = sales_executive_id
        
        if territory_id:
            where_conditions.append("r.territory_id = :territory_id")
            params["territory_id"] = territory_id
        
        if route_id:
            where_conditions.append("r.route_id = :route_id")
            params["route_id"] = route_id
        
        if shop_id:
            where_conditions.append("ra.shop_id = :shop_id")
            params["shop_id"] = shop_id
        
        if planned_date_from:
            where_conditions.append("ra.planned_date >= :planned_date_from")
            params["planned_date_from"] = planned_date_from
        
        if planned_date_to:
            where_conditions.append("ra.planned_date <= :planned_date_to")
            params["planned_date_to"] = planned_date_to
        
        if assignment_status:
            where_conditions.append("ra.status = :assignment_status")
            params["assignment_status"] = assignment_status
        
        # Construct final query
        if where_conditions:
            query = text(base_query + " WHERE " + " AND ".join(where_conditions) + " ORDER BY ra.planned_date DESC, ra.sequence_order ASC")
        else:
            query = text(base_query + " ORDER BY ra.planned_date DESC, ra.sequence_order ASC")
        
        result = db.execute(query, params)
        assignments = []
        
        for row in result:
            # Convert timedelta to time if needed
            planned_time_value = row[5]
            if planned_time_value and hasattr(planned_time_value, 'total_seconds'):
                # Convert timedelta to time
                total_seconds = int(planned_time_value.total_seconds())
                hours = total_seconds // 3600
                minutes = (total_seconds % 3600) // 60
                seconds = total_seconds % 60
                from datetime import time
                planned_time_value = time(hours, minutes, seconds)
            
            assignments.append(RouteAssignmentResponse(
                id=row[0],
                route_id=row[1],
                shop_id=row[2],
                sales_executive_id=row[3],
                planned_date=row[4],
                planned_time=planned_time_value,
                sequence_order=row[6],
                status=row[7],
                created_at=row[8],
                updated_at=row[9]
            ))
        
        return assignments
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/analytics/shop-performance/{tenant_id}", response_model=List[AnalyticsResponse])
async def get_shop_analytics(tenant_id: str, db=Depends(get_db)):
    """Get shop performance analytics for a specific tenant"""
    try:
        query = text("""
            SELECT 
                s.shop_id,
                s.name as shop_name,
                COUNT(v.id) as total_visits,
                MAX(v.checkin_time) as last_visit_date,
                COALESCE(o.amount_due, 0) as outstanding_amount,
                COALESCE(o.days_overdue, 0) as days_overdue,
                COALESCE(SUM(ol.qty * ol.rate), 0) as monthly_sales
            FROM shops s
            LEFT JOIN visits v ON s.shop_id = v.shop_id AND s.tenant_id = v.tenant_id
            LEFT JOIN outstandings o ON s.shop_id = o.shop_id AND s.tenant_id = o.tenant_id
            LEFT JOIN orders ord ON s.shop_id = ord.shop_id AND s.tenant_id = ord.tenant_id
            LEFT JOIN order_lines ol ON ord.order_id = ol.order_id
            WHERE s.tenant_id = :tenant_id
            GROUP BY s.shop_id, s.name, o.amount_due, o.days_overdue
            ORDER BY outstanding_amount DESC
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id})
        analytics = []
        
        for row in result:
            analytics.append(AnalyticsResponse(
                shop_id=row[0],
                shop_name=row[1],
                total_visits=row[2] or 0,
                last_visit_date=row[3],
                outstanding_amount=row[4] or 0.0,
                days_overdue=row[5] or 0,
                monthly_sales=row[6] or 0.0
            ))
        
        return analytics
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.post("/api/sync/client-data")
async def sync_client_data(tenant_id: str, sync_data: Dict[str, Any], db=Depends(get_db)):
    """Sync data from client's finance system (Tally-like)"""
    try:
        # This would contain the logic to sync data from the client's API
        # For now, we'll just log the sync request
        logger.info(f"Sync request received for tenant {tenant_id}")
        logger.info(f"Sync data: {sync_data}")
        
        # In a real implementation, this would:
        # 1. Validate the sync data
        # 2. Transform and normalize the data
        # 3. Insert/update records in the database
        # 4. Handle conflicts and data integrity
        
        return {
            "status": "success",
            "message": "Data sync initiated",
            "tenant_id": tenant_id,
            "sync_timestamp": datetime.now().isoformat(),
            "records_processed": len(sync_data.get("products", [])) + len(sync_data.get("shops", []))
        }
    except Exception as e:
        logger.error(f"Sync error: {e}")
        raise HTTPException(status_code=500, detail="Sync failed")


# Due Data / Outstanding Management Endpoints

class DueDataCreate(BaseModel):
    """Model for creating due data records."""
    shop_id: str
    shop_name: str
    amount: float
    due_date: date
    status: str
    sales_executive_id: Optional[int] = None
    territory_id: Optional[str] = None
    original_amount: Optional[float] = None
    days_overdue: Optional[int] = None
    last_payment_date: Optional[date] = None
    notes: Optional[str] = None
    created_by: Optional[int] = None
    updated_by: Optional[int] = None


class DueDataUpdate(BaseModel):
    """Model for updating due data records."""
    shop_name: Optional[str] = None
    amount: Optional[float] = None
    due_date: Optional[date] = None
    status: Optional[str] = None
    sales_executive_id: Optional[int] = None
    territory_id: Optional[str] = None
    original_amount: Optional[float] = None
    days_overdue: Optional[int] = None
    last_payment_date: Optional[date] = None
    notes: Optional[str] = None
    updated_by: Optional[int] = None


class NotificationResponse(BaseModel):
    """Response model for notification data."""
    id: int
    sender_id: int
    receiver_id: int
    subject: str
    notification_type: str
    related_data: Optional[Dict[str, Any]] = None
    is_confirmed: bool
    tenant_id: str
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None
    sender_name: Optional[str] = None
    receiver_name: Optional[str] = None


class NotificationCreate(BaseModel):
    """Model for creating notifications."""
    sender_id: int
    receiver_id: int
    subject: str
    notification_type: str
    related_data: Optional[Dict[str, Any]] = None
    is_confirmed: bool = False
    created_by: Optional[int] = None
    updated_by: Optional[int] = None


class NotificationUpdate(BaseModel):
    """Model for updating notifications."""
    subject: Optional[str] = None
    is_confirmed: Optional[bool] = None
    related_data: Optional[Dict[str, Any]] = None
    updated_by: Optional[int] = None


@app.post("/api/due-data/{tenant_id}")
async def create_due_data(tenant_id: str, data: DueDataCreate, db=Depends(get_db)):
    """Create a new due data record."""
    try:
        # Insert due data record
        query = text("""
            INSERT INTO due_data (
                shop_id, shop_name, amount, due_date, status, sales_executive_id, 
                territory_id, tenant_id, original_amount, days_overdue, 
                last_payment_date, notes, created_by, updated_by,
                created_at, updated_at
            ) VALUES (
                :shop_id, :shop_name, :amount, :due_date, :status, :sales_executive_id,
                :territory_id, :tenant_id, :original_amount, :days_overdue,
                :last_payment_date, :notes, :created_by, :updated_by,
                NOW(), NOW()
            )
        """)
        
        result = db.execute(query, {
            "shop_id": data.shop_id,
            "shop_name": data.shop_name,
            "amount": data.amount,
            "due_date": data.due_date,
            "status": data.status,
            "sales_executive_id": data.sales_executive_id,
            "territory_id": data.territory_id,
            "tenant_id": tenant_id,  # From URL parameter
            "original_amount": data.original_amount,
            "days_overdue": data.days_overdue,
            "last_payment_date": data.last_payment_date,
            "notes": data.notes,
            "created_by": data.created_by,
            "updated_by": data.updated_by
        })
        
        db.commit()
        
        # Get the created record with specific column order
        created_id = result.lastrowid
        created_record = db.execute(
            text("""
                SELECT id, shop_id, shop_name, amount, due_date, status, 
                       sales_executive_id, territory_id, tenant_id, original_amount, 
                       days_overdue, last_payment_date, notes, 
                       created_at, updated_at, created_by, updated_by
                FROM due_data 
                WHERE id = :id AND tenant_id = :tenant_id
            """),
            {"id": created_id, "tenant_id": tenant_id}
        ).fetchone()
        
        if not created_record:
            raise HTTPException(status_code=404, detail="Created record not found")
        
        return {
            "id": created_record[0],
            "shop_id": created_record[1],
            "shop_name": created_record[2],
            "amount": float(created_record[3]),
            "due_date": created_record[4],
            "status": created_record[5],
            "sales_executive_id": created_record[6],
            "territory_id": created_record[7],
            "tenant_id": created_record[8],
            "original_amount": float(created_record[9]) if created_record[9] else None,
            "days_overdue": created_record[10],
            "last_payment_date": created_record[11],
            "notes": created_record[12],
            "created_at": created_record[13],
            "updated_at": created_record[14],
            "created_by": created_record[15],
            "updated_by": created_record[16]
        }
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error creating due data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create due data: {str(e)}")


@app.get("/api/due-data/{tenant_id}")
async def get_due_data(
    tenant_id: str,
    sales_executive_id: Optional[int] = None,
    territory_id: Optional[str] = None,
    status: Optional[str] = None,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    shop_search: Optional[str] = None,
    min_amount: Optional[float] = None,
    max_amount: Optional[float] = None,
    db=Depends(get_db)
):
    """Get due data records with filtering."""
    try:
        # Build the query with filters
        where_conditions = ["d.tenant_id = :tenant_id"]
        params = {"tenant_id": tenant_id}
        
        if sales_executive_id:
            where_conditions.append("d.sales_executive_id = :sales_executive_id")
            params["sales_executive_id"] = sales_executive_id
        
        if territory_id:
            where_conditions.append("d.territory_id = :territory_id")
            params["territory_id"] = territory_id
        
        if status:
            where_conditions.append("d.status = :status")
            params["status"] = status
        
        if start_date:
            where_conditions.append("d.due_date >= :start_date")
            params["start_date"] = start_date
        
        if end_date:
            where_conditions.append("d.due_date <= :end_date")
            params["end_date"] = end_date
        
        if shop_search:
            where_conditions.append("d.shop_name LIKE :shop_search")
            params["shop_search"] = f"%{shop_search}%"
        
        if min_amount:
            where_conditions.append("d.amount >= :min_amount")
            params["min_amount"] = min_amount
        
        if max_amount:
            where_conditions.append("d.amount <= :max_amount")
            params["max_amount"] = max_amount
        
        where_clause = " AND ".join(where_conditions)
        
        # Working query with proper JOIN and column handling
        query = text(f"""
            SELECT 
                d.id,
                d.shop_id, 
                d.shop_name, 
                d.amount, 
                d.due_date, 
                d.status,
                d.sales_executive_id, 
                d.territory_id, 
                d.tenant_id, 
                d.original_amount,
                DATEDIFF(CURDATE(), d.due_date) as days_overdue, 
                d.last_payment_date, 
                d.notes, 
                d.last_sync_date,
                d.sync_status, 
                d.created_at, 
                d.updated_at, 
                d.created_by, 
                d.updated_by,
                COALESCE(NULLIF(u.name, ''), 'Unknown') as sales_executive_name,
                COALESCE(t.name, '') as territory_name
            FROM due_data d
            LEFT JOIN users u ON d.sales_executive_id = u.id AND d.tenant_id = u.tenant_id
            LEFT JOIN territories t ON d.territory_id = t.id AND d.tenant_id = t.tenant_id
            WHERE {where_clause}
            ORDER BY d.due_date, d.created_at DESC
        """)
        
        result = db.execute(query, params).fetchall()
        
        records = []
        for row in result:
            # Use explicit column name access for reliability
            records.append({
                "id": row.id,
                "shop_id": row.shop_id,
                "shop_name": row.shop_name,
                "amount": float(row.amount),
                "due_date": row.due_date,
                "status": row.status,
                "sales_executive_id": row.sales_executive_id,
                "territory_id": row.territory_id,
                "tenant_id": row.tenant_id,
                "original_amount": float(row.original_amount) if row.original_amount else None,
                "days_overdue": row.days_overdue,
                "last_payment_date": row.last_payment_date,
                "notes": row.notes,
                "last_sync_date": row.last_sync_date,
                "sync_status": row.sync_status,
                "created_at": row.created_at,
                "updated_at": row.updated_at,
                "created_by": row.created_by,
                "updated_by": row.updated_by,
                "sales_executive_name": row.sales_executive_name,
                "territory_name": row.territory_name
            })
        
        return records
        
    except Exception as e:
        logger.error(f"Error getting due data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get due data: {str(e)}")


@app.get("/api/due-data/{tenant_id}/summary")
async def get_due_data_summary(tenant_id: str, db=Depends(get_db)):
    """Get due data summary statistics."""
    try:
        query = text("""
            SELECT 
                COUNT(*) as total_records,
                SUM(amount) as total_outstanding,
                SUM(CASE WHEN status = 'current' THEN amount ELSE 0 END) as current_payments,
                SUM(CASE WHEN status = 'upcoming' THEN amount ELSE 0 END) as upcoming_payments,
                SUM(CASE WHEN status = 'overdue' THEN amount ELSE 0 END) as overdue_payments,
                COUNT(CASE WHEN status = 'current' THEN 1 END) as current_count,
                COUNT(CASE WHEN status = 'upcoming' THEN 1 END) as upcoming_count,
                COUNT(CASE WHEN status = 'overdue' THEN 1 END) as overdue_count,
                AVG(amount) as average_amount,
                MAX(CASE WHEN status = 'overdue' THEN days_overdue ELSE 0 END) as oldest_overdue_days
            FROM due_data 
            WHERE tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id}).fetchone()
        
        return {
            "total_records": result[0] or 0,
            "total_outstanding": float(result[1]) if result[1] else 0.0,
            "current_payments": float(result[2]) if result[2] else 0.0,
            "upcoming_payments": float(result[3]) if result[3] else 0.0,
            "overdue_payments": float(result[4]) if result[4] else 0.0,
            "current_count": result[5] or 0,
            "upcoming_count": result[6] or 0,
            "overdue_count": result[7] or 0,
            "average_amount": float(result[8]) if result[8] else 0.0,
            "oldest_overdue_days": result[9] or 0
        }
        
    except Exception as e:
        logger.error(f"Error getting due data summary: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get due data summary: {str(e)}")


@app.get("/api/due-data/{tenant_id}/{due_data_id}")
async def get_due_data_by_id(tenant_id: str, due_data_id: int, db=Depends(get_db)):
    """Get a specific due data record by ID."""
    try:
        query = text("""
            SELECT d.*, u.name as sales_executive_name, t.name as territory_name
            FROM due_data d
            LEFT JOIN users u ON d.sales_executive_id = u.id AND d.tenant_id = u.tenant_id
            LEFT JOIN territories t ON d.territory_id = t.id AND d.tenant_id = t.tenant_id
            WHERE d.id = :id AND d.tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"id": due_data_id, "tenant_id": tenant_id}).fetchone()
        
        if not result:
            raise HTTPException(status_code=404, detail="Due data record not found")
        
        return {
            "id": result[0],
            "shop_id": result[1],
            "shop_name": result[2],
            "amount": float(result[3]),
            "due_date": result[4],
            "status": result[5],
            "sales_executive_id": result[6],
            "territory_id": result[7],
            "tenant_id": result[8],
            "original_amount": float(result[9]) if result[9] else None,
            "days_overdue": result[10],
            "last_payment_date": result[11],
            "notes": result[12],
            "last_sync_date": result[13],
            "sync_status": result[14],
            "created_at": result[15],
            "updated_at": result[16],
            "created_by": result[17],
            "updated_by": result[18],
            "sales_executive_name": result[19],
            "territory_name": result[20]
        }
        
    except Exception as e:
        logger.error(f"Error getting due data by ID: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get due data: {str(e)}")


@app.put("/api/due-data/{tenant_id}/{due_data_id}")
async def update_due_data(tenant_id: str, due_data_id: int, data: DueDataUpdate, db=Depends(get_db)):
    """Update a due data record."""
    try:
        # Check if record exists
        existing = db.execute(
            text("SELECT id FROM due_data WHERE id = :id AND tenant_id = :tenant_id"),
            {"id": due_data_id, "tenant_id": tenant_id}
        ).fetchone()
        
        if not existing:
            raise HTTPException(status_code=404, detail="Due data record not found")
        
        # Build update query with only provided fields
        update_fields = []
        params = {"id": due_data_id, "tenant_id": tenant_id}
        
        if data.shop_name is not None:
            update_fields.append("shop_name = :shop_name")
            params["shop_name"] = data.shop_name
        
        if data.amount is not None:
            update_fields.append("amount = :amount")
            params["amount"] = data.amount
        
        if data.due_date is not None:
            update_fields.append("due_date = :due_date")
            params["due_date"] = data.due_date
        
        if data.status is not None:
            update_fields.append("status = :status")
            params["status"] = data.status
        
        if data.sales_executive_id is not None:
            update_fields.append("sales_executive_id = :sales_executive_id")
            params["sales_executive_id"] = data.sales_executive_id
        
        if data.territory_id is not None:
            update_fields.append("territory_id = :territory_id")
            params["territory_id"] = data.territory_id
        
        if data.original_amount is not None:
            update_fields.append("original_amount = :original_amount")
            params["original_amount"] = data.original_amount
        
        if data.days_overdue is not None:
            update_fields.append("days_overdue = :days_overdue")
            params["days_overdue"] = data.days_overdue
        
        if data.last_payment_date is not None:
            update_fields.append("last_payment_date = :last_payment_date")
            params["last_payment_date"] = data.last_payment_date
        
        if data.notes is not None:
            update_fields.append("notes = :notes")
            params["notes"] = data.notes
        
        if data.updated_by is not None:
            update_fields.append("updated_by = :updated_by")
            params["updated_by"] = data.updated_by
        
        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        update_fields.append("updated_at = NOW()")
        
        query = text(f"""
            UPDATE due_data 
            SET {', '.join(update_fields)}
            WHERE id = :id AND tenant_id = :tenant_id
        """)
        
        db.execute(query, params)
        db.commit()
        
        # Return updated record
        updated_record = db.execute(
            text("""
                SELECT d.*, u.name as sales_executive_name, t.name as territory_name
                FROM due_data d
                LEFT JOIN users u ON d.sales_executive_id = u.id AND d.tenant_id = u.tenant_id
                LEFT JOIN territories t ON d.territory_id = t.id AND d.tenant_id = t.tenant_id
                WHERE d.id = :id AND d.tenant_id = :tenant_id
            """),
            {"id": due_data_id, "tenant_id": tenant_id}
        ).fetchone()
        
        return {
            "id": updated_record[0],
            "shop_id": updated_record[1],
            "shop_name": updated_record[2],
            "amount": float(updated_record[3]),
            "due_date": updated_record[4],
            "status": updated_record[5],
            "sales_executive_id": updated_record[6],
            "territory_id": updated_record[7],
            "tenant_id": updated_record[8],
            "original_amount": float(updated_record[9]) if updated_record[9] else None,
            "days_overdue": updated_record[10],
            "last_payment_date": updated_record[11],
            "notes": updated_record[12],
            "last_sync_date": updated_record[13],
            "sync_status": updated_record[14],
            "created_at": updated_record[15],
            "updated_at": updated_record[16],
            "created_by": updated_record[17],
            "updated_by": updated_record[18],
            "sales_executive_name": updated_record[19],
            "territory_name": updated_record[20]
        }
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error updating due data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update due data: {str(e)}")


@app.delete("/api/due-data/{tenant_id}/{due_data_id}")
async def delete_due_data(tenant_id: str, due_data_id: int, db=Depends(get_db)):
    """Delete a due data record."""
    try:
        # Check if record exists
        existing = db.execute(
            text("SELECT id FROM due_data WHERE id = :id AND tenant_id = :tenant_id"),
            {"id": due_data_id, "tenant_id": tenant_id}
        ).fetchone()
        
        if not existing:
            raise HTTPException(status_code=404, detail="Due data record not found")
        
        # Delete the record
        db.execute(
            text("DELETE FROM due_data WHERE id = :id AND tenant_id = :tenant_id"),
            {"id": due_data_id, "tenant_id": tenant_id}
        )
        db.commit()
        
        return {"message": "Due data record deleted successfully"}
        
    except Exception as e:
        db.rollback()
        logger.error(f"Error deleting due data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to delete due data: {str(e)}")


# ------------------ Analytics Endpoints ------------------

@app.get("/api/analytics/executive/{executive_id}/top-customers")
async def get_executive_top_customers(
    executive_id: int, 
    tenant_id: str = Query(...), 
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    db=Depends(get_db)
):
    """Get top customers for a sales executive based on total outstanding amounts."""
    try:
        # Get shops assigned to this sales executive
        shops_query = text("""
            SELECT DISTINCT s.shop_id, s.name as shop_name
            FROM sales_executive_assignments sea
            JOIN shops s ON sea.shop_id = s.shop_id AND sea.tenant_id = s.tenant_id
            WHERE sea.sales_executive_id = :executive_id 
            AND sea.tenant_id = :tenant_id 
            AND sea.status = 'active'
        """)
        
        shops = db.execute(shops_query, {
            "executive_id": executive_id,
            "tenant_id": tenant_id
        }).fetchall()
        
        if not shops:
            return []
        
        # Get outstanding amounts for each shop
        shop_ids = [shop[0] for shop in shops]
        placeholders = ','.join([':shop_id_' + str(i) for i in range(len(shop_ids))])
        
        outstanding_query = text(f"""
            SELECT 
                dd.shop_id,
                dd.shop_name,
                COALESCE(SUM(dd.amount), 0) as total_amount
            FROM due_data dd
            WHERE dd.shop_id IN ({placeholders})
            AND dd.tenant_id = :tenant_id
            {"AND dd.due_date >= :start_date" if start_date else ""}
            {"AND dd.due_date <= :end_date" if end_date else ""}
            GROUP BY dd.shop_id, dd.shop_name
            ORDER BY total_amount DESC
        """)
        
        params = {"tenant_id": tenant_id}
        for i, shop_id in enumerate(shop_ids):
            params[f"shop_id_{i}"] = shop_id
        
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
        
        results = db.execute(outstanding_query, params).fetchall()
        
        return [
            {
                "shop_name": row[1],
                "points": float(row[2])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting executive top customers: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get top customers: {str(e)}")


@app.get("/api/analytics/tenant/top-customers")
async def get_tenant_top_customers(
    tenant_id: str = Query(...), 
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    db=Depends(get_db)
):
    """Get top customers for entire tenant (aggregated view)."""
    try:
        # Get all shops with their outstanding amounts
        shops_query = text("""
            SELECT 
                s.shop_id,
                s.name as shop_name,
                COALESCE(SUM(dd.amount), 0) as total_amount
            FROM shops s
            LEFT JOIN due_data dd ON s.shop_id = dd.shop_id AND s.tenant_id = dd.tenant_id
            WHERE s.tenant_id = :tenant_id
            """ + ("AND dd.due_date >= :start_date" if start_date else "") + """
            """ + ("AND dd.due_date <= :end_date" if end_date else "") + """
            GROUP BY s.shop_id, s.name
            ORDER BY total_amount DESC
        """)

        params = {"tenant_id": tenant_id}
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        results = db.execute(shops_query, params).fetchall()

        return [
            {
                "shop_name": row[1],
                "points": float(row[2])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting tenant top customers: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get tenant top customers: {str(e)}")


@app.get("/api/analytics/territory/{territory_id}/top-customers")
async def get_territory_top_customers(territory_id: str, tenant_id: str = Query(...), db=Depends(get_db)):
    """Get top customers for a specific territory (aggregated view)."""
    try:
        # Get shops in this territory with their outstanding amounts
        shops_query = text("""
            SELECT 
                s.shop_id,
                s.name as shop_name,
                COALESCE(SUM(dd.amount), 0) as total_amount
            FROM shops s
            LEFT JOIN due_data dd ON s.shop_id = dd.shop_id AND s.tenant_id = dd.tenant_id
            WHERE s.territory_id = :territory_id
            AND s.tenant_id = :tenant_id
            GROUP BY s.shop_id, s.name
            ORDER BY total_amount DESC
        """)

        results = db.execute(shops_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id
        }).fetchall()

        return [
            {
                "shop_name": row[1],
                "points": float(row[2])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting territory top customers: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get territory top customers: {str(e)}")


@app.get("/api/analytics/area-manager/{area_manager_id}/top-customers")
async def get_area_manager_top_customers(area_manager_id: int, tenant_id: str = Query(...), db=Depends(get_db)):
    """Get top customers for all territories managed by an area manager."""
    try:
        # Get territories managed by this area manager
        territories_query = text("""
            SELECT territory_id 
            FROM territories 
            WHERE area_manager_id = :area_manager_id 
            AND tenant_id = :tenant_id
        """)
        
        territory_results = db.execute(territories_query, {
            "area_manager_id": area_manager_id,
            "tenant_id": tenant_id
        }).fetchall()
        
        if not territory_results:
            return []
        
        territory_ids = [row[0] for row in territory_results]
        
        # Get shops in these territories with their outstanding amounts
        shops_query = text("""
            SELECT 
                s.shop_id,
                s.name as shop_name,
                COALESCE(SUM(dd.amount), 0) as total_amount
            FROM shops s
            LEFT JOIN due_data dd ON s.shop_id = dd.shop_id AND s.tenant_id = dd.tenant_id
            WHERE s.territory_id IN :territory_ids
            AND s.tenant_id = :tenant_id
            GROUP BY s.shop_id, s.name
            ORDER BY total_amount DESC
        """)

        results = db.execute(shops_query, {
            "territory_ids": tuple(territory_ids),
            "tenant_id": tenant_id
        }).fetchall()

        return [
            {
                "shop_name": row[1],
                "points": float(row[2])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting area manager top customers: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get area manager top customers: {str(e)}")


@app.get("/api/analytics/executive/{executive_id}/best-selling-products")
async def get_executive_best_selling_products(
    executive_id: int, 
    tenant_id: str = Query(...), 
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    db=Depends(get_db)
):
    """Get best selling products for a sales executive."""
    try:
        # Get products sold by this executive
        products_query = text("""
            SELECT 
                sp.product_name,
                COUNT(*) as units_sold
            FROM synced_products sp
            WHERE sp.sales_executive_id = :executive_id 
            AND sp.tenant_id = :tenant_id
            """ + ("AND sp.created_at >= :start_date" if start_date else "") + """
            """ + ("AND sp.created_at <= :end_date" if end_date else "") + """
            GROUP BY sp.product_name
            ORDER BY units_sold DESC
        """)
        
        executive_products = db.execute(products_query, {
            "executive_id": executive_id,
            "tenant_id": tenant_id,
            **({"start_date": start_date} if start_date else {}),
            **({"end_date": end_date} if end_date else {})
        }).fetchall()
        
        if not executive_products:
            return []
        
        # Get total units sold across all executives for percentage calculation
        total_query = text("""
            SELECT COUNT(*) as total_units
            FROM synced_products sp
            WHERE sp.tenant_id = :tenant_id
            """ + ("AND sp.created_at >= :start_date" if start_date else "") + """
            """ + ("AND sp.created_at <= :end_date" if end_date else "") + """
        """)
        
        total_result = db.execute(total_query, {
            "tenant_id": tenant_id,
            **({"start_date": start_date} if start_date else {}),
            **({"end_date": end_date} if end_date else {})
        }).fetchone()
        total_units = total_result[0] if total_result else 0
        
        return [
            {
                "product_name": row[0],
                "units_sold": row[1],
                "percentage": round((row[1] / total_units * 100), 2) if total_units > 0 else 0
            }
            for row in executive_products
        ]
        
    except Exception as e:
        logger.error(f"Error getting executive best selling products: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get best selling products: {str(e)}")


@app.get("/api/analytics/tenant/best-selling-products")
async def get_tenant_best_selling_products(tenant_id: str = Query(...), db=Depends(get_db)):
    """Get best selling products for entire tenant (aggregated view)."""
    try:
        # Get products sold across all executives in the tenant
        products_query = text("""
            SELECT 
                sp.product_name,
                COUNT(*) as units_sold
            FROM synced_products sp
            WHERE sp.tenant_id = :tenant_id
            GROUP BY sp.product_name
            ORDER BY units_sold DESC
        """)

        results = db.execute(products_query, {"tenant_id": tenant_id}).fetchall()

        if not results:
            return []

        # Calculate total units sold across all executives
        total_units = sum(row[1] for row in results)

        return [
            {
                "product_name": row[0],
                "units_sold": int(row[1]),
                "percentage": round((row[1] / total_units) * 100, 2) if total_units > 0 else 0
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting tenant best selling products: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get tenant best selling products: {str(e)}")


@app.get("/api/analytics/territory/{territory_id}/best-selling-products")
async def get_territory_best_selling_products(territory_id: str, tenant_id: str = Query(...), db=Depends(get_db)):
    """Get best selling products for a specific territory (aggregated view)."""
    try:
        # Get products sold by executives in this territory
        products_query = text("""
            SELECT 
                sp.product_name,
                COUNT(*) as units_sold
            FROM synced_products sp
            JOIN users u ON sp.sales_executive_id = u.id
            WHERE u.territory_id = :territory_id
            AND sp.tenant_id = :tenant_id
            GROUP BY sp.product_name
            ORDER BY units_sold DESC
        """)

        results = db.execute(products_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id
        }).fetchall()

        if not results:
            return []

        # Calculate total units sold in this territory
        total_units = sum(row[1] for row in results)

        return [
            {
                "product_name": row[0],
                "units_sold": int(row[1]),
                "percentage": round((row[1] / total_units) * 100, 2) if total_units > 0 else 0
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting territory best selling products: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get territory best selling products: {str(e)}")


@app.get("/api/analytics/area-manager/{area_manager_id}/best-selling-products")
async def get_area_manager_best_selling_products(area_manager_id: int, tenant_id: str = Query(...), db=Depends(get_db)):
    """Get best selling products for all territories managed by an area manager."""
    try:
        # Get territories managed by this area manager
        territories_query = text("""
            SELECT territory_id 
            FROM territories 
            WHERE area_manager_id = :area_manager_id 
            AND tenant_id = :tenant_id
        """)
        
        territory_results = db.execute(territories_query, {
            "area_manager_id": area_manager_id,
            "tenant_id": tenant_id
        }).fetchall()
        
        if not territory_results:
            return []
        
        territory_ids = [row[0] for row in territory_results]
        
        # Get products sold by executives in these territories
        products_query = text("""
            SELECT 
                sp.product_name,
                COUNT(*) as units_sold
            FROM synced_products sp
            JOIN users u ON sp.sales_executive_id = u.id
            WHERE u.territory_id IN :territory_ids
            AND sp.tenant_id = :tenant_id
            GROUP BY sp.product_name
            ORDER BY units_sold DESC
        """)

        results = db.execute(products_query, {
            "territory_ids": tuple(territory_ids),
            "tenant_id": tenant_id
        }).fetchall()

        if not results:
            return []

        # Calculate total units sold in these territories
        total_units = sum(row[1] for row in results)

        return [
            {
                "product_name": row[0],
                "units_sold": int(row[1]),
                "percentage": round((row[1] / total_units) * 100, 2) if total_units > 0 else 0
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting area manager best selling products: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get area manager best selling products: {str(e)}")


@app.get("/api/analytics/executive/{executive_id}/sales-report")
async def get_executive_sales_report(
    executive_id: int, 
    tenant_id: str = Query(...),
    start_date: Optional[str] = Query(None),
    end_date: Optional[str] = Query(None),
    db=Depends(get_db)
):
    """Get sales report for a sales executive for the specified period."""
    try:
        # Get sales data for the executive in the specified period
        sales_query = text("""
            SELECT 
                DATE_FORMAT(so.order_date, '%Y-%m') as month_year,
                SUM(so.order_amount) as total_amount
            FROM synced_orders so
            WHERE so.sales_executive_id = :executive_id 
            AND so.tenant_id = :tenant_id
            """ + ("AND so.order_date >= :start_date" if start_date else "") + """
            """ + ("AND so.order_date <= :end_date" if end_date else "") + """
            GROUP BY DATE_FORMAT(so.order_date, '%Y-%m')
            ORDER BY month_year
        """)
        
        params = {
            "executive_id": executive_id,
            "tenant_id": tenant_id
        }
        if start_date:
            params["start_date"] = start_date
        if end_date:
            params["end_date"] = end_date
            
        results = db.execute(sales_query, params).fetchall()
        
        return [
            {
                "month_year": row[0],
                "sale_point": float(row[1])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting executive sales report: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get sales report: {str(e)}")


@app.get("/api/analytics/tenant/sales-report")
async def get_tenant_sales_report(
    tenant_id: str = Query(...),
    start_date: str = Query(...),
    end_date: str = Query(...),
    db=Depends(get_db)
):
    """Get sales report for entire tenant (aggregated view)."""
    try:
        # Get monthly sales data across all executives in the tenant
        sales_query = text("""
            SELECT 
                DATE_FORMAT(so.order_date, '%Y-%m') as month_year,
                SUM(so.order_amount) as total_amount
            FROM synced_orders so
            WHERE so.tenant_id = :tenant_id
            AND so.order_date BETWEEN :start_date AND :end_date
            GROUP BY DATE_FORMAT(so.order_date, '%Y-%m')
            ORDER BY month_year
        """)
        
        results = db.execute(sales_query, {
            "tenant_id": tenant_id,
            "start_date": start_date,
            "end_date": end_date
        }).fetchall()
        
        return [
            {
                "month_year": row[0],
                "sale_point": float(row[1])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting tenant sales report: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get tenant sales report: {str(e)}")


@app.get("/api/analytics/territory/{territory_id}/sales-report")
async def get_territory_sales_report(
    territory_id: str,
    tenant_id: str = Query(...),
    start_date: str = Query(...),
    end_date: str = Query(...),
    db=Depends(get_db)
):
    """Get sales report for a specific territory (aggregated view)."""
    try:
        # Get monthly sales data by executives in this territory
        sales_query = text("""
            SELECT 
                DATE_FORMAT(so.order_date, '%Y-%m') as month_year,
                SUM(so.order_amount) as total_amount
            FROM synced_orders so
            JOIN users u ON so.sales_executive_id = u.id
            WHERE u.territory_id = :territory_id
            AND so.tenant_id = :tenant_id
            AND so.order_date BETWEEN :start_date AND :end_date
            GROUP BY DATE_FORMAT(so.order_date, '%Y-%m')
            ORDER BY month_year
        """)
        
        results = db.execute(sales_query, {
            "territory_id": territory_id,
            "tenant_id": tenant_id,
            "start_date": start_date,
            "end_date": end_date
        }).fetchall()
        
        return [
            {
                "month_year": row[0],
                "sale_point": float(row[1])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting territory sales report: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get territory sales report: {str(e)}")


@app.get("/api/analytics/area-manager/{area_manager_id}/sales-report")
async def get_area_manager_sales_report(
    area_manager_id: int,
    tenant_id: str = Query(...),
    start_date: str = Query(...),
    end_date: str = Query(...),
    db=Depends(get_db)
):
    """Get sales report for all territories managed by an area manager."""
    try:
        # Get territories managed by this area manager
        territories_query = text("""
            SELECT territory_id 
            FROM territories 
            WHERE area_manager_id = :area_manager_id 
            AND tenant_id = :tenant_id
        """)
        
        territory_results = db.execute(territories_query, {
            "area_manager_id": area_manager_id,
            "tenant_id": tenant_id
        }).fetchall()
        
        if not territory_results:
            return []
        
        territory_ids = [row[0] for row in territory_results]
        
        # Get monthly sales data by executives in these territories
        sales_query = text("""
            SELECT 
                DATE_FORMAT(so.order_date, '%Y-%m') as month_year,
                SUM(so.order_amount) as total_amount
            FROM synced_orders so
            JOIN users u ON so.sales_executive_id = u.id
            WHERE u.territory_id IN :territory_ids
            AND so.tenant_id = :tenant_id
            AND so.order_date BETWEEN :start_date AND :end_date
            GROUP BY DATE_FORMAT(so.order_date, '%Y-%m')
            ORDER BY month_year
        """)
        
        results = db.execute(sales_query, {
            "territory_ids": tuple(territory_ids),
            "tenant_id": tenant_id,
            "start_date": start_date,
            "end_date": end_date
        }).fetchall()
        
        return [
            {
                "month_year": row[0],
                "sale_point": float(row[1])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting area manager sales report: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get area manager sales report: {str(e)}")


@app.get("/api/analytics/shops/{shop_id}/purchase-analysis")
async def get_shop_purchase_analysis(
    shop_id: str, 
    tenant_id: str = Query(...),
    year: int = Query(...),
    db=Depends(get_db)
):
    """Get purchase analysis for a shop for the specified year."""
    try:
        # Get purchase data for the shop in the specified year
        purchases_query = text("""
            SELECT 
                DATE_FORMAT(so.order_date, '%Y-%m') as month_year
            FROM synced_orders so
            WHERE so.shop_data_id IN (
                SELECT id FROM synced_shop_data 
                WHERE shop_id = :shop_id AND tenant_id = :tenant_id
            )
            AND YEAR(so.order_date) = :year
            GROUP BY DATE_FORMAT(so.order_date, '%Y-%m')
        """)
        
        results = db.execute(purchases_query, {
            "shop_id": shop_id,
            "tenant_id": tenant_id,
            "year": year
        }).fetchall()
        
        # Create a set of months with purchases
        purchase_months = {row[0] for row in results}
        
        # Generate analysis for all months in the year
        analysis = []
        for month in range(1, 13):
            month_year = f"{year}-{month:02d}"
            analysis.append({
                "month_year": month_year,
                "is_purchased": month_year in purchase_months
            })
        
        return analysis
        
    except Exception as e:
        logger.error(f"Error getting shop purchase analysis: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get purchase analysis: {str(e)}")


@app.get("/api/analytics/shops/{shop_id}/best-selling-products")
async def get_shop_best_selling_products(
    shop_id: str, 
    tenant_id: str = Query(...),
    year: int = Query(...),
    db=Depends(get_db)
):
    """Get best selling products for a shop for the specified year."""
    try:
        # Get products sold to this shop
        products_query = text("""
            SELECT 
                sp.product_name,
                COUNT(*) as units_sold
            FROM synced_products sp
            JOIN synced_orders so ON sp.order_id = so.id
            JOIN synced_shop_data ssd ON so.shop_data_id = ssd.id
            WHERE ssd.shop_id = :shop_id 
            AND ssd.tenant_id = :tenant_id
            AND YEAR(so.order_date) = :year
            GROUP BY sp.product_name
            ORDER BY units_sold DESC
        """)
        
        shop_products = db.execute(products_query, {
            "shop_id": shop_id,
            "tenant_id": tenant_id,
            "year": year
        }).fetchall()
        
        if not shop_products:
            return []
        
        # Get total units sold across all shops for percentage calculation
        total_query = text("""
            SELECT COUNT(*) as total_units
            FROM synced_products sp
            JOIN synced_orders so ON sp.order_id = so.id
            WHERE so.tenant_id = :tenant_id
            AND YEAR(so.order_date) = :year
        """)
        
        total_result = db.execute(total_query, {
            "tenant_id": tenant_id,
            "year": year
        }).fetchone()
        total_units = total_result[0] if total_result else 0
        
        return [
            {
                "product_name": row[0],
                "units_sold": row[1],
                "percentage": round((row[1] / total_units * 100), 2) if total_units > 0 else 0
            }
            for row in shop_products
        ]
        
    except Exception as e:
        logger.error(f"Error getting shop best selling products: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get best selling products: {str(e)}")


@app.get("/api/analytics/shops/{shop_id}/sales-report")
async def get_shop_sales_report(
    shop_id: str, 
    tenant_id: str = Query(...),
    year: int = Query(...),
    db=Depends(get_db)
):
    """Get sales report for a shop for the specified year."""
    try:
        # Get sales data for the shop in the specified year
        sales_query = text("""
            SELECT 
                DATE_FORMAT(so.order_date, '%Y-%m') as month_year,
                SUM(so.order_amount) as total_amount
            FROM synced_orders so
            JOIN synced_shop_data ssd ON so.shop_data_id = ssd.id
            WHERE ssd.shop_id = :shop_id 
            AND ssd.tenant_id = :tenant_id
            AND YEAR(so.order_date) = :year
            GROUP BY DATE_FORMAT(so.order_date, '%Y-%m')
            ORDER BY month_year
        """)
        
        results = db.execute(sales_query, {
            "shop_id": shop_id,
            "tenant_id": tenant_id,
            "year": year
        }).fetchall()
        
        return [
            {
                "month_year": row[0],
                "sale_point": float(row[1])
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting shop sales report: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get sales report: {str(e)}")


# ------------------ Assignment Management Endpoints ------------------

@app.get("/api/assignments/executive/{executive_id}/shops")
async def get_executive_shop_assignments(executive_id: int, tenant_id: str = Query(...), db=Depends(get_db)):
    """Get all shop assignments for a sales executive."""
    try:
        query = text("""
            SELECT 
                sea.id,
                sea.shop_id,
                s.name as shop_name,
                sea.territory_id,
                t.name as territory_name,
                sea.assigned_date,
                sea.status,
                sea.created_at,
                sea.updated_at
            FROM sales_executive_assignments sea
            JOIN shops s ON sea.shop_id = s.shop_id AND sea.tenant_id = s.tenant_id
            LEFT JOIN territories t ON sea.territory_id = t.territory_id AND sea.tenant_id = t.tenant_id
            WHERE sea.sales_executive_id = :executive_id 
            AND sea.tenant_id = :tenant_id
            ORDER BY sea.assigned_date DESC
        """)
        
        results = db.execute(query, {
            "executive_id": executive_id,
            "tenant_id": tenant_id
        }).fetchall()
        
        return [
            {
                "id": row[0],
                "shop_id": row[1],
                "shop_name": row[2],
                "territory_id": row[3],
                "territory_name": row[4],
                "assigned_date": row[5],
                "status": row[6],
                "created_at": row[7],
                "updated_at": row[8]
            }
            for row in results
        ]
        
    except Exception as e:
        logger.error(f"Error getting executive shop assignments: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to get shop assignments: {str(e)}")


@app.post("/api/assignments/executive-shop")
async def create_executive_shop_assignment(assignment_data: dict, db=Depends(get_db)):
    """Create a new sales executive to shop assignment."""
    try:
        # Validate required fields
        required_fields = ["sales_executive_id", "shop_id", "territory_id", "tenant_id", "assigned_date"]
        for field in required_fields:
            if field not in assignment_data:
                raise HTTPException(status_code=400, detail=f"Missing required field: {field}")
        
        # Check if assignment already exists
        existing = db.execute(
            text("""
                SELECT id FROM sales_executive_assignments 
                WHERE sales_executive_id = :executive_id 
                AND shop_id = :shop_id 
                AND tenant_id = :tenant_id
            """),
            {
                "executive_id": assignment_data["sales_executive_id"],
                "shop_id": assignment_data["shop_id"],
                "tenant_id": assignment_data["tenant_id"]
            }
        ).fetchone()
        
        if existing:
            raise HTTPException(status_code=409, detail="Assignment already exists")
        
        # Create the assignment
        insert_query = text("""
            INSERT INTO sales_executive_assignments 
            (sales_executive_id, shop_id, territory_id, tenant_id, assigned_date, status, created_by, updated_by)
            VALUES (:sales_executive_id, :shop_id, :territory_id, :tenant_id, :assigned_date, :status, :created_by, :updated_by)
        """)
        
        db.execute(insert_query, {
            "sales_executive_id": assignment_data["sales_executive_id"],
            "shop_id": assignment_data["shop_id"],
            "territory_id": assignment_data["territory_id"],
            "tenant_id": assignment_data["tenant_id"],
            "assigned_date": assignment_data["assigned_date"],
            "status": assignment_data.get("status", "active"),
            "created_by": assignment_data.get("created_by"),
            "updated_by": assignment_data.get("updated_by")
        })
        db.commit()
        
        return {"message": "Assignment created successfully"}
        
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error creating executive shop assignment: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create assignment: {str(e)}")


# Email Authentication Endpoints

@app.post("/api/user-auth/{tenant_id}", response_model=UserAuthResponse)
async def create_user_auth(tenant_id: str, auth_data: UserAuthCreate, db=Depends(get_db)):
    """Create email authentication record for a user"""
    try:
        # Verify user exists and belongs to tenant
        user_check = text("""
            SELECT id, role FROM users 
            WHERE id = :user_id AND tenant_id = :tenant_id 
            AND role IN ('client_admin', 'superadmin')
        """)
        
        user_result = db.execute(user_check, {
            "user_id": auth_data.user_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not user_result:
            raise HTTPException(status_code=404, detail="User not found or not eligible for email authentication")
        
        # Check if email already exists for this tenant
        email_check = text("""
            SELECT id FROM user_auth 
            WHERE email = :email AND tenant_id = :tenant_id
        """)
        
        existing_email = db.execute(email_check, {
            "email": auth_data.email,
            "tenant_id": tenant_id
        }).fetchone()
        
        if existing_email:
            raise HTTPException(status_code=409, detail="Email already exists for this tenant")
        
        # Check if user already has auth record
        auth_check = text("""
            SELECT id FROM user_auth 
            WHERE user_id = :user_id
        """)
        
        existing_auth = db.execute(auth_check, {
            "user_id": auth_data.user_id
        }).fetchone()
        
        if existing_auth:
            raise HTTPException(status_code=409, detail="User already has authentication record")
        
        # Create auth record
        insert_query = text("""
            INSERT INTO user_auth (user_id, email, password_hash, tenant_id, created_at, updated_at, created_by, updated_by)
            VALUES (:user_id, :email, :password_hash, :tenant_id, NOW(), NOW(), :created_by, :updated_by)
        """)
        
        result = db.execute(insert_query, {
            "user_id": auth_data.user_id,
            "email": auth_data.email,
            "password_hash": auth_data.password_hash,
            "tenant_id": tenant_id,
            "created_by": auth_data.created_by,
            "updated_by": auth_data.updated_by
        })
        
        db.commit()
        
        # Get the created auth record
        auth_id = result.lastrowid
        select_query = text("""
            SELECT id, user_id, email, last_login, login_attempts, locked_until, tenant_id, created_at, updated_at
            FROM user_auth 
            WHERE id = :auth_id
        """)
        
        auth_result = db.execute(select_query, {"auth_id": auth_id})
        auth_row = auth_result.fetchone()
        
        return UserAuthResponse(
            id=auth_row[0],
            user_id=auth_row[1],
            email=auth_row[2],
            last_login=auth_row[3],
            login_attempts=auth_row[4],
            locked_until=auth_row[5],
            tenant_id=auth_row[6],
            created_at=auth_row[7],
            updated_at=auth_row[8]
        )
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/user-auth/{tenant_id}/by-email")
async def get_user_auth_by_email(tenant_id: str, email: str = Query(...), db=Depends(get_db)):
    """Get user authentication record by email"""
    try:
        query = text("""
            SELECT ua.id, ua.user_id, ua.email, ua.password_hash, ua.last_login, 
                   ua.login_attempts, ua.locked_until, ua.tenant_id, ua.created_at, ua.updated_at,
                   u.name, u.role, u.status
            FROM user_auth ua
            INNER JOIN users u ON ua.user_id = u.id
            WHERE ua.email = :email AND ua.tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"email": email, "tenant_id": tenant_id})
        row = result.fetchone()
        
        if not row:
            raise HTTPException(status_code=404, detail="User authentication record not found")
        
        return {
            "id": row[0],
            "user_id": row[1],
            "email": row[2],
            "password_hash": row[3],
            "last_login": row[4],
            "login_attempts": row[5],
            "locked_until": row[6],
            "tenant_id": row[7],
            "created_at": row[8],
            "updated_at": row[9],
            "user_name": row[10],
            "user_role": row[11],
            "user_status": row[12]
        }
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.put("/api/user-auth/{tenant_id}/{user_id}")
async def update_user_auth(tenant_id: str, user_id: str, auth_data: UserAuthUpdate, db=Depends(get_db)):
    """Update user authentication record"""
    try:
        # Check if auth record exists
        check_query = text("""
            SELECT id FROM user_auth 
            WHERE user_id = :user_id AND tenant_id = :tenant_id
        """)
        
        existing_auth = db.execute(check_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not existing_auth:
            raise HTTPException(status_code=404, detail="User authentication record not found")
        
        # Build dynamic UPDATE query based on provided fields
        update_fields = []
        params = {"user_id": user_id, "tenant_id": tenant_id}
        
        if auth_data.email is not None:
            # Check email uniqueness within tenant
            email_check = text("""
                SELECT id FROM user_auth 
                WHERE email = :email AND tenant_id = :tenant_id AND user_id != :user_id
            """)
            
            existing_email = db.execute(email_check, {
                "email": auth_data.email,
                "tenant_id": tenant_id,
                "user_id": user_id
            }).fetchone()
            
            if existing_email:
                raise HTTPException(status_code=409, detail="Email already exists for this tenant")
            
            update_fields.append("email = :email")
            params["email"] = auth_data.email
        
        if auth_data.password_hash is not None:
            update_fields.append("password_hash = :password_hash")
            params["password_hash"] = auth_data.password_hash
        
        if auth_data.reset_token is not None:
            update_fields.append("reset_token = :reset_token")
            params["reset_token"] = auth_data.reset_token
        
        if auth_data.reset_token_expires is not None:
            update_fields.append("reset_token_expires = :reset_token_expires")
            params["reset_token_expires"] = auth_data.reset_token_expires
        
        if auth_data.last_login is not None:
            update_fields.append("last_login = :last_login")
            params["last_login"] = auth_data.last_login
        
        if auth_data.login_attempts is not None:
            update_fields.append("login_attempts = :login_attempts")
            params["login_attempts"] = auth_data.login_attempts
        
        if auth_data.locked_until is not None:
            update_fields.append("locked_until = :locked_until")
            params["locked_until"] = auth_data.locked_until
        
        if not update_fields:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        # Add timestamp and updated_by
        update_fields.append("updated_at = NOW()")
        if auth_data.updated_by is not None:
            update_fields.append("updated_by = :updated_by")
            params["updated_by"] = auth_data.updated_by
        
        update_query = text(f"""
            UPDATE user_auth 
            SET {', '.join(update_fields)}
            WHERE user_id = :user_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(update_query, params)
        db.commit()
        
        if result.rowcount == 0:
            raise HTTPException(status_code=500, detail="Failed to update user authentication")
        
        # Get the updated auth record
        select_query = text("""
            SELECT id, user_id, email, last_login, login_attempts, locked_until, tenant_id, created_at, updated_at
            FROM user_auth 
            WHERE user_id = :user_id AND tenant_id = :tenant_id
        """)
        
        auth_result = db.execute(select_query, {"user_id": user_id, "tenant_id": tenant_id})
        auth_row = auth_result.fetchone()
        
        return UserAuthResponse(
            id=auth_row[0],
            user_id=auth_row[1],
            email=auth_row[2],
            last_login=auth_row[3],
            login_attempts=auth_row[4],
            locked_until=auth_row[5],
            tenant_id=auth_row[6],
            created_at=auth_row[7],
            updated_at=auth_row[8]
        )
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/user-auth/{tenant_id}/reset-token")
async def create_reset_token(tenant_id: str, reset_data: PasswordResetRequest, db=Depends(get_db)):
    """Generate password reset token for user"""
    try:
        # Find user by email
        user_query = text("""
            SELECT ua.user_id FROM user_auth ua
            INNER JOIN users u ON ua.user_id = u.id
            WHERE ua.email = :email AND ua.tenant_id = :tenant_id AND u.status = 'active'
        """)
        
        user_result = db.execute(user_query, {
            "email": reset_data.email,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not user_result:
            raise HTTPException(status_code=404, detail="User not found or inactive")
        
        # Update with reset token
        update_query = text("""
            UPDATE user_auth 
            SET reset_token = :reset_token, reset_token_expires = :reset_token_expires, updated_at = NOW()
            WHERE email = :email AND tenant_id = :tenant_id
        """)
        
        db.execute(update_query, {
            "reset_token": reset_data.reset_token,
            "reset_token_expires": reset_data.reset_token_expires,
            "email": reset_data.email,
            "tenant_id": tenant_id
        })
        
        db.commit()
        
        return {
            "message": "Password reset token generated successfully",
            "email": reset_data.email,
            "token_expires": reset_data.reset_token_expires
        }
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/user-auth/{tenant_id}/verify-reset")
async def verify_reset_token(tenant_id: str, reset_data: PasswordResetVerify, db=Depends(get_db)):
    """Verify reset token and update password"""
    try:
        # Verify reset token
        verify_query = text("""
            SELECT ua.user_id, ua.email FROM user_auth ua
            INNER JOIN users u ON ua.user_id = u.id
            WHERE ua.reset_token = :reset_token 
            AND ua.tenant_id = :tenant_id 
            AND ua.reset_token_expires > NOW()
            AND u.status = 'active'
        """)
        
        verify_result = db.execute(verify_query, {
            "reset_token": reset_data.reset_token,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not verify_result:
            raise HTTPException(status_code=400, detail="Invalid or expired reset token")
        
        # Update password and clear reset token
        update_query = text("""
            UPDATE user_auth 
            SET password_hash = :new_password_hash, 
                reset_token = NULL, 
                reset_token_expires = NULL,
                login_attempts = 0,
                locked_until = NULL,
                updated_at = NOW()
            WHERE reset_token = :reset_token AND tenant_id = :tenant_id
        """)
        
        db.execute(update_query, {
            "new_password_hash": reset_data.new_password_hash,
            "reset_token": reset_data.reset_token,
            "tenant_id": tenant_id
        })
        
        db.commit()
        
        return {
            "message": "Password reset successfully",
            "user_id": verify_result[0],
            "email": verify_result[1]
        }
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/users/{tenant_id}/by-email")
async def get_user_by_email(tenant_id: str, email: str = Query(...), db=Depends(get_db)):
    """Get user information by email (for authentication purposes)"""
    try:
        query = text("""
            SELECT u.id, u.phone, u.name, u.email, u.role, u.status, u.tenant_id, 
                   u.territory_id, u.created_at, u.updated_at, u.created_by, u.updated_by
            FROM users u
            LEFT JOIN user_auth ua ON u.id = ua.user_id
            WHERE (u.email = :email OR ua.email = :email) 
            AND u.tenant_id = :tenant_id
        """)
        
        result = db.execute(query, {"email": email, "tenant_id": tenant_id})
        row = result.fetchone()
        
        if not row:
            raise HTTPException(status_code=404, detail="User not found")
        
        return UserResponse(
            id=row[0],
            phone=row[1],
            name=row[2],
            email=row[3],
            role=row[4],
            status=row[5],
            tenant_id=row[6],
            territory_id=row[7],
            created_at=row[8],
            updated_at=row[9],
            created_by=row[10],
            updated_by=row[11]
        )
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


# Notification Management Endpoints

@app.get("/api/notifications/{tenant_id}", response_model=List[NotificationResponse])
async def get_notifications(
    tenant_id: str,
    receiver_id: Optional[int] = None,
    notification_type: Optional[str] = None,
    is_confirmed: Optional[bool] = None,
    db=Depends(get_db)
):
    """Get notifications for a specific tenant with optional filtering"""
    try:
        # Build query with optional filters
        where_conditions = ["n.tenant_id = :tenant_id"]
        params = {"tenant_id": tenant_id}
        
        if receiver_id:
            where_conditions.append("n.receiver_id = :receiver_id")
            params["receiver_id"] = receiver_id
            
        if notification_type:
            where_conditions.append("n.notification_type = :notification_type")
            params["notification_type"] = notification_type
        
        if is_confirmed is not None:
            where_conditions.append("n.is_confirmed = :is_confirmed")
            params["is_confirmed"] = is_confirmed
        
        where_clause = " AND ".join(where_conditions)
        
        query = text(f"""
            SELECT n.id, n.sender_id, n.receiver_id, n.subject, n.notification_type, 
                   n.related_data, n.is_confirmed, n.tenant_id, n.created_at, n.updated_at,
                   n.created_by, n.updated_by,
                   s.name as sender_name, r.name as receiver_name
            FROM notifications n
            LEFT JOIN users s ON n.sender_id = s.id
            LEFT JOIN users r ON n.receiver_id = r.id
            WHERE {where_clause}
            ORDER BY n.created_at DESC
        """)
        
        result = db.execute(query, params)
        notifications = []
        
        for row in result:
            # Handle JSON data safely
            related_data = None
            if row[5]:  # related_data column
                try:
                    import json
                    related_data = json.loads(row[5]) if isinstance(row[5], str) else row[5]
                except:
                    related_data = row[5]
            
            notifications.append(NotificationResponse(
                id=row[0],
                sender_id=row[1],
                receiver_id=row[2],
                subject=row[3],
                notification_type=row[4],
                related_data=related_data,
                is_confirmed=row[6],
                tenant_id=row[7],
                created_at=row[8],
                updated_at=row[9],
                created_by=row[10],
                updated_by=row[11],
                sender_name=row[12],
                receiver_name=row[13]
            ))
        
        return notifications
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.get("/api/notifications/{tenant_id}/{notification_id}", response_model=NotificationResponse)
async def get_notification(tenant_id: str, notification_id: str, db=Depends(get_db)):
    """Get a specific notification by tenant and notification_id"""
    try:
        query = text("""
            SELECT n.id, n.sender_id, n.receiver_id, n.subject, n.notification_type, 
                   n.related_data, n.is_confirmed, n.tenant_id, n.created_at, n.updated_at,
                   n.created_by, n.updated_by,
                   s.name as sender_name, r.name as receiver_name
            FROM notifications n
            LEFT JOIN users s ON n.sender_id = s.id
            LEFT JOIN users r ON n.receiver_id = r.id
            WHERE n.tenant_id = :tenant_id AND n.id = :notification_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id, "notification_id": notification_id})
        row = result.fetchone()
        
        if not row:
            raise HTTPException(status_code=404, detail="Notification not found")
        
        # Handle JSON data safely
        related_data = None
        if row[5]:  # related_data column
            try:
                import json
                related_data = json.loads(row[5]) if isinstance(row[5], str) else row[5]
            except:
                related_data = row[5]
        
        return NotificationResponse(
            id=row[0],
            sender_id=row[1],
            receiver_id=row[2],
            subject=row[3],
            notification_type=row[4],
            related_data=related_data,
            is_confirmed=row[6],
            tenant_id=row[7],
            created_at=row[8],
            updated_at=row[9],
            created_by=row[10],
            updated_by=row[11],
            sender_name=row[12],
            receiver_name=row[13]
        )
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.post("/api/notifications/{tenant_id}", response_model=NotificationResponse)
async def create_notification(tenant_id: str, notification_data: NotificationCreate, db=Depends(get_db)):
    """Create a new notification for a specific tenant"""
    try:
        # Validate sender and receiver exist and belong to tenant
        user_check = text("""
            SELECT id, name FROM users 
            WHERE id IN (:sender_id, :receiver_id) AND tenant_id = :tenant_id
        """)
        
        users = db.execute(user_check, {
            "sender_id": notification_data.sender_id,
            "receiver_id": notification_data.receiver_id,
            "tenant_id": tenant_id
        }).fetchall()
        
        if len(users) != 2:
            raise HTTPException(status_code=400, detail="Invalid sender or receiver")
        
        # Prepare related_data for insertion
        related_data_json = None
        if notification_data.related_data:
            import json
            related_data_json = json.dumps(notification_data.related_data)
        
        # Insert new notification
        insert_query = text("""
            INSERT INTO notifications (sender_id, receiver_id, subject, notification_type, 
                                     related_data, is_confirmed, tenant_id, created_at, updated_at, 
                                     created_by, updated_by)
            VALUES (:sender_id, :receiver_id, :subject, :notification_type, 
                    :related_data, :is_confirmed, :tenant_id, NOW(), NOW(), 
                    :created_by, :updated_by)
        """)
        
        result = db.execute(insert_query, {
            "sender_id": notification_data.sender_id,
            "receiver_id": notification_data.receiver_id,
            "subject": notification_data.subject,
            "notification_type": notification_data.notification_type,
            "related_data": related_data_json,
            "is_confirmed": notification_data.is_confirmed,
            "tenant_id": tenant_id,
            "created_by": notification_data.created_by,
            "updated_by": notification_data.updated_by
        })
        
        db.commit()
        
        # Return the created notification
        notification_id = result.lastrowid
        return await get_notification(tenant_id, str(notification_id), db)
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.put("/api/notifications/{tenant_id}/{notification_id}", response_model=NotificationResponse)
async def update_notification(tenant_id: str, notification_id: str, notification_data: NotificationUpdate, db=Depends(get_db)):
    """Update an existing notification"""
    try:
        # Check if notification exists
        existing_query = text("""
            SELECT id FROM notifications 
            WHERE tenant_id = :tenant_id AND id = :notification_id
        """)
        
        existing = db.execute(existing_query, {
            "tenant_id": tenant_id,
            "notification_id": notification_id
        }).fetchone()
        
        if not existing:
            raise HTTPException(status_code=404, detail="Notification not found")
        
        # Build update query dynamically
        update_fields = []
        params = {"tenant_id": tenant_id, "notification_id": notification_id}
        
        if notification_data.subject is not None:
            update_fields.append("subject = :subject")
            params["subject"] = notification_data.subject
        
        if notification_data.is_confirmed is not None:
            update_fields.append("is_confirmed = :is_confirmed")
            params["is_confirmed"] = notification_data.is_confirmed
        
        if notification_data.related_data is not None:
            update_fields.append("related_data = :related_data")
            import json
            params["related_data"] = json.dumps(notification_data.related_data)
        
        # Always update audit fields
        update_fields.append("updated_at = NOW()")
        if notification_data.updated_by is not None:
            update_fields.append("updated_by = :updated_by")
            params["updated_by"] = notification_data.updated_by
        
        if not update_fields:
            # No fields to update, return existing notification
            return await get_notification(tenant_id, notification_id, db)
        
        update_query = text(f"""
            UPDATE notifications 
            SET {', '.join(update_fields)}
            WHERE tenant_id = :tenant_id AND id = :notification_id
        """)
        
        db.execute(update_query, params)
        db.commit()
        
        # Return the updated notification
        return await get_notification(tenant_id, notification_id, db)
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


@app.delete("/api/notifications/{tenant_id}/{notification_id}")
async def delete_notification(tenant_id: str, notification_id: str, db=Depends(get_db)):
    """Delete a notification"""
    try:
        # Check if notification exists
        existing_query = text("""
            SELECT id FROM notifications 
            WHERE tenant_id = :tenant_id AND id = :notification_id
        """)
        
        existing = db.execute(existing_query, {
            "tenant_id": tenant_id,
            "notification_id": notification_id
        }).fetchone()
        
        if not existing:
            raise HTTPException(status_code=404, detail="Notification not found")
        
        # Delete notification
        delete_query = text("""
            DELETE FROM notifications 
            WHERE tenant_id = :tenant_id AND id = :notification_id
        """)
        
        db.execute(delete_query, {"tenant_id": tenant_id, "notification_id": notification_id})
        db.commit()
        
        return {"message": "Notification deleted successfully"}
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")


# ==================== Orders Endpoints ====================

class OrderResponse(BaseModel):
    id: int
    order_id: str
    bill_number: Optional[str] = None
    shop_id: str
    executive_id: int
    order_date: date
    delivery_date: Optional[date] = None
    total_amount: float
    discount_amount: Optional[float] = None
    tax_amount: Optional[float] = None
    final_amount: float
    status: str
    payment_status: str
    payment_method: Optional[str] = None
    items_count: int
    notes: Optional[str] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class OrderItemResponse(BaseModel):
    id: int
    order_id: int
    product_code: str
    product_name: str
    quantity: int
    unit_price: float
    discount_percent: Optional[float] = None
    discount_amount: Optional[float] = None
    tax_percent: Optional[float] = None
    tax_amount: Optional[float] = None
    total_amount: float
    created_at: datetime

class OrderCreate(BaseModel):
    order_id: str
    bill_number: Optional[str] = None
    shop_id: str
    executive_id: int
    order_date: date
    delivery_date: Optional[date] = None
    total_amount: float
    discount_amount: Optional[float] = 0
    tax_amount: Optional[float] = 0
    final_amount: float
    status: str = "pending"
    payment_status: str = "pending"
    payment_method: Optional[str] = None
    items_count: int = 0
    notes: Optional[str] = None
    tenant_id: str

class OrderItemCreate(BaseModel):
    order_id: int
    product_code: str
    product_name: str
    quantity: int
    unit_price: float
    discount_percent: Optional[float] = 0
    discount_amount: Optional[float] = 0
    tax_percent: Optional[float] = 0
    tax_amount: Optional[float] = 0
    total_amount: float

@app.get("/api/orders/{tenant_id}", response_model=List[OrderResponse])
async def get_orders(
    tenant_id: str,
    status: Optional[str] = Query(None),
    shop_id: Optional[str] = Query(None),
    executive_id: Optional[int] = Query(None),
    from_date: Optional[str] = Query(None),
    to_date: Optional[str] = Query(None),
    search: Optional[str] = Query(None),
    page: int = Query(1, gt=0),
    page_size: int = Query(50, gt=0, le=100)
):
    """Get all orders for a tenant with optional filters."""
    db = SessionLocal()
    try:
        # Build query with filters
        conditions = ["tenant_id = :tenant_id"]
        params = {"tenant_id": tenant_id}
        
        if status:
            conditions.append("status = :status")
            params["status"] = status
        
        if shop_id:
            conditions.append("shop_id = :shop_id")
            params["shop_id"] = shop_id
        
        if executive_id:
            conditions.append("executive_id = :executive_id")
            params["executive_id"] = executive_id
        
        if from_date:
            conditions.append("order_date >= :from_date")
            params["from_date"] = from_date
        
        if to_date:
            conditions.append("order_date <= :to_date")
            params["to_date"] = to_date
        
        if search:
            conditions.append("(order_id LIKE :search OR bill_number LIKE :search)")
            params["search"] = f"%{search}%"
        
        where_clause = " AND ".join(conditions)
        offset = (page - 1) * page_size
        
        query = text(f"""
            SELECT * FROM orders
            WHERE {where_clause}
            ORDER BY order_date DESC, created_at DESC
            LIMIT :limit OFFSET :offset
        """)
        
        params["limit"] = page_size
        params["offset"] = offset
        
        result = db.execute(query, params)
        orders = [dict(row._mapping) for row in result]
        
        return orders
        
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

@app.get("/api/orders/{tenant_id}/{order_id}", response_model=OrderResponse)
async def get_order_by_id(tenant_id: str, order_id: str):
    """Get a single order by order_id."""
    db = SessionLocal()
    try:
        query = text("""
            SELECT * FROM orders
            WHERE tenant_id = :tenant_id AND order_id = :order_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id, "order_id": order_id})
        order = result.fetchone()
        
        if not order:
            raise HTTPException(status_code=404, detail="Order not found")
        
        return dict(order._mapping)
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

@app.get("/api/orders/{tenant_id}/{order_id}/items", response_model=List[OrderItemResponse])
async def get_order_items(tenant_id: str, order_id: str):
    """Get all items for an order."""
    db = SessionLocal()
    try:
        # First verify order exists
        order_query = text("""
            SELECT id FROM orders
            WHERE tenant_id = :tenant_id AND order_id = :order_id
        """)
        order_result = db.execute(order_query, {"tenant_id": tenant_id, "order_id": order_id})
        order = order_result.fetchone()
        
        if not order:
            raise HTTPException(status_code=404, detail="Order not found")
        
        # Get order items
        items_query = text("""
            SELECT * FROM order_items
            WHERE order_id = :order_id
            ORDER BY id
        """)
        
        result = db.execute(items_query, {"order_id": order[0]})
        items = [dict(row._mapping) for row in result]
        
        return items
        
    except HTTPException:
        raise
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

@app.post("/api/orders/{tenant_id}", response_model=OrderResponse)
async def create_order(tenant_id: str, order: OrderCreate):
    """Create a new order."""
    db = SessionLocal()
    try:
        # Check if order_id already exists
        check_query = text("""
            SELECT id FROM orders
            WHERE tenant_id = :tenant_id AND order_id = :order_id
        """)
        existing = db.execute(check_query, {"tenant_id": tenant_id, "order_id": order.order_id})
        if existing.fetchone():
            raise HTTPException(status_code=400, detail="Order ID already exists")
        
        # Insert order
        insert_query = text("""
            INSERT INTO orders (
                order_id, bill_number, shop_id, executive_id, order_date,
                delivery_date, total_amount, discount_amount, tax_amount,
                final_amount, status, payment_status, payment_method,
                items_count, notes, tenant_id
            ) VALUES (
                :order_id, :bill_number, :shop_id, :executive_id, :order_date,
                :delivery_date, :total_amount, :discount_amount, :tax_amount,
                :final_amount, :status, :payment_status, :payment_method,
                :items_count, :notes, :tenant_id
            )
        """)
        
        db.execute(insert_query, order.dict())
        db.commit()
        
        # Get created order
        get_query = text("""
            SELECT * FROM orders
            WHERE tenant_id = :tenant_id AND order_id = :order_id
        """)
        result = db.execute(get_query, {"tenant_id": tenant_id, "order_id": order.order_id})
        created_order = result.fetchone()
        
        return dict(created_order._mapping)
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

@app.post("/api/order-items", response_model=OrderItemResponse)
async def create_order_item(item: OrderItemCreate):
    """Create a new order item."""
    db = SessionLocal()
    try:
        insert_query = text("""
            INSERT INTO order_items (
                order_id, product_code, product_name, quantity, unit_price,
                discount_percent, discount_amount, tax_percent, tax_amount, total_amount
            ) VALUES (
                :order_id, :product_code, :product_name, :quantity, :unit_price,
                :discount_percent, :discount_amount, :tax_percent, :tax_amount, :total_amount
            )
        """)
        
        db.execute(insert_query, item.dict())
        db.commit()
        
        # Get created item
        get_query = text("""
            SELECT * FROM order_items
            WHERE order_id = :order_id AND product_code = :product_code
            ORDER BY id DESC LIMIT 1
        """)
        result = db.execute(get_query, {"order_id": item.order_id, "product_code": item.product_code})
        created_item = result.fetchone()
        
        return dict(created_item._mapping)
        
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

# ==================== Shop Assignments Endpoints ====================

class ShopAssignmentResponse(BaseModel):
    id: int
    shop_id: str
    executive_id: int
    territory_id: Optional[str] = None
    assigned_date: date
    end_date: Optional[date] = None
    status: str
    notes: Optional[str] = None
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class ShopAssignmentCreate(BaseModel):
    shop_id: str
    executive_id: int
    territory_id: Optional[str] = None
    assigned_date: date
    end_date: Optional[date] = None
    status: str = "active"
    notes: Optional[str] = None
    tenant_id: str

@app.get("/api/shop-assignments/{tenant_id}", response_model=List[ShopAssignmentResponse])
async def get_shop_assignments(
    tenant_id: str,
    shop_id: Optional[str] = Query(None),
    executive_id: Optional[int] = Query(None),
    territory_id: Optional[str] = Query(None),
    status: Optional[str] = Query(None)
):
    """Get all shop assignments for a tenant with optional filters."""
    db = SessionLocal()
    try:
        conditions = ["tenant_id = :tenant_id"]
        params = {"tenant_id": tenant_id}
        
        if shop_id:
            conditions.append("shop_id = :shop_id")
            params["shop_id"] = shop_id
        
        if executive_id:
            conditions.append("executive_id = :executive_id")
            params["executive_id"] = executive_id
        
        if territory_id:
            conditions.append("territory_id = :territory_id")
            params["territory_id"] = territory_id
        
        if status:
            conditions.append("status = :status")
            params["status"] = status
        
        where_clause = " AND ".join(conditions)
        
        query = text(f"""
            SELECT * FROM shop_assignments
            WHERE {where_clause}
            ORDER BY assigned_date DESC, created_at DESC
        """)
        
        result = db.execute(query, params)
        assignments = [dict(row._mapping) for row in result]
        
        return assignments
        
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

@app.post("/api/shop-assignments/{tenant_id}", response_model=ShopAssignmentResponse)
async def create_shop_assignment(tenant_id: str, assignment: ShopAssignmentCreate):
    """Create a new shop assignment."""
    db = SessionLocal()
    try:
        # Check for existing active assignment
        check_query = text("""
            SELECT id FROM shop_assignments
            WHERE tenant_id = :tenant_id 
            AND shop_id = :shop_id 
            AND executive_id = :executive_id
            AND status = 'active'
        """)
        existing = db.execute(check_query, {
            "tenant_id": tenant_id,
            "shop_id": assignment.shop_id,
            "executive_id": assignment.executive_id
        })
        if existing.fetchone():
            raise HTTPException(status_code=400, detail="Active assignment already exists for this shop and executive")
        
        # Insert assignment
        insert_query = text("""
            INSERT INTO shop_assignments (
                shop_id, executive_id, territory_id, assigned_date,
                end_date, status, notes, tenant_id
            ) VALUES (
                :shop_id, :executive_id, :territory_id, :assigned_date,
                :end_date, :status, :notes, :tenant_id
            )
        """)
        
        db.execute(insert_query, assignment.dict())
        db.commit()
        
        # Get created assignment
        get_query = text("""
            SELECT * FROM shop_assignments
            WHERE tenant_id = :tenant_id 
            AND shop_id = :shop_id 
            AND executive_id = :executive_id
            ORDER BY id DESC LIMIT 1
        """)
        result = db.execute(get_query, {
            "tenant_id": tenant_id,
            "shop_id": assignment.shop_id,
            "executive_id": assignment.executive_id
        })
        created_assignment = result.fetchone()
        
        return dict(created_assignment._mapping)
        
    except HTTPException:
        db.rollback()
        raise
    except SQLAlchemyError as e:
        db.rollback()
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()

# ==================== Enhanced Visits Endpoints ====================

@app.get("/api/visits/{tenant_id}/shop/{shop_id}/status")
async def get_shop_visit_status(tenant_id: str, shop_id: str):
    """Get visit status summary for a specific shop."""
    db = SessionLocal()
    try:
        query = text("""
            SELECT 
                MAX(DATE(checkin_time)) as last_visit_date,
                DATEDIFF(CURDATE(), MAX(DATE(checkin_time))) as days_since_visit,
                COUNT(CASE WHEN MONTH(checkin_time) = MONTH(CURDATE()) 
                      AND YEAR(checkin_time) = YEAR(CURDATE()) THEN 1 END) as visit_count_this_month,
                (SELECT MAX(order_date) FROM orders 
                 WHERE shop_id = :shop_id AND tenant_id = :tenant_id) as last_order_date,
                (SELECT COUNT(*) FROM orders 
                 WHERE shop_id = :shop_id AND tenant_id = :tenant_id
                 AND MONTH(order_date) = MONTH(CURDATE()) 
                 AND YEAR(order_date) = YEAR(CURDATE())) as orders_this_month
            FROM visits
            WHERE tenant_id = :tenant_id AND shop_id = :shop_id
        """)
        
        result = db.execute(query, {"tenant_id": tenant_id, "shop_id": shop_id})
        status = result.fetchone()
        
        if not status:
            return {
                "last_visit_date": None,
                "days_since_visit": None,
                "visit_count_this_month": 0,
                "last_order_date": None,
                "orders_this_month": 0
            }
        
        return dict(status._mapping)
        
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    finally:
        db.close()


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
