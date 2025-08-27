import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/route_paths.dart';

class AddNewShopScreen extends StatelessWidget {
  const AddNewShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Shop"),
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
            SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter your customer details",
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),

                  const SizedBox(height: 16),

                  // Shop Name
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "All fields are required.",
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                  Text("Use the above thing or do it like below"),
                  TextField(
                    decoration: InputDecoration(
                      errorText: "All fields are required",
                      labelText: "Shop Name",
                      hintText: "Enter shop name",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Shop Address
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Shop Address",
                      hintText: "Enter shop address",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pin Code
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Pin Code",
                      hintText: "Enter shop address pin code",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Contact Number
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      hintText: "Enter your mobile number",
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter shop email address",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Aadhaar Number
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Aadhaar Number",
                      hintText: "Enter aadhaar number",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // PAN Number
                  TextField(
                    decoration: InputDecoration(
                      labelText: "PAN Number",
                      hintText: "Enter PAN number",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Location",
                      hintText: "Enter shop location",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Area
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Area",
                      hintText: "Enter shop area",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // GST
                  TextField(
                    decoration: InputDecoration(
                      labelText: "GST",
                      hintText: "Enter your GST number",
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Shop Logo
                  Row(
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Create Button
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //TODO: write proper code
                    context.go(RoutePaths.waitForApproval);
                  },
                  child: const Text("Create New Customer"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
