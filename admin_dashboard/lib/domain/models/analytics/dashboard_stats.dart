/// Dashboard statistics model containing counts and summaries
class DashboardStats {
  final int totalExecutives;
  final int totalCustomers;
  final int newCustomers;
  final int totalAreaManagers;
  final int newAreaManagers;
  final double? todaySales;
  final double? todayCollection;
  final int? todayNewCustomers;

  const DashboardStats({
    required this.totalExecutives,
    required this.totalCustomers,
    required this.newCustomers,
    required this.totalAreaManagers,
    required this.newAreaManagers,
    this.todaySales,
    this.todayCollection,
    this.todayNewCustomers,
  });

  /// Create DashboardStats from JSON
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalExecutives: json['total_executives'] as int? ?? 0,
      totalCustomers: json['total_customers'] as int? ?? 0,
      newCustomers: json['new_customers'] as int? ?? 0,
      totalAreaManagers: json['total_area_managers'] as int? ?? 0,
      newAreaManagers: json['new_area_managers'] as int? ?? 0,
      todaySales: json['today_sales'] != null ? (json['today_sales'] as num).toDouble() : null,
      todayCollection: json['today_collection'] != null ? (json['today_collection'] as num).toDouble() : null,
      todayNewCustomers: json['today_new_customers'] as int?,
    );
  }

  /// Convert DashboardStats to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_executives': totalExecutives,
      'total_customers': totalCustomers,
      'new_customers': newCustomers,
      'total_area_managers': totalAreaManagers,
      'new_area_managers': newAreaManagers,
      'today_sales': todaySales,
      'today_collection': todayCollection,
      'today_new_customers': todayNewCustomers,
    };
  }

  /// Create empty dashboard stats
  factory DashboardStats.empty() {
    return const DashboardStats(
      totalExecutives: 0,
      totalCustomers: 0,
      newCustomers: 0,
      totalAreaManagers: 0,
      newAreaManagers: 0,
    );
  }

  @override
  String toString() =>
      'DashboardStats{executives: $totalExecutives, customers: $totalCustomers, '
      'newCustomers: $newCustomers, areaManagers: $totalAreaManagers}';
}
