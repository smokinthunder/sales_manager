import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/analytics/point_system.dart';
import 'package:admin_dashboard/ui/analytics/shop_analytics.dart';
import 'package:admin_dashboard/ui/area_manager.dart';
import 'package:admin_dashboard/ui/customer/active_customers.dart';
import 'package:admin_dashboard/ui/customer/add_new_customer.dart';
import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:admin_dashboard/ui/customer/customer_details.dart';
import 'package:admin_dashboard/ui/customer/inactive_customers.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_collections.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_daily_sales.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_new_customers.dart';
import 'package:admin_dashboard/ui/dashboard/dashboard.dart';
import 'package:admin_dashboard/ui/executive.dart';
import 'package:admin_dashboard/ui/home_screen_scaffold.dart';
import 'package:admin_dashboard/ui/login_screen.dart';
import 'package:admin_dashboard/ui/notifications.dart';
import 'package:admin_dashboard/ui/outstanding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final router = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.dashboard,
            builder: (context, state) => const Dashboard(),
          ),
          GoRoute(
            path: Routes.customer,
            builder: (context, state) => const Customer(),
          ),
          GoRoute(
            path: Routes.analytics,
            builder: (context, state) => const Analytics(),
          ),
          GoRoute(
            path: Routes.executive,
            builder: (context, state) => const Executive(),
          ),
          GoRoute(
            path: Routes.outstanding,
            builder: (context, state) => Outstanding(),
          ),
          GoRoute(
            path: Routes.areaManager,
            builder: (context, state) => const AreaManager(),
          ),
          GoRoute(
            path: Routes.notifications,
            builder: (context, state) => const Notifications(),
          ),
          GoRoute(
            path: Routes.analyzeNewCustomers,
            builder: (context, state) => const AnalyzeNewCustomers(),
          ),
          GoRoute(
            path: Routes.analyzeCollection,
            builder: (context, state) => const AnalyzeCollections(),
          ),
          GoRoute(
            path: Routes.analyzeSales,
            builder: (context, state) => const AnalyzeDailySales(),
          ),
          GoRoute(
            path: Routes.addNewCusomter,
            builder: (context, state) => const AddNewCustomer(),
          ),
          GoRoute(
            path: Routes.activeCustomers,
            builder: (context, state) => const ActiveCustomers(),
          ),
          GoRoute(
            path: Routes.inactiveCustomers,
            builder: (context, state) => const InactiveCustomers(),
          ),
          GoRoute(
            path: Routes.pointSystem,
            builder: (context, state) => const PointSystem(),
          ),
          GoRoute(
            path: Routes.customerDetails,
            builder: (context, state) => const CustomerDetails(),
          ),
          GoRoute(
            path: Routes.shopAnalytics,
            builder: (context, state) => const ShopAnalytics(),
          ),
        ],
      ),
    ],
  );
});
