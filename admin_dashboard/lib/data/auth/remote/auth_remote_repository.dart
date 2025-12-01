import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_dashboard/data/auth/remote/remote_email_auth_service.dart';
import 'package:admin_dashboard/domain/models/auth_response.dart';
import 'package:admin_dashboard/utils/result.dart';

part 'auth_remote_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  final RemoteEmailAuthService _authService = RemoteEmailAuthService();

  /// Login with email and password
  Future<Result<AuthResponse>> login(
    String email,
    String password,
  ) async {
    return await _authService.login(email, password);
  }

  /// Request password reset
  Future<Result<PasswordResetRequestResponse>> forgotPassword(
    String email,
  ) async {
    return await _authService.forgotPassword(email);
  }

  /// Reset password using reset token
  Future<Result<PasswordResetResponse>> resetPassword(
    String resetToken,
    String newPassword,
  ) async {
    return await _authService.resetPassword(resetToken, newPassword);
  }

  /// Change password for authenticated user
  Future<Result<PasswordChangeResponse>> changePassword(
    String currentPassword,
    String newPassword,
    String accessToken,
  ) async {
    return await _authService.changePassword(
      currentPassword,
      newPassword,
      accessToken,
    );
  }

  /// Check email availability
  Future<Result<EmailAvailabilityResponse>> checkEmailAvailability(
    String email,
  ) async {
    return await _authService.checkEmailAvailability(email);
  }

  /// Logout
  Future<Result<void>> logout() async {
    return await _authService.logout();
  }
}
