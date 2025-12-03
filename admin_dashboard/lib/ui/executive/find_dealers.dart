import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/empty_state.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FindDealers extends ConsumerStatefulWidget {
  const FindDealers({super.key});

  @override
  ConsumerState<FindDealers> createState() => _FindDealersState();
}

class _FindDealersState extends ConsumerState<FindDealers> {
  String _searchQuery = '';

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
        spacing: 12,
        children: [
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search shop",
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(48),
              border: Border.all(color: theme.colorScheme.primary),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Table(
                    children: [
                      _buildTableRow(theme, "Name", "Arun Kumar"),
                      _buildTableRow(theme, "Location", "Ernakulam"),
                      _buildTableRow(theme, "Contanct no", "+91 345345345"),
                      _buildTableRow(theme, "Joined date", "21-08-205"),
                    ],
                  ),
                ),
                Spacer(),
                Flexible(
                  child: Table(
                    children: [
                      _buildTableRow(theme, "Total Shops", "35"),
                      _buildTableRow(theme, "Month", "Sep"),
                      _buildTableRow(theme, "Pending to Visit", "10"),
                      _buildTableRow(theme, "Visited Shops", "25"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.executive);
                },
                child: Text(
                  "Total Executive",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Find Dealers"),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "Name",
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
          Consumer(
            builder: (context, ref, child) {
              final shopsAsync = ref.watch(
                shopsProvider(
                  status: 'active',
                ),
              );

              return shopsAsync.when(
                data: (shopsList) {
                  // Apply client-side search filter
                  final filteredShops = _searchQuery.isEmpty
                      ? shopsList
                      : shopsList
                          .where((shop) =>
                              shop.name
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              (shop.address
                                      ?.toLowerCase()
                                      .contains(_searchQuery.toLowerCase()) ??
                                  false) ||
                              (shop.locationName
                                      ?.toLowerCase()
                                      .contains(_searchQuery.toLowerCase()) ??
                                  false))
                          .toList();

                  // Empty state
                  if (filteredShops.isEmpty) {
                    return Expanded(
                      child: _searchQuery.isNotEmpty
                          ? SearchEmptyState(searchQuery: _searchQuery)
                          : EmptyState(
                              icon: Icons.store_outlined,
                              title: 'No dealers found',
                              message:
                                  'Shops/Dealers will appear here once they are assigned',
                            ),
                    );
                  }

                  return SafePaginatedCardGrid(
                    cardHeight: 220,
                    cardWidth: 224,
                    cards: [
                      for (var shop in filteredShops)
                        ShopStateCardWrapper(shop: shop),
                    ],
                  );
                },
                loading: () => Expanded(
                  child: LoadingState(message: 'Loading dealers...'),
                ),
                error: (error, stack) => Expanded(
                  child: ErrorState(
                    title: 'Failed to load dealers',
                    message: error.toString(),
                    onRetry: () {
                      ref.invalidate(shopsProvider);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(ThemeData theme, String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
            maxLines: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            ":",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(value, style: theme.textTheme.bodyLarge, maxLines: 1),
        ),
      ],
    );
  }
}

/// Wrapper widget that fetches assignment and visit status for a shop
class ShopStateCardWrapper extends ConsumerWidget {
  const ShopStateCardWrapper({super.key, required this.shop});
  
  final dynamic shop; // Shop model

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch shop assignment to get executive info
    final assignmentAsync = ref.watch(
      shopAssignmentsProvider(
        shopId: shop.shopId,
        status: 'active',
        pageSize: 1,
      ),
    );
    
    // Fetch visit status for this shop
    final visitStatusAsync = ref.watch(
      shopVisitStatusProvider(shop.shopId),
    );

    return assignmentAsync.when(
      data: (assignmentData) {
        final assignments = assignmentData['items'] as List;
        final assignment = assignments.isNotEmpty ? assignments.first : null;
        
        return visitStatusAsync.when(
          data: (visitData) {
            final daysSinceVisit = visitData['days_since_visit'] as int?;
            final ordersThisMonth = visitData['orders_this_month'] as int? ?? 0;
            
            return ShopStateCard(
              orderReceived: ordersThisMonth > 0,
              shopVisited: daysSinceVisit != null && daysSinceVisit <= 7,
              executiveName: assignment?['executive_name'] ?? "N/A",
              executivePhoneNo: assignment?['executive_phone'] ?? "N/A",
              shopName: shop.name,
              shopLocation: shop.address ?? shop.locationName ?? "N/A",
            );
          },
          loading: () => ShopStateCard(
            orderReceived: false,
            shopVisited: false,
            executiveName: assignment?['executive_name'] ?? "N/A",
            executivePhoneNo: assignment?['executive_phone'] ?? "N/A",
            shopName: shop.name,
            shopLocation: shop.address ?? shop.locationName ?? "N/A",
          ),
          error: (_, __) => ShopStateCard(
            orderReceived: false,
            shopVisited: false,
            executiveName: assignment?['executive_name'] ?? "N/A",
            executivePhoneNo: assignment?['executive_phone'] ?? "N/A",
            shopName: shop.name,
            shopLocation: shop.address ?? shop.locationName ?? "N/A",
          ),
        );
      },
      loading: () => visitStatusAsync.when(
        data: (visitData) {
          final daysSinceVisit = visitData['days_since_visit'] as int?;
          final ordersThisMonth = visitData['orders_this_month'] as int? ?? 0;
          
          return ShopStateCard(
            orderReceived: ordersThisMonth > 0,
            shopVisited: daysSinceVisit != null && daysSinceVisit <= 7,
            executiveName: "...",
            executivePhoneNo: "...",
            shopName: shop.name,
            shopLocation: shop.address ?? shop.locationName ?? "N/A",
          );
        },
        loading: () => ShopStateCard(
          orderReceived: false,
          shopVisited: false,
          executiveName: "...",
          executivePhoneNo: "...",
          shopName: shop.name,
          shopLocation: shop.address ?? shop.locationName ?? "N/A",
        ),
        error: (_, __) => ShopStateCard(
          orderReceived: false,
          shopVisited: false,
          executiveName: "N/A",
          executivePhoneNo: "N/A",
          shopName: shop.name,
          shopLocation: shop.address ?? shop.locationName ?? "N/A",
        ),
      ),
      error: (_, __) => visitStatusAsync.when(
        data: (visitData) {
          final daysSinceVisit = visitData['days_since_visit'] as int?;
          final ordersThisMonth = visitData['orders_this_month'] as int? ?? 0;
          
          return ShopStateCard(
            orderReceived: ordersThisMonth > 0,
            shopVisited: daysSinceVisit != null && daysSinceVisit <= 7,
            executiveName: "N/A",
            executivePhoneNo: "N/A",
            shopName: shop.name,
            shopLocation: shop.address ?? shop.locationName ?? "N/A",
          );
        },
        loading: () => ShopStateCard(
          orderReceived: false,
          shopVisited: false,
          executiveName: "N/A",
          executivePhoneNo: "N/A",
          shopName: shop.name,
          shopLocation: shop.address ?? shop.locationName ?? "N/A",
        ),
        error: (_, __) => ShopStateCard(
          orderReceived: false,
          shopVisited: false,
          executiveName: "N/A",
          executivePhoneNo: "N/A",
          shopName: shop.name,
          shopLocation: shop.address ?? shop.locationName ?? "N/A",
        ),
      ),
    );
  }
}

class ShopStateCard extends StatelessWidget {
  const ShopStateCard({
    super.key,
    required this.orderReceived,
    required this.shopVisited,
    required this.shopName,
    required this.shopLocation,
    required this.executiveName,
    required this.executivePhoneNo,
  });
  final bool orderReceived;
  final bool shopVisited;
  final String shopName;
  final String shopLocation;
  final String executiveName;
  final String executivePhoneNo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 224,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.tertiary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shopName, style: theme.textTheme.bodyLarge),
                Text(
                  shopLocation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 8),
                Text(executiveName, style: theme.textTheme.bodyLarge),
                Text(
                  executivePhoneNo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(16),
              borderRadius: BorderRadius.circular(8),
              border: Border(
                top: BorderSide(color: theme.colorScheme.tertiary),
              ),
            ),
            child: Column(
              children: [
                _buildStateRow(orderReceived, "Order received"),
                _buildStateRow(shopVisited, "Shop Visited"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateRow(bool isDone, String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
    child: Row(
      children: [
        Text(text),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            color: isDone ? const Color(0xff34c759) : const Color(0xffbe2121),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(isDone ? Icons.check : Icons.close, color: Colors.white),
        ),
      ],
    ),
  );
}
