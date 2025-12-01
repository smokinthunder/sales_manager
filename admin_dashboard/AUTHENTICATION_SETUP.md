# Admin Dashboard Email Authentication Implementation

## Overview
This document provides instructions for completing the email authentication implementation in the admin dashboard using MVVM architecture with Riverpod state management.

## ✅ Completed Files

### Domain Models
- ✅ `lib/domain/models/auth_response.dart` - Auth response and user models
- ✅ `lib/domain/models/auth_state.dart` - Authentication state classes

### Data Layer
- ✅ `lib/data/auth/local/local_auth_service.dart` - Local storage for tokens
- ✅ `lib/data/auth/remote/remote_email_auth_service.dart` - API service for email auth
- ✅ `lib/data/auth/remote/auth_remote_repository.dart` - Repository pattern implementation
- ✅ `lib/data/auth/remote/auth_interceptor.dart` - Automatic token management
- ✅ `lib/data/core/api_endpoints.dart` - API endpoint definitions

### ViewModel
- ✅ `lib/viewmodel/auth_viewmodel.dart` - State management with Riverpod

### UI Screens
- ✅ `lib/ui/login_screen.dart` - Updated with email authentication
- ✅ `lib/ui/forgot_password_screen.dart` - Password reset request
- ✅ `lib/ui/reset_password_screen.dart` - Reset password with token
- ✅ `lib/ui/change_password_screen.dart` - Change password for authenticated users

## 📋 Required Setup Steps

### 1. Add Dependencies to pubspec.yaml

Add the following dependencies if not already present:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Network
  dio: ^5.4.0
  
  # Local Storage
  flutter_secure_storage: ^9.0.0
  
  # Environment Variables
  flutter_dotenv: ^5.1.0
  
  # Routing
  go_router: ^13.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.8
  riverpod_generator: ^2.3.11
```

### 2. Run Code Generation

Run the following command to generate Riverpod providers:

```bash
cd admin_dashboard
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- `auth_viewmodel.g.dart`
- `auth_remote_repository.g.dart`

### 3. Setup Environment Variables

Create a `.env` file in the `admin_dashboard` root:

```env
IP_ADDR=192.168.63.132
TENANT_ID=aquastar
```

Update `pubspec.yaml` to include the .env file:

```yaml
flutter:
  assets:
    - .env
    - assets/images/
```

### 4. Update main.dart

Wrap your app with `ProviderScope` for Riverpod:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 5. Update Router Configuration

Add the new authentication routes to your router:

```dart
// In lib/routing/router.dart or wherever you define routes

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: Routes.dashboard,
      builder: (context, state) => HomeScreenScaffold(),
    ),
    // ... other routes
  ],
);
```

### 6. Add Route Guards (Optional but Recommended)

Add authentication checks to protected routes:

```dart
final router = GoRouter(
  redirect: (context, state) {
    final container = ProviderContainer();
    final authState = container.read(authViewModelProvider);
    
    final isAuthenticated = authState is AuthAuthenticated;
    final isLoginRoute = state.matchedLocation == '/';
    
    // Redirect to login if not authenticated
    if (!isAuthenticated && !isLoginRoute && 
        !state.matchedLocation.startsWith('/forgot-password') &&
        !state.matchedLocation.startsWith('/reset-password')) {
      return '/';
    }
    
    // Redirect to dashboard if already authenticated and trying to access login
    if (isAuthenticated && isLoginRoute) {
      return Routes.dashboard;
    }
    
    return null;
  },
  // ... routes
);
```

## 🔧 Configuration Notes

