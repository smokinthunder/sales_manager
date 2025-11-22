import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple state provider for notification count
final notificationCountProvider = StateProvider<int>((ref) => 0);