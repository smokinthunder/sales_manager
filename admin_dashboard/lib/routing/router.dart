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
import 'package:admin_dashboard/ui/forgot_password_screen.dart';
import 'package:admin_dashboard/ui/reset_password_screen.dart';
import 'package:admin_dashboard/ui/change_password_screen.dart';
import 'package:admin_dashboard/ui/notifications.dart';
import 'package:admin_dashboard/ui/orders/orders.dart';
import 'package:admin_dashboard/ui/orders/view_order_datails.dart';
import 'package:admin_dashboard/ui/outstanding/invoice.dart';
import 'package:admin_dashboard/ui/outstanding/more_details.dart';
import 'package:admin_dashboard/ui/outstanding/outstanding.dart';
import 'package:admin_dashboard/viewmodel/auth_viewmodel.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final router = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);
  
  return GoRouter(
    initialLocation: Routes.login,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.forgotPassword ||
          state.matchedLocation == Routes.resetPassword;

      // If not authenticated and trying to access protected route
      if (!isAuthenticated && !isLoggingIn) {
        return Routes.login;
      }

      // If authenticated and trying to access login
      if (isAuthenticated && isLoggingIn) {
        return Routes.dashboard;
      }

      return null; // No redirect needed
    },
    routes: [
      // Auth Routes (Public)
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(resetToken: token);
        },
      ),
      // Protected Routes
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
          ...orderRoutes,

          GoRoute(
            path: Routes.notifications,
            builder: (context, state) => const Notifications(),
          ),
          GoRoute(
            path: Routes.changePassword,
            builder: (context, state) => const ChangePasswordScreen(),
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

final orderRoutes = [
  GoRoute(
    path: Routes.order,
    builder: (context, state) => const Orders(),
  ),
  GoRoute(
    path: Routes.viewOrderDetails,
    builder: (context, state) => const ViewOrderDatails(),
  ),
];