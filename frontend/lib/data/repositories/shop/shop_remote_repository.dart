import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_shop_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'shop_remote_repository.g.dart';

@Riverpod(keepAlive: true)
ShopRemoteRepository shopRemoteRepository(Ref<ShopRemoteRepository> ref) {
  return ShopRemoteRepository();
}

class ShopRemoteRepository {
  final RemoteShopService remoteShopService = RemoteShopService();

  Future<Result<Response<Map<String, dynamic>>>> createShop({
    required String shopId,
    required String name,
    required String status,
    required String address,
    required String phone,
    required String contactPerson,
    required double latitude,
    required double longitude,
    required String territoryId,
  }) async => await remoteShopService.createShop(
    shopId: shopId,
    name: name,
    status: status,
    address: address,
    phone: phone,
    contactPerson: contactPerson,
    latitude: latitude,
    longitude: longitude,
    territoryId: territoryId,
  );

  Future<Result<Response<List<Map<String, dynamic>>>>> getShops({
    String? status,
    String? territoryId,
  }) async => await remoteShopService.getShops(
    status: status,
    territoryId: territoryId,
  );

  Future<Result<Response<Map<String, dynamic>>>> getShop(String shopId) async =>
      await remoteShopService.getShop(shopId);
  Future<Result<Response<Map<String, dynamic>>>> updateShop({
    required String shopId,
    String? name,
    String? status,
    String? address,
    String? phone,
    String? contactPerson,
    double? latitude,
    double? longitude,
    String? territoryId,
  }) async => await remoteShopService.updateShop(
    shopId: shopId,
    name: name,
    status: status,
    address: address,
    phone: phone,
    contactPerson: contactPerson,
    latitude: latitude,
    longitude: longitude,
    territoryId: territoryId,
  );

  Future<Result<Response<String>>> deleteShop(String shopId) async =>
      await remoteShopService.deleteShop(shopId);
}
