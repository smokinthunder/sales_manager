"""
Analytics API endpoints.

Handles analytics and reporting with 30-day payment policy integration.
"""

from datetime import datetime, date, timedelta
from typing import Dict, Any, List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query, Path
from pydantic import BaseModel, Field

from ...api.deps import get_current_user
from ...core.logging import get_logger
from ...domain.models.analytics import (
    TopCustomerResponse, BestSellingProductResponse, SalesReportResponse,
    PurchaseAnalysisResponse, ShopBestSellingProductResponse, ShopSalesReportResponse
)
from ...services.analytics_service import AnalyticsService

logger = get_logger(__name__)
router = APIRouter(tags=["analytics"])


class AnalyticsPeriod(BaseModel):
    """Request model for analytics period."""
    
    period_start: Optional[date] = Field(None, description="Start date for analytics period")
    period_end: Optional[date] = Field(None, description="End date for analytics period")


# Executive Analytics Endpoints
@router.get("/executive/top_customers", response_model=List[TopCustomerResponse])
async def get_executive_top_customers(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    sales_executive_id: Optional[int] = Query(None, description="Sales executive ID (only for area_manager, client_admin and superadmin users, for sales_executive it takes its own id)"),
    area_manager_id: Optional[int] = Query(None, description="Area manager ID (only for client_admin and superadmin users to filter by area manager)"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[TopCustomerResponse]:
    """
    Get top customers for a sales executive or aggregated view.
    
    **Business Logic:**
    - Returns shops with highest payment amounts (current + upcoming + overdue)
    - For sales_executive role: automatically uses their own ID
    - For area_manager: can specify sales_executive_id or get territory aggregated data
    - For client_admin, superadmin: can specify sales_executive_id, area_manager_id, or get tenant aggregated data
    
    **Security:**
    - Requires authentication
    - Tenant isolation enforced
    - Sales executives can only see their own data
    - Area managers can only see data for their territory
    - Client admins can see all data for their tenant
    """
    try:
        logger.info(f"=== ANALYTICS ENDPOINT CALLED ===")
        logger.info(f"tenant_id: {tenant_id}")
        logger.info(f"sales_executive_id: {sales_executive_id}")
        logger.info(f"current_user: {current_user}")
        
        # Verify tenant access
        if current_user["tenant_id"] != tenant_id and current_user["role"] != "superadmin":
            logger.error(f"Tenant access denied: user_tenant={current_user['tenant_id']}, requested_tenant={tenant_id}")
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to access this tenant's data"
            )
        
        logger.info("Tenant access verified, creating analytics service")
        analytics_service = AnalyticsService()
        logger.info(f"Created analytics service, calling get_executive_top_customers")
        top_customers = await analytics_service.get_executive_top_customers(
            tenant_id=tenant_id,
            sales_executive_id=sales_executive_id,
            area_manager_id=area_manager_id,
            current_user=current_user
        )
        logger.info(f"Analytics service returned: {top_customers}")
        
        logger.info(f"Converting to TopCustomerResponse objects")
        response_objects = [TopCustomerResponse(**customer) for customer in top_customers]
        logger.info(f"Response objects created: {response_objects}")
        
        return response_objects
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executive_top_customers: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executive top customers: {str(e)}"
        )


@router.get("/executive/best_selling_products", response_model=List[BestSellingProductResponse])
async def get_executive_best_selling_products(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    sales_executive_id: Optional[int] = Query(None, description="Sales executive ID (only for area_manager, client_admin and superadmin users, for sales_executive it takes its own id)"),
    area_manager_id: Optional[int] = Query(None, description="Area manager ID (only for client_admin and superadmin users to filter by area manager)"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[BestSellingProductResponse]:
    """
    Get best selling products for a sales executive or aggregated view.
    
    **Business Logic:**
    - Returns products with highest units sold by the executive
    - Calculates percentage of total products sold across all executives
    - For sales_executive role: automatically uses their own ID
    - For area_manager: can specify sales_executive_id or get territory aggregated data
    - For client_admin, superadmin: can specify sales_executive_id, area_manager_id, or get tenant aggregated data
    
    **Security:**
    - Requires authentication
    - Tenant isolation enforced
    - Sales executives can only see their own data
    - Area managers can only see data for their territory
    - Client admins can see all data for their tenant
    """
    try:
        # Verify tenant access
        if current_user["tenant_id"] != tenant_id and current_user["role"] != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to access this tenant's data"
            )
        
        analytics_service = AnalyticsService()
        best_selling_products = await analytics_service.get_executive_best_selling_products(
            tenant_id=tenant_id,
            sales_executive_id=sales_executive_id,
            area_manager_id=area_manager_id,
            current_user=current_user
        )
        
        return [BestSellingProductResponse(**product) for product in best_selling_products]
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executive_best_selling_products: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executive best selling products: {str(e)}"
        )


