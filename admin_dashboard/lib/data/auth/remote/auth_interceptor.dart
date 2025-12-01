import 'package:dio/dio.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';

/// Interceptor to automatically add auth tokens to requests
/// and handle token refresh
class AuthInterceptor extends Interceptor {
  final LocalAuthService localAuth;

  AuthInterceptor(this.localAuth);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login, forgot-password, reset-password endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token
    final accessToken = await localAuth.getAccessToken();

    if (accessToken != null) {
      // Check if token is expired
      final isExpired = await localAuth.isAccessTokenExpired();

      if (isExpired) {
        // Try to refresh token
        final refreshToken = await localAuth.getRefreshToken();
        if (refreshToken != null) {
          try {
            // TODO: Implement token refresh endpoint
            // For now, just use existing token
            options.headers['Authorization'] = 'Bearer $accessToken';
          } catch (e) {
            // Token refresh failed, clear tokens
            await localAuth.clearTokens();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Session expired. Please login again.',
              ),
            );
          }
        } else {
          // No refresh token, clear everything
          await localAuth.clearTokens();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Session expired. Please login again.',
            ),
          );
        }
      } else {
        // Token is valid, add to headers
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token might be invalid
    if (err.response?.statusCode == 401) {
      // Clear tokens and force re-login
      await localAuth.clearTokens();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: 'Session expired. Please login again.',
          response: err.response,
        ),
      );
    }

    return handler.next(err);
  }

  /// Check if endpoint is public (doesn't require auth)
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/login',
      '/forgot-password',
      '/reset-password',
      '/check-email',
    ];

    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
