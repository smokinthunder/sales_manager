import 'package:admin_dashboard/routing/router.dart';
import 'package:admin_dashboard/ui/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerP = ref.watch(router);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerP,
      title: 'AquaStar',
      theme: appTheme,
    );
  }
}
