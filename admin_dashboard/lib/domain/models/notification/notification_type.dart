enum NotificationType {
  profileUpdate('profile_update'),
  customerCreation('customer_creation');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String value) {
    switch (value) {
      case 'profile_update':
        return NotificationType.profileUpdate;
      case 'customer_creation':
        return NotificationType.customerCreation;
      default:
        throw ArgumentError('Unknown notification type: $value');
    }
  }

  @override
  String toString() => value;
}
