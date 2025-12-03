import 'package:admin_dashboard/domain/models/order/order_status.dart';

/// Order Item model representing a line item in an order
class OrderItem {
  final int id;
  final int orderId;
  final String productCode;
  final String productName;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final double discount;
  final double taxAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    required this.discount,
    required this.taxAmount,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create OrderItem from JSON response
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      productCode: json['product_code'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert OrderItem to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_code': productCode,
      'product_name': productName,
      'quantity': quantity,
      'unit': unit,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'discount': discount,
      'tax_amount': taxAmount,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

/// Order model representing a complete order
class Order {
  final int id;
  final String orderId;
  final String billNumber;
  final String shopId;
  final String shopName;
  final String shopLocation;
  final int executiveId;
  final String executiveName;
  final String executivePhone;
  final DateTime orderDate;
  final double totalAmount;
  final OrderStatus status;
  final int itemsCount;
  final String? notes;
  final DateTime? deliveryDate;
  final String? paymentStatus;
  final String? paymentMethod;
  final String tenantId;
  final List<OrderItem> items;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Order({
    required this.id,
    required this.orderId,
    required this.billNumber,
    required this.shopId,
    required this.shopName,
    required this.shopLocation,
    required this.executiveId,
    required this.executiveName,
    required this.executivePhone,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.itemsCount,
    this.notes,
    this.deliveryDate,
    this.paymentStatus,
    this.paymentMethod,
    required this.tenantId,
    this.items = const [],
    required this.createdAt,
    this.updatedAt,
  });

  /// Create Order from JSON response
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderId: json['order_id'] as String,
      billNumber: json['bill_number'] as String,
      shopId: json['shop_id'] as String,
      shopName: json['shop_name'] as String,
      shopLocation: json['shop_location'] as String,
      executiveId: json['executive_id'] as int,
      executiveName: json['executive_name'] as String,
      executivePhone: json['executive_phone'] as String,
      orderDate: DateTime.parse(json['order_date'] as String),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String),
      itemsCount: json['items_count'] as int,
      notes: json['notes'] as String?,
      deliveryDate: json['delivery_date'] != null
          ? DateTime.parse(json['delivery_date'] as String)
          : null,
      paymentStatus: json['payment_status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      tenantId: json['tenant_id'] as String,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert Order to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'bill_number': billNumber,
      'shop_id': shopId,
      'shop_name': shopName,
      'shop_location': shopLocation,
      'executive_id': executiveId,
      'executive_name': executiveName,
      'executive_phone': executivePhone,
      'order_date': orderDate.toIso8601String(),
      'total_amount': totalAmount,
      'status': status.toApiString(),
      'items_count': itemsCount,
      if (notes != null) 'notes': notes,
      if (deliveryDate != null) 'delivery_date': deliveryDate!.toIso8601String(),
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      'tenant_id': tenantId,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
