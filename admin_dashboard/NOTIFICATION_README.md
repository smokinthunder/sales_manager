# Notification System Documentation

## Overview

The admin dashboard notification system provides a comprehensive, production-ready solution for managing and processing notification requests. Built with professional engineering practices, it features robust error handling, comprehensive logging, and a clean architecture.

## Architecture

### Three-Layer Architecture

```
┌─────────────────────────────────────────┐
│           UI Layer                      │
│  ┌───────────────────────────────────┐  │
│  │    Notifications Screen           │  │
│  │  - Display notifications          │  │
│  │  - Approve/Reject actions         │  │
│  │  - Real-time count updates        │  │
│  └───────────────────────────────────┘  │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│         ViewModel Layer                  │
│  ┌───────────────────────────────────┐  │
│  │  NotificationViewModel            │  │
│  │  - State management               │  │
│  │  - Business logic                 │  │
│  │  - Error handling                 │  │
│  └───────────────────────────────────┘  │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│          Data Layer                      │
│  ┌───────────────────────────────────┐  │
│  │  NotificationRepository           │  │
│  │  - Data coordination              │  │
│  │  - Logging                        │  │
│  └───────────────┬───────────────────┘  │
│                  │                       │
│  ┌───────────────▼───────────────────┐  │
│  │  RemoteNotificationService        │  │
│  │  - API communication              │  │
│  │  - Error parsing                  │  │
│  │  - Request logging                │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Core Components

### 1. NotificationConfig (`lib/data/notification/config/notification_config.dart`)

Centralized configuration for all notification-related constants:

```dart
class NotificationConfig {
  // API Configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxApiRetries = 3;
  
  // Error Messages
  static const String networkErrorMessage = '...';
  static const String fetchErrorMessage = '...';
  
  // Display Configuration
  static const int notificationsPerPage = 20;
  static const bool enableFiltering = true;
  
  // Feature Flags
  static const bool enableRealTime = false;
  static const bool enableBulkActions = false;
}
```

**Benefits:**
- Single source of truth for all constants
- Easy configuration updates
- Type-safe values
- Self-documenting code

### 2. RemoteNotificationService (`lib/data/notification/remote/remote_notification_service.dart`)

Handles all API communication with comprehensive error handling:

```dart
class RemoteNotificationService {
  // Features:
  // ✅ Timeout configuration
  // ✅ Comprehensive error parsing
  // ✅ Detailed logging
  // ✅ User-friendly error messages
  
  Future<Result<List<Map<String, dynamic>>>> getNotifications({
    String? notificationType,
    bool? isConfirmed,
  }) async {
    // Logs request
    logger.apiRequest('GET', endpoint, queryParameters);
    
    try {
      // Makes API call
      final response = await dio.get(...);
      
      // Logs success
      logger.apiResponse(statusCode, endpoint, 'Success');
      
      return Result.ok(data);
    } on DioException catch (e) {
      // Parses error and returns user-friendly message
      return Result.error(Exception(_parseError(e)));
    }
  }
}
```

**Key Features:**
- ✅ HTTP timeout handling (30s)
- ✅ Status code-specific error messages
- ✅ Network error detection
- ✅ Comprehensive API logging
- ✅ Result type pattern for error handling

### 3. NotificationRepository (`lib/data/notification/notification_repository.dart`)

Coordinates data operations with logging:

```dart
@riverpod
class NotificationRepository {
  Future<Result<List<Map<String, dynamic>>>> getNotifications({
    String? notificationType,
    bool? isConfirmed,
  }) async {
    logger.info('Repository: Fetching notifications', 'NOTIFICATION_REPO');
    return await remoteNotificationService.getNotifications(
      notificationType: notificationType,
      isConfirmed: isConfirmed,
    );
  }
}
```

**Responsibilities:**
- Data source coordination
- Operation logging
- Clean API for viewmodels

### 4. NotificationViewModel (`lib/viewmodel/notification_viewmodel.dart`)

Manages state and business logic with Riverpod:

```dart
@riverpod
Future<List<NotificationItem>> allNotifications(Ref ref) async {
  logger.info('Fetching all notifications', 'NOTIFICATION_VM');
  
  final repository = ref.read(notificationRepositoryProvider);
  final result = await repository.getNotifications();
  
  switch (result) {
    case Ok():
      logger.info('Successfully loaded ${result.value.length} notifications', 'NOTIFICATION_VM');
      return result.value.map(...).toList()..sort(...);
    case Error():
      logger.error('Failed to load notifications', 'NOTIFICATION_VM', result.error);
      throw Exception('Failed to load notifications: ${result.error}');
  }
}

