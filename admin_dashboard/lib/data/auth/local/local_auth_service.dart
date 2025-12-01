import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalAuthService {
  final _storage = FlutterSecureStorage();

  /// Save All Tokens to secure storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn, // seconds
  }) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(
      key: 'expires_at',
      value: expiryTime.toIso8601String(),
    );
  }

  /// Updates access token and expiresAt keeping the refreshToken same
  Future<void> updateAccessToken({
    required String accessToken,
    required int expiresIn, // seconds
  }) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));

    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(
      key: 'expires_at',
      value: expiryTime.toIso8601String(),
    );
  }

  /// Fetches access token from secure storage
  Future<String?> getAccessToken() async =>
      await _storage.read(key: 'access_token');

  /// Fetches access token from secure storage
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: 'refresh_token');

  /// Fetches access token from secure storage

  Future<DateTime?> getExpiryTime() async {
    final expiresAtStr = await _storage.read(key: 'expires_at');
    return expiresAtStr != null ? DateTime.parse(expiresAtStr) : null;
  }

  /// Checks if the access token had expired or will expire soon (with 30s buffer)
  Future<bool> isAccessTokenExpired() async {
    final expiryTime = await getExpiryTime();
    if (expiryTime == null) return true;

    // Add 30-second buffer to refresh token before it actually expires
    final bufferTime = DateTime.now().add(Duration( seconds: 30));
    return bufferTime.isAfter(expiryTime);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'expires_at');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_role');
  }

  /// Save user information to secure storage
  Future<void> saveUserInfo(dynamic userInfo) async {
    await _storage.write(key: 'user_id', value: userInfo.id.toString());
    await _storage.write(key: 'user_email', value: userInfo.email);
    await _storage.write(key: 'user_name', value: userInfo.name);
    await _storage.write(key: 'user_role', value: userInfo.role);
  }

  /// Get user ID from secure storage
  Future<String?> getUserId() async => await _storage.read(key: 'user_id');

  /// Get user email from secure storage
  Future<String?> getUserEmail() async => await _storage.read(key: 'user_email');

  /// Get user name from secure storage
  Future<String?> getUserName() async => await _storage.read(key: 'user_name');

  /// Get user role from secure storage
  Future<String?> getUserRole() async => await _storage.read(key: 'user_role');
}
