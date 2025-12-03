/// Order status enumeration
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  completed,
  cancelled,
  returned;

  /// Convert from API string to enum
  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }

  /// Convert enum to API string
  String toApiString() => name;
}
