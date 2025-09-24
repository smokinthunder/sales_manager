"""
Outstanding Service Layer

Handles all outstanding payment-related business logic including CRUD operations,
authorization checks, and data filtering with proper tenant isolation.
"""

import logging
from typing import List, Optional, Dict, Any
from datetime import datetime, date, timedelta
from fastapi import HTTPException, status
from app.core.errors import (
    OutstandingNotFoundError, 
    OutstandingAlreadyExistsError, 
    InvalidOutstandingDataError,
    InsufficientPermissionsError
)
from app.services.data_layer_client import get_data_layer_client
from app.domain.models.outstanding import (
    DueDataCreate, 
    DueDataUpdate, 
    DueDataRead, 
    OutstandingSummary,
    OutstandingFilters,
    OutstandingStatus
)

logger = logging.getLogger(__name__)


class OutstandingService:
    """Service for managing outstanding payments with proper security and validation."""
    
    def __init__(self, data_layer_client=None):
        self.data_layer = data_layer_client
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    def _calculate_outstanding_status(self, due_date: date, current_date: date = None) -> OutstandingStatus:
        """
        Calculate outstanding status based on due date.
        
        Args:
            due_date: Due date for payment
            current_date: Current date (defaults to today)
            
        Returns:
            OutstandingStatus: Calculated status
        """
        if current_date is None:
            current_date = date.today()
        
        if due_date < current_date:
            return OutstandingStatus.OVERDUE
        elif due_date == current_date:
            return OutstandingStatus.CURRENT
        else:
            return OutstandingStatus.UPCOMING
    
    def _calculate_days_overdue(self, due_date: date, current_date: date = None) -> int:
        """
        Calculate days overdue for a payment.
        
        Args:
            due_date: Due date for payment
            current_date: Current date (defaults to today)
            
        Returns:
            int: Number of days overdue (0 if not overdue)
        """
        if current_date is None:
            current_date = date.today()
        
        if due_date < current_date:
            return (current_date - due_date).days
        return 0
    
    def _check_authorization(self, current_user: Dict[str, Any], sales_executive_id: Optional[int] = None) -> bool:
        """
        Check if user has permission to access outstanding data.
        
        Args:
            current_user: Current authenticated user
            sales_executive_id: Optional sales executive ID to filter by
            
        Returns:
            bool: True if authorized, False otherwise
        """
        user_role = current_user.get("role")
        user_id = current_user.get("id")
        
        # Superadmin can access all data
        if user_role == "superadmin":
            return True
        
        # Client admin can access all data within their tenant
        if user_role == "client_admin":
            return True
        
        # Area manager can access data for their territory
        if user_role == "area_manager":
            return True
        
        # Sales executive can only access their own data
        if user_role == "sales_executive":
            if sales_executive_id and str(sales_executive_id) != str(user_id):
                return False
            return True
        
        return False
    
    async def create_outstanding(
        self, 
        outstanding_data: DueDataCreate, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Create new outstanding payment record.
        
        Args:
            outstanding_data: Outstanding payment data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Dict: Created outstanding record
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
            InvalidOutstandingDataError: If data is invalid
        """
        # Check authorization
        if not self._check_authorization(current_user, outstanding_data.sales_executive_id):
            raise InsufficientPermissionsError(
                message="You don't have permission to create outstanding records"
            )
        
        # Calculate status and days overdue
        current_date = date.today()
        calculated_status = self._calculate_outstanding_status(outstanding_data.due_date, current_date)
        days_overdue = self._calculate_days_overdue(outstanding_data.due_date, current_date)
        
        # Prepare data for creation
        create_data = outstanding_data.model_dump()
        create_data.update({
            "status": calculated_status,
            "days_overdue": days_overdue if calculated_status == OutstandingStatus.OVERDUE else None,
            "tenant_id": tenant_id,
            "created_by": current_user.get("id"),
            "updated_by": current_user.get("id")
        })
        
        data_layer = await self._get_data_layer()
        
        try:
            # Create outstanding record via Data Layer
            result = await data_layer.create_outstanding(create_data)
            logger.info(f"Created outstanding record for shop {outstanding_data.shop_id}")
            return result
        except Exception as e:
            logger.error(f"Error creating outstanding record: {str(e)}")
            raise InvalidOutstandingDataError(
                message=f"Failed to create outstanding record: {str(e)}"
            )
    
    async def get_outstanding(
        self, 
        tenant_id: str, 
        current_user: Dict[str, Any], 
        filters: Optional[OutstandingFilters] = None
    ) -> List[OutstandingSummary]:
        """
        Get outstanding payments with filtering and authorization.
        
        Args:
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            filters: Optional filters for the query
            
        Returns:
            List[OutstandingSummary]: List of outstanding payments
            
        Raises:
            InsufficientPermissionsError: If user lacks permission
        """
        # Check authorization
        if not self._check_authorization(current_user, filters.sales_executive_id if filters else None):
            raise InsufficientPermissionsError(
                message="You don't have permission to view outstanding data"
            )
        
        # Enforce tenant isolation
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only view outstanding data from your own tenant"
            )
        
        # Apply role-based filtering
        query_filters = {}
        if filters:
            query_filters = filters.model_dump(exclude_none=True)
        
        # Sales executives can only see their own data
        if current_user.get("role") == "sales_executive":
            query_filters["sales_executive_id"] = current_user.get("id")
        
        # Area managers can filter by territory if needed
        if current_user.get("role") == "area_manager" and current_user.get("territory_id"):
            # If no territory filter specified, show only their territory
            if not query_filters.get("territory_id"):
                query_filters["territory_id"] = current_user.get("territory_id")
        
        data_layer = await self._get_data_layer()
        
        try:
            # Get outstanding data via Data Layer
            outstanding_data = await data_layer.get_outstanding(tenant_id, query_filters)
            
            # Convert to summary format
            summaries = []
            for item in outstanding_data:
                summary = OutstandingSummary(
                    due_date=item["due_date"],
                    shop_name=item["shop_name"],
                    amount=item["amount"],
                    status=item["status"],
                    sales_executive_name=item.get("sales_executive_name"),
                    territory_name=item.get("territory_name"),
                    days_overdue=item.get("days_overdue")
                )
                summaries.append(summary)
            
            logger.info(f"Retrieved {len(summaries)} outstanding records for tenant {tenant_id}")
            return summaries
        except Exception as e:
            logger.error(f"Error retrieving outstanding data: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve outstanding data"
            )
    
    async def update_outstanding(
        self, 
        outstanding_id: int, 
        update_data: DueDataUpdate, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Update existing outstanding payment record.
        
        Args:
            outstanding_id: Outstanding record ID
            update_data: Update data
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Dict: Updated outstanding record
            
        Raises:
            OutstandingNotFoundError: If record not found
            InsufficientPermissionsError: If user lacks permission
        """
        # Get existing record first
        data_layer = await self._get_data_layer()
        existing_record = await data_layer.get_outstanding_by_id(outstanding_id, tenant_id)
        
        if not existing_record:
            raise OutstandingNotFoundError(
                message=f"Outstanding record with ID {outstanding_id} not found"
            )
        
        # Check authorization
        if not self._check_authorization(current_user, existing_record.get("sales_executive_id")):
            raise InsufficientPermissionsError(
                message="You don't have permission to update this outstanding record"
            )
        
        # Calculate new status if due_date is being updated
        update_dict = update_data.model_dump(exclude_none=True)
        if "due_date" in update_dict:
            current_date = date.today()
            calculated_status = self._calculate_outstanding_status(update_dict["due_date"], current_date)
            days_overdue = self._calculate_days_overdue(update_dict["due_date"], current_date)
            update_dict.update({
                "status": calculated_status,
                "days_overdue": days_overdue if calculated_status == OutstandingStatus.OVERDUE else None
            })
        
        update_dict["updated_by"] = current_user.get("id")
        
        try:
            # Update outstanding record via Data Layer
            result = await data_layer.update_outstanding(outstanding_id, update_dict, tenant_id)
            logger.info(f"Updated outstanding record {outstanding_id}")
            return result
        except Exception as e:
            logger.error(f"Error updating outstanding record: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to update outstanding record"
            )
    
    async def delete_outstanding(
        self, 
        outstanding_id: int, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> bool:
        """
        Delete outstanding payment record.
        
        Args:
            outstanding_id: Outstanding record ID
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            bool: True if deleted successfully
            
        Raises:
            OutstandingNotFoundError: If record not found
            InsufficientPermissionsError: If user lacks permission
        """
        # Get existing record first
        data_layer = await self._get_data_layer()
        existing_record = await data_layer.get_outstanding_by_id(outstanding_id, tenant_id)
        
        if not existing_record:
            raise OutstandingNotFoundError(
                message=f"Outstanding record with ID {outstanding_id} not found"
            )
        
        # Check authorization
        if not self._check_authorization(current_user, existing_record.get("sales_executive_id")):
            raise InsufficientPermissionsError(
                message="You don't have permission to delete this outstanding record"
            )
        
        try:
            # Delete outstanding record via Data Layer
            await data_layer.delete_outstanding(outstanding_id, tenant_id)
            logger.info(f"Deleted outstanding record {outstanding_id}")
            return True
        except Exception as e:
            logger.error(f"Error deleting outstanding record: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to delete outstanding record"
            )
    
    async def get_outstanding_summary(
        self, 
        tenant_id: str, 
        current_user: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Get outstanding payment summary statistics.
        
        Args:
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            Dict: Summary statistics
        """
        # Check authorization
        if not self._check_authorization(current_user):
            raise InsufficientPermissionsError(
                message="You don't have permission to view outstanding summary"
            )
        
        # Enforce tenant isolation
        user_tenant_id = current_user.get("tenant_id")
        if current_user.get("role") != "superadmin" and tenant_id != user_tenant_id:
            raise InsufficientPermissionsError(
                message="You can only view outstanding summary from your own tenant"
            )
        
        data_layer = await self._get_data_layer()
        
        try:
            # Get summary statistics via Data Layer
            summary = await data_layer.get_outstanding_summary(tenant_id, current_user)
            logger.info(f"Retrieved outstanding summary for tenant {tenant_id}")
            return summary
        except Exception as e:
            logger.error(f"Error retrieving outstanding summary: {str(e)}")
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail="Failed to retrieve outstanding summary"
            )


# Service dependency
async def get_outstanding_service() -> OutstandingService:
    """Get Outstanding Service instance."""
    return OutstandingService()
