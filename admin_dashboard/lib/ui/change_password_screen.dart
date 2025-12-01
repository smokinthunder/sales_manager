import 'package:admin_dashboard/viewmodel/auth_viewmodel.dart';
import 'package:admin_dashboard/domain/models/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isObscuredCurrent = true;
  var isObscuredNew = true;
  var isObscuredConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                    // Current Password field
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                        Text("Current Password"),
                      ],
                    ),
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: isObscuredCurrent,
                      decoration: InputDecoration(
                        hintText: "***************",
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            isObscuredCurrent = !isObscuredCurrent;
                          }),
                          child: Icon(
                            isObscuredCurrent
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Color(0xff6c6c6c),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
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
                      controller: _newPasswordController,
                      obscureText: isObscuredNew,
                      decoration: InputDecoration(
                        hintText: "***************",
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            isObscuredNew = !isObscuredNew;
                          }),
                          child: Icon(
                            isObscuredNew
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
                        Text("Confirm New Password"),
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
                          return 'Please confirm your new password';
                        }
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    
                    // Success/Error message
                    Consumer(
                      builder: (context, ref, child) {
                        final state = ref.watch(passwordChangeViewModelProvider);
                        
                        ref.listen<PasswordChangeState>(
                          passwordChangeViewModelProvider,
                          (previous, next) {
                            if (next is PasswordChangeSuccess) {
                              // Show success and navigate back
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(next.message),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Future.delayed(Duration(seconds: 1), () {
                                if (mounted) {
                                  context.pop();
                                }
                              });
                            }
                          },
                        );
                        
                        if (state is PasswordChangeError) {
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
                        final state = ref.watch(passwordChangeViewModelProvider);
                        final authState = ref.watch(authViewModelProvider);
                        final isLoading = state is PasswordChangeLoading;
                        
                        return InkWell(
                          onTap: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    final accessToken = ref.read(authViewModelProvider.notifier).accessToken;
                                    if (accessToken != null) {
                                      await ref
                                          .read(passwordChangeViewModelProvider.notifier)
                                          .changePassword(
                                            _currentPasswordController.text,
                                            _newPasswordController.text,
                                            accessToken,
                                          );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Please login first'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
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
                                  isLoading ? "Changing..." : "Change Password",
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
