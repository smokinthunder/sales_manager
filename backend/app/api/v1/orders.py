"""
Orders Management API endpoints.

Provides read operations for orders with proper authentication,
authorization checks, and tenant isolation.
"""

from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query, Path
from datetime import date
from app.api.deps import get_current_user
from app.services.data_layer_client import get_data_layer_client, DataLayerClient
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get(
    "/",
    summary="Get orders with filtering and pagination",
    tags=["Orders Management"]
)
async def get_orders(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    status: Optional[str] = Query(None, description="Filter by order status"),
    search: Optional[str] = Query(None, description="Search by bill number or shop name"),
    executive_id: Optional[int] = Query(None, description="Filter by sales executive ID"),
    shop_id: Optional[str] = Query(None, description="Filter by shop ID"),
    from_date: Optional[date] = Query(None, description="Filter by start date (order_date >= from_date)"),
    to_date: Optional[date] = Query(None, description="Filter by end date (order_date <= to_date)"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    data_layer: DataLayerClient = Depends(get_data_layer_client)
):
    """
    Get orders with optional filtering and pagination.
    
    **Business Logic:**
    - Returns order records with filtering options
    - Enforces role-based data access
    - Supports pagination
    - Includes shop name, executive name, and territory name via joins
    
    **Query Parameters:**
    - tenant_id: Required tenant identifier
    - status: Filter by order status (pending, confirmed, processing, shipped, delivered, completed, cancelled, returned)
    - search: Search in bill_number or shop name (partial match)
    - executive_id: Filter by sales executive
    - shop_id: Filter by specific shop
    - from_date: Filter orders from this date (inclusive)
    - to_date: Filter orders until this date (inclusive)
    - page: Page number (default: 1)
    - page_size: Items per page (default: 20, max: 100)
    
    **Authorization:**
    - Sales executives can only see their own orders
    - Area managers can see orders for their territory
    - Client admins and superadmins can see all orders
    
    **Response Format:**
    ```json
    {
        "items": [
            {
                "id": 1,
                "order_id": "ORD2024001",
                "bill_number": "BILL-2024-0001",
                "shop_id": "AQ-N-001",
                "shop_name": "ABC Store",
                "sales_executive_id": 5,
                "sales_executive_name": "John Doe",
                "order_date": "2024-12-01",
                "delivery_date": "2024-12-05",
                "status": "confirmed",
                "total_amount": 15000.00,
                "items_count": 10,
                "territory_name": "North Region",
                "created_at": "2024-12-01T10:00:00",
                "updated_at": "2024-12-01T10:00:00"
            }
        ],
        "total": 150,
        "page": 1,
        "page_size": 20,
        "pages": 8
    }
    ```
    """
    try:
        # Build query with filters
        query = """
            SELECT 
                o.id,
                o.order_id,
                o.bill_number,
                o.shop_id,
                s.name as shop_name,
                o.executive_id as sales_executive_id,
                u.name as sales_executive_name,
                o.order_date,
                o.delivery_date,
                o.status,
                o.total_amount,
                o.items_count,
                t.name as territory_name,
                o.created_at,
                o.updated_at
            FROM orders o
            LEFT JOIN shops s ON o.shop_id = s.id
            LEFT JOIN users u ON o.executive_id = u.id
            LEFT JOIN territories t ON s.territory_id = t.territory_id
            WHERE o.tenant_id = :tenant_id
        """
        
        params = {"tenant_id": tenant_id}
        
        # Apply role-based filtering
        user_role = current_user.get("role")
        user_id = current_user.get("id")
        
        if user_role == "sales_executive":
            # Sales executives only see their own orders
            query += " AND o.executive_id = :user_id"
            params["user_id"] = user_id
        elif user_role == "area_manager":
            # Area managers see orders from their territory
            # First get territory_id from user's territories
            territory_query = """
                SELECT territory_id FROM territories 
                WHERE area_manager_id = :user_id AND tenant_id = :tenant_id
                LIMIT 1
            """
            territory_result = await data_layer.execute_query(territory_query, {"user_id": user_id, "tenant_id": tenant_id})
            if territory_result:
                territory_id = territory_result[0].get("territory_id")
                query += " AND s.territory_id = :territory_id"
                params["territory_id"] = territory_id
        
        # Apply optional filters
        if status:
            query += " AND o.status = :status"
            params["status"] = status
        
        if search:
            query += " AND (o.bill_number LIKE :search OR s.name LIKE :search)"
            params["search"] = f"%{search}%"
        
        if executive_id:
            query += " AND o.executive_id = :executive_id"
            params["executive_id"] = executive_id
        
        if shop_id:
            query += " AND o.shop_id = :shop_id"
            params["shop_id"] = shop_id
        
        if from_date:
            query += " AND o.order_date >= :from_date"
            params["from_date"] = from_date
        
        if to_date:
            query += " AND o.order_date <= :to_date"
            params["to_date"] = to_date
        
        # Get total count
        count_query = f"""
            SELECT COUNT(*) as total
            FROM ({query}) as filtered_orders
        """
        
        count_result = await data_layer.execute_query(count_query, params)
        total = count_result[0].get("total", 0) if count_result else 0
        
        # Add sorting and pagination
        query += " ORDER BY o.order_date DESC, o.id DESC"
        query += " LIMIT :limit OFFSET :offset"
        
        offset = (page - 1) * page_size
        params["limit"] = page_size
        params["offset"] = offset
        
        # Execute query
        orders = await data_layer.execute_query(query, params)
        
        # Calculate total pages
        pages = (total + page_size - 1) // page_size if total > 0 else 0
        
        return {
            "items": orders,
            "total": total,
            "page": page,
            "page_size": page_size,
            "pages": pages
        }
        
    except Exception as e:
        logger.error(f"Error fetching orders: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch orders"
        )


@router.get(
    "/{order_id}",
    summary="Get single order by ID with items",
    tags=["Orders Management"]
)
async def get_order_by_id(
    order_id: int = Path(..., description="Order ID"),
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    data_layer: DataLayerClient = Depends(get_data_layer_client)
):
    """
    Get single order details with items.
    
    **Business Logic:**
    - Returns complete order information including all items
    - Enforces role-based data access
    - Includes shop, executive, and territory information
    
    **Response Format:**
    ```json
    {
        "id": 1,
        "order_id": "ORD2024001",
        "bill_number": "BILL-2024-0001",
        "shop_id": "AQ-N-001",
        "shop_name": "ABC Store",
        "sales_executive_id": 5,
        "sales_executive_name": "John Doe",
        "order_date": "2024-12-01",
        "delivery_date": "2024-12-05",
        "status": "confirmed",
        "total_amount": 15000.00,
        "notes": "Urgent delivery",
        "territory_name": "North Region",
        "items": [
            {
                "id": 1,
                "product_code": "P001",
                "product_name": "Product A",
                "quantity": 10,
                "unit": "pcs",
                "unit_price": 1000.00,
                "total_price": 10000.00,
                "discount": 0.00,
                "tax_amount": 0.00
            }
        ],
        "created_at": "2024-12-01T10:00:00",
        "updated_at": "2024-12-01T10:00:00"
    }
    ```
    """
    try:
        # Get order details
        order_query = """
            SELECT 
                o.id,
                o.order_id,
                o.bill_number,
                o.shop_id,
                s.name as shop_name,
                o.executive_id as sales_executive_id,
                u.name as sales_executive_name,
                o.order_date,
                o.delivery_date,
                o.status,
                o.total_amount,
                o.items_count,
                o.notes,
                t.name as territory_name,
                o.payment_status,
                o.payment_method,
                o.created_at,
                o.updated_at
            FROM orders o
            LEFT JOIN shops s ON o.shop_id = s.id
            LEFT JOIN users u ON o.executive_id = u.id
            LEFT JOIN territories t ON s.territory_id = t.territory_id
            WHERE o.id = :order_id AND o.tenant_id = :tenant_id
        """
        
        params = {"order_id": order_id, "tenant_id": tenant_id}
        
        # Apply role-based filtering
        user_role = current_user.get("role")
        user_id = current_user.get("id")
        
        if user_role == "sales_executive":
            order_query += " AND o.executive_id = :user_id"
            params["user_id"] = user_id
        elif user_role == "area_manager":
            # Area managers see orders from their territory
            territory_query = """
                SELECT territory_id FROM territories 
                WHERE area_manager_id = :user_id AND tenant_id = :tenant_id
                LIMIT 1
            """
            territory_result = await data_layer.execute_query(territory_query, {"user_id": user_id, "tenant_id": tenant_id})
            if territory_result:
                territory_id = territory_result[0].get("territory_id")
                order_query += " AND s.territory_id = :territory_id"
                params["territory_id"] = territory_id
        
        order_result = await data_layer.execute_query(order_query, params)
        
        if not order_result:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Order not found"
            )
        
        order = order_result[0]
        
        # Get order items
        items_query = """
            SELECT 
                id,
                product_code,
                product_name,
                quantity,
                unit,
                unit_price,
                total_price,
                discount,
                tax_amount
            FROM order_items
            WHERE order_id = :order_id AND tenant_id = :tenant_id
            ORDER BY id
        """
        
        items = await data_layer.execute_query(items_query, {"order_id": order_id, "tenant_id": tenant_id})
        
        # Combine order and items
        order["items"] = items if items else []
        
        return order
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching order {order_id}: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to fetch order"
        )
