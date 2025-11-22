import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewOrderDatails extends StatelessWidget {
  const ViewOrderDatails({super.key});

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
            spacing: 32,
            children: [
              TitleAndValueContainer(
                title: "All Orders",
                count: "100",
                width: 200,
              ),
              TitleAndValueContainer(
                title: "New Orders",
                count: "15",
                width: 200,
              ),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by bill no or name",
                  ),
                ),
              ),
            ],
          ),      Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.order);
                },
                child: Text(
                  "Order",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("View Bill"),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "Time",
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
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.tertiary),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text('Ponnore Industries', style: theme.textTheme.headlineLarge)),
                const SizedBox(height: 40),
              
                Text('Bill No: 123456', style: theme.textTheme.bodyMedium),
                Text( 'Date: 2024-06-15', style: theme.textTheme.bodyMedium),
                Text('Executive: Jane Smith', style: theme.textTheme.bodyMedium),  

                SizedBox(height: 20),
                Text("Customer : John Doe", style: theme.textTheme.bodyMedium),
                Text("Address : 123 Main St, Cityville", style: theme.textTheme.bodyMedium),
                Text("Email : john.doe@example.com", style: theme.textTheme.bodyMedium),
                Text("Phone : +1 234 567 8900", style: theme.textTheme.bodyMedium),
                SizedBox(height: 40),
                Table(
                 columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.tertiary))),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Item Name', style: theme.textTheme.bodyMedium),
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Price', style: theme.textTheme.bodyMedium),
                        ), Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Quantity', style: theme.textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Std.Pkg', style: theme.textTheme.bodyMedium),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Discount', style: theme.textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Tax Amount', style: theme.textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Total', style: theme.textTheme.bodyMedium),
                        ),
                      ],
                    ),
                for (final _ in Iterable.generate(6)) TableRow(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.tertiary))),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Product A', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('2', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$50', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$100', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('5', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$10', style: theme.textTheme.bodySmall),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('\$8', style: theme.textTheme.bodySmall),
                        ),
                     
                      ],
                    ),
                    // Add more TableRow widgets for additional items
                  ],
                ),
                
                SizedBox(height: 20),
                Text( 'Grand Total: \$218', style: theme.textTheme.bodyMedium), 
                SizedBox(height: 8),
                Text( 'Tax Total: \$18', style: theme.textTheme.bodyMedium),]
            ),
          ),
        ],
      ),
    );
  }
}