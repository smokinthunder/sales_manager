// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingNotificationCountHash() =>
    r'58005964a791343dd805ae2b5888952591712f48';

/// Provider for easy access to pending notification count
///
/// Copied from [pendingNotificationCount].
@ProviderFor(pendingNotificationCount)
final pendingNotificationCountProvider = AutoDisposeProvider<int>.internal(
  pendingNotificationCount,
  name: r'pendingNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingNotificationCountRef = AutoDisposeProviderRef<int>;
String _$notificationNotifierHash() =>
    r'50925f77046bde31621fe7b9f7adf9cfdd75a8f0';

/// See also [NotificationNotifier].
@ProviderFor(NotificationNotifier)
final notificationNotifierProvider =
    AutoDisposeNotifierProvider<
      NotificationNotifier,
      NotificationState
    >.internal(
      NotificationNotifier.new,
      name: r'notificationNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationNotifier = AutoDisposeNotifier<NotificationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
