import 'package:admin_dashboard/domain/models/user/app_user.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/empty_state.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FindExecutive extends ConsumerStatefulWidget {
  final int managerId;
  
  const FindExecutive({required this.managerId, super.key});

  @override
  ConsumerState<FindExecutive> createState() => _FindExecutiveState();
}

class _FindExecutiveState extends ConsumerState<FindExecutive> {
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
        spacing: 12,
        children: [
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search Executive by name, phone, or email",
                  ),
                ),
              ),
            ],
          ),
          // Fetch area manager and executives data
          Consumer(
            builder: (context, ref, child) {
              // Fetch the selected area manager's data
              final managerAsync = ref.watch(userByIdProvider(widget.managerId));
              // Fetch all active executives
              final executivesAsync = ref.watch(usersProvider(
                role: 'sales_executive',
                status: 'active',
              ));

              return managerAsync.when(
                data: (managerData) {
                  final manager = AppUser.fromJson(managerData);
                  
                  return executivesAsync.when(
                    data: (executivesList) {
                      // Calculate statistics from real data
                      final totalExecutives = executivesList.length;
                      
                      return Container(
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(48),
                          border: Border.all(color: theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Table(
                                children: [
                                  _buildTableRow(theme, "Name", manager.name),
                                  _buildTableRow(theme, "Location", manager.territoryId?.toString() ?? 'N/A'),
                                  _buildTableRow(theme, "Contact no", manager.phone),
                                  _buildTableRow(theme, "Joined date", manager.createdAt.toString().split(' ')[0]),
                                ],
                              ),
                            ),
                            Spacer(),
                            Flexible(
                              child: Table(
                                children: [
                                  _buildTableRow(theme, "Total Executives", totalExecutives.toString()),
                                  _buildTableRow(theme, "Active", totalExecutives.toString()),
                                  _buildTableRow(theme, "Inactive", "0"),
                                  _buildTableRow(theme, "Month", _getCurrentMonthName()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(48),
                        border: Border.all(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stack) => Container(
                      padding: EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(48),
                        border: Border.all(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('Error loading executives: ${error.toString()}'),
                    ),
                  );
                },
                loading: () => Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(48),
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(48),
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('Error loading area manager: ${error.toString()}'),
                ),
              );
            },
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.areaManager);
                },
                child: Text(
                  "Area Manager",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Find Executive"),
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
          // Sales Executives List with real data
          Consumer(
            builder: (context, ref, child) {
              final executives = ref.watch(usersProvider(
                role: 'sales_executive',
                status: 'active',
                search: _searchQuery.isEmpty ? null : _searchQuery,
              ));

              return executives.when(
                data: (executivesList) {
                  // Empty state
                  if (executivesList.isEmpty) {
                    return SizedBox(
                      height: 400,
                      child: _searchQuery.isNotEmpty
                          ? SearchEmptyState(searchQuery: _searchQuery)
                          : EmptyState(
                              icon: Icons.person_search,
                              title: 'No executives found',
                              message:
                                  'Sales executives will appear here once assigned to this area',
                            ),
                    );
                  }

                  return SafePaginatedCardGrid(
                    cardHeight: 150,
                    cardWidth: 230,
                    cards: [
                      for (var executive in executivesList)
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: theme.colorScheme.tertiary),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                executive.name,
                                style: theme.textTheme.bodyLarge,
                              ),
                              Text(
                                executive.phone,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                executive.email ?? "N/A",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
                loading: () => SizedBox(
                  height: 400,
                  child: LoadingState(message: 'Loading executives...'),
                ),
                error: (error, stack) => SizedBox(
                  height: 400,
                  child: ErrorState(
                    title: 'Failed to load executives',
                    message: error.toString(),
                    onRetry: () {
                      ref.invalidate(usersProvider);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(ThemeData theme, String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            ":",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(value, style: theme.textTheme.bodyLarge, maxLines: 1),
        ),
      ],
    );
  }

  String _getCurrentMonthName() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[DateTime.now().month - 1];
  }
}
