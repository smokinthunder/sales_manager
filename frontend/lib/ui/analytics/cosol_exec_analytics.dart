import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/ui/analytics/widgets/best_selling_product.dart';
import 'package:sales_manager/ui/analytics/widgets/sales_report.dart';
import 'package:sales_manager/ui/analytics/widgets/switch_row.dart';
import 'package:sales_manager/ui/common/widgets/drop_down_menu.dart';

class ConsolidatedAnalyticsScreen extends ConsumerStatefulWidget {
  const ConsolidatedAnalyticsScreen({super.key});

  @override
  ConsumerState<ConsolidatedAnalyticsScreen> createState() =>
      _ConsolidatedAnalyticsScreenState();
}

class _ConsolidatedAnalyticsScreenState
    extends ConsumerState<ConsolidatedAnalyticsScreen> {
  bool showTopTen = false;
  bool showSalesReport = false;
  bool showBestSelling = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.read(currentUserNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Analytics"),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (user!.type == UserType.areaManager)
                              ? "Select Executive"
                              : "Select Items",
                          style: textTheme.bodyLarge,
                        ),
                      ),
                      if (user!.type == UserType.areaManager)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomDropDownMenu(
                            hintText: "Akhil Dev",
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                value: "Akhil Dev",
                                label: "Akhil Dev",
                              ),
                              DropdownMenuEntry(
                                value: "John Doe",
                                label: "John Doe",
                              ),
                            ],
                          ),
                        ),
                      SwitchRow(
                        title: "TOP 10 Customer",
                        value: showTopTen,
                        onChanged: (value) => setState(() {
                          showTopTen = value;
                        }),
                      ),
                      SwitchRow(
                        title: "Best Selling Product",
                        value: showBestSelling,
                        onChanged: (value) => setState(() {
                          showBestSelling = value;
                        }),
                      ),
                      SwitchRow(
                        title: "Sales Report",
                        value: showSalesReport,
                        onChanged: (value) => setState(() {
                          showSalesReport = value;
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO
                    },
                    child: Text("Find Analytics"),
                  ),
                ),
                if (showTopTen)
                  TopTenCustomers(
                    customers: [
                      "Acme Corp",
                      "Beta Traders",
                      "Gamma Industries",
                      "Delta Enterprises",
                      "Epsilon Ltd",
                      "Zeta Solutions",
                      "Eta Distributors",
                      "Theta Group",
                      "Iota Holdings",
                      "Kappa Partners",
                    ],
                  ),
                if (showBestSelling)
                  BestSellingProduct(
                    productList: [
                      ProductSaleMap("ELBOW SOCKET 90", 60, Color(0xff3977e6)),
                      ProductSaleMap(
                        "RAIN WATER CHAMBER",
                        30,
                        Color(0xfff3a100),
                      ),
                      ProductSaleMap("RAIN WATER PIPES", 10, Color(0xff449f40)),
                    ],
                  ),
                if (showSalesReport)
                  SalesReport(
                    salesData: const [
                      SalesReportDataMap('Jan', 5),
                      SalesReportDataMap('Feb', 7.5),
                      SalesReportDataMap('Mar', 10),
                      SalesReportDataMap('Apr', 8),
                      SalesReportDataMap('May', 15),
                      SalesReportDataMap('Jun', 10),
                      SalesReportDataMap('Jul', 8),
                      SalesReportDataMap('Aug', 4),
                      SalesReportDataMap('Sep', 5),
                      SalesReportDataMap('Oct', 8),
                      SalesReportDataMap('Nov', 10),
                      SalesReportDataMap('Dec', 4),
                    ],
                  ),
                TextButton(
                  onPressed: () {
                    //TODO
                  },
                  child: Row(
                    children: [
                      Text('Download Report '),
                      Icon(Icons.file_download_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopTenCustomers extends StatelessWidget {
  const TopTenCustomers({super.key, required this.customers});
  final List<String> customers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Top 10 Customers",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Wrap(
          children: customers
              .map(
                (e) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
