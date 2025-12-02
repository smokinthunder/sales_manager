import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:admin_dashboard/utils/notification_count_provider.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/viewmodel/notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Notifications extends ConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(allNotificationsProvider);
    final notificationCount = ref.watch(notificationCountProvider);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              Text("All notifications", style: theme.textTheme.bodyLarge),
              if (notificationCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$notificationCount pending',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              Spacer(),
              IconButton(
                onPressed: () {
                  ref.invalidate(allNotificationsProvider);
                },
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh notifications',
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: notificationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(context, ref, error.toString(), theme),
              data: (notifications) {
                if (notifications.isEmpty) {
                  return _buildEmptyState(theme);
                }

                // Update notification count
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final pendingCount = notifications.where((n) => !n.isConfirmed).length;
                  ref.read(notificationCountProvider.notifier).updateCount(pendingCount);
                });

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationCard(context, ref, notification, theme);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Failed to load notifications', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(error, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(allNotificationsProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: theme.colorScheme.onSurface.withAlpha(153)),
          const SizedBox(height: 16),
          Text('No notifications', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'You\'ll see approval requests here',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(153)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, WidgetRef ref, NotificationItem notification, ThemeData theme) {
    if (notification.isProfileUpdate) {
      return ProfileEditingRequest(
        notification: notification,
        onApprove: () => _handleApprove(context, ref, notification),
        onReject: () => _handleReject(context, ref, notification),
        onDismiss: () {},
      );
    } else {
      // For customer creation or other types, use a generic card
      return CustomerCreationCard(
        notification: notification,
        onApprove: () => _handleApprove(context, ref, notification),
        onReject: () => _handleReject(context, ref, notification),
        onDismiss: () {},
      );
    }
  }

  Future<void> _handleApprove(BuildContext context, WidgetRef ref, NotificationItem notification) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Request'),
        content: Text('Are you sure you want to approve ${notification.senderName}\'s ${notification.displaySubject.toLowerCase()}?'),
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
      final result = await ref.read(notificationActionsProvider.notifier).approveNotification(notification.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result is Ok ? '${notification.senderName}\'s request has been approved' : 'Failed to approve request'),
            backgroundColor: result is Ok ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleReject(BuildContext context, WidgetRef ref, NotificationItem notification) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: Text('Are you sure you want to reject ${notification.senderName}\'s ${notification.displaySubject.toLowerCase()}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await ref.read(notificationActionsProvider.notifier).rejectNotification(notification.id);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result is Ok ? '${notification.senderName}\'s request has been rejected' : 'Failed to reject request'),
            backgroundColor: result is Ok ? Colors.orange : Colors.red,
          ),
        );
      }
    }
  }
}

class NotPlacingOrNotVistedCard extends StatelessWidget {
  const NotPlacingOrNotVistedCard({
    super.key,
    required this.onDismiss,
    required this.shopName,
    required this.executiveName,
    this.reasonForEvent,
    this.isNotplacing = false,
  });
  final VoidCallback onDismiss;
  final String shopName;
  final String executiveName;
  final String? reasonForEvent;
  final bool isNotplacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isNotplacing
                    ? "Reason for not placing order"
                    : "Not Visited Shops",
                style: theme.textTheme.bodyLarge,
              ),
              Spacer(),
              IconButton(onPressed: onDismiss, icon: Icon(Icons.close)),
            ],
          ),
          Text(
            shopName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          IconTheme.merge(
            data: IconThemeData(size: 36),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(),
              expandedAlignment: Alignment.topLeft,
              tilePadding: EdgeInsets.only(right: 4),
              title: Text(executiveName, style: theme.textTheme.labelLarge),
              children: [
                if (reasonForEvent != null) Text(reasonForEvent!.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileEditingRequest extends StatelessWidget {
  const ProfileEditingRequest({
    super.key,
    required this.notification,
    required this.onDismiss,
    required this.onApprove,
    required this.onReject,
  });
  final NotificationItem notification;
  final VoidCallback onDismiss;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final changes = _parseChangesFromRelatedData(notification.relatedData);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isConfirmed ? Colors.grey.withAlpha(51) : Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Profile Editing Request", style: theme.textTheme.bodyLarge),
              if (notification.isConfirmed)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(51),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Confirmed',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.green[700]),
                    ),
                  ),
                ),
              Spacer(),
              Text(
                notification.formattedTime,
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface),
              ),
              IconButton(onPressed: onDismiss, icon: Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification.senderName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(notification.subject, style: theme.textTheme.labelLarge),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(
              color: theme.colorScheme.onSurface.withAlpha(38),
              height: 2,
            ),
          ),
          Column(
            children: [
              ...changes.map(
                (e) => ExpansionTile(
                  tilePadding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(),
                  expandedAlignment: Alignment.topLeft,
                  title: Row(
                    children: [
                      Text(
                        "${e.changeType}: ",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        e.newValue,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          copyToClipBoard(context, e.newValue);
                        },
                        icon: Icon(
                          Icons.copy,
                          color: theme.colorScheme.tertiary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    InkWell(
                      onTap: () {
                        copyToClipBoard(context, e.oldValue);
                      },
                      child: Row(
                        children: [
                          Text(
                            "Old ${e.changeType}:\t\t\t",
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            e.oldValue,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isConfirmed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlueBorderButtons(
                      title: "Reject",
                      onClick: onReject,
                    ),
                    const SizedBox(width: 8),
                    BlueBorderButtons(
                      title: "Approve",
                      onClick: onApprove,
                      invert: true,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<DataChange> _parseChangesFromRelatedData(Map<String, dynamic> relatedData) {
    final List<DataChange> changes = [];
    
    // Parse changes from related_data
    // Expected format: {"field_name": {"old": "old_value", "new": "new_value"}}
    relatedData.forEach((key, value) {
      if (value is Map && value.containsKey('old') && value.containsKey('new')) {
        changes.add(DataChange(
          changeType: _formatFieldName(key),
          oldValue: value['old'].toString(),
          newValue: value['new'].toString(),
        ));
      }
    });
    
    return changes;
  }

  String _formatFieldName(String fieldName) {
    // Convert snake_case to Title Case
    return fieldName
        .split('_')
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  void copyToClipBoard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied $value to clipboard, Use Ctrl + V to paste"),
      ),
    );
  }
}

// CustomerCreationCard widget for customer creation notifications
class CustomerCreationCard extends StatelessWidget {
  const CustomerCreationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
    required this.onApprove,
    required this.onReject,
  });
  
  final NotificationItem notification;
  final VoidCallback onDismiss;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isConfirmed ? Colors.grey.withAlpha(51) : Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(notification.displaySubject, style: theme.textTheme.bodyLarge),
              if (notification.isConfirmed)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(51),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Confirmed',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.green[700]),
                    ),
                  ),
                ),
              Spacer(),
              Text(
                notification.formattedTime,
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface),
              ),
              IconButton(onPressed: onDismiss, icon: Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification.senderName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(notification.subject, style: theme.textTheme.labelLarge),
          if (!notification.isConfirmed) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlueBorderButtons(
                  title: "Reject",
                  onClick: onReject,
                ),
                const SizedBox(width: 8),
                BlueBorderButtons(
                  title: "Approve",
                  onClick: onApprove,
                  invert: true,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class DataChange {
  final String changeType;
  final String oldValue;
  final String newValue;
  const DataChange({
    required this.changeType,
    required this.oldValue,
    required this.newValue,
  });
}
