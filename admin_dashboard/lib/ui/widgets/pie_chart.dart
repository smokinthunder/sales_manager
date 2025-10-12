import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductSaleMap {
  final String productName;
  final double salePercentage;
  final Color displayColor;
  const ProductSaleMap(
    this.productName,
    this.salePercentage,
    this.displayColor,
  );
}

class OurPieChart extends StatelessWidget {
  const OurPieChart({
    super.key,
    required this.productList,
    required this.width,
  });
  final List<ProductSaleMap> productList;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Point system analytics", style: textTheme.bodyLarge),
        ),
        Row(
          children: [
            SizedBox(
              width: width * 0.3,
              height: width * 0.3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 0,
                  sections: productList.map((e) {
                    return PieChartSectionData(
                      value: e.salePercentage,
                      title: "${e.salePercentage}%",
                      titleStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                      borderSide: BorderSide(color: colorScheme.onPrimary),
                      color: e.displayColor,
                      radius: width * 0.12,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: productList.map((e) {
                return Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(6),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: e.displayColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(e.productName),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
