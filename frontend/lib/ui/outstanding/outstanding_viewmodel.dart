import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/outstanding/outstanding_remote_repository.dart';
import 'package:sales_manager/data/repositories/user/user_remote_repository.dart';
import 'package:sales_manager/domain/models/user/user_role.dart';
import 'package:sales_manager/utils/result.dart';

part 'outstanding_viewmodel.g.dart';

/// Unified enum for credit/outstanding payment types with both UI and API properties
enum CreditType {
  outstanding(Color(0xff1ea123), "Current Outstanding", 'current'),
  upcoming(Color(0xffff9d00), "Upcoming Due", 'upcoming'),
  overdue(Color(0xffbe2121), "Overdue", 'overdue');

  const CreditType(this.color, this.placeholder, this.apiStatus);
  
  final Color color;
  final String placeholder;
  final String apiStatus; // The status value used in API responses
}

/// Data class to represent an outstanding payment item
class OutstandingPaymentItem {
  final String dueDate;
  final String shopName;
  final String amount;
  final String status;

  const OutstandingPaymentItem({
    required this.dueDate,
    required this.shopName,
    required this.amount,
    required this.status,
  });

  /// Factory constructor to create from API response map
  factory OutstandingPaymentItem.fromMap(Map<String, dynamic> map) {
    return OutstandingPaymentItem(
      dueDate: map['due_date']?.toString() ?? '',
      shopName: map['shop_name']?.toString() ?? '',
      amount: map['amount']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
    );
  }

  /// Convert to list format for table display
  List<String> toTableRow() => [dueDate, shopName, amount];
}

/// Main provider that fetches all outstanding payments from the repository
@Riverpod(keepAlive: true)
Future<List<OutstandingPaymentItem>> allOutstandingPayments(
  Ref ref, {
  String? executiveId,
}) async {
  final repository = ref.read(outstandingRemoteRepositoryProvider);
  final int? executiveIdInt = executiveId != null ? int.tryParse(executiveId) : null;
  final result = await repository.getOutstandingPayments(
    salesExecutiveId: executiveIdInt,
  );
  
  return switch (result) {
    Ok() => result.value
        .map<OutstandingPaymentItem>((item) => OutstandingPaymentItem.fromMap(item))
        .toList(),
    Error() => throw Exception('Failed to load outstanding payments: ${result.error}'),
  };
}

/// Provider for sales executives (for area managers)
@Riverpod(keepAlive: true)
Future<List<Map<String, dynamic>>> getAllSalesExecutives(Ref ref) async {
  final res = await ref
      .watch(userRemoteRepositoryProvider)
      .getUsers(role: UserRole.salesExecutive.backendName);
  
  return switch (res) {
    Ok() => res.value.map((item) {
      return {
        for (var key in ['id', 'name']) key: item[key],
      };
    }).toList(),
    Error() => throw Exception('Failed to load sales executives: ${res.error}'),
  };
}

/// Provider for filtered outstanding payments by status and executive
@Riverpod(keepAlive: true)
Future<List<List<String>>> getOutstandingPaymentsByStatusAndExecutive(
  Ref ref,
  CreditType status,
  String? executiveId,
) async {
  final repository = ref.read(outstandingRemoteRepositoryProvider);
  final int? executiveIdInt = executiveId != null ? int.tryParse(executiveId) : null;
  final result = await repository.getOutstandingPayments(
    salesExecutiveId: executiveIdInt,
  );
  
  final payments = switch (result) {
    Ok() => result.value
        .map<OutstandingPaymentItem>((item) => OutstandingPaymentItem.fromMap(item))
        .toList(),
    Error() => throw Exception('Failed to load outstanding payments: ${result.error}'),
  };
  
  return _filterAndTransformPayments(payments, status);
}

/// Helper function to filter and transform payments based on status
List<List<String>> _filterAndTransformPayments(
  List<OutstandingPaymentItem> payments,
  CreditType status,
) {
  return payments
      .where((payment) => payment.status == status.apiStatus)
      .map((payment) => payment.toTableRow())
      .toList();
}

/// Extension to add refresh functionality
extension OutstandingPaymentsX on Ref {
  /// Refresh all outstanding payments data
  void refreshOutstandingPayments() {
    invalidate(allOutstandingPaymentsProvider);
  }
  
  /// Refresh specific status and executive payments
  void refreshOutstandingPaymentsByStatusAndExecutive(CreditType status, String? executiveId) {
    invalidate(getOutstandingPaymentsByStatusAndExecutiveProvider);
  }
}
