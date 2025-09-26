import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/customer/add_new_customer.dart';
import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:admin_dashboard/ui/widgets/dropdownmenu.dart';
import 'package:admin_dashboard/ui/widgets/title_and_value_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AssignSpecialRoutes extends StatelessWidget {
  const AssignSpecialRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableTitle = theme.textTheme.bodyLarge;
    final tableText = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.tertiary,
    );
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 32,
        children: [
          Row(
            spacing: 32,
            children: [
              TitleAndValueContainer(
                title: "Total Executives",
                count: "100",
                width: 200,
              ),
              TitleAndValueContainer(
                title: "New Executives",
                count: "15",
                width: 200,
              ),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search by executive",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.executive);
                },
                child: Text(
                  "Total Executive",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Assign special route", style: theme.textTheme.bodyLarge),
              Spacer(),
            ],
          ),
          Center(child: Text("Assign route", style: theme.textTheme.bodyLarge)),
          Row(
            spacing: 16,
            children: [
              Container(
                height: 164,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.tertiary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sales Executive"),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.person_outline_rounded),
                        ),
                        Text("Kiran BS", style: theme.textTheme.bodySmall),
                      ],
                    ),
                    SizedBox(height: 26),
                    Text(
                      "Area Manager",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Symbols.crown),
                        ),
                        Text("Kiran BS", style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  height: 164,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.tertiary),
                  ),
                  child: Column(
                    spacing: 32,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        spacing: 32,
                        children: [
                          Flexible(
                            child: CustomDropDownMenu(
                              hintText: "Select Location",
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: "Old", label: "Old"),
                                DropdownMenuEntry(
                                  value: "A-Z",
                                  label: "A-Z (Ascending)",
                                ),
                                DropdownMenuEntry(
                                  value: "Month",
                                  label: "Z-A (Descending)",
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: CustomDropDownMenu(
                              hintText: "Select Area",
                              dropdownMenuEntries: [
                                DropdownMenuEntry(value: "Old", label: "Old"),
                                DropdownMenuEntry(
                                  value: "A-Z",
                                  label: "A-Z (Ascending)",
                                ),
                                DropdownMenuEntry(
                                  value: "Month",
                                  label: "Z-A (Descending)",
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter Shop Name",
                              ),
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "mm/dd/yyyy",
                              ),
                            ),
                          ),
                        ],
                      ),
                      BlueBorderButtons(
                        invert: true,
                        title: "\t\t\t\t\t\t\tSubmit\t\t\t\t\t\t\t",
                        onClick: () {
                          //TODO
                          context.showSuccessDialog(
                            "Special route created successfully",
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text("Assign route history", style: theme.textTheme.bodyLarge),
          Table(
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                ),
                children: [
                  _buildTableTitle(tableTitle, "Area Manager"),
                  _buildTableTitle(tableTitle, "Executive"),
                  _buildTableTitle(tableTitle, "Location"),
                  _buildTableTitle(tableTitle, "Area"),
                  _buildTableTitle(tableTitle, "Shop Name"),
                  _buildTableTitle(tableTitle, "Date", atStart: true),
                ],
              ),
              //TODO:Write logic here
              ...testRoutes.map(
                (e) => _buildTableRow(theme, tableText, e, () {
                  showConfirmDialog(context, () {
                    //TODO : write delete logic here
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    ThemeData theme,
    TextStyle? tableText,
    SpecialRoute route,
    VoidCallback onDelete,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.surface, width: 2),
        ),
      ),
      children: [
        _buildTableChildText(tableText, route.areaManger),
        _buildTableChildText(tableText, route.executive),
        _buildTableChildText(tableText, route.location),
        _buildTableChildText(tableText, route.area),
        _buildTableChildText(tableText, route.shopName),
        Row(
          children: [
            _buildTableChildText(tableText, route.date),
            Spacer(),
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: InkWell(
                onTap: onDelete,
                child: Icon(
                  Icons.delete_outline_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Padding _buildTableChildText(TextStyle? theme, String title) => Padding(
    padding: const EdgeInsets.all(8.0).copyWith(bottom: 24),
    child: Text(title, textAlign: TextAlign.center, style: theme),
  );

  Padding _buildTableTitle(
    TextStyle? theme,
    String title, {
    bool atStart = false,
  }) => Padding(
    padding: const EdgeInsets.all(8.0).copyWith(bottom: 24),
    child: Text(
      title,
      textAlign: atStart ? TextAlign.start : TextAlign.center,
      style: theme,
    ),
  );

  void showConfirmDialog(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 470,
          height: 130,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 8,
            children: [
              Text("Delete", style: Theme.of(context).textTheme.bodyLarge),
              Text("Are you sure you want to delete this special route?"),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).maybePop();
                    },
                    child: Container(
                      width: 96,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Center(child: Text("Cancel")),
                    ),
                  ),
                  InkWell(
                    onTap: onDelete,
                    child: Container(
                      width: 96,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xffbe2121),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Center(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialRoute {
  final String areaManger;
  final String executive;
  final String location;
  final String area;
  final String shopName;
  final String date;
  const SpecialRoute({
    required this.area,
    required this.areaManger,
    required this.executive,
    required this.location,
    required this.shopName,
    required this.date,
  });
}

final testRoutes = [
  SpecialRoute(
    areaManger: "Ravi Kumar",
    executive: "Kiran BS",
    location: "Bangalore",
    area: "Indiranagar",
    shopName: "SuperMart",
    date: "06/10/2024",
  ),
  SpecialRoute(
    areaManger: "Anita Sharma",
    executive: "Priya Singh",
    location: "Chennai",
    area: "T Nagar",
    shopName: "Fresh Foods",
    date: "06/09/2024",
  ),
  SpecialRoute(
    areaManger: "Sunil Mehta",
    executive: "Rahul Dev",
    location: "Hyderabad",
    area: "Banjara Hills",
    shopName: "Daily Needs",
    date: "06/08/2024",
  ),
  SpecialRoute(
    areaManger: "Meera Joshi",
    executive: "Sneha Rao",
    location: "Mumbai",
    area: "Andheri",
    shopName: "City Grocers",
    date: "06/07/2024",
  ),
];
