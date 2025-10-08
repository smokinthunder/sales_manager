import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_manager/config/providers/login_message_provider.dart';
import 'package:sales_manager/ui/auth/viewmodel/auth_viewmodel.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste operation
      _handlePaste(value, index);
    } else if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      }
    }
  }

  void _handlePaste(String pastedText, int startIndex) {
    // Remove non-numeric characters
    String numericOnly = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Fill the OTP fields starting from the current index
    for (int i = 0; i < numericOnly.length && (startIndex + i) < 6; i++) {
      otpControllers[startIndex + i].text = numericOnly[i];
    }
    
    // Move focus to the next empty field or the last field
    int nextIndex = (startIndex + numericOnly.length).clamp(0, 5);
    if (nextIndex < 6) {
      focusNodes[nextIndex].requestFocus();
    }
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (otpControllers[index].text.isEmpty && index > 0) {
          // Move to previous field and clear it
          focusNodes[index - 1].requestFocus();
          otpControllers[index - 1].clear();
        } else if (otpControllers[index].text.isNotEmpty) {
          // Clear current field
          otpControllers[index].clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((val) => val?.isLoading == true),
    );

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          ref.read(loginMessageProvider.notifier).state =
              'Authentication successful';
        },
        error: (error, st) {
          showSnackBar(context, error.toString().split(":").last, true);
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
                            "assets/images/otp.png",
                            height: 180,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Title
                        const Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Enter the OTP sent to +91 ${widget.phoneNumber}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),

                        // OTP input fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 55,
                              child: KeyboardListener(
                                focusNode: FocusNode(),
                                onKeyEvent: (event) => _onKeyEvent(event, index),
                                child: TextField(
                                  controller: otpControllers[index],
                                  focusNode: focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (value) => _onOtpChanged(value, index),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        // Resend text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn’t you receive the OTP? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .generateOtp(
                                      phoneNumber: widget.phoneNumber,
                                    );
                                showSnackBar(context, "OTP Resent");
                              },
                              child: const Text(
                                "Resend OTP",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          var otpValue = "";
                          for (var otpController in otpControllers) {
                            otpValue = otpValue + otpController.text;
                          }
                          await ref
                              .read(authViewModelProvider.notifier)
                              .verifyOtp(
                                phoneNumber: widget.phoneNumber,
                                otp: otpValue,
                              );
                          await ref
                              .read(authViewModelProvider.notifier)
                              .getUser();
                        },
                        child: const Text("Verify"),
                      ),
                    ),
                  ), // Verify button
                ],
              ),
            ),
    );
  }
}
