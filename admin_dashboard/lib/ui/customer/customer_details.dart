import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:admin_dashboard/domain/models/shop/shop.dart';
import 'package:admin_dashboard/domain/models/shop/shop_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomerDetails extends ConsumerWidget {
  final String shopId;
  
  const CustomerDetails({
    super.key,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final shopAsync = ref.watch(shopByIdProvider(shopId));
    
    return shopAsync.when(
      loading: () => Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Failed to load shop details',
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.red),
              ),
              SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(shopByIdProvider(shopId));
                },
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (shopData) {
        final shop = Shop.fromJson(shopData);
        
        return Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 32,
            children: [
              // Title with back button
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.go(Routes.customer);
                    },
                    child: Text(
                      "Customer",
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  Icon(Icons.chevron_right),
                  Text(shop.name),
                ],
              ),
              
              Container(
                color: theme.colorScheme.surface,
                padding: EdgeInsets.all(12),
                child: Row(
                  spacing: 12,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Column(
                        spacing: 12,
                        children: [
                          // Shop Title Card
                          Container(
                            padding: EdgeInsets.all(12),
                            color: theme.colorScheme.onPrimary,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: Text(
                                    shop.name.isNotEmpty 
                                        ? shop.name[0].toUpperCase() 
                                        : 'S',
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.name,
                                        style: theme.textTheme.bodyLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        shop.address ?? 'No address',
                                        style: theme.textTheme.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Chip(
                                  label: Text(shop.status.name.toUpperCase()),
                                  backgroundColor: shop.status == ShopStatus.active
                                      ? Colors.green.shade100
                                      : Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                          
                          // Basic Details
                          Container(
                            padding: EdgeInsets.all(12),
                            color: theme.colorScheme.onPrimary,
                            child: Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Basic details", style: theme.textTheme.bodyLarge),
                                _buildRowItem(theme, "Shop ID", shop.shopId),
                                _buildRowItem(theme, "Phone", shop.phone ?? 'Not provided'),
                                _buildRowItem(theme, "Email", shop.email ?? 'Not provided'),
                                _buildRowItem(theme, "Address", shop.address ?? 'Not provided'),
                                _buildRowItem(theme, "Territory ID", shop.territoryId ?? 'N/A'),
                              ],
                            ),
                          ),
                          
                          // More Details
                          Container(
                            padding: EdgeInsets.all(12),
                            color: theme.colorScheme.onPrimary,
                            child: Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("More details", style: theme.textTheme.bodyLarge),
                                _buildRowItem(theme, "Contact Person", shop.contactPerson ?? 'Not provided'),
                                _buildRowItem(theme, "Location", shop.locationName ?? 'N/A'),
                                _buildRowItem(theme, "Pin Code", shop.pinCode ?? 'N/A'),
                                _buildRowItem(theme, "GST Number", shop.gstNumber ?? 'Not provided'),
                                _buildRowItem(theme, "Created Date", shop.createdAt.toString().substring(0, 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Recent Orders Section (placeholder - needs order API)
                    Flexible(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        color: theme.colorScheme.onPrimary,
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Recent Orders", style: theme.textTheme.bodyLarge),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 40),
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 48,
                                    color: theme.colorScheme.tertiary,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Order history feature coming soon',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildRowItem(ThemeData theme, String title, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$title:",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
