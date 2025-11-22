import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OurBarChart extends StatelessWidget {
  final List<BarChartDataMap> dataMap;

  const OurBarChart({super.key, required this.dataMap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: colorScheme.tertiary),
              left: BorderSide(color: colorScheme.tertiary),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                // interval: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= dataMap.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      dataMap[value.toInt()].label,
                      style: textTheme.labelMedium,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: dataMap
              .asMap()
              .map(
                (index, item) => MapEntry(
                  index,
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: item.value,
                        color: colorScheme.secondary,
                        width: 12,
                        borderRadius: BorderRadius.circular(0),
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

class BarChartDataMap {
  final double value;
  final String label;
  const BarChartDataMap({required this.label, required this.value});
}
