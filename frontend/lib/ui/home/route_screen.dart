import 'package:flutter/material.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key, required this.isSpecial});
  final bool isSpecial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Screen"), centerTitle: true),
      body: const Center(child: Text("Route Screen")),
    );
  }
}
