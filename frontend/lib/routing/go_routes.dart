import 'package:go_router/go_router.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/analytics/consol_exec_analytics.dart';
import 'package:sales_manager/ui/analytics/analytics.dart';
import 'package:sales_manager/ui/analytics/individual_analytics.dart';
import 'package:sales_manager/ui/home/add_shop/add_new_shop.dart';
import 'package:sales_manager/ui/home/add_shop/success.dart';
import 'package:sales_manager/ui/home/create_target.dart';
import 'package:sales_manager/ui/home/home_screens/home.dart';
import 'package:sales_manager/ui/home/messages.dart';
import 'package:sales_manager/ui/home/not_visiting.dart';
// import 'package:sales_manager/ui/home/notification.dart';
import 'package:sales_manager/ui/home/pending_requests.dart';
import 'package:sales_manager/ui/home/route_screen.dart';
import 'package:sales_manager/ui/home/shop_details.dart';
import 'package:sales_manager/ui/home/top_customers.dart';
import 'package:sales_manager/ui/home/add_shop/wait_for_approval.dart';
import 'package:sales_manager/ui/home/view_history.dart';
import 'package:sales_manager/ui/notification/notification_screen_new.dart';
import 'package:sales_manager/ui/orders/cart_screen.dart';
import 'package:sales_manager/ui/orders/create_order_screen.dart';
import 'package:sales_manager/ui/orders/order_history_screen.dart';
import 'package:sales_manager/ui/orders/select_product_screen.dart';
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
      path: RoutePaths.consolidatedOrExecutiveAnalytics,
      builder: (context, state) => ConsolidatedAnalyticsScreen(),
    ),
    GoRoute(path: RoutePaths.addShop, builder: (c, s) => AddNewShopScreen()),
    GoRoute(
      path: RoutePaths.shopAnalytics,
      builder: (context, state) => IndividualAnalyticsScreen(),
    ),
    GoRoute(
      path: RoutePaths.consolidatedOrExecutiveAnalytics,
      builder: (context, state) => ConsolidatedAnalyticsScreen(),
    ),
    GoRoute(
      path: RoutePaths.addShopSuccess,
      builder: (context, state) => const SuccessScreen(),
    ),
    GoRoute(
      path: RoutePaths.viewExecutiveHistory,
      builder: (c, s) => const ViewExecutiveHistory(),
    ),
    GoRoute(
      path: RoutePaths.notifications,
      builder: (c, s) => const NotificationScreen(),
    ),
    GoRoute(path: RoutePaths.chat, builder: (c, s) => const MessageScreen()),
    GoRoute(
      path: RoutePaths.pendingRequests,
      builder: (c, s) => const PendingRequests(),
    ),
    GoRoute(
      path: RoutePaths.createTarget,
      builder: (c, s) => const CreateTargetScreen(),
    ),
    GoRoute(
      path: RoutePaths.selectProducts,
      builder: (c, s) => const SelectProductScreen(),
    ),
    GoRoute(path: RoutePaths.cart, builder: (c, s) => const CartScreen()),
    GoRoute(
      path: RoutePaths.createOrder,
      builder: (c, s) => const CreateOrderScreen(),
    ),
    GoRoute(
      path: RoutePaths.orderHistory,
      builder: (c, s) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: RoutePaths.todaysRoute,
      builder: (c, s) => const RouteScreen(isSpecial: false),
    ),
    GoRoute(
      path: RoutePaths.todaysSpecialRoute,
      builder: (context, state) => const RouteScreen(isSpecial: true),
    ),
  ];
}
