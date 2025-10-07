import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteNotificationService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteNotificationService() {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
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
      Response<List<dynamic>> response = await dio.get(
        ApiEndpoints.notifications,
        queryParameters: queryParameters,
      );
      
      final List<Map<String, dynamic>> notifications = response.data!
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      
      return Result.ok(notifications);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Get a specific notification by ID
  Future<Result<Map<String, dynamic>>> getNotification(String notificationId) async {
    final queryParameters = {"tenant_id": tenantId};

    try {
      Response<Map<String, dynamic>> response = await dio.get(
        "${ApiEndpoints.notifications}$notificationId",
        queryParameters: queryParameters,
      );
      return Result.ok(response.data!);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Confirm (approve or reject) a notification
  Future<Result<Map<String, dynamic>>> confirmNotification({
    required String notificationId,
    required String action, // "approve" or "reject"
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {"action": action};

    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.notificationConfirm.replaceAll("{}", notificationId),
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response.data!);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Get pending notifications count (unconfirmed notifications)
  Future<Result<int>> getPendingNotificationsCount() async {
    try {
      final result = await getNotifications(isConfirmed: false);
      switch (result) {
        case Ok():
          return Result.ok(result.value.length);
        case Error():
          return Result.error(result.error);
      }
    } catch (e) {
      return Result.error(Exception('Failed to get pending notifications count'));
    }
  }
}