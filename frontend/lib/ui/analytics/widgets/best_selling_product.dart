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

class BestSellingProduct extends StatelessWidget {
  const BestSellingProduct({super.key, required this.productList});
  final List<ProductSaleMap> productList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text("Best Selling Products", style: textTheme.bodyLarge),
        ),
        Column(
          children: [
            SizedBox(
              width: width * 0.4,
              height: width * 0.4,
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
                      radius: width * 0.2,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 20),
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
