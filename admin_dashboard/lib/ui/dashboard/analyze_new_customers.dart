import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/dashboard/analyze_collections.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalyzeNewCustomers extends StatelessWidget {
  const AnalyzeNewCustomers({super.key});

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
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.dashboard);
                },
                child: Text(
                  "Daily Report",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("New Customers Analyze"),
              Spacer(),
              Row(
                children: [
                  Icon(Icons.file_download_outlined),
                  Text("  Download Report"),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(64),
            padding: EdgeInsets.symmetric(horizontal: 72, vertical: 40),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              spacing: 32,
              children: [
                CompareDateRangePicker(),
                NewCustomerTable(
                  onClose: () {
                    //TODO:
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewCustomerTable extends StatelessWidget {
  const NewCustomerTable({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Text("New Customer Overview", style: theme.textTheme.bodyLarge),
              SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.surface,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Date range ", style: theme.textTheme.labelLarge),
                    Text("06-09-2025"),
                    Text(" to ", style: theme.textTheme.labelLarge),
                    Text("10-09-2025"),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text("Total New Customer", style: theme.textTheme.bodyLarge),
              Text(
                "5",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 32),
              Table(
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Shop Name")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Location")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Executive")),
                      ),
                    ],
                  ),
                  for (var _ in Iterable.generate(5))
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              '• Krishna Prasad',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              '• Cochin Pipe House',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              '• ₹7,21,072',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: -10,
            child: IconButton(onPressed: onClose, icon: Icon(Icons.close)),
          ),
        ],
      ),
    );
  }
}
