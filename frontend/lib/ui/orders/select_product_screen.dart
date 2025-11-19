import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/widgets/drop_down_menu.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Product"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        spacing: 6,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("kevin Hardwares", style: textTheme.bodyLarge),
                          Text("Fort Kochi, Kochi", style: textTheme.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage("TODO"),

                          //TODO: Clean up above line
                        ),
                      ),
                    ],
                  ),
                  Text("Search", style: textTheme.bodyLarge),
                  Row(
                    spacing: 12,
                    children: [
                      Flexible(
                        flex: 5,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search name product",
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.tertiary.withAlpha(50),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            suffixIcon: Icon(
                              size: 32,
                              Icons.search,
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: CustomDropDownMenu(
                          hintText: "Sort by",
                          dropdownMenuEntries: [],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text("Add to Cart", style: textTheme.bodyLarge),
                      Spacer(),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(child: Icon(Icons.shopping_cart)),
                          Positioned(
                            top: -12,
                            right: 5,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.onPrimary,
                              ),
                              child: Text(
                                "2",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ProductCard(isSelected: false),
                  ProductCard(isSelected: true),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //TODO:
                    context.go(RoutePaths.selectProducts);
                  },
                  child: const Text("Continue"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 216,
      width: 120,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.grey : Colors.black,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Text("Product Name", textAlign: TextAlign.center),
          Divider(),
          Text("\$870"),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : Color(0xff484c52),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isSelected ? "Add to Cart" : "Remove",
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
