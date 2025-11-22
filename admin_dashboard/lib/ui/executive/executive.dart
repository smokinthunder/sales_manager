import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Executive extends StatelessWidget {
  const Executive({super.key});

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
              TitleAndValueContainer(
                title: "Total Executives",
                count: "100",
                width: 200,
              ),
              TitleAndValueContainer(
                title: "New Executives",
                count: "15",
                width: 200,
              ),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
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
          SafePaginatedCardGrid(
            cardWidth: 208,
            cardHeight: 272,
            cards: [
              for (var _ in Iterable.generate(10000))
                ExecutiveCard(
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
          ),
        ],
      ),
    );
  }
}

class ExecutiveCard extends StatelessWidget {
  const ExecutiveCard({
    super.key,
    required this.onFindDealers,
    required this.onAddSpecialRoute,
  });
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
                _buildIconAndTextRow(Icons.person_outline, "Rahul", theme),
                _buildIconAndTextRow(Symbols.crown_rounded, "Rajev", theme),

                _buildIconAndTextRow(Symbols.phone, "+91 984624352", theme),
                _buildIconAndTextRow(
                  Icons.location_on_outlined,
                  "Kochi, Edappaly +91 984624352",
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
