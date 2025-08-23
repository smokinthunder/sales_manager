import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/utils/result.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  // late String _phoneNumberStore;
  final _log = Logger("AuthViewModel");

  @override
  AsyncValue<AppUser>? build() {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> sendOtp({required phoneNumber}) async {
    state = const AsyncValue.loading();
    _log.info("Sending OTP to $phoneNumber");
    final res = await _authLocalRepository.sendOtp(phoneNumber);
    _log.info("Otp sent to $phoneNumber: $res");
    switch (res) {
      case Ok():
        _log.info("Otp send to $phoneNumber");
        // _phoneNumberStore = phoneNumber;
        state = AsyncData(AppUser(id: "", type: UserType.executive, name: ''));
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> verifyOtp({required phoneNumber, required otp}) async {
    state = const AsyncLoading();
    final res = await _authLocalRepository.verifyOtp(phoneNumber, otp);
    switch (res) {
      case Ok():
        _log.info("Logged in as ${res.value.id}");
        _verifyOtpSuccess(res.value);
      case Error():
        _log.warning("Otp doesn't match");
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  AsyncValue<AppUser>? _verifyOtpSuccess(AppUser user) {
    _currentUserNotifier.addUser(user);
    _log.info("Current user updated: ${_currentUserNotifier.state}");
    return state = AsyncData(user);
  }
}
