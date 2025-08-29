import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager/routing/route_paths.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({super.key});

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Request"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: PaginatedList(
          items: [
            ShopArrovalRequest(
              shopName: "Fresh Mart",
              executiveName: "John Doe",
              location: "Downtown",
              requestTime: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            ShopArrovalRequest(
              shopName: "Green Grocers",
              executiveName: "Jane Smith",
              location: "Uptown",
              requestTime: DateTime.now().subtract(
                const Duration(days: 1, hours: 3),
              ),
            ),
            ShopArrovalRequest(
              shopName: "Super Foods",
              executiveName: "Alex Johnson",
              location: "Midtown",
              requestTime: DateTime.now().subtract(const Duration(hours: 5)),
            ),
            ShopArrovalRequest(
              shopName: "Daily Needs",
              executiveName: "Emily Clark",
              location: "East Side",
              requestTime: DateTime.now().subtract(const Duration(days: 2)),
            ),
            ShopArrovalRequest(
              shopName: "Market Hub",
              executiveName: "Michael Lee",
              location: "West End",
              requestTime: DateTime.now().subtract(const Duration(hours: 8)),
            ),
            ShopArrovalRequest(
              shopName: "Shop & Save",
              executiveName: "Sarah Kim",
              location: "South Town",
              requestTime: DateTime.now().subtract(
                const Duration(days: 1, hours: 6),
              ),
            ),
            ShopArrovalRequest(
              shopName: "Urban Mart",
              executiveName: "David Brown",
              location: "Central City",
              requestTime: DateTime.now().subtract(const Duration(hours: 10)),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginatedList extends StatefulWidget {
  final List<ShopArrovalRequest> items;
  const PaginatedList({super.key, required this.items});

  @override
  State<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  final int itemsPerPage = 6;
  late final int totalPages;
  late final PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    totalPages = (widget.items.length / itemsPerPage).ceil();
    _pageController = PageController();
  }

  List<ShopArrovalRequest> getPageItems(int pageIndex) {
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
                    context.push(RoutePaths.executiveShopDetails);
                  },
                  child: RequestCard(
                    requests: pageItems[index],
                    onApprove: () {
                      //TODO: implement approve
                    },
                    onReject: () {
                      //TODO: implement delete
                    },
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Navigation buttons
        if (itemsPerPage < widget.items.length)
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

class RequestCard extends StatelessWidget {
  final ShopArrovalRequest requests;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  const RequestCard({
    super.key,
    required this.requests,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(requests.shopName, style: textTheme.bodyLarge),
                Text(requests.location, style: textTheme.labelLarge),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    requests.executiveName,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  "Date: ${DateFormat("dd-MM-yyyy | hh:mm a").format(requests.requestTime)}",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                InkWell(
                  onTap: onApprove,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Approve",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onReject,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.primary),
                    ),
                    child: Text(
                      "Reject",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Modify or rework data classes to the requirements
class ShopArrovalRequest {
  final String shopName;
  final String executiveName;
  final String location;
  final DateTime requestTime;

  ShopArrovalRequest({
    required this.shopName,
    required this.executiveName,
    required this.location,
    required this.requestTime,
  });
}
