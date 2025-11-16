import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

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
                title: "All Orders",
                count: "100",
                width: 200,
              ),
              TitleAndValueContainer(
                title: "New Orders",
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
                    hintText: "Search by bill no or name",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Orders', style: theme.textTheme.headlineMedium),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "Time",
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
            cardHeight: 222,
            cards: [
              for (var _ in Iterable.generate(10000))
                ShopAnalyticsCard(
                  onTap: () {
                    context.go(Routes.viewOrderDetails);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShopAnalyticsCard extends StatelessWidget {
  const ShopAnalyticsCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
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
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined, color: theme.colorScheme.tertiary),
              Text(" National Pipes", style: theme.textTheme.bodyLarge),
            ],
          ),
          SizedBox(height: 8),Row(
            children: [
              Icon(Icons.description_outlined, color: theme.colorScheme.tertiary),
              Text("0019", style: theme.textTheme.bodyLarge),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, color: theme.colorScheme.tertiary),
              Text(" Rahul Dev", style: theme.textTheme.labelLarge),
            ],
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Icon(
                Icons.currency_rupee,
                color: Colors.black,
                size: 28,
              ),
              Text(" 2456", style: theme.textTheme.headlineLarge),
            ],
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "View Bill",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

