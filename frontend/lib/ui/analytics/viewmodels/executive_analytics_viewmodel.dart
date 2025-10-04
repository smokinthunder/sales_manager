import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/analytics/analytics_remote_repository.dart';
import 'package:sales_manager/utils/result.dart';

part 'executive_analytics_viewmodel.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> getTopTenCustomers(
  Ref ref, {
  String? salesExecutiveId,
}) async {
  final repository = ref.read(analyticsRemoteRepositoryProvider);
  final result = await repository.getExecutiveTopCustomers(
    salesExecutiveId: salesExecutiveId.toString(),
  );
  switch (result) {
    case Ok():
      final rawdata = result.value;
      rawdata.sort((a, b) => b['points'].compareTo(a['points']));
      final List<String> list = rawdata
          .map((map) => map['shop_name'] as String)
          .toList();
      if (list.length > 10) {
        list.removeRange(10, list.length);
      }
      return list;
    case Error():
      return [];
  }
}
