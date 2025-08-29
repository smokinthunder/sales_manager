import 'package:dio/dio.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteAuthService {
  final dio = Dio();
  Future<Result<Response<Map<String, dynamic>>>> generateOtp(
    String phoneNumber,
  ) async {
    final data = {"phone": phoneNumber, "tenant_id": "default"};
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.generateOtp,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    final data = {"phone": phoneNumber, "otp": otp, "tenant_id": "default"};
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.verifyOtp,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> refreshTocken(
    String refreshToken,
  ) async {
    final data = {"refresh_token": refreshToken};
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.refreshToken,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> logout() async {
    try {
      Response<String> response = await dio.post(ApiEndpoints.logout);
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
