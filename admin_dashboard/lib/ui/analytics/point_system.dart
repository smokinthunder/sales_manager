import 'dart:async';

import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PointSystem extends StatelessWidget {
  const PointSystem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 16,
        children: [
          _buildTitleCards(theme),
          Divider(color: theme.colorScheme.tertiary.withAlpha(128)),
          _buildNavigation(context, theme),
          AddPointsWidget(
            top5Customers: {
              "AliceAliceAlice": 120,
              "BobAlice": 110,
              "CharlieAlice": 105,
              "DavidAlice": 100,
              "EveAlice": 95,
            },
          ),
        ],
      ),
    );
  }

  Row _buildNavigation(BuildContext context, ThemeData theme) {
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
        Text("Point Sysetm"),
      ],
    );
  }

  Row _buildTitleCards(ThemeData theme) {
    return Row(
      spacing: 16,
      children: [
        _buildPointContainer(theme, "Active Point", 100),
        _buildPointContainer(theme, "Purchase Amount", 1000),
      ],
    );
  }

  Container _buildPointContainer(ThemeData theme, String title, int value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.tertiary),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.secondary,
            ),
          ),
          Text(title, style: theme.textTheme.labelLarge),
          Text(value.toString()),
        ],
      ),
    );
  }
}

class AddPointsWidget extends StatelessWidget {
  const AddPointsWidget({super.key, required this.top5Customers});
  final Map<String, int> top5Customers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 620,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.tertiary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add points", style: theme.textTheme.bodyLarge),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "You can add points based on customer purchases (e.g., ₹100 = 1 Point)",
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.tertiary),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              spacing: 32,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Purchase Amount", style: theme.textTheme.bodySmall),
                    SizedBox(width: 150, child: TextField()),
                  ],
                ),
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Point", style: theme.textTheme.bodySmall),
                    SizedBox(width: 100, child: TextField()),
                  ],
                ),
                BlueBorderButtons(
                  title: "         Save         ",
                  onClick: () {
                    showSuccessDialog(context);
                    //TODO: I'm not sure how you guys want to implement this, so I kept it as such.
                  },
                  invert: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.tertiary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top 5 Customers by Points",
                  style: theme.textTheme.bodyLarge,
                ),
                ...top5Customers.entries.map((entry) {
                  return Row(
                    children: [
                      Text(entry.key),
                      Spacer(),
                      Text(
                        entry.value.toString(),
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(dialogContext).colorScheme.secondary,
                  size: 48,
                ),
                Text(
                  "  Your point has been successfully updated",
                  style: Theme.of(dialogContext).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }
}
