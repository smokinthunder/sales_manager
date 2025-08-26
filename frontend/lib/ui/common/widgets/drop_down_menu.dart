import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu<T> extends StatelessWidget {
  const CustomDropDownMenu({
    super.key,
    required this.hintText,
    required this.dropdownMenuEntries,
    this.onSelected,
    this.title,
    this.width,
    this.tinyTitle = false,
  });
  final String hintText;
  final String? title;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;
  final double? width;
  final bool tinyTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              title!,
              style: tinyTitle
                  ? textTheme.bodySmall
                  : textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
            ),
          ),
        DropdownMenu<T>(
          width: width,
          hintText: hintText,
          textStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.tertiary),
          inputDecorationTheme: theme.dropdownMenuTheme.inputDecorationTheme
              ?.copyWith(constraints: BoxConstraints.expand(height: 48)),
          selectedTrailingIcon: Icon(
            CupertinoIcons.chevron_up,
            size: 24,
            color: colorScheme.tertiary,
          ),
          trailingIcon: Icon(
            CupertinoIcons.chevron_down,
            size: 24,
            color: colorScheme.tertiary,
          ),
          dropdownMenuEntries: dropdownMenuEntries,
          onSelected: onSelected,
        ),
      ],
    );
  }
}
