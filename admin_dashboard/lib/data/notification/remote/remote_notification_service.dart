import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/data/core/api_endpoints.dart';
import 'package:admin_dashboard/data/auth/remote/auth_interceptor.dart';
import 'package:admin_dashboard/data/notification/config/notification_config.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

class RemoteNotificationService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final LoggerService logger = LoggerService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteNotificationService() {
    dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: NotificationConfig.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: NotificationConfig.apiTimeoutSeconds),
        sendTimeout: Duration(seconds: NotificationConfig.apiTimeoutSeconds),
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    dio.interceptors.add(AuthInterceptor(localAuth));
    logger.info('RemoteNotificationService initialized', 'NOTIFICATION_SERVICE');
  }

  /// Parse DioException and return user-friendly error message
  String _parseError(DioException e) {
    logger.apiError(e.requestOptions.uri.toString(), e, e.stackTrace);
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NotificationConfig.timeoutErrorMessage;
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('detail')) {
            return data['detail'].toString();
          }
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
        }
        
        switch (statusCode) {
          case 400:
            return 'Invalid request. Please check your input.';
          case 401:
          case 403:
            return NotificationConfig.unauthorizedErrorMessage;
          case 404:
            return NotificationConfig.notFoundErrorMessage;
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
          case 502:
          case 503:
            return NotificationConfig.serverErrorMessage;
          default:
            return 'Request failed with status code: $statusCode';
        }
      
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      
      case DioExceptionType.connectionError:
        return NotificationConfig.networkErrorMessage;
      
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please check your connection.';
      
      default:
        return e.message ?? NotificationConfig.serverErrorMessage;
    }
  }

  /// Get all notifications for the current user
  Future<Result<List<Map<String, dynamic>>>> getNotifications({
    String? notificationType,
    bool? isConfirmed,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (notificationType != null) "notification_type": notificationType,
      if (isConfirmed != null) "is_confirmed": isConfirmed.toString(),
    };

    try {
      logger.apiRequest('GET', ApiEndpoints.notifications, queryParameters);
      
      Response<List<dynamic>> response = await dio.get(
        ApiEndpoints.notifications,
        queryParameters: queryParameters,
      );
      
      logger.apiResponse(
        response.statusCode ?? 0,
        ApiEndpoints.notifications,
        'Success: ${response.data?.length ?? 0} notifications',
      );
      
      final List<Map<String, dynamic>> notifications = response.data!
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      
      logger.info('Fetched ${notifications.length} notifications', 'NOTIFICATION_SERVICE');
      return Result.ok(notifications);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.error('Failed to fetch notifications: $errorMessage', 'NOTIFICATION_SERVICE', e);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching notifications', 'NOTIFICATION_SERVICE', e, stackTrace);
      return Result.error(Exception(NotificationConfig.fetchErrorMessage));
    }
  }

  /// Get a specific notification by ID
  Future<Result<Map<String, dynamic>>> getNotification(String notificationId) async {
    final queryParameters = {"tenant_id": tenantId};
    final endpoint = "${ApiEndpoints.notifications}$notificationId";

    try {
      logger.apiRequest('GET', endpoint, queryParameters);
      
      Response<Map<String, dynamic>> response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success',
      );
      
      logger.info('Fetched notification: $notificationId', 'NOTIFICATION_SERVICE');
      return Result.ok(response.data!);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.error('Failed to fetch notification $notificationId: $errorMessage', 'NOTIFICATION_SERVICE', e);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error fetching notification $notificationId', 'NOTIFICATION_SERVICE', e, stackTrace);
      return Result.error(Exception(NotificationConfig.fetchErrorMessage));
    }
  }

  /// Confirm (approve or reject) a notification
  Future<Result<Map<String, dynamic>>> confirmNotification({
    required String notificationId,
    required String action, // "approve" or "reject"
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {"action": action};
    final endpoint = ApiEndpoints.notificationConfirm.replaceAll("{}", notificationId);

    try {
      logger.apiRequest('POST', endpoint, {'action': action, ...queryParameters});
      
      Response<Map<String, dynamic>> response = await dio.post(
        endpoint,
        queryParameters: queryParameters,
        data: data,
      );
      
      logger.apiResponse(
        response.statusCode ?? 0,
        endpoint,
        'Success: $action action completed',
      );
      
      logger.info('Notification $notificationId $action successfully', 'NOTIFICATION_SERVICE');
      return Result.ok(response.data!);
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      final specificError = action == 'approve' 
          ? NotificationConfig.approveErrorMessage 
          : NotificationConfig.rejectErrorMessage;
      logger.error('Failed to $action notification $notificationId: $errorMessage', 'NOTIFICATION_SERVICE', e);
      return Result.error(Exception(errorMessage.isEmpty ? specificError : errorMessage));
    } catch (e, stackTrace) {
      logger.error('Unexpected error ${action}ing notification $notificationId', 'NOTIFICATION_SERVICE', e, stackTrace);
      final specificError = action == 'approve' 
          ? NotificationConfig.approveErrorMessage 
          : NotificationConfig.rejectErrorMessage;
      return Result.error(Exception(specificError));
    }
  }

  /// Get pending notifications count (unconfirmed notifications)
  Future<Result<int>> getPendingNotificationsCount() async {
    try {
      logger.info('Fetching pending notifications count', 'NOTIFICATION_SERVICE');
      
      final result = await getNotifications(isConfirmed: false);
      switch (result) {
        case Ok():
          final count = result.value.length;
          logger.info('Pending notifications count: $count', 'NOTIFICATION_SERVICE');
          return Result.ok(count);
        case Error():
          logger.error('Failed to get pending count: ${result.error}', 'NOTIFICATION_SERVICE');
          return Result.error(result.error);
      }
    } catch (e, stackTrace) {
      logger.error('Unexpected error getting pending count', 'NOTIFICATION_SERVICE', e, stackTrace);
      return Result.error(Exception('Failed to get pending notifications count'));
    }
  }
}
