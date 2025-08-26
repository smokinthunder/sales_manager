import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sales_manager/ui/common/widgets/drop_down_menu.dart';
import 'package:sales_manager/ui/core/theme.dart';
import 'package:sales_manager/ui/executive/analytics/widgets/best_selling_product.dart';
import 'package:sales_manager/ui/executive/analytics/widgets/sales_report.dart';

class IndividualAnalyticsScreen extends StatefulWidget {
  const IndividualAnalyticsScreen({super.key});

  @override
  State<IndividualAnalyticsScreen> createState() =>
      _IndividualAnalyticsScreenState();
}

class _IndividualAnalyticsScreenState extends State<IndividualAnalyticsScreen> {
  // Form state
  String shopName = 'ABC Plumbing';
  String shopLocation = 'Kochi';
  String shopArea = 'Aluva';

  bool purchaseAnalysis = true;
  bool bestSelling = true;
  bool salesReport = true;

  String compareFrom = '2023';
  String compareTo = '2024';

  int currentIndex = 1; // bottom nav selected (Analytics)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Individual Shop Analytics",
                  style: textTheme.bodyLarge,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomDropDownMenu(
                            width: constraints.maxWidth,
                            hintText: "Shop name",
                            title: "Select shop name",
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: 'ABC Plumbing',
                                label: 'ABC Plumbing',
                              ),
                              DropdownMenuEntry(
                                value: 'XYZ Hardware',
                                label: 'XYZ Hardware',
                              ),
                              DropdownMenuEntry(
                                value: 'LMN Electricals',
                                label: 'LMN Electricals',
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomDropDownMenu(
                                  hintText: "Location",
                                  title: "Select shop Location",
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                      value: 'ABC Plumbing',
                                      label: 'ABC Plumbing',
                                    ),
                                    DropdownMenuEntry(
                                      value: 'XYZ Hardware',
                                      label: 'XYZ Hardware',
                                    ),
                                    DropdownMenuEntry(
                                      value: 'LMN Electricals',
                                      label: 'LMN Electricals',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomDropDownMenu(
                                  hintText: "Area",
                                  title: "Select shop area",
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                      value: 'ABC Plumbing',
                                      label: 'ABC Plumbing',
                                    ),
                                    DropdownMenuEntry(
                                      value: 'XYZ Hardware',
                                      label: 'XYZ Hardware',
                                    ),
                                    DropdownMenuEntry(
                                      value: 'LMN Electricals',
                                      label: 'LMN Electricals',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildSwitchRow(
                          textTheme,
                          "Purchase Analysis",
                          purchaseAnalysis,
                          (value) {
                            setState(() {
                              purchaseAnalysis = value;
                            });
                          },
                        ),
                        _buildSwitchRow(
                          textTheme,
                          "Best Selling Product",
                          bestSelling,
                          (value) {
                            setState(() {
                              bestSelling = value;
                            });
                          },
                        ),
                        _buildSwitchRow(
                          textTheme,
                          "Sales Report",
                          salesReport,
                          (value) {
                            setState(() {
                              salesReport = value;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //TODO
                  },
                  child: Text("Find Analytics"),
                ),
              ),
              if (purchaseAnalysis) PurchaseAnalysis(),
              if (bestSelling)
                BestSellingProduct(
                  productList: [
                    ProductSaleMap("ELBOW SOCKET 90", 60, Color(0xff3977e6)),
                    ProductSaleMap("RAIN WATER CHAMBER", 30, Color(0xfff3a100)),
                    ProductSaleMap("RAIN WATER PIPES", 10, Color(0xff449f40)),
                  ],
                ),

              if (salesReport)
                SalesReport(
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
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSwitchRow(
    TextTheme textTheme,
    String title,
    bool value,
    void Function(bool value)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        children: [
          Text(title, style: textTheme.bodyLarge),
          Spacer(),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class PurchaseAnalysis extends StatelessWidget {
  const PurchaseAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Purchase Analysis", style: textTheme.bodyLarge),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildColorLabel(
                  textTheme,
                  colorScheme,
                  "Purchase",
                  colorScheme.secondary,
                ),
                _buildColorLabel(
                  textTheme,
                  colorScheme,
                  "Not Purchase",
                  colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        PurchaseAnalysisBarChart(
          monthlyData: [
            MonthlyMap("Jan", true),
            MonthlyMap("Feb", false),
            MonthlyMap("Mar", true),
            MonthlyMap("Apr", true),
            MonthlyMap("May", false),
            MonthlyMap("Jun", true),
            MonthlyMap("Jul", true),
            MonthlyMap("Aug", false),
            MonthlyMap("Sep", true),
            MonthlyMap("Oct", true),
            MonthlyMap("Nov", false),
            MonthlyMap("Dec", true),
          ],
        ),
      ],
    );
  }

  Row _buildColorLabel(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
    Color color,
  ) {
    return Row(
      children: [
        Text(
          title,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSecondary,
          ),
        ),
        Container(
          margin: EdgeInsets.all(4),
          width: 40,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
        ),
      ],
    );
  }
}

class MonthlyMap {
  final String monthLabel;
  final bool hasPurchased;
  const MonthlyMap(this.monthLabel, this.hasPurchased);
}

class PurchaseAnalysisBarChart extends StatelessWidget {
  final List<MonthlyMap> monthlyData;

  const PurchaseAnalysisBarChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AspectRatio(
      aspectRatio: 3.3,
      child: BarChart(
        BarChartData(
          minY: -8,
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(bottom: BorderSide(color: colorScheme.tertiary)),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 32),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 ||
                      value.toInt() >= monthlyData.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      monthlyData[value.toInt()].monthLabel,
                      style: textTheme.labelMedium,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: monthlyData
              .asMap()
              .map(
                (index, value) => MapEntry(
                  index,
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value.hasPurchased ? 100 : 90,
                        color: value.hasPurchased
                            ? colorScheme.secondary
                            : colorScheme.tertiary,
                        width: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              )
              .values
              .toList(),
        ),
      ),
    );
  }
}
