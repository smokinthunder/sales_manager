"""
Mock Client Finance API for Development.

This is a mock implementation of the client's Tally-like
finance system API for development and testing purposes.
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from datetime import date, datetime
import random

app = FastAPI(
    title="Mock Client Finance API",
    description="Mock API simulating client's finance system",
    version="1.0.0"
)

# Mock data models
class Product(BaseModel):
    sku: str
    name: str
    category: str
    mrp: float

class Shop(BaseModel):
    shop_id: str
    name: str
    territory_id: str

class OrderLine(BaseModel):
    sku: str
    qty: int
    rate: float

class Order(BaseModel):
    order_id: str
    shop_id: str
    order_date: date
    status: str
    lines: List[OrderLine]

class Payment(BaseModel):
    payment_id: str
    shop_id: str
    amount: float
    date: date

class Outstanding(BaseModel):
    shop_id: str
    amount_due: float
    as_of: date
    days_overdue: int

class SyncResponse(BaseModel):
    tenant_id: str
    sync_date: date
    products: List[Product]
    shops: List[Shop]
    orders: List[Order]
    payments: List[Payment]
    outstandings: List[Outstanding]

# Mock data
MOCK_PRODUCTS = [
    Product(sku="P-001", name="Item A", category="Beverage", mrp=120.0),
    Product(sku="P-002", name="Item B", category="Snacks", mrp=85.0),
    Product(sku="P-003", name="Item C", category="Beverage", mrp=95.0),
    Product(sku="P-004", name="Item D", category="Snacks", mrp=150.0),
    Product(sku="P-005", name="Item E", category="Beverage", mrp=200.0),
]

MOCK_SHOPS = [
    Shop(shop_id="S-901", name="Lucky Stores", territory_id="TR-22"),
    Shop(shop_id="S-902", name="City Mart", territory_id="TR-22"),
    Shop(shop_id="S-903", name="Quick Shop", territory_id="TR-23"),
    Shop(shop_id="S-904", name="Super Market", territory_id="TR-23"),
    Shop(shop_id="S-905", name="Corner Store", territory_id="TR-24"),
]

MOCK_ORDERS = [
    Order(
        order_id="O-7788",
        shop_id="S-901",
        order_date=date(2025, 1, 20),
        status="DELIVERED",
        lines=[OrderLine(sku="P-001", qty=10, rate=100.0)]
    ),
    Order(
        order_id="O-7789",
        shop_id="S-902",
        order_date=date(2025, 1, 21),
        status="CONFIRMED",
        lines=[OrderLine(sku="P-002", qty=5, rate=80.0)]
    ),
    Order(
        order_id="O-7790",
        shop_id="S-903",
        order_date=date(2025, 1, 22),
        status="PENDING",
        lines=[OrderLine(sku="P-003", qty=8, rate=90.0)]
    ),
]

MOCK_PAYMENTS = [
    Payment(payment_id="PM-55", shop_id="S-901", amount=500.0, date=date(2025, 1, 21)),
    Payment(payment_id="PM-56", shop_id="S-902", amount=400.0, date=date(2025, 1, 22)),
    Payment(payment_id="PM-57", shop_id="S-903", amount=300.0, date=date(2025, 1, 23)),
]

MOCK_OUTSTANDINGS = [
    Outstanding(shop_id="S-901", amount_due=700.0, as_of=date(2025, 1, 22), days_overdue=35),
    Outstanding(shop_id="S-902", amount_due=450.0, as_of=date(2025, 1, 22), days_overdue=15),
    Outstanding(shop_id="S-903", amount_due=1200.0, as_of=date(2025, 1, 22), days_overdue=45),
]


@app.get("/")
async def root():
    """Root endpoint for health check."""
    return {
        "message": "Mock Client Finance API",
        "version": "1.0.0",
        "status": "running"
    }


@app.get("/health")
async def health():
    """Health check endpoint."""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}


@app.post("/api/sync")
async def sync_data(tenant_id: str):
    """
    Mock data synchronization endpoint.
    
    Args:
        tenant_id: Tenant identifier
        
    Returns:
        SyncResponse: Mock finance data
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    # Simulate some randomness in the data
    random_products = random.sample(MOCK_PRODUCTS, random.randint(3, 5))
    random_shops = random.sample(MOCK_SHOPS, random.randint(3, 5))
    random_orders = random.sample(MOCK_ORDERS, random.randint(2, 3))
    random_payments = random.sample(MOCK_PAYMENTS, random.randint(2, 3))
    random_outstandings = random.sample(MOCK_OUTSTANDINGS, random.randint(2, 3))
    
    return SyncResponse(
        tenant_id=tenant_id,
        sync_date=date.today(),
        products=random_products,
        shops=random_shops,
        orders=random_orders,
        payments=random_payments,
        outstandings=random_outstandings
    )


@app.get("/api/products")
async def get_products(tenant_id: str, category: Optional[str] = None):
    """
    Get products for a tenant.
    
    Args:
        tenant_id: Tenant identifier
        category: Optional product category filter
        
    Returns:
        List[Product]: List of products
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    products = MOCK_PRODUCTS
    if category:
        products = [p for p in products if p.category.lower() == category.lower()]
    
    return products


@app.get("/api/shops")
async def get_shops(tenant_id: str, territory_id: Optional[str] = None):
    """
    Get shops for a tenant.
    
    Args:
        tenant_id: Tenant identifier
        territory_id: Optional territory filter
        
    Returns:
        List[Shop]: List of shops
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    shops = MOCK_SHOPS
    if territory_id:
        shops = [s for s in shops if s.territory_id == territory_id]
    
    return shops


@app.get("/api/orders")
async def get_orders(tenant_id: str, shop_id: Optional[str] = None, status: Optional[str] = None):
    """
    Get orders for a tenant.
    
    Args:
        tenant_id: Tenant identifier
        shop_id: Optional shop filter
        status: Optional status filter
        
    Returns:
        List[Order]: List of orders
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    orders = MOCK_ORDERS
    if shop_id:
        orders = [o for o in orders if o.shop_id == shop_id]
    if status:
        orders = [o for o in orders if o.status.upper() == status.upper()]
    
    return orders


@app.get("/api/payments")
async def get_payments(tenant_id: str, shop_id: Optional[str] = None, date_from: Optional[date] = None):
    """
    Get payments for a tenant.
    
    Args:
        tenant_id: Tenant identifier
        shop_id: Optional shop filter
        date_from: Optional date filter
        
    Returns:
        List[Payment]: List of payments
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    payments = MOCK_PAYMENTS
    if shop_id:
        payments = [p for p in payments if p.shop_id == shop_id]
    if date_from:
        payments = [p for p in payments if p.date >= date_from]
    
    return payments


@app.get("/api/outstandings")
async def get_outstandings(tenant_id: str, shop_id: Optional[str] = None, days_overdue: Optional[int] = None):
    """
    Get outstanding amounts for a tenant.
    
    Args:
        tenant_id: Tenant identifier
        shop_id: Optional shop filter
        days_overdue: Optional overdue days filter
        
    Returns:
        List[Outstanding]: List of outstanding amounts
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    outstandings = MOCK_OUTSTANDINGS
    if shop_id:
        outstandings = [o for o in outstandings if o.shop_id == shop_id]
    if days_overdue:
        outstandings = [o for o in outstandings if o.days_overdue >= days_overdue]
    
    return outstandings


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
