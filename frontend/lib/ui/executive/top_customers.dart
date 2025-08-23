import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/routes.dart';

class TopCustomersScreen extends StatelessWidget {
  const TopCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Customers"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.go(AppRoutes.executiveHome);
          },
        ),
        centerTitle: true,
      ),
      body: Center(child: Text("Top Customers Screen")),
    );
  }
}
