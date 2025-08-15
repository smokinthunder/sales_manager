import 'package:logging/logging.dart';

import 'package:sales_manager/data/repositories/auth/auth_repository.dart';
import 'package:sales_manager/data/services/local/local_data_service.dart';
import 'package:sales_manager/data/services/local/models/login_request/login_request.dart';
import 'package:sales_manager/utils/result.dart';

class AuthRepositoryLocal extends AuthRepository {
  AuthRepositoryLocal({required LocalDataService localDataService})
    : _localDataService = localDataService;
  bool? _isAuthenticated;
  final _log = Logger("AuthRepositoryLocal");
  final LocalDataService _localDataService;

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<String>> loginWithOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final result = await _localDataService.loginWithOtp(
        LoginRequest(phoneNumber: phoneNumber, otp: otp),
      );
      switch (result) {
        case Ok():
          _log.info('User logged int');
          // Set auth status
          _isAuthenticated = true;
          return Result.ok(result.value);
        case Error():
          _log.warning('Error logging in: ${result.error}');
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      _isAuthenticated = false;
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }
}
