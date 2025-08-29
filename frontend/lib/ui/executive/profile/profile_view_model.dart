import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/data/repositories/auth/auth_local_repository.dart';
import 'package:sales_manager/data/repositories/auth/auth_remote_repository.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late AuthLocalRepository _authLocalRepository;
  late AuthRemoteRepository _authRemoteRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<void>? build() {
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> logout() async {
    await _authLocalRepository.clearTokens();
    await _authRemoteRepository.logout();
    _currentUserNotifier.removeUser();
  }
}
