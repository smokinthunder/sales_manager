import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:admin_dashboard/data/core/api_endpoints.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/domain/models/auth_response.dart';
import 'package:admin_dashboard/utils/result.dart';

class RemoteEmailAuthService {
  late final Dio dio;
  final LocalAuthService localAuth = LocalAuthService();
  final tenantId = dotenv.env['TENANT_ID'] ?? "aquastar";

  RemoteEmailAuthService({bool useInterceptor = false}) {
    dio = Dio();
    // Interceptor will be added after initial implementation
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
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.emailLogin,
        queryParameters: queryParameters,
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
        
        return Result.ok(authResponse);
      } else {
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      return Result.error(
        Exception(e.response?.data['detail'] ?? e.message ?? 'Login failed'),
      );
    } catch (e) {
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
      Response<Map<String, dynamic>> response = await dio.post(
        ApiEndpoints.emailForgotPassword,
        queryParameters: queryParameters,
      );
      
      if (response.data != null) {
        final resetResponse = PasswordResetRequestResponse.fromJson(response.data!);
        return Result.ok(resetResponse);
      } else {
        return Result.error(Exception('Invalid response from server'));
      }
    } on DioException catch (e) {
      return Result.error(
        Exception(e.response?.data['detail'] ?? e.message ?? 'Password reset request failed'),
      );
    } catch (e) {
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
