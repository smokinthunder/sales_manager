import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Outstanding extends StatefulWidget {
  const Outstanding({super.key});

  @override
  State<Outstanding> createState() => _OutstandingState();
}

class _OutstandingState extends State<Outstanding> {
  OutstandingStatus status = OutstandingStatus.current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by shop name",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Outstanding', style: theme.textTheme.headlineMedium),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "New",
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "Old", label: "Old"),
                    DropdownMenuEntry(value: "A-Z", label: "A-Z (Ascending)"),
                    DropdownMenuEntry(
                      value: "Month",
                      label: "Z-A (Descending)",
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: OutstandingStatus.values
                  .map(
                    (e) => Flexible(
                      flex: status == e ? 2 : 1,
                      child: InkWell(
                        onTap: () => setState(() => status = e),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: status == e ? e.color : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.title,
                            style: TextStyle(
                              color: status == e
                                  ? Colors.black
                                  : theme.colorScheme.tertiary,
                              fontWeight: status == e
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          SafePaginatedCardGrid(
            cards: [
              for (var _ in Iterable.generate(1000))
                ShopCard(
                  shopName: "S.M. Electronics",
                  location: "Kochi, Kaloor",
                  dueDate: "12-08-2024",
                  amount: "25,000.00",
                  onMoreDetails: () {
                    context.go(Routes.viewDetails);
                  },
                  onViewInvoice: () {
                    context.go(Routes.viewInvoice);
                  },
                ),
            ],
            backgroundColor: status.color,
          ),
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.shopName,
    required this.location,
    required this.dueDate,
    required this.amount,
    required this.onMoreDetails,
    required this.onViewInvoice,
  });

  final String shopName;
  final String location;
  final String dueDate;
  final String amount;
  final VoidCallback onMoreDetails;
  final VoidCallback onViewInvoice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(shopName, style: theme.textTheme.bodyLarge),
          Text(location, style: TextStyle(color: theme.colorScheme.tertiary)),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Due Date\t\t:\t\t ",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                TextSpan(text: dueDate, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Amount\t\t\t\t:\t\t ",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                TextSpan(text: amount, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(
            spacing: 12,
            children: [
              Flexible(
                child: InkWell(
                  onTap: onMoreDetails,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.tertiary),
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "More details",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  onTap: onViewInvoice,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "View Invoice",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
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

enum OutstandingStatus {
  current(color: Color(0xff34c759), title: "Current Outstanding"),
  upcoming(color: Color(0xffffe70b), title: "Upcoming Due"),
  overdue(color: Color(0xfff00b08), title: "Overdue");

  final Color color;
  final String title;

  const OutstandingStatus({required this.color, required this.title});
}
