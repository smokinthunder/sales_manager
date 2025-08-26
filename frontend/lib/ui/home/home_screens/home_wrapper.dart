import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/home/home_screens/area_manager_home.dart';
import 'package:sales_manager/ui/home/home_screens/executive_home.dart';

class HomeWrapper extends ConsumerWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserNotifierProvider);
    if (user == null) {
      context.go(RoutePaths.login);
    }
    switch (user!.type) {
      case UserType.areaManager:
        return AreaManagerHome();
      case UserType.executive:
        return ExecutiveHome();
    }
  }
}
