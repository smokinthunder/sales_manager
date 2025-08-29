import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/ui/core/theme.dart';
import 'package:sales_manager/ui/widgets/drop_down_menu.dart';

class CreateTargetScreen extends StatefulWidget {
  const CreateTargetScreen({super.key});

  @override
  State<CreateTargetScreen> createState() => _CreateTargetScreenState();
}

class _CreateTargetScreenState extends State<CreateTargetScreen> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final decoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colorScheme.tertiary),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Target"),
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Text("Set target point", style: textTheme.bodyLarge),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        spacing: 30,
                        children: [
                          Flexible(
                            child: CustomDropDownMenu(
                              tinyTitle: true,
                              hintText: 'Sidharth GK',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "Sidharth GK",
                                  label: "Sidharth GK",
                                ),
                              ],
                              title: "Select Executive",
                            ),
                          ),
                          Flexible(
                            child: CustomDropDownMenu(
                              tinyTitle: true,
                              hintText: 'Kalamassery',
                              dropdownMenuEntries: [
                                DropdownMenuEntry(
                                  value: "Kalamassery",
                                  label: "Kalamassery",
                                ),
                              ],
                              title: "Add Location",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 30,
                        children: [
                          Flexible(
                            child: CustomDropDownMenu(
                              tinyTitle: true,
                              hintText: 'June/2008',
                              dropdownMenuEntries: [],
                              title: "Select Month/Year",
                            ),
                          ),
                          Flexible(
                            child: CustomDropDownMenu(
                              tinyTitle: true,
                              hintText: 'Select category',
                              dropdownMenuEntries: [],
                              title: "Category",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Flexible(
                            child: CustomDropDownMenu(
                              tinyTitle: true,
                              hintText: 'Sidharth GK',
                              dropdownMenuEntries: [],
                              title: "Products",
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    "Enter Quantity",
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                                TextField(
                                  decoration: decoration.copyWith(
                                    hintText: "1000",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  child: Text(
                                    "Enter Amount",
                                    style: textTheme.bodySmall,
                                  ),
                                ),
                                TextField(
                                  decoration: decoration.copyWith(
                                    hintText: "1,00,000",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //TODO
                  },
                  child: Text("Create Target"),
                ),
              ),

              Text("Target list", style: textTheme.bodyLarge),

              Table(
                children: [
                  TableRow(
                    children: [
                      _buildTitle(theme, "Name"),
                      _buildTitle(theme, "Target"),
                      _buildTitle(theme, "Achieved"),
                      _buildTitle(theme, "Month"),
                      _buildTitle(theme, "Status"),
                    ],
                  ),
                  ...(isExpanded ? testTargetData : testTargetData.take(5)).map(
                    (data) => _buildTableRow(theme, data),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      isExpanded ? "View less" : "View more",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(ThemeData theme, TargetData data) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.tertiary, width: 1),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            data.name,
            style: textTheme.bodySmall,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            data.target.toString(),
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            data.achieved.toString(),
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            data.month.toString(),
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            data.target <= data.achieved ? "Done" : "Pending",

            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: data.target <= data.achieved
                  ? Color(0xff9cc449)
                  : Color(0xffd07213),
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.all(2.0).copyWith(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class TargetData {
  final String name;
  final int target;
  final int achieved;
  final String month;

  TargetData({
    required this.name,
    required this.target,
    required this.achieved,
    required this.month,
  });
}

final testTargetData = [
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(name: "Sidharth GK", target: 50000, achieved: 50000, month: "May"),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(name: "Sidharth GK", target: 50000, achieved: 70000, month: "May"),

  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(name: "Sidharth GK", target: 50000, achieved: 50000, month: "May"),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(name: "Sidharth GK", target: 50000, achieved: 70000, month: "May"),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(name: "Sidharth GK", target: 50000, achieved: 50000, month: "May"),
  TargetData(
    name: "Sidharth GK",
    target: 50000,
    achieved: 30000,
    month: "June",
  ),
  TargetData(name: "Sidharth GK", target: 50000, achieved: 70000, month: "May"),
];
