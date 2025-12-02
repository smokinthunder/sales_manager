# Notification System Testing Guide

## Overview

This document provides comprehensive testing scenarios for the admin dashboard notification system. It covers functional testing, error handling, edge cases, and performance validation.

## Testing Environment Setup

### Prerequisites

```bash
# 1. Ensure backend is running
curl http://192.168.154.166:8000/api/v1/

# 2. Verify .env configuration
cat .env
# Should contain:
# IP_ADDR=192.168.154.166
# TENANT_ID=AQUASTAR

# 3. Clean build
cd /home/antesh/Desktop/sales_manager/admin_dashboard
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Enable Debug Logging

In `lib/data/notification/config/notification_config.dart`:
```dart
static const bool enableVerboseLogging = true;
static const bool enableDebugMode = true;
```

## Test Scenarios

### 1. Basic Functionality Tests

#### Test 1.1: Load All Notifications

**Steps:**
1. Launch admin dashboard
2. Login with valid credentials
3. Navigate to Notifications screen

**Expected Results:**
- ✅ Loading indicator appears
- ✅ Notifications list loads successfully
- ✅ Each notification shows: sender name, subject, timestamp
- ✅ Profile image or fallback icon displays
- ✅ Pending count badge shows correct number

**Console Logs Expected:**
```
✅ [NOTIFICATION_SERVICE]: RemoteNotificationService initialized
📤 [API_REQUEST]: GET /api/v1/notifications/
✅ [API_RESPONSE]: 200 /api/v1/notifications/ Success
✅ [NOTIFICATION_REPO]: Repository: Fetching notifications
✅ [NOTIFICATION_VM]: Successfully loaded X notifications
```

**Validation:**
```dart
// Check state
expect(ref.read(allNotificationsProvider).hasValue, true);
expect(ref.read(allNotificationsProvider).value?.isNotEmpty, true);
```

---

#### Test 1.2: View Pending Notifications

**Steps:**
1. Navigate to "Pending" tab
2. Observe filtered notifications

**Expected Results:**
- ✅ Only shows notifications where `is_confirmed = false`
- ✅ Pending count matches displayed items
- ✅ Each notification has "Approve" and "Reject" buttons

**Console Logs Expected:**
```
✅ [NOTIFICATION_VM]: Filtering pending notifications
```

**Validation:**
```dart
final pending = ref.read(pendingNotificationsProvider).value;
expect(pending?.every((n) => !n.isConfirmed), true);
```

---

#### Test 1.3: View Confirmed Notifications

**Steps:**
1. Navigate to "Confirmed" tab
2. Observe filtered notifications

**Expected Results:**
- ✅ Only shows notifications where `is_confirmed = true`
- ✅ No action buttons visible
- ✅ Shows confirmation status (approved/rejected)

**Validation:**
```dart
final confirmed = ref.read(confirmedNotificationsProvider).value;
expect(confirmed?.every((n) => n.isConfirmed), true);
```

---

### 2. Action Tests

#### Test 2.1: Approve Notification

**Steps:**
1. Find a pending notification
2. Tap "Approve" button
3. Observe confirmation dialog
4. Tap "Approve" in dialog

**Expected Results:**
- ✅ Confirmation dialog appears with notification details
- ✅ Dialog shows "Are you sure you want to approve this notification?"
- ✅ On confirm: Loading indicator appears
- ✅ Success snackbar: "Notification approved successfully"
- ✅ Notification moves to "Confirmed" tab
- ✅ Pending count decreases by 1
- ✅ List refreshes automatically

**Console Logs Expected:**
```
✅ [NOTIFICATION_VM]: Approving notification: {id}
📤 [API_REQUEST]: POST /api/v1/notifications/{id}/confirm
✅ [API_RESPONSE]: 200 /api/v1/notifications/{id}/confirm Success
✅ [NOTIFICATION_VM]: Notification {id} approved successfully
```

**Validation:**
```dart
final actions = ref.read(notificationActionsProvider.notifier);
final result = await actions.approveNotification('123');
expect(result is Ok, true);
```

---

#### Test 2.2: Reject Notification

**Steps:**
1. Find a pending notification
2. Tap "Reject" button
3. Observe confirmation dialog
4. Tap "Reject" in dialog

**Expected Results:**
- ✅ Confirmation dialog appears
- ✅ Dialog shows "Are you sure you want to reject this notification?"
- ✅ On confirm: Loading indicator appears
- ✅ Success snackbar: "Notification rejected successfully"
- ✅ Notification moves to "Confirmed" tab
- ✅ Pending count decreases by 1
- ✅ List refreshes automatically

**Console Logs Expected:**
```
✅ [NOTIFICATION_VM]: Rejecting notification: {id}
📤 [API_REQUEST]: POST /api/v1/notifications/{id}/confirm
✅ [API_RESPONSE]: 200 /api/v1/notifications/{id}/confirm Success
✅ [NOTIFICATION_VM]: Notification {id} rejected successfully
```

---

#### Test 2.3: Cancel Action

**Steps:**
1. Tap "Approve" or "Reject"
2. In confirmation dialog, tap "Cancel"

**Expected Results:**
- ✅ Dialog closes
- ✅ No API call made
- ✅ Notification remains in pending state
- ✅ No changes to pending count

**Console Logs Expected:**
```
(No logs - action cancelled before execution)
```

---

### 3. Error Handling Tests

#### Test 3.1: Network Disconnection

**Steps:**
1. Disconnect device from network (WiFi/Mobile data off)
2. Try to load notifications
3. Try to approve/reject a notification

**Expected Results:**
- ✅ Error message: "Unable to connect to server. Please check your internet connection."
- ✅ Error icon displayed
- ✅ "Retry" button available
- ✅ No app crash

**Console Logs Expected:**
```
❌ [API_ERROR]: SocketException
❌ [NOTIFICATION_SERVICE]: Network error: Unable to connect
❌ [NOTIFICATION_VM]: Failed to load notifications: Unable to connect to server
```

**Validation:**
```dart
expect(
  () => remoteService.getNotifications(),
  throwsA(isA<Exception>().having(
    (e) => e.toString(),
    'message',
    contains('Unable to connect')
  ))
);
```

---

#### Test 3.2: Request Timeout

**Steps:**
1. Use slow network connection
2. Wait more than 30 seconds for response

**Expected Results:**
- ✅ Error message: "Request timed out. Please check your connection and try again."
- ✅ Request cancelled after 30 seconds
- ✅ User can retry

**Console Logs Expected:**
```
📤 [API_REQUEST]: GET /api/v1/notifications/
⏱️  [API_TIMEOUT]: Request exceeded 30 seconds
❌ [API_ERROR]: Timeout
❌ [NOTIFICATION_SERVICE]: Request timed out
```

---

#### Test 3.3: Authentication Error (401/403)

**Steps:**
1. Use expired or invalid auth token
2. Try to load notifications

**Expected Results:**
- ✅ Error message: "You are not authorized to perform this action."
- ✅ Redirect to login (if implemented)
- ✅ Token cleared from storage

**Console Logs Expected:**
```
❌ [API_ERROR]: 401 /api/v1/notifications/
❌ [NOTIFICATION_SERVICE]: Unauthorized access
```

---

#### Test 3.4: Not Found Error (404)

**Steps:**
1. Try to approve a deleted notification

**Expected Results:**
- ✅ Error message: "Notification not found. It may have been already processed."
- ✅ Notification removed from list
- ✅ List refreshes

**Console Logs Expected:**
```
❌ [API_ERROR]: 404 /api/v1/notifications/{id}
❌ [NOTIFICATION_SERVICE]: Notification not found
❌ [NOTIFICATION_VM]: Failed to approve: Notification not found
```

---

#### Test 3.5: Server Error (500+)

**Steps:**
1. Backend returns 500/502/503
2. Observe error handling

**Expected Results:**
- ✅ Error message: "Server error occurred. Please try again later or contact support."
- ✅ Retry option available
- ✅ Error logged with details

**Console Logs Expected:**
```
❌ [API_ERROR]: 500 /api/v1/notifications/
❌ [NOTIFICATION_SERVICE]: Server error: Internal server error
```

---

### 4. Edge Cases

#### Test 4.1: Empty Notification List

**Steps:**
1. Ensure no notifications exist in backend
2. Load notifications

**Expected Results:**
- ✅ Empty state displays
- ✅ Message: "No notifications to display"
- ✅ Icon showing empty inbox
- ✅ No loading errors

---

#### Test 4.2: Very Long Notification

**Steps:**
1. Create notification with long sender name, subject
2. Display in list

**Expected Results:**
- ✅ Text truncates with ellipsis
- ✅ Card maintains consistent height
- ✅ No overflow errors
- ✅ Full text visible in expanded view

---

#### Test 4.3: Rapid Action Clicks

**Steps:**
1. Quickly tap "Approve" button multiple times
2. Observe behavior

**Expected Results:**
- ✅ Only one API call made
- ✅ Button disabled during processing
- ✅ No duplicate confirmations
- ✅ Single success message

---

#### Test 4.4: Concurrent Notifications

**Steps:**
1. Two admins approve/reject same notification simultaneously

**Expected Results:**
- ✅ First action succeeds
- ✅ Second action gets 404 error
- ✅ Proper error message shown
- ✅ Lists refresh correctly

---

### 5. UI/UX Tests

#### Test 5.1: Pull to Refresh

**Steps:**
1. Pull down on notification list
2. Release to refresh

**Expected Results:**
- ✅ Refresh indicator appears
- ✅ API call made
- ✅ List updates with new data
- ✅ Indicator dismisses

---

#### Test 5.2: Notification Types

**Profile Update:**
- ✅ Shows "Profile Editing Request" title
- ✅ Displays field changes (before → after)
- ✅ Shows manager profile image

**Customer Creation:**
- ✅ Shows "Customer Creation Request" title
- ✅ Displays generic notification icon
- ✅ Shows customer details

---

#### Test 5.3: Timestamp Display

**Steps:**
1. Check various notification timestamps

**Expected Formats:**
- < 1 minute ago: "Just now"
- < 1 hour ago: "X minutes ago"
- < 24 hours ago: "X hours ago"
- < 7 days ago: "X days ago"
- Older: "DD MMM YYYY, HH:mm"

---

### 6. Performance Tests

#### Test 6.1: Large Dataset

**Steps:**
1. Backend has 100+ notifications
2. Load notifications
3. Scroll through list

**Expected Results:**
- ✅ Initial load < 3 seconds
- ✅ Smooth scrolling (60 FPS)
- ✅ No memory leaks
- ✅ Images load progressively

**Validation:**
```dart
final stopwatch = Stopwatch()..start();
await ref.read(allNotificationsProvider.future);
stopwatch.stop();
expect(stopwatch.elapsedMilliseconds, lessThan(3000));
```

---

#### Test 6.2: Memory Usage

**Steps:**
1. Load notifications
2. Approve 10 notifications
3. Refresh multiple times
4. Check memory

**Expected Results:**
- ✅ Memory stays < 200MB
- ✅ No memory growth over time
- ✅ Proper disposal of resources

---

### 7. Integration Tests

#### Test 7.1: End-to-End Flow

**Steps:**
1. Login
2. Navigate to notifications
3. Approve notification
4. Check confirmed tab
5. Verify backend state

**Expected Results:**
- ✅ Complete flow works
- ✅ Data consistent across UI and backend
- ✅ State persists across app restarts

---

## Automated Testing

### Unit Tests

```dart
// test/viewmodel/notification_viewmodel_test.dart
void main() {
  group('NotificationViewModel', () {
    test('loads notifications successfully', () async {
      // Arrange
      final container = ProviderContainer(overrides: [
        notificationRepositoryProvider.overrideWith((ref) => mockRepository),
      ]);
      
      // Act
      final notifications = await container.read(allNotificationsProvider.future);
      
      // Assert
      expect(notifications.length, greaterThan(0));
    });
    
    test('handles approval success', () async {
      // Test approve flow
    });
    
    test('handles network error gracefully', () async {
      // Test error handling
    });
  });
}
```

### Widget Tests

```dart
// test/ui/notifications_test.dart
void main() {
  testWidgets('displays notification list', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: NotificationsScreen()),
      ),
    );
    
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);
  });
}
```

---

## Test Checklist

### Pre-Release Checklist

- [ ] All basic functionality tests pass
- [ ] All action tests pass
- [ ] All error handling tests pass
- [ ] All edge cases handled
- [ ] UI/UX tests pass
- [ ] Performance benchmarks met
- [ ] Integration tests pass
- [ ] Logs are comprehensive and clean
- [ ] No sensitive data in logs
- [ ] Error messages user-friendly

### Regression Testing

After any code changes, verify:
- [ ] Notifications still load
- [ ] Approve/Reject still works
- [ ] Error handling unchanged
- [ ] Logs still comprehensive
- [ ] No new warnings/errors

---

## Debugging Tools

### Console Log Filtering

```bash
# Filter notification logs only
flutter run | grep "NOTIFICATION"

