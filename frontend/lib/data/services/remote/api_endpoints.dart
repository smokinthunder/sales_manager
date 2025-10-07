import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String _ipAddr = dotenv.env['IP_ADDR'] ?? "192.168.63.132";
  static final String _baseUrl = "http://$_ipAddr:8000/";
  static final String _apiUrl = "${_baseUrl}api/v1/";

  // End Points

  //Auth Apis
  static final String _authApi = "${_apiUrl}auth/";
  static final String generateOtp = "${_authApi}otp/generate";
  static final String verifyOtp = "${_authApi}otp/verify";
  static final String refreshToken = "${_authApi}token/refresh";
  static final String logout = "${_authApi}logout";
  static final String getCurrentUser = "${_authApi}me";

  //User Apis
  static final String _userApi = "${_apiUrl}users/";
  static final String user = _userApi;
  static final String profileMe = "${_userApi}profile/me";
  static final String byPhone = "${_userApi}by-phone/";
  static final String bulkStatusUpdate = "${_userApi}bulk-status-update";
  static final String approvalsPending = "${_userApi}approvals/pending";
  static final String approvals = "${_userApi}approvals/";
  static final String approvalsHistory = "${_userApi}approvals/history/";

  // territories Apis
  static final String territories = "${_apiUrl}territories/";

  // Routes Apis
  static final String routes = "${_apiUrl}routes/";
  static final String routeAssignments = "${routes}assignments/";

  // Shops Apis
  static final String shops = "${_apiUrl}shops/";

  // Outstanding Payment Apis
  static final String outstandingPayments = "${_apiUrl}outstanding/";
  
  // Notification Apis
  static final String _notificationApi = "${_apiUrl}notifications/";
  static final String notifications = _notificationApi;
  static final String notificationConfirm = "$_notificationApi{}}/confirm"; // {} will be replaced with notification ID

  // Analytics Apis
  static final String _analyticsApi = "${_apiUrl}analytics/";
  // Executive Analytics
  static final String _executiveAnalyticsApi = "${_analyticsApi}executive/";

  static final String executiveTopCustomers = "${_executiveAnalyticsApi}top_customers";
  static final String executiveBestSellingProducts = "${_executiveAnalyticsApi}best_selling_products";
  static final String executiveSalesReport = "${_executiveAnalyticsApi}sales_report";

  // Shops Analytics 
  static final String _shopsAnalyticsApi = "${_analyticsApi}shops/";

  static final String shopPurchaseAnalysis = "${_shopsAnalyticsApi}purchase_analysis";
  static final String shopBestSellingProducts = "${_shopsAnalyticsApi}best_selling_products";
  static final String shopSalesReport = "${_shopsAnalyticsApi}sales_report";

}
