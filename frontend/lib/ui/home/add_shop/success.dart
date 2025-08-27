import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/assets.dart';
import 'package:sales_manager/routing/route_paths.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

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
                    child: Image.asset(Assets.successGreenTick, width: 190),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text("Success !", style: textTheme.headlineLarge),
                  ),
                  Text(
                    "New shop has been successfully created.",
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.tertiary,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
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
