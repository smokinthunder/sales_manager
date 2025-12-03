import 'package:admin_dashboard/domain/models/outstanding/outstanding_payment.dart';
import 'package:admin_dashboard/domain/models/outstanding/outstanding_status.dart';
import 'package:admin_dashboard/domain/models/outstanding/outstanding_summary.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/empty_state.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Outstanding extends ConsumerStatefulWidget {
  const Outstanding({super.key});

  @override
  ConsumerState<Outstanding> createState() => _OutstandingState();
}

class _OutstandingState extends ConsumerState<Outstanding> {
  OutstandingStatus selectedStatus = OutstandingStatus.current;
  String searchQuery = '';
  String sortOrder = 'New';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fetch outstanding payments based on selected status
    final paymentsAsync = ref.watch(
      outstandingPaymentsProvider(
        status: selectedStatus.toApiString(),
        shopSearch: searchQuery.isEmpty ? null : searchQuery,
        pageSize: 100,
      ),
    );

    // Fetch summary for status tabs
    final summaryAsync = ref.watch(outstandingSummaryProvider);

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
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
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
              Text('Outstanding', style: theme.textTheme.headlineMedium),
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
          // Status tabs with counts
          summaryAsync.when(
            data: (summaryData) {
              final summary = OutstandingSummary.fromJson(summaryData);
              return Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: OutstandingStatus.values
                      .map(
                        (e) => Flexible(
                          flex: selectedStatus == e ? 2 : 1,
                          child: InkWell(
                            onTap: () => setState(() => selectedStatus = e),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: selectedStatus == e
                                    ? e.color
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                spacing: 4,
                                children: [
                                  Text(
                                    e.title,
                                    style: TextStyle(
                                      color: selectedStatus == e
                                          ? Colors.black
                                          : theme.colorScheme.tertiary,
                                      fontWeight: selectedStatus == e
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${_getStatusCount(summary, e)} payments',
                                    style: TextStyle(
                                      color: selectedStatus == e
                                          ? Colors.black.withOpacity(0.7)
                                          : theme.colorScheme.tertiary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
            loading: () => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: OutstandingStatus.values
                    .map(
                      (e) => Flexible(
                        flex: selectedStatus == e ? 2 : 1,
                        child: InkWell(
                          onTap: () => setState(() => selectedStatus = e),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedStatus == e
                                  ? e.color
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              e.title,
                              style: TextStyle(
                                color: selectedStatus == e
                                    ? Colors.black
                                    : theme.colorScheme.tertiary,
                                fontWeight: selectedStatus == e
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
            error: (_, __) => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: OutstandingStatus.values
                    .map(
                      (e) => Flexible(
                        flex: selectedStatus == e ? 2 : 1,
                        child: InkWell(
                          onTap: () => setState(() => selectedStatus = e),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selectedStatus == e
                                  ? e.color
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              e.title,
                              style: TextStyle(
                                color: selectedStatus == e
                                    ? Colors.black
                                    : theme.colorScheme.tertiary,
                                fontWeight: selectedStatus == e
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
          ),
          // Payments list
          paymentsAsync.when(
            data: (paymentsData) {
              final payments = (paymentsData['items'] as List)
                  .map((item) => OutstandingPayment.fromJson(item))
                  .toList();

              // Apply sorting
              switch (sortOrder) {
                case 'Old':
                  payments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                  break;
                case 'A-Z':
                  payments.sort((a, b) => a.shopName.compareTo(b.shopName));
                  break;
                case 'Z-A':
                  payments.sort((a, b) => b.shopName.compareTo(a.shopName));
                  break;
                case 'New':
                default:
                  payments.sort((a, b) => b.dueDate.compareTo(a.dueDate));
                  break;
              }

              // Empty state
              if (payments.isEmpty) {
                return Expanded(
                  child: searchQuery.isNotEmpty
                      ? SearchEmptyState(searchQuery: searchQuery)
                      : EmptyState(
                          icon: Icons.payment_outlined,
                          title: 'No ${selectedStatus.title.toLowerCase()}',
                          message:
                              '${selectedStatus.title} will appear here once available',
                        ),
                );
              }

              return SafePaginatedCardGrid(
                cards: payments
                    .map(
                      (payment) => OutstandingPaymentCard(
                        payment: payment,
                        onMoreDetails: () {
                          context.go(Routes.viewDetails);
                        },
                        onViewInvoice: () {
                          context.go(Routes.viewInvoice);
                        },
                      ),
                    )
                    .toList(),
                backgroundColor: selectedStatus.color,
              );
            },
            loading: () => Expanded(
              child: LoadingState(message: 'Loading outstanding payments...'),
            ),
            error: (error, stack) => Expanded(
              child: ErrorState(
                title: 'Failed to load outstanding payments',
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(outstandingPaymentsProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getStatusCount(OutstandingSummary summary, OutstandingStatus status) {
    switch (status) {
      case OutstandingStatus.current:
        return summary.currentCount;
      case OutstandingStatus.upcoming:
        return summary.upcomingCount;
      case OutstandingStatus.overdue:
        return summary.overdueCount;
    }
  }
}

/// Outstanding payment card widget
class OutstandingPaymentCard extends StatelessWidget {
  const OutstandingPaymentCard({
    super.key,
    required this.payment,
    required this.onMoreDetails,
    required this.onViewInvoice,
  });

  final OutstandingPayment payment;
  final VoidCallback onMoreDetails;
  final VoidCallback onViewInvoice;

  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return isoDate;
    }
  }

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
          // Shop name and overdue badge
          Row(
            children: [
              Expanded(
                child: Text(
                  payment.shopName,
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (payment.isOverdue && payment.daysOverdue > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${payment.daysOverdue} days overdue',
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            payment.territoryName ?? 'Unknown Territory',
            style: TextStyle(color: theme.colorScheme.tertiary),
          ),
          if (payment.salesExecutiveName != null) ...[
            SizedBox(height: 4),
            Text(
              'Executive: ${payment.salesExecutiveName}',
              style: TextStyle(
                color: theme.colorScheme.tertiary,
                fontSize: 12,
              ),
            ),
          ],
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
                TextSpan(
                  text: payment.formattedDueDate,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: payment.isOverdue ? Colors.red : null,
                    fontWeight:
                        payment.isOverdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
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
                TextSpan(
                  text: payment.formattedAmount,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (payment.lastPaymentDate != null) ...[
            SizedBox(height: 8),
            Text(
              'Last payment: ${_formatDate(payment.lastPaymentDate)}',
              style: TextStyle(
                color: theme.colorScheme.tertiary,
                fontSize: 12,
              ),
            ),
          ],
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
