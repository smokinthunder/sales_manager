import 'package:flutter/material.dart';

/// Outstanding payment status enum
enum OutstandingStatus {
  current,
  upcoming,
  overdue;

  /// Convert string to OutstandingStatus
  static OutstandingStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'current':
        return OutstandingStatus.current;
      case 'upcoming':
        return OutstandingStatus.upcoming;
      case 'overdue':
        return OutstandingStatus.overdue;
      default:
        return OutstandingStatus.current;
    }
  }

  /// Convert OutstandingStatus to API string
  String toApiString() {
    return name;
  }

  /// Get display title
  String get title {
    switch (this) {
      case OutstandingStatus.current:
        return 'Current';
      case OutstandingStatus.upcoming:
        return 'Upcoming';
      case OutstandingStatus.overdue:
        return 'Overdue';
    }
  }

  /// Get display color
  Color get color {
    switch (this) {
      case OutstandingStatus.current:
        return const Color(0xFF4CAF50); // Green
      case OutstandingStatus.upcoming:
        return const Color(0xFFFFC107); // Amber/Yellow
      case OutstandingStatus.overdue:
        return const Color(0xFFF44336); // Red
    }
  }
}
