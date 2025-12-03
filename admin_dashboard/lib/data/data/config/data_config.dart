/// Configuration class for data fetching system (users, shops, analytics)
/// 
/// Centralizes all constants, error messages, and settings following
/// the same professional pattern as AuthConfig and NotificationConfig.
class DataConfig {
  // ===== API Configuration =====
  
  /// API request timeout in seconds
  static const int apiTimeoutSeconds = 30;
  
  /// Maximum number of API retries on failure
  static const int maxApiRetries = 3;
  
  /// Delay between retries in seconds
  static const int retryDelaySeconds = 2;
  
  // ===== Pagination Configuration =====
  
  /// Number of items to load per page
  static const int itemsPerPage = 20;
  
  /// Number of items to load initially
  static const int initialLoadCount = 50;
  
  /// Enable infinite scrolling
  static const bool enableInfiniteScroll = true;
  
  // ===== Cache Configuration =====
  
  /// Cache duration for user data in minutes
  static const int userCacheDurationMinutes = 10;
  
  /// Cache duration for shop data in minutes
  static const int shopCacheDurationMinutes = 15;
  
  /// Cache duration for dashboard stats in minutes
  static const int statsCacheDurationMinutes = 5;
  
  /// Cache duration for analytics data in minutes
  static const int analyticsCacheDurationMinutes = 10;
  
  /// Enable caching for better performance
  static const bool enableCaching = true;
  
  // ===== Search Configuration =====
  
  /// Minimum characters required for search
  static const int minSearchLength = 2;
  
  /// Debounce delay for search in milliseconds
  static const int searchDebounceMs = 500;
  
  /// Enable fuzzy search
  static const bool enableFuzzySearch = false;
  
  // ===== Filter Configuration =====
  
  /// Available user roles for filtering
  static const List<String> availableUserRoles = [
    'superadmin',
    'client_admin',
    'area_manager',
    'sales_executive',
  ];
  
  /// Available user statuses for filtering
  static const List<String> availableUserStatuses = [
    'active',
    'inactive',
    'suspended',
  ];
  
  /// Available shop statuses for filtering
  static const List<String> availableShopStatuses = [
    'active',
    'inactive',
    'suspended',
    'closed',
  ];
  
  // ===== Error Messages =====
  
  /// Network connection error message
  static const String networkErrorMessage = 
      'Unable to connect to server. Please check your internet connection.';
  
  /// Timeout error message
  static const String timeoutErrorMessage = 
      'Request timed out. Please check your connection and try again.';
  
  /// Unauthorized error message (401/403)
  static const String unauthorizedErrorMessage = 
      'You are not authorized to perform this action.';
  
  /// Not found error message (404)
  static const String notFoundErrorMessage = 
      'Requested data not found. It may have been deleted or moved.';
  
  /// Bad request error message (400)
  static const String badRequestErrorMessage = 
      'Invalid request. Please check your input and try again.';
  
  /// Rate limit error message (429)
  static const String rateLimitErrorMessage = 
      'Too many requests. Please wait a moment and try again.';
  
  /// Server error message (500+)
  static const String serverErrorMessage = 
      'Server error occurred. Please try again later or contact support.';
  
  /// Unknown error message
  static const String unknownErrorMessage = 
      'An unexpected error occurred. Please try again.';
  
  /// Users fetch error
  static const String fetchUsersErrorMessage = 
      'Failed to load users. Please try again.';
  
  /// Shops fetch error
  static const String fetchShopsErrorMessage = 
      'Failed to load shops. Please try again.';
  
  /// Dashboard stats fetch error
  static const String fetchStatsErrorMessage = 
      'Failed to load dashboard statistics. Please try again.';
  
  /// Analytics fetch error
  static const String fetchAnalyticsErrorMessage = 
      'Failed to load analytics data. Please try again.';
  
  // ===== Success Messages =====
  
  /// Users loaded successfully
  static const String usersLoadedSuccessMessage = 
      'Users loaded successfully';
  
  /// Shops loaded successfully
  static const String shopsLoadedSuccessMessage = 
      'Shops loaded successfully';
  
  /// Dashboard stats loaded successfully
  static const String statsLoadedSuccessMessage = 
      'Dashboard statistics loaded successfully';
  
  /// Analytics loaded successfully
  static const String analyticsLoadedSuccessMessage = 
      'Analytics data loaded successfully';
  
  /// Data refreshed successfully
  static const String dataRefreshedSuccessMessage = 
      'Data refreshed successfully';
  
  // ===== Validation Rules =====
  
  /// Minimum name length
  static const int minNameLength = 2;
  
  /// Maximum name length
  static const int maxNameLength = 100;
  
  /// Phone number regex pattern
  static const String phoneRegex = r'^\+?[1-9]\d{9,14}$';
  
  /// Email regex pattern
  static const String emailRegex = 
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // ===== Display Configuration =====
  
  /// Show timestamps in lists
  static const bool showTimestamps = true;
  
  /// Date format for display
  static const String displayDateFormat = 'MMM dd, yyyy';
  
  /// Date-time format for display
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  /// Show inactive items by default
  static const bool showInactiveByDefault = false;
  
  /// Highlight new items (created in last N days)
  static const int newItemDays = 7;
  
  /// Card view vs list view
  static const bool defaultToCardView = true;
  
  // ===== Feature Flags =====
  
  /// Enable user management features
  static const bool enableUserManagement = true;
  
  /// Enable shop management features
  static const bool enableShopManagement = true;
  
  /// Enable analytics features
  static const bool enableAnalytics = true;
  
  /// Enable export functionality
  static const bool enableExport = false;
  
  /// Enable bulk operations
  static const bool enableBulkOperations = false;
  
  /// Enable advanced filtering
  static const bool enableAdvancedFiltering = true;
  
  /// Enable real-time updates (WebSocket)
  static const bool enableRealTimeUpdates = false;
  
  /// Enable offline mode
  static const bool enableOfflineMode = false;
  
  // ===== Logging Configuration =====
  
  /// Enable verbose logging for debugging
  static const bool enableVerboseLogging = true;
  
  /// Enable debug mode
  static const bool enableDebugMode = true;
  
  /// Log all API requests
  static const bool logApiRequests = true;
  
  /// Log all API responses
  static const bool logApiResponses = true;
  
  /// Log cache operations
  static const bool logCacheOperations = false;
  
  // ===== Performance Configuration =====
  
  /// Enable lazy loading
  static const bool enableLazyLoading = true;
  
  /// Preload next page when reaching this percentage
  static const double preloadThresholdPercentage = 0.8;
  
  /// Maximum concurrent API requests
  static const int maxConcurrentRequests = 3;
  
  // ===== Analytics Configuration =====
  
  /// Default analytics period in days
  static const int defaultAnalyticsPeriodDays = 30;
  
  /// Maximum analytics period in days
  static const int maxAnalyticsPeriodDays = 365;
  
  /// Number of top customers to show
  static const int topCustomersCount = 10;
  
  /// Number of best selling products to show
  static const int bestSellingProductsCount = 10;
  
  // Prevent instantiation
  const DataConfig._();
}
