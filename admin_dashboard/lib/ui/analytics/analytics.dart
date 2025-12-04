import 'package:admin_dashboard/domain/models/analytics/shop_analytics.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/viewmodel/data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Analytics extends ConsumerStatefulWidget {
  const Analytics({super.key});

  @override
  ConsumerState<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends ConsumerState<Analytics> {
  int? selectedRating;
  String searchQuery = '';
  String sortOrder = 'New';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Fetch shop analytics with optional rating filter
    final analyticsAsync = ref.watch(
      shopAnalyticsSummaryProvider(
        minRating: selectedRating,
        maxRating: selectedRating,
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
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
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
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
                  hintText: sortOrder,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "New", label: "New"),
                    DropdownMenuEntry(value: "Old", label: "Old"),
                    DropdownMenuEntry(value: "A-Z", label: "A-Z (Ascending)"),
                    DropdownMenuEntry(
                      value: "Z-A",
                      label: "Z-A (Descending)",
                    ),
                  ],
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        sortOrder = value;
                      });
                    }
                  },
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
                  analyticsAsync.when(
                    data: (data) {
                      final summary = ShopAnalyticsSummary.fromJson(data);
                      final count = summary.getCountForRating(i);
                      return RatingCard(
                        count: i,
                        shopCount: count,
                        isSelected: selectedRating == i,
                        onTap: () {
                          setState(() {
                            selectedRating = selectedRating == i ? null : i;
                          });
                        },
                      );
                    },
                    loading: () => RatingCard(
                      count: i,
                      shopCount: 0,
                      isSelected: selectedRating == i,
                      onTap: () {
                        setState(() {
                          selectedRating = selectedRating == i ? null : i;
                        });
                      },
                    ),
                    error: (_, __) => RatingCard(
                      count: i,
                      shopCount: 0,
                      isSelected: selectedRating == i,
                      onTap: () {
                        setState(() {
                          selectedRating = selectedRating == i ? null : i;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          analyticsAsync.when(
            data: (data) {
              final summary = ShopAnalyticsSummary.fromJson(data);
              var shops = summary.shops;

              // Apply search filter
              if (searchQuery.isNotEmpty) {
                shops = shops
                    .where((shop) =>
                        shop.shopName.toLowerCase().contains(searchQuery))
                    .toList();
              }

              // Apply sorting
              switch (sortOrder) {
                case 'Old':
                  shops = shops.reversed.toList();
                  break;
                case 'A-Z':
                  shops.sort((a, b) => a.shopName.compareTo(b.shopName));
                  break;
                case 'Z-A':
                  shops.sort((a, b) => b.shopName.compareTo(a.shopName));
                  break;
                case 'New':
                default:
                  // Default order from backend
                  break;
              }

              // Empty state
              if (shops.isEmpty) {
                return SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 64,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'No shops found matching "$searchQuery"'
                              : selectedRating != null
                                  ? 'No shops with $selectedRating star rating'
                                  : 'No shop analytics available',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try adjusting your search'
                              : selectedRating != null
                                  ? 'Try selecting a different rating'
                                  : 'Shop analytics will appear here once available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SafePaginatedCardGrid(
                cards: shops
                    .map(
                      (shop) => ShopAnalyticsCardWidget(
                        shopData: shop,
                        onTap: () {
                          context.go('${Routes.shopAnalytics}/${shop.shopId}');
                        },
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => SizedBox(height: 400,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => SizedBox(
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Failed to load shop analytics',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(shopAnalyticsSummaryProvider);
                      },
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
  final Color? backgroundColor;

  const SafePaginatedCardGrid({
    super.key,
    required this.cards,
    this.cardWidth = 260,
    this.cardHeight = 220,
    this.spacing = 20,
    this.rowsPerPage = 4,
    this.backgroundColor,
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
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.backgroundColor?.withAlpha(48) ?? Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: LayoutBuilder(
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

          // Clamp currentPage to valid range (DIRECT MUTATION - working pattern)
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
      ),
    );
  }
}

class ShopAnalyticsCardWidget extends StatelessWidget {
  const ShopAnalyticsCardWidget({
    super.key,
    required this.shopData,
    required this.onTap,
  });

  final ShopAnalyticsCard shopData;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.business_outlined, color: theme.colorScheme.tertiary),
              Expanded(
                child: Text(
                  " ${shopData.shopName}",
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          if (shopData.territoryName != null)
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: theme.colorScheme.tertiary,
                  size: 16,
                ),
                Expanded(
                  child: Text(
                    " ${shopData.territoryName}",
                    style: theme.textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, color: theme.colorScheme.tertiary),
              Expanded(
                child: Text(
                  " ${shopData.executiveName ?? 'N/A'}",
                  style: theme.textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              for (var i = 0; i < shopData.rating; i++)
                Icon(Icons.star, color: Colors.amber, size: 16),
              for (var i = shopData.rating; i < 5; i++)
                Icon(Icons.star_border, color: Colors.grey, size: 16),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                color: Colors.green,
                size: 24,
              ),
              Text(
                " ${shopData.formattedSales}",
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Orders: ${shopData.totalOrders}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
          if (shopData.lastOrderDate != null)
            Text(
              'Last: ${shopData.formattedLastOrderDate}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.tertiary,
              ),
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
  final int shopCount;
  final bool isSelected;
  final VoidCallback onTap;
  const RatingCard({
    super.key,
    required this.count,
    required this.shopCount,
    required this.isSelected,
    required this.onTap,
  }) : assert(count <= 5 && count >= 0, "Count must be between 0 and 5");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            SizedBox(height: 4),
            Text(
              "$shopCount Shops",
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.tertiary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
