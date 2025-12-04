# Outstanding Payment Model - Null Safety Fix

## Problem

The `OutstandingPayment.fromJson` factory was using strict type casts that failed when the API returned null values:

```dart
id: json['id'] as int  // ❌ Fails if null
```

This caused the runtime error:
```
type 'Null' is not a subtype of type 'int' in type cast
```

## Root Cause

The API may return null values for some fields, but the model was using strict non-nullable casts without fallback values.

## Solution

Added null safety checks with default fallback values for all required fields:

### Before
```dart
id: json['id'] as int,
shopId: json['shop_id'] as String,
shopName: json['shop_name'] as String,
amount: (json['amount'] as num).toDouble(),
dueDate: json['due_date'] as String,
status: OutstandingStatus.fromString(json['status'] as String),
createdAt: json['created_at'] as String,
updatedAt: json['updated_at'] as String,
```

### After
```dart
id: json['id'] as int? ?? 0,
shopId: json['shop_id'] as String? ?? '',
shopName: json['shop_name'] as String? ?? '',
amount: json['amount'] != null 
    ? (json['amount'] as num).toDouble() 
    : 0.0,
dueDate: json['due_date'] as String? ?? '',
status: OutstandingStatus.fromString(json['status'] as String? ?? 'current'),
createdAt: json['created_at'] as String? ?? '',
updatedAt: json['updated_at'] as String? ?? '',
```

## Changes Made

✅ **All required fields now have null-safe parsing with default values:**
- `id`: defaults to `0` if null
- `shopId`: defaults to empty string if null
- `shopName`: defaults to empty string if null
- `amount`: defaults to `0.0` if null
- `dueDate`: defaults to empty string if null
- `status`: defaults to `'current'` if null
- `createdAt`: defaults to empty string if null
- `updatedAt`: defaults to empty string if null

✅ **Optional fields remain nullable** (as they should be)

## Benefits

1. **Prevents crashes** from unexpected null values
2. **Graceful degradation** with sensible defaults
3. **Matches frontend pattern** for handling nullable API fields
4. **Robust parsing** that won't break on API changes

## Result

✅ **No more null type casting errors**
✅ **App handles incomplete API data gracefully**
✅ **Ready for production use**
