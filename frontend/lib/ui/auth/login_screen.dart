import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/routing/routes.dart';
import 'package:sales_manager/ui/auth/viewmodel/auth_viewmodel.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // String accountType = "Executive";

  // final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) async {
          context.go(AppRoutes.otp, extra: phoneController.text);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSnackBar(context, "OTP sent to ${phoneController.text}");
          });
        },
        error: (error, st) {
          showSnackBar(context, error.toString(), true);
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Top image
                        Center(
                          child: Image.asset(
                            "assets/images/login.png",
                            height: 180,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Title
                        const Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Welcome back! Please enter your details.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),

                        // // Select account type
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Select account type",
                        //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        //   ),
                        // ),
                        // const Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Mandatory",
                        //     style: TextStyle(color: Colors.grey, fontSize: 14),
                        //   ),
                        // ),
                        // const SizedBox(height: 10),

                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: RadioListTile(
                        //         contentPadding: EdgeInsets.zero,
                        //         title: const Text("Executive"),
                        //         value: "Executive",
                        //         groupValue: accountType,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             accountType = value!;
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: RadioListTile(
                        //         contentPadding: EdgeInsets.zero,
                        //         title: const Text("Area Manager"),
                        //         value: "Area Manager",
                        //         groupValue: accountType,
                        //         onChanged: (value) {
                        //           setState(() {
                        //             accountType = value!;
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 20),

                        // Username
                        // TextField(
                        //   controller: nameController,
                        //   decoration: const InputDecoration(
                        //     labelText: "User Name",
                        //     hintText: "Enter your name",
                        //     border: OutlineInputBorder(),
                        //   ),
                        // ),
                        // const SizedBox(height: 20),

                        // Phone number
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Mobile Number",
                            hintText: "Enter your mobile number",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "We will send you one-time password to your mobile number",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  // Login button
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await ref
                              .read(authViewModelProvider.notifier)
                              .sendOtp(phoneNumber: phoneController.text);
                        },
                        child: const Text("Login"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
