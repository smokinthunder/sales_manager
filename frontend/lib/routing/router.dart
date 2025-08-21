import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/auth/login_screen.dart';
import 'package:sales_manager/ui/auth/otp_screen.dart';
import 'package:sales_manager/ui/executive/analytics.dart';
import 'package:sales_manager/ui/executive/home.dart';
import 'package:sales_manager/ui/executive/outstanding.dart';
import 'package:sales_manager/ui/executive/profile.dart';
import 'package:sales_manager/ui/executive/scaffold.dart';
import 'package:sales_manager/ui/loading_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // final user = ref.watch(authStreamProvider).valueOrNull;
  final user = ref.watch(currentUserNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (c, s) => const LoadingScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (c, s) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.otp,
        builder: (c, s) {
          final phoneNumber = s.extra as String;
          return OtpVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return ExecutiveScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.executiveHome,
            builder: (context, state) => ExecutiveHome(),
          ),
          GoRoute(
            path: AppRoutes.executiveAnalytics,
            builder: (context, state) => ExecutiveAnalytics(),
          ),
          GoRoute(
            path: AppRoutes.executiveOutStanding,
            builder: (context, state) => ExecutiveOutStanding(),
          ),
          GoRoute(
            path: AppRoutes.executiveProfile,
            builder: (context, state) => ExecutiveProfile(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // final isLoggingIn =
      //     state.matchedLocation == AppRoutes.login ||
      //     state.matchedLocation == AppRoutes.otp;

      // // 1. User not logged in → force login unless already at login/otp
      // if (user == null) {
      //   return isLoggingIn ? null : AppRoutes.login;
      // }

      // if (user.type == UserType.executive) {
      //   if (!state.matchedLocation.startsWith(AppRoutes.executive) ||
      //       state.matchedLocation == AppRoutes.executive) {
      //     return AppRoutes.executiveHome;
      //   }
      // }

      // 3. Already in right place → no redirect
      return null;
    },
  );
});
