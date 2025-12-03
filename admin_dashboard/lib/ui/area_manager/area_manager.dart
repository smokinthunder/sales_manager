import 'package:admin_dashboard/domain/models/user/app_user.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AreaManager extends ConsumerStatefulWidget {
  const AreaManager({super.key});

  @override
  ConsumerState<AreaManager> createState() => _AreaManagerState();
}

class _AreaManagerState extends ConsumerState<AreaManager> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          Row(
            spacing: 32,
            children: [
              // Total Area Managers
              Consumer(
                builder: (context, ref, child) {
                  final count = ref.watch(activeAreaManagersCountProvider);
                  return count.when(
                    data: (num) => TitleAndValueContainer(
                      title: "Total Area Managers",
                      count: "$num",
                      width: 216,
                    ),
                    loading: () => TitleAndValueContainer(
                      title: "Total Area Managers",
                      count: "...",
                      width: 216,
                    ),
                    error: (error, stack) => TitleAndValueContainer(
                      title: "Total Area Managers",
                      count: "0",
                      width: 216,
                    ),
                  );
                },
              ),
              // New Area Managers
              Consumer(
                builder: (context, ref, child) {
                  final dashboardStats = ref.watch(dashboardStatsProvider);
                  return dashboardStats.when(
                    data: (stats) => TitleAndValueContainer(
                      title: "New Area Managers",
                      count: "${stats.newAreaManagers}",
                      width: 216,
                    ),
                    loading: () => TitleAndValueContainer(
                      title: "New Area Managers",
                      count: "...",
                      width: 216,
                    ),
                    error: (error, stack) => TitleAndValueContainer(
                      title: "New Area Managers",
                      count: "0",
                      width: 216,
                    ),
                  );
                },
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  //TODO
                  context.go(Routes.addAreaManager);
                },
                child: Row(
                  children: [
                    Text(
                      "Add New Area Manager ",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    Icon(Icons.add, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by area manager name, phone, or email",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Area Managers', style: theme.textTheme.headlineMedium),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "Name",
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "Old", label: "Old"),
                    DropdownMenuEntry(value: "A-Z", label: "A-Z (Ascending)"),
                    DropdownMenuEntry(
                      value: "Month",
                      label: "Z-A (Descending)",
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Area Managers List with real data
          Consumer(
            builder: (context, ref, child) {
              final areaManagers = ref.watch(usersProvider(
                role: 'area_manager',
                status: 'active',
                search: _searchQuery.isEmpty ? null : _searchQuery,
              ));

              return areaManagers.when(
                data: (managers) => SafePaginatedCardGrid(
                  cardHeight: 208,
                  cardWidth: 208,
                  cards: [
                    for (var manager in managers)
                      AreaManagerCard(
                        manager: manager,
                        onFindExecutives: () {
                          context.go('${Routes.findExecutive}/${manager.id}');
                        },
                      ),
                  ],
                ),
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load area managers',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AreaManagerCard extends StatelessWidget {
  const AreaManagerCard({
    super.key,
    required this.manager,
    required this.onFindExecutives,
  });
  
  final AppUser manager;
  final VoidCallback onFindExecutives;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 208,
      height: 208,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            color: theme.colorScheme.primary.withAlpha(16),
            child: Column(
              spacing: 6,
              children: [
                _buildIconAndTextRow(Icons.person_outline, manager.name, theme),
                _buildIconAndTextRow(Symbols.phone, manager.phone, theme),
                _buildIconAndTextRow(
                  Icons.location_on_outlined,
                  manager.territoryId?.toString() ?? 'N/A',
                  theme,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onFindExecutives,
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Find Executive",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildIconAndTextRow(IconData icon, String text, ThemeData theme) => Row(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(icon, color: theme.colorScheme.tertiary, size: 26),
      ),
      Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
    ],
  );
}
