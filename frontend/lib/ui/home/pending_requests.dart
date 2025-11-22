import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/notification/notification_viewmodel.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class PendingRequests extends ConsumerStatefulWidget {
  const PendingRequests({super.key});

  @override
  ConsumerState<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends ConsumerState<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    final shopCreationNotificationsAsync = ref.watch(shopCreationNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Shop Creation Requests"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: shopCreationNotificationsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load shop creation requests',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(shopCreationNotificationsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'No pending shop creation requests',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All shop creation requests have been processed',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            // Convert notifications to shop approval requests for the existing UI
            final shopRequests = notifications.map((notification) {
              return ShopArrovalRequest.fromNotification(notification);
            }).toList();

            return PaginatedList(items: shopRequests);
          },
        ),
      ),
    );
  }
}

class PaginatedList extends ConsumerStatefulWidget {
  final List<ShopArrovalRequest> items;
  const PaginatedList({super.key, required this.items});

  @override
  ConsumerState<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends ConsumerState<PaginatedList> {
  final int itemsPerPage = 6;
  late final int totalPages;
  late final PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    totalPages = (widget.items.length / itemsPerPage).ceil();
    _pageController = PageController();
  }

  List<ShopArrovalRequest> getPageItems(int pageIndex) {
    final start = pageIndex * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, widget.items.length);
    return widget.items.sublist(start, end);
  }

  Widget _buildNavButton({
    required bool enabled,
    required VoidCallback? onTap,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: enabled ? color : color.withAlpha(128),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Main paged list
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, pageIndex) {
              final pageItems = getPageItems(pageIndex);
              return ListView.separated(
                itemCount: pageItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    // TODO: implement navigation
                    context.push(RoutePaths.executiveShopDetails);
                  },
                  child: RequestCard(
                    requests: pageItems[index],
                    onApprove: () async {
                      final success = await ref
                          .read(notificationConfirmationProvider.notifier)
                          .confirmNotification(pageItems[index].notificationId, 'approve');
                      
                      if (context.mounted) {
                        if (success) {
                          showSnackBar(
                            context,
                            'Shop creation request approved successfully',
                            false,
                          );
                          // Refresh the data
                          ref.invalidate(shopCreationNotificationsProvider);
                        } else {
                          showSnackBar(
                            context,
                            'Failed to approve request. Please try again.',
                            true,
                          );
                        }
                      }
                    },
                    onReject: () async {
                      final success = await ref
                          .read(notificationConfirmationProvider.notifier)
                          .confirmNotification(pageItems[index].notificationId, 'reject');
                      
                      if (context.mounted) {
                        if (success) {
                          showSnackBar(
                            context,
                            'Shop creation request rejected successfully',
                            false,
                          );
                          // Refresh the data
                          ref.invalidate(shopCreationNotificationsProvider);
                        } else {
                          showSnackBar(
                            context,
                            'Failed to reject request. Please try again.',
                            true,
                          );
                        }
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Navigation buttons
        if (itemsPerPage < widget.items.length)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavButton(
                enabled: currentPage > 0,
                onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                icon: Icons.arrow_back_ios_new,
                color: colors.primary,
                iconColor: colors.onPrimary,
              ),
              const SizedBox(width: 16),
              _buildNavButton(
                enabled: currentPage < totalPages - 1,
                onTap: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                icon: Icons.arrow_forward_ios,
                color: colors.primary,
                iconColor: colors.onPrimary,
              ),
            ],
          ),

        const SizedBox(height: 12),
      ],
    );
  }
}

class RequestCard extends StatelessWidget {
  final ShopArrovalRequest requests;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  const RequestCard({
    super.key,
    required this.requests,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(requests.shopName, style: textTheme.bodyLarge),
                Text(requests.location, style: textTheme.labelLarge),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    requests.executiveName,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  "Date: ${DateFormat("dd-MM-yyyy | hh:mm a").format(requests.requestTime)}",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                InkWell(
                  onTap: onApprove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Approve",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onReject,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.primary),
                    ),
                    child: Text(
                      "Reject",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Modify or rework data classes to the requirements
class ShopArrovalRequest {
  final String shopName;
  final String executiveName;
  final String location;
  final DateTime requestTime;
  final String notificationId;

  ShopArrovalRequest({
    required this.shopName,
    required this.executiveName,
    required this.location,
    required this.requestTime,
    required this.notificationId,
  });

  /// Factory constructor to create from notification data
  factory ShopArrovalRequest.fromNotification(NotificationItem notification) {
    // Extract shop data from notification's related data or subject
    final shopName = notification.subject.contains('shop creation') 
        ? notification.subject.replaceAll('Request for shop creation approval', '').trim()
        : 'Shop Request';
    
    return ShopArrovalRequest(
      shopName: shopName.isNotEmpty ? shopName : 'New Shop',
      executiveName: notification.senderName,
      location: 'Location not specified', // This might need to come from relatedData if available
      requestTime: notification.createdAt,
      notificationId: notification.id,
    );
  }
}
