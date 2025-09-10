import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteShopService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "super_tenant";

  RemoteShopService() {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  Future<Result<Response<Map<String, dynamic>>>> createShop({
    required String shopId,
    required String name,
    required String status,
    required String address,
    required String phone,
    required String contactPerson,
    required double latitude,
    required double longitude,
    required String territoryId,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      "shop_id": shopId,
      "name": name,
      "status": status,
      "address": address,
      "phone": phone,
      "contact_person": contactPerson,
      "latitude": latitude,
      "longitude": longitude,
      "territory_id": territoryId,
    };
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.shops,
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<List<Map<String, dynamic>>>>> getShops({
    String? status,
    String? territoryId,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (status != null) "status": status,
      if (territoryId != null) "territory_id": territoryId,
    };
    try {
      final Response<List<Map<String, dynamic>>> response = await dio.get(
        ApiEndpoints.shops,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> getShop(String shopId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      Response<Map<String, dynamic>> response = await dio.get(
        ApiEndpoints.shops + shopId,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> updateShop({
    required String shopId,
    String? name,
    String? status,
    String? address,
    String? phone,
    String? contactPerson,
    double? latitude,
    double? longitude,
    String? territoryId,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      if (name != null) "name": name,
      if (status != null) "status": status,
      if (address != null) "address": address,
      if (phone != null) "phone": phone,
      if (contactPerson != null) "contact_person": contactPerson,
      if (latitude != null) "latitude": latitude,
      if (longitude != null) "longitude": longitude,
      if (territoryId != null) "territory_id": territoryId,
    };
    try {
      final Response<Map<String, dynamic>> response = await dio.put(
        ApiEndpoints.shops + shopId,
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> deleteShop(String shopId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<String> response = await dio.delete(
        ApiEndpoints.shops + shopId,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }
}
