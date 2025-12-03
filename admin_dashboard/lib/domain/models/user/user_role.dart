/// User role enum for role-based access control
enum UserRole {
  superadmin,
  clientAdmin,
  areaManager,
  salesExecutive;

  /// Create UserRole from string
  factory UserRole.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'superadmin':
        return UserRole.superadmin;
      case 'client_admin':
      case 'clientadmin':
        return UserRole.clientAdmin;
      case 'area_manager':
      case 'areamanager':
        return UserRole.areaManager;
      case 'sales_executive':
      case 'salesexecutive':
        return UserRole.salesExecutive;
      default:
        throw ArgumentError('Invalid user role: $value');
    }
  }

  /// Convert UserRole to API string format
  String toApiString() {
    switch (this) {
      case UserRole.superadmin:
        return 'superadmin';
      case UserRole.clientAdmin:
        return 'client_admin';
      case UserRole.areaManager:
        return 'area_manager';
      case UserRole.salesExecutive:
        return 'sales_executive';
    }
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case UserRole.superadmin:
        return 'Super Admin';
      case UserRole.clientAdmin:
        return 'Client Admin';
      case UserRole.areaManager:
        return 'Area Manager';
      case UserRole.salesExecutive:
        return 'Sales Executive';
    }
  }

  @override
  String toString() => toApiString();
}
