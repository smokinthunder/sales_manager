import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key, required this.isSpecial});
  final bool isSpecial;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isSpecial ? "Special Route Screen" : "Route Screen"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Text("Search", style: textTheme.bodyLarge),
              Row(
                spacing: 12,
                children: [
                  Flexible(
                    flex: 5,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search name date (dd/mm/yyyy)",
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
                ],
              ),
              Text("Today route", style: textTheme.bodySmall),
              ShopListCard(isTodays: true),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Previous route list",
                      style: textTheme.bodySmall,
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              ShopListCard(isTodays: false),
            ],
          ),
        ),
      ),
    );
  }
}

class ShopListCard extends StatefulWidget {
  const ShopListCard({super.key, required this.isTodays});
  final bool isTodays;

  @override
  State<ShopListCard> createState() => _ShopListCardState();
}

class _ShopListCardState extends State<ShopListCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Column(
      spacing: 8,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.isTodays
                ? theme.colorScheme.primary.withAlpha(50)
                : null,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View Shops List",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("12-15-2024", style: textTheme.labelMedium),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ),
            ],
          ),
        ),
        if (isExpanded)
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: widget.isTodays
                  ? theme.colorScheme.primary.withAlpha(50)
                  : null,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Table(
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                      child: Text("Shop name"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                      child: Text("Location"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0).copyWith(left: 0),
                      child: Text("Area"),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Shop name", style: textTheme.bodySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Location", style: textTheme.bodySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("Area", style: textTheme.bodySmall),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Shop name", style: textTheme.bodySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Location", style: textTheme.bodySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Area", style: textTheme.bodySmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
