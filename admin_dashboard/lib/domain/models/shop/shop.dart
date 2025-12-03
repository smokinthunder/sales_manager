import 'shop_status.dart';

/// Shop/Customer model representing retail stores
class Shop {
  final int id;
  final String shopId; // Business identifier like "SH001"
  final String name;
  final ShopStatus status;
  final String? address;
  final String? phone;
  final String? contactPerson;
  final double? latitude;
  final double? longitude;
  final String? territoryId;
  final String tenantId;
  final String? pinCode;
  final String? email;
  final String? aadhaarNumber;
  final String? panNumber;
  final String? locationName;
  final String? gstNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? createdBy;
  final int? updatedBy;

  const Shop({
    required this.id,
    required this.shopId,
    required this.name,
    required this.status,
    this.address,
    this.phone,
    this.contactPerson,
    this.latitude,
    this.longitude,
    this.territoryId,
    required this.tenantId,
    this.pinCode,
    this.email,
    this.aadhaarNumber,
    this.panNumber,
    this.locationName,
    this.gstNumber,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  /// Create Shop from JSON
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as int,
      shopId: json['shop_id'] as String,
      name: json['name'] as String,
      status: ShopStatus.fromString(json['status'] as String),
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      contactPerson: json['contact_person'] as String?,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      territoryId: json['territory_id'] as String?,
      tenantId: json['tenant_id'] as String,
      pinCode: json['pin_code'] as String?,
      email: json['email'] as String?,
      aadhaarNumber: json['aadhaar_number'] as String?,
      panNumber: json['pan_number'] as String?,
      locationName: json['location_name'] as String?,
      gstNumber: json['gst_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
    );
  }

  /// Convert Shop to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'name': name,
      'status': status.toApiString(),
      'address': address,
      'phone': phone,
      'contact_person': contactPerson,
      'latitude': latitude,
      'longitude': longitude,
      'territory_id': territoryId,
      'tenant_id': tenantId,
      'pin_code': pinCode,
      'email': email,
      'aadhaar_number': aadhaarNumber,
      'pan_number': panNumber,
      'location_name': locationName,
      'gst_number': gstNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }

  /// Check if shop is active
  bool get isActive => status == ShopStatus.active;

  /// Get display name with shop ID
  String get displayNameWithId => '$name ($shopId)';

  /// Get short address (first 50 characters)
  String? get shortAddress => address != null && address!.length > 50
      ? '${address!.substring(0, 50)}...'
      : address;

  /// Check if shop has location coordinates
  bool get hasLocation => latitude != null && longitude != null;

  /// Copy with method for immutable updates
  Shop copyWith({
    int? id,
    String? shopId,
    String? name,
    ShopStatus? status,
    String? address,
    String? phone,
    String? contactPerson,
    double? latitude,
    double? longitude,
    String? territoryId,
    String? tenantId,
    String? pinCode,
    String? email,
    String? aadhaarNumber,
    String? panNumber,
    String? locationName,
    String? gstNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdBy,
    int? updatedBy,
  }) {
    return Shop(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      name: name ?? this.name,
      status: status ?? this.status,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      contactPerson: contactPerson ?? this.contactPerson,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      territoryId: territoryId ?? this.territoryId,
      tenantId: tenantId ?? this.tenantId,
      pinCode: pinCode ?? this.pinCode,
      email: email ?? this.email,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      panNumber: panNumber ?? this.panNumber,
      locationName: locationName ?? this.locationName,
      gstNumber: gstNumber ?? this.gstNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Shop && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Shop{id: $id, shopId: $shopId, name: $name, status: $status}';
}
