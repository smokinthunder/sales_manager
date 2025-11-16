import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/widgets/drop_down_menu.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  bool isShopDetailsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create order"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Text(
                        'Enter  your order details',
                        style: textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        style: buttonStyle,
                        onPressed: () {
                          context.push(RoutePaths.orderHistory);
                        },
                        child: Text(
                          "Order History",
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text("Order No: 123456", style: textTheme.bodySmall),
                  Text("Date: 20-09-2025", style: textTheme.bodySmall),
                  Text("Executive: Sidharth", style: textTheme.bodySmall),
                  SizedBox(height: 8),
                  Text(
                    'Select Shop',
                    style: textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  CustomDropDownMenu(
                    hintText: "Shop Name",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(value: "Akhil Dev", label: "Akhil Dev"),
                      DropdownMenuEntry(value: "John Doe", label: "John Doe"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Shop details',
                        style: textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isShopDetailsExpanded = !isShopDetailsExpanded;
                          });
                        },
                        icon: Icon(
                          isShopDetailsExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                      ),
                    ],
                  ),
                  if (isShopDetailsExpanded)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.tertiary),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(5),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Address:",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Near Moolankuzhy Circle Corporation Office, Nazareth Road North Moolankuzhi, Fort Kochi-682002",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Location:",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Fort Kochi , Kochi",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Contact Number",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "123-456-7890",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: write proper code
                    context.go(RoutePaths.addShopSuccess);
                  },
                  child: const Text("Continue"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
