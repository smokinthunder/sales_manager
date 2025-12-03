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

String _$usersHash() => r'cc7852dc91278c3f92acac94192051a017a041e3';

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

String _$userByIdHash() => r'd70a84387ffbae6c011304bd2012ddc83866348c';

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

String _$shopsHash() => r'802d98965dbe858f0a05cc1d6d7a0c8c14387f65';

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

String _$shopByIdHash() => r'9c18ac88dfd329641c4d84c54a5daefe90016f00';

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

String _$topCustomersHash() => r'ca020bbc776d072d3e6ad849217061c839ce1877';

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
    r'07885f6c66dee869b4b370969f4b8509b231c0e9';

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

String _$salesReportHash() => r'8f80a3cfa37607098315d7586390d52c8197d5fc';

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

String _$dashboardStatsHash() => r'ffa223256dd54dea1238c7afbd48c3deff28bcff';

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
    r'5db9ba89c64b2eeb232a65c14f577c8b52480210';

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
    r'd54ec16e81af1b9c121c7e004bdb5b0a6788e7f9';

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
    r'219351f63ca7bec7dd8b54cec2a7a9e3475fac0b';

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

String _$usersByTerritoryHash() => r'1bc6a846d46cb45e5510b7365d5490431977c473';

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

String _$shopsByTerritoryHash() => r'145929bace1ecc63e586ac9e385fda47124e8f1d';

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

/// Fetch orders with optional filtering and pagination
///
/// Parameters:
/// - [status]: Filter by order status (e.g., 'pending', 'completed')
/// - [search]: Search query for order ID, bill number, or shop name
/// - [executiveId]: Filter by executive ID
/// - [shopId]: Filter by shop ID
/// - [fromDate]: Filter orders from this date
/// - [toDate]: Filter orders to this date
/// - [page]: Page number (default: 1)
/// - [pageSize]: Items per page (default: 20)
///
/// Returns Map<String, dynamic> with items, total, page, page_size, pages

@ProviderFor(orders)
const ordersProvider = OrdersFamily._();

/// Fetch orders with optional filtering and pagination
///
/// Parameters:
/// - [status]: Filter by order status (e.g., 'pending', 'completed')
/// - [search]: Search query for order ID, bill number, or shop name
/// - [executiveId]: Filter by executive ID
/// - [shopId]: Filter by shop ID
/// - [fromDate]: Filter orders from this date
/// - [toDate]: Filter orders to this date
/// - [page]: Page number (default: 1)
/// - [pageSize]: Items per page (default: 20)
///
/// Returns Map<String, dynamic> with items, total, page, page_size, pages

