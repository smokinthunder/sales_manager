import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_territory_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'territory_remote_repository.g.dart';

@Riverpod(keepAlive: true)
TerritoryRemoteRepository territoryRemoteRepository(Ref<TerritoryRemoteRepository> ref) {
  return TerritoryRemoteRepository();
}

class TerritoryRemoteRepository {
  final RemoteTerritoryService remoteTerritoryService = RemoteTerritoryService();

  Future<Result<Response<Map<String, dynamic>>>> createTerritory({
    required String territoryId,
    required String name,
    required String code,
    required String description,
    required String areaManagerId,
  }) async => await remoteTerritoryService.createTerritory(
        territoryId: territoryId,
        name: name,
        code: code,
        description: description,
        areaManagerId: areaManagerId);

  Future<Result<Response<List<Map<String, dynamic>>>>> getTerritories() async =>
      await remoteTerritoryService.getTerritories();

  Future<Result<Response<Map<String, dynamic>>>> getTerritory(
      String territoryId) async =>
      await remoteTerritoryService.getTerritory(territoryId);

  Future<Result<Response<Map<String, dynamic>>>> updateTerritory({
    required String territoryId,
    required String updateTerritoryId,
    required String name,
    required String code,
    required String description,
    required String areaManagerId,
  }) async =>
      await remoteTerritoryService.updateTerritory(
        territoryId: territoryId,
        updateTerritoryId: updateTerritoryId,
        name: name,
        code: code,
        description: description,
        areaManagerId: areaManagerId,
      );

  Future<Result<Response<String>>> deleteTerritory(String territoryId) async =>
      await remoteTerritoryService.deleteTerritory(territoryId);
}