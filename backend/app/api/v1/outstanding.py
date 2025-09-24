"""
Outstanding Management API endpoints.

Provides CRUD operations for outstanding payments with proper authentication,
authorization checks, and tenant isolation.
"""

from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query, Path, Body
from datetime import date
from app.api.deps import get_current_user
from app.core.errors import (
    OutstandingNotFoundError, 
    OutstandingAlreadyExistsError, 
    InvalidOutstandingDataError,
    InsufficientPermissionsError
)
from app.services.outstanding_service import get_outstanding_service, OutstandingService
from app.domain.models.outstanding import (
    DueDataCreate, 
    DueDataUpdate, 
    DueDataRead, 
    OutstandingSummary,
    OutstandingFilters,
    OutstandingStatus
)
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.post(
    "/", 
    response_model=DueDataRead, 
    status_code=status.HTTP_201_CREATED,
    summary="Create a new outstanding payment record",
    tags=["Outstanding Management"]
)
async def create_outstanding(
    outstanding_data: DueDataCreate,
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    outstanding_service: OutstandingService = Depends(get_outstanding_service)
):
    """
    Create a new outstanding payment record.
    
    **Business Logic:**
    - Creates outstanding payment records for shops
    - Automatically calculates status (current, upcoming, overdue) based on due date
    - Calculates days overdue for overdue payments
    - Enforces tenant isolation and role-based access control
    
    **Required Fields:**
    - shop_id: Shop identifier
    - shop_name: Shop name
    - amount: Outstanding amount
    - due_date: Due date for payment
    - tenant_id: Tenant identifier (from URL parameter)
    
    **Optional Fields:**
    - sales_executive_id: Sales executive responsible for this shop
    - territory_id: Territory identifier
    - original_amount: Original amount before adjustments
    - last_payment_date: Last payment date
    - notes: Additional notes
    
    **Authorization:**
    - Sales executives can only create records for themselves
    - Area managers can create records for their territory
    - Client admins and superadmins can create records for any user
    
    **Example Request:**
    ```json
    {
        "shop_id": "SHOP001",
        "shop_name": "ABC Store",
        "amount": 1500.00,
        "due_date": "2025-01-15",
        "sales_executive_id": 123,
        "territory_id": "TERR001",
        "notes": "Payment due for January orders"
    }
    ```
    
    **Example Response:**
    ```json
    {
        "id": 456,
        "shop_id": "SHOP001",
        "shop_name": "ABC Store",
        "amount": 1500.00,
        "due_date": "2025-01-15",
        "status": "upcoming",
        "sales_executive_id": 123,
        "territory_id": "TERR001",
        "tenant_id": "test_tenant",
        "days_overdue": null,
        "notes": "Payment due for January orders",
        "created_at": "2025-01-10T10:30:00Z",
        "updated_at": "2025-01-10T10:30:00Z",
        "created_by": 7,
        "updated_by": 7
    }
    ```
    """
    try:
        created_outstanding = await outstanding_service.create_outstanding(
            outstanding_data, tenant_id, current_user
        )
        return created_outstanding
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidOutstandingDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.get(
    "/", 
    response_model=List[OutstandingSummary],
    summary="Get outstanding payments with filtering",
    tags=["Outstanding Management"]
)
async def get_outstanding(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    sales_executive_id: Optional[int] = Query(None, description="Filter by sales executive ID"),
    territory_id: Optional[str] = Query(None, description="Filter by territory ID"),
    status: Optional[OutstandingStatus] = Query(None, description="Filter by status"),
    start_date: Optional[date] = Query(None, description="Filter by start date"),
    end_date: Optional[date] = Query(None, description="Filter by end date"),
    shop_search: Optional[str] = Query(None, description="Search by shop name"),
    min_amount: Optional[float] = Query(None, description="Minimum amount filter"),
    max_amount: Optional[float] = Query(None, description="Maximum amount filter"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    outstanding_service: OutstandingService = Depends(get_outstanding_service)
):
    """
    Get outstanding payments with optional filtering.
    
    **Business Logic:**
    - Returns outstanding payment records with filtering options
    - Enforces role-based data access:
      - Sales executives see only their own records
      - Area managers see records for their territory
      - Client admins and superadmins see all records
    - Supports filtering by various criteria
    
    **Query Parameters:**
    - tenant_id: Tenant identifier (required)
    - sales_executive_id: Filter by sales executive ID (optional)
    - territory_id: Filter by territory ID (optional)
    - status: Filter by status - current, upcoming, or overdue (optional)
    - start_date: Filter by start date (optional)
    - end_date: Filter by end date (optional)
    - shop_search: Search by shop name (optional)
    - min_amount: Minimum amount filter (optional)
    - max_amount: Maximum amount filter (optional)
    
    **Authorization:**
    - All authenticated users can view outstanding data
    - Data is filtered based on user role and permissions
    - Tenant isolation is enforced
    
    **Example Response:**
    ```json
    [
        {
            "due_date": "2025-01-15",
            "shop_name": "ABC Store",
            "amount": 1500.00,
            "status": "upcoming",
            "sales_executive_name": "John Doe",
            "territory_name": "North Territory",
            "days_overdue": null
        },
        {
            "due_date": "2025-01-05",
            "shop_name": "XYZ Mart",
            "amount": 2300.00,
            "status": "overdue",
            "sales_executive_name": "Jane Smith",
            "territory_name": "South Territory",
            "days_overdue": 5
        }
    ]
    ```
    """
    try:
        # Build filters from query parameters
        filters = OutstandingFilters(
            sales_executive_id=sales_executive_id,
            territory_id=territory_id,
            status=status,
            start_date=start_date,
            end_date=end_date,
            shop_search=shop_search,
            min_amount=min_amount,
            max_amount=max_amount
        )
        
        outstanding_list = await outstanding_service.get_outstanding(
            tenant_id, current_user, filters
        )
        return outstanding_list
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get(
    "/{outstanding_id}", 
    response_model=DueDataRead,
    summary="Get outstanding payment by ID",
    tags=["Outstanding Management"]
)
async def get_outstanding_by_id(
    outstanding_id: int = Path(..., description="Outstanding payment ID"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    outstanding_service: OutstandingService = Depends(get_outstanding_service)
):
    """
    Get outstanding payment by ID.
    
    Users can view outstanding records based on their role and permissions.
    """
    try:
        # This would need to be implemented in the service layer
        # For now, we'll use the list endpoint with ID filter
        filters = OutstandingFilters()
        outstanding_list = await outstanding_service.get_outstanding(
            tenant_id, current_user, filters
        )
        
        # Find the specific record (this is a simplified approach)
        for record in outstanding_list:
            if hasattr(record, 'id') and record.id == outstanding_id:
                return record
        
        raise OutstandingNotFoundError(
            message=f"Outstanding record with ID {outstanding_id} not found"
        )
    except OutstandingNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.put(
    "/{outstanding_id}", 
    response_model=DueDataRead,
    summary="Update outstanding payment record",
    tags=["Outstanding Management"]
)
async def update_outstanding(
    outstanding_id: int = Path(..., description="Outstanding payment ID"),
    update_data: DueDataUpdate = Body(..., description="Outstanding data to update"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    outstanding_service: OutstandingService = Depends(get_outstanding_service)
):
    """
    Update outstanding payment record.
    
    **Business Logic:**
    - Updates existing outstanding payment records
    - Automatically recalculates status and days overdue if due_date changes
    - Enforces role-based access control
    
    **Updatable Fields:**
    - shop_name: Shop name
    - amount: Outstanding amount
    - due_date: Due date (triggers status recalculation)
    - status: Manual status override (optional)
    - sales_executive_id: Sales executive assignment
    - territory_id: Territory assignment
    - original_amount: Original amount
    - last_payment_date: Last payment date
    - notes: Additional notes
    
    **Authorization:**
    - Users can only update records they have permission to access
    - Role-based restrictions apply
    """
    try:
        updated_outstanding = await outstanding_service.update_outstanding(
            outstanding_id, update_data, tenant_id, current_user
        )
        return updated_outstanding
    except OutstandingNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
    except InvalidOutstandingDataError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=e.message
        )


@router.delete(
    "/{outstanding_id}", 
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete outstanding payment record",
    tags=["Outstanding Management"]
)
async def delete_outstanding(
    outstanding_id: int = Path(..., description="Outstanding payment ID to delete"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    outstanding_service: OutstandingService = Depends(get_outstanding_service)
):
    """
    Delete outstanding payment record.
    
    **Authorization:**
    - Users can only delete records they have permission to access
    - Role-based restrictions apply
    """
    try:
        await outstanding_service.delete_outstanding(
            outstanding_id, tenant_id, current_user
        )
    except OutstandingNotFoundError as e:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=e.message
        )
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )


@router.get(
    "/summary/statistics", 
    summary="Get outstanding payment summary statistics",
    tags=["Outstanding Management"]
)
async def get_outstanding_summary(
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user),
    outstanding_service: OutstandingService = Depends(get_outstanding_service)
):
    """
    Get outstanding payment summary statistics.
    
    **Business Logic:**
    - Provides summary statistics for outstanding payments
    - Includes counts and totals by status
    - Role-based data filtering applies
    
    **Example Response:**
    ```json
    {
        "total_outstanding": 50000.00,
        "current_payments": 15000.00,
        "upcoming_payments": 20000.00,
        "overdue_payments": 15000.00,
        "total_records": 25,
        "current_count": 8,
        "upcoming_count": 12,
        "overdue_count": 5,
        "average_amount": 2000.00,
        "oldest_overdue_days": 45
    }
    ```
    """
    try:
        summary = await outstanding_service.get_outstanding_summary(
            tenant_id, current_user
        )
        return summary
    except InsufficientPermissionsError as e:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=e.message
        )
