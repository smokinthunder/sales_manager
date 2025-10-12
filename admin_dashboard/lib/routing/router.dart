import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/analytics/point_system.dart';
import 'package:admin_dashboard/ui/analytics/shop_analytics.dart';
import 'package:admin_dashboard/ui/area_manager/add_area_manager.dart';
import 'package:admin_dashboard/ui/area_manager/area_manager.dart';
import 'package:admin_dashboard/ui/area_manager/find_executive.dart';
import 'package:admin_dashboard/ui/customer/active_customers.dart';
import 'package:admin_dashboard/ui/customer/add_new_customer.dart';
import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:admin_dashboard/ui/customer/customer_details.dart';
import 'package:admin_dashboard/ui/customer/inactive_customers.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_collections.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_daily_sales.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_new_customers.dart';
import 'package:admin_dashboard/ui/dashboard/dashboard.dart';
import 'package:admin_dashboard/ui/executive/assign_special_routes.dart';
import 'package:admin_dashboard/ui/executive/executive.dart';
import 'package:admin_dashboard/ui/executive/find_dealers.dart';
import 'package:admin_dashboard/ui/home_screen_scaffold.dart';
import 'package:admin_dashboard/ui/login_screen.dart';
import 'package:admin_dashboard/ui/notifications.dart';
import 'package:admin_dashboard/ui/outstanding/invoice.dart';
import 'package:admin_dashboard/ui/outstanding/more_details.dart';
import 'package:admin_dashboard/ui/outstanding/outstanding.dart';
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
          ...dashBoardRoutes,
          ...executiveRoutes,
          ...customerRoutes,
          ...analyticsRoutes,
          ...areaManagerRoutes,
          ...outStandingRoutes,

          GoRoute(
            path: Routes.notifications,
            builder: (context, state) => const Notifications(),
          ),
        ],
      ),
    ],
  );
});

final areaManagerRoutes = [
  GoRoute(
    path: Routes.areaManager,
    builder: (context, state) => const AreaManager(),
  ),
  GoRoute(
    path: Routes.findExecutive,
    builder: (context, state) => FindExecutive(),
  ),
  GoRoute(
    path: Routes.addAreaManager,
    builder: (context, state) => AddAreaManager(),
  ),
];

final outStandingRoutes = [
  GoRoute(path: Routes.outstanding, builder: (context, state) => Outstanding()),
  GoRoute(path: Routes.viewInvoice, builder: (context, state) => Invoice()),
  GoRoute(path: Routes.viewDetails, builder: (context, state) => MoreDetails()),
];

final executiveRoutes = [
  GoRoute(
    path: Routes.executive,
    builder: (context, state) => const Executive(),
  ),
  GoRoute(
    path: Routes.findDealers,
    builder: (context, state) => const FindDealers(),
  ),
  GoRoute(
    path: Routes.assignSpecialRoutes,
    builder: (context, state) => const AssignSpecialRoutes(),
  ),
];

final dashBoardRoutes = [
  GoRoute(
    path: Routes.dashboard,
    builder: (context, state) => const Dashboard(),
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
];

final customerRoutes = [
  GoRoute(path: Routes.customer, builder: (context, state) => const Customer()),
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
    path: Routes.customerDetails,
    builder: (context, state) => const CustomerDetails(),
  ),
];

final analyticsRoutes = [
  GoRoute(
    path: Routes.analytics,
    builder: (context, state) => const Analytics(),
  ),
  GoRoute(
    path: Routes.pointSystem,
    builder: (context, state) => const PointSystem(),
  ),
  GoRoute(
    path: Routes.shopAnalytics,
    builder: (context, state) => const ShopAnalytics(),
  ),
];