final class OrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch orders with optional filtering and pagination
  ///
  /// Parameters:
  /// - [status]: Filter by order status (e.g., 'pending', 'completed')
  /// - [search]: Search query for order ID, bill number, or shop name
  /// - [executiveId]: Filter by executive ID
  /// - [shopId]: Filter by shop ID
  /// - [fromDate]: Filter orders from this date
  /// - [toDate]: Filter orders to this date
  /// - [page]: Page number (default: 1)
  /// - [pageSize]: Items per page (default: 20)
  ///
  /// Returns Map<String, dynamic> with items, total, page, page_size, pages
  const OrdersProvider._({
    required OrdersFamily super.from,
    required ({
      String? status,
      String? search,
      int? executiveId,
      String? shopId,
      DateTime? fromDate,
      DateTime? toDate,
      int page,
      int pageSize,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'ordersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ordersHash();

  @override
  String toString() {
    return r'ordersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? status,
              String? search,
              int? executiveId,
              String? shopId,
              DateTime? fromDate,
              DateTime? toDate,
              int page,
              int pageSize,
            });
    return orders(
      ref,
      status: argument.status,
      search: argument.search,
      executiveId: argument.executiveId,
      shopId: argument.shopId,
      fromDate: argument.fromDate,
      toDate: argument.toDate,
      page: argument.page,
      pageSize: argument.pageSize,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ordersHash() => r'409a17137a4d5077497a6f1d7cfef0c997323585';

/// Fetch orders with optional filtering and pagination
///
/// Parameters:
/// - [status]: Filter by order status (e.g., 'pending', 'completed')
/// - [search]: Search query for order ID, bill number, or shop name
/// - [executiveId]: Filter by executive ID
/// - [shopId]: Filter by shop ID
/// - [fromDate]: Filter orders from this date
/// - [toDate]: Filter orders to this date
/// - [page]: Page number (default: 1)
/// - [pageSize]: Items per page (default: 20)
///
/// Returns Map<String, dynamic> with items, total, page, page_size, pages

final class OrdersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({
            String? status,
            String? search,
            int? executiveId,
            String? shopId,
            DateTime? fromDate,
            DateTime? toDate,
            int page,
            int pageSize,
          })
        > {
  const OrdersFamily._()
    : super(
        retry: null,
        name: r'ordersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch orders with optional filtering and pagination
  ///
  /// Parameters:
  /// - [status]: Filter by order status (e.g., 'pending', 'completed')
  /// - [search]: Search query for order ID, bill number, or shop name
  /// - [executiveId]: Filter by executive ID
  /// - [shopId]: Filter by shop ID
  /// - [fromDate]: Filter orders from this date
  /// - [toDate]: Filter orders to this date
  /// - [page]: Page number (default: 1)
  /// - [pageSize]: Items per page (default: 20)
  ///
  /// Returns Map<String, dynamic> with items, total, page, page_size, pages

  OrdersProvider call({
    String? status,
    String? search,
    int? executiveId,
    String? shopId,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int pageSize = 20,
  }) => OrdersProvider._(
    argument: (
      status: status,
      search: search,
      executiveId: executiveId,
      shopId: shopId,
      fromDate: fromDate,
      toDate: toDate,
      page: page,
      pageSize: pageSize,
    ),
    from: this,
  );

  @override
  String toString() => r'ordersProvider';
}

/// Fetch single order by ID with items
///
/// Parameters:
/// - [orderId]: The ID of the order to fetch
///
/// Returns Map<String, dynamic> with order details and items array

@ProviderFor(orderById)
const orderByIdProvider = OrderByIdFamily._();

/// Fetch single order by ID with items
///
/// Parameters:
/// - [orderId]: The ID of the order to fetch
///
/// Returns Map<String, dynamic> with order details and items array

final class OrderByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch single order by ID with items
  ///
  /// Parameters:
  /// - [orderId]: The ID of the order to fetch
  ///
  /// Returns Map<String, dynamic> with order details and items array
  const OrderByIdProvider._({
    required OrderByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'orderByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderByIdHash();

  @override
  String toString() {
    return r'orderByIdProvider'
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
    return orderById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderByIdHash() => r'2040119933d2be8b795eac9396cff438fdf6977c';

/// Fetch single order by ID with items
///
/// Parameters:
/// - [orderId]: The ID of the order to fetch
///
/// Returns Map<String, dynamic> with order details and items array

final class OrderByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, int> {
  const OrderByIdFamily._()
    : super(
        retry: null,
        name: r'orderByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch single order by ID with items
  ///
  /// Parameters:
  /// - [orderId]: The ID of the order to fetch
  ///
  /// Returns Map<String, dynamic> with order details and items array

  OrderByIdProvider call(int orderId) =>
      OrderByIdProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderByIdProvider';
}

/// Fetch shop-executive assignments with optional filtering
///
/// Parameters:
/// - [shopId]: Filter by shop ID
/// - [executiveId]: Filter by executive ID
/// - [status]: Filter by assignment status (e.g., 'active', 'inactive')
/// - [territoryId]: Filter by territory ID
/// - [page]: Page number (default: 1)
/// - [pageSize]: Items per page (default: 20)
///
/// Returns Map<String, dynamic> with items, total, page, page_size, pages

@ProviderFor(shopAssignments)
const shopAssignmentsProvider = ShopAssignmentsFamily._();

/// Fetch shop-executive assignments with optional filtering
///
/// Parameters:
/// - [shopId]: Filter by shop ID
/// - [executiveId]: Filter by executive ID
/// - [status]: Filter by assignment status (e.g., 'active', 'inactive')
/// - [territoryId]: Filter by territory ID
/// - [page]: Page number (default: 1)
/// - [pageSize]: Items per page (default: 20)
///
/// Returns Map<String, dynamic> with items, total, page, page_size, pages

final class ShopAssignmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch shop-executive assignments with optional filtering
  ///
  /// Parameters:
  /// - [shopId]: Filter by shop ID
  /// - [executiveId]: Filter by executive ID
  /// - [status]: Filter by assignment status (e.g., 'active', 'inactive')
  /// - [territoryId]: Filter by territory ID
  /// - [page]: Page number (default: 1)
  /// - [pageSize]: Items per page (default: 20)
  ///
  /// Returns Map<String, dynamic> with items, total, page, page_size, pages
  const ShopAssignmentsProvider._({
    required ShopAssignmentsFamily super.from,
    required ({
      String? shopId,
      int? executiveId,
      String? status,
      String? territoryId,
      int page,
      int pageSize,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'shopAssignmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopAssignmentsHash();

  @override
  String toString() {
    return r'shopAssignmentsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? shopId,
              int? executiveId,
              String? status,
              String? territoryId,
              int page,
              int pageSize,
            });
    return shopAssignments(
      ref,
      shopId: argument.shopId,
      executiveId: argument.executiveId,
      status: argument.status,
      territoryId: argument.territoryId,
      page: argument.page,
      pageSize: argument.pageSize,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShopAssignmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopAssignmentsHash() => r'3ea387453300dab5e0389a5a2a55fcea1e29e75f';

/// Fetch shop-executive assignments with optional filtering
///
/// Parameters:
/// - [shopId]: Filter by shop ID
/// - [executiveId]: Filter by executive ID
/// - [status]: Filter by assignment status (e.g., 'active', 'inactive')
/// - [territoryId]: Filter by territory ID
/// - [page]: Page number (default: 1)
/// - [pageSize]: Items per page (default: 20)
///
/// Returns Map<String, dynamic> with items, total, page, page_size, pages

final class ShopAssignmentsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({
            String? shopId,
            int? executiveId,
            String? status,
            String? territoryId,
            int page,
            int pageSize,
          })
        > {
  const ShopAssignmentsFamily._()
    : super(
        retry: null,
        name: r'shopAssignmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch shop-executive assignments with optional filtering
  ///
  /// Parameters:
  /// - [shopId]: Filter by shop ID
  /// - [executiveId]: Filter by executive ID
  /// - [status]: Filter by assignment status (e.g., 'active', 'inactive')
  /// - [territoryId]: Filter by territory ID
  /// - [page]: Page number (default: 1)
  /// - [pageSize]: Items per page (default: 20)
  ///
  /// Returns Map<String, dynamic> with items, total, page, page_size, pages

  ShopAssignmentsProvider call({
    String? shopId,
    int? executiveId,
    String? status,
    String? territoryId,
    int page = 1,
    int pageSize = 20,
  }) => ShopAssignmentsProvider._(
    argument: (
      shopId: shopId,
      executiveId: executiveId,
      status: status,
      territoryId: territoryId,
      page: page,
      pageSize: pageSize,
    ),
    from: this,
  );

  @override
  String toString() => r'shopAssignmentsProvider';
}

/// Fetch shop visit status for a specific shop
///
/// Parameters:
/// - [shopId]: The ID of the shop to fetch visit status for
///
/// Returns Map<String, dynamic> with visit statistics

@ProviderFor(shopVisitStatus)
const shopVisitStatusProvider = ShopVisitStatusFamily._();

/// Fetch shop visit status for a specific shop
///
/// Parameters:
/// - [shopId]: The ID of the shop to fetch visit status for
///
/// Returns Map<String, dynamic> with visit statistics

final class ShopVisitStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch shop visit status for a specific shop
  ///
  /// Parameters:
  /// - [shopId]: The ID of the shop to fetch visit status for
  ///
  /// Returns Map<String, dynamic> with visit statistics
  const ShopVisitStatusProvider._({
    required ShopVisitStatusFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shopVisitStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopVisitStatusHash();

  @override
  String toString() {
    return r'shopVisitStatusProvider'
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
    return shopVisitStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopVisitStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopVisitStatusHash() => r'c60538ea83da7f77e3e2a33402c1a3759b99f568';

/// Fetch shop visit status for a specific shop
///
/// Parameters:
/// - [shopId]: The ID of the shop to fetch visit status for
///
/// Returns Map<String, dynamic> with visit statistics

final class ShopVisitStatusFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, String> {
  const ShopVisitStatusFamily._()
    : super(
        retry: null,
        name: r'shopVisitStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch shop visit status for a specific shop
  ///
  /// Parameters:
  /// - [shopId]: The ID of the shop to fetch visit status for
  ///
  /// Returns Map<String, dynamic> with visit statistics

  ShopVisitStatusProvider call(String shopId) =>
      ShopVisitStatusProvider._(argument: shopId, from: this);

  @override
  String toString() => r'shopVisitStatusProvider';
}

/// Fetch shop analytics summary with optional filtering
///
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status
/// - [minRating]: Minimum rating filter (1-5)
/// - [maxRating]: Maximum rating filter (1-5)
/// - [fromDate]: Filter from this date
/// - [toDate]: Filter to this date
///
/// Returns Map<String, dynamic> with shop analytics summary

@ProviderFor(shopAnalyticsSummary)
const shopAnalyticsSummaryProvider = ShopAnalyticsSummaryFamily._();

/// Fetch shop analytics summary with optional filtering
///
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status
/// - [minRating]: Minimum rating filter (1-5)
/// - [maxRating]: Maximum rating filter (1-5)
/// - [fromDate]: Filter from this date
/// - [toDate]: Filter to this date
///
/// Returns Map<String, dynamic> with shop analytics summary

final class ShopAnalyticsSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch shop analytics summary with optional filtering
  ///
  /// Parameters:
  /// - [territoryId]: Filter by territory ID
  /// - [status]: Filter by shop status
  /// - [minRating]: Minimum rating filter (1-5)
  /// - [maxRating]: Maximum rating filter (1-5)
  /// - [fromDate]: Filter from this date
  /// - [toDate]: Filter to this date
  ///
  /// Returns Map<String, dynamic> with shop analytics summary
  const ShopAnalyticsSummaryProvider._({
    required ShopAnalyticsSummaryFamily super.from,
    required ({
      int? territoryId,
      String? status,
      int? minRating,
      int? maxRating,
      DateTime? fromDate,
      DateTime? toDate,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'shopAnalyticsSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopAnalyticsSummaryHash();

  @override
  String toString() {
    return r'shopAnalyticsSummaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? territoryId,
              String? status,
              int? minRating,
              int? maxRating,
              DateTime? fromDate,
              DateTime? toDate,
            });
    return shopAnalyticsSummary(
      ref,
      territoryId: argument.territoryId,
      status: argument.status,
      minRating: argument.minRating,
      maxRating: argument.maxRating,
      fromDate: argument.fromDate,
      toDate: argument.toDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ShopAnalyticsSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopAnalyticsSummaryHash() =>
    r'0c9c36141a2be52a0eca312685df8d56f8f499b8';

/// Fetch shop analytics summary with optional filtering
///
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status
/// - [minRating]: Minimum rating filter (1-5)
/// - [maxRating]: Maximum rating filter (1-5)
/// - [fromDate]: Filter from this date
/// - [toDate]: Filter to this date
///
/// Returns Map<String, dynamic> with shop analytics summary

final class ShopAnalyticsSummaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({
            int? territoryId,
            String? status,
            int? minRating,
            int? maxRating,
            DateTime? fromDate,
            DateTime? toDate,
          })
        > {
  const ShopAnalyticsSummaryFamily._()
    : super(
        retry: null,
        name: r'shopAnalyticsSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch shop analytics summary with optional filtering
  ///
  /// Parameters:
  /// - [territoryId]: Filter by territory ID
  /// - [status]: Filter by shop status
  /// - [minRating]: Minimum rating filter (1-5)
  /// - [maxRating]: Maximum rating filter (1-5)
  /// - [fromDate]: Filter from this date
  /// - [toDate]: Filter to this date
  ///
  /// Returns Map<String, dynamic> with shop analytics summary

  ShopAnalyticsSummaryProvider call({
    int? territoryId,
    String? status,
    int? minRating,
    int? maxRating,
    DateTime? fromDate,
    DateTime? toDate,
  }) => ShopAnalyticsSummaryProvider._(
    argument: (
      territoryId: territoryId,
      status: status,
      minRating: minRating,
      maxRating: maxRating,
      fromDate: fromDate,
      toDate: toDate,
    ),
    from: this,
  );

  @override
  String toString() => r'shopAnalyticsSummaryProvider';
}

/// Fetch outstanding payments list with optional filtering
///
/// Parameters:
/// - [status]: Filter by payment status (current, upcoming, overdue)
/// - [fromDate]: Filter from due date
/// - [toDate]: Filter to due date
/// - [minAmount]: Minimum amount filter
/// - [maxAmount]: Maximum amount filter
/// - [shopSearch]: Search by shop name
/// - [page]: Page number for pagination
/// - [pageSize]: Number of items per page
///
/// Returns Map<String, dynamic> with outstanding payments list

@ProviderFor(outstandingPayments)
const outstandingPaymentsProvider = OutstandingPaymentsFamily._();

/// Fetch outstanding payments list with optional filtering
///
/// Parameters:
/// - [status]: Filter by payment status (current, upcoming, overdue)
/// - [fromDate]: Filter from due date
/// - [toDate]: Filter to due date
/// - [minAmount]: Minimum amount filter
/// - [maxAmount]: Maximum amount filter
/// - [shopSearch]: Search by shop name
/// - [page]: Page number for pagination
/// - [pageSize]: Number of items per page
///
/// Returns Map<String, dynamic> with outstanding payments list

final class OutstandingPaymentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch outstanding payments list with optional filtering
  ///
  /// Parameters:
  /// - [status]: Filter by payment status (current, upcoming, overdue)
  /// - [fromDate]: Filter from due date
  /// - [toDate]: Filter to due date
  /// - [minAmount]: Minimum amount filter
  /// - [maxAmount]: Maximum amount filter
  /// - [shopSearch]: Search by shop name
  /// - [page]: Page number for pagination
  /// - [pageSize]: Number of items per page
  ///
  /// Returns Map<String, dynamic> with outstanding payments list
  const OutstandingPaymentsProvider._({
    required OutstandingPaymentsFamily super.from,
    required ({
      String? status,
      DateTime? fromDate,
      DateTime? toDate,
      double? minAmount,
      double? maxAmount,
      String? shopSearch,
      int? page,
      int? pageSize,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'outstandingPaymentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$outstandingPaymentsHash();

  @override
  String toString() {
    return r'outstandingPaymentsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String? status,
              DateTime? fromDate,
              DateTime? toDate,
              double? minAmount,
              double? maxAmount,
              String? shopSearch,
              int? page,
              int? pageSize,
            });
    return outstandingPayments(
      ref,
      status: argument.status,
      fromDate: argument.fromDate,
      toDate: argument.toDate,
      minAmount: argument.minAmount,
      maxAmount: argument.maxAmount,
      shopSearch: argument.shopSearch,
      page: argument.page,
      pageSize: argument.pageSize,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is OutstandingPaymentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outstandingPaymentsHash() =>
    r'168910bcfd9599395ec2f18d836403ef81e8d6fd';

/// Fetch outstanding payments list with optional filtering
///
/// Parameters:
/// - [status]: Filter by payment status (current, upcoming, overdue)
/// - [fromDate]: Filter from due date
/// - [toDate]: Filter to due date
/// - [minAmount]: Minimum amount filter
/// - [maxAmount]: Maximum amount filter
/// - [shopSearch]: Search by shop name
/// - [page]: Page number for pagination
/// - [pageSize]: Number of items per page
///
/// Returns Map<String, dynamic> with outstanding payments list

final class OutstandingPaymentsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, dynamic>>,
          ({
            String? status,
            DateTime? fromDate,
            DateTime? toDate,
            double? minAmount,
            double? maxAmount,
            String? shopSearch,
            int? page,
            int? pageSize,
          })
        > {
  const OutstandingPaymentsFamily._()
    : super(
        retry: null,
        name: r'outstandingPaymentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch outstanding payments list with optional filtering
  ///
  /// Parameters:
  /// - [status]: Filter by payment status (current, upcoming, overdue)
  /// - [fromDate]: Filter from due date
  /// - [toDate]: Filter to due date
  /// - [minAmount]: Minimum amount filter
  /// - [maxAmount]: Maximum amount filter
  /// - [shopSearch]: Search by shop name
  /// - [page]: Page number for pagination
  /// - [pageSize]: Number of items per page
  ///
  /// Returns Map<String, dynamic> with outstanding payments list

  OutstandingPaymentsProvider call({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    double? minAmount,
    double? maxAmount,
    String? shopSearch,
    int? page,
    int? pageSize,
  }) => OutstandingPaymentsProvider._(
    argument: (
      status: status,
      fromDate: fromDate,
      toDate: toDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      shopSearch: shopSearch,
      page: page,
      pageSize: pageSize,
    ),
    from: this,
  );

  @override
  String toString() => r'outstandingPaymentsProvider';
}

/// Fetch outstanding payments summary with totals and counts
///
/// Returns Map<String, dynamic> with summary statistics

@ProviderFor(outstandingSummary)
const outstandingSummaryProvider = OutstandingSummaryProvider._();

/// Fetch outstanding payments summary with totals and counts
///
/// Returns Map<String, dynamic> with summary statistics

final class OutstandingSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch outstanding payments summary with totals and counts
  ///
  /// Returns Map<String, dynamic> with summary statistics
  const OutstandingSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outstandingSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outstandingSummaryHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return outstandingSummary(ref);
  }
}

String _$outstandingSummaryHash() =>
    r'35575c2a93861b394fbce3528ce694f65600c91e';

/// Fetch single outstanding payment by ID
///
/// Parameters:
/// - [id]: Outstanding payment ID
///
/// Returns Map<String, dynamic> with payment details

@ProviderFor(outstandingById)
const outstandingByIdProvider = OutstandingByIdFamily._();

/// Fetch single outstanding payment by ID
///
/// Parameters:
/// - [id]: Outstanding payment ID
///
/// Returns Map<String, dynamic> with payment details

final class OutstandingByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  /// Fetch single outstanding payment by ID
  ///
  /// Parameters:
  /// - [id]: Outstanding payment ID
  ///
  /// Returns Map<String, dynamic> with payment details
  const OutstandingByIdProvider._({
    required OutstandingByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'outstandingByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$outstandingByIdHash();

  @override
  String toString() {
    return r'outstandingByIdProvider'
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
    return outstandingById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OutstandingByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outstandingByIdHash() => r'f0ec460994c69263a1c0f5596006ef6f15a6d94b';

/// Fetch single outstanding payment by ID
///
/// Parameters:
/// - [id]: Outstanding payment ID
///
/// Returns Map<String, dynamic> with payment details

final class OutstandingByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, dynamic>>, int> {
  const OutstandingByIdFamily._()
    : super(
        retry: null,
        name: r'outstandingByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetch single outstanding payment by ID
  ///
  /// Parameters:
  /// - [id]: Outstanding payment ID
  ///
  /// Returns Map<String, dynamic> with payment details

  OutstandingByIdProvider call(int id) =>
      OutstandingByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'outstandingByIdProvider';
}
