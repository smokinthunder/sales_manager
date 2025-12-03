import 'package:flutter/material.dart';

/// Shop status enum
enum ShopStatus {
  active,
  inactive,
  suspended,
  closed;

  /// Create ShopStatus from string
  factory ShopStatus.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ShopStatus.active;
      case 'inactive':
        return ShopStatus.inactive;
      case 'suspended':
        return ShopStatus.suspended;
      case 'closed':
        return ShopStatus.closed;
      default:
        throw ArgumentError('Invalid shop status: $value');
    }
  }

  /// Convert to API string format
  String toApiString() {
    return name;
  }

  /// Get display name for UI
  String get displayName {
    switch (this) {
      case ShopStatus.active:
        return 'Active';
      case ShopStatus.inactive:
        return 'Inactive';
      case ShopStatus.suspended:
        return 'Suspended';
      case ShopStatus.closed:
        return 'Closed';
    }
  }

  /// Get color for status badge
  Color get color {
    switch (this) {
      case ShopStatus.active:
        return Colors.green;
      case ShopStatus.inactive:
        return Colors.orange;
      case ShopStatus.suspended:
        return Colors.red;
      case ShopStatus.closed:
        return Colors.grey;
    }
  }

  @override
  String toString() => toApiString();
}
