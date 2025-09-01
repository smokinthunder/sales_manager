import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
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
                theme: theme,
                photoUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMHBob3RvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
                subject: "Profile Editing Request",
                name: "Jestin George",
                onTap: () {
                  //TODO: handle on tap
                },
              ),
              _buldMessageCard(
                time: "02:06 PM",
                theme: theme,
                photoUrl:
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZSUyMHBob3RvfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60",
                subject: "Profile Editing Request",
                name: "Jestin George",
                onTap: () {
                  //TODO: handle on tap
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
    void Function()? onTap,
    required ThemeData theme,
  }) => Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: theme.colorScheme.surface, width: 2),
      ),
    ),
    child: InkWell(
      onTap: onTap,
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
                  Text(name, style: theme.textTheme.bodyLarge),
                  SizedBox(height: 4),
                  Text(
                    "Subject: $subject",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                time,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
        ],
      ),
    ),
  );
}
