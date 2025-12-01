# Quick Commands Reference

## Initial Setup (One-time)
```bash
cd admin_dashboard

# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Create .env file
echo "IP_ADDR=192.168.63.132" > .env
echo "TENANT_ID=aquastar" >> .env
```

## During Development
```bash
# Watch for changes and auto-generate
dart run build_runner watch --delete-conflicting-outputs

# Clean and regenerate
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

## Quick Test Credentials
```
Email: admin@example.com
Password: SecurePass123!
Tenant: aquastar
```

## Files Created
```
admin_dashboard/
├── lib/
│   ├── domain/models/
│   │   ├── auth_response.dart          ✅ NEW
│   │   └── auth_state.dart             ✅ NEW
│   ├── data/auth/
│   │   ├── local/
│   │   │   └── local_auth_service.dart ✅ UPDATED
│   │   └── remote/
│   │       ├── remote_email_auth_service.dart ✅ NEW
│   │       ├── auth_remote_repository.dart    ✅ UPDATED
│   │       └── auth_interceptor.dart          ✅ NEW
│   ├── viewmodel/
│   │   └── auth_viewmodel.dart         ✅ NEW
│   └── ui/
│       ├── login_screen.dart           ✅ UPDATED
│       ├── forgot_password_screen.dart ✅ NEW
│       ├── reset_password_screen.dart  ✅ NEW
│       └── change_password_screen.dart ✅ NEW
├── AUTHENTICATION_SETUP.md             ✅ NEW
├── IMPLEMENTATION_SUMMARY.md           ✅ NEW
├── SETUP_CHECKLIST.md                  ✅ NEW
└── QUICK_REFERENCE.md                  ✅ NEW (this file)
```

## Common Issues & Solutions

### "Undefined name 'authViewModelProvider'"
```bash
dart run build_runner build --delete-conflicting-outputs
```

### "Could not validate credentials"
- Check backend is running
- Verify IP_ADDR in .env
- Check tenant_id matches

### "Account is temporarily locked"
Wait 30 minutes or reset in database:
```sql
UPDATE user_auth 
SET login_attempts = 0, locked_until = NULL 
WHERE email = 'your@email.com';
```

## Password Requirements
- ✅ Minimum 8 characters
- ✅ At least 1 uppercase (A-Z)
- ✅ At least 1 lowercase (a-z)
- ✅ At least 1 number (0-9)
- ✅ At least 1 special char (!@#$%^&*...)

## Important Code Snippets

### Access Current User
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

### Logout
```dart
await ref.read(authViewModelProvider.notifier).logout();
context.go('/');
```

### Protected API Call
```dart
final accessToken = ref.read(authViewModelProvider.notifier).accessToken;
if (accessToken != null) {
  // Make API call with token
}
```

## Docs Quick Links
- **API Docs**: `/EMAIL_AUTHENTICATION_API.md` (root)
- **Setup Guide**: `AUTHENTICATION_SETUP.md`
- **Summary**: `IMPLEMENTATION_SUMMARY.md`
- **Checklist**: `SETUP_CHECKLIST.md`

## Architecture Flow
```
Login Screen
    ↓ user input
AuthViewModel.login()
    ↓ calls
AuthRemoteRepository.login()
    ↓ calls
RemoteEmailAuthService.login()
    ↓ HTTP POST
Backend API /api/v1/auth/email/login
    ↓ response
Save tokens to LocalAuthService
    ↓ update
AuthState → AuthAuthenticated
    ↓ triggers
Navigate to Dashboard
```

## Status Check
✅ Implementation: Complete
✅ Documentation: Complete
⏳ Setup: Pending (run checklist)
⏳ Testing: Pending

## Next Actions
1. ✅ Read `SETUP_CHECKLIST.md`
2. ⏳ Run code generation
3. ⏳ Test login flow
4. ⏳ Test password flows
5. ⏳ Deploy to production

---
**Need help?** Check `AUTHENTICATION_SETUP.md`
