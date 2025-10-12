import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/analytics/analytics.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Customer extends StatelessWidget {
  const Customer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          Row(
            spacing: 32,
            children: [
              TitleAndValueContainer(title: "All Customers", count: "15489"),

              TitleAndValueContainer(title: "New Customers", count: "5"),
              Spacer(),
              InkWell(
                onTap: () {
                  //TODO
                  context.go(Routes.addNewCusomter);
                },
                child: Row(
                  children: [
                    Text(
                      "Add new Customer ",
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    Icon(Icons.add, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ],
          ),
          Row(
            spacing: 32,
            children: [
              BlueBorderButtons(
                title: "Active customers",
                onClick: () {
                  //TODO
                  context.go(Routes.activeCustomers);
                },
              ),
              BlueBorderButtons(
                title: "Inactive customers",
                onClick: () {
                  //TODO
                  context.go(Routes.inactiveCustomers);
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('All customer list', style: theme.textTheme.headlineMedium),
              Spacer(),
              Text("Sort by  ", style: theme.textTheme.labelLarge),
              SizedBox(
                width: 118,
                child: CustomDropDownMenu(
                  hintText: "New",
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "Old", label: "Old"),
                    DropdownMenuEntry(value: "A-Z", label: "A-Z (Ascending)"),
                    DropdownMenuEntry(
                      value: "Month",
                      label: "Z-A (Descending)",
                    ),
                  ],
                ),
              ),
            ],
          ),
          SafePaginatedCardGrid(
            spacing: 16,
            cardWidth: 300,
            cardHeight: 136,
            cards: [
              for (final _ in Iterable.generate(15489))
                ShopCard(
                  imageUrl: "",
                  title: "shop Name",
                  location: "location",
                  onClick: () {
                    //TODO:

                    context.go(Routes.customerDetails);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  const ShopCard({
    super.key,
    required this.onClick,
    required this.title,
    required this.location,
    required this.imageUrl,
  });
  final VoidCallback onClick;
  final String title;
  final String location;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 300,
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
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
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
          BlueBorderButtons(
            title: "View details",
            onClick: onClick,
            invert: true,
          ),
        ],
      ),
    );
  }
}

class BlueBorderButtons extends StatelessWidget {
  const BlueBorderButtons({
    super.key,
    required this.title,
    required this.onClick,
    this.invert = false,
  });
  final String title;
  final VoidCallback onClick;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: invert ? theme.colorScheme.primary : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.primary, width: 1),
        ),
        child: Text(
          title,
          style: invert
              ? theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                )
              : theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
        ),
      ),
    );
  }
}
