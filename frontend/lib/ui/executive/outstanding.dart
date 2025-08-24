import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExecutiveOutStanding extends StatefulWidget {
  const ExecutiveOutStanding({super.key});

  @override
  State<ExecutiveOutStanding> createState() => _ExecutiveOutStandingState();
}

class _ExecutiveOutStandingState extends State<ExecutiveOutStanding> {
  String? selectedValue;

  final List<String> options = ["1 Month", "2 Month", "3 Month", "1 Year"];
  CreditType selectedType = CreditType.outstanding;

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("Select Shop", style: textTheme.bodyLarge),
          SizedBox(height: 8),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colorScheme.tertiary),
                    ),
                    hint: Text(
                      'Search here',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.tertiary,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.search_rounded,
                      color: colorScheme.tertiary,
                    ),
                  ),
                ),
              ),

              DropdownMenu<String>(
                hintText: "Sort by",
                textStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.tertiary,
                ),
                selectedTrailingIcon: Icon(
                  CupertinoIcons.chevron_up,
                  size: 24,
                  color: colorScheme.tertiary,
                ),
                trailingIcon: Icon(
                  CupertinoIcons.chevron_down,
                  size: 24,
                  color: colorScheme.tertiary,
                ),
                menuStyle: MenuStyle(
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  backgroundColor: WidgetStatePropertyAll(
                    colorScheme.onPrimary,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: colorScheme.tertiary, width: 1),
                    ),
                  ),
                  visualDensity: VisualDensity.compact,
                  alignment: AlignmentDirectional.bottomStart.add(
                    const AlignmentDirectional(0, 0.2),
                  ),
                ),
                dropdownMenuEntries: options
                    .map(
                      (value) =>
                          DropdownMenuEntry<String>(value: value, label: value),
                    )
                    .toList(),
                onSelected: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    // TODO
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          Text("Credit list", style: textTheme.bodyLarge),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: BoxBorder.all(color: selectedType.color),
              color: selectedType.color.withAlpha(26),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: CreditType.values.map((e) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedType = e;
                      _controller.animateToPage(
                        e.index,
                        duration: Duration(milliseconds: 200),
                        curve: TreeSliver.defaultAnimationCurve,
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: (selectedType == e)
                            ? e.color
                            : e.color.withAlpha(72),
                        border: Border.all(
                          width: 1,
                          color: colorScheme.onPrimary,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e.placeholder,
                        style: textTheme.bodySmall?.copyWith(
                          color: e == selectedType
                              ? colorScheme.onPrimary
                              : colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  selectedType = CreditType.values[value];
                });
              },
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: CreditType.values.length,
              itemBuilder: (context, index) {
                return OutstandingTable(color: CreditType.values[index].color);
              },
            ),
          ),
          Center(child: Icon(Icons.more_horiz, size: 32)),
        ],
      ),
    );
  }
}

enum CreditType {
  outstanding(Color(0xff1ea123), "Current Outstanding"),
  upcoming(Color(0xffff9d00), "Upcoming Due"),
  overdue(Color(0xffbe2121), "Overdue");

  final Color color;
  final String placeholder;
  const CreditType(this.color, this.placeholder);
}

class OutstandingTable extends StatelessWidget {
  final Color color;
  const OutstandingTable({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final rows = [
      ["21-06-2025", "Aqua Star (160MM) Joint", "14990"],
      ["21-06-2025", "Aqua Star Delta - Runner Drop", "17990"],
      ["21-06-2025", "Aqua Star Delta (160MM) Elbow Plain", "42899"],
      ["21-06-2025", "Aqua Star (160MM) Stop End", "21230"],
      ["21-06-2025", "Aqua Star 45 Elbow", "216789"],
      ["21-06-2025", "Aqua Star (160MM) Joint", "14990"],
      ["21-06-2025", "Aqua Star Delta - Runner Drop", "17990"],
      ["21-06-2025", "Aqua Star Delta (160MM) Elbow Plain", "42899"],
      ["21-06-2025", "Aqua Star (160MM) Stop End", "21230"],
      ["21-06-2025", "Aqua Star 45 Elbow", "216789"],
      ["21-06-2025", "Aqua Star (160MM) Joint", "14990"],
      ["21-06-2025", "Aqua Star Delta - Runner Drop", "17990"],
      ["21-06-2025", "Aqua Star Delta (160MM) Elbow Plain", "42899"],
      ["21-06-2025", "Aqua Star (160MM) Stop End", "21230"],
      ["21-06-2025", "Aqua Star 45 Elbow", "216789"],
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: BoxBorder.all(color: color),
        color: color.withAlpha(26),
      ),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Due date", style: textTheme.bodyLarge),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Shop", style: textTheme.bodyLarge),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Amount", style: textTheme.bodyLarge),
                ),
              ],
            ),
            for (var r in rows)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      r[0],
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      r[1],
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      r[2],
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
