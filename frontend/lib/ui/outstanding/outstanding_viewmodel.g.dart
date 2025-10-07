// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outstanding_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allOutstandingPaymentsHash() =>
    r'eb17ba1f4c6d3aac50cae9d18d2bdaeebbcfa270';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Main provider that fetches all outstanding payments from the repository
///
/// Copied from [allOutstandingPayments].
@ProviderFor(allOutstandingPayments)
const allOutstandingPaymentsProvider = AllOutstandingPaymentsFamily();

/// Main provider that fetches all outstanding payments from the repository
///
/// Copied from [allOutstandingPayments].
class AllOutstandingPaymentsFamily
    extends Family<AsyncValue<List<OutstandingPaymentItem>>> {
  /// Main provider that fetches all outstanding payments from the repository
  ///
  /// Copied from [allOutstandingPayments].
  const AllOutstandingPaymentsFamily();

  /// Main provider that fetches all outstanding payments from the repository
  ///
  /// Copied from [allOutstandingPayments].
  AllOutstandingPaymentsProvider call({String? executiveId}) {
    return AllOutstandingPaymentsProvider(executiveId: executiveId);
  }

  @override
  AllOutstandingPaymentsProvider getProviderOverride(
    covariant AllOutstandingPaymentsProvider provider,
  ) {
    return call(executiveId: provider.executiveId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'allOutstandingPaymentsProvider';
}

/// Main provider that fetches all outstanding payments from the repository
///
/// Copied from [allOutstandingPayments].
class AllOutstandingPaymentsProvider
    extends AutoDisposeFutureProvider<List<OutstandingPaymentItem>> {
  /// Main provider that fetches all outstanding payments from the repository
  ///
  /// Copied from [allOutstandingPayments].
  AllOutstandingPaymentsProvider({String? executiveId})
    : this._internal(
        (ref) => allOutstandingPayments(
          ref as AllOutstandingPaymentsRef,
          executiveId: executiveId,
        ),
        from: allOutstandingPaymentsProvider,
        name: r'allOutstandingPaymentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$allOutstandingPaymentsHash,
        dependencies: AllOutstandingPaymentsFamily._dependencies,
        allTransitiveDependencies:
            AllOutstandingPaymentsFamily._allTransitiveDependencies,
        executiveId: executiveId,
      );

  AllOutstandingPaymentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.executiveId,
  }) : super.internal();

  final String? executiveId;

  @override
  Override overrideWith(
    FutureOr<List<OutstandingPaymentItem>> Function(
      AllOutstandingPaymentsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AllOutstandingPaymentsProvider._internal(
        (ref) => create(ref as AllOutstandingPaymentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        executiveId: executiveId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OutstandingPaymentItem>>
  createElement() {
    return _AllOutstandingPaymentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AllOutstandingPaymentsProvider &&
        other.executiveId == executiveId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, executiveId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AllOutstandingPaymentsRef
    on AutoDisposeFutureProviderRef<List<OutstandingPaymentItem>> {
  /// The parameter `executiveId` of this provider.
  String? get executiveId;
}

class _AllOutstandingPaymentsProviderElement
    extends AutoDisposeFutureProviderElement<List<OutstandingPaymentItem>>
    with AllOutstandingPaymentsRef {
  _AllOutstandingPaymentsProviderElement(super.provider);

  @override
  String? get executiveId =>
      (origin as AllOutstandingPaymentsProvider).executiveId;
}

String _$getAllSalesExecutivesHash() =>
    r'f5262c1d379f837dac167a152fdc23ade8cd803e';

/// Provider for sales executives (for area managers)
///
/// Copied from [getAllSalesExecutives].
@ProviderFor(getAllSalesExecutives)
final getAllSalesExecutivesProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
      getAllSalesExecutives,
      name: r'getAllSalesExecutivesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getAllSalesExecutivesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllSalesExecutivesRef =
    AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$getOutstandingPaymentsByStatusAndExecutiveHash() =>
    r'7292a2b9b17c6c745e9e5d2919ffeff9abb39142';

/// Provider for filtered outstanding payments by status and executive
///
/// Copied from [getOutstandingPaymentsByStatusAndExecutive].
@ProviderFor(getOutstandingPaymentsByStatusAndExecutive)
const getOutstandingPaymentsByStatusAndExecutiveProvider =
    GetOutstandingPaymentsByStatusAndExecutiveFamily();

/// Provider for filtered outstanding payments by status and executive
///
/// Copied from [getOutstandingPaymentsByStatusAndExecutive].
class GetOutstandingPaymentsByStatusAndExecutiveFamily
    extends Family<AsyncValue<List<List<String>>>> {
  /// Provider for filtered outstanding payments by status and executive
  ///
  /// Copied from [getOutstandingPaymentsByStatusAndExecutive].
  const GetOutstandingPaymentsByStatusAndExecutiveFamily();

  /// Provider for filtered outstanding payments by status and executive
  ///
  /// Copied from [getOutstandingPaymentsByStatusAndExecutive].
  GetOutstandingPaymentsByStatusAndExecutiveProvider call(
    CreditType status,
    String? executiveId,
  ) {
    return GetOutstandingPaymentsByStatusAndExecutiveProvider(
      status,
      executiveId,
    );
  }

  @override
  GetOutstandingPaymentsByStatusAndExecutiveProvider getProviderOverride(
    covariant GetOutstandingPaymentsByStatusAndExecutiveProvider provider,
  ) {
    return call(provider.status, provider.executiveId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getOutstandingPaymentsByStatusAndExecutiveProvider';
}

/// Provider for filtered outstanding payments by status and executive
///
/// Copied from [getOutstandingPaymentsByStatusAndExecutive].
class GetOutstandingPaymentsByStatusAndExecutiveProvider
    extends AutoDisposeFutureProvider<List<List<String>>> {
  /// Provider for filtered outstanding payments by status and executive
  ///
  /// Copied from [getOutstandingPaymentsByStatusAndExecutive].
  GetOutstandingPaymentsByStatusAndExecutiveProvider(
    CreditType status,
    String? executiveId,
  ) : this._internal(
        (ref) => getOutstandingPaymentsByStatusAndExecutive(
          ref as GetOutstandingPaymentsByStatusAndExecutiveRef,
          status,
          executiveId,
        ),
        from: getOutstandingPaymentsByStatusAndExecutiveProvider,
        name: r'getOutstandingPaymentsByStatusAndExecutiveProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getOutstandingPaymentsByStatusAndExecutiveHash,
        dependencies:
            GetOutstandingPaymentsByStatusAndExecutiveFamily._dependencies,
        allTransitiveDependencies:
            GetOutstandingPaymentsByStatusAndExecutiveFamily
                ._allTransitiveDependencies,
        status: status,
        executiveId: executiveId,
      );

  GetOutstandingPaymentsByStatusAndExecutiveProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.executiveId,
  }) : super.internal();

  final CreditType status;
  final String? executiveId;

  @override
  Override overrideWith(
    FutureOr<List<List<String>>> Function(
      GetOutstandingPaymentsByStatusAndExecutiveRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetOutstandingPaymentsByStatusAndExecutiveProvider._internal(
        (ref) => create(ref as GetOutstandingPaymentsByStatusAndExecutiveRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        executiveId: executiveId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<List<String>>> createElement() {
    return _GetOutstandingPaymentsByStatusAndExecutiveProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetOutstandingPaymentsByStatusAndExecutiveProvider &&
        other.status == status &&
        other.executiveId == executiveId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, executiveId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetOutstandingPaymentsByStatusAndExecutiveRef
    on AutoDisposeFutureProviderRef<List<List<String>>> {
  /// The parameter `status` of this provider.
  CreditType get status;

  /// The parameter `executiveId` of this provider.
  String? get executiveId;
}

class _GetOutstandingPaymentsByStatusAndExecutiveProviderElement
    extends AutoDisposeFutureProviderElement<List<List<String>>>
    with GetOutstandingPaymentsByStatusAndExecutiveRef {
  _GetOutstandingPaymentsByStatusAndExecutiveProviderElement(super.provider);

  @override
  CreditType get status =>
      (origin as GetOutstandingPaymentsByStatusAndExecutiveProvider).status;
  @override
  String? get executiveId =>
      (origin as GetOutstandingPaymentsByStatusAndExecutiveProvider)
          .executiveId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
