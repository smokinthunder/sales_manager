/// User status enum
enum UserStatus {
  active,
  inactive,
  suspended;

  /// Create UserStatus from string
  factory UserStatus.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return UserStatus.active;
      case 'inactive':
        return UserStatus.inactive;
      case 'suspended':
        return UserStatus.suspended;
      default:
        throw ArgumentError('Invalid user status: $value');
    }
  }

  /// Convert to API string format
  String toApiString() {
    return name;
  }

  @override
  String toString() => toApiString();
}
