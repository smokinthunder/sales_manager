import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/analytics/analytics_remote_repository.dart';
import 'package:sales_manager/ui/analytics/viewmodels/fill_missing_months.dart';
import 'package:sales_manager/utils/color_gen.dart';
import 'package:sales_manager/utils/result.dart';

part 'executive_analytics_viewmodel.g.dart';

@riverpod
Future<List<String>> getTopTenCustomers(
  Ref ref, {
  String? salesExecutiveId,
}) async {
  if (salesExecutiveId != null) salesExecutiveId = salesExecutiveId.toString();
  final repository = ref.read(analyticsRemoteRepositoryProvider);
  final result = await repository.getExecutiveTopCustomers(
    salesExecutiveId: salesExecutiveId,
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

@riverpod
Future<List<Map<String, dynamic>>> getBestSellingProducts(
  Ref ref, {
  String? salesExecutiveId,
}) async {
  if (salesExecutiveId != null) salesExecutiveId = salesExecutiveId.toString();
  final repository = ref.read(analyticsRemoteRepositoryProvider);
  final result = await repository.getExecutiveBestSellingProducts(
    salesExecutiveId: salesExecutiveId,
  );
  switch (result) {
    case Ok():
      final rawdata = result.value;
      final List<Map<String, dynamic>> list = rawdata
          .map(
            (map) => {
              'product_name': map['product_name'],
              'percentage': map['percentage'],
              'color': colorFromSimpleHash(map['product_name']),
            },
          )
          .toList();
      return list;
    case Error():
      return [];
  }
}

@riverpod
Future<List<Map<String, dynamic>>> getSalesReport(
  Ref ref, {
  String? salesExecutiveId,
}) async {
  final repository = ref.read(analyticsRemoteRepositoryProvider);
  final result = await repository.getExecutiveSalesReport(
    salesExecutiveId: salesExecutiveId,
   
  );
  switch (result) {
    case Ok():
      final rawdata = result.value;
      final filledData = fillMissingMonths(rawdata);
      return filledData;
    case Error():
      return [];
  }
}
