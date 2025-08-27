import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/routing/route_paths.dart';

enum AnalyticsType {
  allShops("All Shops"),
  individualShops("Individual shops");

  final String displayText;
  const AnalyticsType(this.displayText);
}

class ExecutiveAnalytics extends ConsumerStatefulWidget {
  const ExecutiveAnalytics({super.key});

  @override
  ConsumerState<ExecutiveAnalytics> createState() => _ExecutiveAnalyticsState();
}

class _ExecutiveAnalyticsState extends ConsumerState<ExecutiveAnalytics> {
  AnalyticsType? selectedType;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select your type for analysis", style: textTheme.bodyLarge),
          SizedBox(height: 12),
          _buildButtonTile(
            textTheme,
            (user!.type == UserType.areaManager) ? "Executive" : "All Shops",
            AnalyticsType.allShops,
          ),
          _buildButtonTile(
            textTheme,
            (user.type == UserType.areaManager)
                ? "All Shops"
                : "Individual Shops",
            AnalyticsType.individualShops,
          ),
          Spacer(),
          _buildContinueButton(context),
        ],
      ),
    );
  }

  SizedBox _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (selectedType == null)
            ? null
            : () {
                switch (selectedType) {
                  case AnalyticsType.allShops:
                    context.push(RoutePaths.consolidatedOrExecutiveAnalytics);
                    break;
                  case AnalyticsType.individualShops:
                    context.push(RoutePaths.shopAnalytics);
                    break;
                  case null:
                }
              },
        child: const Text("Continue"),
      ),
    );
  }

  InkWell _buildButtonTile(
    TextTheme textTheme,
    String title,
    AnalyticsType type,
  ) {
    onChanged() {
      setState(() {
        selectedType = type;
      });
    }

    return InkWell(
      onTap: onChanged,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(title, style: textTheme.bodyMedium),
              Spacer(),
              Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: type,
                groupValue: selectedType,
                onChanged: (value) {
                  onChanged();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
