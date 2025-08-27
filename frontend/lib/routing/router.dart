import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/routing/go_routes.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/auth/login_screen.dart';
import 'package:sales_manager/ui/auth/otp_screen.dart';
import 'package:sales_manager/ui/widgets/scaffold.dart';
import 'package:sales_manager/ui/loading_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // final user = ref.watch(authStreamProvider).valueOrNull;
  final user = ref.watch(currentUserNotifierProvider);

  return GoRouter(
    initialLocation: RoutePaths.loading,
    routes: [
      loadinRoute,
      loginRoute,
      otpRoute,
      ...ExecutiveRoutes.otherRoutes,
      ShellRoute(
        builder: (context, state, child) {
          return ExecutiveScaffold(child: child);
        },
        routes: [
          ExecutiveRoutes.executiveHome,
          ExecutiveRoutes.executiveAnalytics,
          ExecutiveRoutes.executiveOutStanding,
          ExecutiveRoutes.executiveProfile,
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggingIn =
          state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.otp;

      // 1. User not logged in → force login unless already at login/otp
      if (user == null) {
        return isLoggingIn ? null : RoutePaths.login;
      }

      if (state.matchedLocation == RoutePaths.loading) {
        return RoutePaths.home;
      }

      if (isLoggingIn) {
        return RoutePaths.home;
      }

      return null;
    },
  );
});

final loadinRoute = GoRoute(
  path: RoutePaths.loading,
  builder: (c, s) => const LoadingScreen(),
);

final loginRoute = GoRoute(
  path: RoutePaths.login,
  builder: (c, s) => const LoginScreen(),
);

final otpRoute = GoRoute(
  path: RoutePaths.otp,
  builder: (c, s) {
    final phoneNumber = s.extra as String;
    return OtpVerificationScreen(phoneNumber: phoneNumber);
  },
);
