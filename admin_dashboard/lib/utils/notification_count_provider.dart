import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_count_provider.g.dart';

/// Notification count state notifier
@riverpod
class NotificationCount extends _$NotificationCount {
  @override
  int build() => 0;

  void updateCount(int count) {
    state = count;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) state--;
  }

  void reset() {
    state = 0;
  }
}
