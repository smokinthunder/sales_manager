// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'executive_analytics_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTopTenCustomersHash() =>
    r'250f43f9e6a72a66e0a6d18a2053d2015ad61518';

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

/// See also [getTopTenCustomers].
@ProviderFor(getTopTenCustomers)
const getTopTenCustomersProvider = GetTopTenCustomersFamily();

/// See also [getTopTenCustomers].
class GetTopTenCustomersFamily extends Family<AsyncValue<List<String>>> {
  /// See also [getTopTenCustomers].
  const GetTopTenCustomersFamily();

  /// See also [getTopTenCustomers].
  GetTopTenCustomersProvider call({String? salesExecutiveId}) {
    return GetTopTenCustomersProvider(salesExecutiveId: salesExecutiveId);
  }

  @override
  GetTopTenCustomersProvider getProviderOverride(
    covariant GetTopTenCustomersProvider provider,
  ) {
    return call(salesExecutiveId: provider.salesExecutiveId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getTopTenCustomersProvider';
}

/// See also [getTopTenCustomers].
class GetTopTenCustomersProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [getTopTenCustomers].
  GetTopTenCustomersProvider({String? salesExecutiveId})
    : this._internal(
        (ref) => getTopTenCustomers(
          ref as GetTopTenCustomersRef,
          salesExecutiveId: salesExecutiveId,
        ),
        from: getTopTenCustomersProvider,
        name: r'getTopTenCustomersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getTopTenCustomersHash,
        dependencies: GetTopTenCustomersFamily._dependencies,
        allTransitiveDependencies:
            GetTopTenCustomersFamily._allTransitiveDependencies,
        salesExecutiveId: salesExecutiveId,
      );

  GetTopTenCustomersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.salesExecutiveId,
  }) : super.internal();

  final String? salesExecutiveId;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(GetTopTenCustomersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTopTenCustomersProvider._internal(
        (ref) => create(ref as GetTopTenCustomersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        salesExecutiveId: salesExecutiveId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _GetTopTenCustomersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTopTenCustomersProvider &&
        other.salesExecutiveId == salesExecutiveId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, salesExecutiveId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetTopTenCustomersRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `salesExecutiveId` of this provider.
  String? get salesExecutiveId;
}

class _GetTopTenCustomersProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with GetTopTenCustomersRef {
  _GetTopTenCustomersProviderElement(super.provider);

  @override
  String? get salesExecutiveId =>
      (origin as GetTopTenCustomersProvider).salesExecutiveId;
}

String _$getBestSellingProductsHash() =>
    r'64e3d02fba494e0a04c0967c342c7a77fafaac98';

/// See also [getBestSellingProducts].
@ProviderFor(getBestSellingProducts)
const getBestSellingProductsProvider = GetBestSellingProductsFamily();

/// See also [getBestSellingProducts].
class GetBestSellingProductsFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [getBestSellingProducts].
  const GetBestSellingProductsFamily();

  /// See also [getBestSellingProducts].
  GetBestSellingProductsProvider call({String? salesExecutiveId}) {
    return GetBestSellingProductsProvider(salesExecutiveId: salesExecutiveId);
  }

  @override
  GetBestSellingProductsProvider getProviderOverride(
    covariant GetBestSellingProductsProvider provider,
  ) {
    return call(salesExecutiveId: provider.salesExecutiveId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getBestSellingProductsProvider';
}

/// See also [getBestSellingProducts].
class GetBestSellingProductsProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [getBestSellingProducts].
  GetBestSellingProductsProvider({String? salesExecutiveId})
    : this._internal(
        (ref) => getBestSellingProducts(
          ref as GetBestSellingProductsRef,
          salesExecutiveId: salesExecutiveId,
        ),
        from: getBestSellingProductsProvider,
        name: r'getBestSellingProductsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$getBestSellingProductsHash,
        dependencies: GetBestSellingProductsFamily._dependencies,
        allTransitiveDependencies:
            GetBestSellingProductsFamily._allTransitiveDependencies,
        salesExecutiveId: salesExecutiveId,
      );

  GetBestSellingProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.salesExecutiveId,
  }) : super.internal();

  final String? salesExecutiveId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(
      GetBestSellingProductsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBestSellingProductsProvider._internal(
        (ref) => create(ref as GetBestSellingProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        salesExecutiveId: salesExecutiveId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _GetBestSellingProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBestSellingProductsProvider &&
        other.salesExecutiveId == salesExecutiveId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, salesExecutiveId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetBestSellingProductsRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `salesExecutiveId` of this provider.
  String? get salesExecutiveId;
}

class _GetBestSellingProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with GetBestSellingProductsRef {
  _GetBestSellingProductsProviderElement(super.provider);

  @override
  String? get salesExecutiveId =>
      (origin as GetBestSellingProductsProvider).salesExecutiveId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
