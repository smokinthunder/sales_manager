/// Outstanding summary domain model
class OutstandingSummary {
  final double totalOutstanding;
  final int currentCount;
  final double currentAmount;
  final int upcomingCount;
  final double upcomingAmount;
  final int overdueCount;
  final double overdueAmount;
  final List<TerritoryOutstanding>? byTerritory;
  final List<ExecutiveOutstanding>? byExecutive;

  OutstandingSummary({
    required this.totalOutstanding,
    required this.currentCount,
    required this.currentAmount,
    required this.upcomingCount,
    required this.upcomingAmount,
    required this.overdueCount,
    required this.overdueAmount,
    this.byTerritory,
    this.byExecutive,
  });

  /// Create OutstandingSummary from JSON
  factory OutstandingSummary.fromJson(Map<String, dynamic> json) {
    return OutstandingSummary(
      totalOutstanding: (json['total_outstanding'] as num).toDouble(),
      currentCount: json['current_count'] as int,
      currentAmount: (json['current_amount'] as num).toDouble(),
      upcomingCount: json['upcoming_count'] as int,
      upcomingAmount: (json['upcoming_amount'] as num).toDouble(),
      overdueCount: json['overdue_count'] as int,
      overdueAmount: (json['overdue_amount'] as num).toDouble(),
      byTerritory: json['by_territory'] != null
          ? (json['by_territory'] as List)
              .map((t) => TerritoryOutstanding.fromJson(t))
              .toList()
          : null,
      byExecutive: json['by_executive'] != null
          ? (json['by_executive'] as List)
              .map((e) => ExecutiveOutstanding.fromJson(e))
              .toList()
          : null,
    );
  }

  /// Convert OutstandingSummary to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_outstanding': totalOutstanding,
      'current_count': currentCount,
      'current_amount': currentAmount,
      'upcoming_count': upcomingCount,
      'upcoming_amount': upcomingAmount,
      'overdue_count': overdueCount,
      'overdue_amount': overdueAmount,
      'by_territory': byTerritory?.map((t) => t.toJson()).toList(),
      'by_executive': byExecutive?.map((e) => e.toJson()).toList(),
    };
  }

  /// Helper: Get formatted total outstanding
  String get formattedTotal => '₹${totalOutstanding.toStringAsFixed(2)}';
}

/// Territory outstanding breakdown
class TerritoryOutstanding {
  final String territoryId;
  final String territoryName;
  final int count;
  final double amount;

  TerritoryOutstanding({
    required this.territoryId,
    required this.territoryName,
    required this.count,
    required this.amount,
  });

  factory TerritoryOutstanding.fromJson(Map<String, dynamic> json) {
    return TerritoryOutstanding(
      territoryId: json['territory_id'] as String,
      territoryName: json['territory_name'] as String,
      count: json['count'] as int,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'territory_id': territoryId,
      'territory_name': territoryName,
      'count': count,
      'amount': amount,
    };
  }
}

/// Executive outstanding breakdown
class ExecutiveOutstanding {
  final int executiveId;
  final String executiveName;
  final int count;
  final double amount;

  ExecutiveOutstanding({
    required this.executiveId,
    required this.executiveName,
    required this.count,
    required this.amount,
  });

  factory ExecutiveOutstanding.fromJson(Map<String, dynamic> json) {
    return ExecutiveOutstanding(
      executiveId: json['executive_id'] as int,
      executiveName: json['executive_name'] as String,
      count: json['count'] as int,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'executive_id': executiveId,
      'executive_name': executiveName,
      'count': count,
      'amount': amount,
    };
  }
}
