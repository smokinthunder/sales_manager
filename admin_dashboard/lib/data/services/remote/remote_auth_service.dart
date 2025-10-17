import 'package:admin_dashboard/data/services/local/local_auth_service.dart';
import 'package:admin_dashboard/data/services/remote/api_endpoints.dart';
import 'package:admin_dashboard/data/services/remote/auth_interceptor.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteAuthService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteAuthService({bool useInterceptor = true}) {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  Future<Result<Response<Map<String, dynamic>>>> loginWithEmail(
    String email,
    String password,
  ) async {
    final queryParameters = {
      "email": email,
      "password": password,
      "tenant_id": tenantId,
    };
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndPoints.login,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> refreshToken(
    String refreshToken,
  ) async {
    final data = {"refresh_token": refreshToken};
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndPoints.refreshToken,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> logout() async {
    try {
      Response<String> response = await dio.post(ApiEndPoints.logout);
      return Result.ok(response);
    } on DioException catch (e) {
      // Extract error message from server response or use Dio's fallback
      String errorMessage = "Something went wrong";

      // Check if response data is a Map (JSON), and extract 'message' or 'detail'
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data;
        errorMessage = data['detail'] ?? data['message'] ?? errorMessage;
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      return Result.error(Exception(errorMessage));
    }
  }
}
