abstract class AppRoutes {
  //loading for
  static const loading = '/';
  static const login = '/login';
  static const otp = '/otp_screen';

  //Executive routes
  static const executive = '/executive';
  static const executiveHome = '/executive/home';
  static const executiveProfile = '/executive/profile';
  static const executiveAnalytics = '/executive/analytics';
  static const executiveAnalyticsConsolidated =
      '/executive/analytics/consolidated';
  static const executiveAnalyticsIndividual = '/executive/analytics/individual';
  static const executiveOutStanding = '/executive/outstanding'; //TODO
  static const executiveNotVisiting =
      '/executive/not_visiting'; //Rewrite with shop_id as argument?
  static const executiveAddShop = '/executive/add_shop';
  static const executiveWaitForApproval = '/executive/wait_for_approval';
  static const executiveTopCustomers = '/executive/top_customers';
  static const executiveShopDetails = '/executive/shop_details';

  //Area Manager Routes
  static const areaManager = '/area_manager';
  static const areaManagerHome = '/area_manager/home';
  static const areaManagerProfile = '/area_manager/profile';
  static const areaManagerAnalytics = '/area_manager/analytics';
  static const areaManagerOutStanding = '/area_manager/outstanding';
  static const areaManagerPendingRequests = '/area_manager/pending_requests';
  static const areaManagerNotifications = '/area_manager/notifications';
  static const areaManagerMessages = '/area_manager/messages';
  static const areaManagerUserMessege =
      '/area_manager/user_message'; //Rewrite with user_id as argument?
  // static String quizDetail(String id) => '/quiz/$id';
}
