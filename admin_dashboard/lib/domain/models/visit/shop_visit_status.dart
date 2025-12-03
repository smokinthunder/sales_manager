/// Shop Visit Status model for tracking visit history and statistics
class ShopVisitStatus {
  final String shopId;
  final DateTime? lastVisitDate;
  final int daysSinceVisit;
  final int visitCountThisMonth;
  final DateTime? lastOrderDate;
  final int ordersThisMonth;

  const ShopVisitStatus({
    required this.shopId,
    this.lastVisitDate,
    required this.daysSinceVisit,
    required this.visitCountThisMonth,
    this.lastOrderDate,
    required this.ordersThisMonth,
  });

  /// Create ShopVisitStatus from JSON response
  factory ShopVisitStatus.fromJson(Map<String, dynamic> json) {
    return ShopVisitStatus(
      shopId: json['shop_id'] as String,
      lastVisitDate: json['last_visit_date'] != null
          ? DateTime.parse(json['last_visit_date'] as String)
          : null,
      daysSinceVisit: json['days_since_visit'] as int,
      visitCountThisMonth: json['visit_count_this_month'] as int,
      lastOrderDate: json['last_order_date'] != null
          ? DateTime.parse(json['last_order_date'] as String)
          : null,
      ordersThisMonth: json['orders_this_month'] as int,
    );
  }

  /// Convert ShopVisitStatus to JSON
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      if (lastVisitDate != null)
        'last_visit_date': lastVisitDate!.toIso8601String(),
      'days_since_visit': daysSinceVisit,
      'visit_count_this_month': visitCountThisMonth,
      if (lastOrderDate != null)
        'last_order_date': lastOrderDate!.toIso8601String(),
      'orders_this_month': ordersThisMonth,
    };
  }

  /// Check if shop was visited recently (within last 7 days)
  bool get wasVisitedRecently => daysSinceVisit <= 7;

  /// Check if shop has orders this month
  bool get hasOrdersThisMonth => ordersThisMonth > 0;
}
