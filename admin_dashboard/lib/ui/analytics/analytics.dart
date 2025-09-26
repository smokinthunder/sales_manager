import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

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
        spacing: 24,
        children: [
          TextButton(
            onPressed: () {
              context.go(Routes.pointSystem);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Point System"),
                Icon(Icons.chevron_right, size: 24),
              ],
            ),
          ),
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
          Row(
            children: [
              Text(
                'All Shops Analytics Overview',
                style: theme.textTheme.headlineMedium,
              ),
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
          Container(
            color: theme.colorScheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var i = 1; i <= 5; i++)
                  RatingCard(
                    count: i,
                    isSelected: i == 1,
                    onTap: () {
                      //TODO
                    },
                  ),
              ],
            ),
          ),
          SafePaginatedCardGrid(
            cards: List.generate(
              1000000,
              (index) => ShopAnalyticsCard(
                onTap: () {
                  //TODO:
                  context.go(Routes.shopAnalytics);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SafePaginatedCardGrid extends StatefulWidget {
  final List<Widget> cards; //Probably could pass data here instead of widgets,
  final double cardWidth;
  final double cardHeight;
  final double spacing;
  final int rowsPerPage;

  const SafePaginatedCardGrid({
    super.key,
    required this.cards,
    this.cardWidth = 260,
    this.cardHeight = 190,
    this.spacing = 20,
    this.rowsPerPage = 4,
  });

  @override
  State<SafePaginatedCardGrid> createState() => _SafePaginatedCardGridState();
}

class _SafePaginatedCardGridState extends State<SafePaginatedCardGrid> {
  int currentPage = 0;

  List<int> getVisiblePages(int totalPages, int currentPage) {
    List<int> pages = [];

    if (totalPages <= 7) {
      pages = List.generate(totalPages, (i) => i);
    } else {
      pages.add(0); // first page
      if (currentPage > 3) pages.add(-1); // ellipsis

      int start = (currentPage - 1).clamp(1, totalPages - 3);
      int end = (currentPage + 1).clamp(3, totalPages - 2);

      for (int i = start; i <= end; i++) {
        pages.add(i);
      }

      if (currentPage < totalPages - 4) pages.add(-1); // ellipsis
      pages.add(totalPages - 1); // last page
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cards.isEmpty) return SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Calculate cards per row
        final cardsPerRow =
            ((availableWidth + widget.spacing) ~/
                    (widget.cardWidth + widget.spacing))
                .clamp(1, widget.cards.length);

        // Cards per page
        final cardsPerPage = cardsPerRow * widget.rowsPerPage;

        // Total pages
        final totalPages = (widget.cards.length / cardsPerPage).ceil();

        // Clamp currentPage to valid range
        if (currentPage >= totalPages) {
          currentPage = totalPages - 1;
        }
        if (currentPage < 0) {
          currentPage = 0;
        }

        // Determine sublist safely
        final start = currentPage * cardsPerPage;
        final end = (start + cardsPerPage).clamp(0, widget.cards.length);
        final pageCards = widget.cards.sublist(start, end);

        final visiblePages = getVisiblePages(totalPages, currentPage);

        return Column(
          children: [
            // Grid
            SizedBox(
              height:
                  widget.rowsPerPage * widget.cardHeight +
                  (widget.rowsPerPage - 1) * widget.spacing,
              child: Padding(
                padding: EdgeInsets.all(widget.spacing / 2),
                child: Wrap(
                  spacing: widget.spacing,
                  runSpacing: widget.spacing,
                  children: pageCards
                      .map(
                        (card) => SizedBox(
                          width: widget.cardWidth,
                          height: widget.cardHeight,
                          child: card,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pagination controls
            if (totalPages > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous button
                  if (currentPage > 0)
                    InkWell(
                      onTap: () => setState(() => currentPage--),
                      child: Text('Previous'),
                    ),
                  const SizedBox(width: 8),

                  // Page numbers with ellipsis
                  ...visiblePages.map((i) {
                    if (i == -1) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Text('…'),
                      );
                    } else {
                      return InkWell(
                        onTap: () => setState(() => currentPage = i),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: i == currentPage
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: i == currentPage
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }
                  }),

                  const SizedBox(width: 8),

                  // Next button
                  if (currentPage < totalPages - 1)
                    InkWell(
                      onTap: () => setState(() => currentPage++),
                      child: Text('Next'),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class ShopAnalyticsCard extends StatelessWidget {
  const ShopAnalyticsCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
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
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined, color: theme.colorScheme.tertiary),
              Text(" National Pipes", style: theme.textTheme.bodyLarge),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, color: theme.colorScheme.tertiary),
              Text(" Rahul Dev", style: theme.textTheme.labelLarge),
            ],
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                color: Colors.amber,
                size: 28,
              ),
              Text(" 2456", style: theme.textTheme.headlineLarge),
            ],
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "View Analytics",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  const RatingCard({
    super.key,
    required this.count,
    required this.isSelected,
    required this.onTap,
  }) : assert(count <= 5 && count >= 0, "Count must be between 0 and 5");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: isSelected
            ? BoxDecoration(
                color: theme.colorScheme.onPrimary,
                border: Border.all(color: theme.colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Column(
          children: [
            Row(
              children: [
                for (var i = 1; i <= count; i++)
                  Icon(
                    Icons.star_rate_rounded,
                    color: theme.colorScheme.secondary.withAlpha(
                      isSelected ? 255 : 200,
                    ),
                  ),
                for (var i = 1; i <= (5 - count); i++)
                  Icon(
                    Icons.star_border_rounded,
                    color: theme.colorScheme.secondary.withAlpha(
                      isSelected ? 255 : 200,
                    ),
                  ),
              ],
            ),
            Text(
              "Shops",
              style: isSelected
                  ? null
                  : TextStyle(color: theme.colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }
}
