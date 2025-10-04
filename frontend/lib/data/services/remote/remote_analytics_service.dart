import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteAnalyticsService {
  late Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteAnalyticsService() {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  Future<Result<List<Map<String, dynamic>>>> getExecutiveTopCustomers({
    String? salesExecutiveId,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (salesExecutiveId != null) "sales_executive_id": salesExecutiveId,
    };
    try {
      final Response response = await dio.get(
        ApiEndpoints.executiveTopCustomers,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> result = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getExecutiveBestSellingProducts({
    String? salesExecutiveId,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (salesExecutiveId != null) "sales_executive_id": salesExecutiveId,
    };
    try {
      final Response response = await dio.get(
        ApiEndpoints.executiveBestSellingProducts,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> result = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getExecutiveSalesReport({
    String? salesExecutiveId,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (salesExecutiveId != null) "sales_executive_id": salesExecutiveId,
    };
    try {
      final Response response = await dio.get(
        ApiEndpoints.executiveSalesReport,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> result = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getShopPurchaseAnalysis({
    required String shopId,
    String? year,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      "shop_id": shopId,
      if (year != null) "year": year,
    };
    try {
      final response = await dio.get(
        ApiEndpoints.shopPurchaseAnalysis,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> result = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getShopBestSellingProducts({
    required String shopId,
    String? year,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      "shop_id": shopId,
      if (year != null) "year": year,
    };
    try {
      final response = await dio.get(
        ApiEndpoints.shopPurchaseAnalysis,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> result = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<List<Map<String, dynamic>>>> getShopSalesReport({
    required String shopId,
    String? year,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      "shop_id": shopId,
      if (year != null) "year": year,
    };
    try {
      final response = await dio.get(
        ApiEndpoints.shopPurchaseAnalysis,
        queryParameters: queryParameters,
      );
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> result = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      return Result.ok(result);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }
}
