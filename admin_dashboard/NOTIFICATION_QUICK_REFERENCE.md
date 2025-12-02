# Notification System - Quick Reference

## Usage in Admin Dashboard

### 1. Displaying Notifications
The `Notifications` widget automatically handles fetching and displaying all notifications.

```dart
// In your routing/navigation
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const Notifications()),
);
```

### 2. Accessing Notification Count
Use the `notificationCountProvider` to display pending count in your app bar:

```dart
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(notificationCountProvider);
    return Badge(
      label: Text('$count'),
      isLabelVisible: count > 0,
      child: IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => Navigator.push(...),
      ),
    );
  },
)
```

### 3. Programmatic Actions
```dart
// Get reference to actions provider
final actions = ref.read(notificationActionsProvider.notifier);

// Approve a notification
final result = await actions.approveNotification(notificationId);

// Reject a notification
final result = await actions.rejectNotification(notificationId);

// Handle result
if (result is Ok) {
  print('Success!');
} else {
  print('Error: ${result.error}');
}
```

### 4. Refresh Notifications
```dart
// Trigger a refresh
ref.invalidate(allNotificationsProvider);
```

## Notification Types

### Profile Update
- Shows field-by-field changes
- Displays old → new values
- Copy-to-clipboard for each field
- Example fields: phone_number, address, email

### Customer Creation
- Shows customer creation request
- Basic sender and subject info
- Approve/Reject actions

## API Integration

### Environment Variables
Ensure `.env` file has:
```
IP_ADDR=192.168.154.166
TENANT_ID=AQUASTAR
```

### Expected Backend Response
```json
[
  {
    "id": "notification_id",
    "sender_name": "John Doe",
    "receiver_name": "Admin",
    "subject": "Area Manager",
    "notification_type": "profile_update",
    "related_data": {
      "phone_number": {
        "old": "1234567890",
        "new": "0987654321"
      }
    },
    "is_confirmed": false,
    "created_at": "2024-12-02T10:30:00Z",
    "updated_at": "2024-12-02T10:30:00Z"
  }
]
```

## Customization

### Add New Notification Type
1. Add to `NotificationType` enum in `notification_type.dart`
2. Update `fromString()` method
3. Add case in `displaySubject` getter in `notification.dart`
4. Create custom UI card in `notifications.dart` if needed

### Modify UI Cards
Edit the widget classes in `notifications.dart`:
- `ProfileEditingRequest`: Profile update cards
- `CustomerCreationCard`: Customer creation cards

### Change Styling
All cards use theme colors:
- `theme.colorScheme.primary`
- `theme.textTheme.bodyLarge`
- etc.

## Troubleshooting

### Notifications not loading
1. Check backend is running
2. Verify `.env` has correct `IP_ADDR`
3. Check authentication token is valid
4. Inspect network requests in browser DevTools

### Count not updating
The count auto-updates when notifications load. To manually update:
```dart
ref.read(notificationCountProvider.notifier).state = newCount;
```

### Build errors after changes
Run code generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```
