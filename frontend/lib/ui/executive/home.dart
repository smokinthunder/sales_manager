import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sales_manager/ui/theme.dart';

class ExecutiveHome extends StatefulWidget {
  const ExecutiveHome({super.key});

  @override
  State<ExecutiveHome> createState() => _ExecutiveHomeState();
}

class _ExecutiveHomeState extends State<ExecutiveHome> {
  bool isSpecialRouteExpanded = false;
  bool isViewAllExpanded = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Customers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Customers : 58", style: textTheme.headlineSmall),
              TextButton(
                onPressed: () {
                  //TODO: implement on pressed
                },
                child: Text(
                  "Add new customer",
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Today Route
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today Route", style: textTheme.bodyLarge),
              Text("17-05-2024", style: textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 8),

          // ExpansionTile for Special Route
          Card(
            color: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: _InputField(label: "Location", value: "Kochi"),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _InputField(label: "Area", value: "Kalamassery"),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text(
                    "Special route",

                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  initiallyExpanded: isSpecialRouteExpanded,
                  onExpansionChanged: (val) {
                    setState(() => isSpecialRouteExpanded = val);
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(
                                child: _InputField(
                                  label: "Shop Name",
                                  value: "New India Traders",
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _InputField(
                                  label: "Location",
                                  value: "Kalamassery",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Expanded(
                                child: _InputField(
                                  label: "Area",
                                  value: "Manalimukku",
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _InputField(
                                  label: "Contact No",
                                  value: "+91 9821241890",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Top Customers
          Text("Top Customers", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            mainAxisSpacing: 12,
            children: const [
              _CustomerCard(
                name: "S K Steels",
                location: "Kochi",
                phone: "+91 8432518902",
                value: "2500",
              ),
              _CustomerCard(
                name: "M K Enterprises",
                location: "Ernakulam",
                phone: "+91 8432518902",
                value: "2400",
              ),
              _CustomerCard(
                name: "Athira Metals",
                location: "Aluva",
                phone: "+91 8432518902",
                value: "2300",
              ),
              _CustomerCard(
                name: "SAM Traders",
                location: "Vyttila",
                phone: "+91 8432518902",
                value: "1200",
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ExpansionTile for View All
          ExpansionTile(
            title: SizedBox(
              width: double.infinity,
              child: const Text(
                "View all",
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.blue),
              ),
            ),
            initiallyExpanded: isViewAllExpanded,
            onExpansionChanged: (val) {
              setState(() => isViewAllExpanded = val);
            },
            children: [
              //TODO: Replace with dynamic data, griedview like above
              _CustomerCard(
                name: "Athira Metals",
                location: "Aluva",
                phone: "+91 8432518902",
                value: "2300",
              ),
              _CustomerCard(
                name: "SAM Traders",
                location: "Vyttila",
                phone: "+91 8432518902",
                value: "1200",
              ),
            ],
          ),
          CategoryScroll(),
        ],
      ),
    );
  }
}

//// Reusable Widgets //////

class _InputField extends StatelessWidget {
  final String label;
  final String value;
  const _InputField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.tertiary),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final String name;
  final String location;
  final String phone;
  final String value;
  const _CustomerCard({
    required this.name,
    required this.location,
    required this.phone,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.bodyLarge),
            Text(location, style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: 4),
            Text(phone, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.blue),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScroll extends StatefulWidget {
  const CategoryScroll({super.key});

  @override
  State<CategoryScroll> createState() => _CategoryScrollState();
}

class _CategoryScrollState extends State<CategoryScroll> {
  final List<String> categories = [
    "All",
    "Technology",
    "Science",
    "Business",
    "Art",
    "Sports",
    "Health",
    "Music",
    "Travel",
  ];

  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return TextButton(
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected ? AppColors.blue : AppColors.grey,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              );
            },
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                "Bindu metals",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                "kalamassery",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey[300], thickness: 1, height: 1),
        ),
      ],
    );
  }
}
