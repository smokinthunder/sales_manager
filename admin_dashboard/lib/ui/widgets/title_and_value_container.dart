import 'package:flutter/material.dart';

class TitleAndValueContainer extends StatelessWidget {
  const TitleAndValueContainer({
    super.key,
    required this.title,
    required this.count,
    this.width = 160,
  });

  final String title;
  final String count;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      width: width,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.tertiary.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4),
          Text(count, style: theme.textTheme.headlineMedium),
        ],
      ),
    );
  }
}
