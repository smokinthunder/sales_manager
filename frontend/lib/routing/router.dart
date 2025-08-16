import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/dependencies.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/auth/login_screen.dart';
import 'package:sales_manager/ui/loading_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(authStreamProvider).valueOrNull;

  return GoRouter(
    initialLocation: AppRoutes.loading,
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (c, s) => const LoadingScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (c, s) => const LoginScreen()),
    ],
    redirect: (context, state) {
      final atLogin = state.matchedLocation == AppRoutes.login;

      if (user == null) return atLogin ? null : AppRoutes.login;

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
