"""
Mock Client Finance API for Development.

This is a mock implementation of the client's finance system API
that matches the expected format from AQUASTAR_BACKEND_UPDATION_PLAN.md
"""

from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import date, datetime, timedelta
import random

app = FastAPI(
    title="Mock Client Finance API",
    description="Mock API simulating client's finance system with 30-day payment policy",
    version="1.0.0"
)

# Response models matching the expected format
class Product(BaseModel):
    product_name: str
    product_amount: float

class Order(BaseModel):
    order_id: int
    order_date: str  # YYYY-MM-DD format
    order_amount: float
    products: List[Product]

class PaymentStatus(BaseModel):
    current: float
    upcoming: float
    overdue: float

class Shop(BaseModel):
    shop_id: int
    shop_name: str
    orders: List[Order]
    payment_status: PaymentStatus

class ClientDataResponse(BaseModel):
    status: str
    message: str
    shops: List[Shop]

# Mock data - Product names and categories
PRODUCT_NAMES = [
    "Coca Cola 500ml", "Pepsi 500ml", "Sprite 500ml", "Fanta 500ml", "Thums Up 500ml",
    "Lays Classic", "Lays Masala", "Kurkure", "Cheetos", "Doritos",
    "Biscuits Pack", "Cookies Pack", "Cake Mix", "Bread Loaf", "Milk 1L",
    "Yogurt 500g", "Cheese 200g", "Butter 100g", "Jam 500g", "Honey 250g",
    "Rice 1kg", "Wheat Flour 1kg", "Sugar 1kg", "Salt 500g", "Oil 1L",
    "Tea Leaves 250g", "Coffee 200g", "Noodles Pack", "Pasta 500g", "Cereal 500g"
]

PRODUCT_CATEGORIES = ["Beverages", "Snacks", "Dairy", "Bakery", "Pantry", "Breakfast"]

# Shop names and locations
SHOP_NAMES = [
    "Lucky Stores", "City Mart", "Quick Shop", "Super Market", "Corner Store",
    "Family Store", "Daily Needs", "Fresh Mart", "Value Store", "Prime Shop",
    "Neighborhood Store", "Community Shop", "Local Mart", "Express Store", "Best Buy",
    "Quality Store", "Reliable Shop", "Trust Mart", "Good Store", "Top Shop",
    "Elite Store", "Premium Shop", "Gold Store", "Silver Mart", "Bronze Shop"
]

# Generate realistic mock data
def generate_products(count: int = 3) -> List[Product]:
    """Generate random products for an order."""
    products = []
    for _ in range(count):
        product_name = random.choice(PRODUCT_NAMES)
        product_amount = round(random.uniform(25.0, 200.0), 2)
        products.append(Product(
            product_name=product_name,
            product_amount=product_amount
        ))
    return products

def generate_orders(shop_id: int, count: int = 3) -> List[Order]:
    """Generate random orders for a shop."""
    orders = []
    for i in range(count):
        # Generate order date within last 60 days
        days_ago = random.randint(1, 60)
        order_date = (datetime.now() - timedelta(days=days_ago)).strftime("%Y-%m-%d")
        
        # Generate products for this order
        products = generate_products(random.randint(1, 4))
        order_amount = sum(p.product_amount for p in products)
        
        orders.append(Order(
            order_id=random.randint(1000, 9999),
            order_date=order_date,
            order_amount=round(order_amount, 2),
            products=products
        ))
    return orders

def calculate_payment_status(orders: List[Order]) -> PaymentStatus:
    """Calculate payment status based on 30-day policy."""
    current = 0.0
    upcoming = 0.0
    overdue = 0.0
    
    today = datetime.now().date()
    
    for order in orders:
        order_date = datetime.strptime(order.order_date, "%Y-%m-%d").date()
        due_date = order_date + timedelta(days=30)
        
        if today > due_date:
            # Overdue
            overdue += order.order_amount
        elif today <= due_date and (due_date - today).days <= 7:
            # Upcoming (due within 7 days)
            upcoming += order.order_amount
        else:
            # Current
            current += order.order_amount
    
    return PaymentStatus(
        current=round(current, 2),
        upcoming=round(upcoming, 2),
        overdue=round(overdue, 2)
    )

def generate_shops(count: int = 15) -> List[Shop]:
    """Generate mock shops with orders and payment status."""
    shops = []
    
    for i in range(count):
        shop_id = random.randint(100, 999)
        shop_name = random.choice(SHOP_NAMES)
        
        # Generate orders for this shop
        orders = generate_orders(shop_id, random.randint(2, 6))
        
        # Calculate payment status
        payment_status = calculate_payment_status(orders)
        
        shops.append(Shop(
            shop_id=shop_id,
            shop_name=shop_name,
            orders=orders,
            payment_status=payment_status
        ))
    
    return shops


@app.get("/")
async def root():
    """Root endpoint for health check."""
    return {
        "message": "Mock Client Finance API",
        "version": "1.0.0",
        "status": "running",
        "format": "Matches AQUASTAR_BACKEND_UPDATION_PLAN.md specification"
    }


@app.get("/health")
async def health():
    """Health check endpoint."""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}


@app.get("/api/client-data")
async def get_client_data(tenant_id: str = Query(..., description="Tenant identifier")):
    """
    Get client data in the format expected by AquaStar backend.
    
    This endpoint matches the exact format specified in AQUASTAR_BACKEND_UPDATION_PLAN.md:
    - GET /api/client-data?tenant_id={tenant_id}
    - Returns shops with embedded orders, products, and payment_status
    - Implements 30-day payment policy calculation
    
    Args:
        tenant_id: Tenant identifier (required query parameter)
        
    Returns:
        ClientDataResponse: Client data in expected format
        
    Raises:
        HTTPException: If tenant_id is missing
    """
    if not tenant_id:
        raise HTTPException(status_code=400, detail="tenant_id is required")
    
    # Generate realistic mock data
    shops = generate_shops(random.randint(10, 20))  # 10-20 shops per tenant
    
    return ClientDataResponse(
        status="success",
        message="Data fetched successfully",
        shops=shops
    )


@app.get("/api/client-data/sample")
async def get_sample_data():
    """
    Get a small sample of client data for testing.
    
    Returns:
        ClientDataResponse: Sample client data with 3 shops
    """
    shops = generate_shops(3)
    
    return ClientDataResponse(
        status="success",
        message="Sample data fetched successfully",
        shops=shops
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
