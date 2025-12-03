import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/empty_state.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FindExecutive extends ConsumerStatefulWidget {
  const FindExecutive({super.key});

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
        spacing: 32,
        children: [
          Row(
            spacing: 20,
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
                    hintText: "Search Executive by name, phone, or email",
                  ),
                ),
              ),
            ],
          ),
          Container(
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
                  flex: 2,
                  child: Table(
                    children: [
                      _buildTableRow(theme, "Name", "Arun Kumar"),
                      _buildTableRow(theme, "Location", "Ernakulam"),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  flex: 2,
                  child: Table(
                    children: [
                      _buildTableRow(theme, "Contanct no", "+91 345345345"),
                      _buildTableRow(theme, "Joined date", "21-08-205"),
                    ],
                  ),
                ),
              ],
            ),
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
                    return Expanded(
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
                    cardHeight: 102,
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
                loading: () => Expanded(
                  child: LoadingState(message: 'Loading executives...'),
                ),
                error: (error, stack) => Expanded(
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
          child: Text(value, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }
}
