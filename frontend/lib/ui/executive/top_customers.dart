import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/domain/models/shops/shop.dart';
import 'package:sales_manager/routing/routes.dart';

///Provide sorted list for this widget
class TopCustomersScreen extends StatelessWidget {
  const TopCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Customers"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.go(AppRoutes.executiveHome);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: PaginatedList(items: testShops + testShops + testShops),
      ),
    );
  }
}

class PaginatedList extends StatefulWidget {
  final List<Shop> items;
  const PaginatedList({super.key, required this.items});

  @override
  State<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  final int itemsPerPage = 7;
  late final int totalPages;
  late final PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    totalPages = (widget.items.length / itemsPerPage).ceil();
    _pageController = PageController();
  }

  List<Shop> getPageItems(int pageIndex) {
    final start = pageIndex * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, widget.items.length);
    return widget.items.sublist(start, end);
  }

  Widget _buildNavButton({
    required bool enabled,
    required VoidCallback? onTap,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: enabled ? color : color.withAlpha(128),
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Main paged list
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: (index) => setState(() => currentPage = index),
            itemBuilder: (context, pageIndex) {
              final pageItems = getPageItems(pageIndex);
              return ListView.separated(
                itemCount: pageItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    // TODO: implement navigation
                  },
                  child: ShopCard(shop: pageItems[index]),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              enabled: currentPage > 0,
              onTap: () => _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              icon: Icons.arrow_back_ios_new,
              color: colors.primary,
              iconColor: colors.onPrimary,
            ),
            const SizedBox(width: 16),
            _buildNavButton(
              enabled: currentPage < totalPages - 1,
              onTap: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              icon: Icons.arrow_forward_ios,
              color: colors.primary,
              iconColor: colors.onPrimary,
            ),
          ],
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

class ShopCard extends StatelessWidget {
  final Shop shop;
  const ShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage(shop.logoUrl),
              //TODO: Clean up above line
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shop.name, style: textTheme.bodyLarge),
              Text(shop.location, style: textTheme.bodySmall),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(shop.phoneNumber, style: textTheme.bodySmall),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              shop.points.toString(),
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
