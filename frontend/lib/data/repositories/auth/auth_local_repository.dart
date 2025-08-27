import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref<AuthLocalRepository> ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  final LocalAuthService _localAuthService = LocalAuthService();

  /// Save All Tokens to secure storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn, // seconds
  }) async => await _localAuthService.saveTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
  );

  /// Updates access token and expiresAt keeping the refreshToken same
  Future<void> updateAccessToken({
    required String accessToken,
    required int expiresIn, // seconds
  }) async => await _localAuthService.updateAccessToken(
    accessToken: accessToken,
    expiresIn: expiresIn,
  );

  /// Fetches access token from secure storage
  Future<String?> getAccessToken() async =>
      await _localAuthService.getAccessToken();

  /// Fetches access token from secure storage
  Future<String?> getRefreshToken() async =>
      await _localAuthService.getRefreshToken();

  /// Fetches access token from secure storage

  Future<DateTime?> getExpiryTime() async =>
      await _localAuthService.getExpiryTime();

  /// Checks if the access token had expired
  Future<bool> isAccessTokenExpired() async =>
      await _localAuthService.isAccessTokenExpired();

  /// Clear all tokens (logout)
  Future<void> clearTokens() async => await _localAuthService.clearTokens();
}
