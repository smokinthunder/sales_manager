import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sales_manager/ui/common/widgets/drop_down_menu.dart';

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
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Individual Shop Analytics", style: textTheme.bodyLarge),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomDropDownMenu(
                            width: constraints.maxWidth,
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
                        _buildSwitchRow(
                          textTheme,
                          "Purchase Analysis",
                          purchaseAnalysis,
                          (value) {
                            setState(() {
                              purchaseAnalysis = value;
                            });
                          },
                        ),
                        _buildSwitchRow(
                          textTheme,
                          "Best Selling Product",
                          bestSelling,
                          (value) {
                            setState(() {
                              bestSelling = value;
                            });
                          },
                        ),
                        _buildSwitchRow(
                          textTheme,
                          "Sales Report",
                          salesReport,
                          (value) {
                            setState(() {
                              salesReport = value;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
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
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildSwitchRow(
    TextTheme textTheme,
    String title,
    bool value,
    void Function(bool value)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        children: [
          Text(title, style: textTheme.bodyLarge),
          Spacer(),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