@router.get("/executive/sales_report", response_model=List[SalesReportResponse])
async def get_executive_sales_report(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    sales_executive_id: Optional[int] = Query(None, description="Sales executive ID (only for area_manager, client_admin and superadmin users, for sales_executive it takes its own id)"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[SalesReportResponse]:
    """
    Get sales report for a sales executive for the last year.
    
    **Business Logic:**
    - Returns monthly sales data for the last 12 months
    - Shows sale points (order amounts) per month in YYYY-MM format
    - For sales_executive role: automatically uses their own ID
    - For area_manager, client_admin, superadmin: can specify sales_executive_id
    
    **Security:**
    - Requires authentication
    - Tenant isolation enforced
    - Sales executives can only see their own data unless they have higher privileges
    """
    try:
        # Verify tenant access
        if current_user["tenant_id"] != tenant_id and current_user["role"] != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to access this tenant's data"
            )
        
        analytics_service = AnalyticsService()
        sales_report = await analytics_service.get_executive_sales_report(
            tenant_id=tenant_id,
            sales_executive_id=sales_executive_id,
            current_user=current_user
        )
        
        return [SalesReportResponse(**report) for report in sales_report]
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executive_sales_report: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executive sales report: {str(e)}"
        )


# Shop Analytics Endpoints
@router.get("/shops/purchase_analysis", response_model=List[PurchaseAnalysisResponse])
async def get_shop_purchase_analysis(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    shop_id: str = Query(..., description="Shop ID"),
    year: Optional[int] = Query(None, description="Year (Optional, if not given should provide the result of last one year)"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[PurchaseAnalysisResponse]:
    """
    Get purchase analysis for a shop.
    
    **Business Logic:**
    - Returns monthly purchase data for the specified year
    - Shows whether purchases were made in each month (YYYY-MM format)
    - Defaults to last year if year not specified
    - Creates complete year data (12 months) with purchase status
    
    **Security:**
    - Requires authentication
    - Tenant isolation enforced
    - Users can only access shops from their tenant
    """
    try:
        # Verify tenant access
        if current_user["tenant_id"] != tenant_id and current_user["role"] != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to access this tenant's data"
            )
        
        analytics_service = AnalyticsService()
        purchase_analysis = await analytics_service.get_shop_purchase_analysis(
            tenant_id=tenant_id,
            shop_id=shop_id,
            year=year
        )
        
        return [PurchaseAnalysisResponse(**analysis) for analysis in purchase_analysis]
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_purchase_analysis: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop purchase analysis: {str(e)}"
        )


@router.get("/shops/best_selling_products", response_model=List[ShopBestSellingProductResponse])
async def get_shop_best_selling_products(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    shop_id: str = Query(..., description="Shop ID"),
    year: Optional[int] = Query(None, description="Year (Optional, if not given should provide the result of last one year)"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[ShopBestSellingProductResponse]:
    """
    Get best selling products for a shop.
    
    **Business Logic:**
    - Returns products with highest units sold by this shop
    - Calculates percentage of total products sold across all shops
    - Defaults to last year if year not specified
    - For sales_executive role: automatically uses their own ID
    - For area_manager, client_admin, superadmin: can specify sales_executive_id
    
    **Security:**
    - Requires authentication
    - Tenant isolation enforced
    - Users can only access shops from their tenant
    """
    try:
        # Verify tenant access
        if current_user["tenant_id"] != tenant_id and current_user["role"] != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to access this tenant's data"
            )
        
        analytics_service = AnalyticsService()
        best_selling_products = await analytics_service.get_shop_best_selling_products(
            tenant_id=tenant_id,
            shop_id=shop_id,
            year=year
        )
        
        return [ShopBestSellingProductResponse(**product) for product in best_selling_products]
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_best_selling_products: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop best selling products: {str(e)}"
        )


