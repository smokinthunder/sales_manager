import 'package:admin_dashboard/viewmodel/auth_viewmodel.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Color(0xffe0e0e0),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back),
                    ),
                    SizedBox(height: 24),
                    
                    // Title
                    Text(
                      "Forgot Password",
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2c2c2c),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    Text(
                      "Enter your email address and we'll send you a password reset token.",
                      style: textTheme.bodyLarge?.copyWith(
                        color: Color(0xff6c6c6c),
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Email field
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
                    TextFormField(
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
                    SizedBox(height: 24),
                    
                    // Success/Error message
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(passwordResetViewModelProvider);
                        
                        if (state is PasswordResetSuccess) {
                          return Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.green),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.message,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: Colors.green.shade900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Check the backend terminal/logs for the reset token.",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.green.shade700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (state is PasswordResetError) {
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
                                    state.message,
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
                    
                    // Submit Button
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(passwordResetViewModelProvider);
                        final isLoading = state is PasswordResetLoading;
                        
                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    await ref
                                        .read(passwordResetViewModelProvider.notifier)
                                        .requestPasswordReset(
                                          _emailController.text.trim(),
                                        );
                                  }
                                },
                          child: Container(
                            constraints: BoxConstraints(
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
                                  isLoading ? "Sending..." : "Send Reset Token",
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
                    SizedBox(height: 24),
                    
                    // Reset Password Link (if token received)
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(passwordResetViewModelProvider);
                        
                        if (state is PasswordResetSuccess) {
                          return Center(
                            child: TextButton(
                              onPressed: () {
                                context.push('/reset-password');
                              },
                              child: Text("I have a reset token"),
                            ),
                          );
                        }
                        
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
