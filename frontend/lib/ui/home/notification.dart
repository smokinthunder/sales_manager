import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buldMessageCard(
                time: "02:06 PM",
                colorScheme: colorScheme,
                textTheme: textTheme,
                photoUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMHBob3RvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
                subject: "Profile Editing Request",
                name: "Jestin George",
                onDeleteTap: () {
                  //TODO: handle delete
                },
                onConfirmTap: () {
                  //TODO: handle confirm
                },
              ),
              _buldMessageCard(
                time: "02:06 PM",
                textTheme: textTheme,
                colorScheme: colorScheme,
                photoUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMHBob3RvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
                subject: "Profile Editing Request",
                name: "Jestin George",
                onDeleteTap: () {
                  //TODO: handle delete
                },
                onConfirmTap: () {
                  //TODO: handle confirm
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buldMessageCard({
    required String photoUrl,
    required String subject,
    required String name,
    required String time,
    void Function()? onDeleteTap,
    void Function()? onConfirmTap,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) => Container(
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: colorScheme.surface, width: 2)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 18, 10),
              child: CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: textTheme.bodyLarge),
                SizedBox(height: 4),
                Text(
                  "Subject: $subject",
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              time,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 10,
          children: [
            InkWell(
              onTap: onDeleteTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.primary),
                ),
                child: Text(
                  "Delete",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: onConfirmTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Confirm",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
      ],
    ),
  );
}
