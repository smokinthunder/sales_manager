import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/widgets/bar_chart.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopAnalytics extends StatelessWidget {
  const ShopAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildSearchBar(theme),
              SizedBox(height: 32),
              _buildSortBy(context, theme),
              SizedBox(height: 32),
              _buildShopHeader(theme, context),
              SizedBox(height: 32),
              _buildBarGraphs(constraints),
              SizedBox(height: 32),
              Container(
                width: constraints.maxWidth,
                height: 1,
                color: theme.colorScheme.tertiary,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductAnalytics(theme, constraints),
                  CreditAnalytics(
                    creditPercentage: 70,
                    constraints: constraints,
                    data: [
                      const CreditAnalyticsData(
                        month: "Jan",
                        amount: 12000,
                        isComleted: true,
                      ),
                      const CreditAnalyticsData(
                        month: "Feb",
                        amount: 15000,
                        isComleted: false,
                      ),
                      const CreditAnalyticsData(
                        month: "Mar",
                        amount: 10000,
                        isComleted: true,
                      ),
                      const CreditAnalyticsData(
                        month: "Apr",
                        amount: 18000,
                        isComleted: true,
                      ),
                      const CreditAnalyticsData(
                        month: "May",
                        amount: 9000,
                        isComleted: false,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Container _buildProductAnalytics(
    ThemeData theme,
    BoxConstraints constraints,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: theme.colorScheme.tertiary)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OurPieChart(
            productList: [
              ProductSaleMap("productName", 60, Colors.blue),
              ProductSaleMap("productName", 30, Colors.amber),
              ProductSaleMap("productName", 10, Colors.green),
            ],
            width: constraints.maxWidth,
          ),
          Container(
            width: (constraints.maxWidth / 2) - 20,
            height: 1,
            color: theme.colorScheme.tertiary,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Point system analytics",
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildBarGraphs(BoxConstraints constraints) {
    return Row(
      spacing: 20,
      children: [
        AnalyticsBarCharts(
          constraints: constraints,
          data: [
            const BarChartDataMap(label: 'Mon', value: 30),
            const BarChartDataMap(label: 'Tue', value: 45),
            const BarChartDataMap(label: 'Wed', value: 28),
            const BarChartDataMap(label: 'Thu', value: 60),
            const BarChartDataMap(label: 'Fri', value: 50),
            const BarChartDataMap(label: 'Sat', value: 80),
            const BarChartDataMap(label: 'Sun', value: 40),
          ],
          high: 6000,
          low: 800,
          total: 8888888,
          lowMonth: "Jun",
          highMonth: "Oct",
          isPoints: true,
        ),
        AnalyticsBarCharts(
          constraints: constraints,
          data: [
            const BarChartDataMap(label: 'Mon', value: 30),
            const BarChartDataMap(label: 'Tue', value: 45),
            const BarChartDataMap(label: 'Wed', value: 28),
            const BarChartDataMap(label: 'Thu', value: 60),
            const BarChartDataMap(label: 'Fri', value: 50),
            const BarChartDataMap(label: 'Sat', value: 80),
            const BarChartDataMap(label: 'Sun', value: 40),
          ],
          total: 8888888,
          high: 6000,
          low: 800,
          lowMonth: "Jun",
          highMonth: "Oct",
        ),
      ],
    );
  }

  Row _buildSortBy(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            context.go(Routes.analytics);
          },
          child: Text(
            "All Shop Analytics Overview",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        Icon(Icons.chevron_right),
        Text("National Pipes"),
        Spacer(),
        Text("Sort by  ", style: theme.textTheme.labelLarge),
        SizedBox(
          width: 118,
          child: CustomDropDownMenu(
            hintText: "New",
            dropdownMenuEntries: [
              DropdownMenuEntry(value: "Old", label: "Old"),
              DropdownMenuEntry(value: "A-Z", label: "A-Z (Ascending)"),
              DropdownMenuEntry(value: "Month", label: "Z-A (Descending)"),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildSearchBar(ThemeData theme) {
    return Row(
      spacing: 20,
      children: [
        Flexible(
          child: TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: "Search by shop name",
            ),
          ),
        ),
        InkWell(
          onTap: () {
            //TODO:
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.onSurface),
            ),
            child: Text("Search", style: theme.textTheme.labelLarge),
          ),
        ),
      ],
    );
  }

  Container _buildShopHeader(ThemeData theme, BuildContext context) {
    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("National Pipes", style: theme.textTheme.headlineMedium),
              Text(
                "Kochi | Kalamassery",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () {
                  //TODO:
                  context.go(Routes.customerDetails);
                },
                child: Text(
                  "View more details",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.underline,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              openWhatsApp(
                //TODO:
                "91806613921",
                message: "Hi, we are from AquaStar",
              );
            },
            child: Row(
              children: [
                Image.asset("assets/images/whatsapp.png"),
                Text("+91 3459837592", style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openWhatsApp(String phoneNumber, {String? message}) async {
    final url = Uri.parse(
      "https://wa.me/$phoneNumber${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CreditAnalyticsData {
  final String month;
  final int amount;
  final bool isComleted;
  const CreditAnalyticsData({
    required this.month,
    required this.amount,
    required this.isComleted,
  });
}

class CreditAnalytics extends StatelessWidget {
  const CreditAnalytics({
    super.key,
    required this.constraints,
    required this.data,
    required this.creditPercentage,
  });

  final BoxConstraints constraints;
  final List<CreditAnalyticsData> data;
  final double creditPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ).copyWith(top: 16),
          child: Text("Credit analytics", style: theme.textTheme.bodyLarge),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ClipRRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.6,
                child: Container(
                  margin: EdgeInsets.only(left: 48),
                  width: constraints.maxWidth / 4,
                  child: GaugeWidget(value: creditPercentage),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "$creditPercentage%",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.tertiary.withAlpha(128),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: (constraints.maxWidth / 2) - 20,
          child: Table(
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Month"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Purchase amount", textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text("Status", textAlign: TextAlign.end),
                  ),
                ],
              ),
              ...data.map(
                (e) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(e.month, style: theme.textTheme.bodySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        e.amount.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        e.isComleted ? "Completed" : "Pending",
                        textAlign: TextAlign.end,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: e.isComleted ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnalyticsBarCharts extends StatelessWidget {
  const AnalyticsBarCharts({
    super.key,
    required this.constraints,
    required this.high,
    required this.low,
    required this.highMonth,
    required this.lowMonth,
    required this.data,
    this.isPoints = false,
    required this.total,
  });

  final BoxConstraints constraints;
  final int total;
  final int high;
  final int low;
  final String highMonth;
  final String lowMonth;
  final List<BarChartDataMap> data;
  final bool isPoints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isPoints ? "Point System analytics" : "Sales analytics",
          style: theme.textTheme.bodyLarge,
        ),
        SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          width: (constraints.maxWidth / 2) - 10,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.tertiary.withAlpha(128),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: OurBarChart(dataMap: data),
        ),
        SizedBox(height: 12),
        _buildValueRow(
          "Total ${isPoints ? "Points" : "Sale"}",
          total.toString(),
        ),
        _buildValueRow(
          "Highest ${isPoints ? "Points" : "Sale"}",
          high.toString(),
        ),
        _buildValueRow(
          "Lowest ${isPoints ? "Points" : "Sale"}",
          low.toString(),
        ),
        _buildValueRow("Max ${isPoints ? "Points" : "Sale"} Month", highMonth),
        _buildValueRow("Min ${isPoints ? "Points" : "Sale"} Month", lowMonth),
      ],
    );
  }

  Container _buildValueRow(String title, String value) {
    return Container(
      width: (constraints.maxWidth / 2) - 10,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      child: Row(children: [Text(title), Spacer(), Text(value)]),
    );
  }
}

class GaugeWidget extends StatelessWidget {
  const GaugeWidget({super.key, required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SfRadialGauge(
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          startAngle: 180,
          endAngle: 0,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.3,
            cornerStyle: CornerStyle.bothCurve,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 33,
              color: Colors.red,
              startWidth: 50,
              endWidth: 50,
            ),
            GaugeRange(
              startValue: 33,
              endValue: 66,
              color: Colors.yellow,
              startWidth: 50,
              endWidth: 50,
            ),
            GaugeRange(
              startValue: 66,
              endValue: 100,
              color: Colors.green,
              startWidth: 50,
              endWidth: 50,
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: value, // Adjust needle value
              needleLength: 0.7,
              enableAnimation: true,
            ),
          ],
          annotations: <GaugeAnnotation>[
            // Label at left (Average)
            GaugeAnnotation(
              widget: Text('Below Average', style: theme.textTheme.bodySmall),
              angle: 175,
              positionFactor: 1,
            ),
            // Label at top (Below Average)
            GaugeAnnotation(
              widget: Text('Average', style: theme.textTheme.bodySmall),
              angle: 270,
              positionFactor: 1.1,
            ),
            // Label at right (Good)
            GaugeAnnotation(
              widget: Text('Good', style: theme.textTheme.bodySmall),
              angle: 5,
              positionFactor: 1,
            ),
          ],
        ),
      ],
    );
  }
}
