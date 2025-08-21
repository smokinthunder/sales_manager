// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sales_manager/data/repositories/auth/auth_repository.dart';
// import 'package:sales_manager/domain/models/user/user.dart';

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final repo = AuthRepository();
//   ref.onDispose(repo.dispose);
//   return repo;
// });

// // Optional: expose a stream for widgets that want to react to auth changes.
// final authStreamProvider = StreamProvider<AppUser?>((ref) {
//   return ref.watch(authRepositoryProvider).authChanges;
// });
