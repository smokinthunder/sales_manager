import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/auth_interceptor.dart';
import 'package:sales_manager/utils/result.dart';

class RemoteOutstandingService {
  late Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "default";

  RemoteOutstandingService() {
    dio = Dio();
    dio.interceptors.add(AuthInterceptor(localAuth));
  }

  /// Create a new outstanding payment record
  Future<Result<Map<String, dynamic>>> createOutstanding({
    required String shopId,
    required String shopName,
    required double amount,
    required String dueDate, // ISO date string (YYYY-MM-DD)
    required String status, // "current", "upcoming", "overdue"
    int? salesExecutiveId,
    String? territoryId,
    double? originalAmount,
    int? daysOverdue,
    String? lastPaymentDate, // ISO date string (YYYY-MM-DD)
    String? notes,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      "shop_id": shopId,
      "shop_name": shopName,
      "amount": amount,
      "due_date": dueDate,
      "status": status,
      if (salesExecutiveId != null) "sales_executive_id": salesExecutiveId,
      if (territoryId != null) "territory_id": territoryId,
      if (originalAmount != null) "original_amount": originalAmount,
      if (daysOverdue != null) "days_overdue": daysOverdue,
      if (lastPaymentDate != null) "last_payment_date": lastPaymentDate,
      if (notes != null) "notes": notes,
    };
    
    try {
      print("Creating outstanding payment for shop $shopId");
      final Response response = await dio.post(
        ApiEndpoints.outstandingPayments,
        queryParameters: queryParameters,
        data: data,
      );
      
      // Safely cast the response data
      final rawData = response.data;
      if (rawData is! Map<String, dynamic>) {
        throw Exception("Expected a map, got ${rawData.runtimeType}");
      }

      print("Created outstanding payment: $rawData");
      return Result.ok(rawData);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error creating outstanding payment: ${e.message}");
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Get outstanding payments with filtering options
  Future<Result<List<Map<String, dynamic>>>> getOutstandingPayments({
    int? salesExecutiveId,
    String? territoryId,
    String? status, // "current", "upcoming", "overdue"
    String? startDate, // ISO date string (YYYY-MM-DD)
    String? endDate, // ISO date string (YYYY-MM-DD)
    String? shopSearch,
    double? minAmount,
    double? maxAmount,
  }) async {
    
    print("Fetching outstanding payments from ${ApiEndpoints.outstandingPayments} with tenant_id $tenantId");
    
    final queryParameters = {
      "tenant_id": tenantId,
      if (salesExecutiveId != null) "sales_executive_id": salesExecutiveId,
      if (territoryId != null) "territory_id": territoryId,
      if (status != null) "status": status,
      if (startDate != null) "start_date": startDate,
      if (endDate != null) "end_date": endDate,
      if (shopSearch != null) "shop_search": shopSearch,
      if (minAmount != null) "min_amount": minAmount,
      if (maxAmount != null) "max_amount": maxAmount,
    };
    
    try {
      print("get request for outstanding payments");
      final Response response = await dio.get(
        ApiEndpoints.outstandingPayments,
        queryParameters: queryParameters,
      );
      
      // Safely cast the response data
      final rawData = response.data;
      if (rawData is! List) {
        throw Exception("Expected a list, got ${rawData.runtimeType}");
      }

      final List<Map<String, dynamic>> outstandingPayments = rawData
          .map((item) => item as Map<String, dynamic>)
          .toList();

      print("Fetched outstanding payments: $outstandingPayments");
      return Result.ok(outstandingPayments);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error fetching outstanding payments: ${e.message}");
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Get specific outstanding payment by ID
  Future<Result<Map<String, dynamic>>> getOutstandingPayment(int outstandingId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      print("Fetching outstanding payment with ID $outstandingId");
      final Response response = await dio.get(
        "${ApiEndpoints.outstandingPayments}$outstandingId",
        queryParameters: queryParameters,
      );
      
      // Safely cast the response data
      final rawData = response.data;
      if (rawData is! Map<String, dynamic>) {
        throw Exception("Expected a map, got ${rawData.runtimeType}");
      }

      print("Fetched outstanding payment: $rawData");
      return Result.ok(rawData);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error fetching outstanding payment: ${e.message}");
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Update outstanding payment record
  Future<Result<Map<String, dynamic>>> updateOutstandingPayment({
    required int outstandingId,
    String? shopName,
    double? amount,
    String? dueDate, // ISO date string (YYYY-MM-DD)
    String? status, // "current", "upcoming", "overdue"
    int? salesExecutiveId,
    String? territoryId,
    double? originalAmount,
    int? daysOverdue,
    String? lastPaymentDate, // ISO date string (YYYY-MM-DD)
    String? notes,
  }) async {
    final queryParameters = {"tenant_id": tenantId};
    final data = {
      if (shopName != null) "shop_name": shopName,
      if (amount != null) "amount": amount,
      if (dueDate != null) "due_date": dueDate,
      if (status != null) "status": status,
      if (salesExecutiveId != null) "sales_executive_id": salesExecutiveId,
      if (territoryId != null) "territory_id": territoryId,
      if (originalAmount != null) "original_amount": originalAmount,
      if (daysOverdue != null) "days_overdue": daysOverdue,
      if (lastPaymentDate != null) "last_payment_date": lastPaymentDate,
      if (notes != null) "notes": notes,
    };
    
    try {
      print("Updating outstanding payment with ID $outstandingId");
      final Response response = await dio.put(
        "${ApiEndpoints.outstandingPayments}$outstandingId",
        queryParameters: queryParameters,
        data: data,
      );
      
      // Safely cast the response data
      final rawData = response.data;
      if (rawData is! Map<String, dynamic>) {
        throw Exception("Expected a map, got ${rawData.runtimeType}");
      }

      print("Updated outstanding payment: $rawData");
      return Result.ok(rawData);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error updating outstanding payment: ${e.message}");
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Delete outstanding payment record
  Future<Result<bool>> deleteOutstandingPayment(int outstandingId) async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      print("Deleting outstanding payment with ID $outstandingId");
      await dio.delete(
        "${ApiEndpoints.outstandingPayments}$outstandingId",
        queryParameters: queryParameters,
      );
      
      print("Successfully deleted outstanding payment with ID $outstandingId");
      // Return true for successful deletion (204 No Content)
      return Result.ok(true);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error deleting outstanding payment: ${e.message}");
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

  /// Get outstanding payment summary statistics
  Future<Result<Map<String, dynamic>>> getOutstandingSummary() async {
    final queryParameters = {"tenant_id": tenantId};
    try {
      print("Fetching outstanding summary from ${ApiEndpoints.outstandingPayments}summary/statistics");
      final Response response = await dio.get(
        "${ApiEndpoints.outstandingPayments}summary/statistics",
        queryParameters: queryParameters,
      );
      
      // Safely cast the response data
      final rawData = response.data;
      if (rawData is! Map<String, dynamic>) {
        throw Exception("Expected a map, got ${rawData.runtimeType}");
      }

      print("Fetched outstanding summary: $rawData");
      return Result.ok(rawData);
    } on DioException catch (e) {
      print("DioException Type: ${e.type}");
      print("Full Error: $e");
      print("Response Data: ${e.response?.data}");
      print("Response Status Code: ${e.response?.statusCode}");
      print("Error fetching outstanding summary: ${e.message}");
      return Result.error(Exception(e.response?.data['detail'] ?? e.message));
    }
  }

//   /// Get outstanding payments filtered by current status
//   Future<Result<List<Map<String, dynamic>>>> getCurrentOutstandingPayments({
//     int? salesExecutiveId,
//     String? territoryId,
//   }) async {
//     return getOutstandingPayments(
//       status: "current",
//       salesExecutiveId: salesExecutiveId,
//       territoryId: territoryId,
//     );
//   }

//   /// Get outstanding payments filtered by upcoming status
//   Future<Result<List<Map<String, dynamic>>>> getUpcomingOutstandingPayments({
//     int? salesExecutiveId,
//     String? territoryId,
//   }) async {
//     return getOutstandingPayments(
//       status: "upcoming",
//       salesExecutiveId: salesExecutiveId,
//       territoryId: territoryId,
//     );
//   }

//   /// Get outstanding payments filtered by overdue status
//   Future<Result<List<Map<String, dynamic>>>> getOverdueOutstandingPayments({
//     int? salesExecutiveId,
//     String? territoryId,
//   }) async {
//     return getOutstandingPayments(
//       status: "overdue",
//       salesExecutiveId: salesExecutiveId,
//       territoryId: territoryId,
//     );
//   }

//   /// Get outstanding payments for a specific shop
//   Future<Result<List<Map<String, dynamic>>>> getOutstandingPaymentsByShop(String shopId) async {
//     return getOutstandingPayments(shopSearch: shopId);
//   }

//   /// Get outstanding payments for a specific sales executive
//   Future<Result<List<Map<String, dynamic>>>> getOutstandingPaymentsByExecutive(int salesExecutiveId) async {
//     return getOutstandingPayments(salesExecutiveId: salesExecutiveId);
//   }

//   /// Get outstanding payments for a specific territory
//   Future<Result<List<Map<String, dynamic>>>> getOutstandingPaymentsByTerritory(String territoryId) async {
//     return getOutstandingPayments(territoryId: territoryId);
//   }

//   /// Get outstanding payments within a date range
//   Future<Result<List<Map<String, dynamic>>>> getOutstandingPaymentsByDateRange({
//     required String startDate, // ISO date string (YYYY-MM-DD)
//     required String endDate, // ISO date string (YYYY-MM-DD)
//     int? salesExecutiveId,
//     String? territoryId,
//     String? status,
//   }) async {
//     return getOutstandingPayments(
//       startDate: startDate,
//       endDate: endDate,
//       salesExecutiveId: salesExecutiveId,
//       territoryId: territoryId,
//       status: status,
//     );
//   }

//   /// Get outstanding payments within an amount range
//   Future<Result<List<Map<String, dynamic>>>> getOutstandingPaymentsByAmountRange({
//     required double minAmount,
//     required double maxAmount,
//     int? salesExecutiveId,
//     String? territoryId,
//     String? status,
//   }) async {
//     return getOutstandingPayments(
//       minAmount: minAmount,
//       maxAmount: maxAmount,
//       salesExecutiveId: salesExecutiveId,
//       territoryId: territoryId,
//       status: status,
//     );
//   }
}
