import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String accountType = "Executive";

  // final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    child: Image.asset("assets/images/login.png", height: 180),
                  ),
                  const SizedBox(height: 30),

                  // Title
                  const Text(
                    "Login to your account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  onPressed: () {
                    //TODO: Handle login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 32, 129, 191),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
