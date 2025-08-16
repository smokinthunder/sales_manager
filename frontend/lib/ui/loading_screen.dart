import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage(
            "assets/images/logo.png",
          ), // replace with your image path
          width: 300, // optional size
          height: 300,
        ),
      ),
    );
  }
}
