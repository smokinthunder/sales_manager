import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/ui/customer/add_new_customer.dart';
import 'package:admin_dashboard/ui/customer/customer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddAreaManager extends StatelessWidget {
  const AddAreaManager({super.key});
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
                  context.go(Routes.areaManager);
                },
                child: Text(
                  "Area Manger",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ),
              Icon(Icons.chevron_right),
              Text("Add New Area Manager"),
              Spacer(),
            ],
          ),
          Text(
            "Add new Area Manager",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Column(
            spacing: 32,
            children: [
              // Shop Address
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "First Name",
                        hintText: "Enter area manager first name",
                      ),
                    ),
                  ),

                  // Pin Code
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        hintText: "Enter area manager last name",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              // Shop Address
              Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Address",
                        hintText: "Enter area manager address",
                      ),
                    ),
                  ),

                  // Pin Code
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Pin Code",
                        hintText: "Enter area manager pin code",
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
                        hintText: "Enter area manager contact number",
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),

                  // Email
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter area manager email address",
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
                        hintText: "Enter area manager's aadhaar number",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  // PAN Number
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "PAN Number",
                        hintText: "Enter area manager's PAN number",
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
                        hintText: "Enter area manager's location",
                      ),
                    ),
                  ),

                  // Area
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Area",
                        hintText: "Enter area manager's area",
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
                        labelText: "Date of Birth",
                        hintText: "dd/mm/yyyy",
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
                              "Photo",
                              textAlign: TextAlign.left,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSecondary,
                              ),
                            ),
                            Text(
                              "Upload photo",
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
                title:
                    "\t\t\t\t\t\t\t\t\t\t\t\t\t\tCreate New Area Manager\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                onClick: () {
                  //TODO
                  context.showSuccessDialog(
                    "New area manager added successfully",
                  );
                },
                invert: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
