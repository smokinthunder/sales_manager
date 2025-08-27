import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ViewExecutiveHistory extends StatefulWidget {
  const ViewExecutiveHistory({super.key});

  @override
  State<ViewExecutiveHistory> createState() => _ViewExecutiveHistoryState();
}

class _ViewExecutiveHistoryState extends State<ViewExecutiveHistory> {
  SelectedView selectedView = SelectedView.visited;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Visit History"),
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
              Row(
                spacing: 20,
                children: [
                  _invertingButton(
                    colorScheme,
                    textTheme,
                    selectedView == SelectedView.visited,
                    "Visited shops",
                    () {
                      setState(() {
                        selectedView = SelectedView.visited;
                      });
                    },
                  ),
                  _invertingButton(
                    colorScheme,
                    textTheme,
                    selectedView == SelectedView.nonVisited,
                    "Non Visited shops",
                    () {
                      setState(() {
                        selectedView = SelectedView.nonVisited;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              Table(
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.tertiary.withAlpha(64),
                          width: 3,
                        ),
                      ),
                    ),
                    children: [
                      _buildTitle(
                        textTheme,
                        colorScheme,
                        (selectedView == SelectedView.nonVisited)
                            ? "Assigned date"
                            : "Visited date",
                      ),
                      _buildTitle(textTheme, colorScheme, "Shop name"),
                      _buildTitle(textTheme, colorScheme, "Shop photo"),
                    ],
                  ),
                  _buildDataRow(
                    textTheme,
                    colorScheme,
                    DateTime.now(),
                    "Shop 1",
                    "https://picsum.photos/200",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildDataRow(
    TextTheme textTheme,
    ColorScheme colorScheme,
    DateTime date,
    String shopName,
    String photoUrl,
  ) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            DateFormat('dd-MM-yyyy').format(date),
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),

          child: Text(
            shopName,
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: selectedView == SelectedView.visited
                ? () {
                    //TODO: handle url
                  }
                : null,
            child: Text(
              "View photo",
              style: textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.underline,
                color: selectedView == SelectedView.visited
                    ? colorScheme.onSurface
                    : colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildTitle(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }

  InkWell _invertingButton(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool selected,
    String title,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(8),
          border: selected ? null : Border.all(color: colorScheme.tertiary),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Text(
            title,
            style: textTheme.labelLarge?.copyWith(
              color: selected ? colorScheme.onPrimary : colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}

enum SelectedView { visited, nonVisited }
