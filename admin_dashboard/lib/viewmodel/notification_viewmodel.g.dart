// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Main provider that fetches all notifications from the repository

@ProviderFor(allNotifications)
const allNotificationsProvider = AllNotificationsProvider._();

/// Main provider that fetches all notifications from the repository

final class AllNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationItem>>,
          List<NotificationItem>,
          FutureOr<List<NotificationItem>>
        >
    with
        $FutureModifier<List<NotificationItem>>,
        $FutureProvider<List<NotificationItem>> {
  /// Main provider that fetches all notifications from the repository
  const AllNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allNotificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<NotificationItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NotificationItem>> create(Ref ref) {
    return allNotifications(ref);
  }
}

String _$allNotificationsHash() => r'20fa05fc16e9defd8d2a717d4137b36084a59698';

/// Provider for pending notifications only

@ProviderFor(pendingNotifications)
const pendingNotificationsProvider = PendingNotificationsProvider._();

/// Provider for pending notifications only

final class PendingNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationItem>>,
          List<NotificationItem>,
          FutureOr<List<NotificationItem>>
        >
    with
        $FutureModifier<List<NotificationItem>>,
        $FutureProvider<List<NotificationItem>> {
  /// Provider for pending notifications only
  const PendingNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingNotificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<NotificationItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NotificationItem>> create(Ref ref) {
    return pendingNotifications(ref);
  }
}

String _$pendingNotificationsHash() =>
    r'76016abc6f46bfbe83a1ea041e362ce72fdb77b5';

/// Provider for confirmed notifications only

@ProviderFor(confirmedNotifications)
const confirmedNotificationsProvider = ConfirmedNotificationsProvider._();

/// Provider for confirmed notifications only

final class ConfirmedNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NotificationItem>>,
          List<NotificationItem>,
          FutureOr<List<NotificationItem>>
        >
    with
        $FutureModifier<List<NotificationItem>>,
        $FutureProvider<List<NotificationItem>> {
  /// Provider for confirmed notifications only
  const ConfirmedNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'confirmedNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$confirmedNotificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<NotificationItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NotificationItem>> create(Ref ref) {
    return confirmedNotifications(ref);
  }
}

String _$confirmedNotificationsHash() =>
    r'411bd5b36b8d8363ed8d1edff4456329a18ad5a9';

/// State notifier for handling notification actions

@ProviderFor(NotificationActions)
const notificationActionsProvider = NotificationActionsProvider._();

/// State notifier for handling notification actions
final class NotificationActionsProvider
    extends $AsyncNotifierProvider<NotificationActions, void> {
  /// State notifier for handling notification actions
  const NotificationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationActionsHash();

  @$internal
  @override
  NotificationActions create() => NotificationActions();
}

String _$notificationActionsHash() =>
    r'101a40efc6dab1fa78701385f29f6839827f312d';

/// State notifier for handling notification actions

abstract class _$NotificationActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
