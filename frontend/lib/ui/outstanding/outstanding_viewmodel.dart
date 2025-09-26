import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/outstanding/outstanding_remote_repository.dart';
import 'package:sales_manager/utils/result.dart';

part 'outstanding_viewmodel.g.dart';

@Riverpod(keepAlive: true)
Future<List<List<String>>> getCurrentOutstandingPayments(Ref ref) async =>
    getOutstandingPayments('current', ref);

@Riverpod(keepAlive: true)
Future<List<List<String>>> getOverdueOutstandingPayments(Ref ref) async =>
    getOutstandingPayments('overdue', ref);
    
@Riverpod(keepAlive: true)
Future<List<List<String>>> getUpcomingOutstandingPayments(Ref ref) async =>
    getOutstandingPayments('upcoming', ref);

Future<List<List<String>>> getOutstandingPayments(
  String status,
  Ref ref,
) async {
  final res = await ref
      .watch(outstandingRemoteRepositoryProvider)
      .getOutstandingPayments();
  print(res);
  switch (res) {
    case Ok():
      final rawData = res.value;
      final filteredMap = rawData.where((item) => item['status']?.toString() == status).toList();
      final filteredList = filteredMap.map((item) {
        return [
          item['due_date']?.toString() ?? '',
          item['shop_name']?.toString() ?? '',
          item['amount']?.toString() ?? '',
        ];
      }).toList();
      return filteredList;
    case Error():
      print(res.error.toString());
      return [];
  }
}

@Riverpod(keepAlive: true)
Future<List<List<String>>> getAllOutstandingPayments(Ref ref) async {
  final res = await ref
      .watch(outstandingRemoteRepositoryProvider)
      .getOutstandingPayments();
  print(res);
  switch (res) {
    case Ok():
      final rawData = res.value;
      final filteredList = rawData.map((item) {
        return [
          item['due_date']?.toString() ?? '',
          item['shop_name']?.toString() ?? '',
          item['amount']?.toString() ?? '',
        ];
      }).toList();
      return filteredList;
    case Error():
      print(res.error.toString());
      return [];
  }
}