@riverpod
class NotificationActions extends _$NotificationActions {
  Future<Result<void>> approveNotification(String notificationId) async {
    logger.info('Approving notification: $notificationId', 'NOTIFICATION_VM');
    // ... approval logic with error handling
  }
  
  Future<Result<void>> rejectNotification(String notificationId) async {
    logger.info('Rejecting notification: $notificationId', 'NOTIFICATION_VM');
    // ... rejection logic with error handling
  }
}
```

**Features:**
- ✅ Automatic state management with Riverpod
- ✅ Comprehensive logging
- ✅ Error handling with try-catch
- ✅ Automatic UI updates
- ✅ Type-safe state

## Logging System

### Log Levels

The notification system uses comprehensive logging across all layers:

```
[INFO]  - Normal operations (fetch, approve, reject)
[ERROR] - Failures and exceptions
[API]   - API requests and responses
```

### Example Log Output

```
✅ [NOTIFICATION_SERVICE]: RemoteNotificationService initialized
📤 [API_REQUEST]: GET /api/v1/notifications/ {"tenant_id": "AQUASTAR"}
✅ [API_RESPONSE]: 200 /api/v1/notifications/ Success: 5 notifications
✅ [NOTIFICATION_SERVICE]: Fetched 5 notifications
✅ [NOTIFICATION_REPO]: Repository: Fetching notifications
✅ [NOTIFICATION_VM]: Fetching all notifications
✅ [NOTIFICATION_VM]: Successfully loaded 5 notifications
```

### Error Log Example

```
❌ [API_ERROR]: 404 /api/v1/notifications/123
❌ [NOTIFICATION_SERVICE]: Failed to fetch notification 123: Notification not found
❌ [NOTIFICATION_VM]: Failed to load notifications: Notification not found
```

## Error Handling

### Three-Level Error Handling

1. **Service Level** - Parses DioException and converts to user-friendly messages
2. **Repository Level** - Logs errors and passes them up
3. **ViewModel Level** - Catches unexpected errors and provides fallbacks

### Error Message Mapping

| Error Type | User Message |
|------------|--------------|
| Timeout | "Request timed out. Please check your connection and try again." |
| Network Error | "Unable to connect to server. Please check your internet connection." |
| 401/403 | "You are not authorized to perform this action." |
| 404 | "Notification not found. It may have been already processed." |
| 500+ | "Server error occurred. Please try again later or contact support." |

### Error Flow

```
API Error
   ↓
Service._parseError() → User-friendly message
   ↓
Repository → Logs and forwards
   ↓
ViewModel → Handles and updates UI
   ↓
UI → Shows snackbar/error state
```

## Usage

### Basic Usage

```dart
// 1. Watch all notifications
final notificationsAsync = ref.watch(allNotificationsProvider);

notificationsAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(),
  data: (notifications) => ListView(...),
);

// 2. Get pending count
final count = ref.watch(notificationCountProvider);

// 3. Approve notification
final actions = ref.read(notificationActionsProvider.notifier);
final result = await actions.approveNotification(notificationId);

if (result is Ok) {
  // Show success message
} else {
  // Show error message
}
```

### Advanced Usage

```dart
// Filter by type
@riverpod
Future<List<NotificationItem>> profileUpdateNotifications(Ref ref) async {
  final notifications = await ref.watch(allNotificationsProvider.future);
  return notifications.where((n) => n.isProfileUpdate).toList();
}

// Manual refresh
ref.invalidate(allNotificationsProvider);

