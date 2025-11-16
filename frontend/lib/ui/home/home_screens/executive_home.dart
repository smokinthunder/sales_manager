import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager/config/assets.dart';
import 'package:sales_manager/config/providers/login_message_provider.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';
import 'package:sales_manager/utils/show_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/route_paths.dart';

class ExecutiveHome extends ConsumerStatefulWidget {
  const ExecutiveHome({super.key});

  @override
  ConsumerState<ExecutiveHome> createState() => _ExecutiveHomeState();
}

class _ExecutiveHomeState extends ConsumerState<ExecutiveHome> {
  bool isSpecialRouteExpanded = false;

  bool _isMessageShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final loginMessage = ref.read(loginMessageProvider);

    if (!_isMessageShown && loginMessage != null) {
      _isMessageShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, loginMessage);
        ref.read(loginMessageProvider.notifier).state = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Customers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Customers : 58", style: textTheme.headlineSmall),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      context.push(RoutePaths.addShop);
                    },
                    child: Text(
                      "Add new customer",
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      context.push(RoutePaths.create_order);
                    },
                    child: Text(
                      "Create order",
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          const SizedBox(height: 8),

          // ExpansionTile for Special Route
          Card(
            color: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's Route", style: textTheme.bodyLarge),
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: textTheme.labelLarge,
                      ),
                      SizedBox(height: 4),
                      Text("kochi, Kalamassery", style: textTheme.labelLarge),
                    ],
                  ),
                  Spacer(),

                  Image.asset(Assets.todayRouteImage, height: 40, width: 40),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Special Route", style: textTheme.bodyLarge),

                      SizedBox(height: 4),
                      Text(
                        "No special route assigned",
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(Assets.specialRouteImage, height: 46, width: 46),
                ],
              ),
            ),
          ),

          //TODO: Clean up the commented code below or use it
          // Card(
          //   color: theme.colorScheme.onPrimary,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Row(
          //           children: const [
          //             Expanded(
          //               child: _InputField(label: "Location", value: "Kochi"),
          //             ),
          //             SizedBox(width: 10),
          //             Expanded(
          //               child: _InputField(label: "Area", value: "Kalamassery"),
          //             ),
          //           ],
          //         ),
          //       ),
          //       ExpansionTile(
          //         shape: RoundedRectangleBorder(),
          //         title: Text(
          //           "Special route",

          //           style: textTheme.bodyMedium?.copyWith(
          //             color: theme.colorScheme.primary,
          //           ),
          //         ),
          //         initiallyExpanded: isSpecialRouteExpanded,
          //         onExpansionChanged: (val) {
          //           setState(() => isSpecialRouteExpanded = val);
          //         },
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(12.0),
          //             child: Column(
          //               children: [
          //                 Row(
          //                   children: const [
          //                     Expanded(
          //                       child: _InputField(
          //                         label: "Shop Name",
          //                         value: "New India Traders",
          //                       ),
          //                     ),
          //                     SizedBox(width: 10),
          //                     Expanded(
          //                       child: _InputField(
          //                         label: "Location",
          //                         value: "Kalamassery",
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Row(
          //                   children: const [
          //                     Expanded(
          //                       child: _InputField(
          //                         label: "Area",
          //                         value: "Manalimukku",
          //                       ),
          //                     ),
          //                     SizedBox(width: 10),
          //                     Expanded(
          //                       child: _InputField(
          //                         label: "Contact No",
          //                         value: "+91 9821241890",
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 16),

          // Top Customers
          Text("Top Customers", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            mainAxisSpacing: 12,
            children: const [
              _CustomerCard(
                name: "S K Steels",
                location: "Kochi",
                phone: "+91 8432518902",
                value: "2500",
              ),
              _CustomerCard(
                name: "M K Enterprises",
                location: "Ernakulam",
                phone: "+91 8432518902",
                value: "2400",
              ),
              _CustomerCard(
                name: "Athira Metals",
                location: "Aluva",
                phone: "+91 8432518902",
                value: "2300",
              ),
              _CustomerCard(
                name: "SAM Traders",
                location: "Vyttila",
                phone: "+91 8432518902",
                value: "1200",
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              context.push(RoutePaths.executiveTopCustomers);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "View all",
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
          CategoryScroll(shops: testShops),
        ],
      ),
    );
  }
}

//// Reusable Widgets //////

class _InputField extends StatelessWidget {
  final String label;
  final String value;
  const _InputField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.tertiary),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final String name;
  final String location;
  final String phone;
  final String value;
  const _CustomerCard({
    required this.name,
    required this.location,
    required this.phone,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(RoutePaths.executiveShopDetails);
        //TODO
      },
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.bodyLarge),
              Text(location, style: Theme.of(context).textTheme.bodySmall),
              SizedBox(height: 4),
              Text(phone, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.blue),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryScroll extends StatefulWidget {
  final List<Shop> shops;

  const CategoryScroll({super.key, required this.shops});

  @override
  State<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends State<CategoryScroll> {
  ShopCategory selectedCategory = ShopCategory.newShops;

  List<Shop> getFilteredShops() {
    switch (selectedCategory) {
      case ShopCategory.newShops:
        return widget.shops.where((shop) => shop.isNewShop).toList();
      case ShopCategory.bestCustomers:
        return widget.shops.where((shop) => shop.isBestCustomer).toList();
      case ShopCategory.visitedShops:
        return widget.shops.where((shop) => !shop.needsVisiting).toList();
      case ShopCategory.notVisited:
        return widget.shops.where((shop) => shop.needsVisiting).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredShops = getFilteredShops();

    return Column(
      children: [
        // Category tabs
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: ShopCategory.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 2),
            itemBuilder: (context, index) {
              final category = ShopCategory.values[index];
              final isSelected = category == selectedCategory;

              return TextButton(
                child: Text(
                  category.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.tertiary,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              );
            },
          ),
        ),

        // Shop list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredShops.length,
          itemBuilder: (context, index) {
            Widget? trailing;
            final shop = filteredShops[index];
            if (selectedCategory == ShopCategory.visitedShops) {
              trailing = Text(
                DateFormat('dd-MM-yyyy').format(shop.lastVisted),
                style: Theme.of(context).textTheme.bodySmall,
              );
            } else if (selectedCategory == ShopCategory.notVisited) {
              trailing = IconButton(
                icon: const Icon(Icons.chat_outlined),
                onPressed: () {
                  setState(() {
                    context.push(RoutePaths.reasonForNotVisting, extra: shop);
                  });
                },
              );
            } else {
              trailing = null;
            }
            return ListTile(
              title: Text(
                shop.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                shop.location,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: trailing,
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: colorScheme.tertiary, thickness: 0.5, height: 0),
        ),
      ],
    );
  }
}

enum ShopCategory {
  newShops("New Shops"),
  bestCustomers("Best Customer"),
  visitedShops("Visited Shop"),
  notVisited("Not Visited");

  final String label;
  const ShopCategory(this.label);
}
