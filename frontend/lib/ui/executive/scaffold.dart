import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/common/app_bar.dart';

class ExecutiveScaffold extends StatelessWidget {
  final Widget child;
  const ExecutiveScaffold({super.key, required this.child});

  static const tabs = [
    _NavTab(label: 'Home', icon: Icons.home, route: AppRoutes.executiveHome),
    _NavTab(
      label: 'Analytics',
      icon: Icons.pie_chart,
      route: AppRoutes.executiveAnalytics,
    ),
    _NavTab(
      label: 'Outstanding',
      icon: Icons.access_time,
      route: AppRoutes.executiveOutStanding,
    ),
    _NavTab(
      label: 'Profile',
      icon: Icons.person,
      route: AppRoutes.executiveProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = tabs.indexWhere(
      (tab) => location.startsWith(tab.route),
    );
    final safeIndex = currentIndex == -1 ? 0 : currentIndex;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: child,
      appBar: const CustomAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          final tab = tabs[index];
          context.go(tab.route);
        },
        currentIndex: safeIndex,
        items: [
          for (final tab in tabs)
            BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}

class _NavTab {
  final String label;
  final IconData icon;
  final String route;
  const _NavTab({required this.label, required this.icon, required this.route});
}
