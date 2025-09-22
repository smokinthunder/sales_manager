import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/route/route_remote_repository.dart';
import 'package:sales_manager/data/repositories/shop/shop_remote_repository.dart';
import 'package:sales_manager/data/repositories/user/user_remote_repository.dart';
import 'package:sales_manager/domain/models/user/user_role.dart';
import 'package:sales_manager/utils/result.dart';

part 'home_screen_viewmodel.g.dart';

@Riverpod(keepAlive: true)
Future<List<Map<String, dynamic>>> getTopFourShops(Ref ref) async {
  final res = await ref.watch(shopRemoteRepositoryProvider).getShops();
  print(res);
  switch (res) {
    case Ok():
      final length = res.value.length;
      if (length > 4) {
        return res.value.sublist(0, 4);
      }
      return res.value;
    case Error():
      print(res.error.toString());
      return [];
  }
}

@Riverpod(keepAlive: true)
Future<List<Map<String, dynamic>>> getAllShops(Ref ref) async {
  final res = await ref.watch(shopRemoteRepositoryProvider).getShops();
  print(res);
  switch (res) {
    case Ok():
      return res.value;
    case Error():
      print(res.error.toString());
      return [];
  }
}

@riverpod
Future<List<Map<String, dynamic>>> getAllRoutes(Ref ref) async {
  final res = await ref.watch(routeRemoteRepositoryProvider).getRoutes();
  print(res);
  switch (res) {
    case Ok():
      final rawData = res.value;
      final filteredList = rawData.map((item) {
        return {
          for (var key in ['route_id', 'name']) key: item[key],
        };
      }).toList();
      return filteredList;
    case Error():
      print(res.error.toString());
      return [];
  }
}

@riverpod
Future<List<Map<String, dynamic>>> getAllSalesExecutives(Ref ref) async {
  final res = await ref
      .watch(userRemoteRepositoryProvider)
      .getUsers(role: UserRole.salesExecutive.backendName);
  print(res);
  switch (res) {
    case Ok():
      final rawData = res.value;
      final filteredList = rawData.map((item) {
        return {
          for (var key in ['id', 'name']) key: item[key],
        };
      }).toList();
      return filteredList;
    case Error():
      print(res.error.toString());
      return [];
  }
}

@riverpod
class RouteCardViewModel extends _$RouteCardViewModel {
  late RouteRemoteRepository _routeRemoteRepository;
  @override
  AsyncValue? build() {
    _routeRemoteRepository = ref.watch(routeRemoteRepositoryProvider);
    return null;
  }

  Future<void> assignRoutes({
    required String routeId,
    required String shopId,
    required String salesExecutiveId,
    required String plannedDate,
  }) async {
    state = const AsyncValue.loading();
    final int salesExecutiveIdInt = int.parse(salesExecutiveId);
    final res = await _routeRemoteRepository.addShopToRoute(
      routeId: routeId,
      shopId: shopId,
      salesExecutiveId: salesExecutiveIdInt,
      plannedDate: plannedDate,
    );
    switch (res) {
      case Ok():
        state = AsyncValue.data(res.value);
      case Error():
        state = AsyncValue.error(res.error, StackTrace.current);
    }
  }
}