// Update count manually
ref.read(notificationCountProvider.notifier).updateCount(newCount);
```

## Configuration

### Environment Variables

Required in `.env`:
```env
IP_ADDR=192.168.154.166  # Backend server IP
TENANT_ID=AQUASTAR        # Tenant identifier
```

### Feature Flags

Toggle features in `NotificationConfig`:

```dart
static const bool enableFiltering = true;     // Enable filtering
static const bool enableSearch = true;         // Enable search
static const bool enableBulkActions = false;   // Bulk approve/reject
static const bool enableRealTime = false;      // WebSocket support
```

### Timeouts

```dart
static const int apiTimeoutSeconds = 30;         // API timeout
static const int autoRefreshIntervalSeconds = 60; // Auto-refresh
```

## Testing

### Manual Testing

1. **Fetch Notifications**
   ```
   Expected: List of notifications loads
   Log: "Successfully loaded X notifications"
   ```

2. **Approve Notification**
   ```
   Expected: Confirmation dialog → API call → Success snackbar → List refresh
   Log: "Notification X approved successfully"
   ```

3. **Error Handling**
   ```
   Test: Disconnect network
   Expected: "Unable to connect to server" message
   Log: Network error logged
   ```

### Debug Tips

```dart
// Enable verbose logging
const bool enableVerboseLogging = true; // in NotificationConfig

// Check current state
print(ref.read(allNotificationsProvider));

// Force refresh
ref.invalidate(allNotificationsProvider);
```

## API Reference

### Endpoints

```
GET  /api/v1/notifications/
     ?tenant_id={tenant}
     &notification_type={type}
     &is_confirmed={bool}

POST /api/v1/notifications/{id}/confirm
     ?tenant_id={tenant}
     Body: {"action": "approve" | "reject"}
```

### Response Format

```json
{
  "id": "123",
  "sender_name": "John Doe",
  "receiver_name": "Admin",
  "subject": "Area Manager",
  "notification_type": "profile_update",
  "related_data": {...},
  "is_confirmed": false,
  "created_at": "2024-12-02T10:30:00Z",
  "updated_at": "2024-12-02T10:30:00Z"
}
```

## Troubleshooting

### Common Issues

**Problem:** Notifications not loading  
**Solution:** Check backend connection, verify `.env` file, check auth token

**Problem:** "No access token found" warning  
**Solution:** Login to admin dashboard first

**Problem:** Approve/Reject fails  
**Solution:** Check logs for specific error, verify notification exists

### Debug Commands

```bash
# Check backend
curl http://192.168.154.166:8000/api/v1/

# Test notifications endpoint
curl -H "Authorization: Bearer TOKEN" \
  http://192.168.154.166:8000/api/v1/notifications/?tenant_id=AQUASTAR
```

## Best Practices

1. **Always check Result types**
   ```dart
   switch (result) {
     case Ok(): // Handle success
     case Error(): // Handle error
   }
   ```

2. **Use configuration constants**
   ```dart
   // ❌ Don't hardcode
   throw Exception('Failed to load');
   
   // ✅ Use config
   throw Exception(NotificationConfig.fetchErrorMessage);
   ```

3. **Log important operations**
   ```dart
   logger.info('Operation started', 'COMPONENT');
   // ... operation
   logger.info('Operation completed', 'COMPONENT');
   ```

4. **Handle all error cases**
   ```dart
   try {
     // Operation
   } on DioException catch (e) {
     // Parse Dio errors
   } catch (e, stackTrace) {
     // Handle unexpected errors
   }
   ```

## Future Enhancements

- [ ] Real-time notifications via WebSocket
- [ ] Bulk approve/reject actions
- [ ] Notification filtering and search
- [ ] Export notifications to CSV
- [ ] Notification categories
- [ ] Custom notification types
- [ ] Notification templates

## Support

For issues or questions:
1. Check logs in console
2. Review `AUTH_DEBUGGING_GUIDE.md`
3. Verify backend connectivity
4. Check notification count in UI

---

**Version:** 1.0.0  
**Last Updated:** December 2, 2025  
**Status:** Production Ready ✅
