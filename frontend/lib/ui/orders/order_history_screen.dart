import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/ui/widgets/drop_down_menu.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(top: 32),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Search", style: textTheme.bodyLarge),
              Row(
                spacing: 12,
                children: [
                  Flexible(
                    flex: 5,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search name or b.no",
                        hintStyle: textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.tertiary.withAlpha(50),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        suffixIcon: Icon(
                          size: 32,
                          Icons.search,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: CustomDropDownMenu(
                      hintText: "Sort by",
                      dropdownMenuEntries: [],
                    ),
                  ),
                ],
              ),

              Text("All invoice List", style: textTheme.bodyLarge),
              ExpandableInvoiceCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableInvoiceCard extends StatelessWidget {
  const ExpandableInvoiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Valamkottil Agencies"),
                    Text("\$1500"),
                  ],
                ),
                Text("025"),
              ],
            ),
          ),
          ExpansionTile(
            shape: RoundedRectangleBorder(),
            title: Text("20-09-2025", style: textTheme.bodySmall),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(children: const [Text("Purchase items")]),
                    const SizedBox(height: 10),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.tertiary,
                                width: 1,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Item name"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Price"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Quantity"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Total"),
                            ),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.tertiary,
                                width: 1,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Item 1",
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("2", style: textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("\$500", style: textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("\$500", style: textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Grand Total: \$1500",
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
