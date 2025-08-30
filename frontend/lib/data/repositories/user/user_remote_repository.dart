import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_user_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'user_remote_repository.g.dart';

@Riverpod(keepAlive: true)
UserRemoteRepository userRemoteRepository(Ref<UserRemoteRepository> ref) {
  return UserRemoteRepository();
}

class UserRemoteRepository {
  final RemoteUserService remoteUserService = RemoteUserService();

  Future<Result<Response<Map<String, dynamic>>>> updateUser({
    required String name,
    required String email,
    required String role,
    required String status,
  }) async => await remoteUserService.updateUser(
    name: name,
    email: email,
    role: role,
    status: status,
  );
}
