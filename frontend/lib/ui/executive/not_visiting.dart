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
      body: Column(
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
          Text(
            "Enter reason for not visiting the shop",
            style: textTheme.labelLarge,
          ),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(hintText: "Type..."),
          ),
          ElevatedButton(
            onPressed: () {
              //TODO: Implement
            },
            child: Text("Send"),
          ),
        ],
      ),
    );
  }
}
