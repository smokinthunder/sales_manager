import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FindDealers extends StatelessWidget {
  const FindDealers({super.key});

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
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search shop",
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
                  child: Table(
                    children: [
                      _buildTableRow(theme, "Name", "Arun Kumar"),
                      _buildTableRow(theme, "Location", "Ernakulam"),
                      _buildTableRow(theme, "Contanct no", "+91 345345345"),
                      _buildTableRow(theme, "Joined date", "21-08-205"),
                    ],
                  ),
                ),
                Spacer(),
                Flexible(
                  child: Table(
                    children: [
                      _buildTableRow(theme, "Total Shops", "35"),
                      _buildTableRow(theme, "Month", "Sep"),
                      _buildTableRow(theme, "Pending to Visit", "10"),
                      _buildTableRow(theme, "Visited Shops", "25"),
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
                  context.go(Routes.executive);
                },
                child: Text(
                  "Total Executive",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Find Dealers"),
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
            cardHeight: 220,
            cardWidth: 224,
            cards: [
              for (var _ in Iterable.generate(100000))
                ShopStateCard(
                  orderReceived: true,
                  shopVisited: false,
                  executiveName: "Abhin K Leji",
                  executivePhoneNo: "+91 8345349537",
                  shopName: "Kerala Pipe House",
                  shopLocation: "Kerala Pipe House",
                ),
            ],
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
}

class ShopStateCard extends StatelessWidget {
  const ShopStateCard({
    super.key,
    required this.orderReceived,
    required this.shopVisited,
    required this.shopName,
    required this.shopLocation,
    required this.executiveName,
    required this.executivePhoneNo,
  });
  final bool orderReceived;
  final bool shopVisited;
  final String shopName;
  final String shopLocation;
  final String executiveName;
  final String executivePhoneNo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 224,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shopName, style: theme.textTheme.bodyLarge),
                Text(
                  shopLocation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 8),
                Text(executiveName, style: theme.textTheme.bodyLarge),
                Text(
                  executivePhoneNo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(16),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                top: BorderSide(color: theme.colorScheme.tertiary),
              ),
            ),
            child: Column(
              children: [
                _buildStateRow(orderReceived, "Order received"),
                _buildStateRow(shopVisited, "Shop Visited"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateRow(bool isDone, String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
    child: Row(
      children: [
        Text(text),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            color: isDone ? const Color(0xff34c759) : const Color(0xffbe2121),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(isDone ? Icons.check : Icons.close, color: Colors.white),
        ),
      ],
    ),
  );
}
