import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_dashboard/data/data/data_repository.dart';
import 'package:admin_dashboard/domain/models/user/app_user.dart';
import 'package:admin_dashboard/domain/models/shop/shop.dart';
import 'package:admin_dashboard/domain/models/analytics/analytics_data.dart';
import 'package:admin_dashboard/domain/models/analytics/dashboard_stats.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

part 'data_viewmodel.g.dart';

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
@riverpod
Future<List<AppUser>> users(
  Ref ref, {
  String? role,
  String? status,
  String? search,
}) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching users - role: $role, status: $status, search: $search',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getUsers(
    role: role,
    status: status,
    search: search,
  );

  return switch (result) {
    Ok(value: final usersData) => () {
      logger.info(
        'ViewModel: Converting ${usersData.length} users to domain models',
        'DATA_VM',
      );
      return usersData
          .map((userData) => AppUser.fromJson(userData))
          .toList();
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch users - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
}

/// Fetch a single user by ID
/// 
/// Parameters:
/// - [userId]: The ID of the user to fetch
/// 
/// Returns Map<String, dynamic> (raw user data) or throws Exception on error
@riverpod
Future<Map<String, dynamic>> userById(
  Ref ref,
  int userId,
) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching user by ID: $userId',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getUserById(userId);

  return switch (result) {
    Ok(value: final userData) => () {
      logger.info(
        'ViewModel: Successfully fetched user $userId',
        'DATA_VM',
      );
      return userData as Map<String, dynamic>;
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch user $userId - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
}

// ==================== SHOP PROVIDERS ====================

/// Fetch shops/customers with optional filters
/// 
/// Parameters:
/// - [territoryId]: Filter by territory ID
/// - [status]: Filter by shop status (e.g., 'active', 'inactive')
/// 
/// Returns List<Shop> or throws Exception on error
@riverpod
Future<List<Shop>> shops(
  Ref ref, {
  int? territoryId,
  String? status,
}) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching shops - territoryId: $territoryId, status: $status',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getShops(
    territoryId: territoryId,
    status: status,
  );

  return switch (result) {
    Ok(value: final shopsData) => () {
      logger.info(
        'ViewModel: Converting ${shopsData.length} shops to domain models',
        'DATA_VM',
      );
      return shopsData
          .map((shopData) => Shop.fromJson(shopData))
          .toList();
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch shops - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
}

/// Fetch a single shop by shop_id
/// 
/// Parameters:
/// - [shopId]: The shop_id (string) of the shop to fetch
/// 
/// Returns Map<String, dynamic> (raw shop data) or throws Exception on error
@riverpod
Future<Map<String, dynamic>> shopById(
  Ref ref,
  String shopId,
) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching shop by ID: $shopId',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getShopById(shopId);

  return switch (result) {
    Ok(value: final shopData) => () {
      logger.info(
        'ViewModel: Successfully fetched shop $shopId',
        'DATA_VM',
      );
      return shopData as Map<String, dynamic>;
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch shop $shopId - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
}

// ==================== ANALYTICS PROVIDERS ====================

/// Fetch top customers analytics
/// 
/// Parameters:
/// - [salesExecutiveId]: Filter by sales executive ID
/// - [areaManagerId]: Filter by area manager ID
/// - [startDate]: Start date for analytics period (YYYY-MM-DD)
/// - [endDate]: End date for analytics period (YYYY-MM-DD)
/// 
/// Returns List<TopCustomer> or throws Exception on error
@riverpod
Future<List<TopCustomer>> topCustomers(
  Ref ref, {
  int? salesExecutiveId,
  int? areaManagerId,
  String? startDate,
  String? endDate,
}) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching top customers - executiveId: $salesExecutiveId, managerId: $areaManagerId',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getTopCustomers(
    salesExecutiveId: salesExecutiveId,
    areaManagerId: areaManagerId,
    startDate: startDate,
    endDate: endDate,
  );

  return switch (result) {
    Ok(value: final customersData) => () {
      logger.info(
        'ViewModel: Converting ${customersData.length} top customers to domain models',
        'DATA_VM',
      );
      return customersData
          .map((customerData) => TopCustomer.fromJson(customerData))
          .toList();
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch top customers - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
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
@riverpod
Future<List<BestSellingProduct>> bestSellingProducts(
  Ref ref, {
  int? salesExecutiveId,
  int? areaManagerId,
  String? startDate,
  String? endDate,
}) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching best selling products - executiveId: $salesExecutiveId, managerId: $areaManagerId',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getBestSellingProducts(
    salesExecutiveId: salesExecutiveId,
    areaManagerId: areaManagerId,
    startDate: startDate,
    endDate: endDate,
  );

  return switch (result) {
    Ok(value: final productsData) => () {
      logger.info(
        'ViewModel: Converting ${productsData.length} best selling products to domain models',
        'DATA_VM',
      );
      return productsData
          .map((productData) => BestSellingProduct.fromJson(productData))
          .toList();
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch best selling products - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
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
@riverpod
Future<List<SalesDataPoint>> salesReport(
  Ref ref, {
  int? salesExecutiveId,
  int? areaManagerId,
  String? startDate,
  String? endDate,
}) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Fetching sales report - executiveId: $salesExecutiveId, managerId: $areaManagerId',
    'DATA_VM',
  );

  final repository = ref.read(dataRepositoryProvider.notifier);
  final result = await repository.getSalesReport(
    salesExecutiveId: salesExecutiveId,
    areaManagerId: areaManagerId,
    startDate: startDate,
    endDate: endDate,
  );

  return switch (result) {
    Ok(value: final salesData) => () {
      logger.info(
        'ViewModel: Converting ${salesData.length} sales data points to domain models',
        'DATA_VM',
      );
      return salesData
          .map((dataPoint) => SalesDataPoint.fromJson(dataPoint))
          .toList();
    }(),
    Error(error: final error) => () {
      logger.error(
        'ViewModel: Failed to fetch sales report - ${error.toString()}',
        'DATA_VM',
      );
      throw error;
    }(),
  };
}

// ==================== COMPUTED PROVIDERS ====================

/// Compute dashboard statistics from users and shops data
/// 
/// This provider aggregates data from multiple sources to create
/// a complete dashboard statistics view.
/// 
/// Returns DashboardStats or throws Exception on error
@riverpod
Future<DashboardStats> dashboardStats(Ref ref) async {
  final logger = LoggerService();
  logger.info(
    'ViewModel: Computing dashboard statistics',
    'DATA_VM',
  );

  try {
    // Fetch all required data in parallel
    final results = await Future.wait([
      ref.watch(usersProvider(role: 'sales_executive').future),
      ref.watch(usersProvider(role: 'area_manager').future),
      ref.watch(shopsProvider(status: 'active').future),
    ]);

    final salesExecutives = results[0] as List<AppUser>;
    final areaManagers = results[1] as List<AppUser>;
    final activeShops = results[2] as List<Shop>;

    // Calculate statistics
    final stats = DashboardStats(
      totalExecutives: salesExecutives.length,
      totalCustomers: activeShops.length,
      newCustomers: 0, // TODO: Calculate based on created_at date
      totalAreaManagers: areaManagers.length,
      newAreaManagers: 0, // TODO: Calculate based on created_at date
      todaySales: 0.0, // TODO: Fetch from sales API
      todayCollection: 0.0, // TODO: Fetch from collection API
      todayNewCustomers: 0, // TODO: Calculate from today's shops
    );

    logger.info(
      'ViewModel: Dashboard stats - Executives: ${stats.totalExecutives}, Customers: ${stats.totalCustomers}, Area Managers: ${stats.totalAreaManagers}',
      'DATA_VM',
    );

    return stats;
  } catch (e, stackTrace) {
    logger.error(
      'ViewModel: Failed to compute dashboard statistics - $e',
      'DATA_VM',
      stackTrace,
    );
    rethrow;
  }
}

// ==================== FILTERED PROVIDERS ====================

/// Get active sales executives count
@riverpod
Future<int> activeSalesExecutivesCount(Ref ref) async {
  final users = await ref.watch(usersProvider(role: 'sales_executive', status: 'active').future);
  return users.length;
}

/// Get active area managers count
@riverpod
Future<int> activeAreaManagersCount(Ref ref) async {
  final users = await ref.watch(usersProvider(role: 'area_manager', status: 'active').future);
  return users.length;
}

/// Get active customers/shops count
@riverpod
Future<int> activeCustomersCount(Ref ref) async {
  final shops = await ref.watch(shopsProvider(status: 'active').future);
  return shops.length;
}

/// Get users by territory ID
@riverpod
Future<List<AppUser>> usersByTerritory(
  Ref ref,
  int territoryId, {
  String? role,
  String? status,
}) async {
  final allUsers = await ref.watch(usersProvider(role: role, status: status).future);
  return allUsers.where((user) => user.territoryId == territoryId).toList();
}

/// Get shops by territory ID (convenience provider)
@riverpod
Future<List<Shop>> shopsByTerritory(
  Ref ref,
  int territoryId, {
  String? status,
}) async {
  return ref.watch(shopsProvider(territoryId: territoryId, status: status).future);
}
