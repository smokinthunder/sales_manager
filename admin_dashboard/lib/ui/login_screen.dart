import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/viewmodel/auth_viewmodel.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var isObscured = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Image.asset(
                          'assets/images/company_logo.png',
                          width: 340,
                        ),
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
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "example123@gmail.com",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
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
                          child: TextFormField(
                            controller: _passwordController,
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
                            InkWell(
                              onTap: () {
                                // Navigate to forgot password screen
                                context.push('/forgot-password');
                              },
                              child: Text(
                                "Forgot Password?",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Error message display
                        Consumer(
                          builder: (context, ref, child) {
                            final authState = ref.watch(authViewModelProvider);
                            if (authState is AuthError) {
                              return Container(
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        authState.message,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: 24),
                        // Login Button
                        Consumer(
                          builder: (context, ref, child) {
                            final authState = ref.watch(authViewModelProvider);
                            final isLoading = authState is AuthLoading;

                            // Listen for authentication changes
                            ref.listen<AuthState>(
                              authViewModelProvider,
                              (previous, next) {
                                if (next is AuthAuthenticated) {
                                  // Navigate to dashboard on successful login
                                  context.go(Routes.dashboard);
                                }
                              },
                            );

                            return InkWell(
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        await ref
                                            .read(authViewModelProvider.notifier)
                                            .login(
                                              _emailController.text.trim(),
                                              _passwordController.text,
                                            );
                                      }
                                    },
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 430,
                                  minHeight: 48,
                                ),
                                decoration: BoxDecoration(
                                  color: isLoading
                                      ? colorScheme.primary.withOpacity(0.6)
                                      : colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading)
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            colorScheme.onPrimary,
                                          ),
                                        ),
                                      ),
                                    if (isLoading) SizedBox(width: 12),
                                    Text(
                                      isLoading ? "Logging in..." : "Login",
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),

                if (width > 1054)
                  Image.asset(
                    'assets/images/login_pattern.png',
                    fit: BoxFit.fitHeight,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
