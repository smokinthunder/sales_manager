import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/widgets/app_bar.dart';

class ExecutiveScaffold extends StatelessWidget {
  final Widget child;
  const ExecutiveScaffold({super.key, required this.child});

  static const tabs = [
    _NavTab(
      label: 'Home',
      title: 'Home',
      icon: Icons.home_outlined,
      route: RoutePaths.home,
    ),
    _NavTab(
      label: 'Analytics',
      title: 'Analytics',
      icon: Icons.pie_chart_outline,
      route: RoutePaths.analyticsRoot,
    ),
    _NavTab(
      label: 'Outstanding',
      title: 'Outstanding',
      icon: Icons.access_time,
      route: RoutePaths.outstanding,
    ),
    _NavTab(
      label: 'Profile',
      title: 'Profile Editing',
      icon: Icons.person_outline_rounded,
      route: RoutePaths.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = tabs.indexWhere(
      (tab) => location.startsWith(tab.route),
    );
    final safeIndex = currentIndex == -1 ? 0 : currentIndex;
    final isHome = tabs[safeIndex].route == RoutePaths.home;

    return Scaffold(
      backgroundColor: isHome
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.onPrimary,
      body: child,
      appBar: (isHome)
          ? CustomAppBar()
          : AppBar(
              title: Text(tabs[safeIndex].title),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  context.go(RoutePaths.home);
                },
              ),
              centerTitle: true,
            ),
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
  final String title;
  const _NavTab({
    required this.label,
    required this.icon,
    required this.route,
    required this.title,
  });
}
