import 'package:go_router/go_router.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/analytics/consolidated_analytics.dart';
import 'package:sales_manager/ui/analytics/analytics.dart';
import 'package:sales_manager/ui/analytics/individual_analytics.dart';
import 'package:sales_manager/ui/home/add_shop/add_new_shop.dart';
import 'package:sales_manager/ui/home/home_screens/home.dart';
import 'package:sales_manager/ui/home/not_visiting.dart';
import 'package:sales_manager/ui/home/shop_details.dart';
import 'package:sales_manager/ui/home/top_customers.dart';
import 'package:sales_manager/ui/home/add_shop/wait_for_approval.dart';
import 'package:sales_manager/ui/outstanding/outstanding.dart';
import 'package:sales_manager/ui/profile/profile.dart';

abstract class ExecutiveRoutes {
  static final executiveHome = GoRoute(
    path: RoutePaths.home,
    builder: (context, state) => HomeScreen(),
  );
  static final executiveAnalytics = GoRoute(
    path: RoutePaths.analyticsRoot,
    builder: (context, state) => ExecutiveAnalytics(),
  );
  static final executiveOutStanding = GoRoute(
    path: RoutePaths.outstanding,
    builder: (context, state) => ExecutiveOutStanding(),
  );
  static final executiveProfile = GoRoute(
    path: RoutePaths.profile,
    builder: (context, state) => ExecutiveProfile(),
  );

  static final otherRoutes = <GoRoute>[
    GoRoute(
      path: RoutePaths.executiveTopCustomers,
      builder: (c, s) => const TopCustomersScreen(),
    ),
    GoRoute(
      path: RoutePaths.reasonForNotVisting,
      builder: (c, s) {
        final shop = s.extra as Shop;
        return ReasonForNotVisitingScreen(shop: shop);
      },
    ),
    GoRoute(
      path: RoutePaths.waitForApproval,
      builder: (context, state) => WaitForApprovalScreen(),
    ),
    GoRoute(
      path: RoutePaths.executiveShopDetails,
      builder: (context, state) => ShopDetailScreen(),
    ),
    GoRoute(
      path: RoutePaths.executiveAnalyticsConsolidated,
      builder: (context, state) => ConsolidatedAnalyticsScreen(),
    ),
    GoRoute(path: RoutePaths.addShop, builder: (c, s) => AddNewShopScreen()),
    GoRoute(
      path: RoutePaths.executiveAnalyticsIndividual,
      builder: (context, state) => IndividualAnalyticsScreen(),
    ),
    GoRoute(
      path: RoutePaths.executiveAnalyticsConsolidated,
      builder: (context, state) => ConsolidatedAnalyticsScreen(),
    ),
  ];
}
