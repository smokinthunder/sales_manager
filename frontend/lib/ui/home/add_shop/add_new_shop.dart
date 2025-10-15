import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_manager/config/providers/current_user_notifier.dart';
import 'package:sales_manager/data/services/remote/remote_shop_service.dart';
import 'package:sales_manager/routing/route_paths.dart';
import 'package:sales_manager/utils/result.dart';
import 'package:sales_manager/utils/show_snackbar.dart';

class AddNewShopScreen extends ConsumerStatefulWidget {
  const AddNewShopScreen({super.key});

  @override
  ConsumerState<AddNewShopScreen> createState() => _AddNewShopScreenState();
}

class _AddNewShopScreenState extends ConsumerState<AddNewShopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopService = RemoteShopService();
  
  // Form controllers
  final _shopIdController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _aadhaarNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _gstNumberController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _shopIdController.dispose();
    _shopNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _contactPersonController.dispose();
    _pinCodeController.dispose();
    _emailController.dispose();
    _aadhaarNumberController.dispose();
    _panNumberController.dispose();
    _locationNameController.dispose();
    _gstNumberController.dispose();
    super.dispose();
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter shop details",
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "All fields marked with * are required.",
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Shop ID
                    TextFormField(
                      controller: _shopIdController,
                      decoration: InputDecoration(
                        labelText: "Shop ID *",
                        hintText: "Enter unique shop ID (e.g., SH001)",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Shop ID is required';
                        }
                        if (value.trim().length < 3) {
                          return 'Shop ID must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Shop Name
                    TextFormField(
                      controller: _shopNameController,
                      decoration: InputDecoration(
                        labelText: "Shop Name *",
                        hintText: "Enter shop name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Shop name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Shop Address
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Shop Address *",
                        hintText: "Enter shop address",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Shop address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Contact Number
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Contact Number *",
                        hintText: "Enter contact phone number",
                        border: OutlineInputBorder(),
                        prefixText: "+",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Contact number is required';
                        }
                        if (value.trim().length < 10) {
                          return 'Contact number must be at least 10 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Contact Person
                    TextFormField(
                      controller: _contactPersonController,
                      decoration: InputDecoration(
                        labelText: "Contact Person *",
                        hintText: "Enter contact person name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Contact person is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Pin Code
                    TextFormField(
                      controller: _pinCodeController,
                      decoration: InputDecoration(
                        labelText: "Pin Code",
                        hintText: "Enter pin code",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter email address",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Aadhaar Number
                    TextFormField(
                      controller: _aadhaarNumberController,
                      decoration: InputDecoration(
                        labelText: "Aadhaar Number",
                        hintText: "Enter 12-digit Aadhaar number",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 16),

                    // PAN Number
                    TextFormField(
                      controller: _panNumberController,
                      decoration: InputDecoration(
                        labelText: "PAN Number",
                        hintText: "Enter PAN number",
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 10,
                    ),
                    const SizedBox(height: 16),

                    // Location Name
                    TextFormField(
                      controller: _locationNameController,
                      decoration: InputDecoration(
                        labelText: "Location Name",
                        hintText: "Enter location name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // GST Number
                    TextFormField(
                      controller: _gstNumberController,
                      decoration: InputDecoration(
                        labelText: "GST Number",
                        hintText: "Enter GST number",
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 15,
                    ),
                    const SizedBox(height: 24),
                    
                    // Info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Shop creation may require approval based on your role.",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Create Button
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleCreateShop,
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text("Creating..."),
                          ],
                        )
                      : const Text("Create Shop"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCreateShop() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = ref.read(currentUserNotifierProvider);
      final result = await _shopService.createShop(
        shopId: _shopIdController.text.trim(),
        name: _shopNameController.text.trim(),
        status: 'active',
        address: _addressController.text.trim(),
        phone: '+${_phoneController.text.trim()}',
        contactPerson: _contactPersonController.text.trim(),
        latitude: 0.0, // TODO: Get actual location
        longitude: 0.0, // TODO: Get actual location
        territoryId: currentUser?.territoryId ?? '', // Get from user's territory
        pinCode: _pinCodeController.text.trim().isNotEmpty ? _pinCodeController.text.trim() : null,
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
        aadhaarNumber: _aadhaarNumberController.text.trim().isNotEmpty ? _aadhaarNumberController.text.trim() : null,
        panNumber: _panNumberController.text.trim().isNotEmpty ? _panNumberController.text.trim() : null,
        locationName: _locationNameController.text.trim().isNotEmpty ? _locationNameController.text.trim() : null,
        gstNumber: _gstNumberController.text.trim().isNotEmpty ? _gstNumberController.text.trim() : null,
      );

      if (!mounted) return;

      switch (result) {
        case Ok():
          final response = result.value.data;
          final approvalRequired = response?['approval_required'] as bool?;
          final shop = response?['shop'] as Map<String, dynamic>?;
          
          if (approvalRequired == true) {
            // Show approval pending screen/message
            _showApprovalPendingDialog();
          } else if (shop != null) {
            // Shop created successfully
            showSnackBar(
              context,
              'Shop "${_shopNameController.text.trim()}" created successfully!',
              false,
            );
            context.go(RoutePaths.addShopSuccess);
          }
          break;
          
        case Error():
          showSnackBar(
            context,
            'Failed to create shop: ${result.error}',
            true,
          );
          break;
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          'An unexpected error occurred: $e',
          true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showApprovalPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.hourglass_empty,
          color: Theme.of(context).colorScheme.primary,
          size: 48,
        ),
        title: const Text('Approval Required'),
        content: Text(
          'Your shop creation request has been submitted and is pending approval from your area manager.\n\nYou will receive a notification once it\'s approved.',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go(RoutePaths.home);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
