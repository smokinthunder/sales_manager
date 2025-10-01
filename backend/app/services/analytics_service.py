"""
Analytics service for performance tracking and reporting.

Handles analytics calculations, performance metrics, and business intelligence
with 30-day payment policy integration.
"""

from datetime import datetime, date, timedelta
from typing import Dict, List, Optional, Tuple, Any
from sqlalchemy.orm import Session
from sqlalchemy import and_, desc, func, case
import logging

from ..core.logging import get_logger
from ..domain.models.analytics import (
    SalesPerformance, ShopAnalytics, PaymentAnalytics,
    PerformanceLevel, PaymentTrend,
    calculate_performance_level, calculate_payment_trend, 
    calculate_payment_collection_rate, calculate_compliance_rate
)
from ..domain.models.sync_data import SyncedShopData, SyncedOrder, SyncedProduct
from ..domain.models.shop import Shop
from ..domain.models.user import User
from ..domain.models.visit import Visit
from ..domain.models.route import Route, RouteAssignment

logger = get_logger(__name__)


class AnalyticsService:
    """Service for analytics and performance tracking."""
    
    def __init__(self, db: Session):
        """Initialize analytics service with database session."""
        self.db = db
    
    async def get_executive_performance(
        self, 
        user_id: int, 
        tenant_id: str,
        period_start: Optional[date] = None,
        period_end: Optional[date] = None
    ) -> Dict[str, Any]:
        """
        Get executive performance analytics.
        
        Args:
            user_id: User ID
            tenant_id: Tenant identifier
            period_start: Start date for analytics period
            period_end: End date for analytics period
            
        Returns:
            Dict containing executive performance metrics
        """
        try:
            # Set default period if not provided
            if not period_end:
                period_end = date.today()
            if not period_start:
                period_start = period_end - timedelta(days=30)
            
            # Get user information
            user = self.db.query(User).filter(
                and_(User.id == user_id, User.tenant_id == tenant_id)
            ).first()
            
            if not user:
                return {"error": "User not found"}
            
            # Get synced data for the period
            synced_data = await self._get_synced_data_for_period(tenant_id, period_start, period_end)
            
            # Calculate performance metrics
            performance_metrics = await self._calculate_executive_metrics(
                user_id, tenant_id, period_start, period_end, synced_data
            )
            
            # Get or create performance record
            performance_record = await self._get_or_create_performance_record(
                user_id, tenant_id, period_start, period_end, performance_metrics
            )
            
            return {
                "user_id": user_id,
                "user_name": user.name,
                "role": user.role.value,
                "period_start": period_start.isoformat(),
                "period_end": period_end.isoformat(),
                "performance_metrics": performance_metrics,
                "performance_level": performance_record.performance_level.value,
                "payment_trend": performance_record.payment_trend.value,
                "created_at": performance_record.created_at.isoformat(),
                "updated_at": performance_record.updated_at.isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error getting executive performance: {str(e)}", exc_info=True)
            return {"error": f"Failed to get executive performance: {str(e)}"}
    
    async def get_shop_analytics(
        self,
        shop_id: int,
        tenant_id: str,
        period_start: Optional[date] = None,
        period_end: Optional[date] = None
    ) -> Dict[str, Any]:
        """
        Get shop-specific analytics.
        
        Args:
            shop_id: Shop ID
            tenant_id: Tenant identifier
            period_start: Start date for analytics period
            period_end: End date for analytics period
            
        Returns:
            Dict containing shop analytics
        """
        try:
            # Set default period if not provided
            if not period_end:
                period_end = date.today()
            if not period_start:
                period_start = period_end - timedelta(days=30)
            
            # Get shop information
            shop = self.db.query(Shop).filter(
                and_(Shop.id == shop_id, Shop.tenant_id == tenant_id)
            ).first()
            
            if not shop:
                return {"error": "Shop not found"}
            
            # Get synced data for the shop
            shop_synced_data = await self._get_shop_synced_data(shop_id, tenant_id, period_start, period_end)
            
            # Calculate shop analytics
            shop_metrics = await self._calculate_shop_metrics(
                shop_id, tenant_id, period_start, period_end, shop_synced_data
            )
            
            # Get or create shop analytics record
            analytics_record = await self._get_or_create_shop_analytics_record(
                shop_id, tenant_id, period_start, period_end, shop_metrics
            )
            
            return {
                "shop_id": shop_id,
                "shop_name": shop.name,
                "shop_code": shop.shop_id,
                "period_start": period_start.isoformat(),
                "period_end": period_end.isoformat(),
                "analytics_metrics": shop_metrics,
                "performance_level": analytics_record.performance_level.value,
                "payment_trend": analytics_record.payment_trend.value,
                "created_at": analytics_record.created_at.isoformat(),
                "updated_at": analytics_record.updated_at.isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error getting shop analytics: {str(e)}", exc_info=True)
            return {"error": f"Failed to get shop analytics: {str(e)}"}
    
    async def get_payment_analytics(
        self,
        tenant_id: str,
        period_start: Optional[date] = None,
        period_end: Optional[date] = None
    ) -> Dict[str, Any]:
        """
        Get payment analytics for a tenant.
        
        Args:
            tenant_id: Tenant identifier
            period_start: Start date for analytics period
            period_end: End date for analytics period
            
        Returns:
            Dict containing payment analytics
        """
        try:
            # Set default period if not provided
            if not period_end:
                period_end = date.today()
            if not period_start:
                period_start = period_end - timedelta(days=30)
            
            # Get synced data for the period
            synced_data = await self._get_synced_data_for_period(tenant_id, period_start, period_end)
            
            # Calculate payment analytics
            payment_metrics = await self._calculate_payment_metrics(
                tenant_id, period_start, period_end, synced_data
            )
            
            # Get or create payment analytics record
            analytics_record = await self._get_or_create_payment_analytics_record(
                tenant_id, period_start, period_end, payment_metrics
            )
            
            return {
                "tenant_id": tenant_id,
                "period_start": period_start.isoformat(),
                "period_end": period_end.isoformat(),
                "payment_metrics": payment_metrics,
                "payment_trend": analytics_record.payment_trend.value,
                "created_at": analytics_record.created_at.isoformat(),
                "updated_at": analytics_record.updated_at.isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error getting payment analytics: {str(e)}", exc_info=True)
            return {"error": f"Failed to get payment analytics: {str(e)}"}
    
    async def get_overdue_analysis(self, tenant_id: str) -> Dict[str, Any]:
        """
        Get overdue payments analysis.
        
        Args:
            tenant_id: Tenant identifier
            
        Returns:
            Dict containing overdue analysis
        """
        try:
            # Get overdue orders
            overdue_orders = self.db.query(SyncedOrder).filter(
                and_(
                    SyncedOrder.tenant_id == tenant_id,
                    SyncedOrder.payment_status == "overdue"
                )
            ).all()
            
            # Group by shop
            overdue_by_shop = {}
            total_overdue = 0.0
            
            for order in overdue_orders:
                shop_data = self.db.query(SyncedShopData).filter(
                    SyncedShopData.id == order.shop_data_id
                ).first()
                
                if shop_data:
                    shop_id = shop_data.shop_id
                    if shop_id not in overdue_by_shop:
                        overdue_by_shop[shop_id] = {
                            "shop_name": shop_data.shop_name,
                            "orders": [],
                            "total_amount": 0.0,
                            "max_days_overdue": 0
                        }
                    
                    overdue_by_shop[shop_id]["orders"].append({
                        "order_id": order.order_id,
                        "order_date": order.order_date.isoformat(),
                        "order_amount": order.order_amount,
                        "due_date": order.due_date.isoformat(),
                        "days_overdue": order.days_overdue
                    })
                    
                    overdue_by_shop[shop_id]["total_amount"] += order.order_amount
                    overdue_by_shop[shop_id]["max_days_overdue"] = max(
                        overdue_by_shop[shop_id]["max_days_overdue"],
                        order.days_overdue
                    )
                    
                    total_overdue += order.order_amount
            
            # Sort shops by total overdue amount
            sorted_shops = sorted(
                overdue_by_shop.items(),
                key=lambda x: x[1]["total_amount"],
                reverse=True
            )
            
            return {
                "tenant_id": tenant_id,
                "total_overdue_amount": total_overdue,
                "total_overdue_orders": len(overdue_orders),
                "shops_with_overdue": len(overdue_by_shop),
                "overdue_by_shop": dict(sorted_shops),
                "analysis_date": datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error getting overdue analysis: {str(e)}", exc_info=True)
            return {"error": f"Failed to get overdue analysis: {str(e)}"}
    
    async def get_best_selling_products(self, tenant_id: str, limit: int = 10) -> Dict[str, Any]:
        """
        Get best selling products analysis.
        
        Args:
            tenant_id: Tenant identifier
            limit: Maximum number of products to return
            
        Returns:
            Dict containing best selling products
        """
        try:
            # Get product sales data
            product_sales = self.db.query(
                SyncedProduct.product_name,
                func.sum(SyncedProduct.product_amount).label('total_amount'),
                func.count(SyncedProduct.id).label('total_orders'),
                func.avg(SyncedProduct.product_amount).label('average_amount')
            ).filter(
                SyncedProduct.tenant_id == tenant_id
            ).group_by(
                SyncedProduct.product_name
            ).order_by(
                func.sum(SyncedProduct.product_amount).desc()
            ).limit(limit).all()
            
            products = []
            for product in product_sales:
                products.append({
                    "product_name": product.product_name,
                    "total_amount": float(product.total_amount),
                    "total_orders": product.total_orders,
                    "average_amount": float(product.average_amount)
                })
            
            return {
                "tenant_id": tenant_id,
                "products": products,
                "analysis_date": datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error getting best selling products: {str(e)}", exc_info=True)
            return {"error": f"Failed to get best selling products: {str(e)}"}
    
    async def _get_synced_data_for_period(
        self, 
        tenant_id: str, 
        period_start: date, 
        period_end: date
    ) -> Dict[str, Any]:
        """Get synced data for a specific period."""
        # Get synced shop data
        shop_data = self.db.query(SyncedShopData).filter(
            and_(
                SyncedShopData.tenant_id == tenant_id,
                SyncedShopData.sync_date >= period_start,
                SyncedShopData.sync_date <= period_end
            )
        ).all()
        
        # Get synced orders
        orders = self.db.query(SyncedOrder).filter(
            and_(
                SyncedOrder.tenant_id == tenant_id,
                SyncedOrder.order_date >= period_start,
                SyncedOrder.order_date <= period_end
            )
        ).all()
        
        # Get synced products
        products = self.db.query(SyncedProduct).filter(
            and_(
                SyncedProduct.tenant_id == tenant_id,
                SyncedProduct.sync_date >= period_start,
                SyncedProduct.sync_date <= period_end
            )
        ).all()
        
        return {
            "shop_data": shop_data,
            "orders": orders,
            "products": products
        }
    
    async def _get_shop_synced_data(
        self, 
        shop_id: int, 
        tenant_id: str, 
        period_start: date, 
        period_end: date
    ) -> Dict[str, Any]:
        """Get synced data for a specific shop."""
        # Get synced shop data
        shop_data = self.db.query(SyncedShopData).filter(
            and_(
                SyncedShopData.tenant_id == tenant_id,
                SyncedShopData.sync_date >= period_start,
                SyncedShopData.sync_date <= period_end
            )
        ).first()
        
        if not shop_data:
            return {"shop_data": None, "orders": [], "products": []}
        
        # Get orders for this shop
        orders = self.db.query(SyncedOrder).filter(
            and_(
                SyncedOrder.shop_data_id == shop_data.id,
                SyncedOrder.order_date >= period_start,
                SyncedOrder.order_date <= period_end
            )
        ).all()
        
        # Get products for this shop
        products = self.db.query(SyncedProduct).filter(
            and_(
                SyncedProduct.shop_data_id == shop_data.id,
                SyncedProduct.sync_date >= period_start,
                SyncedProduct.sync_date <= period_end
            )
        ).all()
        
        return {
            "shop_data": shop_data,
            "orders": orders,
            "products": products
        }
    
    async def _calculate_executive_metrics(
        self,
        user_id: int,
        tenant_id: str,
        period_start: date,
        period_end: date,
        synced_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Calculate executive performance metrics."""
        orders = synced_data["orders"]
        shop_data = synced_data["shop_data"]
        
        # Basic metrics
        total_orders = len(orders)
        total_order_value = sum(order.order_amount for order in orders)
        average_order_value = total_order_value / total_orders if total_orders > 0 else 0.0
        
        # Payment metrics
        current_payments = sum(shop.current_payment for shop in shop_data)
        upcoming_payments = sum(shop.upcoming_payment for shop in shop_data)
        overdue_payments = sum(shop.overdue_payment for shop in shop_data)
        
        payment_collection_rate = calculate_payment_collection_rate(
            current_payments + upcoming_payments, total_order_value
        )
        
        # Shop metrics
        shops_managed = len(set(order.shop_data_id for order in orders))
        active_shops = len([shop for shop in shop_data if shop.current_payment > 0 or shop.upcoming_payment > 0])
        
        # Visit metrics (placeholder - would need visit data)
        total_visits = 0  # Would be calculated from visit data
        completed_visits = 0  # Would be calculated from visit data
        visit_completion_rate = 0.0
        
        # Calculate performance level
        overdue_rate = (overdue_payments / total_order_value * 100) if total_order_value > 0 else 0.0
        performance_level = calculate_performance_level(
            payment_collection_rate, visit_completion_rate, overdue_rate
        )
        
        # Calculate payment trend (simplified)
        payment_trend = PaymentTrend.STABLE  # Would need historical data for proper calculation
        
        return {
            "total_orders": total_orders,
            "total_order_value": total_order_value,
            "average_order_value": average_order_value,
            "current_payments": current_payments,
            "upcoming_payments": upcoming_payments,
            "overdue_payments": overdue_payments,
            "payment_collection_rate": payment_collection_rate,
            "shops_managed": shops_managed,
            "active_shops": active_shops,
            "total_visits": total_visits,
            "completed_visits": completed_visits,
            "visit_completion_rate": visit_completion_rate,
            "performance_level": performance_level,
            "payment_trend": payment_trend
        }
    
    async def _calculate_shop_metrics(
        self,
        shop_id: int,
        tenant_id: str,
        period_start: date,
        period_end: date,
        synced_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Calculate shop analytics metrics."""
        shop_data = synced_data["shop_data"]
        orders = synced_data["orders"]
        products = synced_data["products"]
        
        if not shop_data:
            return {}
        
        # Order metrics
        total_orders = len(orders)
        total_order_value = sum(order.order_amount for order in orders)
        average_order_value = total_order_value / total_orders if total_orders > 0 else 0.0
        
        # Calculate order frequency (orders per week)
        period_days = (period_end - period_start).days
        order_frequency = (total_orders / period_days * 7) if period_days > 0 else 0.0
        
        # Payment metrics
        current_payment = shop_data.current_payment
        upcoming_payment = shop_data.upcoming_payment
        overdue_payment = shop_data.overdue_payment
        
        payment_collection_rate = calculate_payment_collection_rate(
            current_payment + upcoming_payment, total_order_value
        )
        
        # Calculate average payment delay
        overdue_orders = [order for order in orders if order.payment_status == "overdue"]
        average_payment_delay = sum(order.days_overdue for order in overdue_orders) / len(overdue_orders) if overdue_orders else 0
        
        # Visit metrics (placeholder)
        total_visits = 0
        completed_visits = 0
        visit_frequency = 0.0
        
        # Product metrics
        product_diversity = len(set(product.product_name for product in products))
        
        # Calculate performance level
        overdue_rate = (overdue_payment / total_order_value * 100) if total_order_value > 0 else 0.0
        performance_level = calculate_performance_level(
            payment_collection_rate, 0.0, overdue_rate  # Visit completion rate not available
        )
        
        # Calculate payment trend
        payment_trend = PaymentTrend.STABLE  # Would need historical data
        
        return {
            "total_orders": total_orders,
            "total_order_value": total_order_value,
            "average_order_value": average_order_value,
            "order_frequency": order_frequency,
            "current_payment": current_payment,
            "upcoming_payment": upcoming_payment,
            "overdue_payment": overdue_payment,
            "payment_collection_rate": payment_collection_rate,
            "average_payment_delay": int(average_payment_delay),
            "total_visits": total_visits,
            "completed_visits": completed_visits,
            "visit_frequency": visit_frequency,
            "product_diversity": product_diversity,
            "performance_level": performance_level,
            "payment_trend": payment_trend
        }
    
    async def _calculate_payment_metrics(
        self,
        tenant_id: str,
        period_start: date,
        period_end: date,
        synced_data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Calculate payment analytics metrics."""
        shop_data = synced_data["shop_data"]
        orders = synced_data["orders"]
        
        # Payment summary
        total_current_payments = sum(shop.current_payment for shop in shop_data)
        total_upcoming_payments = sum(shop.upcoming_payment for shop in shop_data)
        total_overdue_payments = sum(shop.overdue_payment for shop in shop_data)
        total_payments = total_current_payments + total_upcoming_payments + total_overdue_payments
        
        # Payment metrics
        average_payment_amount = total_payments / len(shop_data) if shop_data else 0.0
        payment_collection_rate = calculate_payment_collection_rate(
            total_current_payments + total_upcoming_payments, total_payments
        )
        overdue_rate = (total_overdue_payments / total_payments * 100) if total_payments > 0 else 0.0
        
        # 30-day policy compliance
        orders_within_30_days = len([order for order in orders if order.payment_status in ["current", "upcoming"]])
        orders_overdue = len([order for order in orders if order.payment_status == "overdue"])
        compliance_rate = calculate_compliance_rate(orders_within_30_days, len(orders))
        
        # Shop metrics
        total_shops = len(shop_data)
        shops_with_overdue = len([shop for shop in shop_data if shop.overdue_payment > 0])
        shops_with_upcoming = len([shop for shop in shop_data if shop.upcoming_payment > 0])
        
        # Payment trend
        payment_trend = PaymentTrend.STABLE  # Would need historical data
        
        return {
            "total_current_payments": total_current_payments,
            "total_upcoming_payments": total_upcoming_payments,
            "total_overdue_payments": total_overdue_payments,
            "total_payments": total_payments,
            "average_payment_amount": average_payment_amount,
            "payment_collection_rate": payment_collection_rate,
            "overdue_rate": overdue_rate,
            "orders_within_30_days": orders_within_30_days,
            "orders_overdue": orders_overdue,
            "compliance_rate": compliance_rate,
            "total_shops": total_shops,
            "shops_with_overdue": shops_with_overdue,
            "shops_with_upcoming": shops_with_upcoming,
            "payment_trend": payment_trend
        }
    
    async def _get_or_create_performance_record(
        self,
        user_id: int,
        tenant_id: str,
        period_start: date,
        period_end: date,
        metrics: Dict[str, Any]
    ) -> SalesPerformance:
        """Get or create sales performance record."""
        # Check if record exists
        existing_record = self.db.query(SalesPerformance).filter(
            and_(
                SalesPerformance.user_id == user_id,
                SalesPerformance.tenant_id == tenant_id,
                SalesPerformance.period_start == period_start,
                SalesPerformance.period_end == period_end
            )
        ).first()
        
        if existing_record:
            # Update existing record
            for key, value in metrics.items():
                if hasattr(existing_record, key):
                    setattr(existing_record, key, value)
            existing_record.updated_at = datetime.utcnow()
            self.db.commit()
            return existing_record
        else:
            # Create new record
            new_record = SalesPerformance(
                user_id=user_id,
                tenant_id=tenant_id,
                period_start=period_start,
                period_end=period_end,
                **metrics
            )
            self.db.add(new_record)
            self.db.commit()
            self.db.refresh(new_record)
            return new_record
    
    async def _get_or_create_shop_analytics_record(
        self,
        shop_id: int,
        tenant_id: str,
        period_start: date,
        period_end: date,
        metrics: Dict[str, Any]
    ) -> ShopAnalytics:
        """Get or create shop analytics record."""
        # Check if record exists
        existing_record = self.db.query(ShopAnalytics).filter(
            and_(
                ShopAnalytics.shop_id == shop_id,
                ShopAnalytics.tenant_id == tenant_id,
                ShopAnalytics.period_start == period_start,
                ShopAnalytics.period_end == period_end
            )
        ).first()
        
        if existing_record:
            # Update existing record
            for key, value in metrics.items():
                if hasattr(existing_record, key):
                    setattr(existing_record, key, value)
            existing_record.updated_at = datetime.utcnow()
            self.db.commit()
            return existing_record
        else:
            # Create new record
            new_record = ShopAnalytics(
                shop_id=shop_id,
                tenant_id=tenant_id,
                period_start=period_start,
                period_end=period_end,
                **metrics
            )
            self.db.add(new_record)
            self.db.commit()
            self.db.refresh(new_record)
            return new_record
    
    async def _get_or_create_payment_analytics_record(
        self,
        tenant_id: str,
        period_start: date,
        period_end: date,
        metrics: Dict[str, Any]
    ) -> PaymentAnalytics:
        """Get or create payment analytics record."""
        # Check if record exists
        existing_record = self.db.query(PaymentAnalytics).filter(
            and_(
                PaymentAnalytics.tenant_id == tenant_id,
                PaymentAnalytics.period_start == period_start,
                PaymentAnalytics.period_end == period_end
            )
        ).first()
        
        if existing_record:
            # Update existing record
            for key, value in metrics.items():
                if hasattr(existing_record, key):
                    setattr(existing_record, key, value)
            existing_record.updated_at = datetime.utcnow()
            self.db.commit()
            return existing_record
        else:
            # Create new record
            new_record = PaymentAnalytics(
                tenant_id=tenant_id,
                period_start=period_start,
                period_end=period_end,
                **metrics
            )
            self.db.add(new_record)
            self.db.commit()
            self.db.refresh(new_record)
            return new_record
    
    async def get_executive_top_customers(
        self,
        tenant_id: str,
        sales_executive_id: Optional[int] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get top customers for a sales executive.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID (optional, defaults to current user)
            current_user: Current authenticated user
            
        Returns:
            List of top customers with shop names and points
        """
        try:
            # Determine the sales executive ID
            if sales_executive_id is None:
                if current_user and current_user.get("role") == "sales_executive":
                    sales_executive_id = current_user["id"]
                else:
                    return []
            
            # Get shops managed by this executive
            shops_query = self.db.query(Shop).filter(
                and_(
                    Shop.tenant_id == tenant_id,
                    Shop.status == "active"
                )
            )
            
            # If not superadmin/client_admin/area_manager, filter by executive's shops
            if current_user and current_user.get("role") == "sales_executive":
                # Get shops assigned to this executive through routes
                route_assignments = self.db.query(RouteAssignment).join(Route).filter(
                    and_(
                        RouteAssignment.sales_executive_id == sales_executive_id,
                        Route.tenant_id == tenant_id
                    )
                ).all()
                
                shop_ids = [assignment.shop_id for assignment in route_assignments]
                if shop_ids:
                    shops_query = shops_query.filter(Shop.shop_id.in_(shop_ids))
                else:
                    return []
            
            shops = shops_query.all()
            
            # Get synced shop data for these shops
            shop_data = self.db.query(SyncedShopData).filter(
                and_(
                    SyncedShopData.tenant_id == tenant_id,
                    SyncedShopData.shop_id.in_([shop.shop_id for shop in shops])
                )
            ).all()
            
            # Calculate points based on total payment amounts
            top_customers = []
            for data in shop_data:
                total_points = data.current_payment + data.upcoming_payment + data.overdue_payment
                if total_points > 0:
                    shop = next((s for s in shops if s.shop_id == data.shop_id), None)
                    if shop:
                        top_customers.append({
                            "shop_name": shop.name,
                            "points": float(total_points)
                        })
            
            # Sort by points descending
            top_customers.sort(key=lambda x: x["points"], reverse=True)
            
            return top_customers
            
        except Exception as e:
            logger.error(f"Error getting executive top customers: {str(e)}", exc_info=True)
            return []
    
    async def get_executive_best_selling_products(
        self,
        tenant_id: str,
        sales_executive_id: Optional[int] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get best selling products for a sales executive.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID (optional, defaults to current user)
            current_user: Current authenticated user
            
        Returns:
            List of best selling products with units sold and percentages
        """
        try:
            # Determine the sales executive ID
            if sales_executive_id is None:
                if current_user and current_user.get("role") == "sales_executive":
                    sales_executive_id = current_user["id"]
                else:
                    return []
            
            # Get shops managed by this executive
            shops_query = self.db.query(Shop).filter(
                and_(
                    Shop.tenant_id == tenant_id,
                    Shop.status == "active"
                )
            )
            
            # If not superadmin/client_admin/area_manager, filter by executive's shops
            if current_user and current_user.get("role") == "sales_executive":
                route_assignments = self.db.query(RouteAssignment).join(Route).filter(
                    and_(
                        RouteAssignment.sales_executive_id == sales_executive_id,
                        Route.tenant_id == tenant_id
                    )
                ).all()
                
                shop_ids = [assignment.shop_id for assignment in route_assignments]
                if shop_ids:
                    shops_query = shops_query.filter(Shop.shop_id.in_(shop_ids))
                else:
                    return []
            
            shops = shops_query.all()
            shop_ids = [shop.shop_id for shop in shops]
            
            if not shop_ids:
                return []
            
            # Get synced shop data for these shops
            shop_data_ids = self.db.query(SyncedShopData.id).filter(
                and_(
                    SyncedShopData.tenant_id == tenant_id,
                    SyncedShopData.shop_id.in_(shop_ids)
                )
            ).all()
            
            shop_data_ids = [data.id for data in shop_data_ids]
            
            if not shop_data_ids:
                return []
            
            # Get products sold by this executive
            products = self.db.query(
                SyncedProduct.product_name,
                func.count(SyncedProduct.id).label('units_sold'),
                func.sum(SyncedProduct.product_amount).label('total_amount')
            ).filter(
                and_(
                    SyncedProduct.tenant_id == tenant_id,
                    SyncedProduct.shop_data_id.in_(shop_data_ids)
                )
            ).group_by(
                SyncedProduct.product_name
            ).order_by(
                func.count(SyncedProduct.id).desc()
            ).all()
            
            # Get total products sold across all executives for percentage calculation
            total_products_sold = self.db.query(
                func.count(SyncedProduct.id)
            ).filter(
                SyncedProduct.tenant_id == tenant_id
            ).scalar() or 0
            
            best_selling_products = []
            for product in products:
                percentage = (product.units_sold / total_products_sold * 100) if total_products_sold > 0 else 0
                best_selling_products.append({
                    "product_name": product.product_name,
                    "units_sold": product.units_sold,
                    "percentage": round(percentage, 2)
                })
            
            return best_selling_products
            
        except Exception as e:
            logger.error(f"Error getting executive best selling products: {str(e)}", exc_info=True)
            return []
    
    async def get_executive_sales_report(
        self,
        tenant_id: str,
        sales_executive_id: Optional[int] = None,
        current_user: Dict[str, Any] = None
    ) -> List[Dict[str, Any]]:
        """
        Get sales report for a sales executive for the last year.
        
        Args:
            tenant_id: Tenant identifier
            sales_executive_id: Sales executive ID (optional, defaults to current user)
            current_user: Current authenticated user
            
        Returns:
            List of monthly sales reports
        """
        try:
            # Determine the sales executive ID
            if sales_executive_id is None:
                if current_user and current_user.get("role") == "sales_executive":
                    sales_executive_id = current_user["id"]
                else:
                    return []
            
            # Get last year's data
            end_date = date.today()
            start_date = date(end_date.year - 1, end_date.month, end_date.day)
            
            # Get shops managed by this executive
            shops_query = self.db.query(Shop).filter(
                and_(
                    Shop.tenant_id == tenant_id,
                    Shop.status == "active"
                )
            )
            
            # If not superadmin/client_admin/area_manager, filter by executive's shops
            if current_user and current_user.get("role") == "sales_executive":
                route_assignments = self.db.query(RouteAssignment).join(Route).filter(
                    and_(
                        RouteAssignment.sales_executive_id == sales_executive_id,
                        Route.tenant_id == tenant_id
                    )
                ).all()
                
                shop_ids = [assignment.shop_id for assignment in route_assignments]
                if shop_ids:
                    shops_query = shops_query.filter(Shop.shop_id.in_(shop_ids))
                else:
                    return []
            
            shops = shops_query.all()
            shop_ids = [shop.shop_id for shop in shops]
            
            if not shop_ids:
                return []
            
            # Get synced shop data for these shops
            shop_data_ids = self.db.query(SyncedShopData.id).filter(
                and_(
                    SyncedShopData.tenant_id == tenant_id,
                    SyncedShopData.shop_id.in_(shop_ids)
                )
            ).all()
            
            shop_data_ids = [data.id for data in shop_data_ids]
            
            if not shop_data_ids:
                return []
            
            # Get monthly sales data
            monthly_sales = self.db.query(
                func.date_format(SyncedOrder.order_date, '%Y-%m').label('month_year'),
                func.sum(SyncedOrder.order_amount).label('sale_point')
            ).filter(
                and_(
                    SyncedOrder.tenant_id == tenant_id,
                    SyncedOrder.shop_data_id.in_(shop_data_ids),
                    SyncedOrder.order_date >= start_date,
                    SyncedOrder.order_date <= end_date
                )
            ).group_by(
                func.date_format(SyncedOrder.order_date, '%Y-%m')
            ).order_by(
                func.date_format(SyncedOrder.order_date, '%Y-%m')
            ).all()
            
            sales_report = []
            for sale in monthly_sales:
                sales_report.append({
                    "month_year": sale.month_year,
                    "sale_point": float(sale.sale_point or 0)
                })
            
            return sales_report
            
        except Exception as e:
            logger.error(f"Error getting executive sales report: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_purchase_analysis(
        self,
        tenant_id: str,
        shop_id: str,
        year: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Get purchase analysis for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop ID
            year: Year for analysis (optional, defaults to last year)
            
        Returns:
            List of monthly purchase analysis
        """
        try:
            # Set year to last year if not provided
            if year is None:
                year = date.today().year - 1
            
            start_date = date(year, 1, 1)
            end_date = date(year, 12, 31)
            
            # Get synced shop data for this shop
            shop_data = self.db.query(SyncedShopData).filter(
                and_(
                    SyncedShopData.tenant_id == tenant_id,
                    SyncedShopData.shop_id == shop_id
                )
            ).first()
            
            if not shop_data:
                return []
            
            # Get monthly purchase data
            monthly_purchases = self.db.query(
                func.date_format(SyncedOrder.order_date, '%Y-%m').label('month_year'),
                func.count(SyncedOrder.id).label('purchase_count')
            ).filter(
                and_(
                    SyncedOrder.tenant_id == tenant_id,
                    SyncedOrder.shop_data_id == shop_data.id,
                    SyncedOrder.order_date >= start_date,
                    SyncedOrder.order_date <= end_date
                )
            ).group_by(
                func.date_format(SyncedOrder.order_date, '%Y-%m')
            ).order_by(
                func.date_format(SyncedOrder.order_date, '%Y-%m')
            ).all()
            
            # Create a complete year's data
            purchase_analysis = []
            for month in range(1, 13):
                month_year = f"{year}-{month:02d}"
                is_purchased = any(p.month_year == month_year for p in monthly_purchases)
                purchase_analysis.append({
                    "month_year": month_year,
                    "is_purchased": is_purchased
                })
            
            return purchase_analysis
            
        except Exception as e:
            logger.error(f"Error getting shop purchase analysis: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_best_selling_products(
        self,
        tenant_id: str,
        shop_id: str,
        year: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Get best selling products for a shop.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop ID
            year: Year for analysis (optional, defaults to last year)
            
        Returns:
            List of best selling products for the shop
        """
        try:
            # Set year to last year if not provided
            if year is None:
                year = date.today().year - 1
            
            start_date = date(year, 1, 1)
            end_date = date(year, 12, 31)
            
            # Get synced shop data for this shop
            shop_data = self.db.query(SyncedShopData).filter(
                and_(
                    SyncedShopData.tenant_id == tenant_id,
                    SyncedShopData.shop_id == shop_id
                )
            ).first()
            
            if not shop_data:
                return []
            
            # Get products sold by this shop
            products = self.db.query(
                SyncedProduct.product_name,
                func.count(SyncedProduct.id).label('units_sold'),
                func.sum(SyncedProduct.product_amount).label('total_amount')
            ).filter(
                and_(
                    SyncedProduct.tenant_id == tenant_id,
                    SyncedProduct.shop_data_id == shop_data.id,
                    SyncedProduct.sync_date >= start_date,
                    SyncedProduct.sync_date <= end_date
                )
            ).group_by(
                SyncedProduct.product_name
            ).order_by(
                func.count(SyncedProduct.id).desc()
            ).all()
            
            # Get total products sold across all shops for percentage calculation
            total_products_sold = self.db.query(
                func.count(SyncedProduct.id)
            ).filter(
                and_(
                    SyncedProduct.tenant_id == tenant_id,
                    SyncedProduct.sync_date >= start_date,
                    SyncedProduct.sync_date <= end_date
                )
            ).scalar() or 0
            
            best_selling_products = []
            for product in products:
                percentage = (product.units_sold / total_products_sold * 100) if total_products_sold > 0 else 0
                best_selling_products.append({
                    "product_name": product.product_name,
                    "units_sold": product.units_sold,
                    "percentage": round(percentage, 2)
                })
            
            return best_selling_products
            
        except Exception as e:
            logger.error(f"Error getting shop best selling products: {str(e)}", exc_info=True)
            return []
    
    async def get_shop_sales_report(
        self,
        tenant_id: str,
        shop_id: str,
        year: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Get sales report for a shop for the specified year.
        
        Args:
            tenant_id: Tenant identifier
            shop_id: Shop ID
            year: Year for analysis (optional, defaults to last year)
            
        Returns:
            List of monthly sales reports
        """
        try:
            # Set year to last year if not provided
            if year is None:
                year = date.today().year - 1
            
            start_date = date(year, 1, 1)
            end_date = date(year, 12, 31)
            
            # Get synced shop data for this shop
            shop_data = self.db.query(SyncedShopData).filter(
                and_(
                    SyncedShopData.tenant_id == tenant_id,
                    SyncedShopData.shop_id == shop_id
                )
            ).first()
            
            if not shop_data:
                return []
            
            # Get monthly sales data
            monthly_sales = self.db.query(
                func.date_format(SyncedOrder.order_date, '%Y-%m').label('month_year'),
                func.sum(SyncedOrder.order_amount).label('sale_point')
            ).filter(
                and_(
                    SyncedOrder.tenant_id == tenant_id,
                    SyncedOrder.shop_data_id == shop_data.id,
                    SyncedOrder.order_date >= start_date,
                    SyncedOrder.order_date <= end_date
                )
            ).group_by(
                func.date_format(SyncedOrder.order_date, '%Y-%m')
            ).order_by(
                func.date_format(SyncedOrder.order_date, '%Y-%m')
            ).all()
            
            # Create a complete year's data
            sales_report = []
            for month in range(1, 13):
                month_year = f"{year}-{month:02d}"
                sale_point = next((float(s.sale_point or 0) for s in monthly_sales if s.month_year == month_year), 0.0)
                sales_report.append({
                    "month_year": month_year,
                    "sale_point": sale_point
                })
            
            return sales_report
            
        except Exception as e:
            logger.error(f"Error getting shop sales report: {str(e)}", exc_info=True)
            return []
