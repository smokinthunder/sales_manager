/// Notification System Configuration
/// 
/// This class contains all notification-related configuration
/// constants, timeouts, error messages, and settings.
class NotificationConfig {
  /// Private constructor to prevent instantiation
  NotificationConfig._();

  // ============== API Configuration ==============
  
  /// API request timeout in seconds
  static const int apiTimeoutSeconds = 30;
  
  /// Maximum number of API retry attempts
  static const int maxApiRetries = 3;
  
  /// Delay between API retry attempts (in milliseconds)
  static const int apiRetryDelayMs = 1000;
  
  /// Auto-refresh interval for notifications (in seconds)
  /// Set to 0 to disable auto-refresh
  static const int autoRefreshIntervalSeconds = 60;

  // ============== Notification Configuration ==============
  
  /// Maximum notifications to display per page
  static const int notificationsPerPage = 20;
  
  /// Maximum age of notifications to display (in days)
  /// Older notifications will be filtered out
  static const int maxNotificationAgeDays = 30;
  
  /// Enable notification sound/vibration
  static const bool enableNotificationAlerts = true;
  
  /// Show confirmed notifications
  static const bool showConfirmedNotifications = true;

  // ============== Cache Configuration ==============
  
  /// Cache duration for notification data (in minutes)
  static const int cacheValidityMinutes = 5;
  
  /// Maximum number of notifications to cache
  static const int maxCachedNotifications = 100;

  // ============== Action Configuration ==============
  
  /// Timeout for approve/reject actions (in seconds)
  static const int actionTimeoutSeconds = 15;
  
  /// Show confirmation dialog before approve/reject
  static const bool requireConfirmation = true;
  
  /// Auto-dismiss notification after approval
  static const bool autoDismissOnApproval = false;

  // ============== Notification Types ==============
  
  /// Profile update notification type identifier
  static const String typeProfileUpdate = 'profile_update';
  
  /// Customer creation notification type identifier
  static const String typeCustomerCreation = 'customer_creation';
  
  /// Shop update notification type identifier
  static const String typeShopUpdate = 'shop_update';
  
  /// Order notification type identifier
  static const String typeOrderNotification = 'order_notification';

  // ============== Display Configuration ==============
  
  /// Default profile image URL when none is provided
  static const String defaultProfileImageUrl = 'https://ui-avatars.com/api/';
  
  /// Date format for notifications (e.g., "Dec 2, 2024")
  static const String dateFormat = 'MMM d, yyyy';
  
  /// Time format for notifications (e.g., "2:30 PM")
  static const String timeFormat = 'h:mm a';
  
  /// Relative time threshold (show "2h ago" if less than this many hours)
  static const int relativeTimeThresholdHours = 24;

  // ============== Error Messages ==============
  
  /// Default error message for network failures
  static const String networkErrorMessage = 
      'Unable to connect to server. Please check your internet connection.';
  
  /// Default error message for fetching notifications
  static const String fetchErrorMessage = 
      'Failed to load notifications. Please try again.';
  
  /// Default error message for approval action
  static const String approveErrorMessage = 
      'Failed to approve notification. Please try again.';
  
  /// Default error message for rejection action
  static const String rejectErrorMessage = 
      'Failed to reject notification. Please try again.';
  
  /// Default error message for timeout
  static const String timeoutErrorMessage = 
      'Request timed out. Please check your connection and try again.';
  
  /// Default error message for unauthorized access
  static const String unauthorizedErrorMessage = 
      'You are not authorized to perform this action.';
  
  /// Default error message for server errors
  static const String serverErrorMessage = 
      'Server error occurred. Please try again later or contact support.';
  
  /// Default error message when notification not found
  static const String notFoundErrorMessage = 
      'Notification not found. It may have been already processed.';

  // ============== Success Messages ==============
  
  /// Success message for approval
  static const String approveSuccessMessage = 
      'Request approved successfully';
  
  /// Success message for rejection
  static const String rejectSuccessMessage = 
      'Request rejected successfully';
  
  /// Success message for refresh
  static const String refreshSuccessMessage = 
      'Notifications updated';

  // ============== Validation ==============
  
  /// Minimum notification ID length
  static const int minNotificationIdLength = 1;
  
  /// Maximum notification subject length for display
  static const int maxSubjectDisplayLength = 100;
  
  /// Maximum sender name length for display
  static const int maxSenderNameDisplayLength = 50;

  // ============== Feature Flags ==============
  
  /// Enable notification filtering
  static const bool enableFiltering = true;
  
  /// Enable notification search
  static const bool enableSearch = true;
  
  /// Enable bulk actions (approve/reject multiple)
  static const bool enableBulkActions = false;
  
  /// Enable notification export
  static const bool enableExport = false;
  
  /// Enable real-time notifications (WebSocket/SSE)
  static const bool enableRealTime = false;

  // ============== Logging Configuration ==============
  
  /// Enable verbose logging for notifications
  static const bool enableVerboseLogging = true;
  
  /// Log notification fetch operations
  static const bool logFetchOperations = true;
  
  /// Log notification actions (approve/reject)
  static const bool logActions = true;
}
