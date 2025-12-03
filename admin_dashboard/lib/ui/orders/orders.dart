import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/empty_state.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:admin_dashboard/domain/models/order/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Orders extends ConsumerStatefulWidget {
  const Orders({super.key});

  @override
  ConsumerState<Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<Orders> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Fetch all orders
    final allOrdersAsync = ref.watch(ordersProvider(
      search: _searchQuery.isEmpty ? null : _searchQuery,
      pageSize: 100,
    ));
    
    // Fetch pending orders for "New Orders" count
    final pendingOrdersAsync = ref.watch(ordersProvider(
      status: 'pending',
      pageSize: 100,
    ));

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          // Order counts
          Row(
            spacing: 32,
            children: [
              allOrdersAsync.when(
                data: (data) => TitleAndValueContainer(
                  title: "All Orders",
                  count: data['total'].toString(),
                  width: 200,
                ),
                loading: () => TitleAndValueContainer(
                  title: "All Orders",
                  count: "...",
                  width: 200,
                ),
                error: (_, __) => TitleAndValueContainer(
                  title: "All Orders",
                  count: "0",
                  width: 200,
                ),
              ),
              pendingOrdersAsync.when(
                data: (data) => TitleAndValueContainer(
                  title: "New Orders",
                  count: data['total'].toString(),
                  width: 200,
                ),
                loading: () => TitleAndValueContainer(
                  title: "New Orders",
                  count: "...",
                  width: 200,
                ),
                error: (_, __) => TitleAndValueContainer(
                  title: "New Orders",
                  count: "0",
                  width: 200,
                ),
              ),
            ],
          ),
          
          // Search field
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by bill no or name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
          
          // Orders header
          Row(
            children: [
              Text('Orders', style: theme.textTheme.headlineMedium),
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
          
          // Orders grid
          allOrdersAsync.when(
            data: (data) {
              final orders = (data['items'] as List)
                  .map((item) => Order.fromJson(item))
                  .toList();
              
              if (orders.isEmpty) {
                return SizedBox(
                  height: 400,
                  child: _searchQuery.isNotEmpty
                      ? SearchEmptyState(searchQuery: _searchQuery)
                      : EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: 'No orders found',
                          message: 'Orders will appear here once customers place them',
                        ),
                );
              }
              
              return SafePaginatedCardGrid(
                cardHeight: 222,
                cards: [
                  for (var order in orders)
                    ShopAnalyticsCard(
                      order: order,
                      onTap: () {
                        context.go('${Routes.viewOrderDetails}/${order.id}');
                      },
                    ),
                ],
              );
            },
            loading: () => SizedBox(height: 400,
              child: LoadingState(message: 'Loading orders...'),
            ),
            error: (error, stackTrace) => SizedBox(
              height: 400,
              child: ErrorState(
                title: 'Failed to load orders',
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(ordersProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopAnalyticsCard extends StatelessWidget {
  const ShopAnalyticsCard({
    super.key,
    required this.order,
    required this.onTap,
  });
  
  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
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
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined, color: theme.colorScheme.tertiary),
              Expanded(
                child: Text(
                  " ${order.shopName}",
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.description_outlined, color: theme.colorScheme.tertiary),
              Text(" ${order.billNumber}", style: theme.textTheme.bodyLarge),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, color: theme.colorScheme.tertiary),
              Expanded(
                child: Text(
                  " ${order.executiveName}",
                  style: theme.textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Icon(
                Icons.currency_rupee,
                color: Colors.black,
                size: 28,
              ),
              Text(
                " ${order.totalAmount.toStringAsFixed(2)}",
                style: theme.textTheme.headlineLarge,
              ),
            ],
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "View Bill",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

