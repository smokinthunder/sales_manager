/// Authentication Configuration
/// 
/// This class contains all authentication-related configuration
/// constants, timeouts, and settings.
class AuthConfig {
  /// Private constructor to prevent instantiation
  AuthConfig._();

  // ============== Token Configuration ==============
  
  /// Buffer time before token expiry to trigger refresh (in seconds)
  /// Tokens will be refreshed 30 seconds before they expire
  static const int tokenRefreshBufferSeconds = 30;
  
  /// Maximum number of token refresh retry attempts
  static const int maxRefreshRetries = 3;
  
  /// Delay between refresh retry attempts (in milliseconds)
  static const int refreshRetryDelayMs = 1000;

  // ============== Session Configuration ==============
  
  /// Session timeout in minutes (for inactive sessions)
  static const int sessionTimeoutMinutes = 30;
  
  /// Remember me token duration in days
  static const int rememberMeTokenDays = 30;

  // ============== Password Configuration ==============
  
  /// Minimum password length
  static const int minPasswordLength = 8;
  
  /// Maximum password length
  static const int maxPasswordLength = 128;
  
  /// Password reset token validity in hours
  static const int passwordResetTokenValidityHours = 24;

  // ============== API Configuration ==============
  
  /// API request timeout in seconds
  static const int apiTimeoutSeconds = 30;
  
  /// Maximum number of API retry attempts
  static const int maxApiRetries = 3;
  
  /// Delay between API retry attempts (in milliseconds)
  static const int apiRetryDelayMs = 1000;

  // ============== Security Configuration ==============
  
  /// Maximum login attempts before account lockout
  static const int maxLoginAttempts = 5;
  
  /// Account lockout duration in minutes
  static const int accountLockoutMinutes = 30;
  
  /// Enable biometric authentication (future feature)
  static const bool enableBiometric = false;

  // ============== Storage Keys ==============
  
  /// Secure storage key for access token
  static const String accessTokenKey = 'access_token';
  
  /// Secure storage key for refresh token
  static const String refreshTokenKey = 'refresh_token';
  
  /// Secure storage key for token expiry time
  static const String expiresAtKey = 'expires_at';
  
  /// Secure storage key for user ID
  static const String userIdKey = 'user_id';
  
  /// Secure storage key for user email
  static const String userEmailKey = 'user_email';
  
  /// Secure storage key for user name
  static const String userNameKey = 'user_name';
  
  /// Secure storage key for user role
  static const String userRoleKey = 'user_role';
  
  /// Secure storage key for remember me preference
  static const String rememberMeKey = 'remember_me';

  // ============== Error Messages ==============
  
  /// Default error message for network failures
  static const String networkErrorMessage = 
      'Unable to connect to server. Please check your internet connection.';
  
  /// Default error message for authentication failures
  static const String authErrorMessage = 
      'Authentication failed. Please check your credentials and try again.';
  
  /// Default error message for token expiry
  static const String tokenExpiredMessage = 
      'Your session has expired. Please login again.';
  
  /// Default error message for account lockout
  static const String accountLockedMessage = 
      'Account temporarily locked due to multiple failed login attempts. Please try again in 30 minutes.';
  
  /// Default error message for server errors
  static const String serverErrorMessage = 
      'An unexpected error occurred. Please try again later.';
  
  /// Default error message for invalid credentials
  static const String invalidCredentialsMessage = 
      'Invalid email or password. Please try again.';

  // ============== Success Messages ==============
  
  /// Success message for login
  static const String loginSuccessMessage = 'Login successful!';
  
  /// Success message for password reset request
  static const String passwordResetRequestSuccessMessage = 
      'Password reset link has been sent to your email.';
  
  /// Success message for password reset
  static const String passwordResetSuccessMessage = 
      'Password reset successful! Please login with your new password.';
  
  /// Success message for password change
  static const String passwordChangeSuccessMessage = 
      'Password changed successfully!';
  
  /// Success message for logout
  static const String logoutSuccessMessage = 'Logged out successfully!';

  // ============== Validation Messages ==============
  
  /// Validation message for empty email
  static const String emptyEmailMessage = 'Please enter your email';
  
  /// Validation message for invalid email format
  static const String invalidEmailFormatMessage = 'Please enter a valid email address';
  
  /// Validation message for empty password
  static const String emptyPasswordMessage = 'Please enter your password';
  
  /// Validation message for short password
  static const String shortPasswordMessage = 
      'Password must be at least $minPasswordLength characters long';
  
  /// Validation message for password mismatch
  static const String passwordMismatchMessage = 'Passwords do not match';
  
  /// Validation message for weak password
  static const String weakPasswordMessage = 
      'Password must contain uppercase, lowercase, number, and special character';
}
