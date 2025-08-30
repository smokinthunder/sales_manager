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

  /// Checks if the access token had expired
  Future<bool> isAccessTokenExpired() async {
    final expiryTime = await getExpiryTime();
    return expiryTime == null || DateTime.now().isAfter(expiryTime);
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'expires_at');
  }
}
