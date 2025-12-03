"""
Orders API endpoints.

Provides CRUD operations for orders and order items.
"""

from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, or_, and_
from datetime import datetime, date

from app.api.deps import get_current_user, get_db, get_tenant_id
from app.domain.models import (
    User, Order, OrderItem, OrderCreate, OrderUpdate, OrderRead, OrderListItem,
    OrderStatus
)
from app.core.database import get_session

router = APIRouter()


@router.get("/", response_model=dict)
async def get_orders(
    status_filter: Optional[OrderStatus] = Query(None, alias="status", description="Filter by order status"),
    search: Optional[str] = Query(None, description="Search by bill number or shop name"),
    executive_id: Optional[int] = Query(None, description="Filter by sales executive ID"),
    shop_id: Optional[str] = Query(None, description="Filter by shop ID"),
    from_date: Optional[date] = Query(None, description="Filter from this date"),
    to_date: Optional[date] = Query(None, description="Filter to this date"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get all orders with filtering and pagination.
    
    - **status**: Filter by order status (pending, completed, cancelled, etc.)
    - **search**: Search orders by bill number or shop name
    - **executive_id**: Filter by sales executive
    - **shop_id**: Filter by shop
    - **from_date**: Filter orders from this date
    - **to_date**: Filter orders to this date
    - **page**: Page number (default: 1)
    - **page_size**: Items per page (default: 20, max: 100)
    """
    
    # Build the query
    query = select(Order).where(Order.tenant_id == tenant_id)
    
    # Apply filters
    if status_filter:
        query = query.where(Order.status == status_filter)
    
    if executive_id:
        query = query.where(Order.executive_id == executive_id)
    
    if shop_id:
        query = query.where(Order.shop_id == shop_id)
    
    if from_date:
        query = query.where(Order.order_date >= datetime.combine(from_date, datetime.min.time()))
    
    if to_date:
        query = query.where(Order.order_date <= datetime.combine(to_date, datetime.max.time()))
    
    if search:
        # Search in bill number or shop name (via relationship)
        search_pattern = f"%{search}%"
        query = query.where(
            or_(
                Order.bill_number.ilike(search_pattern),
                Order.shop.has(func.lower(Order.shop.name).like(func.lower(search_pattern)))
            )
        )
    
    # Get total count
    count_query = select(func.count()).select_from(query.subquery())
    result = await db.execute(count_query)
    total = result.scalar() or 0
    
    # Apply pagination and ordering
    query = query.order_by(Order.order_date.desc())
    query = query.offset((page - 1) * page_size).limit(page_size)
    
    # Execute query
    result = await db.execute(query)
    orders = result.scalars().all()
    
    # Convert to response format
    items = []
    for order in orders:
        item = OrderListItem(
            id=order.id,
            order_id=order.order_id,
            bill_number=order.bill_number,
            shop_id=order.shop_id,
            shop_name=order.shop.name if order.shop else None,
            shop_location=order.shop.location_name or order.shop.address if order.shop else None,
            executive_id=order.executive_id,
            executive_name=order.executive.name if order.executive else "Unknown",
            executive_phone=order.executive.phone if order.executive else "N/A",
            total_amount=order.total_amount,
            status=order.status,
            order_date=order.order_date,
            items_count=order.items_count,
            tenant_id=order.tenant_id,
            created_at=order.created_at,
            updated_at=order.updated_at
        )
        items.append(item)
    
    pages = (total + page_size - 1) // page_size
    
    return {
        "items": items,
        "total": total,
        "page": page,
        "page_size": page_size,
        "pages": pages
    }


@router.get("/{order_id}", response_model=OrderRead)
async def get_order(
    order_id: int,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get a specific order by ID with all details including items.
    """
    
    query = select(Order).where(
        and_(
            Order.id == order_id,
            Order.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    order = result.scalar_one_or_none()
    
    if not order:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Order with id {order_id} not found"
        )
    
    # Convert to response format
    order_read = OrderRead(
        id=order.id,
        order_id=order.order_id,
        bill_number=order.bill_number,
        shop_id=order.shop_id,
        shop_name=order.shop.name if order.shop else None,
        shop_location=order.shop.location_name or order.shop.address if order.shop else None,
        executive_id=order.executive_id,
        executive_name=order.executive.name if order.executive else "Unknown",
        executive_phone=order.executive.phone if order.executive else "N/A",
        order_date=order.order_date,
        total_amount=order.total_amount,
        status=order.status,
        items_count=order.items_count,
        notes=order.notes,
        delivery_date=order.delivery_date,
        payment_status=order.payment_status,
        payment_method=order.payment_method,
        items=[
            OrderItemRead(
                id=item.id,
                order_id=item.order_id,
                product_code=item.product_code,
                product_name=item.product_name,
                quantity=item.quantity,
                unit=item.unit,
                unit_price=item.unit_price,
                total_price=item.total_price,
                discount=item.discount,
                tax_amount=item.tax_amount,
                created_at=item.created_at,
                updated_at=item.updated_at
            ) for item in order.items
        ],
        created_at=order.created_at,
        updated_at=order.updated_at
    )
    
    return order_read


@router.post("/", response_model=OrderRead, status_code=status.HTTP_201_CREATED)
async def create_order(
    order_data: OrderCreate,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Create a new order with items.
    """
    
    # Create the order
    order = Order(
        order_id=order_data.order_id,
        bill_number=order_data.bill_number,
        shop_id=order_data.shop_id,
        executive_id=order_data.executive_id,
        order_date=order_data.order_date,
        total_amount=order_data.total_amount,
        status=order_data.status,
        items_count=len(order_data.items),
        notes=order_data.notes,
        delivery_date=order_data.delivery_date,
        payment_status=order_data.payment_status,
        payment_method=order_data.payment_method,
        tenant_id=tenant_id,
        created_by=current_user.id,
        updated_by=current_user.id
    )
    
    db.add(order)
    await db.flush()  # Get the order ID
    
    # Create order items
    for item_data in order_data.items:
        item = OrderItem(
            order_id=order.id,
            product_code=item_data.product_code,
            product_name=item_data.product_name,
            quantity=item_data.quantity,
            unit=item_data.unit,
            unit_price=item_data.unit_price,
            total_price=item_data.total_price,
            discount=item_data.discount,
            tax_amount=item_data.tax_amount,
            tenant_id=tenant_id,
            created_by=current_user.id,
            updated_by=current_user.id
        )
        db.add(item)
    
    await db.commit()
    await db.refresh(order)
    
    # Return the created order
    return await get_order(order.id, db, current_user, tenant_id)


@router.put("/{order_id}", response_model=OrderRead)
async def update_order(
    order_id: int,
    order_data: OrderUpdate,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Update an existing order.
    """
    
    query = select(Order).where(
        and_(
            Order.id == order_id,
            Order.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    order = result.scalar_one_or_none()
    
    if not order:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Order with id {order_id} not found"
        )
    
    # Update fields
    update_data = order_data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(order, field, value)
    
    order.updated_by = current_user.id
    order.updated_at = datetime.utcnow()
    
    await db.commit()
    await db.refresh(order)
    
    return await get_order(order.id, db, current_user, tenant_id)


@router.delete("/{order_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_order(
    order_id: int,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Delete an order and its items.
    """
    
    query = select(Order).where(
        and_(
            Order.id == order_id,
            Order.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    order = result.scalar_one_or_none()
    
    if not order:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Order with id {order_id} not found"
        )
    
    await db.delete(order)
    await db.commit()
    
    return None
