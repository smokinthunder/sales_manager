import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/notification/notification_remote_repository.dart';
import 'package:sales_manager/domain/models/notification/notification.dart';
import 'package:sales_manager/utils/result.dart';

part 'notification_viewmodel.g.dart';

/// Data class to represent notification UI state
class NotificationItem {
  final String id;
  final String senderName;
  final String subject;
  final String displaySubject;
  final String notificationType;
  final String profileImageUrl;
  final String formattedTime;
  final DateTime createdAt;
  final bool isConfirmed;

  const NotificationItem({
    required this.id,
    required this.senderName,
    required this.subject,
    required this.displaySubject,
    required this.notificationType,
    required this.profileImageUrl,
    required this.formattedTime,
    required this.createdAt,
    required this.isConfirmed,
  });

  /// Factory constructor to create from AppNotification
  factory NotificationItem.fromAppNotification(AppNotification notification) {
    return NotificationItem(
      id: notification.id,
      senderName: notification.senderName,
      subject: notification.subject,
      displaySubject: notification.displaySubject,
      notificationType: notification.notificationType.toString(),
      profileImageUrl: notification.profileImageUrl,
      formattedTime: notification.formattedTime,
      createdAt: notification.createdAt,
      isConfirmed: notification.isConfirmed,
    );
  }

  /// Create a copy with updated fields
  NotificationItem copyWith({
    String? id,
    String? senderName,
    String? subject,
    String? displaySubject,
    String? notificationType,
    String? profileImageUrl,
    String? formattedTime,
    DateTime? createdAt,
    bool? isConfirmed,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      subject: subject ?? this.subject,
      displaySubject: displaySubject ?? this.displaySubject,
      notificationType: notificationType ?? this.notificationType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      formattedTime: formattedTime ?? this.formattedTime,
      createdAt: createdAt ?? this.createdAt,
      isConfirmed: isConfirmed ?? this.isConfirmed,
    );
  }

  /// Check if this is a profile update notification
  bool get isProfileUpdate => notificationType.contains('profile');
}

/// Main provider that fetches all notifications from the repository
@riverpod
Future<List<NotificationItem>> allNotifications(Ref ref) async {
  final repository = ref.read(notificationRemoteRepositoryProvider);
  final result = await repository.getNotifications();

  return switch (result) {
    Ok() => result.value
        .map<AppNotification>((json) => AppNotification.fromJson(json))
        .map<NotificationItem>((notification) => NotificationItem.fromAppNotification(notification))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)), // Sort by newest first
    Error() => throw Exception('Failed to load notifications: ${result.error}'),
  };
}

/// Provider for pending notifications only
@riverpod
Future<List<NotificationItem>> pendingNotifications(Ref ref) async {
  final notifications = await ref.watch(allNotificationsProvider.future);
  return notifications.where((notification) => !notification.isConfirmed).toList();
}

/// Provider for confirmed notifications only
@riverpod
Future<List<NotificationItem>> confirmedNotifications(Ref ref) async {
  final notifications = await ref.watch(allNotificationsProvider.future);
  return notifications.where((notification) => notification.isConfirmed).toList();
}

/// Provider for shop creation notifications only (customer_creation type)
@riverpod
Future<List<NotificationItem>> shopCreationNotifications(Ref ref) async {
  final notifications = await ref.watch(allNotificationsProvider.future);
  return notifications.where((notification) => 
    notification.notificationType.contains('customer_creation') && !notification.isConfirmed
  ).toList();
}

/// Provider for notification count (using async)
@riverpod
Future<int> notificationCountAsync(Ref ref) async {
  final notifications = await ref.watch(pendingNotificationsProvider.future);
  return notifications.length;
}

/// Provider for handling notification confirmation
@riverpod
class NotificationConfirmation extends _$NotificationConfirmation {
  @override
  AsyncValue<bool?> build() {
    return const AsyncValue.data(null);
  }

  /// Confirm a notification (approve or reject)
  Future<bool> confirmNotification(String notificationId, String action) async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(notificationRemoteRepositoryProvider);
    final result = await repository.confirmNotification(
      notificationId: notificationId,
      action: action,
    );
    
    switch (result) {
      case Ok():
        state = const AsyncValue.data(true);
        // Refresh notifications after successful confirmation
        ref.invalidate(allNotificationsProvider);
        return true;
        
      case Error():
        state = AsyncValue.error(result.error, StackTrace.current);
        return false;
    }
  }

  /// Clear the confirmation state
  void clearState() {
    state = const AsyncValue.data(null);
  }
}

/// Extension to add refresh functionality
extension NotificationViewModelX on Ref {
  /// Refresh all notifications data
  void refreshNotifications() {
    invalidate(allNotificationsProvider);
  }

  /// Refresh pending notifications
  void refreshPendingNotifications() {
    invalidate(pendingNotificationsProvider);
  }

  /// Refresh confirmed notifications
  void refreshConfirmedNotifications() {
    invalidate(confirmedNotificationsProvider);
  }
}