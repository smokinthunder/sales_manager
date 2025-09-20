import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/widgets/bar_chart.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/sales_report.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 32,
            runSpacing: 32,
            children: [
              TitleAndValueContainer(title: "All Executive's", count: "100"),
              TitleAndValueContainer(title: "All Customers", count: "15489"),
              TitleAndValueContainer(title: "New Customers", count: "20"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Row(
              children: [
                Text('Daily Report', style: theme.textTheme.headlineMedium),
                Spacer(),
                Text("Sort by  ", style: theme.textTheme.labelLarge),
                SizedBox(
                  width: 118,
                  child: CustomDropDownMenu(
                    hintText: "Time",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "Time", label: "Time"),
                      DropdownMenuEntry(value: "Day", label: "Day"),
                      DropdownMenuEntry(value: "Month", label: "Month"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Wrap(
              spacing: 32,
              runSpacing: 32,
              children: [
                _buildLineCharts(
                  onAnalyze: () {
                    context.go(Routes.analyzeSales);
                  },
                  theme: theme,
                  interval: "Daily",
                  title: "Sales",
                  value: "85874 ₹",
                  delta: -1,
                  deltaSubString: "Decrease in today's Sales",
                  lastUpdated: "4 min ago",
                  salesData: const [
                    SalesReportDataMap('Jan', 5),
                    SalesReportDataMap('Feb', 7.5),
                    SalesReportDataMap('Mar', 10),
                    SalesReportDataMap('Apr', 8),
                    SalesReportDataMap('May', 15),
                    SalesReportDataMap('Jun', 10),
                    SalesReportDataMap('Jul', 8),
                    SalesReportDataMap('Aug', 4),
                    SalesReportDataMap('Sep', 5),
                    SalesReportDataMap('Oct', 8),
                    SalesReportDataMap('Nov', 10),
                    SalesReportDataMap('Dec', 4),
                  ],
                ),
                _buildLineCharts(
                  onAnalyze: () {
                    context.go(Routes.analyzeCollection);
                  },
                  theme: theme,
                  interval: "Daily",
                  title: "Collection",
                  value: "78652 ₹",
                  lastUpdated: "4 min ago",
                  delta: 5,
                  deltaSubString: "Increase in today's Collection",
                  salesData: const [
                    SalesReportDataMap('Jan', 5),
                    SalesReportDataMap('Feb', 7.5),
                    SalesReportDataMap('Mar', 10),
                    SalesReportDataMap('Apr', 8),
                    SalesReportDataMap('May', 15),
                    SalesReportDataMap('Jun', 10),
                    SalesReportDataMap('Jul', 8),
                    SalesReportDataMap('Aug', 4),
                    SalesReportDataMap('Sep', 5),
                    SalesReportDataMap('Oct', 8),
                    SalesReportDataMap('Nov', 10),
                    SalesReportDataMap('Dec', 4),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  width: 470,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.tertiary.withAlpha(128),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OurBarChart(
                        dataMap: [
                          const BarChartDataMap(label: 'Mon', value: 30),
                          const BarChartDataMap(label: 'Tue', value: 45),
                          const BarChartDataMap(label: 'Wed', value: 28),
                          const BarChartDataMap(label: 'Thu', value: 60),
                          const BarChartDataMap(label: 'Fri', value: 50),
                          const BarChartDataMap(label: 'Sat', value: 80),
                          const BarChartDataMap(label: 'Sun', value: 40),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "New Customers",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  4 >= 0
                                      ? Icon(
                                          Icons.arrow_upward,
                                          size: 12,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.arrow_downward,
                                          size: 12,
                                          color: Colors.red,
                                        ),
                                  Text(
                                    "4 ",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: 4 >= 0 ? Colors.green : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    "New Customers Added Today",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 12),
                                  Text(
                                    "  Updated 4 min ago",
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.onSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //TODO
                              context.go(Routes.analyzeNewCustomers);
                            },
                            child: Text(
                              "Analyze",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildLineCharts({
    required ThemeData theme,
    required List<SalesReportDataMap> salesData,
    required String interval,
    required String title,
    required String value,
    required int delta,
    required String deltaSubString,
    required String lastUpdated,
    required VoidCallback onAnalyze,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      width: 470,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.tertiary.withAlpha(128),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: SalesReport(salesData: salesData),
          ),
          SizedBox(height: 8),
          Text("$interval $title", style: theme.textTheme.bodyMedium),

          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(letterSpacing: 0),
          ),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      delta >= 0
                          ? Icon(
                              Icons.arrow_upward,
                              size: 12,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.arrow_downward,
                              size: 12,
                              color: Colors.red,
                            ),
                      Text(
                        "$delta % ",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: delta >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        deltaSubString,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12),
                      Text(
                        "  Updated $lastUpdated",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onAnalyze,
                child: Text(
                  "Analyze",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
