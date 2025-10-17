import 'package:admin_dashboard/config/assets.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffe0e0e0),
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                Spacer(),
                Container(
                  constraints: BoxConstraints(maxWidth: 430),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Assets.logo, width: 340),
                        Text(
                          "Welcome !!!",
                          style: textTheme.headlineLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          "LOGIN",
                          style: textTheme.headlineLarge?.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2c2c2c),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.email_outlined,
                                color: Color(0xff6c6c6c),
                              ),
                            ),
                            Text("Email"),
                          ],
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 430),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "example123@gmail.com",
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.lock_outline,
                                color: Color(0xff6c6c6c),
                              ),
                            ),
                            Text("Password"),
                          ],
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 430),
                          child: TextField(
                            obscureText: isObscured,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "***************",
                              suffixIcon: InkWell(
                                onTap: () => setState(() {
                                  isObscured = !isObscured;
                                }),
                                child: Icon(
                                  isObscured
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Color(0xff6c6c6c),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) {}),
                            Text("Remember Me"),
                            Spacer(),
                            Text("Forgot Password?"),
                          ],
                        ),
                        SizedBox(height: 48),
                        InkWell(
                          onTap: () {
                            //TODO: Implement Login Functionality
                            context.go(Routes.dashboard);
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 430,
                              minHeight: 48,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                if (width > 1054)
                  Image.asset(Assets.loginPattern, fit: BoxFit.fitHeight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
