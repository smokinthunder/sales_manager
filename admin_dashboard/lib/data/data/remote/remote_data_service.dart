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
    dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: DataConfig.apiTimeoutSeconds),
      receiveTimeout: Duration(seconds: DataConfig.apiTimeoutSeconds),
      sendTimeout: Duration(seconds: DataConfig.apiTimeoutSeconds),
    ));
    
    // Add auth interceptor (using LocalAuthService singleton)
    dio.interceptors.add(AuthInterceptor(LocalAuthService()));
    
    logger.info('RemoteDataService initialized with tenant: $tenantId', 'DATA_SERVICE');
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
}
