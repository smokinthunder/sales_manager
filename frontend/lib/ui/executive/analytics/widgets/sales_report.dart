import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sales_manager/ui/core/colors.dart';

class SalesReport extends StatelessWidget {
  const SalesReport({super.key, required this.salesData});
  final List<SalesReportDataMap> salesData;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Sales Report", style: textTheme.bodyLarge),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: SimpleLineChart(salesData: salesData),
        ),
      ],
    );
  }
}

class SalesReportDataMap {
  final String threeLetterMonthString;
  final double saleAmount;
  const SalesReportDataMap(this.threeLetterMonthString, this.saleAmount);
}

class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({super.key, required this.salesData});
  final List<SalesReportDataMap> salesData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: colorScheme.tertiary, width: 1),
            bottom: BorderSide(color: colorScheme.tertiary, width: 1),
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final months =
                    ['   '] +
                    salesData.map((e) => e.threeLetterMonthString).toList();
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      months[value.toInt()],
                      style: textTheme.labelSmall,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              // interval: 50,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}', style: textTheme.labelSmall);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: salesData
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble() + 1, e.value.saleAmount))
                .toList(),
            isCurved: false,
            isStrokeCapRound: true,
            gradient: AppColors.greenBlueGradient,
            barWidth: 1,
            dotData: FlDotData(
              show: true,
              // getDotPainter: (spot, percent, barData, index) {
              //   if (index == barData.spots.length - 1) {
              //     return FlDotCirclePainter(
              //       radius: 2.5,
              //       color: colorScheme.primary,
              //     );
              //   }
              //   return FlDotCirclePainter(radius: 0); // empty painter (no dot)
              // },
            ),
          ),
        ],
        minX: 0,
        maxX: 12, // only showing Jan - Jun
        minY: 0,
      ),
    );
  }
}
