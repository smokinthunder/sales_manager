import 'package:admin_dashboard/domain/models/outstanding/outstanding_status.dart';

/// Outstanding payment domain model
class OutstandingPayment {
  final int id;
  final String shopId;
  final String shopName;
  final double amount;
  final double? originalAmount;
  final String dueDate; // ISO date string
  final OutstandingStatus status;
  final int daysOverdue;
  final String? lastPaymentDate; // ISO date string  
  final int? salesExecutiveId;
  final String? salesExecutiveName;
  final String? territoryId;
  final String? territoryName;
  final String? notes;
  final String createdAt; // ISO datetime string
  final String updatedAt; // ISO datetime string

  OutstandingPayment({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.amount,
    this.originalAmount,
    required this.dueDate,
    required this.status,
    required this.daysOverdue,
    this.lastPaymentDate,
    this.salesExecutiveId,
    this.salesExecutiveName,
    this.territoryId,
    this.territoryName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create OutstandingPayment from JSON
  factory OutstandingPayment.fromJson(Map<String, dynamic> json) {
    return OutstandingPayment(
      id: json['id'] as int? ?? 0,
      shopId: json['shop_id'] as String? ?? '',
      shopName: json['shop_name'] as String? ?? '',
      amount: json['amount'] != null 
          ? (json['amount'] as num).toDouble() 
          : 0.0,
      originalAmount: json['original_amount'] != null
          ? (json['original_amount'] as num).toDouble()
          : null,
      dueDate: json['due_date'] as String? ?? '',
      status: OutstandingStatus.fromString(json['status'] as String? ?? 'current'),
      daysOverdue: json['days_overdue'] as int? ?? 0,
      lastPaymentDate: json['last_payment_date'] as String?,
      salesExecutiveId: json['sales_executive_id'] as int?,
      salesExecutiveName: json['sales_executive_name'] as String?,
      territoryId: json['territory_id'] as String?,
      territoryName: json['territory_name'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  /// Convert OutstandingPayment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'shop_name': shopName,
      'amount': amount,
      'original_amount': originalAmount,
      'due_date': dueDate,
      'status': status.toApiString(),
      'days_overdue': daysOverdue,
      'last_payment_date': lastPaymentDate,
      'sales_executive_id': salesExecutiveId,
      'sales_executive_name': salesExecutiveName,
      'territory_id': territoryId,
      'territory_name': territoryName,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Helper: Check if payment is overdue
  bool get isOverdue => status == OutstandingStatus.overdue;

  /// Helper: Check if payment is current
  bool get isCurrent => status == OutstandingStatus.current;

  /// Helper: Check if payment is upcoming
  bool get isUpcoming => status == OutstandingStatus.upcoming;

  /// Helper: Get formatted amount
  String get formattedAmount => '₹${amount.toStringAsFixed(2)}';

  /// Helper: Get formatted due date (assuming ISO format YYYY-MM-DD)
  String get formattedDueDate {
    try {
      final date = DateTime.parse(dueDate);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dueDate;
    }
  }
}
