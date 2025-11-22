import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/customer/inactive_customers.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActiveCustomers extends StatelessWidget {
  const ActiveCustomers({super.key});

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
              Text("Active Customers"),
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
            title: "Active customers",
            monthString: "September 2025",
          ),
        ],
      ),
    );
  }
}
