import 'package:admin_dashboard/viewmodel/auth_viewmodel.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isObscuredPassword = true;
  var isObscuredConfirm = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
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
                      "Reset Password",
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff2c2c2c),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    Text(
                      "Enter the reset token from your email/terminal and your new password.",
                      style: textTheme.bodyLarge?.copyWith(
                        color: Color(0xff6c6c6c),
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Reset Token field
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.key_outlined,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                        Text("Reset Token"),
                      ],
                    ),
                    TextFormField(
                      controller: _tokenController,
                      decoration: InputDecoration(
                        hintText: "Enter reset token",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the reset token';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    
                    // New Password field
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                        Text("New Password"),
                      ],
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: isObscuredPassword,
                      decoration: InputDecoration(
                        hintText: "***************",
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            isObscuredPassword = !isObscuredPassword;
                          }),
                          child: Icon(
                            isObscuredPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    SizedBox(height: 16),
                    
                    // Password requirements
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Password must contain:",
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text("• At least 8 characters", style: textTheme.bodySmall),
                          Text("• One uppercase letter", style: textTheme.bodySmall),
                          Text("• One lowercase letter", style: textTheme.bodySmall),
                          Text("• One number", style: textTheme.bodySmall),
                          Text("• One special character", style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Confirm Password field
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                        Text("Confirm Password"),
                      ],
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: isObscuredConfirm,
                      decoration: InputDecoration(
                        hintText: "***************",
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            isObscuredConfirm = !isObscuredConfirm;
                          }),
                          child: Icon(
                            isObscuredConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    
                    // Success/Error message
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(passwordResetViewModelProvider);
                        
                        ref.listen<PasswordResetState>(
                          passwordResetViewModelProvider,
                          (previous, next) {
                            if (next is PasswordResetSuccess) {
                              // Navigate back to login on success
                              Future.delayed(Duration(seconds: 2), () {
                                if (mounted) {
                                  context.go('/');
                                }
                              });
                            }
                          },
                        );
                        
                        if (state is PasswordResetSuccess) {
                          return Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "${state.message}\nRedirecting to login...",
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: Colors.green.shade900,
                                    ),
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
                                        .resetPassword(
                                          _tokenController.text.trim(),
                                          _passwordController.text,
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
                                  isLoading ? "Resetting..." : "Reset Password",
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
