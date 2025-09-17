import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/repositories/shop/shop_remote_repository.dart';
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
