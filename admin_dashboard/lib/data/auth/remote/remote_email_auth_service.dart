import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:admin_dashboard/data/core/api_endpoints.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/data/auth/remote/auth_interceptor.dart';
import 'package:admin_dashboard/data/auth/config/auth_config.dart';
import 'package:admin_dashboard/domain/models/auth_response.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

class RemoteEmailAuthService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final LoggerService logger = LoggerService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "aquastar";

  RemoteEmailAuthService({bool useInterceptor = true}) {
    dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: AuthConfig.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: AuthConfig.apiTimeoutSeconds),
        sendTimeout: Duration(seconds: AuthConfig.apiTimeoutSeconds),
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    
    // Add auth interceptor if requested
    if (useInterceptor) {
      dio.interceptors.add(AuthInterceptor(localAuth));
      logger.info('Auth interceptor enabled', 'AUTH_SERVICE');
    }
    
    logger.info('RemoteEmailAuthService initialized', 'AUTH_SERVICE');
  }

  /// Parse DioException and return user-friendly error message
  String _parseError(DioException e) {
    logger.apiError(e.requestOptions.uri.toString(), e, e.stackTrace);
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (data is Map<String, dynamic>) {
          // Try to extract detail from response
          if (data.containsKey('detail')) {
            return data['detail'].toString();
          }
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
        }
        
        // Return status code specific messages
        switch (statusCode) {
          case 400:
            return 'Invalid request. Please check your input.';
          case 401:
            return AuthConfig.invalidCredentialsMessage;
          case 403:
            return 'Access forbidden. You do not have permission.';
          case 404:
            return 'Resource not found. Please contact support.';
          case 429:
            return AuthConfig.accountLockedMessage;
          case 500:
            return AuthConfig.serverErrorMessage;
          default:
            return 'Request failed with status code: $statusCode';
        }
      
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      
      case DioExceptionType.connectionError:
        return AuthConfig.networkErrorMessage;
      
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please check your connection.';
      
      default:
        return e.message ?? AuthConfig.serverErrorMessage;
    }
  }

  /// Login with email and password
  /// Returns AuthResponse with tokens and user info
  Future<Result<AuthResponse>> login(
    String email,
    String password,
  ) async {
    final queryParameters = {
      "email": email,
      "password": password,
      "tenant_id": tenantId,
    };
    
    try {
      logger.apiRequest('POST', ApiEndpoints.emailLogin, queryParameters);
      
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.emailLogin,
        queryParameters: queryParameters,
      );
      
      logger.apiResponse(
        response.statusCode ?? 0,
        ApiEndpoints.emailLogin,
        'Success',
      );
      
      if (response.data != null) {
        final authResponse = AuthResponse.fromJson(response.data!);
        
        // Save tokens to local storage
        await localAuth.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
          expiresIn: authResponse.expiresIn,
        );
        
        // Save user info if needed
        if (authResponse.user != null) {
          await localAuth.saveUserInfo(authResponse.user!);
        }
        
        logger.info('Login successful for user: ${authResponse.user?.email}', 'AUTH_SERVICE');
        return Result.ok(authResponse);
      } else {
        logger.error('Login failed: Invalid response', 'AUTH_SERVICE');
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.error('Login failed: $errorMessage', 'AUTH_SERVICE', e);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Login failed: Unexpected error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Unexpected error: $e'));
    }
  }

  /// Request password reset
  /// Sends reset token to email (displayed in terminal in dev mode)
  Future<Result<PasswordResetRequestResponse>> forgotPassword(
    String email,
  ) async {
    final queryParameters = {
      "email": email,
      "tenant_id": tenantId,
    };
    
    try {
      logger.apiRequest('POST', ApiEndpoints.emailForgotPassword, queryParameters);
      
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.emailForgotPassword,
        queryParameters: queryParameters,
      );
      
      logger.apiResponse(
        response.statusCode ?? 0,
        ApiEndpoints.emailForgotPassword,
        'Success',
      );
      
      if (response.data != null) {
        final resetResponse = PasswordResetRequestResponse.fromJson(response.data!);
        logger.info('Password reset requested for: $email', 'AUTH_SERVICE');
        return Result.ok(resetResponse);
      } else {
        logger.error('Password reset failed: Invalid response', 'AUTH_SERVICE');
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      final errorMessage = _parseError(e);
      logger.error('Password reset failed: $errorMessage', 'AUTH_SERVICE', e);
      return Result.error(Exception(errorMessage));
    } catch (e, stackTrace) {
      logger.error('Password reset failed: Unexpected error', 'AUTH_SERVICE', e, stackTrace);
      return Result.error(Exception('Unexpected error: $e'));
    }
  }

  /// Reset password using reset token
  /// Requires reset token from forgot password request
  Future<Result<PasswordResetResponse>> resetPassword(
    String resetToken,
    String newPassword,
  ) async {
    final queryParameters = {
      "reset_token": resetToken,
      "new_password": newPassword,
      "tenant_id": tenantId,
    };
    
    try {
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.emailResetPassword,
        queryParameters: queryParameters,
      );
      
      if (response.data != null) {
        final resetResponse = PasswordResetResponse.fromJson(response.data!);
        return Result.ok(resetResponse);
      } else {
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      return Result.error(
        Exception(e.response?.data['detail'] ?? e.message ?? 'Password reset failed'),
      );
    } catch (e) {
      return Result.error(Exception('Unexpected error: $e'));
    }
  }

  /// Change password for authenticated user
  /// Requires current password for verification
  Future<Result<PasswordChangeResponse>> changePassword(
    String currentPassword,
    String newPassword,
    String accessToken,
  ) async {
    final queryParameters = {
      "current_password": currentPassword,
      "new_password": newPassword,
    };
    
    try {
      Response<Map<String, dynamic>> response = await dio.put(
        ApiEndpoints.emailChangePassword,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      
      if (response.data != null) {
        final changeResponse = PasswordChangeResponse.fromJson(response.data!);
        return Result.ok(changeResponse);
      } else {
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      return Result.error(
        Exception(e.response?.data['detail'] ?? e.message ?? 'Password change failed'),
      );
    } catch (e) {
      return Result.error(Exception('Unexpected error: $e'));
    }
  }

  /// Check if email is available for registration
  Future<Result<EmailAvailabilityResponse>> checkEmailAvailability(
    String email,
  ) async {
    final queryParameters = {
      "email": email,
      "tenant_id": tenantId,
    };
    
    try {
      Response<Map<String, dynamic>> response = await dio.get(
        ApiEndpoints.emailCheckEmail,
        queryParameters: queryParameters,
      );
      
      if (response.data != null) {
        final availabilityResponse = EmailAvailabilityResponse.fromJson(response.data!);
        return Result.ok(availabilityResponse);
      } else {
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      return Result.error(
        Exception(e.response?.data['detail'] ?? e.message ?? 'Email check failed'),
      );
    } catch (e) {
      return Result.error(Exception('Unexpected error: $e'));
    }
  }

  /// Logout - clear local tokens
  Future<Result<void>> logout() async {
    try {
      await localAuth.clearTokens();
      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Logout failed: $e'));
    }
  }
}
