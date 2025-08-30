// data/services/remote/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:sales_manager/data/services/local/local_auth_service.dart';
import 'package:sales_manager/data/services/remote/api_endpoints.dart';
import 'package:sales_manager/data/services/remote/remote_auth_service.dart';
import 'package:sales_manager/utils/result.dart';

class AuthInterceptor extends Interceptor {
  final LocalAuthService _localAuth;

  AuthInterceptor(this._localAuth);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip authentication for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Check if access token is expired
    final isExpired = await _localAuth.isAccessTokenExpired();

    if (isExpired) {
      final refreshToken = await _localAuth.getRefreshToken();

      if (refreshToken == null) {
        // No refresh token — force logout
        await _localAuth.clearTokens();
        return _rejectUnauthorized(
          options,
          handler,
          'No refresh token available',
        );
      }

      try {
        // Create a fresh Dio instance WITHOUT AuthInterceptor to avoid infinite loop
        final freshDio = Dio();
        final authService = RemoteAuthService();
        // Replace the dio instance to bypass interceptor
        authService.dio = freshDio;

        final result = await authService.refreshTocken(refreshToken);

        switch (result) {
          case Ok(value: final response):
            final newAccessToken = response.data?['access_token'];
            final expiresIn = response.data?['expires_in'] ?? 900;

            if (newAccessToken == null) {
              await _localAuth.clearTokens();
              return _rejectUnauthorized(
                options,
                handler,
                'Invalid token response: missing access_token',
              );
            }

            // Save the new access token (refresh token may be rotated)
            await _localAuth.updateAccessToken(
              accessToken: newAccessToken,
              expiresIn: expiresIn,
            );

            // Update the original request with the new token
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            // Proceed with the request
            return handler.next(options);

          case Error(error: final exception):
            await _localAuth.clearTokens();
            return _rejectUnauthorized(
              options,
              handler,
              'Token refresh failed: ${exception.toString()}',
            );
        }
      } on DioException catch (e) {
        await _localAuth.clearTokens();
        return handler.reject(
          DioException(
            requestOptions: options,
            error: e.message,
            response: e.response,
          ),
        );
      } catch (e) {
        await _localAuth.clearTokens();
        return _rejectUnauthorized(
          options,
          handler,
          'Unexpected error during token refresh: $e',
        );
      }
    } else {
      // Token is valid — attach access token
      final accessToken = await _localAuth.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    // Proceed normally if token is valid
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Global error handling
    if (err.response?.statusCode == 401) {
      _localAuth.clearTokens();
      // Optionally notify the app (e.g., via Riverpod state)
    }
    handler.next(err);
  }

  // Helper: Check if endpoint is public (doesn't require auth)
  bool _isPublicEndpoint(String path) {
    return [
      ApiEndpoints.generateOtp,
      ApiEndpoints.verifyOtp,
      ApiEndpoints.refreshToken,
      ApiEndpoints.logout,
    ].contains(path);
  }

  // Utility to reject request with 401
  void _rejectUnauthorized(
    RequestOptions options,
    RequestInterceptorHandler handler,
    String message,
  ) {
    handler.reject(
      DioException(
        requestOptions: options,
        error: message,
        response: Response(
          data: {'detail': 'Session expired or invalid token'},
          statusCode: 401,
          requestOptions: options,
        ),
      ),
    );
  }
}
