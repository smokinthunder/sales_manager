/// Shop status enum
enum ShopStatus {
  active,
  inactive,
  suspended,
  closed;

  /// Create ShopStatus from string
  factory ShopStatus.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ShopStatus.active;
      case 'inactive':
        return ShopStatus.inactive;
      case 'suspended':
        return ShopStatus.suspended;
      case 'closed':
        return ShopStatus.closed;
      default:
        throw ArgumentError('Invalid shop status: $value');
    }
  }

  /// Convert to API string format
  String toApiString() {
    return name;
  }

  @override
  String toString() => toApiString();
}
