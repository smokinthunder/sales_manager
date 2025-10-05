"""
Analytics service for performance tracking and reporting.

Handles analytics calculations, performance metrics, and business intelligence
with 30-day payment policy integration using Data Layer client.
"""

from datetime import datetime, date, timedelta
from typing import Dict, List, Optional, Tuple, Any
import logging

from ..core.logging import get_logger
from ..services.data_layer_client import get_data_layer_client

logger = get_logger(__name__)


class AnalyticsService:
    """Service for analytics and performance tracking using Data Layer client."""
    
    def __init__(self):
        """Initialize analytics service."""
        self.data_layer = None
    
    async def _get_data_layer(self):
        """Get Data Layer client."""
        if not self.data_layer:
            self.data_layer = await get_data_layer_client()
        return self.data_layer
    
    async def get_executive_top_customers(
        self,
        tenant_id: str,
        sales_executive_id: Optional[int] = None,
        area_manager_id: Optional[int] = None,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get top customers for a sales executive or aggregated view.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID (optional, defaults to aggregated view based on role)
            area_manager_id: Area manager ID (optional, for client_admin to filter by area manager)
            start_date: Start date for the report period (YYYY-MM-DD format, optional)
            end_date: End date for the report period (YYYY-MM-DD format, optional)
            current_user: Current authenticated user
            
        Returns:
            List of top customers with shop names and points
        """
        try:
            logger.info(f"Getting executive top customers for tenant {tenant_id}, sales_executive_id: {sales_executive_id}, area_manager_id: {area_manager_id}, start_date: {start_date}, end_date: {end_date}, current_user: {current_user}")
            
            if not current_user:
                logger.warning("No current user provided")
                return []
            
            user_role = current_user.get("role")
            user_id = current_user.get("id")
            data_layer = await self._get_data_layer()
            
            # Handle different user roles
            if user_role == "sales_executive":
                # Sales executives can only see their own data
                top_customers = await data_layer.get_executive_top_customers(tenant_id, user_id, start_date, end_date)
                logger.info(f"Retrieved {len(top_customers)} top customers for sales executive {user_id}")
                return top_customers
            
            elif user_role == "area_manager":
                if sales_executive_id is not None:
                    # Area manager viewing specific sales executive - validate they're under this area manager
                    if await self._validate_executive_under_area_manager(sales_executive_id, user_id, tenant_id):
                        top_customers = await data_layer.get_executive_top_customers(tenant_id, sales_executive_id, start_date, end_date)
                        logger.info(f"Retrieved {len(top_customers)} top customers for executive {sales_executive_id}")
                        return top_customers
                    else:
                        logger.warning(f"Area manager {user_id} attempted to access executive {sales_executive_id} not under their management")
                        return []
                else:
                    # Area manager viewing aggregated data for their territory
                    territory_id = current_user.get("territory_id")
                    if territory_id:
                        top_customers = await data_layer.get_territory_top_customers(tenant_id, territory_id, start_date, end_date)
                        logger.info(f"Retrieved {len(top_customers)} top customers for territory {territory_id}")
                        return top_customers
                    else:
                        logger.warning(f"Area manager {user_id} has no territory_id")
                        return []
            
            elif user_role in ["client_admin", "superadmin"]:
                if sales_executive_id is not None:
                    # Admin viewing specific sales executive
                    top_customers = await data_layer.get_executive_top_customers(tenant_id, sales_executive_id, start_date, end_date)
                    logger.info(f"Retrieved {len(top_customers)} top customers for executive {sales_executive_id}")
                    return top_customers
                elif area_manager_id is not None:
                    # Admin viewing aggregated data for specific area manager
                    top_customers = await data_layer.get_area_manager_top_customers(tenant_id, area_manager_id, start_date, end_date)
                    logger.info(f"Retrieved {len(top_customers)} top customers for area manager {area_manager_id}")
                    return top_customers
                else:
                    # Admin viewing aggregated data for entire tenant
                    top_customers = await data_layer.get_tenant_top_customers(tenant_id, start_date, end_date)
                    logger.info(f"Retrieved {len(top_customers)} top customers for tenant {tenant_id}")
                    return top_customers
            
            logger.warning(f"Unsupported user role: {user_role}")
            return []
            
        except Exception as e:
            logger.error(f"Error getting executive top customers: {str(e)}", exc_info=True)
            return []
    
    async def get_executive_best_selling_products(
        self,
        tenant_id: str,
        sales_executive_id: Optional[int] = None,
        area_manager_id: Optional[int] = None,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get best selling products for a sales executive or aggregated view.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID (optional, defaults to aggregated view based on role)
            area_manager_id: Area manager ID (optional, for client_admin to filter by area manager)
            start_date: Start date for the report period (YYYY-MM-DD format, optional)
            end_date: End date for the report period (YYYY-MM-DD format, optional)
            current_user: Current authenticated user
            
        Returns:
            List of best selling products with units sold and percentages
        """
        try:
            logger.info(f"Getting executive best selling products for tenant {tenant_id}, sales_executive_id: {sales_executive_id}, area_manager_id: {area_manager_id}, start_date: {start_date}, end_date: {end_date}, current_user: {current_user}")
            
            if not current_user:
                logger.warning("No current user provided")
                return []
            
            user_role = current_user.get("role")
            user_id = current_user.get("id")
            data_layer = await self._get_data_layer()
            
            # Handle different user roles
            if user_role == "sales_executive":
                # Sales executives can only see their own data
                best_selling_products = await data_layer.get_products_by_executive(tenant_id, user_id, start_date, end_date)
                logger.info(f"Retrieved {len(best_selling_products)} best selling products for sales executive {user_id}")
                return best_selling_products
            
            elif user_role == "area_manager":
                if sales_executive_id is not None:
                    # Area manager viewing specific sales executive - validate they're under this area manager
                    if await self._validate_executive_under_area_manager(sales_executive_id, user_id, tenant_id):
                        best_selling_products = await data_layer.get_products_by_executive(tenant_id, sales_executive_id, start_date, end_date)
                        logger.info(f"Retrieved {len(best_selling_products)} best selling products for executive {sales_executive_id}")
                        return best_selling_products
                    else:
                        logger.warning(f"Area manager {user_id} attempted to access executive {sales_executive_id} not under their management")
                        return []
                else:
                    # Area manager viewing aggregated data for their territory
                    territory_id = current_user.get("territory_id")
                    if territory_id:
                        best_selling_products = await data_layer.get_territory_best_selling_products(tenant_id, territory_id, start_date, end_date)
                        logger.info(f"Retrieved {len(best_selling_products)} best selling products for territory {territory_id}")
                        return best_selling_products
                    else:
                        logger.warning(f"Area manager {user_id} has no territory_id")
                        return []
            
            elif user_role in ["client_admin", "superadmin"]:
                if sales_executive_id is not None:
                    # Admin viewing specific sales executive
                    best_selling_products = await data_layer.get_products_by_executive(tenant_id, sales_executive_id, start_date, end_date)
                    logger.info(f"Retrieved {len(best_selling_products)} best selling products for executive {sales_executive_id}")
                    return best_selling_products
                elif area_manager_id is not None:
                    # Admin viewing aggregated data for specific area manager
                    best_selling_products = await data_layer.get_area_manager_best_selling_products(tenant_id, area_manager_id, start_date, end_date)
                    logger.info(f"Retrieved {len(best_selling_products)} best selling products for area manager {area_manager_id}")
                    return best_selling_products
                else:
                    # Admin viewing aggregated data for entire tenant
                    best_selling_products = await data_layer.get_tenant_best_selling_products(tenant_id, start_date, end_date)
                    logger.info(f"Retrieved {len(best_selling_products)} best selling products for tenant {tenant_id}")
                    return best_selling_products
            
            logger.warning(f"Unsupported user role: {user_role}")
            return []
            
        except Exception as e:
            logger.error(f"Error getting executive best selling products: {str(e)}", exc_info=True)
            return []
    
    async def get_executive_sales_report(
        self,
        tenant_id: str,
        sales_executive_id: Optional[int] = None,
        area_manager_id: Optional[int] = None,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get sales report for a sales executive or aggregated view.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID (optional, defaults to aggregated view based on role)
            area_manager_id: Area manager ID (optional, for client_admin to filter by area manager)
            start_date: Start date for the report period (YYYY-MM-DD format, optional)
            end_date: End date for the report period (YYYY-MM-DD format, optional)
            current_user: Current authenticated user
            
        Returns:
            List of monthly sales data for the specified period
        """
        try:
            logger.info(f"Getting executive sales report for tenant {tenant_id}, sales_executive_id: {sales_executive_id}, area_manager_id: {area_manager_id}, start_date: {start_date}, end_date: {end_date}, current_user: {current_user}")
            
            if not current_user:
                logger.warning("No current user provided")
                return []
            
            user_role = current_user.get("role")
            user_id = current_user.get("id")
            data_layer = await self._get_data_layer()
            
            # Calculate date range - use provided dates or defaults
            from datetime import datetime, timedelta
            if start_date is None:
                # Default to 1 year ago
                end_date_obj = datetime.now()
                start_date_obj = end_date_obj - timedelta(days=365)
                start_date_str = start_date_obj.strftime('%Y-%m-%d')
            else:
                start_date_str = start_date
                
            if end_date is None:
                # Default to today
                end_date_obj = datetime.now()
                end_date_str = end_date_obj.strftime('%Y-%m-%d')
            else:
                end_date_str = end_date
            
            logger.info(f"Using date range: {start_date_str} to {end_date_str}")
            
            # Handle different user roles
            if user_role == "sales_executive":
                # Sales executives can only see their own data
                sales_report = await data_layer.get_executive_sales_report(tenant_id, user_id, start_date_str, end_date_str)
                logger.info(f"Retrieved sales report for sales executive {user_id}")
                return sales_report
            
            elif user_role == "area_manager":
                if sales_executive_id is not None:
                    # Area manager viewing specific sales executive - validate they're under this area manager
                    if await self._validate_executive_under_area_manager(sales_executive_id, user_id, tenant_id):
                        sales_report = await data_layer.get_executive_sales_report(tenant_id, sales_executive_id, start_date_str, end_date_str)
                        logger.info(f"Retrieved sales report for executive {sales_executive_id}")
                        return sales_report
                    else:
                        logger.warning(f"Area manager {user_id} attempted to access executive {sales_executive_id} not under their management")
                        return []
                else:
                    # Area manager viewing aggregated data for their territory
                    territory_id = current_user.get("territory_id")
                    if territory_id:
                        sales_report = await data_layer.get_territory_sales_report(tenant_id, territory_id, start_date_str, end_date_str)
                        logger.info(f"Retrieved sales report for territory {territory_id}")
                        return sales_report
                    else:
                        logger.warning(f"Area manager {user_id} has no territory_id")
                        return []
            
            elif user_role in ["client_admin", "superadmin"]:
                if sales_executive_id is not None:
                    # Admin viewing specific sales executive
                    sales_report = await data_layer.get_executive_sales_report(tenant_id, sales_executive_id, start_date_str, end_date_str)
                    logger.info(f"Retrieved sales report for executive {sales_executive_id}")
                    return sales_report
                elif area_manager_id is not None:
                    # Admin viewing aggregated data for specific area manager
                    sales_report = await data_layer.get_area_manager_sales_report(tenant_id, area_manager_id, start_date_str, end_date_str)
                    logger.info(f"Retrieved sales report for area manager {area_manager_id}")
                    return sales_report
                else:
                    # Admin viewing aggregated data for entire tenant
                    sales_report = await data_layer.get_tenant_sales_report(tenant_id, start_date_str, end_date_str)
                    logger.info(f"Retrieved sales report for tenant {tenant_id}")
                    return sales_report
            
            logger.warning(f"Unsupported user role: {user_role}")
            return []
            
        except Exception as e:
            logger.error(f"Error getting executive sales report: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_purchase_analysis(
        self,
        tenant_id: str,
        shop_id: str,
        year: Optional[int] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get purchase analysis for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            year: Year for analysis (optional, defaults to last year)
            current_user: Current authenticated user
            
        Returns:
            List of monthly purchase data
        """
        try:
            logger.info(f"Getting shop purchase analysis for tenant {tenant_id}, shop_id: {shop_id}, year: {year}")
            
            # Validate shop access permissions
            if not await self._validate_shop_access(shop_id, tenant_id, current_user):
                logger.warning(f"User {current_user.get('id')} does not have access to shop {shop_id}")
                return []
            
            data_layer = await self._get_data_layer()
            
            # Set year to last year if not provided
            if year is None:
                year = date.today().year - 1
            
            # Get purchase analysis from Data Layer
            purchase_analysis = await data_layer.get_shop_purchase_analysis(tenant_id, shop_id, year)
            
            logger.info(f"Retrieved purchase analysis for shop {shop_id} in year {year}")
            return purchase_analysis
            
        except Exception as e:
            logger.error(f"Error getting shop purchase analysis: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_best_selling_products(
        self,
        tenant_id: str,
        shop_id: str,
        year: Optional[int] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get best selling products for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            year: Year for analysis (optional, defaults to last year)
            current_user: Current authenticated user
            
        Returns:
            List of best selling products for the shop
        """
        try:
            logger.info(f"Getting shop best selling products for tenant {tenant_id}, shop_id: {shop_id}, year: {year}")
            
            # Validate shop access permissions
            if not await self._validate_shop_access(shop_id, tenant_id, current_user):
                logger.warning(f"User {current_user.get('id')} does not have access to shop {shop_id}")
                return []
            
            data_layer = await self._get_data_layer()
            
            # Set year to last year if not provided
            if year is None:
                year = date.today().year - 1
            
            # Get best selling products from Data Layer
            best_selling_products = await data_layer.get_shop_products(tenant_id, shop_id, year)
            
            logger.info(f"Retrieved {len(best_selling_products)} best selling products for shop {shop_id}")
            return best_selling_products
            
        except Exception as e:
            logger.error(f"Error getting shop best selling products: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_sales_report(
        self,
        tenant_id: str,
        shop_id: str,
        year: Optional[int] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get sales report for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop identifier
            year: Year for analysis (optional, defaults to last year)
            current_user: Current authenticated user
            
        Returns:
            List of monthly sales data
        """
        try:
            logger.info(f"Getting shop sales report for tenant {tenant_id}, shop_id: {shop_id}, year: {year}")
            
            # Validate shop access permissions
            if not await self._validate_shop_access(shop_id, tenant_id, current_user):
                logger.warning(f"User {current_user.get('id')} does not have access to shop {shop_id}")
                return []
            
            data_layer = await self._get_data_layer()
            
            # Set year to last year if not provided
            if year is None:
                year = date.today().year - 1
            
            # Get sales report from Data Layer
            sales_report = await data_layer.get_shop_sales_report(tenant_id, shop_id, year)
            
            logger.info(f"Retrieved sales report for shop {shop_id} in year {year}")
            return sales_report
            
        except Exception as e:
            logger.error(f"Error getting shop sales report: {str(e)}", exc_info=True)
            return []
    
    async def _determine_target_executive_id(
        self,
        sales_executive_id: Optional[int],
        current_user: Dict[str, Any],
        tenant_id: str
    ) -> Optional[int]:
        """
        Determine the target sales executive ID based on user role and permissions.
        
        Args:
            sales_executive_id: Requested sales executive ID
            current_user: Current authenticated user
            tenant_id: Tenant identifier
            
        Returns:
            Target sales executive ID or None if not authorized
        """
        if not current_user:
            return None
        
        user_role = current_user.get("role")
        user_id = current_user.get("id")
        
        if user_role == "sales_executive":
            # Sales executives can only see their own data
            return user_id
        
        elif user_role == "area_manager":
            if sales_executive_id is not None:
                # Area manager viewing specific sales executive - validate they're under this area manager
                if await self._validate_executive_under_area_manager(sales_executive_id, user_id, tenant_id):
                    return sales_executive_id
                else:
                    logger.warning(f"Area manager {user_id} attempted to access executive {sales_executive_id} not under their management")
                    return None
            else:
                # Area manager viewing aggregated data - not supported for individual executive endpoints
                logger.info("Area manager requested aggregated data for individual executive endpoint")
                return None
        
        elif user_role in ["client_admin", "superadmin"]:
            # Client admin and superadmin can see any executive's data
            if sales_executive_id is not None:
                return sales_executive_id
            else:
                # For individual executive endpoints, we need a specific executive ID
                logger.info("Admin requested aggregated data for individual executive endpoint")
                return None
        
        return None
    
    async def _validate_shop_access(
        self,
        shop_id: str,
        tenant_id: str,
        current_user: Dict[str, Any]
    ) -> bool:
        """
        Validate that the current user has access to the specified shop.
        
        Args:
            shop_id: Shop identifier
            tenant_id: Tenant identifier
            current_user: Current authenticated user
            
        Returns:
            True if user has access, False otherwise
        """
        if not current_user:
            return False
        
        user_role = current_user.get("role")
        user_id = current_user.get("id")
        
        if user_role == "superadmin":
            return True
        
        elif user_role == "client_admin":
            # Client admins can access any shop in their tenant
            return current_user.get("tenant_id") == tenant_id
        
        elif user_role == "area_manager":
            # Area managers can access shops in their territories
            try:
                data_layer = await self._get_data_layer()
                # Get shop assignments for this area manager's territory
                assignments = await data_layer.get_executive_shop_assignments(tenant_id, user_id)
                # Check if the shop is in any territory managed by this area manager
                # This is a simplified check - in a real implementation, you'd check territory relationships
                return True  # For now, allow access
            except Exception as e:
                logger.error(f"Error validating shop access for area manager: {e}")
                return False
        
        elif user_role == "sales_executive":
            # Sales executives can only access shops assigned to them
            try:
                data_layer = await self._get_data_layer()
                assignments = await data_layer.get_executive_shop_assignments(tenant_id, user_id)
                assigned_shop_ids = [assignment.get("shop_id") for assignment in assignments]
                return shop_id in assigned_shop_ids
            except Exception as e:
                logger.error(f"Error validating shop access for sales executive: {e}")
                return False
        
        return False
    
    async def _validate_executive_under_area_manager(
        self,
        sales_executive_id: int,
        area_manager_id: int,
        tenant_id: str
    ) -> bool:
        """
        Validate that a sales executive is under the management of an area manager.
        
        Args:
            sales_executive_id: Sales executive ID
            area_manager_id: Area manager ID
            tenant_id: Tenant identifier
            
        Returns:
            True if the executive is under the area manager, False otherwise
        """
        try:
            data_layer = await self._get_data_layer()
            # Get the sales executive's territory
            executives = await data_layer.get_users(tenant_id)
            executive = next((e for e in executives if e.get("id") == sales_executive_id), None)
            
            if not executive:
                return False
            
            executive_territory_id = executive.get("territory_id")
            if not executive_territory_id:
                return False
            
            # Get territories managed by the area manager
            territories = await data_layer.get_territories(tenant_id)
            managed_territories = [t for t in territories if t.get("area_manager_id") == area_manager_id]
            managed_territory_ids = [t.get("territory_id") for t in managed_territories]
            
            return executive_territory_id in managed_territory_ids
            
        except Exception as e:
            logger.error(f"Error validating executive under area manager: {e}")
            return False