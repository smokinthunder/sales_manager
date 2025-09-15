import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteTerritoryService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteTerritoryService() {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  Future<Result<Response<Map<String, dynamic>>>> createTerritory({
    required String territoryId,
    required String name,
    required String code,
    required String description,
    required String areaManagerId,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      "territory_id": territoryId,
      "name": name,
      "code": code,
      "description": description,
      "area_manager_id": areaManagerId,
    };
    try {
      final Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.territories,
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<List<Map<String,dynamic>>>>> getTerritories() async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      Response<List<Map<String,dynamic>>> response = await dio.get(
        ApiEndpoints.territories,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> getTerritory(
    String territoryId,
  ) async {
    final queryParameters = {
      "tenant_id": tenantId,
    };
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '${ApiEndpoints.territories}$territoryId',
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> updateTerritory({
    required String territoryId,
    required String updateTerritoryId,
    required String name,
    required String code,
    required String description,
    required String areaManagerId,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
    };
    final data = {
      "territory_id": updateTerritoryId,
      "name": name,
      "code": code,
      "description": description,
      "area_manager_id": areaManagerId,
    };
    try {
      Response<Map<String, dynamic>> response = await dio.put(
        '${ApiEndpoints.territories}$territoryId',
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<String>>> deleteTerritory(
    String territoryId,
  ) async {
    final queryParameters = {
      "tenant_id": tenantId,
    };
    try {
      final Response<String> response =  await dio.delete(
        '${ApiEndpoints.territories}$territoryId',
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }
}