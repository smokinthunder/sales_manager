import 'package:dio/dio.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

/// Interceptor to automatically add auth tokens to requests
/// and handle token refresh
class AuthInterceptor extends Interceptor {
  final LocalAuthService localAuth;
  final LoggerService _logger = LoggerService();

  AuthInterceptor(this.localAuth);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login, forgot-password, reset-password endpoints
    if (_isPublicEndpoint(options.path)) {
      _logger.debug('Public endpoint, skipping auth: ${options.path}', 'AUTH_INTERCEPTOR');
      return handler.next(options);
    }

    // Get access token
    final accessToken = await localAuth.getAccessToken();

    if (accessToken != null) {
      // Check if token is expired
      final isExpired = await localAuth.isAccessTokenExpired();

      if (isExpired) {
        _logger.warning('Access token expired, clearing session', 'AUTH_INTERCEPTOR');
        // Token expired, clear everything and reject
        await localAuth.clearTokens();
        return handler.reject(
          DioException(
            requestOptions: options,
            error: 'Session expired. Please login again.',
            type: DioExceptionType.badResponse,
          ),
        );
      } else {
        // Token is valid, add to headers
        options.headers['Authorization'] = 'Bearer $accessToken';
        _logger.debug('Auth token attached to request', 'AUTH_INTERCEPTOR');
      }
    } else {
      _logger.warning('No access token found for protected endpoint', 'AUTH_INTERCEPTOR');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token might be invalid
    if (err.response?.statusCode == 401) {
      _logger.error('401 Unauthorized, clearing session', 'AUTH_INTERCEPTOR');
      // Clear tokens and force re-login
      await localAuth.clearTokens();
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: 'Session expired. Please login again.',
          response: err.response,
          type: DioExceptionType.badResponse,
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
