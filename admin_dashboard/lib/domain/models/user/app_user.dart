import 'user_role.dart';
import 'user_status.dart';

/// User model representing sales executives, area managers, and admins
class AppUser {
  final int id;
  final String phone;
  final String name;
  final String? email;
  final UserRole role;
  final UserStatus status;
  final String? territoryId;
  final String tenantId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? createdBy;
  final int? updatedBy;

  const AppUser({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    required this.role,
    required this.status,
    this.territoryId,
    required this.tenantId,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  /// Create AppUser from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      phone: json['phone'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      role: UserRole.fromString(json['role'] as String),
      status: UserStatus.fromString(json['status'] as String),
      territoryId: json['territory_id'] as String?,
      tenantId: json['tenant_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
    );
  }

  /// Convert AppUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'email': email,
      'role': role.toApiString(),
      'status': status.toApiString(),
      'territory_id': territoryId,
      'tenant_id': tenantId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  /// Check if user is active
  bool get isActive => status == UserStatus.active;

  /// Check if user is an admin role (client_admin or superadmin)
  bool get isAdmin => role == UserRole.clientAdmin || role == UserRole.superadmin;

  /// Check if user is an area manager
  bool get isAreaManager => role == UserRole.areaManager;

  /// Check if user is a sales executive
  bool get isSalesExecutive => role == UserRole.salesExecutive;

  /// Get display name with role
  String get displayNameWithRole => '$name (${role.displayName})';

  /// Copy with method for immutable updates
  AppUser copyWith({
    int? id,
    String? phone,
    String? name,
    String? email,
    UserRole? role,
    UserStatus? status,
    String? territoryId,
    String? tenantId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdBy,
    int? updatedBy,
  }) {
    return AppUser(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      territoryId: territoryId ?? this.territoryId,
      tenantId: tenantId ?? this.tenantId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppUser{id: $id, name: $name, role: $role, status: $status}';
}
