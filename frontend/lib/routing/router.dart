import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/routing/executiveRoutes.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/auth/login_screen.dart';
import 'package:sales_manager/ui/auth/otp_screen.dart';
import 'package:sales_manager/ui/executive/scaffold.dart';
import 'package:sales_manager/ui/common/screens/loading_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // final user = ref.watch(authStreamProvider).valueOrNull;
  final user = ref.watch(currentUserNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
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
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.otp;

      // 1. User not logged in → force login unless already at login/otp
      if (user == null) {
        return isLoggingIn ? null : AppRoutes.login;
      }

      if (user.type == UserType.executive) {
        if (!state.matchedLocation.startsWith(AppRoutes.executive) ||
            state.matchedLocation == AppRoutes.executive) {
          return AppRoutes.executiveHome;
        }
      }
      return null;
    },
  );
});

final loadinRoute = GoRoute(
  path: AppRoutes.loading,
  builder: (c, s) => const LoadingScreen(),
);

final loginRoute = GoRoute(
  path: AppRoutes.login,
  builder: (c, s) => const LoginScreen(),
);

final otpRoute = GoRoute(
  path: AppRoutes.otp,
  builder: (c, s) {
    final phoneNumber = s.extra as String;
    return OtpVerificationScreen(phoneNumber: phoneNumber);
  },
);
