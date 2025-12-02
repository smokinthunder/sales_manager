# Authentication Testing Guide

## Quick Start

### 1. Run Code Generation
```bash
cd /home/antesh/Desktop/sales_manager/admin_dashboard
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 2. Verify Environment
Check `.env` file:
```env
IP_ADDR=192.168.154.166
TENANT_ID=AQUASTAR
```

### 3. Run the App
```bash
flutter run
```

## Test Scenarios

### ✅ Test 1: Login Flow
1. Open app → Should show login screen
2. Leave fields empty → Click Login → See validation errors
3. Enter invalid email format → See email validation error
4. Enter short password → See password validation error
5. Enter wrong credentials → See authentication error
6. Enter correct credentials → See loading → Redirect to dashboard

**Expected Result**: Smooth login with proper error handling

### ✅ Test 2: Route Protection
1. Login successfully
2. Note the URL in browser (if web) or current route
3. Logout
4. Try to access protected route directly
5. Should redirect to login screen

**Expected Result**: Cannot access protected routes when logged out

### ✅ Test 3: Auto-Redirect When Authenticated
1. Login successfully
2. Try to navigate to `/` or `/login` route
3. Should automatically redirect to dashboard

**Expected Result**: Authenticated users cannot access login page

### ✅ Test 4: Logout
1. Login successfully
2. Navigate to dashboard
3. Click logout button
4. Should redirect to login screen
5. Try accessing dashboard → redirect to login

**Expected Result**: Clean logout with session cleared

### ✅ Test 5: Forgot Password
1. On login screen, click "Forgot Password?"
2. Enter email address
3. Click submit
4. Should see success message
5. Check backend console for reset token

**Expected Result**: Password reset email sent

### ✅ Test 6: Error Handling
1. Stop backend server
2. Try to login
3. Should see network error message

**Expected Result**: User-friendly error messages

### ✅ Test 7: Token Expiry
1. Login successfully
2. Wait for token to expire (or manually delete token from storage)
3. Try to access protected API
4. Should see session expired message
5. Should redirect to login

**Expected Result**: Automatic session handling

## Check Logs

When running in debug mode, you'll see detailed logs:

```
ℹ️ 2025-12-02T10:30:45.123 INFO [AUTH_SERVICE]: RemoteEmailAuthService initialized
🔍 2025-12-02T10:30:50.456 DEBUG [AUTH_VIEWMODEL]: Checking authentication status
ℹ️ 2025-12-02T10:31:00.789 INFO [AUTH_SERVICE]: Login attempt for: user@example.com
✅ 2025-12-02T10:31:02.123 INFO [AUTH_SERVICE]: Login successful for user: user@example.com
```

## Common Issues

### Issue: Compile Errors
**Solution**: Run code generation
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Issue: "Cannot connect to server"
**Solution**: 
1. Check backend is running
2. Verify IP_ADDR in `.env`
3. Check firewall settings

### Issue: "Session expired" immediately
**Solution**: 
1. Check system time is correct
2. Verify token expiry logic
3. Check backend token settings

### Issue: Stuck in redirect loop
**Solution**: 
1. Clear app data
2. Restart app
3. Check auth state in logs

## Backend Requirements

Ensure backend has these endpoints working:

- `POST /api/v1/auth/email/login`
- `POST /api/v1/auth/email/forgot-password`
- `POST /api/v1/auth/email/reset-password`
- `PUT /api/v1/auth/email/change-password`
- `GET /api/v1/auth/email/check-email`

## Success Criteria

✅ All test scenarios pass
✅ No console errors
✅ Smooth user experience
✅ Proper error messages
✅ Logs show proper flow
✅ Route protection works
✅ Token management works

## Next Steps After Testing

1. Deploy to staging environment
2. Test with real backend
3. Test on multiple devices
4. Conduct user acceptance testing
5. Monitor logs for issues
6. Gather user feedback

---

**Testing Date**: December 2, 2025
**Tested By**: Development Team
