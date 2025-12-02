import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/data/auth/remote/remote_email_auth_service.dart';
import 'package:admin_dashboard/domain/models/auth_response.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

/// Unified Authentication Service
/// 
/// This is the main entry point for all authentication operations.
/// It coordinates between local and remote authentication services
/// and provides a clean, unified API for the presentation layer.
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Services
  final LocalAuthService _localAuth = LocalAuthService();
  final RemoteEmailAuthService _remoteAuth = RemoteEmailAuthService();
  final LoggerService _logger = LoggerService();

  // ============== Public API ==============

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _localAuth.getAccessToken();
      if (token == null) return false;

      final isExpired = await _localAuth.isAccessTokenExpired();
      return !isExpired;
    } catch (e, stackTrace) {
      _logger.error('Error checking authentication', 'AUTH_SERVICE', e, stackTrace);
      return false;
    }
  }

  /// Get current user information
  Future<UserInfo?> getCurrentUser() async {
    try {
      final userId = await _localAuth.getUserId();
      final userEmail = await _localAuth.getUserEmail();
      final userName = await _localAuth.getUserName();
      final userRole = await _localAuth.getUserRole();

      if (userId != null && userEmail != null) {
        return UserInfo(
          id: int.parse(userId),
          email: userEmail,
          name: userName ?? '',
          role: userRole ?? 'client_admin',
          status: 'active',
          tenantId: 'aquastar',
          authType: 'email',
        );
      }
      return null;
    } catch (e, stackTrace) {
      _logger.error('Error getting current user', 'AUTH_SERVICE', e, stackTrace);
      return null;
    }
  }

  /// Get current access token
  Future<String?> getAccessToken() async {
    try {
      return await _localAuth.getAccessToken();
    } catch (e, stackTrace) {
      _logger.error('Error getting access token', 'AUTH_SERVICE', e, stackTrace);
      return null;
    }
  }

  /// Login with email and password
  Future<Result<AuthResponse>> login(String email, String password) async {
    try {
      _logger.info('Login attempt: $email', 'AUTH_SERVICE');
      return await _remoteAuth.login(email, password);
    } catch (e, stackTrace) {
      _logger.error('Login error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Login failed: $e'));
    }
  }

  /// Logout current user
  Future<Result<void>> logout() async {
    try {
      _logger.info('Logout initiated', 'AUTH_SERVICE');
      return await _remoteAuth.logout();
    } catch (e, stackTrace) {
      _logger.error('Logout error', 'AUTH_SERVICE', e, stackTrace);
      // Always clear local tokens even if remote logout fails
      await _localAuth.clearTokens();
      return Result.ok(null);
    }
  }

  /// Request password reset
  Future<Result<PasswordResetRequestResponse>> forgotPassword(String email) async {
    try {
      _logger.info('Password reset requested: $email', 'AUTH_SERVICE');
      return await _remoteAuth.forgotPassword(email);
    } catch (e, stackTrace) {
      _logger.error('Forgot password error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Password reset request failed: $e'));
    }
  }

  /// Reset password with token
  Future<Result<PasswordResetResponse>> resetPassword(
    String resetToken,
    String newPassword,
  ) async {
    try {
      _logger.info('Password reset with token', 'AUTH_SERVICE');
      return await _remoteAuth.resetPassword(resetToken, newPassword);
    } catch (e, stackTrace) {
      _logger.error('Reset password error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Password reset failed: $e'));
    }
  }

  /// Change password for authenticated user
  Future<Result<PasswordChangeResponse>> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final token = await _localAuth.getAccessToken();
      if (token == null) {
        return Result.error(Exception('Not authenticated'));
      }

      _logger.info('Password change initiated', 'AUTH_SERVICE');
      return await _remoteAuth.changePassword(
        currentPassword,
        newPassword,
        token,
      );
    } catch (e, stackTrace) {
      _logger.error('Change password error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Password change failed: $e'));
    }
  }

  /// Check email availability
  Future<Result<EmailAvailabilityResponse>> checkEmailAvailability(
    String email,
  ) async {
    try {
      return await _remoteAuth.checkEmailAvailability(email);
    } catch (e, stackTrace) {
      _logger.error('Check email error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Email check failed: $e'));
    }
  }

  /// Clear all local authentication data
  Future<void> clearLocalAuth() async {
    try {
      _logger.info('Clearing local auth data', 'AUTH_SERVICE');
      await _localAuth.clearTokens();
    } catch (e, stackTrace) {
      _logger.error('Clear auth error', 'AUTH_SERVICE', e, stackTrace);
      rethrow;
    }
  }

  /// Get token expiry time
  Future<DateTime?> getTokenExpiryTime() async {
    try {
      return await _localAuth.getExpiryTime();
    } catch (e, stackTrace) {
      _logger.error('Error getting expiry time', 'AUTH_SERVICE', e, stackTrace);
      return null;
    }
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    try {
      return await _localAuth.isAccessTokenExpired();
    } catch (e, stackTrace) {
      _logger.error('Error checking token expiry', 'AUTH_SERVICE', e, stackTrace);
      return true;
    }
  }
}
