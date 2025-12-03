/// Sales report data point for charts
class SalesDataPoint {
  final String period; // e.g., "2024-01", "Jan", "Mon"
  final double value;

  const SalesDataPoint({
    required this.period,
    required this.value,
  });

  /// Create SalesDataPoint from JSON
  factory SalesDataPoint.fromJson(Map<String, dynamic> json) {
    return SalesDataPoint(
      period: json['period'] as String,
      value: (json['value'] as num).toDouble(),
    );
  }

  /// Convert SalesDataPoint to JSON
  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'value': value,
    };
  }

  @override
  String toString() => 'SalesDataPoint{period: $period, value: $value}';
}

/// Top customer analytics data
class TopCustomer {
  final String shopId;
  final String shopName;
  final double totalAmount;
  final double currentPayment;
  final double upcomingPayment;
  final double overduePayment;

  const TopCustomer({
    required this.shopId,
    required this.shopName,
    required this.totalAmount,
    required this.currentPayment,
    required this.upcomingPayment,
    required this.overduePayment,
  });

  /// Create TopCustomer from JSON
  factory TopCustomer.fromJson(Map<String, dynamic> json) {
    return TopCustomer(
      shopId: json['shop_id'] as String,
      shopName: json['shop_name'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      currentPayment: (json['current_payment'] as num).toDouble(),
      upcomingPayment: (json['upcoming_payment'] as num).toDouble(),
      overduePayment: (json['overdue_payment'] as num).toDouble(),
    );
  }

  /// Convert TopCustomer to JSON
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'total_amount': totalAmount,
      'current_payment': currentPayment,
      'upcoming_payment': upcomingPayment,
      'overdue_payment': overduePayment,
    };
  }

  @override
  String toString() => 'TopCustomer{shopId: $shopId, shopName: $shopName, totalAmount: $totalAmount}';
}

/// Best selling product analytics data
class BestSellingProduct {
  final String productName;
  final int unitsSold;
  final double percentage;

  const BestSellingProduct({
    required this.productName,
    required this.unitsSold,
    required this.percentage,
  });

  /// Create BestSellingProduct from JSON
  factory BestSellingProduct.fromJson(Map<String, dynamic> json) {
    return BestSellingProduct(
      productName: json['product_name'] as String,
      unitsSold: json['units_sold'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  /// Convert BestSellingProduct to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'units_sold': unitsSold,
      'percentage': percentage,
    };
  }

  @override
  String toString() => 'BestSellingProduct{productName: $productName, unitsSold: $unitsSold, percentage: $percentage}';
}
