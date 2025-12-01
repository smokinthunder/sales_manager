# ✅ Email Authentication - Setup Checklist

Use this checklist to complete the email authentication setup.

## 📦 Step 1: Dependencies
- [ ] Open `admin_dashboard/pubspec.yaml`
- [ ] Add/verify these dependencies exist:
  ```yaml
  dependencies:
    flutter_riverpod: ^2.5.1
    riverpod_annotation: ^2.3.5
    dio: ^5.4.0
    flutter_secure_storage: ^9.0.0
    flutter_dotenv: ^5.1.0
    go_router: ^13.0.0
  
  dev_dependencies:
    build_runner: ^2.4.8
    riverpod_generator: ^2.3.11
  ```
- [ ] Run: `flutter pub get`

## 🔧 Step 2: Environment Configuration
- [ ] Create `.env` file in `admin_dashboard/` root
- [ ] Add these lines to `.env`:
  ```env
  IP_ADDR=192.168.63.132
  TENANT_ID=aquastar
  ```
- [ ] Update IP_ADDR to match your backend server
- [ ] Update TENANT_ID if different

- [ ] Add to `pubspec.yaml` assets section:
  ```yaml
  flutter:
    assets:
      - .env
      - assets/images/
  ```

## 🏗️ Step 3: Code Generation
- [ ] Open terminal in `admin_dashboard/` directory
- [ ] Run: `dart run build_runner build --delete-conflicting-outputs`
- [ ] Wait for generation to complete
- [ ] Verify these files were created:
  - `lib/viewmodel/auth_viewmodel.g.dart`
  - `lib/data/auth/remote/auth_remote_repository.g.dart`

## 📱 Step 4: Main App Setup
- [ ] Open `lib/main.dart`
- [ ] Import Riverpod and dotenv:
  ```dart
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  ```
- [ ] Update main function:
  ```dart
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }
  ```

## 🗺️ Step 5: Router Configuration
- [ ] Open your router file (e.g., `lib/routing/router.dart`)
- [ ] Import new screens:
  ```dart
  import 'package:admin_dashboard/ui/forgot_password_screen.dart';
  import 'package:admin_dashboard/ui/reset_password_screen.dart';
  import 'package:admin_dashboard/ui/change_password_screen.dart';
  ```
- [ ] Add these routes:
  ```dart
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
  ```

## 🎨 Step 6: UI Integration
- [ ] Add "Change Password" option to settings/profile menu
  ```dart
  ListTile(
    leading: Icon(Icons.lock_outline),
    title: Text('Change Password'),
    onTap: () => context.push('/change-password'),
  ),
  ```

- [ ] Add logout button to your app bar or drawer
  ```dart
  Consumer(
    builder: (context, ref, child) {
      return IconButton(
        icon: Icon(Icons.logout),
        onPressed: () async {
          await ref.read(authViewModelProvider.notifier).logout();
          context.go('/');
        },
      );
    },
  )
  ```

## 🧪 Step 7: Testing

### Backend Setup
- [ ] Ensure backend server is running
- [ ] Verify backend is accessible at the IP in .env
- [ ] Check backend has email auth endpoints enabled

### Test Login
- [ ] Open app and navigate to login screen
- [ ] Enter test credentials:
  - Email: `admin@example.com`
  - Password: `SecurePass123!`
- [ ] Click Login
- [ ] ✅ Should navigate to dashboard on success
- [ ] ✅ Should show error message on failure

### Test Forgot Password
- [ ] Click "Forgot Password?" link
- [ ] Enter email address
- [ ] Click "Send Reset Token"
- [ ] ✅ Check backend terminal for reset token
- [ ] ✅ Should see success message

### Test Reset Password
- [ ] Navigate to Reset Password screen
- [ ] Enter token from terminal
- [ ] Enter new password (meeting all requirements):
  - At least 8 characters
  - 1 uppercase letter
  - 1 lowercase letter
  - 1 number
  - 1 special character
- [ ] Confirm password
- [ ] Click "Reset Password"
- [ ] ✅ Should redirect to login after success

### Test Change Password
- [ ] Login successfully
- [ ] Navigate to Change Password screen
- [ ] Enter current password
- [ ] Enter new password (meeting requirements)
- [ ] Confirm new password
- [ ] Click "Change Password"
- [ ] ✅ Should show success message

### Test Auth State Persistence
- [ ] Login successfully
- [ ] Close app completely
- [ ] Reopen app
- [ ] ✅ Should remain logged in (if token not expired)

## 🐛 Step 8: Troubleshooting

### If you see "Undefined name" errors:
- [ ] Run code generation again:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- [ ] Restart your IDE/editor
- [ ] Run `flutter clean` then `flutter pub get`

### If login fails:
- [ ] Check backend is running
- [ ] Verify IP_ADDR in .env matches backend
- [ ] Check backend logs for errors
- [ ] Verify tenant_id is correct
- [ ] Ensure user exists in database

### If token errors occur:
- [ ] Check token hasn't expired (1 hour limit)
- [ ] Verify secure storage permissions
- [ ] Try logout and login again
- [ ] Check flutter_secure_storage is properly installed

## 📚 Step 9: Documentation Review
- [ ] Read `IMPLEMENTATION_SUMMARY.md` for overview
- [ ] Read `AUTHENTICATION_SETUP.md` for detailed setup
- [ ] Review `EMAIL_AUTHENTICATION_API.md` in project root for API details

## 🚀 Step 10: Production Preparation
- [ ] Change IP_ADDR to production backend URL
- [ ] Enable HTTPS in production
- [ ] Set up email service for password resets (replace terminal output)
- [ ] Configure proper error tracking
- [ ] Test on physical devices
- [ ] Set up proper logging
- [ ] Review security best practices

## ✨ Optional Enhancements
- [ ] Add "Remember Me" functionality
- [ ] Implement biometric authentication
- [ ] Add email verification
- [ ] Implement token refresh endpoint
- [ ] Add session management UI
- [ ] Implement multi-factor authentication
- [ ] Add password strength meter
- [ ] Implement password history (prevent reuse)

---

## 🎯 Success Criteria

You've successfully completed the setup when:
- ✅ No compilation errors
- ✅ Can login with email/password
- ✅ Can request password reset
- ✅ Can reset password with token
- ✅ Can change password when logged in
- ✅ Tokens persist across app restarts
- ✅ Logout clears authentication state
- ✅ Protected routes redirect to login

---

**Need Help?**
- Check `AUTHENTICATION_SETUP.md` for troubleshooting
- Review backend logs for API errors
- Verify .env configuration
- Ensure all dependencies are installed

**Last Updated:** December 1, 2025
