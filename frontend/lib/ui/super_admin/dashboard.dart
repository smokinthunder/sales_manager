import 'package:flutter/material.dart';
import 'package:sales_manager/ui/widgets/drop_down_menu.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Admin Dashboard'),
        actions: [
          ElevatedButton(
            onPressed: () {
              //TODO: Implement logout
            },
            child: Text("Logout"),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Super Admin!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: CustomDropDownMenu(
                  hintText: "Select Tenant",
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: 'tenant1', label: 'Tenant 1'),
                    DropdownMenuEntry(value: 'tenant2', label: 'Tenant 2'),
                    DropdownMenuEntry(value: 'tenant3', label: 'Tenant 3'),
                  ],
                ),
              ),
              Wrap(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Executives", style: textTheme.bodyLarge),
                            Text("Total: 150"),
                            Text("Active: 120"),
                            Text("Added this month: 10"),
                            Text("Yearly Growth: 15%"),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to user management screen
                              },
                              child: Text("Edit Executives"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Area Managers", style: textTheme.bodyLarge),
                            Text("Total: 150"),
                            Text("Active: 120"),
                            Text("Added this month: 10"),
                            Text("Yearly Growth: 15%"),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to user management screen
                              },
                              child: Text("Edit Managers"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shops", style: textTheme.bodyLarge),
                            Text("Total: 150"),
                            Text("Active: 120"),
                            Text("Added this month: 10"),
                            Text("Yearly Growth: 15%"),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to user management screen
                              },
                              child: Text("Edit Shops"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sales", style: textTheme.bodyLarge),
                            Text("Total Sales: \$500,000"),
                            Text("Monthly Sales: \$50,000"),
                            Text("Yearly Growth: 20%"),
                            Text("Top Performing Area: Area 1"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to user management screen
                },
                child: Text("Edit Tenant details"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
