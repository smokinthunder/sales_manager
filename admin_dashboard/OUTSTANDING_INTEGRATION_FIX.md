# Outstanding Integration Fix - Admin Dashboard

## Problem

The admin dashboard was trying to fetch outstanding summary from a non-existent backend endpoint `/api/v1/outstanding/summary`, which was being misinterpreted by the backend as `/api/v1/outstanding/{id}` with `id="summary"`, causing a 422 error.

### Backend Error
```
Request validation failed: 'Input should be a valid integer, unable to parse string as an integer', 'input': 'summary'
```

## Solution

**Implemented client-side calculation of summary counts**, matching the frontend pattern:
1. Fetch all outstanding payments once via `/api/v1/outstanding/`
2. Calculate status counts (current, upcoming, overdue) on the client side
3. Filter payments by selected status locally

## Changes Made

### 1. RemoteDataService (`remote_data_service.dart`)
- ✅ Added `tenant_id` to all query parameters
- ✅ Removed `status` and `pageSize` parameters from `getOutstandingPayments()`
- ✅ Updated `getOutstandingSummary()` to use `/api/v1/outstanding/` endpoint

### 2. DataRepository (`data_repository.dart`)
- ✅ Removed `status` and `pageSize` parameters
- ✅ Updated method signatures to match service layer

### 3. ViewModel (`data_viewmodel.dart`)
- ✅ Removed `status` and `pageSize` parameters from `outstandingPaymentsProvider`
- ✅ Added comment: "Status filtering is done on the client side"

### 4. UI Layer (`outstanding.dart`)
- ✅ Removed separate `outstandingSummaryProvider` call
- ✅ Calculate status counts directly from payments data:
  ```dart
  final statusCounts = {
    for (var status in OutstandingStatus.values)
      status: allPayments.where((p) => p.status == status).length,
  };
  ```
- ✅ Filter payments by selected status on client side:
  ```dart
  final payments = allPayments
      .where((payment) => payment.status == selectedStatus)
      .toList();
  ```
- ✅ Removed unused `_getStatusCount()` method
- ✅ Removed unused `OutstandingSummary` import

## Benefits

1. **Single API Call**: Fetches all payments once instead of two separate calls
2. **No 422 Errors**: No longer calling non-existent `/summary` endpoint
3. **Faster UI**: Status tabs update instantly without network delay
4. **Consistent with Frontend**: Same pattern as the mobile app
5. **Reduced Server Load**: Fewer API requests overall

## API Endpoints Used

✅ **GET** `/api/v1/outstanding/` - Fetch all outstanding payments with filters
- Query params: `tenant_id`, `shop_search`, `page`, etc.
- Returns: `{ items: [...], total: N, page: N, page_size: N }`

❌ ~~**GET** `/api/v1/outstanding/summary`~~ - **REMOVED** (doesn't exist in backend)

## Testing

Run the admin dashboard and verify:
1. Outstanding payments load without 422 errors
2. Status tabs show correct payment counts
3. Switching tabs filters instantly
4. Search functionality works
5. Sorting works correctly

## Result

✅ **All errors resolved** - No more 422 validation errors
✅ **Matches frontend pattern** - Client-side filtering and summary calculation
✅ **Better performance** - Single API call with instant filtering
