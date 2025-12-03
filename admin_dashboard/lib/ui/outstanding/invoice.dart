import 'package:admin_dashboard/domain/models/outstanding/outstanding_status.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  OutstandingStatus status = OutstandingStatus.current;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
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
              TextButton(
                onPressed: () {
                  context.go(Routes.outstanding);
                },
                child: Text(
                  "Outstanding",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Invoice"),
              Spacer(),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: OutstandingStatus.values
                  .map(
                    (e) => Flexible(
                      flex: status == e ? 2 : 1,
                      child: InkWell(
                        onTap: () => setState(() => status = e),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: status == e ? e.color : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.title,
                            style: TextStyle(
                              color: status == e
                                  ? Colors.black
                                  : theme.colorScheme.tertiary,
                              fontWeight: status == e
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Text(
            "Recent Bill",
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          InvoiceWidget(initiallyExpanded: true),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  //TODO
                },
                child: Text('View more'),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  //TODO
                },
                child: Row(
                  children: [
                    Icon(Icons.file_download_outlined),
                    Text("  Download Report"),
                  ],
                ),
              ),
            ],
          ),

          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Old Bills",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              InvoiceWidget(),
              InvoiceWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class InvoiceWidget extends StatelessWidget {
  const InvoiceWidget({super.key, this.initiallyExpanded = false});
  final bool initiallyExpanded;
  //TODO: data binding...

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.tertiary),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text("INVOICE -3495873", style: theme.textTheme.bodyLarge),
        shape: RoundedRectangleBorder(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(theme, "Shop Name", "SM Electronics"),
                _buildText(theme, "Address", "23, MG Road, Kochi"),
                Row(
                  children: [
                    _buildText(theme, "Phone", "+91 3439458748 |"),
                    _buildText(theme, "Email", "brightx@gmail.com"),
                  ],
                ),
                _buildText(theme, "GSTIN", "32ABCDE1234F1Z5"),
                Divider(color: theme.colorScheme.tertiary),
                SizedBox(height: 32),
                Text(
                  "Itemized Bill",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
                Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.tertiary,
                            width: 1,
                          ),
                        ),
                      ),
                      children: [
                        _buildTitleText(theme, "Sl. No"),
                        _buildTitleText(theme, "Description"),
                        _buildTitleText(theme, "Qty"),
                        _buildTitleText(theme, "Unit Price (₹)"),
                        _buildTitleText(theme, "Total (₹)"),
                      ],
                    ),
                    ...List.generate(
                      3,
                      (index) => TableRow(
                        children: [
                          _buildTableText(theme, "${index + 1}"),
                          _buildTableText(theme, "LED TV 32 inch"),
                          _buildTableText(theme, "1"),
                          _buildTableText(theme, "15000"),
                          _buildTableText(theme, "15000"),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(color: theme.colorScheme.tertiary),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Payment Details",
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        _buildText(
                          theme,
                          "Pending Balance",
                          "637.2",
                          keepSame: true,
                        ),
                        _buildText(
                          theme,
                          "Amount Paid",
                          "4177.2",
                          keepSame: true,
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildText(theme, "Subtotal", "3540", keepSame: true),
                        _buildText(theme, "GST (18%)", "637.2", keepSame: true),
                        _buildText(
                          theme,
                          "Grand Total",
                          "4177.2",
                          keepSame: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildTableText(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0).copyWith(left: 8),
      child: Text(text),
    );
  }

  Padding _buildTitleText(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: theme.textTheme.bodyLarge),
    );
  }

  Widget _buildText(
    ThemeData theme,
    String title,
    String value, {
    bool keepSame = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title\t\t:\t\t ",
              style: theme.textTheme.bodyMedium,
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: keepSame ? null : theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