### Password Requirements
The implementation enforces the following password requirements:
- Minimum 8 characters
- At least 1 uppercase letter
- At least 1 lowercase letter
- At least 1 number
- At least 1 special character (!@#$%^&*()_+-=[]{}|;:,.<>?)

### Token Storage
- Access tokens are stored securely using `flutter_secure_storage`
- Tokens expire after 1 hour (3600 seconds)
- Refresh tokens are valid for 7 days
- The auth interceptor automatically adds tokens to API requests

### Rate Limiting
The backend implements rate limiting (5 requests per minute per endpoint):
- Login
- Forgot Password
- Reset Password
- Change Password

## 🧪 Testing the Implementation

### 1. Test Login Flow
```dart
// Use credentials from your backend
Email: admin@example.com
Password: SecurePass123!
Tenant ID: aquastar (configured in .env)
```

### 2. Test Forgot Password
1. Click "Forgot Password?" on login screen
2. Enter email address
3. Check backend terminal for reset token
4. Copy the token for next step

### 3. Test Reset Password
1. Navigate to Reset Password screen
2. Enter the token from terminal
3. Enter new password (meeting requirements)
4. Confirm new password
5. Should redirect to login on success

### 4. Test Change Password
1. Login successfully
2. Navigate to Change Password screen (add to settings/profile menu)
3. Enter current password
4. Enter new password
5. Confirm new password
6. Should show success message

## 📝 Usage Examples

### Accessing User Info in UI
```dart
Consumer(
  builder: (context, ref, child) {
    final authState = ref.watch(authViewModelProvider);
    
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      return Text('Welcome, ${user.name}!');
    }
    
    return SizedBox.shrink();
  },
)
```

### Logout Functionality
```dart
ElevatedButton(
  onPressed: () async {
    await ref.read(authViewModelProvider.notifier).logout();
    context.go('/'); // Navigate to login
  },
  child: Text('Logout'),
)
```

### Protected API Calls
For other services that need authentication:

```dart
import 'package:admin_dashboard/data/auth/remote/auth_interceptor.dart';
import 'package:admin_dashboard/data/auth/local/local_auth_service.dart';

class SomeRemoteService {
  late final Dio dio;
  
  SomeRemoteService() {
    dio = Dio();
    // Add auth interceptor to automatically include tokens
    dio.interceptors.add(AuthInterceptor(LocalAuthService()));
  }
  
  Future<Response> getSomeData() async {
    // Token will be added automatically
    return await dio.get('/api/v1/some-endpoint');
  }
}
```

## 🐛 Troubleshooting

### Issue: "Undefined name 'authViewModelProvider'"
**Solution:** Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: "Could not validate credentials"
**Solution:** Check that:
1. Backend is running on correct IP/port
2. `.env` file has correct IP_ADDR
3. Token hasn't expired (check timestamps)

### Issue: "Account is temporarily locked"
**Solution:** Wait 30 minutes or manually unlock in database:
```sql
UPDATE user_auth SET login_attempts = 0, locked_until = NULL WHERE email = 'your@email.com';
```

### Issue: Invalid or expired reset token
**Solution:** 
1. Request a new token (tokens expire after 1 hour)
2. Copy the exact token from backend terminal

## 📚 Architecture Overview

```
UI Layer (Screens)
    ↓
ViewModel (Riverpod StateNotifier)
    ↓
Repository (Business Logic)
    ↓
Remote Service (API Calls) + Local Service (Storage)
    ↓
Backend API
```

## 🔐 Security Best Practices

1. ✅ Passwords are never stored in plain text
2. ✅ Tokens stored in secure storage (flutter_secure_storage)
3. ✅ Automatic token expiry and refresh
4. ✅ Rate limiting on authentication endpoints
5. ✅ Password strength validation
6. ✅ Account lockout after failed attempts
7. ✅ Generic error messages to prevent enumeration
8. ✅ HTTPS required in production

## 📖 API Documentation Reference

Refer to `EMAIL_AUTHENTICATION_API.md` in the project root for complete API documentation including:
- Endpoint details
- Request/response formats
- Error codes
- Password requirements
- Rate limiting details

## 🎯 Next Steps

1. Run `flutter pub get` and code generation
2. Test all authentication flows
3. Add change password option to user profile/settings menu
4. Implement token refresh endpoint (optional enhancement)
5. Add email service for production password resets
6. Add loading states and better error handling
7. Implement "Remember Me" functionality (optional)
8. Add biometric authentication (optional)

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review `EMAIL_AUTHENTICATION_API.md` for backend details
3. Examine backend logs for detailed error messages
4. Verify .env configuration matches backend setup

---

**Last Updated:** December 1, 2025
**Architecture:** MVVM with Riverpod
**Flutter Version:** 3.x+
