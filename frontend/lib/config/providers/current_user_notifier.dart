import 'package:sales_manager/domain/models/user/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_notifier.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  AppUser? build() {
    return null;
  }

  void addUser(AppUser user) {
    state = user;
  }

  void removeUser() {
    state = null;
  }
}
