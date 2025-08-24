import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopDetailScreen extends StatelessWidget {
  const ShopDetailScreen({super.key});

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
            Card(
              color: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green.shade900,
                  child: const Text(
                    "M",
                    style: TextStyle(fontSize: 28, color: Colors.amber),
                  ),
                ),
                title: Text("M K Enterprises", style: textTheme.bodyLarge),
                subtitle: Text(
                  "Ernakulam\n+91 8432514901",
                  style: textTheme.bodySmall,
                ),
                trailing: Text(
                  "2400",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Sort Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.sort),
                  label: const Text("Sort by"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Purchase History
            Text("Purchase History", style: textTheme.bodyLarge),
            const SizedBox(height: 8),

            HistroyTable(),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.download, size: 18),
                    SizedBox(width: 6),
                    Text("Download List"),
                  ],
                ),
                Text("See more", style: TextStyle(color: Colors.blue)),
              ],
            ),

            const SizedBox(height: 20),

            /// Sales Analysis
            Text("Sales Analysis", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildKeyValue("Total sales :", "20,14,548"),
                    _buildKeyValue("Pending Amounts :", "5,47,239"),
                    const Divider(),
                    _buildOutstandingTable(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Add shop location
            Text("Add shop location", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: "21-10-2025 | 10:45PM",
              decoration: const InputDecoration(
                labelText: "Last visit",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_on_outlined),
              label: const Text("Add location"),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text("Add photo"),
            ),

            const SizedBox(height: 20),

            /// Reason for not placing order
            Text(
              "Reason for not placing order",
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText:
                    "Please provide the reason why this store does not sell the product.",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Send"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOutstandingTable() {
    final rows = [
      ["17-04-2025", "37200.00", "10 days"],
      ["16-04-2025", "46200.00", "09 days"],
      ["15-04-2025", "15200.00", "08 days"],
      ["14-04-2025", "24200.00", "09 days"],
    ];
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Due date",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        for (var r in rows)
          TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8), child: Text(r[0])),
              Padding(padding: const EdgeInsets.all(8), child: Text(r[1])),
              Padding(padding: const EdgeInsets.all(8), child: Text(r[2])),
            ],
          ),
      ],
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
    return Card(
      child: Table(
        border: TableBorder(
          top: BorderSide(color: colorScheme.tertiary, width: 1),
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
              color: Color(0xFFF5F5F5),
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
              decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
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
