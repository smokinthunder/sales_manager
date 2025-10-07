import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_notification_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'notification_remote_repository.g.dart';

@Riverpod(keepAlive: true)
NotificationRemoteRepository notificationRemoteRepository(Ref<NotificationRemoteRepository> ref) {
  return NotificationRemoteRepository();
}

class NotificationRemoteRepository {
  final RemoteNotificationService remoteNotificationService = RemoteNotificationService();

  /// Get all notifications for the current user
  Future<Result<List<Map<String, dynamic>>>> getNotifications({
    String? notificationType,
    bool? isConfirmed,
  }) async => await remoteNotificationService.getNotifications(
    notificationType: notificationType,
    isConfirmed: isConfirmed,
  );

  /// Get a specific notification by ID
  Future<Result<Map<String, dynamic>>> getNotification(String notificationId) async =>
      await remoteNotificationService.getNotification(notificationId);

  /// Confirm (approve or reject) a notification
  Future<Result<Map<String, dynamic>>> confirmNotification({
    required String notificationId,
    required String action,
  }) async => await remoteNotificationService.confirmNotification(
    notificationId: notificationId,
    action: action,
  );

  /// Get pending notifications count
  Future<Result<int>> getPendingNotificationsCount() async =>
      await remoteNotificationService.getPendingNotificationsCount();
}