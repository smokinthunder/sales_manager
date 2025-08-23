import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/data/services/local/local_data_service.dart';
import 'package:sales_manager/data/services/local/models/login_request.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/utils/result.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref<AuthLocalRepository> ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  final LocalDataService localDataService = LocalDataService();
  final _log = Logger('AuthLocalRepository');
  Future<Result<String>> sendOtp(String phoneNumber) async {
    _log.info('Sending OTP to $phoneNumber');
    final registered = await localDataService.isPhoneRegistered(phoneNumber);
    if (registered) {
      _log.info('Phone number $phoneNumber is registered, sending OTP');
      return Result.ok("OTP sent to $phoneNumber");
    } else {
      _log.warning('Phone number $phoneNumber is not registered');
      return Result.error(Exception("Phone number is not registered"));
    }
  }

  Future<Result<AppUser>> verifyOtp(String phoneNumber, String otp) async {
    final result = await localDataService.loginWithOtp(
      LoginRequest(phoneNumber: phoneNumber, otp: otp),
    );
    _log.info('Verifying OTP for $phoneNumber');
    switch (result) {
      case Ok():
        _log.info('OTP verified successfully for $phoneNumber');
        final user = result.value;
        final appUser = AppUser(
          id: user.id,
          type: user.type,
          name: "${user.firstName} ${user.lastName}",
        );
        return Result.ok(appUser);
      case Error():
        _log.warning(
          'OTP verification failed for $phoneNumber: ${result.error}',
        );
        return Result.error(result.error);
    }
  }
}
