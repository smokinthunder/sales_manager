import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/core/theme.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnalyzeCollections extends StatelessWidget {
  const AnalyzeCollections({super.key});

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
              Text("Daily Collection Analyze"),
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
                DailyCollectionTable(
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

class DailyCollectionTable extends StatelessWidget {
  const DailyCollectionTable({super.key, required this.onClose});
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
              Text(
                "Daily Collection Overview",
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorScheme.surface, width: 1),
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
              Text("Total Sales Amount", style: theme.textTheme.bodyLarge),
              Text(
                "₹87,45,217",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 32),
              Table(
                children: [
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Area Manager")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Shop Name")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Received Amount")),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text("Pending Amount")),
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
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Center(
                            child: Text(
                              '• ₹7,21,072',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.red,
                              ),
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

class CompareDateRangePicker extends StatelessWidget {
  const CompareDateRangePicker({super.key});

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
          Text(
            "Compare performace across custom timeframes",
            style: theme.textTheme.bodyLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pick a period  "),
              SizedBox(
                width: 160,
                child: CustomDropDownMenu(
                  hintText: "21-06-2025",
                  dropdownMenuEntries: [],
                ),
              ),
              SizedBox(width: 32),
              SizedBox(
                width: 160,
                child: CustomDropDownMenu(
                  hintText: "21-06-2025",
                  dropdownMenuEntries: [],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              //TODO
            },
            child: Container(
              height: 40,
              width: 192,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  "Analyze",
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
