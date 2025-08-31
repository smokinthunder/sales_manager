import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:sales_manager/data/repositories/auth/auth_remote_repository.dart';
import 'package:sales_manager/data/repositories/user/user_remote_repository.dart';
import 'package:sales_manager/utils/result.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late AuthLocalRepository _authLocalRepository;
  late AuthRemoteRepository _authRemoteRepository;
  late UserRemoteRepository _userRemoteRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<String>? build() {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _userRemoteRepository = ref.watch(userRemoteRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> logout() async {
    await _authLocalRepository.clearTokens();
    await _authRemoteRepository.logout();
    _currentUserNotifier.removeUser();
  }

  Future<void> updateProfile(String name, String email) async {
    state = const AsyncValue.loading();
    final currentName = ref.read(currentUserNotifierProvider)?.name;
    final currentEmail = ref.read(currentUserNotifierProvider)?.email;
    final role =
        ref.read(currentUserNotifierProvider)?.role.backendName ??
        "sales_executive";
    final status =
        ref.read(currentUserNotifierProvider)?.status.backendName ?? "active";
    if (name == currentName && email == currentEmail) return;
    final res = await _userRemoteRepository.updateUserProfile(
      name: name,
      email: email,
      role: role,
      status: status,
    );
    switch (res) {
      case Ok():
        state = const AsyncValue.data("Profile updated successfully");

      case Error():
        state = AsyncValue.error(res.error, StackTrace.current);
    }
  }
}
