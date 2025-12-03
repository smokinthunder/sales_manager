import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_dashboard/data/data/remote/remote_data_service.dart';
import 'package:admin_dashboard/utils/logger_service.dart';
import 'package:admin_dashboard/utils/result.dart';

part 'data_repository.g.dart';

/// Data repository for managing users, shops, and analytics
/// 
/// This repository provides a clean abstraction over the remote data service,
/// adding additional logging and error handling at the repository layer.
/// Following the same pattern as NotificationRepository.
@riverpod
class DataRepository extends _$DataRepository {
  final LoggerService _logger = LoggerService();
  late final RemoteDataService _remoteDataService;

  @override
  FutureOr<void> build() {
    _remoteDataService = RemoteDataService();
    _logger.info('DataRepository initialized', 'DATA_REPO');
  }

  // ==================== User Operations ====================

  /// Fetch users with optional filters
  /// 
  /// Parameters:
  /// - [role]: Filter by user role (e.g., 'sales_executive', 'area_manager')
  /// - [status]: Filter by user status (e.g., 'active', 'inactive')
  /// - [search]: Search query for name, email, or phone
  /// 
  /// Returns Result<List<Map<String, dynamic>>>
  Future<Result<List<Map<String, dynamic>>>> getUsers({
    String? role,
    String? status,
    String? search,
  }) async {
    try {
      _logger.info(
        'Fetching users - role: $role, status: $status, search: $search',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getUsers(
        role: role,
        status: status,
        search: search,
      );

      switch (result) {
        case Ok(value: final users):
          _logger.info(
            'Successfully fetched ${users.length} users',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch users: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching users: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching users'));
    }
  }

  /// Fetch a single user by ID
  /// 
  /// Parameters:
  /// - [userId]: The ID of the user to fetch
  /// 
  /// Returns Result<AppUser>
  Future<Result<dynamic>> getUserById(int userId) async {
    try {
      _logger.info(
        'Fetching user with ID: $userId',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getUserById(userId);

      switch (result) {
        case Ok(value: final user):
          _logger.info(
            'Successfully fetched user: ${user['name']}',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch user $userId: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching user $userId: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching user'));
    }
  }

  // ==================== Shop Operations ====================

  /// Fetch shops/customers with optional filters
  /// 
  /// Parameters:
  /// - [territoryId]: Filter by territory ID
  /// - [status]: Filter by shop status (e.g., 'active', 'inactive')
  /// 
  /// Returns Result<List<Map<String, dynamic>>>
  Future<Result<List<Map<String, dynamic>>>> getShops({
    int? territoryId,
    String? status,
  }) async {
    try {
      _logger.info(
        'Fetching shops - territoryId: $territoryId, status: $status',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getShops(
        territoryId: territoryId,
        status: status,
      );

      switch (result) {
        case Ok(value: final shops):
          _logger.info(
            'Successfully fetched ${shops.length} shops',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch shops: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching shops: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching shops'));
    }
  }

  /// Fetch a single shop by shop_id
  /// 
  /// Parameters:
  /// - [shopId]: The shop_id (string) of the shop to fetch
  /// 
  /// Returns Result<Shop>
  Future<Result<dynamic>> getShopById(String shopId) async {
    try {
      _logger.info(
        'Fetching shop with shop_id: $shopId',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getShopById(shopId);

      switch (result) {
        case Ok(value: final shop):
          _logger.info(
            'Successfully fetched shop: ${shop['name']}',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch shop $shopId: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching shop $shopId: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching shop'));
    }
  }

  // ==================== Analytics Operations ====================

  /// Fetch top customers analytics
  /// 
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  /// 
  /// Returns Result<List<Map<String, dynamic>>>
  Future<Result<List<Map<String, dynamic>>>> getTopCustomers({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      _logger.info(
        'Fetching top customers - executiveId: $salesExecutiveId, managerId: $areaManagerId, period: $startDate to $endDate',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getTopCustomers(
        salesExecutiveId: salesExecutiveId,
        areaManagerId: areaManagerId,
        startDate: startDate,
        endDate: endDate,
      );

      switch (result) {
        case Ok(value: final customers):
          _logger.info(
            'Successfully fetched ${customers.length} top customers',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch top customers: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching top customers: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching top customers'));
    }
  }

  /// Fetch best selling products analytics
  /// 
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  /// 
  /// Returns Result<List<Map<String, dynamic>>>
  Future<Result<List<Map<String, dynamic>>>> getBestSellingProducts({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      _logger.info(
        'Fetching best selling products - executiveId: $salesExecutiveId, managerId: $areaManagerId, period: $startDate to $endDate',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getBestSellingProducts(
        salesExecutiveId: salesExecutiveId,
        areaManagerId: areaManagerId,
        startDate: startDate,
        endDate: endDate,
      );

      switch (result) {
        case Ok(value: final products):
          _logger.info(
            'Successfully fetched ${products.length} best selling products',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch best selling products: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching best selling products: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching best selling products'));
    }
  }

  /// Fetch sales report analytics
  /// 
  /// Parameters:
  /// - [salesExecutiveId]: Filter by sales executive ID
  /// - [areaManagerId]: Filter by area manager ID
  /// - [startDate]: Start date for analytics period (YYYY-MM-DD)
  /// - [endDate]: End date for analytics period (YYYY-MM-DD)
  /// 
  /// Returns Result<List<Map<String, dynamic>>>
  Future<Result<List<Map<String, dynamic>>>> getSalesReport({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      _logger.info(
        'Fetching sales report - executiveId: $salesExecutiveId, managerId: $areaManagerId, period: $startDate to $endDate',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getSalesReport(
        salesExecutiveId: salesExecutiveId,
        areaManagerId: areaManagerId,
        startDate: startDate,
        endDate: endDate,
      );

      switch (result) {
        case Ok(value: final salesData):
          _logger.info(
            'Successfully fetched ${salesData.length} sales data points',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch sales report: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching sales report: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching sales report'));
    }
  }
}
