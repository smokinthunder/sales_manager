// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Data repository for managing users, shops, and analytics
///
/// This repository provides a clean abstraction over the remote data service,
/// adding additional logging and error handling at the repository layer.
/// Following the same pattern as NotificationRepository.

@ProviderFor(DataRepository)
const dataRepositoryProvider = DataRepositoryProvider._();

/// Data repository for managing users, shops, and analytics
///
/// This repository provides a clean abstraction over the remote data service,
/// adding additional logging and error handling at the repository layer.
/// Following the same pattern as NotificationRepository.
final class DataRepositoryProvider
    extends $AsyncNotifierProvider<DataRepository, void> {
  /// Data repository for managing users, shops, and analytics
  ///
  /// This repository provides a clean abstraction over the remote data service,
  /// adding additional logging and error handling at the repository layer.
  /// Following the same pattern as NotificationRepository.
  const DataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataRepositoryHash();

  @$internal
  @override
  DataRepository create() => DataRepository();
}

String _$dataRepositoryHash() => r'1555c736ceeac3375df75e682ca80894f351aba1';

/// Data repository for managing users, shops, and analytics
///
/// This repository provides a clean abstraction over the remote data service,
/// adding additional logging and error handling at the repository layer.
/// Following the same pattern as NotificationRepository.

abstract class _$DataRepository extends $AsyncNotifier<void> {
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
