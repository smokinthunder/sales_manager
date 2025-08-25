import 'package:flutter/material.dart';

enum AnalyticsType {
  allShops("All Shops"),
  individualShops("Individual shops");

  final String displayText;
  const AnalyticsType(this.displayText);
}

class ExecutiveAnalytics extends StatefulWidget {
  const ExecutiveAnalytics({super.key});

  @override
  State<ExecutiveAnalytics> createState() => _ExecutiveAnalyticsState();
}

class _ExecutiveAnalyticsState extends State<ExecutiveAnalytics> {
  AnalyticsType? selectedType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            "Select your type for analysis",
            style: textTheme.bodyLarge,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.tertiary, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text("All Shops", style: textTheme.bodyMedium),
              Spacer(),
              Radio(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: AnalyticsType.allShops,
                groupValue: selectedType,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.tertiary, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text("Individual Shops", style: textTheme.bodyMedium),
              Spacer(),
              Radio(
                value: AnalyticsType.individualShops,
                groupValue: selectedType,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
            ],
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (selectedType == null)
                ? null
                : () {
                    //TODO: complete
                  },
            child: const Text("Continue"),
          ),
        ),
      ],
    );
  }
}
