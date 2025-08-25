import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';
import 'package:sales_manager/ui/executive/top_customers.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  String? selectedValue;

  final List<String> options = ["Option 1", "Option 2", "Option 3"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text("Shop Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Shop Card
            ShopCard(shop: testShops[0], isDisplay: true),
            const SizedBox(height: 16),

            /// Sort Dropdown
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: colorScheme.tertiary),
                ),
                child: DropdownButton<String>(
                  isDense: true,
                  underline: SizedBox.shrink(),
                  value: selectedValue,
                  hint: Text(
                    "Sort by",
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.tertiary,
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      CupertinoIcons.chevron_down,
                      size: 18,
                      color: colorScheme.tertiary,
                    ),
                  ),
                  items: options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                      //TODO
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Purchase History
            Text("Purchase History", style: textTheme.bodyLarge),
            const SizedBox(height: 20),

            HistroyTable(),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Download List", style: textTheme.bodySmall),
                    SizedBox(width: 6),
                    Icon(Icons.file_download_outlined, size: 24),
                  ],
                ),
                Text(
                  "See more",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            /// Sales Analysis
            Text("Sales Analysis", style: theme.textTheme.bodyLarge),
            const SizedBox(height: 18),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                border: Border.all(width: 1, color: colorScheme.tertiary),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ConsolidatedValueRow(
                    title: "Total sales :",
                    value: "20,14,548",
                  ),
                  ConsolidatedValueRow(
                    title: "Pending Amounts :",
                    value: "5,47,239",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            OutStandingTable(),

            const SizedBox(height: 40),

            /// Add shop location
            Text("Add shop location", style: theme.textTheme.bodyLarge),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                border: Border.all(color: colorScheme.tertiary, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text("Last visit", style: textTheme.bodyLarge),
                  Spacer(),
                  Text("21-10-2025 | 10:45PM", style: textTheme.labelLarge),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Upload photo & location',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Upload timestamped photos displaying both the date and time',
                style: textTheme.bodySmall,
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.tertiary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text("Add location", style: textTheme.bodyMedium),
                  Spacer(),
                  Icon(Icons.my_location_outlined, color: colorScheme.tertiary),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.tertiary, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text("Add photo", style: textTheme.bodyMedium),
                  Spacer(),
                  Icon(Icons.camera_alt_outlined, color: colorScheme.tertiary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Reason for not placing order
            Text(
              "Reason for not placing order",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                fillColor: colorScheme.onPrimary,
                hintText:
                    "Please provide the reason why this store does not sell the product.",
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //TODO: implement
                },
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutStandingTable extends StatelessWidget {
  const OutStandingTable({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rows = [
      ["17-04-2025", "37200.00", "10 days"],
      ["16-04-2025", "46200.00", "09 days"],
      ["15-04-2025", "15200.00", "08 days"],
      ["14-04-2025", "24200.00", "09 days"],
    ];
    return Table(
      border: TableBorder(
        verticalInside: BorderSide(color: colorScheme.tertiary, width: 1.5),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colorScheme.tertiary, width: 1.5),
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Date",
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSecondary,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Amount",
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Due date",
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                ),
              ),
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
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSecondary,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    r[1],
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    r[2],
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class ConsolidatedValueRow extends StatelessWidget {
  const ConsolidatedValueRow({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textTheme.bodyLarge),
          Text(
            value,
            style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}

class HistroyTable extends StatelessWidget {
  const HistroyTable({super.key});

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
    ];
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(8),
      child: Table(
        border: TableBorder(
          top: BorderSide(color: colorScheme.tertiary, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        // border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              border: BoxBorder.all(color: colorScheme.tertiary, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Date", style: textTheme.bodyLarge),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Product", style: textTheme.bodyLarge),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Amount", style: textTheme.bodyLarge),
                ),
              ),
            ],
          ),
          for (var r in rows)
            TableRow(
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                border: (r != rows[0])
                    ? Border(top: BorderSide(color: colorScheme.onSurface))
                    : null,
              ),
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      r[0],
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      r[1],
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      r[2],
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
