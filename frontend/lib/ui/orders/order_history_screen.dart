import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Search", style: textTheme.bodyLarge),
              Text("Order History Screen"),
            ],
          ),
        ),
      ),
    );
  }
}
