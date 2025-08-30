import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:sales_manager/data/repositories/auth/auth_remote_repository.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/domain/models/user/user_role.dart';
import 'package:sales_manager/domain/models/user/user_status.dart';
import 'package:sales_manager/utils/result.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  late AuthRemoteRepository _authRemoteRepository;

  @override
  AsyncValue<AppUser>? build() {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    return null;
  }

  Future<Map<String, dynamic>?> generateOtp({required phoneNumber}) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.generateOtp(phoneNumber);
    switch (res) {
      case Ok():
        state = AsyncData(AppUser.empty());
        return res.value.data;
      case Error():
        state = AsyncError(res.error, StackTrace.current);
        return null;
    }
  }

  Future<void> verifyOtp({required phoneNumber, required otp}) async {
    state = const AsyncValue.loading();
    final res = await _authRemoteRepository.verifyOtp(phoneNumber, otp);
    switch (res) {
      case Ok():
        final data = res.value.data;
        // Save tokens
        await _authLocalRepository.saveTokens(
          accessToken: data?["access_token"],
          refreshToken: data?["refresh_token"],
          expiresIn: data?["expires_in"],
        );

        // Store user data in state
        final user = data?["user"];
        final appUser = AppUser(
          name: user["name"],
          email: user["email"] ?? "",
          phoneNumber: user["phone"],
          pictureUrl: "",
          id: user["id"].toString(),
          role: UserRole.fromBackend(user["role"]),
          location: "",
          status: UserStatus.fromBackend(user["status"]),
        );
        _currentUserNotifier.addUser(appUser);
        state = AsyncValue.data(appUser);
      case Error():
        state = AsyncError(res.error, StackTrace.current);
    }
  }

  Future<void> getUser() async {
    final token = await _authLocalRepository.getAccessToken();
    if (token != null) {
      final user = await _authRemoteRepository.getCurrentUser();
      switch (user) {
        case Ok():
          final userData = user.value.data;
          AppUser appUser = AppUser(
            name: userData?["name"] ?? "",
            email: userData?["email"] ?? "",
            phoneNumber: userData?["phone"] ?? "",
            pictureUrl: "",
            id: userData?["id"].toString() ?? "",
            role: UserRole.fromBackend(userData?["role"]),
            location: "",
            status: UserStatus.fromBackend(userData?["status"]),
          );
          _currentUserNotifier.addUser(appUser);
        case Error():
      }
    }
  }
}
