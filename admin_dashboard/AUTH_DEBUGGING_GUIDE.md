# Authentication Debugging Guide

## Warning: "No access token found for protected endpoint"

### What This Means:
The notification API request was made without an authentication token. This happens when:
1. User is not logged in
2. Session expired
3. Token was not saved properly during login

### Quick Fix Steps:

#### Step 1: Verify Login Status
Check if you're logged in to the admin dashboard:
1. Open the admin dashboard app
2. Check if you're on the login screen or the dashboard
3. If on dashboard, check the console for token-related logs

#### Step 2: Login to Admin Dashboard
If not logged in:
1. Navigate to the login screen
2. Enter valid credentials
3. Click "Login"
4. Watch the console for authentication logs

#### Step 3: Check Token Storage
After successful login, verify tokens are stored:

**Console should show:**
```
✅ [AUTH_VIEWMODEL]: Login successful
✅ [LOCAL_AUTH]: Tokens saved successfully
```

#### Step 4: Test Notification Access
1. Navigate to Notifications screen
2. Check if data loads
3. If still failing, check the console for specific errors

### Troubleshooting by Error Pattern:

#### Pattern 1: "No access token found"
**Cause:** User not logged in or token not stored
**Solution:** 
- Login again through the UI
- Check that `.env` file has correct backend IP

#### Pattern 2: "Access token expired"
**Cause:** Token TTL expired
**Solution:**
- Automatically handled by clearing session
- User will be redirected to login

#### Pattern 3: Request fails with 401
**Cause:** Invalid token or backend rejected it
**Solution:**
- Clear app data and login again
- Verify backend is running
- Check token format in backend logs

### How to Debug Token Issues:

#### 1. Enable Verbose Logging
Already enabled in your app. Check console for:
```
[AUTH_INTERCEPTOR]: Public endpoint, skipping auth
[AUTH_INTERCEPTOR]: Auth token attached to request
[AUTH_INTERCEPTOR]: No access token found
```

#### 2. Check Token in Storage
Add this debug code temporarily:

```dart
// In your debug screen or console
final localAuth = LocalAuthService();
final token = await localAuth.getAccessToken();
print('Current access token: ${token ?? "NONE"}');
```

#### 3. Verify Backend Connection
Check your `.env` file:
```env
IP_ADDR=192.168.154.166  # Should match your backend IP
TENANT_ID=AQUASTAR        # Should match your tenant
```

#### 4. Test Backend Directly
Use curl to verify backend is working:
```bash
# Test login endpoint
curl -X POST http://192.168.154.166:8000/api/v1/auth/email/login \
  -H "Content-Type: application/json" \
  -d '{"email":"your@email.com","password":"yourpassword","tenant_id":"AQUASTAR"}'

# Test notifications endpoint (replace TOKEN with actual token)
curl -X GET "http://192.168.154.166:8000/api/v1/notifications/?tenant_id=AQUASTAR" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Expected Flow:

1. **User Opens App**
   - App checks for stored token
   - If no token → Redirect to login
   - If token exists → Check if expired

2. **User Logs In**
   - Credentials sent to backend
   - Backend returns: `access_token`, `refresh_token`, `user_info`
   - Tokens saved to secure storage
   - User redirected to dashboard

3. **User Accesses Notifications**
   - Request intercepted by `AuthInterceptor`
   - Token retrieved from storage
   - Token added to `Authorization` header
   - Request sent to backend

4. **Backend Validates Token**
   - If valid → Returns notification data
   - If invalid → Returns 401
   - If expired → Returns 401

### Common Issues & Solutions:

| Issue | Symptom | Solution |
|-------|---------|----------|
| Not logged in | No token warning | Login through UI |
| Backend down | Connection refused | Start backend server |
| Wrong IP | Timeout/No response | Check `.env` IP_ADDR |
| Token expired | Auto-cleared message | Login again |
| Backend auth broken | 401 despite valid token | Check backend logs |

### Testing Checklist:

- [ ] Backend is running on correct IP
- [ ] `.env` file has correct IP_ADDR
- [ ] User can login successfully
- [ ] Console shows "Tokens saved successfully"
- [ ] Dashboard loads after login
- [ ] Notification screen is accessible
- [ ] API requests include Authorization header

### Next Steps:

**If you're testing the notification system:**
1. First, login to the admin dashboard
2. Navigate to the Notifications screen
3. The system will automatically fetch notifications

**If you see this warning after logging in:**
1. Check the backend logs for authentication errors
2. Verify the token format matches backend expectations
3. Try clearing app data and logging in again

### Dev Note:
The warning is intentional and helps identify unauthenticated requests. It's not an error if you're not logged in yet. The app will:
- Redirect to login if on protected route
- Show login screen if accessing auth-required features
- Work normally once authenticated

---

**Current Status:**
⚠️ You're seeing this warning because the notification request was made without an active session. **Please log in to the admin dashboard first**, then navigate to the Notifications screen.
