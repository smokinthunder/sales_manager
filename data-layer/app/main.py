"""
Data Layer Service - Server B

This service runs on Server B and has direct access to the database.
The backend (Server C) communicates with this service via HTTP APIs.
This is a standalone version that doesn't depend on the core module.
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import date, datetime
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
    updated_by: Optional[int] = None

class UserResponse(BaseModel):
    id: int
    phone: str
    name: str
    email: Optional[str] = None
    role: str
    status: str
    tenant_id: str
    created_at: datetime
    updated_at: datetime
    created_by: Optional[int] = None
    updated_by: Optional[int] = None

class ShopResponse(BaseModel):
    id: int
    shop_id: str
    name: str
    address: str
    territory_id: str
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class TerritoryResponse(BaseModel):
    id: int
    territory_id: str
    name: str
    description: str
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class VisitResponse(BaseModel):
    id: int
    visit_id: str
    shop_id: str
    executive_id: str
    checkin_time: datetime
    checkout_time: Optional[datetime]
    location_lat: float
    location_lng: float
    remarks: Optional[str]
    tenant_id: str
    created_at: datetime
    updated_at: datetime

class RouteResponse(BaseModel):
    id: int
    route_id: str
    name: str
    executive_id: str
    week_start: date
    status: str
    tenant_id: str
    created_at: datetime
    updated_at: datetime

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
            SELECT id, phone, name, email, role, status, tenant_id, created_at, updated_at, created_by, updated_by
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
                created_at=row[7],
                updated_at=row[8],
                created_by=row[9],
                updated_by=row[10]
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
    """Soft delete a user by setting status to inactive"""
    try:
        # Check if user exists
        check_query = text("""
            SELECT id, status FROM users 
            WHERE id = :user_id AND tenant_id = :tenant_id
        """)
        
        existing_user = db.execute(check_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        }).fetchone()
        
        if not existing_user:
            raise HTTPException(status_code=404, detail="User not found")
        
        if existing_user[1] == "inactive":
            raise HTTPException(status_code=400, detail="User is already inactive")
        
        # Soft delete by setting status to inactive
        update_query = text("""
            UPDATE users 
            SET status = 'inactive', updated_at = NOW() 
            WHERE id = :user_id AND tenant_id = :tenant_id
        """)
        
        result = db.execute(update_query, {
            "user_id": user_id,
            "tenant_id": tenant_id
        })
        
        db.commit()
        
        if result.rowcount == 0:
            raise HTTPException(status_code=500, detail="Failed to update user")
        
        return {
            "message": "User deleted successfully",
            "user_id": user_id,
            "status": "inactive",
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
            created_at=user_row[7],
            updated_at=user_row[8],
            created_by=user_row[9],
            updated_by=user_row[10]
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


# User creation model
class UserCreate(BaseModel):
    phone: str
    name: str
    email: Optional[str] = None
    role: str
    tenant_id: str
    status: str = "pending_approval"
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
        
        # Check if tenant_id already exists (only one user per tenant)
        check_tenant_query = text("""
            SELECT id FROM users 
            WHERE tenant_id = :tenant_id
        """)
        
        existing_user_by_tenant = db.execute(check_tenant_query, {
            "tenant_id": tenant_id
        }).fetchone()
        
        if existing_user_by_tenant:
            raise HTTPException(status_code=400, detail="A user with this tenant ID already exists. Each tenant can only have one user.")
        
        # Create new user
        insert_query = text("""
            INSERT INTO users (phone, name, email, role, tenant_id, status, created_at, updated_at, created_by, updated_by)
            VALUES (:phone, :name, :email, :role, :tenant_id, :status, NOW(), NOW(), :created_by, :updated_by)
        """)
        
        result = db.execute(insert_query, {
            "phone": user_data.phone,
            "name": user_data.name,
            "email": getattr(user_data, 'email', None),
            "role": user_data.role,
            "tenant_id": tenant_id,
            "status": user_data.status,
            "created_by": getattr(user_data, 'created_by', None),
            "updated_by": getattr(user_data, 'created_by', None)
        })
        
        db.commit()
        
        # Get the created user
        user_id = result.lastrowid
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
            created_at=user_row[7],
            updated_at=user_row[8],
            created_by=user_row[9],
            updated_by=user_row[10]
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
async def get_shops(tenant_id: str, territory_id: Optional[str] = None, db=Depends(get_db)):
    """Get shops for a specific tenant, optionally filtered by territory"""
    try:
        if territory_id:
            query = text("""
                SELECT id, shop_id, name, address, territory_id, tenant_id, created_at, updated_at
                FROM shops 
                WHERE tenant_id = :tenant_id AND territory_id = :territory_id
            """)
            params = {"tenant_id": tenant_id, "territory_id": territory_id}
        else:
            query = text("""
                SELECT id, shop_id, name, address, territory_id, tenant_id, created_at, updated_at
                FROM shops 
                WHERE tenant_id = :tenant_id
            """)
            params = {"tenant_id": tenant_id}
        
        result = db.execute(query, params)
        shops = []
        
        for row in result:
            shops.append(ShopResponse(
                id=row[0],
                shop_id=row[1],
                name=row[2],
                address=row[3],
                territory_id=row[4],
                tenant_id=row[5],
                created_at=row[6],
                updated_at=row[7]
            ))
        
        return shops
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error")

@app.get("/api/territories/{tenant_id}", response_model=List[TerritoryResponse])
async def get_territories(tenant_id: str, db=Depends(get_db)):
    """Get territories for a specific tenant"""
    try:
        query = text("""
            SELECT id, territory_id, name, description, tenant_id, created_at, updated_at
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
                description=row[3],
                tenant_id=row[4],
                created_at=row[5],
                updated_at=row[6]
            ))
        
        return territories
    except SQLAlchemyError as e:
        logger.error(f"Database error: {e}")
        raise HTTPException(status_code=500, detail="Database error")
    except Exception as e:
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
            SELECT id, route_id, name, executive_id, week_start, status, tenant_id, created_at, updated_at
            FROM routes 
            WHERE tenant_id = :tenant_id
        """
        params = {"tenant_id": tenant_id}
        
        if executive_id:
            base_query += " AND executive_id = :executive_id"
            params["executive_id"] = executive_id
        
        if week_start:
            base_query += " AND week_start = :week_start"
            params["week_start"] = week_start
        
        base_query += " ORDER BY week_start DESC"
        
        result = db.execute(text(base_query), params)
        routes = []
        
        for row in result:
            routes.append(RouteResponse(
                id=row[0],
                route_id=row[1],
                name=row[2],
                executive_id=row[3],
                week_start=row[4],
                status=row[5],
                tenant_id=row[6],
                created_at=row[7],
                updated_at=row[8]
            ))
        
        return routes
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
