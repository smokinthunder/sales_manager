import 'package:admin_dashboard/domain/models/auth_response.dart';

// Authentication State for Riverpod state management
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserInfo user;
  final String accessToken;

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
  });
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

// Password Reset State
sealed class PasswordResetState {
  const PasswordResetState();
}

class PasswordResetInitial extends PasswordResetState {
  const PasswordResetInitial();
}

class PasswordResetLoading extends PasswordResetState {
  const PasswordResetLoading();
}

class PasswordResetSuccess extends PasswordResetState {
  final String message;

  const PasswordResetSuccess(this.message);
}

class PasswordResetError extends PasswordResetState {
  final String message;

  const PasswordResetError(this.message);
}

// Password Change State
sealed class PasswordChangeState {
  const PasswordChangeState();
}

class PasswordChangeInitial extends PasswordChangeState {
  const PasswordChangeInitial();
}

class PasswordChangeLoading extends PasswordChangeState {
  const PasswordChangeLoading();
}

class PasswordChangeSuccess extends PasswordChangeState {
  final String message;

  const PasswordChangeSuccess(this.message);
}

class PasswordChangeError extends PasswordChangeState {
  final String message;

  const PasswordChangeError(this.message);
}
