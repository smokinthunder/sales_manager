import 'package:dio/dio.dart';
import 'package:admin_dashboard/data/core/api_endpoints.dart';
import 'package:admin_dashboard/data/data/config/data_config.dart';
import 'package:admin_dashboard/data/auth/remote/auth_interceptor.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Remote data service for fetching users, shops, and analytics data
/// 
/// Follows the same professional pattern as RemoteNotificationService with:
/// - Comprehensive error parsing
/// - Detailed logging at every operation
/// - Timeout configuration
/// - User-friendly error messages
class RemoteDataService {
  late final Dio dio;
  final LoggerService logger = LoggerService();
  final String tenantId = dotenv.env['TENANT_ID'] ?? 'AQUASTAR';

  RemoteDataService() {
    final ipAddr = dotenv.env['IP_ADDR'] ?? "192.168.63.132";
    final baseUrl = "http://$ipAddr:8000";
    
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: DataConfig.apiTimeoutSeconds),
      receiveTimeout: Duration(seconds: DataConfig.apiTimeoutSeconds),
      sendTimeout: Duration(seconds: DataConfig.apiTimeoutSeconds),
    ));
    
    // Add auth interceptor (using LocalAuthService singleton)
    dio.interceptors.add(AuthInterceptor(LocalAuthService()));
    
    logger.info('RemoteDataService initialized with baseUrl: $baseUrl, tenant: $tenantId', 'DATA_SERVICE');
  }

  // ===== USERS API =====

  /// Fetch all users with optional filtering
  Future<Result<List<Map<String, dynamic>>>> getUsers({
    String? role,
    String? status,
    String? search,
  }) async {
    final endpoint = ApiEndpoints.user;
    final queryParameters = {
      'tenant_id': tenantId,
      if (role != null) 'role': role,
      if (status != null) 'user_status': status,
      if (search != null) 'search': search,
    };

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success: ${(response.data as List).length} users',
      );

      final users = (response.data as List).cast<Map<String, dynamic>>();
      logger.info('Fetched ${users.length} users', 'DATA_SERVICE');
      return Result.ok(users);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch a specific user by ID
  Future<Result<Map<String, dynamic>>> getUserById(int userId) async {
    final endpoint = '${ApiEndpoints.user}$userId';
    final queryParameters = {'tenant_id': tenantId};

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(response.statusCode ?? 0, endpoint, 'Success');

      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  // ===== SHOPS API =====

  /// Fetch all shops with optional filtering
  Future<Result<List<Map<String, dynamic>>>> getShops({
    int? territoryId,
    String? status,
  }) async {
    final endpoint = ApiEndpoints.shops;
    final queryParameters = {
      'tenant_id': tenantId,
      if (territoryId != null) 'territory_id': territoryId.toString(),
      if (status != null) 'status': status,
    };

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success: ${(response.data as List).length} shops',
      );

      final shops = (response.data as List).cast<Map<String, dynamic>>();
      logger.info('Fetched ${shops.length} shops', 'DATA_SERVICE');
      return Result.ok(shops);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch a specific shop by shop_id
  Future<Result<Map<String, dynamic>>> getShopById(String shopId) async {
    final endpoint = ApiEndpoints.shopById.replaceAll('{}', shopId);
    final queryParameters = {'tenant_id': tenantId};

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(response.statusCode ?? 0, endpoint, 'Success');

      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  // ===== ANALYTICS API =====

  /// Fetch top customers analytics
  Future<Result<List<Map<String, dynamic>>>> getTopCustomers({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) async {
    final endpoint = ApiEndpoints.analyticsExecutiveTopCustomers;
    final queryParameters = {
      'tenant_id': tenantId,
      if (salesExecutiveId != null) 'sales_executive_id': salesExecutiveId.toString(),
      if (areaManagerId != null) 'area_manager_id': areaManagerId.toString(),
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    };

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success: ${(response.data as List).length} customers',
      );

      final customers = (response.data as List).cast<Map<String, dynamic>>();
      logger.info('Fetched ${customers.length} top customers', 'DATA_SERVICE');
      return Result.ok(customers);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch best selling products analytics
  Future<Result<List<Map<String, dynamic>>>> getBestSellingProducts({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) async {
    final endpoint = ApiEndpoints.analyticsExecutiveBestSellingProducts;
    final queryParameters = {
      'tenant_id': tenantId,
      if (salesExecutiveId != null) 'sales_executive_id': salesExecutiveId.toString(),
      if (areaManagerId != null) 'area_manager_id': areaManagerId.toString(),
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    };

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success: ${(response.data as List).length} products',
      );

      final products = (response.data as List).cast<Map<String, dynamic>>();
      logger.info('Fetched ${products.length} best selling products', 'DATA_SERVICE');
      return Result.ok(products);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch sales report analytics
  Future<Result<List<Map<String, dynamic>>>> getSalesReport({
    int? salesExecutiveId,
    int? areaManagerId,
    String? startDate,
    String? endDate,
  }) async {
    final endpoint = ApiEndpoints.analyticsExecutiveSalesReport;
    final queryParameters = {
      'tenant_id': tenantId,
      if (salesExecutiveId != null) 'sales_executive_id': salesExecutiveId.toString(),
      if (areaManagerId != null) 'area_manager_id': areaManagerId.toString(),
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    };

    logger.apiRequest('GET', endpoint, queryParameters);

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success: ${(response.data as List).length} data points',
      );

      final salesData = (response.data as List).cast<Map<String, dynamic>>();
      logger.info('Fetched ${salesData.length} sales data points', 'DATA_SERVICE');
      return Result.ok(salesData);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.apiError(endpoint, Exception(errorMessage), e.stackTrace);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.apiError(endpoint, e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  // ===== ERROR PARSING =====

  /// Parse DioException to user-friendly error message
  String _parseError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DataConfig.timeoutErrorMessage;

      case DioExceptionType.connectionError:
        return DataConfig.networkErrorMessage;

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return DataConfig.badRequestErrorMessage;
          case 401:
          case 403:
            return DataConfig.unauthorizedErrorMessage;
          case 404:
            return DataConfig.notFoundErrorMessage;
          case 429:
            return DataConfig.rateLimitErrorMessage;
          case 500:
          case 502:
          case 503:
            return DataConfig.serverErrorMessage;
          default:
            return DataConfig.unknownErrorMessage;
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      default:
        return DataConfig.unknownErrorMessage;
    }
  }

  // ===== ORDERS API =====

  /// Fetch all orders with optional filtering and pagination
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
    const endpoint = '/api/v1/orders/';
    final queryParameters = {
      if (status != null) 'status': status,
      if (search != null) 'search': search,
      if (executiveId != null) 'executive_id': executiveId,
      if (shopId != null) 'shop_id': shopId,
      if (fromDate != null) 'from_date': fromDate.toIso8601String().split('T')[0],
      if (toDate != null) 'to_date': toDate.toIso8601String().split('T')[0],
      'page': page,
      'page_size': pageSize,
    };

    logger.info('Fetching orders', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      logger.info('Successfully fetched ${response.data['total']} orders', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch orders: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching orders', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch single order by ID with items
  Future<Result<Map<String, dynamic>>> getOrderById(int orderId) async {
    final endpoint = '/api/v1/orders/$orderId';

    logger.info('Fetching order with ID: $orderId', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(endpoint);

      logger.info('Successfully fetched order: ${response.data['order_id']}', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch order $orderId: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching order $orderId', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  // ===== SHOP ASSIGNMENTS API =====

  /// Fetch shop-executive assignments with optional filtering
  Future<Result<Map<String, dynamic>>> getShopAssignments({
    String? shopId,
    int? executiveId,
    String? status,
    String? territoryId,
    int page = 1,
    int pageSize = 20,
  }) async {
    const endpoint = '/api/v1/shop-assignments/';
    final queryParameters = {
      if (shopId != null) 'shop_id': shopId,
      if (executiveId != null) 'executive_id': executiveId,
      if (status != null) 'status': status,
      if (territoryId != null) 'territory_id': territoryId,
      'page': page,
      'page_size': pageSize,
    };

    logger.info('Fetching shop assignments', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      logger.info('Successfully fetched ${response.data['total']} shop assignments', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch shop assignments: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching shop assignments', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch shop visit status for a specific shop
  Future<Result<Map<String, dynamic>>> getShopVisitStatus(String shopId) async {
    final endpoint = '/api/v1/visits/shops/$shopId/visit-status';

    logger.info('Fetching visit status for shop: $shopId', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(endpoint);

      logger.info('Successfully fetched visit status for shop $shopId', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch visit status for shop $shopId: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching visit status for shop $shopId', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  // ===== ANALYTICS API =====

  /// Fetch shop analytics summary with rating filtering
  Future<Result<Map<String, dynamic>>> getShopAnalyticsSummary({
    int? territoryId,
    String? status,
    int? minRating,
    int? maxRating,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    const endpoint = '/api/v1/analytics/shops/summary';
    final queryParameters = {
      'tenant_id': tenantId, // Required by backend
      if (territoryId != null) 'territory_id': territoryId,
      if (status != null) 'status': status,
      if (minRating != null) 'min_rating': minRating,
      if (maxRating != null) 'max_rating': maxRating,
      if (fromDate != null) 'from_date': fromDate.toIso8601String().split('T')[0],
      if (toDate != null) 'to_date': toDate.toIso8601String().split('T')[0],
    };

    logger.info('Fetching shop analytics summary with tenant: $tenantId', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      logger.info('Successfully fetched shop analytics summary', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch shop analytics summary: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching shop analytics summary', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  // ===== OUTSTANDING PAYMENTS API =====

  /// Fetch outstanding payments list with filtering
  Future<Result<List<Map<String, dynamic>>>> getOutstandingPayments({
    DateTime? fromDate,
    DateTime? toDate,
    double? minAmount,
    double? maxAmount,
    String? shopSearch,
    int? page,
  }) async {
    const endpoint = '/api/v1/outstanding/';
    final queryParameters = {
      'tenant_id': tenantId,
      if (fromDate != null) 'from_date': fromDate.toIso8601String().split('T')[0],
      if (toDate != null) 'to_date': toDate.toIso8601String().split('T')[0],
      if (minAmount != null) 'min_amount': minAmount,
      if (maxAmount != null) 'max_amount': maxAmount,
      if (shopSearch != null) 'shop_search': shopSearch,
      if (page != null) 'page': page,
    };

    logger.info('Fetching outstanding payments list', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      // API returns a list directly, not wrapped in a map
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception('Expected a list, got ${rawData.runtimeType}');
      }

      final List<Map<String, dynamic>> outstandingPayments = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      logger.info('Successfully fetched outstanding payments list', 'REMOTE_DATA_SERVICE');
      return Result.ok(outstandingPayments);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch outstanding payments: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching outstanding payments', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch single outstanding payment by ID
  Future<Result<Map<String, dynamic>>> getOutstandingPaymentById(int paymentId) async {
    final endpoint = '/api/v1/outstanding/$paymentId';
    final queryParameters = {'tenant_id': tenantId};

    logger.info('Fetching outstanding payment with ID: $paymentId', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);

      logger.info('Successfully fetched outstanding payment: ${response.data['id']}', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch outstanding payment $paymentId: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching outstanding payment $paymentId', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch outstanding payments summary
  Future<Result<Map<String, dynamic>>> getOutstandingSummary() async {
    const endpoint = '/api/v1/outstanding/summary';
    final queryParameters = {'tenant_id': tenantId};

    logger.info('Fetching outstanding payments summary', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(endpoint, queryParameters: queryParameters);

      logger.info('Successfully fetched outstanding summary', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch outstanding summary: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching outstanding summary', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }

  /// Fetch single outstanding payment by ID
  Future<Result<Map<String, dynamic>>> getOutstandingById(int id) async {
    final endpoint = '/api/v1/outstanding/$id';

    logger.info('Fetching outstanding payment ID: $id', 'REMOTE_DATA_SERVICE');

    try {
      final response = await dio.get(endpoint);

      logger.info('Successfully fetched outstanding payment $id', 'REMOTE_DATA_SERVICE');
      return Result.ok(response.data as Map<String, dynamic>);
    } on DioException catch (e, stackTrace) {
      final errorMessage = _parseError(e);
      logger.error(
        'Failed to fetch outstanding payment $id: $errorMessage',
        'REMOTE_DATA_SERVICE',
        e,
        stackTrace,
      );
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching outstanding payment $id', 'REMOTE_DATA_SERVICE', e, stackTrace);
      return Result.error(Exception(DataConfig.unknownErrorMessage));
    }
  }
}
