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

  Future<Result<Response<Map<String, dynamic>>>> createUser({
    required String phone,
    required String name,
    required String email,
    required String role,
    required String status,
  }) async => await remoteUserService.createUser(
    phone: phone,
    name: name,
    email: email,
    role: role,
    status: status,
  );

  Future<Result<Response<List<Map<String, dynamic>>>>> getUsers({
    String? role,
    String? status,
    String? search,
  }) async => await remoteUserService.getUsers(
    role: role,
    status: status,
    search: search,
  );

  Future<Result<Response<Map<String, dynamic>>>> getUser(String userId) async =>
      await remoteUserService.getUser(userId);

  Future<Result<Response<Map<String, dynamic>>>> updateUser({
    required String userId,
    required String name,
    required String email,
    required String role,
    required String status,
  }) async => await remoteUserService.updateUser(
    userId: userId,
    name: name,
    email: email,
    role: role,
    status: status,
  );

  Future<Result<Response<String>>> deleteUser(String userId) async =>
      await remoteUserService.deleteUser(userId);

  Future<Result<Response<Map<String, dynamic>>>> updateUserProfile({
    required String name,
    required String email,
    required String role,
    required String status,
  }) async => await remoteUserService.updateUserProfile(
    name: name,
    email: email,
    role: role,
    status: status,
  );

  Future<Result<Response<Map<String, dynamic>>>> getUserByPhone(
    String phone,
  ) async => await remoteUserService.getUserByPhone(phone);

  Future<Result<Response<String>>> getPendingApprovals() async =>
      await remoteUserService.getPendingApprovals();

  Future<Result<Response<String>>> approveProfileUpdate(
    String requestId,
  ) async => await remoteUserService.approveProfileUpdate(requestId);

  Future<Result<Response<String>>> rejectProfileUpdate(
    String requestId,
    String reason,
  ) async => await remoteUserService.rejectProfileUpdate(requestId, reason);

  Future<Result<Response<String>>> getUserApprovalHistory(
    String userID,
  ) async => await remoteUserService.getUserApprovalHistory(userID);
}
