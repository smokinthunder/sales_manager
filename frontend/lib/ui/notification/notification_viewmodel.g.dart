// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allNotificationsHash() => r'814b1130a4a382d610b1bda452f60e5d9be727cd';

/// Main provider that fetches all notifications from the repository
///
/// Copied from [allNotifications].
@ProviderFor(allNotifications)
final allNotificationsProvider =
    AutoDisposeFutureProvider<List<NotificationItem>>.internal(
      allNotifications,
      name: r'allNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllNotificationsRef =
    AutoDisposeFutureProviderRef<List<NotificationItem>>;
String _$pendingNotificationsHash() =>
    r'76016abc6f46bfbe83a1ea041e362ce72fdb77b5';

/// Provider for pending notifications only
///
/// Copied from [pendingNotifications].
@ProviderFor(pendingNotifications)
final pendingNotificationsProvider =
    AutoDisposeFutureProvider<List<NotificationItem>>.internal(
      pendingNotifications,
      name: r'pendingNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingNotificationsRef =
    AutoDisposeFutureProviderRef<List<NotificationItem>>;
String _$confirmedNotificationsHash() =>
    r'411bd5b36b8d8363ed8d1edff4456329a18ad5a9';

/// Provider for confirmed notifications only
///
/// Copied from [confirmedNotifications].
@ProviderFor(confirmedNotifications)
final confirmedNotificationsProvider =
    AutoDisposeFutureProvider<List<NotificationItem>>.internal(
      confirmedNotifications,
      name: r'confirmedNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$confirmedNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConfirmedNotificationsRef =
    AutoDisposeFutureProviderRef<List<NotificationItem>>;
String _$shopCreationNotificationsHash() =>
    r'eaa7c0f47ee042276964e56f335ee035db5909b9';

/// Provider for shop creation notifications only (customer_creation type)
///
/// Copied from [shopCreationNotifications].
@ProviderFor(shopCreationNotifications)
final shopCreationNotificationsProvider =
    AutoDisposeFutureProvider<List<NotificationItem>>.internal(
      shopCreationNotifications,
      name: r'shopCreationNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shopCreationNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShopCreationNotificationsRef =
    AutoDisposeFutureProviderRef<List<NotificationItem>>;
String _$notificationCountAsyncHash() =>
    r'b952377d3b06ea68cafba91cd2364273b76161f5';

/// Provider for notification count (using async)
///
/// Copied from [notificationCountAsync].
@ProviderFor(notificationCountAsync)
final notificationCountAsyncProvider = AutoDisposeFutureProvider<int>.internal(
  notificationCountAsync,
  name: r'notificationCountAsyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationCountAsyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationCountAsyncRef = AutoDisposeFutureProviderRef<int>;
String _$notificationConfirmationHash() =>
    r'a38c0e60db4ceba0c194105199e26b28056a26d0';

/// Provider for handling notification confirmation
///
/// Copied from [NotificationConfirmation].
@ProviderFor(NotificationConfirmation)
final notificationConfirmationProvider =
    AutoDisposeNotifierProvider<
      NotificationConfirmation,
      AsyncValue<bool?>
    >.internal(
      NotificationConfirmation.new,
      name: r'notificationConfirmationProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationConfirmationHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationConfirmation = AutoDisposeNotifier<AsyncValue<bool?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
