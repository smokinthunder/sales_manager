enum UserStatus {
  active('active', 'active', 'Active'),
  inactive('inactive', 'inactive', 'Inactive'),
  suspended('suspended', 'suspended', 'Suspended'),
  pendingApproval('pendingApproval', 'pending_approval', 'Pending Approval');

  final String typeName;
  final String backendName;
  final String displayName;

  const UserStatus(
    this.typeName,
    this.backendName,
    this.displayName,
  );

  static UserStatus fromBackend(String status) {
    switch (status) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      case 'pending_approval':
        return UserStatus.pendingApproval;
      default:
        throw ArgumentError('Invalid status: $status');
    }
  }
}
