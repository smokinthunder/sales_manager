/// Assignment status enumeration
enum AssignmentStatus {
  active,
  inactive,
  suspended,
  transferred;

  /// Convert from API string to enum
  static AssignmentStatus fromString(String status) {
    return AssignmentStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => AssignmentStatus.active,
    );
  }

  /// Convert enum to API string
  String toApiString() => name;
}

/// Shop Assignment model representing shop-executive relationship
class ShopAssignment {
  final int id;
  final String shopId;
  final String shopName;
  final String shopLocation;
  final int executiveId;
  final String executiveName;
  final String executivePhone;
  final DateTime assignedDate;
  final AssignmentStatus status;
  final String? territoryId;
  final String? territoryName;
  final String? notes;
  final DateTime? endDate;
  final String tenantId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ShopAssignment({
    required this.id,
    required this.shopId,
    required this.shopName,
    required this.shopLocation,
    required this.executiveId,
    required this.executiveName,
    required this.executivePhone,
    required this.assignedDate,
    required this.status,
    this.territoryId,
    this.territoryName,
    this.notes,
    this.endDate,
    required this.tenantId,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create ShopAssignment from JSON response
  factory ShopAssignment.fromJson(Map<String, dynamic> json) {
    return ShopAssignment(
      id: json['id'] as int,
      shopId: json['shop_id'] as String,
      shopName: json['shop_name'] as String,
      shopLocation: json['shop_location'] as String,
      executiveId: json['executive_id'] as int,
      executiveName: json['executive_name'] as String,
      executivePhone: json['executive_phone'] as String,
      assignedDate: DateTime.parse(json['assigned_date'] as String),
      status: AssignmentStatus.fromString(json['status'] as String),
      territoryId: json['territory_id'] as String?,
      territoryName: json['territory_name'] as String?,
      notes: json['notes'] as String?,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      tenantId: json['tenant_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert ShopAssignment to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'shop_name': shopName,
      'shop_location': shopLocation,
      'executive_id': executiveId,
      'executive_name': executiveName,
      'executive_phone': executivePhone,
      'assigned_date': assignedDate.toIso8601String().split('T')[0],
      'status': status.toApiString(),
      if (territoryId != null) 'territory_id': territoryId,
      if (territoryName != null) 'territory_name': territoryName,
      if (notes != null) 'notes': notes,
      if (endDate != null) 'end_date': endDate!.toIso8601String().split('T')[0],
      'tenant_id': tenantId,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
