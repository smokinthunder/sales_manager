import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_dashboard/data/auth/remote/auth_remote_repository.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';
import 'package:admin_dashboard/data/auth/config/auth_config.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:admin_dashboard/domain/models/auth_response.dart';
import 'package:admin_dashboard/utils/result.dart';
import 'package:admin_dashboard/utils/logger_service.dart';

part 'auth_viewmodel.g.dart';

/// Auth ViewModel - Manages authentication state
@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final AuthRemoteRepository _repository;
  late final LocalAuthService _localAuth;
  late final LoggerService _logger;

  @override
  AuthState build() {
    _repository = ref.watch(authRemoteRepositoryProvider);
    _localAuth = LocalAuthService();
    _logger = LoggerService();
    _checkAuthStatus();
    return const AuthInitial();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    try {
      _logger.debug('Checking authentication status', 'AUTH_VIEWMODEL');
      
      final accessToken = await _localAuth.getAccessToken();
      if (accessToken != null) {
        final isExpired = await _localAuth.isAccessTokenExpired();
        if (!isExpired) {
          // User is authenticated, load user info
          final userId = await _localAuth.getUserId();
          final userEmail = await _localAuth.getUserEmail();
          final userName = await _localAuth.getUserName();
          final userRole = await _localAuth.getUserRole();

          if (userId != null && userEmail != null) {
            final user = UserInfo(
              id: int.parse(userId),
              email: userEmail,
              name: userName ?? '',
              role: userRole ?? 'client_admin',
              status: 'active',
              tenantId: 'aquastar',
              authType: 'email',
            );
            _logger.info('User authenticated: ${user.email}', 'AUTH_VIEWMODEL');
            state = AuthAuthenticated(user: user, accessToken: accessToken);
          } else {
            _logger.warning('User info incomplete, clearing session', 'AUTH_VIEWMODEL');
            await _localAuth.clearTokens();
            state = const AuthUnauthenticated();
          }
        } else {
          // Token expired, clear everything
          _logger.info('Token expired, clearing session', 'AUTH_VIEWMODEL');
          await _localAuth.clearTokens();
          state = const AuthUnauthenticated();
        }
      } else {
        _logger.debug('No access token found', 'AUTH_VIEWMODEL');
        state = const AuthUnauthenticated();
      }
    } catch (e, stackTrace) {
      _logger.error('Error checking auth status', 'AUTH_VIEWMODEL', e, stackTrace);
      state = const AuthUnauthenticated();
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    try {
      _logger.info('Login attempt for: $email', 'AUTH_VIEWMODEL');
      state = const AuthLoading();

      final result = await _repository.login(email, password);

      switch (result) {
        case Ok<AuthResponse>():
          final authResponse = result.value;
          if (authResponse.user != null) {
            _logger.info('Login successful for: ${authResponse.user!.email}', 'AUTH_VIEWMODEL');
            state = AuthAuthenticated(
              user: authResponse.user!,
              accessToken: authResponse.accessToken,
            );
          } else {
            _logger.error('Login failed: Invalid response', 'AUTH_VIEWMODEL');
            state = const AuthError('Invalid response from server');
          }
          break;
        case Error<AuthResponse>():
          final errorMessage = result.error.toString().replaceAll('Exception: ', '');
          _logger.error('Login failed: $errorMessage', 'AUTH_VIEWMODEL');
          state = AuthError(errorMessage);
          break;
      }
    } catch (e, stackTrace) {
      _logger.error('Login failed: Unexpected error', 'AUTH_VIEWMODEL', e, stackTrace);
      state = AuthError(AuthConfig.authErrorMessage);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      _logger.info('Logout initiated', 'AUTH_VIEWMODEL');
      state = const AuthLoading();
      
      final result = await _repository.logout();
      
      switch (result) {
        case Ok():
          _logger.info('Logout successful', 'AUTH_VIEWMODEL');
          state = const AuthUnauthenticated();
          break;
        case Error():
          // Even if logout fails, clear local state
          _logger.warning('Logout API failed, clearing local state', 'AUTH_VIEWMODEL');
          state = const AuthUnauthenticated();
          break;
      }
    } catch (e, stackTrace) {
      _logger.error('Logout error', 'AUTH_VIEWMODEL', e, stackTrace);
      // Always clear state on logout
      state = const AuthUnauthenticated();
    }
  }

  /// Get current user
  UserInfo? getCurrentUser() {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state is AuthAuthenticated;

  /// Get access token
  String? get accessToken {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).accessToken;
    }
    return null;
  }
}

/// Password Reset ViewModel
@riverpod
class PasswordResetViewModel extends _$PasswordResetViewModel {
  late final AuthRemoteRepository _repository;

  @override
  PasswordResetState build() {
    _repository = ref.watch(authRemoteRepositoryProvider);
    return const PasswordResetInitial();
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    state = const PasswordResetLoading();

    final result = await _repository.forgotPassword(email);

    switch (result) {
      case Ok<PasswordResetRequestResponse>():
        state = PasswordResetSuccess(result.value.message);
        break;
      case Error<PasswordResetRequestResponse>():
        state = PasswordResetError(
          result.error.toString().replaceAll('Exception: ', ''),
        );
        break;
    }
  }

  /// Reset password using token
  Future<void> resetPassword(String resetToken, String newPassword) async {
    state = const PasswordResetLoading();

    final result = await _repository.resetPassword(resetToken, newPassword);

    switch (result) {
      case Ok<PasswordResetResponse>():
        state = PasswordResetSuccess(result.value.message);
        break;
      case Error<PasswordResetResponse>():
        state = PasswordResetError(
          result.error.toString().replaceAll('Exception: ', ''),
        );
        break;
    }
  }

  /// Reset state to initial
  void resetState() {
    state = const PasswordResetInitial();
  }
}

/// Password Change ViewModel
@riverpod
class PasswordChangeViewModel extends _$PasswordChangeViewModel {
  late final AuthRemoteRepository _repository;

  @override
  PasswordChangeState build() {
    _repository = ref.watch(authRemoteRepositoryProvider);
    return const PasswordChangeInitial();
  }

  /// Change password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String accessToken,
  ) async {
    state = const PasswordChangeLoading();

    final result = await _repository.changePassword(
      currentPassword,
      newPassword,
      accessToken,
    );

    switch (result) {
      case Ok<PasswordChangeResponse>():
        state = PasswordChangeSuccess(result.value.message);
        break;
      case Error<PasswordChangeResponse>():
        state = PasswordChangeError(
          result.error.toString().replaceAll('Exception: ', ''),
        );
        break;
    }
  }

  /// Reset state to initial
  void resetState() {
    state = const PasswordChangeInitial();
  }
}
