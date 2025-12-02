import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_dashboard/data/notification/remote/remote_notification_service.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

part 'notification_repository.g.dart';

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository();
}

class NotificationRepository {
  final RemoteNotificationService remoteNotificationService = RemoteNotificationService();
  final LoggerService logger = LoggerService();

  NotificationRepository() {
    logger.info('NotificationRepository initialized', 'NOTIFICATION_REPO');
  }

  /// Get all notifications for the current user
  Future<Result<List<Map<String, dynamic>>>> getNotifications({
    String? notificationType,
    bool? isConfirmed,
  }) async {
    logger.info('Repository: Fetching notifications', 'NOTIFICATION_REPO');
    return await remoteNotificationService.getNotifications(
      notificationType: notificationType,
      isConfirmed: isConfirmed,
    );
  }

  /// Get a specific notification by ID
  Future<Result<Map<String, dynamic>>> getNotification(String notificationId) async {
    logger.info('Repository: Fetching notification $notificationId', 'NOTIFICATION_REPO');
    return await remoteNotificationService.getNotification(notificationId);
  }

  /// Confirm (approve or reject) a notification
  Future<Result<Map<String, dynamic>>> confirmNotification({
    required String notificationId,
    required String action,
  }) async {
    logger.info('Repository: Confirming notification $notificationId with action: $action', 'NOTIFICATION_REPO');
    return await remoteNotificationService.confirmNotification(
      notificationId: notificationId,
      action: action,
    );
  }

  /// Get pending notifications count
  Future<Result<int>> getPendingNotificationsCount() async {
    logger.info('Repository: Fetching pending notifications count', 'NOTIFICATION_REPO');
    return await remoteNotificationService.getPendingNotificationsCount();
  }
}
