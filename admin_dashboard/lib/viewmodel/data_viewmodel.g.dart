// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel for managing users, shops, and analytics data
///
/// Provides Riverpod providers for accessing data throughout the app.
/// Converts Result types to either data or exceptions for easier UI consumption.
// ==================== USER PROVIDERS ====================
/// Fetch users with optional filters
///
/// Parameters:
/// - [role]: Filter by user role (e.g., 'sales_executive', 'area_manager')
/// - [status]: Filter by user status (e.g., 'active', 'inactive')
/// - [search]: Search query for name, email, or phone
///
/// Returns List<AppUser> or throws Exception on error

@ProviderFor(users)
const usersProvider = UsersFamily._();

/// ViewModel for managing users, shops, and analytics data
///
/// Provides Riverpod providers for accessing data throughout the app.
/// Converts Result types to either data or exceptions for easier UI consumption.
// ==================== USER PROVIDERS ====================
/// Fetch users with optional filters
///
/// Parameters:
/// - [role]: Filter by user role (e.g., 'sales_executive', 'area_manager')
/// - [status]: Filter by user status (e.g., 'active', 'inactive')
/// - [search]: Search query for name, email, or phone
///
/// Returns List<AppUser> or throws Exception on error

final class UsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppUser>>,
          List<AppUser>,
          FutureOr<List<AppUser>>
        >
    with $FutureModifier<List<AppUser>>, $FutureProvider<List<AppUser>> {
  /// ViewModel for managing users, shops, and analytics data
  ///
  /// Provides Riverpod providers for accessing data throughout the app.
  /// Converts Result types to either data or exceptions for easier UI consumption.
  // ==================== USER PROVIDERS ====================
  /// Fetch users with optional filters
  ///
  /// Parameters:
  /// - [role]: Filter by user role (e.g., 'sales_executive', 'area_manager')
  /// - [status]: Filter by user status (e.g., 'active', 'inactive')
  /// - [search]: Search query for name, email, or phone
  ///
  /// Returns List<AppUser> or throws Exception on error
  const UsersProvider._({
    required UsersFamily super.from,
    required ({String? role, String? status, String? search}) super.argument,
  }) : super(
         retry: null,
         name: r'usersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersHash();

  @override
  String toString() {
    return r'usersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AppUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppUser>> create(Ref ref) {
    final argument =
        this.argument as ({String? role, String? status, String? search});
    return users(
      ref,
      role: argument.role,
      status: argument.status,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UsersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersHash() => r'b090bf30b78fb4511303c2f8d4aae79858eb3ba0';

/// ViewModel for managing users, shops, and analytics data
///
/// Provides Riverpod providers for accessing data throughout the app.
/// Converts Result types to either data or exceptions for easier UI consumption.
// ==================== USER PROVIDERS ====================
/// Fetch users with optional filters
///
/// Parameters:
/// - [role]: Filter by user role (e.g., 'sales_executive', 'area_manager')
/// - [status]: Filter by user status (e.g., 'active', 'inactive')
/// - [search]: Search query for name, email, or phone
///
/// Returns List<AppUser> or throws Exception on error

final class UsersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AppUser>>,
          ({String? role, String? status, String? search})
        > {
  const UsersFamily._()
    : super(
        retry: null,
        name: r'usersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// ViewModel for managing users, shops, and analytics data
  ///
  /// Provides Riverpod providers for accessing data throughout the app.
  /// Converts Result types to either data or exceptions for easier UI consumption.
  // ==================== USER PROVIDERS ====================
  /// Fetch users with optional filters
  ///
  /// Parameters:
  /// - [role]: Filter by user role (e.g., 'sales_executive', 'area_manager')
  /// - [status]: Filter by user status (e.g., 'active', 'inactive')
  /// - [search]: Search query for name, email, or phone
  ///
  /// Returns List<AppUser> or throws Exception on error

  UsersProvider call({String? role, String? status, String? search}) =>
      UsersProvider._(
        argument: (role: role, status: status, search: search),
        from: this,
      );

  @override
  String toString() => r'usersProvider';
}

/// Fetch a single user by ID
///
/// Parameters:
/// - [userId]: The ID of the user to fetch
///
/// Returns Map<String, dynamic> (raw user data) or throws Exception on error

@ProviderFor(userById)
const userByIdProvider = UserByIdFamily._();

/// Fetch a single user by ID
///
/// Parameters:
/// - [userId]: The ID of the user to fetch
///
/// Returns Map<String, dynamic> (raw user data) or throws Exception on error

final class UserByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch a single user by ID
  ///
  /// Parameters:
  /// - [userId]: The ID of the user to fetch
  ///
  /// Returns Map<String, dynamic> (raw user data) or throws Exception on error
  const UserByIdProvider._({
    required UserByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'userByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userByIdHash();

  @override
  String toString() {
    return r'userByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as int;
    return userById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userByIdHash() => r'b54ee06455ab2c48168019e4f2d61cfa498d9602';

/// Fetch a single user by ID
///
/// Parameters:
/// - [userId]: The ID of the user to fetch
///
/// Returns Map<String, dynamic> (raw user data) or throws Exception on error

final class UserByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, int> {
  const UserByIdFamily._()
    : super(
        retry: null,
        name: r'userByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch a single user by ID
  ///
  /// Parameters:
  /// - [userId]: The ID of the user to fetch
  ///
  /// Returns Map<String, dynamic> (raw user data) or throws Exception on error

  UserByIdProvider call(int userId) =>
      UserByIdProvider._(argument: userId, from: this);

  @override
  String toString() => r'userByIdProvider';
}

/// Fetch shops/customers with optional filters
///
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status (e.g., 'active', 'inactive')
///
/// Returns List<Shop> or throws Exception on error

@ProviderFor(shops)
const shopsProvider = ShopsFamily._();

/// Fetch shops/customers with optional filters
///
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status (e.g., 'active', 'inactive')
///
/// Returns List<Shop> or throws Exception on error

final class ShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  /// Fetch shops/customers with optional filters
  ///
  /// Parameters:
  /// - [territoryId]: Filter by territory ID
  /// - [status]: Filter by shop status (e.g., 'active', 'inactive')
  ///
  /// Returns List<Shop> or throws Exception on error
  const ShopsProvider._({
    required ShopsFamily super.from,
    required ({int? territoryId, String? status}) super.argument,
  }) : super(
         retry: null,
         name: r'shopsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopsHash();

  @override
  String toString() {
    return r'shopsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Shop>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shop>> create(Ref ref) {
    final argument = this.argument as ({int? territoryId, String? status});
    return shops(
      ref,
      territoryId: argument.territoryId,
      status: argument.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShopsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopsHash() => r'ec22885e8d1482674cffbc679f639973d914233e';

/// Fetch shops/customers with optional filters
///
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status (e.g., 'active', 'inactive')
///
/// Returns List<Shop> or throws Exception on error

final class ShopsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Shop>>,
          ({int? territoryId, String? status})
        > {
  const ShopsFamily._()
    : super(
        retry: null,
        name: r'shopsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch shops/customers with optional filters
  ///
  /// Parameters:
  /// - [territoryId]: Filter by territory ID
  /// - [status]: Filter by shop status (e.g., 'active', 'inactive')
  ///
  /// Returns List<Shop> or throws Exception on error

  ShopsProvider call({int? territoryId, String? status}) => ShopsProvider._(
    argument: (territoryId: territoryId, status: status),
    from: this,
  );

  @override
  String toString() => r'shopsProvider';
}

/// Fetch a single shop by shop_id
///
/// Parameters:
/// - [shopId]: The shop_id (string) of the shop to fetch
///
/// Returns Map<String, dynamic> (raw shop data) or throws Exception on error

@ProviderFor(shopById)
const shopByIdProvider = ShopByIdFamily._();

/// Fetch a single shop by shop_id
///
/// Parameters:
/// - [shopId]: The shop_id (string) of the shop to fetch
///
/// Returns Map<String, dynamic> (raw shop data) or throws Exception on error

final class ShopByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch a single shop by shop_id
  ///
  /// Parameters:
  /// - [shopId]: The shop_id (string) of the shop to fetch
  ///
  /// Returns Map<String, dynamic> (raw shop data) or throws Exception on error
  const ShopByIdProvider._({
    required ShopByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shopByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopByIdHash();

  @override
  String toString() {
    return r'shopByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument = this.argument as String;
    return shopById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopByIdHash() => r'07d460d993307295778e447a9586cb18d5743e23';

/// Fetch a single shop by shop_id
///
/// Parameters:
/// - [shopId]: The shop_id (string) of the shop to fetch
///
/// Returns Map<String, dynamic> (raw shop data) or throws Exception on error

final class ShopByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, String> {
  const ShopByIdFamily._()
    : super(
        retry: null,
        name: r'shopByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch a single shop by shop_id
  ///
  /// Parameters:
  /// - [shopId]: The shop_id (string) of the shop to fetch
  ///
  /// Returns Map<String, dynamic> (raw shop data) or throws Exception on error

  ShopByIdProvider call(String shopId) =>
      ShopByIdProvider._(argument: shopId, from: this);

  @override
  String toString() => r'shopByIdProvider';
}

/// Fetch top customers analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<TopCustomer> or throws Exception on error

@ProviderFor(topCustomers)
const topCustomersProvider = TopCustomersFamily._();

/// Fetch top customers analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<TopCustomer> or throws Exception on error

final class TopCustomersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TopCustomer>>,
          List<TopCustomer>,
          FutureOr<List<TopCustomer>>
        >
    with
        $FutureModifier<List<TopCustomer>>,
        $FutureProvider<List<TopCustomer>> {
  /// Fetch top customers analytics
  ///
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  ///
  /// Returns List<TopCustomer> or throws Exception on error
  const TopCustomersProvider._({
    required TopCustomersFamily super.from,
    required ({
      int? salesExecutiveId,
      int? areaManagerId,
      String? startDate,
      String? endDate,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'topCustomersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$topCustomersHash();

  @override
  String toString() {
    return r'topCustomersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TopCustomer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TopCustomer>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? salesExecutiveId,
              int? areaManagerId,
              String? startDate,
              String? endDate,
            });
    return topCustomers(
      ref,
      salesExecutiveId: argument.salesExecutiveId,
      areaManagerId: argument.areaManagerId,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TopCustomersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topCustomersHash() => r'a004834fdbe3f3a52fdbc2599ccaac087b2254f8';

/// Fetch top customers analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<TopCustomer> or throws Exception on error

final class TopCustomersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TopCustomer>>,
          ({
            int? salesExecutiveId,
            int? areaManagerId,
            String? startDate,
            String? endDate,
          })
        > {
  const TopCustomersFamily._()
    : super(
        retry: null,
        name: r'topCustomersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch top customers analytics
  ///
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  ///
  /// Returns List<TopCustomer> or throws Exception on error

  TopCustomersProvider call({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) => TopCustomersProvider._(
    argument: (
      salesExecutiveId: salesExecutiveId,
      areaManagerId: areaManagerId,
      startDate: startDate,
      endDate: endDate,
    ),
    from: this,
  );

  @override
  String toString() => r'topCustomersProvider';
}

/// Fetch best selling products analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<BestSellingProduct> or throws Exception on error

@ProviderFor(bestSellingProducts)
const bestSellingProductsProvider = BestSellingProductsFamily._();

/// Fetch best selling products analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<BestSellingProduct> or throws Exception on error

final class BestSellingProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BestSellingProduct>>,
          List<BestSellingProduct>,
          FutureOr<List<BestSellingProduct>>
        >
    with
        $FutureModifier<List<BestSellingProduct>>,
        $FutureProvider<List<BestSellingProduct>> {
  /// Fetch best selling products analytics
  ///
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  ///
  /// Returns List<BestSellingProduct> or throws Exception on error
  const BestSellingProductsProvider._({
    required BestSellingProductsFamily super.from,
    required ({
      int? salesExecutiveId,
      int? areaManagerId,
      String? startDate,
      String? endDate,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'bestSellingProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bestSellingProductsHash();

  @override
  String toString() {
    return r'bestSellingProductsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<BestSellingProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BestSellingProduct>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? salesExecutiveId,
              int? areaManagerId,
              String? startDate,
              String? endDate,
            });
    return bestSellingProducts(
      ref,
      salesExecutiveId: argument.salesExecutiveId,
      areaManagerId: argument.areaManagerId,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BestSellingProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bestSellingProductsHash() =>
    r'ad8d3190e49dbd1936e7f927fbde3dde6f5e3835';

/// Fetch best selling products analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<BestSellingProduct> or throws Exception on error

final class BestSellingProductsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BestSellingProduct>>,
          ({
            int? salesExecutiveId,
            int? areaManagerId,
            String? startDate,
            String? endDate,
          })
        > {
  const BestSellingProductsFamily._()
    : super(
        retry: null,
        name: r'bestSellingProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch best selling products analytics
  ///
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  ///
  /// Returns List<BestSellingProduct> or throws Exception on error

  BestSellingProductsProvider call({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) => BestSellingProductsProvider._(
    argument: (
      salesExecutiveId: salesExecutiveId,
      areaManagerId: areaManagerId,
      startDate: startDate,
      endDate: endDate,
    ),
    from: this,
  );

  @override
  String toString() => r'bestSellingProductsProvider';
}

/// Fetch sales report analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<SalesDataPoint> or throws Exception on error

@ProviderFor(salesReport)
const salesReportProvider = SalesReportFamily._();

/// Fetch sales report analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<SalesDataPoint> or throws Exception on error

final class SalesReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SalesDataPoint>>,
          List<SalesDataPoint>,
          FutureOr<List<SalesDataPoint>>
        >
    with
        $FutureModifier<List<SalesDataPoint>>,
        $FutureProvider<List<SalesDataPoint>> {
  /// Fetch sales report analytics
  ///
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  ///
  /// Returns List<SalesDataPoint> or throws Exception on error
  const SalesReportProvider._({
    required SalesReportFamily super.from,
    required ({
      int? salesExecutiveId,
      int? areaManagerId,
      String? startDate,
      String? endDate,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'salesReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesReportHash();

  @override
  String toString() {
    return r'salesReportProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<SalesDataPoint>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SalesDataPoint>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? salesExecutiveId,
              int? areaManagerId,
              String? startDate,
              String? endDate,
            });
    return salesReport(
      ref,
      salesExecutiveId: argument.salesExecutiveId,
      areaManagerId: argument.areaManagerId,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalesReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesReportHash() => r'9af286cdef7f85508884dbce1f1835de0e10e256';

/// Fetch sales report analytics
///
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
///
/// Returns List<SalesDataPoint> or throws Exception on error

final class SalesReportFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SalesDataPoint>>,
          ({
            int? salesExecutiveId,
            int? areaManagerId,
            String? startDate,
            String? endDate,
          })
        > {
  const SalesReportFamily._()
    : super(
        retry: null,
        name: r'salesReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch sales report analytics
  ///
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  ///
  /// Returns List<SalesDataPoint> or throws Exception on error

  SalesReportProvider call({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) => SalesReportProvider._(
    argument: (
      salesExecutiveId: salesExecutiveId,
      areaManagerId: areaManagerId,
      startDate: startDate,
      endDate: endDate,
    ),
    from: this,
  );

  @override
  String toString() => r'salesReportProvider';
}

/// Compute dashboard statistics from users and shops data
///
/// This provider aggregates data from multiple sources to create
/// a complete dashboard statistics view.
///
/// Returns DashboardStats or throws Exception on error

@ProviderFor(dashboardStats)
const dashboardStatsProvider = DashboardStatsProvider._();

/// Compute dashboard statistics from users and shops data
///
/// This provider aggregates data from multiple sources to create
/// a complete dashboard statistics view.
///
/// Returns DashboardStats or throws Exception on error

final class DashboardStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DashboardStats>,
          DashboardStats,
          FutureOr<DashboardStats>
        >
    with $FutureModifier<DashboardStats>, $FutureProvider<DashboardStats> {
  /// Compute dashboard statistics from users and shops data
  ///
  /// This provider aggregates data from multiple sources to create
  /// a complete dashboard statistics view.
  ///
  /// Returns DashboardStats or throws Exception on error
  const DashboardStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardStatsHash();

  @$internal
  @override
  $FutureProviderElement<DashboardStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardStats> create(Ref ref) {
    return dashboardStats(ref);
  }
}

String _$dashboardStatsHash() => r'836f1fa8d87d245db617cabff1783158d2695282';

/// Get active sales executives count

@ProviderFor(activeSalesExecutivesCount)
const activeSalesExecutivesCountProvider =
    ActiveSalesExecutivesCountProvider._();

/// Get active sales executives count

final class ActiveSalesExecutivesCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Get active sales executives count
  const ActiveSalesExecutivesCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSalesExecutivesCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSalesExecutivesCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return activeSalesExecutivesCount(ref);
  }
}

String _$activeSalesExecutivesCountHash() =>
    r'96bf8129e881a00262008be89dd262731b3b67b7';

/// Get active area managers count

@ProviderFor(activeAreaManagersCount)
const activeAreaManagersCountProvider = ActiveAreaManagersCountProvider._();

/// Get active area managers count

final class ActiveAreaManagersCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Get active area managers count
  const ActiveAreaManagersCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeAreaManagersCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeAreaManagersCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return activeAreaManagersCount(ref);
  }
}

String _$activeAreaManagersCountHash() =>
    r'8ec7b195eb853a0dfe479da39959afdf1c707788';

/// Get active customers/shops count

@ProviderFor(activeCustomersCount)
const activeCustomersCountProvider = ActiveCustomersCountProvider._();

/// Get active customers/shops count

final class ActiveCustomersCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Get active customers/shops count
  const ActiveCustomersCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCustomersCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCustomersCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return activeCustomersCount(ref);
  }
}

String _$activeCustomersCountHash() =>
    r'c3d872f5b8a3a9876bb96f6c93095888cbd7bdc7';

/// Get users by territory ID

@ProviderFor(usersByTerritory)
const usersByTerritoryProvider = UsersByTerritoryFamily._();

/// Get users by territory ID

final class UsersByTerritoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppUser>>,
          List<AppUser>,
          FutureOr<List<AppUser>>
        >
    with $FutureModifier<List<AppUser>>, $FutureProvider<List<AppUser>> {
  /// Get users by territory ID
  const UsersByTerritoryProvider._({
    required UsersByTerritoryFamily super.from,
    required (int, {String? role, String? status}) super.argument,
  }) : super(
         retry: null,
         name: r'usersByTerritoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$usersByTerritoryHash();

  @override
  String toString() {
    return r'usersByTerritoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AppUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppUser>> create(Ref ref) {
    final argument = this.argument as (int, {String? role, String? status});
    return usersByTerritory(
      ref,
      argument.$1,
      role: argument.role,
      status: argument.status,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UsersByTerritoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$usersByTerritoryHash() => r'9310b7773f1e87337259fa10dc5fe35733ee409d';

/// Get users by territory ID

final class UsersByTerritoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AppUser>>,
          (int, {String? role, String? status})
        > {
  const UsersByTerritoryFamily._()
    : super(
        retry: null,
        name: r'usersByTerritoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get users by territory ID

  UsersByTerritoryProvider call(
    int territoryId, {
    String? role,
    String? status,
  }) => UsersByTerritoryProvider._(
    argument: (territoryId, role: role, status: status),
    from: this,
  );

  @override
  String toString() => r'usersByTerritoryProvider';
}

/// Get shops by territory ID (convenience provider)

@ProviderFor(shopsByTerritory)
const shopsByTerritoryProvider = ShopsByTerritoryFamily._();

/// Get shops by territory ID (convenience provider)

final class ShopsByTerritoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  /// Get shops by territory ID (convenience provider)
  const ShopsByTerritoryProvider._({
    required ShopsByTerritoryFamily super.from,
    required (int, {String? status}) super.argument,
  }) : super(
         retry: null,
         name: r'shopsByTerritoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopsByTerritoryHash();

  @override
  String toString() {
    return r'shopsByTerritoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Shop>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shop>> create(Ref ref) {
    final argument = this.argument as (int, {String? status});
    return shopsByTerritory(ref, argument.$1, status: argument.status);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopsByTerritoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopsByTerritoryHash() => r'52d56befec5bfbc36bf31c245274d3667663994d';

/// Get shops by territory ID (convenience provider)

final class ShopsByTerritoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Shop>>,
          (int, {String? status})
        > {
  const ShopsByTerritoryFamily._()
    : super(
        retry: null,
        name: r'shopsByTerritoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Get shops by territory ID (convenience provider)

  ShopsByTerritoryProvider call(int territoryId, {String? status}) =>
      ShopsByTerritoryProvider._(
        argument: (territoryId, status: status),
        from: this,
      );

  @override
  String toString() => r'shopsByTerritoryProvider';
}
