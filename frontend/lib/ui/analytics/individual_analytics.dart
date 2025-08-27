import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/ui/common/widgets/drop_down_menu.dart';
import 'package:sales_manager/ui/core/theme.dart';
import 'package:sales_manager/ui/analytics/widgets/best_selling_product.dart';
import 'package:sales_manager/ui/analytics/widgets/sales_report.dart';
import 'package:sales_manager/ui/analytics/widgets/switch_row.dart';

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
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
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
              Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomDropDownMenu(
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
                    SwitchRow(
                      title: "Purchase Analysis",
                      value: purchaseAnalysis,
                      onChanged: (value) {
                        setState(() {
                          purchaseAnalysis = value;
                        });
                      },
                    ),
                    SwitchRow(
                      title: "Best Selling Product",
                      value: bestSelling,
                      onChanged: (value) {
                        setState(() {
                          bestSelling = value;
                        });
                      },
                    ),
                    SwitchRow(
                      title: "Sales Report",
                      value: salesReport,
                      onChanged: (value) {
                        setState(() {
                          salesReport = value;
                        });
                      },
                    ),
                  ],
                ),
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
              if (purchaseAnalysis)
                PurchaseAnalysis(
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
              ComparingAnalytics(),
            ],
          ),
        ),
      ),
    );
  }
}

class PurchaseAnalysis extends StatelessWidget {
  const PurchaseAnalysis({super.key, required this.monthlyData});

  final List<MonthlyMap> monthlyData;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(height: 10),
        TitleWithColorLabel(
          title: "Purchase Analysis",
          color1Title: "Purchase",
          color1: colorScheme.secondary,
          color2Title: "Not Purchase",
          color2: colorScheme.tertiary,
        ),
        SizedBox(height: 20),
        PurchaseAnalysisBarChart(monthlyData: monthlyData),
      ],
    );
  }
}

class TitleWithColorLabel extends StatelessWidget {
  const TitleWithColorLabel({
    super.key,
    required this.title,
    required this.color1Title,
    required this.color1,
    required this.color2Title,
    required this.color2,
  });

  final String color1Title;
  final Color color1;
  final String color2Title;
  final Color color2;

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textTheme.bodyLarge),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildColorLabel(textTheme, colorScheme, color1Title, color1),
            _buildColorLabel(textTheme, colorScheme, color2Title, color2),
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

class ComparingAnalytics extends StatefulWidget {
  const ComparingAnalytics({super.key});

  @override
  State<ComparingAnalytics> createState() => _ComparingAnalyticsState();
}

class _ComparingAnalyticsState extends State<ComparingAnalytics> {
  final List<int> years = List<int>.generate(
    DateTime.now().year - 1980 + 1,
    (index) => 1980 + index,
  );

