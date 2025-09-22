import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteUserService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteUserService() {
    
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  Future<Result<Response<Map<String, dynamic>>>> createUser({
    required String phone,
    required String name,
    required String email,
    required String role,
    required String status,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      "phone": phone,
      "name": name,
      "email": email,
      "role": role,
      "status": status,
    };
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.user,
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getUsers({
    String? role,
    String? status,
    String? search,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (role != null) "role": role,
      if (status != null) "status": status,
      if (search != null) "search": search,
    };
    try {
      Response<List<dynamic>> response = await dio.get(
        ApiEndpoints.user,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData == null) {
        return Result.error(Exception("No data received"));
      }
      final List<Map<String, dynamic>> users = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();
      return Result.ok(users);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> getUser(String userId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      Response<Map<String, dynamic>> response = await dio.get(
        ApiEndpoints.user + userId,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> updateUser({
    required String userId,
    required String name,
    required String email,
    required String role,
    required String status,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {"name": name, "email": email, "role": role, "status": status};
    try {
      final Response<Map<String, dynamic>> response = await dio.put(
        ApiEndpoints.user + userId,
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
    // TODO: Resolve the argument issue
  }

  Future<Result<Response<String>>> deleteUser(String userId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<String> response = await dio.delete(
        ApiEndpoints.user + userId,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> updateUserProfile({
    required String name,
    required String email,
    required String role,
    required String status,
  }) async {
    final data = {"name": name, "email": email, "role": role, "status": status};
    try {
      Response<Map<String, dynamic>> response = await dio.put(
        ApiEndpoints.profileMe,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> getUserByPhone(
    String phone,
  ) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        ApiEndpoints.byPhone + phone,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  void bulkUserStatusUpdate() {
    //TODO: Implement bulk user status update
  }
  Future<Result<Response<String>>> getPendingApprovals() async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      Response<String> response = await dio.get(
        ApiEndpoints.approvalsPending,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> approveProfileUpdate(
    String requestId,
  ) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<String> response = await dio.post(
        "${ApiEndpoints.approvals}$requestId/approve",
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> rejectProfileUpdate(
    String requestId,
    String reason,
  ) async {
    final queryParameters = {"tenant_id": tenantId, "reason": reason};
    try {
      final Response<String> response = await dio.post(
        "${ApiEndpoints.approvals}$requestId/reject",
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> getUserApprovalHistory(String userID) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<String> response = await dio.post(
        ApiEndpoints.approvalsHistory + userID,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }
}
