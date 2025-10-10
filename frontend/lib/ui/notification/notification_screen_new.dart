import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/notification_count_notifier.dart' as count_provider;
import 'package:sales_manager/ui/notification/notification_viewmodel.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final notificationCount = ref.watch(count_provider.notificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
        actions: [
          if (notificationCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$notificationCount pending',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(allNotificationsProvider);
            // Wait a bit for the refresh to complete
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: _buildBody(context, ref, textTheme, colorScheme),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final notificationsAsync = ref.watch(allNotificationsProvider);

    return notificationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _buildErrorState(
        context,
        ref,
        error.toString(),
        textTheme,
        colorScheme,
      ),
      data: (notifications) {
        if (notifications.isEmpty) {
          return _buildEmptyState(textTheme, colorScheme);
        }

        // Update notification count when data loads
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final pendingCount = notifications.where((n) => !n.isConfirmed).length;
          ref.read(count_provider.notificationCountProvider.notifier).state = pendingCount;
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: notifications.map((notification) {
              return _buildNotificationCard(
                context: context,
                ref: ref,
                notification: notification,
                textTheme: textTheme,
                colorScheme: colorScheme,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    String errorMessage,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load notifications',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(allNotificationsProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see approval requests here',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required WidgetRef ref,
    required NotificationItem notification,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.surface, width: 2),
        ),
        borderRadius: BorderRadius.circular(8),
        color: notification.isConfirmed
            ? colorScheme.surface.withValues(alpha: 0.5)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(notification.profileImageUrl),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.senderName,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.subject,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildNotificationTypeChip(
                        notification,
                        colorScheme,
                        textTheme,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      notification.formattedTime,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (notification.isConfirmed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Confirmed',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (!notification.isConfirmed) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _handleReject(context, ref, notification),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
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
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => _handleApprove(context, ref, notification),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
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
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTypeChip(
    NotificationItem notification,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final isProfileUpdate = notification.isProfileUpdate;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isProfileUpdate 
            ? Colors.blue.withValues(alpha: 0.2)
            : Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isProfileUpdate ? 'Profile Update' : 'Customer Creation',
        style: textTheme.labelSmall?.copyWith(
          color: isProfileUpdate ? Colors.blue[700] : Colors.orange[700],
        ),
      ),
    );
  }

  Future<void> _handleApprove(
    BuildContext context,
    WidgetRef ref,
    NotificationItem notification,
  ) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request'),
        content: Text(
          'Are you sure you want to approve ${notification.senderName}\'s ${notification.displaySubject.toLowerCase()}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(notificationConfirmationProvider.notifier)
          .confirmNotification(notification.id, 'approve');

      if (context.mounted) {
        if (success) {
          // Decrement the count
          final currentCount = ref.read(count_provider.notificationCountProvider);
          if (currentCount > 0) {
            ref.read(count_provider.notificationCountProvider.notifier).state = currentCount - 1;
          }
          showSnackBar(
            context,
            '${notification.senderName}\'s request has been approved',
            false,
          );
        } else {
          showSnackBar(
            context,
            'Failed to approve request. Please try again.',
            true,
          );
        }
      }
    }
  }

  Future<void> _handleReject(
    BuildContext context,
    WidgetRef ref,
    NotificationItem notification,
  ) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: Text(
          'Are you sure you want to reject ${notification.senderName}\'s ${notification.displaySubject.toLowerCase()}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(notificationConfirmationProvider.notifier)
          .confirmNotification(notification.id, 'reject');

      if (context.mounted) {
        if (success) {
          // Decrement the count
          final currentCount = ref.read(count_provider.notificationCountProvider);
          if (currentCount > 0) {
            ref.read(count_provider.notificationCountProvider.notifier).state = currentCount - 1;
          }
          showSnackBar(
            context,
            '${notification.senderName}\'s request has been rejected',
            false,
          );
        } else {
          showSnackBar(
            context,
            'Failed to reject request. Please try again.',
            true,
          );
        }
      }
    }
  }
}