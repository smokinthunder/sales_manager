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

  // ==================== Order Operations ====================

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
  /// Returns Result<Map<String, dynamic>> with items, total, page, page_size, pages
  Future<Result<Map<String, dynamic>>> getOrders({
    String? status,
    String? search,
    int? executiveId,
    String? shopId,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      _logger.info(
        'Fetching orders - status: $status, search: $search, executive: $executiveId, shop: $shopId, page: $page',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getOrders(
        status: status,
        search: search,
        executiveId: executiveId,
        shopId: shopId,
        fromDate: fromDate,
        toDate: toDate,
        page: page,
        pageSize: pageSize,
      );

      switch (result) {
        case Ok(value: final data):
          _logger.info(
            'Successfully fetched ${data['total']} orders',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch orders: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching orders: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching orders'));
    }
  }

  /// Fetch single order by ID with items
  /// 
  /// Parameters:
  /// - [orderId]: The ID of the order to fetch
  /// 
  /// Returns Result<Map<String, dynamic>> with order details and items array
  Future<Result<Map<String, dynamic>>> getOrderById(int orderId) async {
    try {
      _logger.info(
        'Fetching order with ID: $orderId',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getOrderById(orderId);

      switch (result) {
        case Ok(value: final order):
          _logger.info(
            'Successfully fetched order: ${order['order_id']}',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch order $orderId: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching order $orderId: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching order'));
    }
  }

  // ==================== Shop Assignment Operations ====================

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
  /// Returns Result<Map<String, dynamic>> with items, total, page, page_size, pages
  Future<Result<Map<String, dynamic>>> getShopAssignments({
    String? shopId,
    int? executiveId,
    String? status,
    String? territoryId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      _logger.info(
        'Fetching shop assignments - shop: $shopId, executive: $executiveId, status: $status, territory: $territoryId',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getShopAssignments(
        shopId: shopId,
        executiveId: executiveId,
        status: status,
        territoryId: territoryId,
        page: page,
        pageSize: pageSize,
      );

      switch (result) {
        case Ok(value: final data):
          _logger.info(
            'Successfully fetched ${data['total']} shop assignments',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch shop assignments: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching shop assignments: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching shop assignments'));
    }
  }

  // ==================== Visit Status Operations ====================

  /// Fetch shop visit status for a specific shop
  /// 
  /// Parameters:
  /// - [shopId]: The ID of the shop to fetch visit status for
  /// 
  /// Returns Result<Map<String, dynamic>> with visit statistics
  Future<Result<Map<String, dynamic>>> getShopVisitStatus(String shopId) async {
    try {
      _logger.info(
        'Fetching visit status for shop: $shopId',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getShopVisitStatus(shopId);

      switch (result) {
        case Ok():
          _logger.info(
            'Successfully fetched visit status for shop $shopId',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch visit status for shop $shopId: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching visit status for shop $shopId: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching visit status'));
    }
  }

  // ==================== Analytics Operations ====================

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
  /// Returns Result<Map<String, dynamic>> with shop analytics summary
  Future<Result<Map<String, dynamic>>> getShopAnalyticsSummary({
    int? territoryId,
    String? status,
    int? minRating,
    int? maxRating,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      _logger.info(
        'Fetching shop analytics summary - territory: $territoryId, rating: $minRating-$maxRating',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getShopAnalyticsSummary(
        territoryId: territoryId,
        status: status,
        minRating: minRating,
        maxRating: maxRating,
        fromDate: fromDate,
        toDate: toDate,
      );

      switch (result) {
        case Ok():
          _logger.info(
            'Successfully fetched shop analytics summary',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch shop analytics summary: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching shop analytics summary: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching shop analytics summary'));
    }
  }

  // ==================== Outstanding Payments Operations ====================

  /// Fetch outstanding payments list with filtering
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
  /// Returns Result<Map<String, dynamic>> with outstanding payments list
  Future<Result<Map<String, dynamic>>> getOutstandingPayments({
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
    double? minAmount,
    double? maxAmount,
    String? shopSearch,
    int? page,
    int? pageSize,
  }) async {
    try {
      _logger.info(
        'Fetching outstanding payments - status: $status, search: $shopSearch',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getOutstandingPayments(
        status: status,
        fromDate: fromDate,
        toDate: toDate,
        minAmount: minAmount,
        maxAmount: maxAmount,
        shopSearch: shopSearch,
        page: page,
        pageSize: pageSize,
      );

      switch (result) {
        case Ok():
          _logger.info(
            'Successfully fetched outstanding payments',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch outstanding payments: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching outstanding payments: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching outstanding payments'));
    }
  }

  /// Fetch outstanding payments summary with totals and counts
  /// 
  /// Returns Result<Map<String, dynamic>> with summary statistics
  Future<Result<Map<String, dynamic>>> getOutstandingSummary() async {
    try {
      _logger.info(
        'Fetching outstanding payments summary',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getOutstandingSummary();

      switch (result) {
        case Ok():
          _logger.info(
            'Successfully fetched outstanding summary',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch outstanding summary: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching outstanding summary: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching outstanding summary'));
    }
  }

  /// Fetch single outstanding payment by ID
  /// 
  /// Parameters:
  /// - [id]: Outstanding payment ID
  /// 
  /// Returns Result<Map<String, dynamic>> with payment details
  Future<Result<Map<String, dynamic>>> getOutstandingById(int id) async {
    try {
      _logger.info(
        'Fetching outstanding payment ID: $id',
        'DATA_REPO',
      );

      final result = await _remoteDataService.getOutstandingById(id);

      switch (result) {
        case Ok():
          _logger.info(
            'Successfully fetched outstanding payment $id',
            'DATA_REPO',
          );
          return result;
        case Error(error: final error):
          _logger.error(
            'Failed to fetch outstanding payment $id: ${error.toString()}',
            'DATA_REPO',
          );
          return result;
      }
    } catch (e, stackTrace) {
      _logger.error(
        'Unexpected error fetching outstanding payment $id: $e',
        'DATA_REPO',
        stackTrace,
      );
      return Result.error(Exception('An unexpected error occurred while fetching outstanding payment'));
    }
  }
}
