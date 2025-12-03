/// Shop analytics card model for analytics overview screen
class ShopAnalyticsCard {
  final String shopId;
  final String shopName;
  final String? territoryName;
  final int rating; // 1-5 stars
  final int totalOrders;
  final double totalSales;
  final String? lastOrderDate; // ISO date string
  final double outstandingAmount;
  final String? executiveName;

  ShopAnalyticsCard({
    required this.shopId,
    required this.shopName,
    this.territoryName,
    required this.rating,
    required this.totalOrders,
    required this.totalSales,
    this.lastOrderDate,
    required this.outstandingAmount,
    this.executiveName,
  });

  /// Create ShopAnalyticsCard from JSON
  factory ShopAnalyticsCard.fromJson(Map<String, dynamic> json) {
    return ShopAnalyticsCard(
      shopId: json['shop_id'] as String,
      shopName: json['shop_name'] as String,
      territoryName: json['territory_name'] as String?,
      rating: json['rating'] as int? ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      lastOrderDate: json['last_order_date'] as String?,
      outstandingAmount: (json['outstanding_amount'] as num?)?.toDouble() ?? 0.0,
      executiveName: json['executive_name'] as String?,
    );
  }

  /// Convert ShopAnalyticsCard to JSON
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'shop_name': shopName,
      'territory_name': territoryName,
      'rating': rating,
      'total_orders': totalOrders,
      'total_sales': totalSales,
      'last_order_date': lastOrderDate,
      'outstanding_amount': outstandingAmount,
      'executive_name': executiveName,
    };
  }

  /// Helper: Get formatted sales amount
  String get formattedSales => '₹${totalSales.toStringAsFixed(2)}';

  /// Helper: Get formatted outstanding amount
  String get formattedOutstanding => '₹${outstandingAmount.toStringAsFixed(2)}';

  /// Helper: Get formatted last order date
  String get formattedLastOrderDate {
    if (lastOrderDate == null) return 'Never';
    try {
      final date = DateTime.parse(lastOrderDate!);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return lastOrderDate!;
    }
  }
}

/// Shop analytics summary model
class ShopAnalyticsSummary {
  final int totalShops;
  final Map<int, int> byRating; // Rating (1-5) -> Count
  final List<ShopAnalyticsCard> shops;

  ShopAnalyticsSummary({
    required this.totalShops,
    required this.byRating,
    required this.shops,
  });

  /// Create ShopAnalyticsSummary from JSON
  factory ShopAnalyticsSummary.fromJson(Map<String, dynamic> json) {
    // Convert by_rating from JSON to Map<int, int>
    final byRatingJson = json['by_rating'] as Map<String, dynamic>? ?? {};
    final byRatingMap = <int, int>{};
    byRatingJson.forEach((key, value) {
      byRatingMap[int.parse(key)] = value as int;
    });

    return ShopAnalyticsSummary(
      totalShops: json['total_shops'] as int? ?? 0,
      byRating: byRatingMap,
      shops: (json['shops'] as List?)
              ?.map((shop) => ShopAnalyticsCard.fromJson(shop))
              .toList() ??
          [],
    );
  }

  /// Convert ShopAnalyticsSummary to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_shops': totalShops,
      'by_rating': byRating.map((key, value) => MapEntry(key.toString(), value)),
      'shops': shops.map((shop) => shop.toJson()).toList(),
    };
  }

  /// Helper: Get count for specific rating
  int getCountForRating(int rating) {
    return byRating[rating] ?? 0;
  }

  /// Helper: Get shops filtered by rating
  List<ShopAnalyticsCard> getShopsByRating(int rating) {
    return shops.where((shop) => shop.rating == rating).toList();
  }
}
