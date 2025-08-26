import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/assets.dart';
import 'package:sales_manager/routing/route_paths.dart';

class WaitForApprovalScreen extends StatelessWidget {
  const WaitForApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(Assets.circleProgress, width: 150),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Wait for approval",
                      style: textTheme.headlineLarge,
                    ),
                  ),
                  Text(
                    "Registration has been completed successfully, waiting for the admin's response.",
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: complete
                    context.go(RoutePaths.home);
                  },
                  child: const Text("Continue"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
