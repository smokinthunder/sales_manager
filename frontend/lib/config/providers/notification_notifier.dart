import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/notification/notification_remote_repository.dart';
import 'package:sales_manager/domain/models/notification/notification.dart';
import 'package:sales_manager/utils/result.dart';

part 'notification_notifier.g.dart';

class NotificationState {
  final List<AppNotification> notifications;
  final int pendingCount;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.pendingCount = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  NotificationState copyWith({
    List<AppNotification>? notifications,
    int? pendingCount,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      pendingCount: pendingCount ?? this.pendingCount,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
    );
  }
}

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(minutes: 1);

  @override
  NotificationState build() {
    // Start auto-refresh when the notifier is built
    _startAutoRefresh();
    // Load notifications immediately
    loadNotifications();
    return const NotificationState();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      refreshNotifications();
    });
  }

  /// Load notifications from the server
  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final repository = ref.read(notificationRemoteRepositoryProvider);
    final result = await repository.getNotifications();
    
    switch (result) {
      case Ok():
        final notifications = result.value
            .map((json) => AppNotification.fromJson(json))
            .toList();
        
        // Sort by creation date (newest first)
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        // Count pending notifications
        final pendingCount = notifications.where((n) => !n.isConfirmed).length;
        
        state = state.copyWith(
          notifications: notifications,
          pendingCount: pendingCount,
          isLoading: false,
          error: null,
        );
        break;
        
      case Error():
        state = state.copyWith(
          isLoading: false,
          error: result.error.toString(),
        );
        break;
    }
  }

  /// Refresh notifications (for pull-to-refresh)
  Future<void> refreshNotifications() async {
    state = state.copyWith(isRefreshing: true, error: null);
    
    final repository = ref.read(notificationRemoteRepositoryProvider);
    final result = await repository.getNotifications();
    
    switch (result) {
      case Ok():
        final notifications = result.value
            .map((json) => AppNotification.fromJson(json))
            .toList();
        
        // Sort by creation date (newest first)
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        // Count pending notifications
        final pendingCount = notifications.where((n) => !n.isConfirmed).length;
        
        state = state.copyWith(
          notifications: notifications,
          pendingCount: pendingCount,
          isRefreshing: false,
          error: null,
        );
        break;
        
      case Error():
        state = state.copyWith(
          isRefreshing: false,
          error: result.error.toString(),
        );
        break;
    }
  }

  /// Confirm a notification (approve or reject)
  Future<bool> confirmNotification(String notificationId, String action) async {
    final repository = ref.read(notificationRemoteRepositoryProvider);
    final result = await repository.confirmNotification(
      notificationId: notificationId,
      action: action,
    );
    
    switch (result) {
      case Ok():
        // Update the local state
        final updatedNotifications = state.notifications.map((notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(isConfirmed: true);
          }
          return notification;
        }).toList();
        
        final pendingCount = updatedNotifications.where((n) => !n.isConfirmed).length;
        
        state = state.copyWith(
          notifications: updatedNotifications,
          pendingCount: pendingCount,
        );
        
        return true;
        
      case Error():
        state = state.copyWith(error: result.error.toString());
        return false;
    }
  }

  /// Get pending notifications only
  List<AppNotification> get pendingNotifications =>
      state.notifications.where((n) => !n.isConfirmed).toList();

  /// Get confirmed notifications only
  List<AppNotification> get confirmedNotifications =>
      state.notifications.where((n) => n.isConfirmed).toList();

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for easy access to pending notification count
@riverpod
int pendingNotificationCount(Ref ref) {
  final notificationState = ref.watch(notificationNotifierProvider);
  return notificationState.pendingCount;
}