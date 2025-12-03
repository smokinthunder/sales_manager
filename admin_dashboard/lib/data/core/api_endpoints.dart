import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String _ipAddr = dotenv.env['IP_ADDR'] ?? "192.168.63.132";
  static final String _baseUrl = "http://$_ipAddr:8000/";
  static final String _apiUrl = "${_baseUrl}api/v1/";

  // End Points

  // Email Auth Apis
  static final String _emailAuthApi = "${_apiUrl}auth/email/";
  static final String emailLogin = "${_emailAuthApi}login";
  static final String emailForgotPassword = "${_emailAuthApi}forgot-password";
  static final String emailResetPassword = "${_emailAuthApi}reset-password";
  static final String emailChangePassword = "${_emailAuthApi}change-password";
  static final String emailCheckEmail = "${_emailAuthApi}check-email";

  // User Apis
  static final String _userApi = "${_apiUrl}users/";
  static final String user = _userApi;
  static final String profileMe = "${_userApi}profile/me";
  static final String byPhone = "${_userApi}by-phone/";
  static final String bulkStatusUpdate = "${_userApi}bulk-status-update";
  static final String approvalsPending = "${_userApi}approvals/pending";
  static final String approvals = "${_userApi}approvals/";
  static final String approvalsHistory = "${_userApi}approvals/history/";

  // Notification Apis
  static final String _notificationApi = "${_apiUrl}notifications/";
  static final String notifications = _notificationApi;
  static final String notificationConfirm = "$_notificationApi{}/confirm"; // {} will be replaced with notification ID

  // Shop/Customer Apis
  static final String _shopsApi = "${_apiUrl}shops/";
  static final String shops = _shopsApi;
  static final String shopById = "$_shopsApi{}"; // {} will be replaced with shop_id
  static final String shopSyncedData = "$_shopsApi{}/synced-data"; // {} will be replaced with shop_id
  static final String shopPaymentStatus = "$_shopsApi{}/payment-status"; // {} will be replaced with shop_id
  static final String shopOrders = "$_shopsApi{}/orders"; // {} will be replaced with shop_id
  static final String shopAnalytics = "$_shopsApi{}/analytics"; // {} will be replaced with shop_id

  // Analytics Apis
  static final String _analyticsApi = "${_apiUrl}analytics/";
  static final String analyticsExecutiveTopCustomers = "${_analyticsApi}executive/top_customers";
  static final String analyticsExecutiveBestSellingProducts = "${_analyticsApi}executive/best_selling_products";
  static final String analyticsExecutiveSalesReport = "${_analyticsApi}executive/sales_report";
  static final String analyticsExecutivePurchaseAnalysis = "${_analyticsApi}executive/purchase_analysis";
  static final String analyticsShopBestSellingProducts = "${_analyticsApi}shop/best_selling_products";
  static final String analyticsShopSalesReport = "${_analyticsApi}shop/sales_report";

}
