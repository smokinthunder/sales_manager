import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 16,
        children: [
          Row(
            children: [
              Text("All notifications", style: theme.textTheme.bodyLarge),
              Spacer(),
              TextButton(
                onPressed: () {
                  //TODO: handle clearing notifications
                },
                child: Text(
                  "Clear all",
                  style: TextStyle(color: theme.colorScheme.tertiary),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          NotPlacingOrNotVistedCard(
            isNotplacing: true,
            shopName: "Western Electricals",
            executiveName: "Gokul GS",
            onDismiss: () {
              //TODO: you make need to write a mapping function, but I don't know how data is going to come here, so I didn't write one.
            },
          ),
          NotPlacingOrNotVistedCard(
            shopName: "Western Electricals",
            executiveName: "Gokul GS",
            onDismiss: () {
              //TODO: you make need to write a mapping function, but I don't know how data is going to come here, so I didn't write one.
            },
          ),
          ProfileEditingRequest(
            changes: [
              const DataChange(
                changeType: "Phone Number",
                oldValue: "9876543210",
                newValue: "9123456780",
              ),
              const DataChange(
                changeType: "Address",
                oldValue: "Old Street, City",
                newValue: "New Avenue, City",
              ),
            ],
            userDesignation: "Area Manager",
            userName: "Sandheep KP",
            onApprove: () {
              //TODO:
            },
            onReject: () {
              //TODO
            },
            onDismiss: () {
              //TODO
            },
          ),
        ],
      ),
    );
  }
}

class NotPlacingOrNotVistedCard extends StatelessWidget {
  const NotPlacingOrNotVistedCard({
    super.key,
    required this.onDismiss,
    required this.shopName,
    required this.executiveName,
    this.reasonForEvent,
    this.isNotplacing = false,
  });
  final VoidCallback onDismiss;
  final String shopName;
  final String executiveName;
  final String? reasonForEvent;
  final bool isNotplacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                isNotplacing
                    ? "Reason for not placing order"
                    : "Not Visited Shops",
                style: theme.textTheme.bodyLarge,
              ),
              Spacer(),
              IconButton(onPressed: onDismiss, icon: Icon(Icons.close)),
            ],
          ),
          Text(
            shopName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          IconTheme.merge(
            data: IconThemeData(size: 36),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(),
              expandedAlignment: Alignment.topLeft,
              tilePadding: EdgeInsets.only(right: 4),
              title: Text(executiveName, style: theme.textTheme.labelLarge),
              children: [
                if (reasonForEvent != null) Text(reasonForEvent!.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileEditingRequest extends StatelessWidget {
  const ProfileEditingRequest({
    super.key,
    required this.onDismiss,
    required this.userName,
    required this.userDesignation,
    required this.changes,
    required this.onApprove,
    required this.onReject,
  });
  final VoidCallback onDismiss;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final String userName;
  final String userDesignation;
  final List<DataChange> changes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Profile Editing Request", style: theme.textTheme.bodyLarge),
              Spacer(),
              IconButton(onPressed: onDismiss, icon: Icon(Icons.close)),
            ],
          ),
          Text(
            userName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(userDesignation, style: theme.textTheme.labelLarge),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(
              color: theme.colorScheme.onSurface.withAlpha(38),
              height: 2,
            ),
          ),
          Column(
            children: [
              ...changes.map(
                (e) => ExpansionTile(
                  tilePadding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(),
                  expandedAlignment: Alignment.topLeft,
                  title: Row(
                    children: [
                      Text(
                        "${e.changeType}: ",
                        style: theme.textTheme.bodyLarge,
                      ),
                      Text(
                        e.newValue,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          copyToClipBoard(context, e.newValue);
                        },
                        icon: Icon(
                          Icons.copy,
                          color: theme.colorScheme.tertiary,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    InkWell(
                      onTap: () {
                        copyToClipBoard(context, e.oldValue);
                      },
                      child: Row(
                        children: [
                          Text(
                            "Old ${e.changeType}:\t\t\t",
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            e.oldValue,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlueBorderButtons(
                    title: "Approve",
                    onClick: () {},
                    invert: true,
                  ),
                  const SizedBox(width: 8),
                  BlueBorderButtons(title: "Reject", onClick: () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void copyToClipBoard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Copied $value to clipboard, Use Ctrl + V to paste"),
      ),
    );
  }
}

class DataChange {
  final String changeType;
  final String oldValue;
  final String newValue;
  const DataChange({
    required this.changeType,
    required this.oldValue,
    required this.newValue,
  });
}
