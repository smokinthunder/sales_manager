import 'package:admin_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreDetails extends StatelessWidget {
  const MoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by shop name",
                  ),
                ),
              ),
            ],
          ),
          _buildTitle(context, theme),
          Container(
            color: theme.colorScheme.primary.withAlpha(32),
            padding: EdgeInsets.all(12),
            child: Row(
              spacing: 12,
              children: [
                Flexible(
                  child: Column(
                    spacing: 12,
                    children: [
                      _buildShopTitleCard(theme),
                      _buildMoreDetails(theme),
                    ],
                  ),
                ),
                _buildAboutShopDetails(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildShopTitleCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(12),
      color: theme.colorScheme.onPrimary,
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage("imageUrl")),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name", style: theme.textTheme.bodyLarge),
              Text("Location", style: theme.textTheme.bodySmall),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Container _buildMoreDetails(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(12),
      color: theme.colorScheme.onPrimary,
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("More details", style: theme.textTheme.bodyLarge),
          _buildRowItem("Area manager : ", "Vishnu kumar"),
          _buildRowItem("Sales Executive : ", "Vishnu kumar"),
          _buildRowItem("Area : ", "Kalamassery"),
          _buildRowItem("Last Purchase : ", "15-06-2024"),
          _buildRowItem("Last Visit : ", "21-06-2024 | 10:30 AM"),
        ],
      ),
    );
  }

  Widget _buildAboutShopDetails(ThemeData theme) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        color: theme.colorScheme.onPrimary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            Text("About shop details", style: theme.textTheme.bodyLarge),
            _buildRowItem(
              "Address: ",
              "THIS IS SOME ADDRESSTHIS IS SOME ADDRESSTHIS IS SOME ADDRESS",
            ),
            _buildRowItem("Contact no : ", "+91 9797938457"),
            _buildRowItem("Location : ", "Kochi"),
            _buildRowItem("Shop owner : ", "Vishnu kumar"),
            _buildRowItem("Join date : ", "21-09-2023"),
          ],
        ),
      ),
    );
  }

  Row _buildRowItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Expanded(child: Text(value)),
      ],
    );
  }

  Row _buildTitle(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            context.go(Routes.customer);
          },
          child: Text(
            "Outstanding",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        Icon(Icons.chevron_right),
        Text("More Details/Kerala Pipe House"),
        Spacer(),
      ],
    );
  }
}
