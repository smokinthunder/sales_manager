import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AreaManager extends StatelessWidget {
  const AreaManager({super.key});

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
                title: "Total Area Managers",
                count: "15489",
                width: 216,
              ),

              TitleAndValueContainer(
                title: "New Area Managers",
                count: "5",
                width: 216,
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
          SafePaginatedCardGrid(
            cardHeight: 208,
            cardWidth: 208,
            cards: [
              for (var _ in Iterable.generate(1000))
                AreaManagerCard(
                  onFindExecutives: () {
                    //TODO:
                    context.go(Routes.findExecutive);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AreaManagerCard extends StatelessWidget {
  const AreaManagerCard({super.key, required this.onFindExecutives});
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
                _buildIconAndTextRow(Icons.person_outline, "Rahul", theme),

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
