// auth_repository.dart
import 'dart:async';
import 'package:sales_manager/domain/models/user/user.dart';

class AuthRepository {
  AppUser? _currentUser;
  final _authCtrl = StreamController<AppUser?>.broadcast();

  Stream<AppUser?> get authChanges => _authCtrl.stream;
  AppUser? get currentUser => _currentUser;

  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<AppUser> verifyOtp(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Demo rule: last digit even => student, odd => teacher

    //TODO: Replace with actual OTP verification logic
    final last = int.tryParse(otp.substring(otp.length - 1)) ?? 0;
    final type = (last % 2 == 0) ? UserType.executive : UserType.areaManager;

    _currentUser = AppUser(id: phone, type: type);
    _authCtrl.add(_currentUser);
    return _currentUser!;
  }

  Future<void> signOut() async {
    _currentUser = null;
    _authCtrl.add(null);
  }

  void dispose() {
    _authCtrl.close();
  }
}
