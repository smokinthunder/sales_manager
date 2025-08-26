import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/login_message_provider.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/common/widgets/drop_down_menu.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class AreaManagerHome extends ConsumerStatefulWidget {
  const AreaManagerHome({super.key});

  @override
  ConsumerState<AreaManagerHome> createState() => _AreaManagerHomeState();
}

class _AreaManagerHomeState extends ConsumerState<AreaManagerHome> {
  bool _isMessageShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final loginMessage = ref.read(loginMessageProvider);

    if (!_isMessageShown && loginMessage != null) {
      _isMessageShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, loginMessage);
        ref.read(loginMessageProvider.notifier).state = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderTexts(),
          const SizedBox(height: 40),
          Text("Create Route", style: Theme.of(context).textTheme.bodyLarge),
          CreateRouteCard(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              "Track Executive",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TrackExecutiveCard(),
          TextButton(
            onPressed: () {
              //TODO
            },
            child: Row(
              spacing: 10,
              children: [
                Text("Create Target"),
                Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderTexts extends StatelessWidget {
  const HeaderTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Executive : 12", style: textTheme.headlineSmall),
        Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              style: buttonStyle,
              onPressed: () {
                context.push(RoutePaths.addShop);
              },
              child: Text(
                "Add new customer",
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              style: buttonStyle,
              onPressed: () {
                //TODO:
              },
              child: Text(
                "Pending Requests",
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CreateRouteCard extends StatelessWidget {
  const CreateRouteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ColorScheme colorScheme = theme.colorScheme;
    return Card(
      color: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: CustomDropDownMenu(
                    hintText: "Select Location",
                    tinyTitle: true,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'ABC Plumbing',
                        label: 'ABC Plumbing',
                      ),
                      DropdownMenuEntry(
                        value: 'XYZ Hardware',
                        label: 'XYZ Hardware',
                      ),
                      DropdownMenuEntry(
                        value: 'LMN Electricals',
                        label: 'LMN Electricals',
                      ),
                    ],
                    title: "Location",
                  ),
                ),
                Flexible(
                  child: CustomDropDownMenu(
                    tinyTitle: true,
                    hintText: "Select Area",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'ABC Plumbing',
                        label: 'ABC Plumbing',
                      ),
                      DropdownMenuEntry(
                        value: 'XYZ Hardware',
                        label: 'XYZ Hardware',
                      ),
                      DropdownMenuEntry(
                        value: 'LMN Electricals',
                        label: 'LMN Electricals',
                      ),
                    ],
                    title: "Area",
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: CustomDropDownMenu(
                    tinyTitle: true,
                    hintText: "Select Executive",
                    dropdownMenuEntries: [],
                    title: "Location",
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text("Date", style: textTheme.bodySmall),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: colorScheme.tertiary),
                          ),
                          hint: Text('mm/dd/yyyy', style: textTheme.labelLarge),
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //TODO:
                  },
                  child: Text("Submit"),
                ),
                TextButton(
                  onPressed: () {
                    //TODO
                  },
                  child: Text('Add special route'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrackExecutiveCard extends StatelessWidget {
  const TrackExecutiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: CustomDropDownMenu(
                    hintText: "Executive list",
                    tinyTitle: true,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'ABC Plumbing',
                        label: 'ABC Plumbing',
                      ),
                      DropdownMenuEntry(
                        value: 'XYZ Hardware',
                        label: 'XYZ Hardware',
                      ),
                      DropdownMenuEntry(
                        value: 'LMN Electricals',
                        label: 'LMN Electricals',
                      ),
                    ],
                    title: "Select executive to track",
                  ),
                ),
                Flexible(
                  child: CustomDropDownMenu(
                    tinyTitle: true,
                    hintText: "Shop name",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'ABC Plumbing',
                        label: 'ABC Plumbing',
                      ),
                      DropdownMenuEntry(
                        value: 'XYZ Hardware',
                        label: 'XYZ Hardware',
                      ),
                      DropdownMenuEntry(
                        value: 'LMN Electricals',
                        label: 'LMN Electricals',
                      ),
                    ],
                    title: "Select a shop",
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //TODO:
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
