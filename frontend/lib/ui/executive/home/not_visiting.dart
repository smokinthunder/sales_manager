import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';

class ReasonForNotVisitingScreen extends StatelessWidget {
  final Shop shop;
  const ReasonForNotVisitingScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Reason for non visiting"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: textTheme.bodyLarge),
                    Text(shop.location, style: textTheme.labelLarge),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Last visit: ${DateFormat('dd-MM-yyyy').format(shop.lastVisted)}",
                      style: textTheme.labelSmall,
                    ),
                    Text(
                      DateFormat('hh:mm a').format(shop.lastVisted),
                      style: textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Enter reason for not visiting the shop",
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSecondary,
              ),
            ),

            SizedBox(height: 8),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(hintText: "Type..."),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                //TODO: Implement
              },
              child: Text("Send"),
            ),
          ],
        ),
      ),
    );
  }
}
