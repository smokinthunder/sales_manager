import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:admin_dashboard/data/auth/config/auth_config.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

class LocalAuthService {
  final _storage = const FlutterSecureStorage();
  final _logger = LoggerService();

  /// Save All Tokens to secure storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn, // seconds
  }) async {
    try {
      final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

      await _storage.write(key: AuthConfig.accessTokenKey, value: accessToken);
      await _storage.write(key: AuthConfig.refreshTokenKey, value: refreshToken);
      await _storage.write(
        key: AuthConfig.expiresAtKey,
        value: expiryTime.toIso8601String(),
      );
      
      _logger.debug('Tokens saved successfully', 'LOCAL_AUTH');
    } catch (e, stackTrace) {
      _logger.error('Failed to save tokens', 'LOCAL_AUTH', e, stackTrace);
      rethrow;
    }
  }

  /// Updates access token and expiresAt keeping the refreshToken same
  Future<void> updateAccessToken({
    required String accessToken,
    required int expiresIn, // seconds
  }) async {
    try {
      final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

      await _storage.write(key: AuthConfig.accessTokenKey, value: accessToken);
      await _storage.write(
        key: AuthConfig.expiresAtKey,
        value: expiryTime.toIso8601String(),
      );
      
      _logger.debug('Access token updated successfully', 'LOCAL_AUTH');
    } catch (e, stackTrace) {
      _logger.error('Failed to update access token', 'LOCAL_AUTH', e, stackTrace);
      rethrow;
    }
  }

  /// Fetches access token from secure storage
  Future<String?> getAccessToken() async =>
      await _storage.read(key: AuthConfig.accessTokenKey);

  /// Fetches refresh token from secure storage
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: AuthConfig.refreshTokenKey);

  /// Fetches token expiry time from secure storage
  Future<DateTime?> getExpiryTime() async {
    final expiresAtStr = await _storage.read(key: AuthConfig.expiresAtKey);
    return expiresAtStr != null ? DateTime.parse(expiresAtStr) : null;
  }

  /// Checks if the access token had expired or will expire soon (with buffer)
  Future<bool> isAccessTokenExpired() async {
    final expiryTime = await getExpiryTime();
    if (expiryTime == null) return true;

    // Add buffer to refresh token before it actually expires
    final bufferTime = DateTime.now().add(
      Duration(seconds: AuthConfig.tokenRefreshBufferSeconds),
    );
    return bufferTime.isAfter(expiryTime);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: AuthConfig.accessTokenKey);
      await _storage.delete(key: AuthConfig.refreshTokenKey);
      await _storage.delete(key: AuthConfig.expiresAtKey);
      await _storage.delete(key: AuthConfig.userIdKey);
      await _storage.delete(key: AuthConfig.userEmailKey);
      await _storage.delete(key: AuthConfig.userNameKey);
      await _storage.delete(key: AuthConfig.userRoleKey);
      
      _logger.info('All tokens cleared successfully', 'LOCAL_AUTH');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear tokens', 'LOCAL_AUTH', e, stackTrace);
      rethrow;
    }
  }

  /// Save user information to secure storage
  Future<void> saveUserInfo(dynamic userInfo) async {
    try {
      await _storage.write(key: AuthConfig.userIdKey, value: userInfo.id.toString());
      await _storage.write(key: AuthConfig.userEmailKey, value: userInfo.email);
      await _storage.write(key: AuthConfig.userNameKey, value: userInfo.name);
      await _storage.write(key: AuthConfig.userRoleKey, value: userInfo.role);
      
      _logger.debug('User info saved successfully', 'LOCAL_AUTH');
    } catch (e, stackTrace) {
      _logger.error('Failed to save user info', 'LOCAL_AUTH', e, stackTrace);
      rethrow;
    }
  }

  /// Get user ID from secure storage
  Future<String?> getUserId() async => await _storage.read(key: AuthConfig.userIdKey);

  /// Get user email from secure storage
  Future<String?> getUserEmail() async => await _storage.read(key: AuthConfig.userEmailKey);

  /// Get user name from secure storage
  Future<String?> getUserName() async => await _storage.read(key: AuthConfig.userNameKey);

  /// Get user role from secure storage
  Future<String?> getUserRole() async => await _storage.read(key: AuthConfig.userRoleKey);
}
