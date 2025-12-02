abstract class Routes {
  //Login and Auth Routes
  static const String login = '/';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String changePassword = '/change-password';

  //Dashboard and related Routes
  static const String dashboard = '/dashboard';
  static const String analyzeNewCustomers = "/dashboard/new-customer";
  static const String analyzeSales = "/dashboard/sales";
  static const String analyzeCollection = "/dashboard/collection";

  //Customer and related Routes
  static const String customer = '/customer';
  static const String customerDetails = '/customer/details';
  static const String addNewCusomter = "/customer/add-new-customer";
  static const String activeCustomers = "/customer/active-customers";
  static const String inactiveCustomers = "/customer/inactive-customers";

  //Analytics and related Routes
  static const String analytics = '/analytics';
  static const String shopAnalytics = '/analytics/shop-analytics';
  static const String pointSystem = '/analytics/point-system';

  //Executives and related Routes
  static const String executive = '/executive';
  static const String assignSpecialRoutes = '/executive/assign-special-routes';
  static const String findDealers = '/executive/find-dealers';

  //AreaManager and related Routes
  static const String areaManager = '/area-manager';
  static const String findExecutive = '/area-manager/find-executives';
  static const String addAreaManager = '/area-manager/add-new';

  //Outstanding and related Routes
  static const String outstanding = '/outstanding';
  static const String viewInvoice = "/outstanding/view-invoice";
  static const String viewDetails = '/outstanding/more-details';

  //Notifications
  static const String notifications = "/notifications";

  //Order and related Routes
  static const String order = '/order';
  static const String viewOrderDetails = '/order/view-order-details';
}
