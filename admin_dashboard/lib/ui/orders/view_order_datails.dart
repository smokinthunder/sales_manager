import 'package:admin_dashboard/domain/models/order/order.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewOrderDatails extends ConsumerWidget {
  final int orderId;
  
  const ViewOrderDatails({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return orderAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load order details',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(orderByIdProvider(orderId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (orderData) {
        final order = Order.fromJson(orderData);
        
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 32,
            children: [
              // Breadcrumb navigation
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.go(Routes.order);
                    },
                    child: Text(
                      "Orders",
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  Icon(Icons.chevron_right),
                  Text("Order #${order.billNumber}"),
                ],
              ),
              // Order details card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.tertiary),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        order.shopName,
                        style: theme.textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 40),
                  
                    Text('Bill No: ${order.billNumber}', style: theme.textTheme.bodyMedium),
                    Text('Order ID: ${order.orderId}', style: theme.textTheme.bodyMedium),
                    Text('Date: ${order.orderDate.toString().substring(0, 10)}', style: theme.textTheme.bodyMedium),
                    Text('Executive: ${order.executiveName}', style: theme.textTheme.bodyMedium),
                    Text('Status: ${order.status.name.toUpperCase()}', style: theme.textTheme.bodyMedium),

                    const SizedBox(height: 20),
                    Text("Shop: ${order.shopName}", style: theme.textTheme.bodyMedium),
                    Text("Location: ${order.shopLocation}", style: theme.textTheme.bodyMedium),
                    Text("Executive Phone: ${order.executivePhone}", style: theme.textTheme.bodyMedium),
                    if (order.notes != null)
                      Text("Notes: ${order.notes}", style: theme.textTheme.bodyMedium),
                    
                    const SizedBox(height: 40),
                    
                    // Order items table
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.5),
                        4: FlexColumnWidth(1.5),
                        5: FlexColumnWidth(1.5),
                        6: FlexColumnWidth(1.5),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: theme.colorScheme.tertiary),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Product', style: theme.textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Unit', style: theme.textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Qty', style: theme.textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Price', style: theme.textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Discount', style: theme.textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Tax', style: theme.textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Total', style: theme.textTheme.bodyMedium),
                            ),
                          ],
                        ),
                        // Order items
                        for (final item in order.items)
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: theme.colorScheme.tertiary),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.productName, style: theme.textTheme.bodySmall),
                                    Text(
                                      item.productCode,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(item.unit, style: theme.textTheme.bodySmall),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.quantity.toStringAsFixed(2),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '₹${item.unitPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '₹${item.discount.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '₹${item.taxAmount.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '₹${item.totalPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Totals
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Items Count: ${order.itemsCount}',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Grand Total: ₹${order.totalAmount.toStringAsFixed(2)}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}