import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/domain/models/user/user.dart';

class ExecutiveProfile extends ConsumerStatefulWidget {
  const ExecutiveProfile({super.key});

  @override
  ConsumerState<ExecutiveProfile> createState() => _ExecutiveProfileState();
}

class _ExecutiveProfileState extends ConsumerState<ExecutiveProfile> {
  AppUser? user;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  didChangeDependencies() {
    user = ref.watch(currentUserNotifierProvider);
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
    emailController.text = user?.email ?? "";
    phoneController.text = user?.phoneNumber ?? "";
    locationController.text = user?.location ?? "";
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Container(height: 160, color: theme.colorScheme.primary),
        SingleChildScrollView(
          child: Column(
            children: [
              // Top Section with background
              Column(
                children: [
                  SizedBox(height: 50),
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 85,
                      backgroundImage: NetworkImage(
                        user?.pictureUrl ??
                            "https://www.gravatar.com/avatar/placeholder",
                      ),
                      //TODO: Clean up above line
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      //TODO: remove this edit and implement in image or implement here
                    },
                    child: Text(
                      "Edit",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Form Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildTextField("First Name", firstNameController),
                    _buildTextField("Last Name", lastNameController),
                    _buildTextField("E-mail Address", emailController),
                    _buildTextField("Phone Number", phoneController),
                    _buildTextField("Location", locationController),

                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        //TODO: implement logout
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: const [
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.logout, color: Colors.blue, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -60,
          top: 0,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff1479ba),
            ),
          ),
        ),
        Positioned(
          left: -15,
          top: 100,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff1479ba),
            ),
          ),
        ),
        Positioned(
          right: 130,
          top: 5,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff1479ba),
            ),
          ),
        ),
        Positioned(
          left: 40,
          top: 5,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff1479ba),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, hintText: "Enter $label"),
      ),
    );
  }
}
