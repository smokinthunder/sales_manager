"""
Visits API endpoints.

Provides CRUD operations for shop visits and visit tracking.
"""

from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_, or_
from datetime import datetime, date, timedelta
from pydantic import BaseModel, Field

from app.api.deps import get_current_user, get_db, get_tenant_id
from app.domain.models import User, Visit, VisitCreate, VisitUpdate, VisitRead, VisitStatus
from app.core.database import get_session

router = APIRouter()


class ShopVisitStatus(BaseModel):
    """Schema for shop visit status response."""
    shop_id: str
    last_visit_date: Optional[datetime] = None
    days_since_visit: int = 0
    visit_count_this_month: int = 0
    last_order_date: Optional[datetime] = None
    orders_this_month: int = 0


@router.get("/", response_model=dict)
async def get_visits(
    executive_id: Optional[int] = Query(None, description="Filter by executive ID"),
    shop_id: Optional[str] = Query(None, description="Filter by shop ID"),
    visit_date: Optional[date] = Query(None, alias="date", description="Filter by specific date (default: today)"),
    from_date: Optional[date] = Query(None, description="Filter from this date"),
    to_date: Optional[date] = Query(None, description="Filter to this date"),
    status_filter: Optional[VisitStatus] = Query(None, alias="status", description="Filter by visit status"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get all visits with filtering and pagination.
    
    - **executive_id**: Filter by sales executive
    - **shop_id**: Filter by shop
    - **date**: Filter by specific date (default: today)
    - **from_date**: Filter visits from this date
    - **to_date**: Filter visits to this date
    - **status**: Filter by visit status (planned, completed, cancelled, etc.)
    - **page**: Page number (default: 1)
    - **page_size**: Items per page (default: 20, max: 100)
    """
    
    # Build the query
    query = select(Visit).where(Visit.tenant_id == tenant_id)
    
    # Apply filters
    if executive_id:
        query = query.where(Visit.sales_executive_id == executive_id)
    
    if shop_id:
        query = query.where(Visit.shop_id == shop_id)
    
    if visit_date:
        query = query.where(Visit.planned_date == visit_date)
    elif not from_date and not to_date:
        # Default to today if no date filters specified
        query = query.where(Visit.planned_date == date.today())
    
    if from_date:
        query = query.where(Visit.planned_date >= from_date)
    
    if to_date:
        query = query.where(Visit.planned_date <= to_date)
    
    if status_filter:
        query = query.where(Visit.status == status_filter)
    
    # Get total count
    count_query = select(func.count()).select_from(query.subquery())
    result = await db.execute(count_query)
    total = result.scalar() or 0
    
    # Apply pagination and ordering
    query = query.order_by(Visit.planned_date.desc(), Visit.check_in_time.desc())
    query = query.offset((page - 1) * page_size).limit(page_size)
    
    # Execute query
    result = await db.execute(query)
    visits = result.scalars().all()
    
    # Convert to response format with enhanced data
    items = []
    for visit in visits:
        # Parse photos JSON if present
        photos_list = []
        if visit.photos:
            import json
            try:
                photos_list = json.loads(visit.photos)
            except:
                photos_list = []
        
        # Check if order was placed (you may want to query orders table)
        order_placed = False
        order_id = None
        # TODO: Query orders table to check if order exists for this visit
        
        visit_data = {
            "id": visit.id,
            "visit_id": visit.visit_id,
            "shop_id": visit.shop_id,
            "shop_name": visit.shop.name if visit.shop else None,
            "sales_executive_id": visit.sales_executive_id,
            "executive_name": visit.sales_executive.name if visit.sales_executive else "Unknown",
            "planned_date": visit.planned_date,
            "visit_date": visit.check_in_time.date() if visit.check_in_time else visit.planned_date,
            "visit_time": visit.check_in_time.time() if visit.check_in_time else None,
            "status": visit.status,
            "check_in_time": visit.check_in_time,
            "check_out_time": visit.check_out_time,
            "location_lat": visit.check_in_latitude,
            "location_lng": visit.check_in_longitude,
            "notes": visit.remarks,
            "order_placed": order_placed,
            "order_id": order_id,
            "photos": photos_list,
            "created_at": visit.created_at
        }
        items.append(visit_data)
    
    pages = (total + page_size - 1) // page_size
    
    return {
        "items": items,
        "total": total,
        "page": page,
        "page_size": page_size,
        "pages": pages
    }


@router.get("/shops/{shop_id}/visit-status", response_model=ShopVisitStatus)
async def get_shop_visit_status(
    shop_id: str,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get visit status summary for a specific shop.
    
    Returns:
    - Last visit date
    - Days since last visit
    - Number of visits this month
    - Last order date
    - Number of orders this month
    """
    
    # Get last visit
    last_visit_query = select(Visit).where(
        and_(
            Visit.shop_id == shop_id,
            Visit.tenant_id == tenant_id,
            Visit.status == VisitStatus.COMPLETED
        )
    ).order_by(Visit.check_in_time.desc()).limit(1)
    
    result = await db.execute(last_visit_query)
    last_visit = result.scalar_one_or_none()
    
    last_visit_date = None
    days_since_visit = 0
    
    if last_visit and last_visit.check_in_time:
        last_visit_date = last_visit.check_in_time
        days_since_visit = (datetime.now() - last_visit.check_in_time).days
    
    # Get visits count this month
    month_start = date.today().replace(day=1)
    visit_count_query = select(func.count()).where(
        and_(
            Visit.shop_id == shop_id,
            Visit.tenant_id == tenant_id,
            Visit.planned_date >= month_start,
            Visit.status == VisitStatus.COMPLETED
        )
    )
    
    result = await db.execute(visit_count_query)
    visit_count_this_month = result.scalar() or 0
    
    # TODO: Query orders table for order statistics
    last_order_date = None
    orders_this_month = 0
    
    return ShopVisitStatus(
        shop_id=shop_id,
        last_visit_date=last_visit_date,
        days_since_visit=days_since_visit,
        visit_count_this_month=visit_count_this_month,
        last_order_date=last_order_date,
        orders_this_month=orders_this_month
    )


@router.get("/{visit_id}", response_model=VisitRead)
async def get_visit(
    visit_id: int,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get a specific visit by ID.
    """
    
    query = select(Visit).where(
        and_(
            Visit.id == visit_id,
            Visit.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    visit = result.scalar_one_or_none()
    
    if not visit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Visit with id {visit_id} not found"
        )
    
    return visit


@router.post("/", response_model=VisitRead, status_code=status.HTTP_201_CREATED)
async def create_visit(
    visit_data: VisitCreate,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Create a new visit record.
    """
    
    visit = Visit(
        visit_id=visit_data.visit_id,
        planned_date=visit_data.planned_date,
        status=visit_data.status,
        check_in_time=visit_data.check_in_time,
        check_in_latitude=visit_data.check_in_latitude,
        check_in_longitude=visit_data.check_in_longitude,
        check_in_accuracy=visit_data.check_in_accuracy,
        check_out_time=visit_data.check_out_time,
        check_out_latitude=visit_data.check_out_latitude,
        check_out_longitude=visit_data.check_out_longitude,
        check_out_accuracy=visit_data.check_out_accuracy,
        duration_minutes=visit_data.duration_minutes,
        remarks=visit_data.remarks,
        next_visit_date=visit_data.next_visit_date,
        photos=visit_data.photos,
        shop_id=visit_data.shop_id,
        sales_executive_id=visit_data.sales_executive_id,
        route_id=visit_data.route_id,
        tenant_id=tenant_id,
        created_by=current_user.id,
        updated_by=current_user.id
    )
    
    db.add(visit)
    await db.commit()
    await db.refresh(visit)
    
    return visit


@router.put("/{visit_id}", response_model=VisitRead)
async def update_visit(
    visit_id: int,
    visit_data: VisitUpdate,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Update an existing visit.
    """
    
    query = select(Visit).where(
        and_(
            Visit.id == visit_id,
            Visit.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    visit = result.scalar_one_or_none()
    
    if not visit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Visit with id {visit_id} not found"
        )
    
    # Update fields
    update_data = visit_data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(visit, field, value)
    
    visit.updated_by = current_user.id
    visit.updated_at = datetime.utcnow()
    
    await db.commit()
    await db.refresh(visit)
    
    return visit


@router.delete("/{visit_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_visit(
    visit_id: int,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Delete a visit.
    """
    
    query = select(Visit).where(
        and_(
            Visit.id == visit_id,
            Visit.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    visit = result.scalar_one_or_none()
    
    if not visit:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Visit with id {visit_id} not found"
        )
    
    await db.delete(visit)
    await db.commit()
    
    return None
