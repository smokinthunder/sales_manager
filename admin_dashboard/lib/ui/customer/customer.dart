import 'package:admin_dashboard/domain/models/shop/shop.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Customer extends ConsumerStatefulWidget {
  const Customer({super.key});

  @override
  ConsumerState<Customer> createState() => _CustomerState();
}

class _CustomerState extends ConsumerState<Customer> {
  String filterStatus = 'all'; // 'all', 'active', 'inactive'
  String searchQuery = '';
  String sortOrder = 'New';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fetch shops based on filter status
    final shopsAsync = ref.watch(
      shopsProvider(
        status: filterStatus == 'all' ? null : filterStatus,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          shopsAsync.when(
            data: (allShops) {
              // Calculate "new customers" - shops created in last 7 days
              final now = DateTime.now();
              final sevenDaysAgo = now.subtract(Duration(days: 7));
              final newCustomers = allShops
                  .where((shop) => shop.createdAt.isAfter(sevenDaysAgo))
                  .length;

              return Row(
                spacing: 32,
                children: [
                  TitleAndValueContainer(
                    title: "All Customers",
                    count: "${allShops.length}",
                  ),
                  TitleAndValueContainer(
                    title: "New Customers",
                    count: "$newCustomers",
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context.go(Routes.addNewCusomter);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Add new Customer ",
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                        Icon(Icons.add, color: theme.colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => Row(
              spacing: 32,
              children: [
                TitleAndValueContainer(
                  title: "All Customers",
                  count: "...",
                ),
                TitleAndValueContainer(
                  title: "New Customers",
                  count: "...",
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    context.go(Routes.addNewCusomter);
                  },
                  child: Row(
                    children: [
                      Text(
                        "Add new Customer ",
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      Icon(Icons.add, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
            error: (_, __) => Row(
              spacing: 32,
              children: [
                TitleAndValueContainer(
                  title: "All Customers",
                  count: "0",
                ),
                TitleAndValueContainer(
                  title: "New Customers",
                  count: "0",
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    context.go(Routes.addNewCusomter);
                  },
                  child: Row(
                    children: [
                      Text(
                        "Add new Customer ",
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      Icon(Icons.add, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 32,
            children: [
              BlueBorderButtons(
                title: "All customers",
                isSelected: filterStatus == 'all',
                onClick: () {
                  setState(() {
                    filterStatus = 'all';
                  });
                },
              ),
              BlueBorderButtons(
                title: "Active customers",
                isSelected: filterStatus == 'active',
                onClick: () {
                  setState(() {
                    filterStatus = 'active';
                  });
                },
              ),
              BlueBorderButtons(
                title: "Inactive customers",
                isSelected: filterStatus == 'inactive',
                onClick: () {
                  setState(() {
                    filterStatus = 'inactive';
                  });
                },
              ),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
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
              Text('All customer list', style: theme.textTheme.headlineMedium),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: sortOrder,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "New", label: "New"),
                    DropdownMenuEntry(value: "Old", label: "Old"),
                    DropdownMenuEntry(value: "A-Z", label: "A-Z (Ascending)"),
                    DropdownMenuEntry(
                      value: "Z-A",
                      label: "Z-A (Descending)",
                    ),
                  ],
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        sortOrder = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          shopsAsync.when(
            data: (shops) {
              var filteredShops = shops;

              // Apply search filter
              if (searchQuery.isNotEmpty) {
                filteredShops = filteredShops
                    .where((shop) =>
                        shop.name.toLowerCase().contains(searchQuery) ||
                        (shop.address?.toLowerCase().contains(searchQuery) ?? false) ||
                        (shop.locationName?.toLowerCase().contains(searchQuery) ?? false))
                    .toList();
              }

              // Apply sorting
              switch (sortOrder) {
                case 'Old':
                  filteredShops = filteredShops.reversed.toList();
                  break;
                case 'A-Z':
                  filteredShops.sort((a, b) => a.name.compareTo(b.name));
                  break;
                case 'Z-A':
                  filteredShops.sort((a, b) => b.name.compareTo(a.name));
                  break;
                case 'New':
                default:
                  // Default order from backend
                  break;
              }

              // Empty state
              if (filteredShops.isEmpty) {
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 64,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'No customers found matching "$searchQuery"'
                              : filterStatus == 'active'
                                  ? 'No active customers'
                                  : filterStatus == 'inactive'
                                      ? 'No inactive customers'
                                      : 'No customers available',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try adjusting your search'
                              : 'Customers will appear here once added',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        if (searchQuery.isEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.go(Routes.addNewCusomter);
                              },
                              icon: Icon(Icons.add),
                              label: Text('Add New Customer'),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }

              return SafePaginatedCardGrid(
                spacing: 16,
                cardWidth: 300,
                cardHeight: 200,
                cards: filteredShops
                    .map(
                      (shop) => ShopCard(
                        shop: shop,
                        onClick: () {
                          context.go('${Routes.customerDetails}/${shop.shopId}');
                        },
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => SizedBox(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load customers',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(shopsProvider);
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget{
  const ShopCard({
    super.key,
    required this.shop,
    required this.onClick,
  });

  final Shop shop;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Get location display text
    final location = shop.locationName ?? 
                     shop.address ?? 
                     (shop.territoryId != null ? 'Territory ${shop.territoryId}' : 'No location');
    
    // Generate initials for avatar
    final initials = shop.name.isNotEmpty 
        ? shop.name.split(' ').take(2).map((word) => word[0]).join().toUpperCase()
        : 'SH';

    return Container(
      width: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: shop.status.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  shop.status.displayName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: shop.status.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (shop.phone != null || shop.contactPerson != null)
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  if (shop.contactPerson != null)
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          shop.contactPerson!,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  if (shop.phone != null)
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          shop.phone!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: BlueBorderButtons(
              title: "View details",
              onClick: onClick,
              invert: true,
            ),
          ),
        ],
      ),
    );
  }
}

class BlueBorderButtons extends StatelessWidget {
  const BlueBorderButtons({
    super.key,
    required this.title,
    required this.onClick,
    this.invert = false,
    this.isSelected = false,
  });
  final String title;
  final VoidCallback onClick;
  final bool invert;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final shouldFill = invert || isSelected;
    
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: shouldFill ? theme.colorScheme.primary : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.primary, width: 1),
        ),
        child: Text(
          title,
          style: shouldFill
              ? theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                )
              : theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
        ),
      ),
    );
  }
}
