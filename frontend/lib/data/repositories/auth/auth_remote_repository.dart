import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/remote/remote_auth_service.dart';
import 'package:sales_manager/utils/result.dart';

part 'auth_remote_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteRepository authRemoteRepository(Ref<AuthRemoteRepository> ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  final RemoteAuthService remoteAuthService = RemoteAuthService();
  Future<Result<Response<Map<String, dynamic>>>> generateOtp(
    String phoneNumber,
  ) async => await remoteAuthService.generateOtp(phoneNumber);

  Future<Result<Response<Map<String, dynamic>>>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async => await remoteAuthService.verifyOtp(phoneNumber, otp);

  Future<Result<Response<Map<String, dynamic>>>> refreshToken(
    String refreshToken,
  ) async => await remoteAuthService.refreshToken(refreshToken);
  Future<Result<Response<String>>> logout() async =>
      await remoteAuthService.logout();
  Future<Result<Response<Map<String, dynamic>>>> getCurrentUser() async =>
      await remoteAuthService.getCurrentUser();
}
