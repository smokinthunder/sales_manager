import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InactiveCustomers extends StatelessWidget {
  const InactiveCustomers({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.customer);
                },
                child: Text(
                  "All customer list",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Inactive Customers"),
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
          CustomerTable(
            data: [
              CustomerData(
                name: "ABC Mart",
                location: "Downtown",
                area: "Central",
                executive: "John Doe",
                areaManager: "Jane Smith",
              ),
              CustomerData(
                name: "XYZ Store",
                location: "Uptown",
                area: "North",
                executive: "Alice Brown",
                areaManager: "Bob Johnson",
              ),
              CustomerData(
                name: "QuickShop",
                location: "West End",
                area: "West",
                executive: "Charlie Green",
                areaManager: "Diana White",
              ),
            ],
            title: "Inactive customers",
            monthString: "September 2025",
          ),
        ],
      ),
    );
  }
}

class CustomerTable extends StatelessWidget {
  const CustomerTable({
    super.key,
    required this.data,
    required this.title,
    required this.monthString,
  });
  final List<CustomerData> data;
  final String title;
  final String monthString;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.tertiary.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(data.length.toString(), style: theme.textTheme.headlineLarge),
          Row(
            children: [
              Spacer(),
              Text(monthString, style: theme.textTheme.labelLarge),
            ],
          ),
          Divider(color: theme.colorScheme.tertiary.withAlpha(128)),
          Table(
            children: [
              TableRow(
                children: [
                  _buildTableTitle("Shop Name", theme.textTheme.headlineMedium),
                  _buildTableTitle("Location", theme.textTheme.headlineMedium),
                  _buildTableTitle("Area", theme.textTheme.headlineMedium),
                  _buildTableTitle("Executive", theme.textTheme.headlineMedium),
                  _buildTableTitle(
                    "Area Manager",
                    theme.textTheme.headlineMedium,
                  ),
                ],
              ),
              ...data.map(
                (e) => TableRow(
                  children: [
                    _buildTableText(e.name),
                    _buildTableText(e.location),
                    _buildTableText(e.area),
                    _buildTableText(e.executive),
                    _buildTableText(e.areaManager),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding _buildTableText(String e) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(e),
    );
  }

  Widget _buildTableTitle(String title, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(title, style: style),
    );
  }
}

class CustomerData {
  final String name;
  final String location;
  final String area;
  final String executive;
  final String areaManager;
  const CustomerData({
    required this.name,
    required this.location,
    required this.area,
    required this.executive,
    required this.areaManager,
  });
}
