import 'package:flutter/material.dart';

/// Reusable empty state widget for consistent empty state UI across the app
/// 
/// Displays an icon, title, message, and optional action button
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.iconColor,
    this.iconSize = 64,
  });

  /// Icon to display (e.g., Icons.inbox_outlined, Icons.error_outline)
  final IconData icon;

  /// Main title text (e.g., "No orders found")
  final String title;

  /// Descriptive message text (e.g., "Orders will appear here once created")
  final String message;

  /// Optional action button label (e.g., "Add Order", "Retry")
  final String? actionLabel;

  /// Callback when action button is pressed
  final VoidCallback? onActionPressed;

  /// Color for the icon (defaults to theme tertiary color)
  final Color? iconColor;

  /// Size of the icon (defaults to 64)
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.tertiary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state variant for error scenarios with retry button
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Error title
  final String title;

  /// Error message
  final String message;

  /// Retry callback
  final VoidCallback onRetry;

  /// Icon to display (defaults to error_outline)
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state variant for search results
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    required this.searchQuery,
    this.icon = Icons.search_off,
  });

  /// The search query that returned no results
  final String searchQuery;

  /// Icon to display (defaults to search_off)
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: icon,
      title: 'No results found',
      message: 'No results found for "$searchQuery".\nTry adjusting your search.',
    );
  }
}

/// Empty state variant for loading scenarios
class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
    this.message = 'Loading...',
  });

  /// Loading message
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
