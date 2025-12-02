import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_dashboard/data/notification/notification_repository.dart';
import 'package:admin_dashboard/domain/models/notification/notification.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

part 'notification_viewmodel.g.dart';

/// Logger instance for notification viewmodel
final _logger = LoggerService();

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
  final Map<String, dynamic> relatedData;

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
    required this.relatedData,
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
      relatedData: notification.relatedData,
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
    Map<String, dynamic>? relatedData,
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
      relatedData: relatedData ?? this.relatedData,
    );
  }

  /// Check if this is a profile update notification
  bool get isProfileUpdate => notificationType.contains('profile');
}

/// Main provider that fetches all notifications from the repository
@riverpod
Future<List<NotificationItem>> allNotifications(Ref ref) async {
  _logger.info('Fetching all notifications', 'NOTIFICATION_VM');
  
  final repository = ref.read(notificationRepositoryProvider);
  final result = await repository.getNotifications();

  switch (result) {
    case Ok():
      _logger.info('Successfully loaded ${result.value.length} notifications', 'NOTIFICATION_VM');
      return result.value
          .map<AppNotification>((json) => AppNotification.fromJson(json))
          .map<NotificationItem>((notification) => NotificationItem.fromAppNotification(notification))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort by newest first
    case Error():
      _logger.error('Failed to load notifications: ${result.error}', 'NOTIFICATION_VM', result.error);
      throw Exception('Failed to load notifications: ${result.error}');
  }
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

/// State notifier for handling notification actions
@riverpod
class NotificationActions extends _$NotificationActions {
  @override
  FutureOr<void> build() {}

  /// Approve a notification
  Future<Result<void>> approveNotification(String notificationId) async {
    _logger.info('Approving notification: $notificationId', 'NOTIFICATION_VM');
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final result = await repository.confirmNotification(
        notificationId: notificationId,
        action: 'approve',
      );

      state = const AsyncData(null);

      // Refresh notifications list after approval
      switch (result) {
        case Ok():
          _logger.info('Notification $notificationId approved successfully', 'NOTIFICATION_VM');
          ref.invalidate(allNotificationsProvider);
          return Result.ok(null);
        case Error():
          _logger.error('Failed to approve notification $notificationId', 'NOTIFICATION_VM', result.error);
          return Result.error(result.error);
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error approving notification $notificationId', 'NOTIFICATION_VM', e, stackTrace);
      state = AsyncError(e, stackTrace);
      return Result.error(Exception('Failed to approve notification'));
    }
  }

  /// Reject a notification
  Future<Result<void>> rejectNotification(String notificationId) async {
    _logger.info('Rejecting notification: $notificationId', 'NOTIFICATION_VM');
    state = const AsyncLoading();
    
    try {
      final repository = ref.read(notificationRepositoryProvider);
      final result = await repository.confirmNotification(
        notificationId: notificationId,
        action: 'reject',
      );

      state = const AsyncData(null);

      // Refresh notifications list after rejection
      switch (result) {
        case Ok():
          _logger.info('Notification $notificationId rejected successfully', 'NOTIFICATION_VM');
          ref.invalidate(allNotificationsProvider);
          return Result.ok(null);
        case Error():
          _logger.error('Failed to reject notification $notificationId', 'NOTIFICATION_VM', result.error);
          return Result.error(result.error);
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error rejecting notification $notificationId', 'NOTIFICATION_VM', e, stackTrace);
      state = AsyncError(e, stackTrace);
      return Result.error(Exception('Failed to reject notification'));
    }
  }
}
