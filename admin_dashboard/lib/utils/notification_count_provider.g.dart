// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notification count state notifier

@ProviderFor(NotificationCount)
const notificationCountProvider = NotificationCountProvider._();

/// Notification count state notifier
final class NotificationCountProvider
    extends $NotifierProvider<NotificationCount, int> {
  /// Notification count state notifier
  const NotificationCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationCountHash();

  @$internal
  @override
  NotificationCount create() => NotificationCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$notificationCountHash() => r'17f47b3438ac60387e5c5ce95d7d1af8670b0f4b';

/// Notification count state notifier

abstract class _$NotificationCount extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
