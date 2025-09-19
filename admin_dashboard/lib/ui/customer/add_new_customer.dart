import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddNewCustomer extends StatelessWidget {
  const AddNewCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        spacing: 32,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go(Routes.customer);
                },
                child: Text(
                  "All customer list",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Add New Customer"),
              Spacer(),
            ],
          ),
          Text(
            "Add new customer",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Column(
            spacing: 16,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Shop Name",
                  hintText: "Enter shop name",
                ),
              ),

              // Shop Address
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Shop Address",
                        hintText: "Enter shop address",
                      ),
                    ),
                  ),

                  // Pin Code
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Pin Code",
                        hintText: "Enter shop address pin code",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              // Contact Number
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Contact Number",
                        hintText: "Enter your mobile number",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),

                  // Email
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter shop email address",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),

              // Aadhaar Number
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Aadhaar Number",
                        hintText: "Enter aadhaar number",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  // PAN Number
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "PAN Number",
                        hintText: "Enter PAN number",
                      ),
                    ),
                  ),
                ],
              ),

              // Location
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Location",
                        hintText: "Enter shop location",
                      ),
                    ),
                  ),

                  // Area
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Area",
                        hintText: "Enter shop area",
                      ),
                    ),
                  ),
                ],
              ),

              // GST
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "GST",
                        hintText: "Enter your GST number",
                      ),
                    ),
                  ),

                  // Shop Logo
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Shop Logo",
                              textAlign: TextAlign.left,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSecondary,
                              ),
                            ),
                            Text(
                              "Upload shop logo",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.file_upload_outlined),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              BlueBorderButtons(
                title: "             Create New Customer             ",
                onClick: () {
                  //TODO
                  showSuccessDialog(context);
                },
                invert: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 586,
            height: 244,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  width: 100,
                  height: 100,
                  image: AssetImage("assets/images/green_tick.png"),
                ),
                Text(
                  "New customer added successfully",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                BlueBorderButtons(
                  title: "            Done            ",
                  onClick: () {
                    //TODO:
                    Navigator.of(context).pop();
                  },
                  invert: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
