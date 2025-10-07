// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingNotificationCountHash() =>
    r'867685a7e9f5c12a4b8f28325a056d19e81bb522';

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
    r'f7728db8549a501508e651d2613d5161ae1ac3e4';

/// See also [NotificationNotifier].
@ProviderFor(NotificationNotifier)
final notificationNotifierProvider =
    NotifierProvider<NotificationNotifier, NotificationState>.internal(
      NotificationNotifier.new,
      name: r'notificationNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationNotifier = Notifier<NotificationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
