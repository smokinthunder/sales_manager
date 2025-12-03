import 'package:admin_dashboard/domain/models/outstanding/outstanding_payment.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MoreDetails extends ConsumerWidget {
  final int paymentId;
  
  const MoreDetails({
    super.key,
    required this.paymentId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final paymentAsync = ref.watch(outstandingPaymentByIdProvider(paymentId));

    return paymentAsync.when(
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
                'Failed to load payment details',
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
                onPressed: () => ref.invalidate(outstandingPaymentByIdProvider(paymentId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (paymentData) {
        final payment = OutstandingPayment.fromJson(paymentData);
        final dateFormat = DateFormat('dd MMM yyyy');
        final dueDate = DateTime.tryParse(payment.dueDate);
        final lastPayment = payment.lastPaymentDate != null 
            ? DateTime.tryParse(payment.lastPaymentDate!) 
            : null;
        
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb navigation
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.go(Routes.outstanding);
                    },
                    child: Text(
                      "Outstanding Payments",
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                  Text("Payment #${payment.id} - ${payment.shopName}"),
                ],
              ),
              const SizedBox(height: 32),
              
              // Payment details container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.tertiary),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment ID: ${payment.id}',
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              payment.shopName,
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: payment.status.name == 'current'
                                ? Colors.blue.withOpacity(0.1)
                                : payment.status.name == 'overdue'
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            payment.status.name.toUpperCase(),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: payment.status.name == 'current'
                                  ? Colors.blue
                                  : payment.status.name == 'overdue'
                                      ? Colors.red
                                      : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    
                    // Payment information
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column - Amount details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AMOUNT DETAILS',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Outstanding Amount:', '₹${payment.amount.toStringAsFixed(2)}', theme),
                              if (payment.originalAmount != null)
                                _buildInfoRow('Original Amount:', '₹${payment.originalAmount!.toStringAsFixed(2)}', theme),
                              if (dueDate != null)
                                _buildInfoRow('Due Date:', dateFormat.format(dueDate), theme),
                              if (payment.daysOverdue > 0)
                                _buildInfoRow(
                                  'Days Overdue:', 
                                  payment.daysOverdue.toString(),
                                  theme,
                                  valueColor: Colors.red,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                        // Right column - Shop & Executive details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SHOP & EXECUTIVE DETAILS',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildInfoRow('Shop ID:', payment.shopId, theme),
                              if (payment.salesExecutiveName != null)
                                _buildInfoRow('Sales Executive:', payment.salesExecutiveName!, theme),
                              if (payment.territoryName != null)
                                _buildInfoRow('Territory:', payment.territoryName!, theme),
                              if (lastPayment != null)
                                _buildInfoRow('Last Payment:', dateFormat.format(lastPayment), theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Notes section
                    if (payment.notes != null && payment.notes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'NOTES',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        payment.notes!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => context.go(Routes.outstanding),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back to List'),
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

  Widget _buildInfoRow(String label, String value, ThemeData theme, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
