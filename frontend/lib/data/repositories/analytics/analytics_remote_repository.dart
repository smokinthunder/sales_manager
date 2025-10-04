import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_analytics_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'analytics_remote_repository.g.dart';

@riverpod
AnalyticsRemoteRepository analyticsRemoteRepository(
  Ref<AnalyticsRemoteRepository> ref,
) {
  return AnalyticsRemoteRepository();
}

class AnalyticsRemoteRepository {
  final RemoteAnalyticsService remoteAnalyticsService =
      RemoteAnalyticsService();

  Future<Result<List<Map<String, dynamic>>>> getExecutiveTopCustomers({
    String? salesExecutiveId,
  }) async => await remoteAnalyticsService.getExecutiveTopCustomers(
    salesExecutiveId: salesExecutiveId,
  );
  Future<Result<List<Map<String, dynamic>>>> getExecutiveBestSellingProducts({
    String? salesExecutiveId,
  }) async => await remoteAnalyticsService.getExecutiveBestSellingProducts(
    salesExecutiveId: salesExecutiveId,
  );
  Future<Result<List<Map<String, dynamic>>>> getExecutiveSalesReport({
    String? salesExecutiveId,
  }) async => await remoteAnalyticsService.getExecutiveSalesReport(
    salesExecutiveId: salesExecutiveId,
  );
  Future<Result<List<Map<String, dynamic>>>> getShopPurchaseAnalysis({
    required String shopId,
    String? year,
  }) async => await remoteAnalyticsService.getShopPurchaseAnalysis(
    shopId: shopId,
    year: year,
  );
  Future<Result<List<Map<String, dynamic>>>> getShopBestSellingProducts({
    required String shopId,
    String? year,
  }) async => await remoteAnalyticsService.getShopBestSellingProducts(
    shopId: shopId,
    year: year,
  );
  Future<Result<List<Map<String, dynamic>>>> getShopSalesReport({
    required String shopId,
    String? year,
  }) async => await remoteAnalyticsService.getShopSalesReport(
    shopId: shopId,
    year: year,
  );
}
