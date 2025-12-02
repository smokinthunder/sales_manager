import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/viewmodel/auth_viewmodel.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;
  const HomeScreen({super.key, required this.child});

  static const tabs = [
    _NavTab(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: Routes.dashboard,
      title: 'Dashboard',
    ),
    _NavTab(
      label: 'Customer',
      icon: Icons.group_outlined,
      route: Routes.customer,
      title: 'Customer',
    ),
    _NavTab(
      label: 'Analytics',
      icon: Icons.bar_chart_outlined,
      route: Routes.analytics,
      title: 'Analytics',
    ),
    _NavTab(
      label: 'Executive',
      icon: Icons.person_outline,
      route: Routes.executive,
      title: 'Executive',
    ),
    _NavTab(
      label: 'Outstanding',
      icon: Icons.receipt_long_outlined,
      route: Routes.outstanding,
      title: 'Outstanding',
    ),
    _NavTab(
      label: 'Area Manager',
      icon: Icons.manage_accounts,
      route: Routes.areaManager,
      title: 'Area Manager',
    ),
    _NavTab(
      label: 'Order',
      icon: Icons.shopping_cart_outlined,
      route: Routes.order,
      title: 'Order',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final shrink = width <= 864;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar
            Container(
              width: shrink ? 130 : 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 1],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 50),
                      width: shrink ? 80 : 120,
                      height: shrink ? 80 : 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Image.asset('assets/images/company_logo.png'),
                    ),
                  ),
                  for (final tab in tabs)
                    _buildDrawerButton(
                      theme,
                      tab.icon,
                      tab.title,
                      location.startsWith(tab.route),
                      shrink,
                      () {
                        context.go(tab.route);
                      },
                    ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 78,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_none,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () {
                                //TODO Handle notification button press
                                context.go(Routes.notifications);
                              },
                            ),
                            SizedBox(width: 16),
                            Consumer(
                              builder: (context, ref, child) {
                                // Listen for logout completion
                                ref.listen<AuthState>(
                                  authViewModelProvider,
                                  (previous, next) {
                                    if (next is AuthUnauthenticated && 
                                        previous is AuthLoading) {
                                      // Navigate to login after successful logout
                                      context.go(Routes.login);
                                    }
                                  },
                                );

                                final authState = ref.watch(authViewModelProvider);
                                final isLoggingOut = authState is AuthLoading;

                                return InkWell(
                                  onTap: isLoggingOut ? null : () async {
                                    // Show confirmation dialog
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Logout'),
                                        content: const Text(
                                          'Are you sure you want to logout?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Logout'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmed == true) {
                                      // Perform logout - this will clear tokens and update state
                                      await ref
                                          .read(authViewModelProvider.notifier)
                                          .logout();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: isLoggingOut
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    theme.colorScheme.primary,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.logout_outlined,
                                                color: theme.colorScheme.primary,
                                              ),
                                      ),
                                      Text(
                                        isLoggingOut ? "Logging out..." : "Logout",
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 32),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          (location == Routes.notifications)
                              ? "Notification"
                              : tabs
                                    .where(
                                      (element) =>
                                          location.startsWith(element.route),
                                    )
                                    .first
                                    .title,
                          style: theme.textTheme.headlineLarge,
                        ),
                      ),
                      Center(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildDrawerButton(
    ThemeData theme,
    IconData iconData,
    String title,
    bool selected,
    bool shrink,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    child: Container(
      width: shrink ? 100 : 220,
      height: 60,
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.surface : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 20),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onPrimary,
            ),
            child: Icon(
              iconData,
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          ),
          if (!shrink)
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onPrimary,
              ),
            ),
        ],
      ),
    ),
  );
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
