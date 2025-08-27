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
}