@router.get("/shops/sales_report", response_model=List[ShopSalesReportResponse])
async def get_shop_sales_report(
    tenant_id: str = Query(..., description="Tenant identifier (required)"),
    shop_id: str = Query(..., description="Shop ID"),
    year: Optional[int] = Query(None, description="Year (Optional, if not given should provide the result of last one year)"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> List[ShopSalesReportResponse]:
    """
    Get sales report for a shop for the specified year.
    
    **Business Logic:**
    - Returns monthly sales data for the specified year
    - Shows sale points (order amounts) per month in YYYY-MM format
    - Defaults to last year if year not specified
    - Creates complete year data (12 months) with sales amounts
    
    **Security:**
    - Requires authentication
    - Tenant isolation enforced
    - Users can only access shops from their tenant
    """
    try:
        # Verify tenant access
        if current_user["tenant_id"] != tenant_id and current_user["role"] != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to access this tenant's data"
            )
        
        analytics_service = AnalyticsService()
        sales_report = await analytics_service.get_shop_sales_report(
            tenant_id=tenant_id,
            shop_id=shop_id,
            year=year
        )
        
        return [ShopSalesReportResponse(**report) for report in sales_report]
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_sales_report: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop sales report: {str(e)}"
        )


# Legacy Analytics Endpoints (keeping existing functionality)
@router.get("/executive/{user_id}/performance")
async def get_executive_performance(
    user_id: int = Path(..., description="User ID"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get executive performance analytics.
    
    This endpoint provides comprehensive performance metrics for sales executives
    including sales data, payment metrics, and performance indicators based on
    the 30-day payment policy.
    
    Args:
        user_id: User ID to get performance for
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing executive performance metrics
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view performance for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view performance for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get executive performance
        performance = await analytics_service.get_executive_performance(
            user_id, tenant_id, period_start, period_end
        )
        
        if "error" in performance:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=performance["error"]
            )
        
        return performance
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executive_performance: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executive performance: {str(e)}"
        )


@router.get("/shop/{shop_id}/analytics")
async def get_shop_analytics(
    shop_id: int = Path(..., description="Shop ID"),
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get shop-specific analytics.
    
    This endpoint provides detailed analytics for individual shops including
    order patterns, payment behavior, and performance metrics based on the
    30-day payment policy.
    
    Args:
        shop_id: Shop ID to get analytics for
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing shop analytics
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view shop analytics for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view shop analytics for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get shop analytics
        analytics = await analytics_service.get_shop_analytics(
            shop_id, tenant_id, period_start, period_end
        )
        
        if "error" in analytics:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=analytics["error"]
            )
        
        return analytics
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shop_analytics: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shop analytics: {str(e)}"
        )


@router.get("/payments/analytics")
async def get_payment_analytics(
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get payment analytics for a tenant.
    
    This endpoint provides comprehensive payment analytics including current,
    upcoming, and overdue payments based on the 30-day payment policy.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing payment analytics
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view payment analytics for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view payment analytics for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get payment analytics
        analytics = await analytics_service.get_payment_analytics(
            tenant_id, period_start, period_end
        )
        
        if "error" in analytics:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=analytics["error"]
            )
        
        return analytics
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_payment_analytics: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get payment analytics: {str(e)}"
        )


@router.get("/payments/overdue")
async def get_overdue_analysis(
    tenant_id: str = Query(..., description="Tenant identifier"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get overdue payments analysis.
    
    This endpoint provides detailed analysis of overdue payments including
    shop-level breakdown and payment trends based on the 30-day payment policy.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing overdue analysis
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view overdue analysis for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view overdue analysis for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get overdue analysis
        analysis = await analytics_service.get_overdue_analysis(tenant_id)
        
        if "error" in analysis:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=analysis["error"]
            )
        
        return analysis
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_overdue_analysis: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get overdue analysis: {str(e)}"
        )


@router.get("/products/best-selling")
async def get_best_selling_products(
    tenant_id: str = Query(..., description="Tenant identifier"),
    limit: int = Query(10, description="Maximum number of products to return", ge=1, le=50),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get best selling products analysis.
    
    This endpoint provides analysis of best selling products based on
    total sales amount and order frequency.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        limit: Maximum number of products to return (1-50)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing best selling products analysis
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view product analytics for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view product analytics for this tenant"
            )
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get best selling products
        products = await analytics_service.get_best_selling_products(tenant_id, limit)
        
        if "error" in products:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=products["error"]
            )
        
        return products
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_best_selling_products: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get best selling products: {str(e)}"
        )