# Show only errors
flutter run | grep "❌"

# Show API calls
flutter run | grep "API"
```

### State Inspection

```dart
// In Flutter DevTools console:
ref.read(allNotificationsProvider).value
ref.read(notificationCountProvider)
ref.read(pendingNotificationsProvider).value?.length
```

### Network Debugging

```bash
# Use Charles Proxy or similar to inspect API calls
# Monitor requests to: http://192.168.154.166:8000/api/v1/notifications/
```

---

## Known Issues

### Issue 1: Auth Warning Before Login
**Symptom:** "No access token found" warning in console  
**Status:** Expected behavior  
**Solution:** Login to clear warning  
**Reference:** AUTH_DEBUGGING_GUIDE.md

---

## Test Results Template

```markdown
## Test Run: [Date]

**Tester:** [Name]
**Environment:** [Device/Emulator]
**Backend Version:** [Version]

### Results
- Basic Functionality: ✅ PASS / ❌ FAIL
- Action Tests: ✅ PASS / ❌ FAIL
- Error Handling: ✅ PASS / ❌ FAIL
- Edge Cases: ✅ PASS / ❌ FAIL
- UI/UX: ✅ PASS / ❌ FAIL
- Performance: ✅ PASS / ❌ FAIL

### Issues Found
1. [Description]
2. [Description]

### Notes
[Any additional observations]
```

---

**Version:** 1.0.0  
**Last Updated:** December 2, 2024  
**Status:** Comprehensive Testing Guide ✅
