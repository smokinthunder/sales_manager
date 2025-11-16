import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Screen"), centerTitle: true),
      body: const Center(child: Text("Route Screen")),
    );
  }
}
