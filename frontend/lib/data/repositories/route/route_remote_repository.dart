import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_route_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'route_remote_repository.g.dart';

@Riverpod(keepAlive: true)
RouteRemoteRepository routeRemoteRepository(Ref<RouteRemoteRepository> ref) {
  return RouteRemoteRepository();
}

class RouteRemoteRepository {
  final RemoteRouteService remoteRouteService = RemoteRouteService();

  Future<Result<Response<Map<String, dynamic>>>> createRoute({
    required String name,
    required String territoryId,
    required String weekStartDate,
    String? routeId,
    String status = "planned",
  }) async => await remoteRouteService.createRoute(
        name: name,
        territoryId: territoryId,
        weekStartDate: weekStartDate,
        routeId: routeId,
        status: status);

  Future<Result<Response<List<dynamic>>>> getRoutes({
    int? executiveId,
    String? weekStart,
    String? routeStatus,
  }) async => await remoteRouteService.getRoutes(
        executiveId: executiveId,
        weekStart: weekStart,
        routeStatus: routeStatus);

  Future<Result<Response<Map<String, dynamic>>>> getRoute(String routeId) async =>
      await remoteRouteService.getRoute(routeId);

  Future<Result<Response<Map<String, dynamic>>>> updateRoute({
    required String routeId,
    String? name,
    String? territoryId,
    String? weekStartDate,
    String? status,
    String? updateRouteId,
  }) async => await remoteRouteService.updateRoute(
        routeId: routeId,
        name: name,
        territoryId: territoryId,
        weekStartDate: weekStartDate,
        status: status,
        updateRouteId: updateRouteId);

  Future<Result<Response<void>>> deleteRoute(String routeId) async =>
      await remoteRouteService.deleteRoute(routeId);

  Future<Result<Response<Map<String, dynamic>>>> addShopToRoute({
    required String routeId,
    required int shopId,
    required int salesExecutiveId,
    required String plannedDate,
    String? plannedTime,
    int? sequenceOrder,
    String status = "planned",
  }) async => await remoteRouteService.addShopToRoute(
        routeId: routeId,
        shopId: shopId,
        salesExecutiveId: salesExecutiveId,
        plannedDate: plannedDate,
        plannedTime: plannedTime,
        sequenceOrder: sequenceOrder,
        status: status);

  Future<Result<Response<Map<String, dynamic>>>> getRouteWithAssignments(
      String routeId) async =>
      await remoteRouteService.getRouteWithAssignments(routeId);

  Future<Result<Response<void>>> removeShopFromRoute({
    required String routeId,
    required int assignmentId,
  }) async =>
      await remoteRouteService.removeShopFromRoute(
          routeId: routeId, assignmentId: assignmentId);
}