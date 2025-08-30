enum UserRole {
  superadmin('superadmin', 'superadmin', 'Super Admin'),
  clientAdmin('clientAdmin', 'client_admin', 'Client Admin'),
  areaManager('areaManager', 'area_manager', 'Area Manager'),
  salesExecutive('salesExecutive', 'sales_executive', 'Sales Executive');

  final String typeName;
  final String backendName;
  final String displayName;

  const UserRole(
    this.typeName,
    this.backendName,
    this.displayName,
  );

  static UserRole fromBackend(String role) {
    switch (role) {
      case 'superadmin':
        return UserRole.superadmin;
      case 'client_admin':
        return UserRole.clientAdmin;
      case 'area_manager':
        return UserRole.areaManager;
      case 'sales_executive':
        return UserRole.salesExecutive;
      default:
        throw ArgumentError('Invalid role: $role');
    }
  }
}