  int? yearOne;
  int? yearTwo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text("Comparing Analytics", style: textTheme.bodyLarge),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select year to compare", style: textTheme.labelLarge),
                SizedBox(height: 10),
                Row(
                  children: [
                    CustomDropDownMenu(
                      hintText: "0000",
                      dropdownMenuEntries: years
                          .map(
                            (e) => DropdownMenuEntry(
                              value: e,
                              label: e.toString(),
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        setState(() {
                          yearOne = value;
                        });
                      },
                    ),
                    Spacer(),
                    Text("to", style: textTheme.bodySmall),
                    Spacer(),
                    CustomDropDownMenu(
                      hintText: "0000",
                      dropdownMenuEntries: years
                          .map(
                            (e) => DropdownMenuEntry(
                              value: e,
                              label: e.toString(),
                            ),
                          )
                          .toList(),
                      onSelected: (value) {
                        setState(() {
                          yearTwo = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              //TODO:
            },
            child: Text("Compare"),
          ),
        ),
        Text(
          "Montly Purchase Value",
          style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
        ),
        Row(
          children: [
            _buildYearCard(textTheme, yearOne ?? 0, 10, 1),
            _buildYearCard(textTheme, yearTwo ?? 0, 10, 1),
          ],
        ),
        ExpansionTile(
          title: Row(
            children: [
              Spacer(),
              Text(
                "More details",
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          iconColor: colorScheme.primary,
          collapsedIconColor: colorScheme.primary,
          shape: RoundedRectangleBorder(),
          children: [
            TitleWithColorLabel(
              title: "Purchase Analysis",
              color1Title: "Purchase",
              color1: colorScheme.secondary,
              color2Title: "Not Purchase",
              color2: colorScheme.tertiary,
            ),
            _buildMontlyPurchaseGrid(
              yearOne,
              yearTwo,
              List.generate(
                12,
                (index) => MonthlyMap(
                  [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec",
                  ][index],
                  index % 2 == 0,
                ),
              ),
              // Dummy data for year2
              List.generate(
                12,
                (index) => MonthlyMap(
                  [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec",
                  ][index],
                  index % 3 == 0,
                ),
              ),
              colorScheme.tertiary,
              colorScheme.secondary,
              colorScheme.tertiary,
              textTheme,
            ),
          ],
        ),
        BestSellingProductGrid(
          productList1: ["ELBOW SOCKET", "ELBOW SOCKET", "ELBOW SOCKET"],
          productList2: [
            "RAIN WATER CHAMBER",
            "RAIN WATER CHAMBER",
            "RAIN WATER CHAMBER",
          ],
          year1: yearOne,
          year2: yearTwo,
        ),
        TitleWithColorLabel(
          title: "Sales Report",
          color1Title: yearOne.toString(),
          color1: colorScheme.secondary,
          color2Title: yearTwo.toString(),
          color2: colorScheme.primary,
        ),
        SizedBox(height: 20),
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
          salesData2: [
            SalesReportDataMap('Jan', 10),
            SalesReportDataMap('Feb', 7.5),
            SalesReportDataMap('Mar', 5),
            SalesReportDataMap('Apr', 8),
            SalesReportDataMap('May', 15),
            SalesReportDataMap('Jun', 5),
            SalesReportDataMap('Jul', 8),
            SalesReportDataMap('Aug', 4),
            SalesReportDataMap('Sep', 5),
            SalesReportDataMap('Oct', 6),
            SalesReportDataMap('Nov', 4),
            SalesReportDataMap('Dec', 10),
          ],
        ),
        TextButton(
          onPressed: () {
            //TODO
          },
          child: Row(
            children: [
              Text('Download Report '),
              Icon(Icons.file_download_outlined),
            ],
          ),
        ),
      ],
    );
  }

  IntrinsicHeight _buildMontlyPurchaseGrid(
    int? year1,
    int? year2,
    List<MonthlyMap> year1Data,
    List<MonthlyMap> year2Data,
    Color dividerColor,
    Color purchasedColor,
    Color notPurchasedColor,
    TextTheme textTheme,
  ) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(year1.toString(), style: textTheme.bodyLarge),
            ),
            ...year1Data.map(
              (e) => Row(
                children: [
                  Text(e.monthLabel, style: textTheme.labelLarge),
                  Container(
                    margin: EdgeInsets.all(6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: e.hasPurchased
                          ? purchasedColor
                          : notPurchasedColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 16, 8),
          child: VerticalDivider(thickness: 2, color: dividerColor),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(year1.toString(), style: textTheme.bodyLarge),
            ),
            ...year1Data.map(
              (e) => Row(
                children: [
                  Text(e.monthLabel, style: textTheme.labelLarge),
                  Container(
                    margin: EdgeInsets.all(6),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: e.hasPurchased
                          ? purchasedColor
                          : notPurchasedColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    ),
  );

  Card _buildYearCard(
    TextTheme textTheme,
    int year,
    int purchasedMonthCount,
    int notPurchasedMonthCount,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(year.toString(), style: textTheme.bodyLarge),
            Text(
              "Purchase: $purchasedMonthCount Month",
              style: textTheme.labelLarge,
            ),
            Text(
              "Not Purchase: $notPurchasedMonthCount Month",
              style: textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class BestSellingProductGrid extends StatelessWidget {
  const BestSellingProductGrid({
    super.key,
    required this.productList1,
    required this.productList2,
    required this.year1,
    required this.year2,
  });

  final List<String> productList1;
  final List<String> productList2;
  final int? year1;
  final int? year2;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final rowCount = productList1.length > productList2.length
        ? productList1.length
        : productList2.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Best Selling Product",
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        Table(
          children:
              [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(year1.toString(), style: textTheme.bodyLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(year2.toString(), style: textTheme.bodyLarge),
                    ),
                  ],
                ),
              ] +
              List.generate(rowCount, (index) {
                final product1 = index < productList1.length
                    ? productList1[index]
                    : '';
                final product2 = index < productList2.length
                    ? productList2[index]
                    : '';

                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(product1, style: textTheme.labelLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(product2, style: textTheme.labelLarge),
                    ),
                  ],
                );
              }),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