@router.get("/executives/summary")
async def get_executives_summary(
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get summary of all executives' performance.
    
    This endpoint provides a summary view of all sales executives'
    performance metrics for the specified period.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing executives summary
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view executives summary for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view executives summary for this tenant"
            )
        
        # Set default period if not provided
        if not period_end:
            period_end = date.today()
        if not period_start:
            period_start = period_end - timedelta(days=30)
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get all sales executives for the tenant
        from ...domain.models.user import User
        executives = db.query(User).filter(
            and_(
                User.tenant_id == tenant_id,
                User.role.in_(["sales_executive", "area_manager"])
            )
        ).all()
        
        executives_summary = []
        for executive in executives:
            performance = await analytics_service.get_executive_performance(
                executive.id, tenant_id, period_start, period_end
            )
            
            if "error" not in performance:
                executives_summary.append({
                    "user_id": executive.id,
                    "user_name": executive.name,
                    "role": executive.role.value,
                    "performance_level": performance.get("performance_level", "unknown"),
                    "payment_collection_rate": performance.get("performance_metrics", {}).get("payment_collection_rate", 0.0),
                    "total_orders": performance.get("performance_metrics", {}).get("total_orders", 0),
                    "total_order_value": performance.get("performance_metrics", {}).get("total_order_value", 0.0),
                    "overdue_payments": performance.get("performance_metrics", {}).get("overdue_payments", 0.0)
                })
        
        # Sort by performance level and payment collection rate
        executives_summary.sort(
            key=lambda x: (
                ["excellent", "good", "average", "poor", "critical"].index(x["performance_level"]),
                -x["payment_collection_rate"]
            )
        )
        
        return {
            "tenant_id": tenant_id,
            "period_start": period_start.isoformat(),
            "period_end": period_end.isoformat(),
            "total_executives": len(executives_summary),
            "executives": executives_summary,
            "summary_date": datetime.utcnow().isoformat()
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_executives_summary: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get executives summary: {str(e)}"
        )


@router.get("/shops/summary")
async def get_shops_summary(
    tenant_id: str = Query(..., description="Tenant identifier"),
    period_start: Optional[date] = Query(None, description="Start date for analytics period"),
    period_end: Optional[date] = Query(None, description="End date for analytics period"),
    current_user: Dict[str, Any] = Depends(get_current_user)
) -> Dict[str, Any]:
    """
    Get summary of all shops' analytics.
    
    This endpoint provides a summary view of all shops'
    analytics metrics for the specified period.
    
    Args:
        tenant_id: Tenant identifier (from URL parameter)
        period_start: Start date for analytics period (optional, defaults to 30 days ago)
        period_end: End date for analytics period (optional, defaults to today)
        current_user: Current authenticated user
        db: Database session
        
    Returns:
        Dict containing shops summary
        
    Raises:
        HTTPException: If user lacks permission or error occurs
    """
    try:
        # Verify user has permission to view shops summary for this tenant
        if current_user.tenant_id != tenant_id and current_user.role != "superadmin":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions to view shops summary for this tenant"
            )
        
        # Set default period if not provided
        if not period_end:
            period_end = date.today()
        if not period_start:
            period_start = period_end - timedelta(days=30)
        
        # Initialize analytics service
        analytics_service = AnalyticsService()
        
        # Get all shops for the tenant
        from ...domain.models.shop import Shop
        shops = db.query(Shop).filter(Shop.tenant_id == tenant_id).all()
        
        shops_summary = []
        for shop in shops:
            analytics = await analytics_service.get_shop_analytics(
                shop.id, tenant_id, period_start, period_end
            )
            
            if "error" not in analytics:
                shops_summary.append({
                    "shop_id": shop.id,
                    "shop_name": shop.name,
                    "shop_code": shop.shop_id,
                    "performance_level": analytics.get("performance_level", "unknown"),
                    "payment_collection_rate": analytics.get("analytics_metrics", {}).get("payment_collection_rate", 0.0),
                    "total_orders": analytics.get("analytics_metrics", {}).get("total_orders", 0),
                    "total_order_value": analytics.get("analytics_metrics", {}).get("total_order_value", 0.0),
                    "overdue_payment": analytics.get("analytics_metrics", {}).get("overdue_payment", 0.0),
                    "product_diversity": analytics.get("analytics_metrics", {}).get("product_diversity", 0)
                })
        
        # Sort by performance level and payment collection rate
        shops_summary.sort(
            key=lambda x: (
                ["excellent", "good", "average", "poor", "critical"].index(x["performance_level"]),
                -x["payment_collection_rate"]
            )
        )
        
        return {
            "tenant_id": tenant_id,
            "period_start": period_start.isoformat(),
            "period_end": period_end.isoformat(),
            "total_shops": len(shops_summary),
            "shops": shops_summary,
            "summary_date": datetime.utcnow().isoformat()
        }
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error in get_shops_summary: {str(e)}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to get shops summary: {str(e)}"
        )
