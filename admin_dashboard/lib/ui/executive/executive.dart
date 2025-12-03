import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Executive extends ConsumerStatefulWidget {
  const Executive({super.key});

  @override
  ConsumerState<Executive> createState() => _ExecutiveState();
}

class _ExecutiveState extends ConsumerState<Executive> {
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
              Consumer(
                builder: (context, ref, child) {
                  final count = ref.watch(activeSalesExecutivesCountProvider);
                  return count.when(
                    data: (total) => TitleAndValueContainer(
                      title: "Total Executives",
                      count: total.toString(),
                      width: 200,
                    ),
                    loading: () => TitleAndValueContainer(
                      title: "Total Executives",
                      count: "...",
                      width: 200,
                    ),
                    error: (_, __) => TitleAndValueContainer(
                      title: "Total Executives",
                      count: "0",
                      width: 200,
                    ),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final stats = ref.watch(dashboardStatsProvider);
                  return stats.when(
                    data: (dashboardStats) => TitleAndValueContainer(
                      title: "New Executives",
                      count: "0", // TODO: Need newExecutives field in backend
                      width: 200,
                    ),
                    loading: () => TitleAndValueContainer(
                      title: "New Executives",
                      count: "...",
                      width: 200,
                    ),
                    error: (_, __) => TitleAndValueContainer(
                      title: "New Executives",
                      count: "0",
                      width: 200,
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by executive",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Total Executives', style: theme.textTheme.headlineMedium),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "New",
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
          Consumer(
            builder: (context, ref, child) {
              final executivesAsync = ref.watch(
                usersProvider(
                  role: 'sales_executive',
                  status: 'active',
                ),
              );

              return executivesAsync.when(
                data: (executivesList) {
                  // Apply client-side search filter
                  final filteredExecutives = _searchQuery.isEmpty
                      ? executivesList
                      : executivesList
                          .where((exec) =>
                              exec.name
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              exec.phone
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              (exec.email != null &&
                                  exec.email!
                                      .toLowerCase()
                                      .contains(_searchQuery.toLowerCase())))
                          .toList();

                  return SafePaginatedCardGrid(
                    cardWidth: 208,
                    cardHeight: 272,
                    cards: [
                      for (var executive in filteredExecutives)
                        ExecutiveCard(
                          executive: executive,
                          onAddSpecialRoute: () {
                            //TODO
                            context.go(Routes.assignSpecialRoutes);
                          },
                          onFindDealers: () {
                            //TODO:
                            context.go(Routes.findDealers);
                          },
                        ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading executives: $error',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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

class ExecutiveCard extends StatelessWidget {
  const ExecutiveCard({
    super.key,
    required this.executive,
    required this.onFindDealers,
    required this.onAddSpecialRoute,
  });
  
  final dynamic executive; // AppUser type
  final VoidCallback onFindDealers;
  final VoidCallback onAddSpecialRoute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 208,
      height: 272,
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
              children: [
                _buildIconAndTextRow(
                  Icons.person_outline,
                  executive.name,
                  theme,
                ),
                _buildIconAndTextRow(
                  Symbols.crown_rounded,
                  "N/A", // TODO: Need manager name from relationship API
                  theme,
                ),
                _buildIconAndTextRow(
                  Symbols.phone,
                  executive.phone,
                  theme,
                ),
                _buildIconAndTextRow(
                  Icons.location_on_outlined,
                  "N/A", // TODO: Need territory/location details from API
                  theme,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onFindDealers,
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Find Dealers",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onAddSpecialRoute,
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                border: Border.all(color: theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Add Special Route",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
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
        child: Icon(icon, color: theme.colorScheme.tertiary, size: 28),
      ),
      Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
    ],
  );
}
