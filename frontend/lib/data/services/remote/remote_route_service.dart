import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteRouteService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "super_tenant";

  RemoteRouteService() {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  Future<Result<Response<Map<String, dynamic>>>> createRoute({
    required String name,
    required String territoryId,
    required String weekStartDate,
    String? routeId,
    String status = "planned",
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      if (routeId != null) "route_id": routeId,
      "name": name,
      "territory_id": territoryId,
      "week_start_date": weekStartDate,
      "status": status,
    };
    try {
      final Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.routes,
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<List<dynamic>>>> getRoutes({
    int? executiveId,
    String? weekStart,
    String? routeStatus,
  }) async {
    final queryParameters = {
      "tenant_id": tenantId,
      if (executiveId != null) "executive_id": executiveId,
      if (weekStart != null) "week_start": weekStart,
      if (routeStatus != null) "route_status": routeStatus,
    };
    try {
      final Response<List<dynamic>> response = await dio.get(
        ApiEndpoints.routes,
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> getRoute(
    String routeId,
  ) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '${ApiEndpoints.routes}$routeId',
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> updateRoute({
    required String routeId,
    String? name,
    String? territoryId,
    String? weekStartDate,
    String? status,
    String? updateRouteId,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      if (name != null) "name": name,
      if (territoryId != null) "territory_id": territoryId,
      if (weekStartDate != null) "week_start_date": weekStartDate,
      if (status != null) "status": status,
      if (updateRouteId != null) "route_id": updateRouteId,
    };
    try {
      final Response<Map<String, dynamic>> response = await dio.put(
        '${ApiEndpoints.routes}$routeId',
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<void>>> deleteRoute(String routeId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<String> response = await dio.delete(
        '${ApiEndpoints.routes}$routeId',
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> addShopToRoute({
    required String routeId,
    required int shopId,
    required int salesExecutiveId,
    required String plannedDate,
    String? plannedTime,
    int? sequenceOrder,
    String status = "planned",
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      "shop_id": shopId,
      "sales_executive_id": salesExecutiveId,
      "planned_date": plannedDate,
      if (plannedTime != null) "planned_time": plannedTime,
      if (sequenceOrder != null) "sequence_order": sequenceOrder,
      "status": status,
    };
    try {
      final Response<Map<String, dynamic>> response = await dio.post(
        '${ApiEndpoints.routes}$routeId/assignments',
        queryParameters: queryParameters,
        data: data,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<Map<String, dynamic>>>> getRouteWithAssignments(
    String routeId,
  ) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<Map<String, dynamic>> response = await dio.get(
        '${ApiEndpoints.routes}$routeId/assignments',
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  Future<Result<Response<void>>> removeShopFromRoute({
    required String routeId,
    required int assignmentId,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      final Response<String> response = await dio.delete(
        '${ApiEndpoints.routes}$routeId/assignments/$assignmentId',
        queryParameters: queryParameters,
      );
      return Result.ok(response);
    } on DioException catch (e) {
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }
}
