"""
Shop Assignments API endpoints.

Provides CRUD operations for shop-executive assignments.
"""

from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from datetime import datetime

from app.api.deps import get_current_user, get_db, get_tenant_id
from app.domain.models import (
    User, ShopAssignment, ShopAssignmentCreate, ShopAssignmentUpdate,
    ShopAssignmentRead, ShopAssignmentListItem, AssignmentStatus
)
from app.core.database import get_session

router = APIRouter()


@router.get("/", response_model=dict)
async def get_shop_assignments(
    shop_id: Optional[str] = Query(None, description="Filter by shop ID"),
    executive_id: Optional[int] = Query(None, description="Filter by executive ID"),
    status_filter: Optional[AssignmentStatus] = Query(None, alias="status", description="Filter by assignment status"),
    territory_id: Optional[str] = Query(None, description="Filter by territory ID"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get all shop assignments with filtering and pagination.
    
    - **shop_id**: Filter by shop
    - **executive_id**: Filter by sales executive
    - **status**: Filter by assignment status (active, inactive, suspended, transferred)
    - **territory_id**: Filter by territory
    - **page**: Page number (default: 1)
    - **page_size**: Items per page (default: 20, max: 100)
    """
    
    # Build the query
    query = select(ShopAssignment).where(ShopAssignment.tenant_id == tenant_id)
    
    # Apply filters
    if shop_id:
        query = query.where(ShopAssignment.shop_id == shop_id)
    
    if executive_id:
        query = query.where(ShopAssignment.executive_id == executive_id)
    
    if status_filter:
        query = query.where(ShopAssignment.status == status_filter)
    
    if territory_id:
        query = query.where(ShopAssignment.territory_id == territory_id)
    
    # Get total count
    count_query = select(func.count()).select_from(query.subquery())
    result = await db.execute(count_query)
    total = result.scalar() or 0
    
    # Apply pagination and ordering
    query = query.order_by(ShopAssignment.assigned_date.desc())
    query = query.offset((page - 1) * page_size).limit(page_size)
    
    # Execute query
    result = await db.execute(query)
    assignments = result.scalars().all()
    
    # Convert to response format
    items = []
    for assignment in assignments:
        item = ShopAssignmentListItem(
            id=assignment.id,
            shop_id=assignment.shop_id,
            shop_name=assignment.shop.name if assignment.shop else None,
            shop_location=assignment.shop.location_name or assignment.shop.address if assignment.shop else None,
            executive_id=assignment.executive_id,
            executive_name=assignment.executive.name if assignment.executive else "Unknown",
            executive_phone=assignment.executive.phone if assignment.executive else "N/A",
            assigned_date=assignment.assigned_date,
            status=assignment.status,
            territory_id=assignment.territory_id,
            territory_name=assignment.territory.name if assignment.territory else None,
            tenant_id=assignment.tenant_id,
            created_at=assignment.created_at,
            updated_at=assignment.updated_at
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


@router.get("/{assignment_id}", response_model=ShopAssignmentRead)
async def get_shop_assignment(
    assignment_id: int,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Get a specific shop assignment by ID.
    """
    
    query = select(ShopAssignment).where(
        and_(
            ShopAssignment.id == assignment_id,
            ShopAssignment.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    assignment = result.scalar_one_or_none()
    
    if not assignment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Shop assignment with id {assignment_id} not found"
        )
    
    # Convert to response format
    assignment_read = ShopAssignmentRead(
        id=assignment.id,
        shop_id=assignment.shop_id,
        shop_name=assignment.shop.name if assignment.shop else None,
        shop_location=assignment.shop.location_name or assignment.shop.address if assignment.shop else None,
        executive_id=assignment.executive_id,
        executive_name=assignment.executive.name if assignment.executive else "Unknown",
        executive_phone=assignment.executive.phone if assignment.executive else "N/A",
        executive_email=assignment.executive.email if assignment.executive else None,
        territory_id=assignment.territory_id,
        territory_name=assignment.territory.name if assignment.territory else None,
        assigned_date=assignment.assigned_date,
        status=assignment.status,
        notes=assignment.notes,
        end_date=assignment.end_date,
        created_at=assignment.created_at,
        updated_at=assignment.updated_at
    )
    
    return assignment_read


@router.post("/", response_model=ShopAssignmentRead, status_code=status.HTTP_201_CREATED)
async def create_shop_assignment(
    assignment_data: ShopAssignmentCreate,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Create a new shop assignment.
    """
    
    # Check if active assignment already exists
    existing_query = select(ShopAssignment).where(
        and_(
            ShopAssignment.shop_id == assignment_data.shop_id,
            ShopAssignment.executive_id == assignment_data.executive_id,
            ShopAssignment.status == AssignmentStatus.ACTIVE,
            ShopAssignment.tenant_id == tenant_id
        )
    )
    result = await db.execute(existing_query)
    existing = result.scalar_one_or_none()
    
    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Active assignment already exists for this shop and executive"
        )
    
    # Create the assignment
    assignment = ShopAssignment(
        shop_id=assignment_data.shop_id,
        executive_id=assignment_data.executive_id,
        territory_id=assignment_data.territory_id,
        assigned_date=assignment_data.assigned_date,
        status=assignment_data.status,
        notes=assignment_data.notes,
        end_date=assignment_data.end_date,
        tenant_id=tenant_id,
        created_by=current_user.id,
        updated_by=current_user.id
    )
    
    db.add(assignment)
    await db.commit()
    await db.refresh(assignment)
    
    # Return the created assignment
    return await get_shop_assignment(assignment.id, db, current_user, tenant_id)


@router.put("/{assignment_id}", response_model=ShopAssignmentRead)
async def update_shop_assignment(
    assignment_id: int,
    assignment_data: ShopAssignmentUpdate,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Update an existing shop assignment.
    """
    
    query = select(ShopAssignment).where(
        and_(
            ShopAssignment.id == assignment_id,
            ShopAssignment.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    assignment = result.scalar_one_or_none()
    
    if not assignment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Shop assignment with id {assignment_id} not found"
        )
    
    # Update fields
    update_data = assignment_data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(assignment, field, value)
    
    assignment.updated_by = current_user.id
    assignment.updated_at = datetime.utcnow()
    
    await db.commit()
    await db.refresh(assignment)
    
    return await get_shop_assignment(assignment.id, db, current_user, tenant_id)


@router.delete("/{assignment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_shop_assignment(
    assignment_id: int,
    db: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user),
    tenant_id: str = Depends(get_tenant_id)
):
    """
    Delete a shop assignment.
    """
    
    query = select(ShopAssignment).where(
        and_(
            ShopAssignment.id == assignment_id,
            ShopAssignment.tenant_id == tenant_id
        )
    )
    result = await db.execute(query)
    assignment = result.scalar_one_or_none()
    
    if not assignment:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Shop assignment with id {assignment_id} not found"
        )
    
    await db.delete(assignment)
    await db.commit()
    
    return None
