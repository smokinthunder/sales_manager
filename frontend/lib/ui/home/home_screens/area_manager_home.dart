import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sales_manager/config/providers/login_message_provider.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/ui/home/home_screens/viewmodel/home_screen_viewmodel.dart';
import 'package:sales_manager/ui/widgets/drop_down_menu.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class AreaManagerHome extends ConsumerStatefulWidget {
  const AreaManagerHome({super.key});

  @override
  ConsumerState<AreaManagerHome> createState() => _AreaManagerHomeState();
}

class _AreaManagerHomeState extends ConsumerState<AreaManagerHome> {
  bool _isMessageShown = false;
  ExecutiveTrackingData? currentTrackingDate = ExecutiveTrackingData(
    name: "name",
    shopName: "shopName",
    assignDate: DateTime.now(),
    lastVisitDate: DateTime.now(),
    photoUrl: "photoUrl",
    hasVisisted: false,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final loginMessage = ref.read(loginMessageProvider);

    if (!_isMessageShown && loginMessage != null) {
      _isMessageShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, loginMessage);
        ref.read(loginMessageProvider.notifier).state = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderTexts(),
          const SizedBox(height: 40),
          Text("Create Route", style: textTheme.bodyLarge),
          CreateRouteCard(),
          DailyExecutiveRoute(
            routeData: [
              ExecutiveRouteData('John Doe', 'ABC Plumbing', 'North Zone'),
              ExecutiveRouteData('Jane Smith', 'XYZ Hardware', 'East Zone'),
              ExecutiveRouteData(
                'Mike Johnson',
                'LMN Electricals',
                'South Zone',
              ),
              ExecutiveRouteData('John Doe', 'ABC Plumbing', 'North Zone'),
              ExecutiveRouteData('Jane Smith', 'XYZ Hardware', 'East Zone'),
              ExecutiveRouteData(
                'Mike Johnson',
                'LMN Electricals',
                'South Zone',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text("Track Executive", style: textTheme.bodyLarge),
          ),
          TrackExecutiveCard(),
          SizedBox(height: 10),
          if (currentTrackingDate != null)
            TrackingData(trackingData: currentTrackingDate),
          SizedBox(height: 20),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              context.push(RoutePaths.createTarget);
              //TODO
            },
            child: Row(
              spacing: 10,
              children: [
                Text("Create Target"),
                Icon(Icons.arrow_forward_ios_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackingData extends StatelessWidget {
  const TrackingData({super.key, required this.trackingData});
  final ExecutiveTrackingData? trackingData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSecondary,
    );
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Table(
            children: [
              TableRow(
                children: [
                  Text(
                    "Executive name",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Shop name",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Status",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      trackingData!.name.toString(),
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      trackingData!.shopName,
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      trackingData!.hasVisisted ? "Visited" : "Not visited",
                      style: textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorScheme.tertiary.withAlpha(118),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                width: trackingData!.hasVisisted ? double.infinity : 50,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorScheme.secondary.withAlpha(168),
                ),
              ),
              Positioned(
                top: 7,
                left: trackingData!.hasVisisted ? null : 45,
                right: trackingData!.hasVisisted ? 0 : null,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.tertiary),
                    color: colorScheme.secondary,
                  ),
                  child: Icon(Icons.directions_walk, size: 10),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Assign Date: ${DateFormat('dd-MM-yyyy').format(trackingData!.assignDate)}",
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Last Visit: ${DateFormat('dd-MM-yyyy').format(trackingData!.lastVisitDate)}",
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: trackingData!.hasVisisted
                    ? () {
                        //TODO
                      }
                    : null,
                child: Row(
                  children: [
                    Icon(Icons.photo_size_select_actual_outlined),
                    Text(" View Photo"),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              context.push(RoutePaths.viewExecutiveHistory);
              //TODO
            },
            child: Text(
              'View History',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyExecutiveRoute extends StatelessWidget {
  const DailyExecutiveRoute({super.key, required this.routeData});
  final List<ExecutiveRouteData> routeData;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final titleStyle = textTheme.labelLarge?.copyWith(
      color: colorScheme.onSecondary,
    );
    final contentStyle = textTheme.bodySmall;
    return ExpansionTile(
      title: Text("Today's List"),
      shape: RoundedRectangleBorder(),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            DateFormat('dd-MM-yyyy').format(DateTime.now()),
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Executive",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Location',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Area",
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            ...routeData.map(
              (e) => TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorScheme.tertiary),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(child: Text(e.name, style: contentStyle)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(child: Text(e.location, style: contentStyle)),
                  ),
                  ExpansionTile(
                    shape: RoundedRectangleBorder(),
                    dense: true,
                    tilePadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Text(e.area, style: contentStyle),
                    children: [Text(e.location, style: contentStyle)],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ExecutiveRouteData {
  final String name;
  final String location;
  final String area;
  const ExecutiveRouteData(this.name, this.location, this.area);
}

class ExecutiveTrackingData {
  final String name;
  final String shopName;
  final DateTime assignDate;
  final DateTime lastVisitDate;
  final String photoUrl;
  final bool hasVisisted;

  ExecutiveTrackingData({
    required this.name,
    required this.shopName,
    required this.assignDate,
    required this.lastVisitDate,
    required this.photoUrl,
    required this.hasVisisted,
  });
}

class HeaderTexts extends StatelessWidget {
  const HeaderTexts({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Total Executive : 12", style: textTheme.headlineSmall),
        Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              style: buttonStyle,
              onPressed: () {
                context.push(RoutePaths.addShop);
              },
              child: Text(
                "Add new customer",
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              style: buttonStyle,
              onPressed: () {
                //TODO:
                context.push(RoutePaths.pendingRequests);
              },
              child: Text(
                "Pending Requests",
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CreateRouteCard extends ConsumerStatefulWidget {
  const CreateRouteCard({super.key});

  @override
  ConsumerState<CreateRouteCard> createState() => _CreateRouteCardState();
}

class _CreateRouteCardState extends ConsumerState<CreateRouteCard> {
  String? selectedRoute;
  String? selectedExecutive;
  String? selectedShop;
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isLoading = ref.watch(
      routeCardViewModelProvider.select((val) => val?.isLoading == true),
    );
    return Card(
      color: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: ref
                      .watch(getAllRoutesProvider)
                      .when(
                        loading: () => const CustomDropDownMenu(
                          tinyTitle: true,
                          hintText: "...Loading Routes",
                          dropdownMenuEntries: [],
                          title: "Routes",
                        ),
                        error: (error, stackTrace) =>
                            Center(child: Text('Error: $error')),
                        data: (routes) => CustomDropDownMenu(
                          hintText: "Select Routes",
                          tinyTitle: true,
                          onSelected: (value) => setState(() {
                            selectedRoute = value;
                          }),
                          dropdownMenuEntries: [
                            ...routes.map(
                              (route) => DropdownMenuEntry(
                                value: route['route_id'],
                                label: route['name'],
                              ),
                            ),
                          ],
                          title: "Routes",
                        ),
                      ),
                ),
                Flexible(
                  child: ref
                      .watch(getAllSalesExecutivesProvider)
                      .when(
                        loading: () => const CustomDropDownMenu(
                          tinyTitle: true,
                          hintText: "...Loading Executives",
                          dropdownMenuEntries: [],
                          title: "Executives",
                        ),
                        error: (error, stackTrace) =>
                            Center(child: Text('Error: $error')),
                        data: (executives) => CustomDropDownMenu(
                          hintText: "Select Executive",
                          tinyTitle: true,
                          onSelected: (value) => setState(() {
                            selectedExecutive = value;
                          }),
                          dropdownMenuEntries: [
                            ...executives.map(
                              (executive) => DropdownMenuEntry(
                                value: executive['id'].toString(),
                                label: executive['name'],
                              ),
                            ),
                          ],
                          title: "Executives",
                        ),
                      ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: ref
                      .watch(getAllShopsProvider)
                      .when(
                        loading: () => const CustomDropDownMenu(
                          tinyTitle: true,
                          hintText: "...Loading Shops",
                          dropdownMenuEntries: [],
                          title: "Shops",
                        ),
                        error: (error, stackTrace) =>
                            Center(child: Text('Error: $error')),
                        data: (shops) => CustomDropDownMenu(
                          hintText: "Select Shop",
                          tinyTitle: true,
                          onSelected: (value) => setState(() {
                            selectedShop = value;
                          }),
                          dropdownMenuEntries: [
                            ...shops.map(
                              (executive) => DropdownMenuEntry(
                                value: executive['shop_id'],
                                label: executive['name'],
                              ),
                            ),
                          ],
                          title: "Shops",
                        ),
                      ),
                ),
                DateInputField(
                  controller: _dateController,
                  label: "Planned Date",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("selectedRoute: $selectedRoute");
                    print("selectedExecutive: $selectedExecutive");
                    print("selectedShop: $selectedShop");
                    print("Planned Date: ${_dateController.text}");
                    if (selectedRoute != null &&
                        selectedRoute!.isNotEmpty &&
                        selectedExecutive != null &&
                        selectedExecutive!.isNotEmpty &&
                        selectedShop != null &&
                        selectedShop!.isNotEmpty &&
                        _dateController.text.isNotEmpty) {
                      ref
                          .read(routeCardViewModelProvider.notifier)
                          .assignRoutes(
                            routeId: selectedRoute ?? "",
                            shopId: selectedShop ?? "",
                            salesExecutiveId: selectedExecutive ?? "",
                            plannedDate: _dateController.text,
                          );
                    }
                  },
                  child: isLoading ? Text("Submiting") : Text("Submit"),
                ),
                TextButton(
                  onPressed: () {
                    //TODO
                  },
                  child: Text('Add special route'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrackExecutiveCard extends StatelessWidget {
  const TrackExecutiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                Flexible(
                  child: CustomDropDownMenu(
                    hintText: "Executive list",
                    tinyTitle: true,
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'ABC Plumbing',
                        label: 'ABC Plumbing',
                      ),
                      DropdownMenuEntry(
                        value: 'XYZ Hardware',
                        label: 'XYZ Hardware',
                      ),
                      DropdownMenuEntry(
                        value: 'LMN Electricals',
                        label: 'LMN Electricals',
                      ),
                    ],
                    title: "Select executive to track",
                  ),
                ),
                Flexible(
                  child: CustomDropDownMenu(
                    tinyTitle: true,
                    hintText: "Shop name",
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'ABC Plumbing',
                        label: 'ABC Plumbing',
                      ),
                      DropdownMenuEntry(
                        value: 'XYZ Hardware',
                        label: 'XYZ Hardware',
                      ),
                      DropdownMenuEntry(
                        value: 'LMN Electricals',
                        label: 'LMN Electricals',
                      ),
                    ],
                    title: "Select a shop",
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                //TODO:
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom Date Input field
class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const DateInputField({
    super.key,
    required this.controller,
    this.label = "Date",
  });

  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  void _selectDate() async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      widget.controller.text = _dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(widget.label, style: textTheme.bodySmall),
          ),
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.tertiary),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              DateInputFormatter(), // custom formatter defined below
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.tertiary),
              ),
              hintText: 'yyyy-mm-dd',
              hintStyle: textTheme.labelLarge,
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_month, color: colorScheme.tertiary),
                onPressed: _selectDate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom formatter to automatically insert dashes for yyyy-mm-dd
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i == 3 || i == 5) && i != text.length - 1) {
        buffer.write('-');
      }
    }

    final String formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
