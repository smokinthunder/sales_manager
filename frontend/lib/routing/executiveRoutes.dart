import 'package:go_router/go_router.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/executive/analytics/consolidated_analytics.dart';
import 'package:sales_manager/ui/executive/analytics/analytics.dart';
import 'package:sales_manager/ui/executive/home/add_new_shop.dart';
import 'package:sales_manager/ui/executive/home/home.dart';
import 'package:sales_manager/ui/executive/home/not_visiting.dart';
import 'package:sales_manager/ui/executive/home/shop_details.dart';
import 'package:sales_manager/ui/executive/home/top_customers.dart';
import 'package:sales_manager/ui/executive/home/wait_for_approval.dart';
import 'package:sales_manager/ui/executive/outstanding/outstanding.dart';
import 'package:sales_manager/ui/executive/profile/profile.dart';

abstract class ExecutiveRoutes {
  static final executiveHome = GoRoute(
    path: AppRoutes.executiveHome,
    builder: (context, state) => ExecutiveHome(),
  );
  static final executiveAnalytics = GoRoute(
    path: AppRoutes.executiveAnalytics,
    builder: (context, state) => ExecutiveAnalytics(),
  );
  static final executiveOutStanding = GoRoute(
    path: AppRoutes.executiveOutStanding,
    builder: (context, state) => ExecutiveOutStanding(),
  );
  static final executiveProfile = GoRoute(
    path: AppRoutes.executiveProfile,
    builder: (context, state) => ExecutiveProfile(),
  );

  static final otherRoutes = <GoRoute>[
    GoRoute(
      path: AppRoutes.executiveTopCustomers,
      builder: (c, s) => const TopCustomersScreen(),
    ),
    GoRoute(
      path: AppRoutes.executiveNotVisiting,
      builder: (c, s) {
        final shop = s.extra as Shop;
        return ReasonForNotVisitingScreen(shop: shop);
      },
    ),
    GoRoute(
      path: AppRoutes.executiveWaitForApproval,
      builder: (context, state) => WaitForApprovalScreen(),
    ),
    GoRoute(
      path: AppRoutes.executiveShopDetails,
      builder: (context, state) => ShopDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.executiveAnalyticsConsolidated,
      builder: (context, state) => ConsolidatedAnalyticScreen(),
    ),
    GoRoute(
      path: AppRoutes.executiveAddShop,
      builder: (c, s) => AddNewShopScreen(),
    ),
  ];
}
