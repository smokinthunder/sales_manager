import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteShopService {
  late Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

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
    String? pinCode,
    String? email,
    String? aadhaarNumber,
    String? panNumber,
    String? locationName,
    String? gstNumber,
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
    
    // Add optional fields if provided
    if (pinCode != null && pinCode.isNotEmpty) data["pin_code"] = pinCode;
    if (email != null && email.isNotEmpty) data["email"] = email;
    if (aadhaarNumber != null && aadhaarNumber.isNotEmpty) data["aadhaar_number"] = aadhaarNumber;
    if (panNumber != null && panNumber.isNotEmpty) data["pan_number"] = panNumber;
    if (locationName != null && locationName.isNotEmpty) data["location_name"] = locationName;
    if (gstNumber != null && gstNumber.isNotEmpty) data["gst_number"] = gstNumber;
    
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

  Future<Result<List<Map<String, dynamic>>>> getShops({
    String? status,
    String? territoryId,
  }) async {
    print("Fetching shops from ${ApiEndpoints.shops} with tenant_id $tenantId");
    final queryParameters = {
      "tenant_id": tenantId,
      if (status != null) "status": status,
      if (territoryId != null) "territory_id": territoryId,
    };
    try {
      print("get request");
      final Response response = await dio.get(
        ApiEndpoints.shops,
        queryParameters: queryParameters,
      );
      // Safely cast the response data
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> shops = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      print("Fetched shops: $shops");
      return Result.ok(shops);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error fetching shops: ${e.message}");
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
