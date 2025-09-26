import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_outstanding_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'outstanding_remote_repository.g.dart';

@riverpod
OutstandingRemoteRepository outstandingRemoteRepository(
  Ref<OutstandingRemoteRepository> ref,
) {
  return OutstandingRemoteRepository();
}

class OutstandingRemoteRepository {
  final RemoteOutstandingService remoteOutstandingService =
      RemoteOutstandingService();

  Future<Result<Map<String, dynamic>>> createOutstanding({
    required String shopId,
    required String shopName,
    required double amount,
    required String dueDate, // ISO date string (YYYY-MM-DD)
    required String status, // "current", "upcoming", "overdue"
    int? salesExecutiveId,
    String? territoryId,
    double? originalAmount,
    int? daysOverdue,
    String? lastPaymentDate, // ISO date string (YYYY-MM-DD)
    String? notes,
  }) async => await remoteOutstandingService.createOutstanding(
    shopId: shopId,
    shopName: shopName,
    amount: amount,
    dueDate: dueDate,
    status: status,
    salesExecutiveId: salesExecutiveId,
    territoryId: territoryId,
    originalAmount: originalAmount,
    daysOverdue: daysOverdue,
    lastPaymentDate: lastPaymentDate,
    notes: notes,
  );

  Future<Result<List<Map<String, dynamic>>>> getOutstandingPayments({
    int? salesExecutiveId,
    String? territoryId,
    String? status, // "current", "upcoming", "overdue"
    String? startDate, // ISO date string (YYYY-MM-DD)
    String? endDate, // ISO date string (YYYY-MM-DD)
    String? shopSearch,
    double? minAmount,
    double? maxAmount,
  }) async => await remoteOutstandingService.getOutstandingPayments(
    salesExecutiveId: salesExecutiveId,
    territoryId: territoryId,
    status: status,
    startDate: startDate,
    endDate: endDate,
    shopSearch: shopSearch,
    minAmount: minAmount,
    maxAmount: maxAmount,
  );
  Future<Result<Map<String, dynamic>>> getOutstandingPayment(
    int outstandingId,
  ) async =>
      await remoteOutstandingService.getOutstandingPayment(outstandingId);

  Future<Result<Map<String, dynamic>>> updateOutstandingPayment({
    required int outstandingId,
    String? shopName,
    double? amount,
    String? dueDate, // ISO date string (YYYY-MM-DD)
    String? status, // "current", "upcoming", "overdue"
    int? salesExecutiveId,
    String? territoryId,
    double? originalAmount,
    int? daysOverdue,
    String? lastPaymentDate, // ISO date string (YYYY-MM-DD)
    String? notes,
  }) async => await remoteOutstandingService.updateOutstandingPayment(
    outstandingId: outstandingId,
    shopName: shopName,
    amount: amount,
    dueDate: dueDate,
    status: status,
    salesExecutiveId: salesExecutiveId,
    territoryId: territoryId,
    originalAmount: originalAmount,
    daysOverdue: daysOverdue,
    lastPaymentDate: lastPaymentDate,
    notes: notes,
  );

  Future<Result<bool>> deleteOutstandingPayment(int outstandingId) async =>
      await remoteOutstandingService.deleteOutstandingPayment(outstandingId);

  Future<Result<Map<String, dynamic>>> getOutstandingSummary() async =>
      await remoteOutstandingService.getOutstandingSummary();
}
