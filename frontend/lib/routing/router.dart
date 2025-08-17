import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/auth/login_screen.dart';
import 'package:sales_manager/ui/auth/otp_screen.dart';
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
    ],
    redirect: (context, state) {
      final atLogin = state.matchedLocation == AppRoutes.login;
      if (user == null) return atLogin ? null : AppRoutes.otp;

      if (user.type == UserType.areaManager &&
          !state.matchedLocation.startsWith('/student')) {
        return '/student';
      }
      if (user.type == UserType.executive &&
          !state.matchedLocation.startsWith('/teacher')) {
        return '/teacher';
      }

      return null;
    },
  );
});
