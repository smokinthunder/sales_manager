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
  ) async {
    final res = await remoteAuthService.generateOtp(phoneNumber);
    return res;
  }

  Future<Result<Response<Map<String, dynamic>>>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    final res = await remoteAuthService.verifyOtp(phoneNumber, otp);
    return res;
  }
}
