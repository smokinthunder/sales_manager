// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'executive_analytics_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTopTenCustomersHash() =>
    r'eb5355cf44db6567e3c5aeb0d0c761639b3ce331';

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
class GetTopTenCustomersProvider extends FutureProvider<List<String>> {
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
  FutureProviderElement<List<String>> createElement() {
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
mixin GetTopTenCustomersRef on FutureProviderRef<List<String>> {
  /// The parameter `salesExecutiveId` of this provider.
  String? get salesExecutiveId;
}

class _GetTopTenCustomersProviderElement
    extends FutureProviderElement<List<String>>
    with GetTopTenCustomersRef {
  _GetTopTenCustomersProviderElement(super.provider);

  @override
  String? get salesExecutiveId =>
      (origin as GetTopTenCustomersProvider).salesExecutiveId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
