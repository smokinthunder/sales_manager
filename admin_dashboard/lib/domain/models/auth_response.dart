// Auth Response Model matching backend API response
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserInfo? user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      expiresIn: json['expires_in'] as int,
      user: json['user'] != null
          ? UserInfo.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'user': user?.toJson(),
    };
  }
}

// User Info Model
class UserInfo {
  final int id;
  final String email;
  final String name;
  final String role;
  final String status;
  final String tenantId;
  final String authType;

  UserInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.status,
    required this.tenantId,
    required this.authType,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      tenantId: json['tenant_id'] as String,
      authType: json['auth_type'] as String? ?? 'email',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'status': status,
      'tenant_id': tenantId,
      'auth_type': authType,
    };
  }

  bool get isAdmin => role == 'client_admin' || role == 'superadmin';
}

// Password Reset Request Response
class PasswordResetRequestResponse {
  final String message;
  final String email;
  final String? expiresAt;
  final String? note;

  PasswordResetRequestResponse({
    required this.message,
    required this.email,
    this.expiresAt,
    this.note,
  });

  factory PasswordResetRequestResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetRequestResponse(
      message: json['message'] as String,
      email: json['email'] as String,
      expiresAt: json['expires_at'] as String?,
      note: json['note'] as String?,
    );
  }
}

// Password Reset Response
class PasswordResetResponse {
  final String message;
  final int? userId;

  PasswordResetResponse({
    required this.message,
    this.userId,
  });

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponse(
      message: json['message'] as String,
      userId: json['user_id'] as int?,
    );
  }
}

// Password Change Response
class PasswordChangeResponse {
  final String message;

  PasswordChangeResponse({required this.message});

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) {
    return PasswordChangeResponse(
      message: json['message'] as String,
    );
  }
}

// Email Availability Response
class EmailAvailabilityResponse {
  final String email;
  final bool available;
  final String message;

  EmailAvailabilityResponse({
    required this.email,
    required this.available,
    required this.message,
  });

  factory EmailAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    return EmailAvailabilityResponse(
      email: json['email'] as String,
      available: json['available'] as bool,
      message: json['message'] as String,
    );
  }
}
