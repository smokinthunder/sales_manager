# Testing Guide - Data Integration

## Pre-requisites

### 1. Backend Setup
Ensure all Docker containers are running:
```bash
cd /home/antesh/Desktop/sales_manager
docker-compose ps
```

Expected output: All services should be "Up" and "healthy"
- `sales_manager_backend` - Port 8000
- `sales_manager_data_layer` - Port 8001  
- `sales_manager_mysql` - Port 3307
- `sales_manager_redis` - Port 6379
- `sales_manager_mock_client_api` - Port 8002

### 2. Database Seeding
Seed the database with test data:
```bash
cd /home/antesh/Desktop/sales_manager
./seed.sh
```

This creates test users:
- **SUPERADMIN**: +1234567890
- **CLIENT_ADMIN**: +1111111111 (AquaStar Admin)
- **AREA_MANAGER**: +1111111112 (AquaStar North Manager)
- **SALES_EXECUTIVE**: +1111111121 (Alex Thompson)

### 3. Flutter App Setup
Ensure dependencies are installed:
```bash
cd /home/antesh/Desktop/sales_manager/admin_dashboard
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

---

## Testing Procedure

### Phase 1: API Connectivity Tests

#### Test 1.1: Backend Health Check
```bash
curl http://localhost:8000/health
curl http://localhost:8001/health
```
Expected: `{"status": "healthy", ...}` for both

#### Test 1.2: Authentication Flow
```bash
# Request OTP
curl -X POST http://localhost:8001/api/v1/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1111111121"}'

# Check logs for OTP (in development mode)
docker-compose logs backend | grep "OTP"

# Verify OTP
curl -X POST http://localhost:8001/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1111111121", "otp": "123456"}'

# Save the access_token from response for next tests
```

#### Test 1.3: Users API
```bash
# Get all users
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     http://localhost:8001/api/v1/users/

# Get sales executives
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     "http://localhost:8001/api/v1/users/?role=sales_executive&status=active"

# Get area managers
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     "http://localhost:8001/api/v1/users/?role=area_manager&status=active"
```

Expected: JSON response with user data including id, name, phone, role, status

#### Test 1.4: Shops API
```bash
# Get all shops
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     "http://localhost:8001/api/v1/shops/?status=active"
```

Expected: JSON response with shop data including id, name, address, status

#### Test 1.5: Analytics API
```bash
# Get dashboard stats
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     http://localhost:8001/api/v1/analytics/dashboard

# Get top customers
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     "http://localhost:8001/api/v1/analytics/executive/top_customers?executive_id=1&period=7"

# Get best selling products
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     "http://localhost:8001/api/v1/analytics/executive/best_selling_products?executive_id=1&period=7"

# Get sales report
curl -H "X-Tenant-ID: AQUASTAR" \
     -H "Authorization: Bearer YOUR_TOKEN" \
     "http://localhost:8001/api/v1/analytics/executive/sales_report?executive_id=1&period=7"
```

---

### Phase 2: UI Testing

#### Test 2.1: Authentication in Flutter App
1. Launch the Flutter admin dashboard app
2. Login using test credentials:
   - Phone: +1111111111 (CLIENT_ADMIN)
   - OTP: Check backend logs or use 123456 in development
3. Verify successful login and navigation to dashboard

Expected:
- ✅ Login successful
- ✅ Redirect to dashboard
- ✅ User session stored

#### Test 2.2: Dashboard Screen
**Navigate to:** Dashboard (home screen)

**Test Cases:**
1. **Count Displays:**
   - Total Executives count should show real number (not "100")
   - Total Customers count should show real number (not "15489")
   - New Customers count should show real number (not "20")

2. **Loading States:**
   - On first load, should show "..." while fetching
   - Should transition to real numbers

3. **Error Handling:**
   - Stop backend: `docker-compose stop backend`
   - Refresh app
   - Should show "0" or error message in counts
   - Restart backend: `docker-compose start backend`

**Pass Criteria:**
- ✅ Counts update with real data from API
- ✅ Loading indicator shows during fetch
- ✅ Error state shows when backend is down
- ✅ Data recovers when backend restarts

#### Test 2.3: Area Manager Screen
**Navigate to:** Area Manager section

**Test Cases:**
1. **Count Displays:**
   - Total Area Managers should show real count
   - New Area Managers should show real count

2. **List Display:**
   - Should show list of real area managers (not 1000 dummy cards)
   - Each card should show real data: name, phone, email

3. **Search Functionality:**
   - Type in search box: "Kumar" or any manager name
   - List should filter in real-time
   - Clear search, list should show all managers again

4. **Loading State:**
   - Should show CircularProgressIndicator on first load

5. **Error State:**
   - Stop backend
   - Refresh screen
   - Should show error message with icon

**Pass Criteria:**
- ✅ Real area manager data displayed
- ✅ Search filters correctly
- ✅ Loading/error states work
- ✅ No hardcoded data visible

#### Test 2.4: Find Executive Screen
**Navigate to:** Area Manager → Find Executive

**Test Cases:**
1. **List Display:**
   - Should show real sales executives (not 100,000 dummy entries)
   - Each entry shows: name, phone, email

2. **Search Functionality:**
   - Search by name: "Alex" or "Thompson"
   - Search by phone: "+1111" or similar
   - Search by email
   - Results filter in real-time

3. **Data Accuracy:**
   - Verify displayed names match backend data
   - Verify phone numbers are correctly formatted
   - Verify email addresses are shown

**Pass Criteria:**
- ✅ Real executive data displayed
- ✅ Search works across name/phone/email
- ✅ No lag with large datasets
- ✅ Loading/error states functional

#### Test 2.5: Find Dealers Screen
**Navigate to:** Executive → Find Dealers

**Test Cases:**
1. **List Display:**
   - Should show real shops (not 100,000 dummy cards)
   - Each ShopStateCard shows:
     - ✅ Real shop name
     - ✅ Real shop location/address
     - ⚠️ executiveName: "N/A" (expected - needs backend API)
     - ⚠️ executivePhoneNo: "N/A" (expected - needs backend API)
     - ⚠️ orderReceived: false (expected - needs orders API)
     - ⚠️ shopVisited: false (expected - needs visits API)

2. **Search Functionality:**
   - Search by shop name: "Kerala" or similar
   - Search by location
   - Results filter correctly

3. **Data Verification:**
   - Shop names are real
   - Addresses/locations are real
   - Cards are clickable

**Pass Criteria:**
- ✅ Real shop data displayed
- ✅ Search works correctly
- ⚠️ N/A fields are expected (documented in MISSING_BACKEND_APIS.md)
- ✅ Loading/error states work

#### Test 2.6: Executive Screen
**Navigate to:** Executive section

**Test Cases:**
1. **Count Displays:**
   - Total Executives should show real count (not "100")
   - New Executives shows "0" (expected - backend needs this field)

2. **Executive Cards:**
   - Should show real executives (not 10,000 dummy cards)
   - Each ExecutiveCard shows:
     - ✅ Real executive name
     - ✅ Real phone number
     - ⚠️ Manager name: "N/A" (expected - needs relationship API)
     - ⚠️ Location: "N/A" (expected - needs territory API)

3. **Search Functionality:**
   - Search by executive name
   - Search by phone number
   - Search by email
   - Results filter in real-time

4. **Navigation:**
   - Click "Find Dealers" button → should navigate
   - Click "Add Special Route" button → should navigate

**Pass Criteria:**
- ✅ Real executive data in cards
- ✅ Search works across fields
- ⚠️ N/A fields are expected
- ✅ Navigation buttons work
- ✅ Loading/error states functional

#### Test 2.7: Orders Screen (Expected to Fail)
**Navigate to:** Orders section

**Expected Behavior:**
- ❌ Still shows hardcoded data (count: "100", "15")
- ❌ Still shows 10,000 dummy order cards
- ❌ Search doesn't work with real data
- ℹ️ This is expected - no orders API available yet

**Documented in:** MISSING_BACKEND_APIS.md (HIGH PRIORITY)

---

### Phase 3: Performance Testing

#### Test 3.1: Large Dataset Handling
1. Ensure database has 100+ users, 100+ shops
2. Navigate to each screen
3. Verify:
   - No lag in loading
   - Smooth scrolling
   - Search is responsive
   - Pagination works (SafePaginatedCardGrid)

#### Test 3.2: Search Performance
1. Load screen with many items
2. Type quickly in search box
3. Verify:
   - Results update without lag
   - No visible flicker
   - Debouncing works (if implemented)

#### Test 3.3: Network Conditions
1. **Slow Network:**
   - Throttle network in DevTools
   - Verify loading indicators show
   - Verify timeout handling (30 seconds)

2. **No Network:**
   - Disconnect network
   - Verify error messages appear
   - Reconnect network
   - Verify data recovers

3. **Intermittent Connection:**
   - Toggle network on/off
   - Verify app handles gracefully

---

### Phase 4: Error Handling Tests

#### Test 4.1: Authentication Errors
1. Login with invalid credentials
2. Verify error message shown
3. Try expired token
4. Verify re-authentication prompt

#### Test 4.2: API Errors
1. **404 Not Found:**
   - Request non-existent user ID
   - Verify error handling

2. **500 Server Error:**
   - Simulate server error
   - Verify error message displayed

3. **Timeout:**
   - Simulate slow API (>30s)
   - Verify timeout error shown

#### Test 4.3: Data Validation
1. Empty response from API
2. Malformed JSON response
3. Missing required fields
4. Verify app doesn't crash, shows appropriate error

---

### Phase 5: State Management Tests

#### Test 5.1: Provider Caching
1. Navigate to Dashboard
2. Note the data displayed
3. Navigate to another screen
4. Return to Dashboard
5. Verify: Data loads from cache (instant), then refreshes

#### Test 5.2: Provider Invalidation
1. Load user list
2. Perform action that changes data (if available)
3. Verify list updates automatically

#### Test 5.3: Multi-Screen State
1. Open Area Manager screen
2. Note area manager count
3. Open Find Executive screen
4. Return to Area Manager
5. Verify state preserved

---

## Test Results Template

### Test Execution: [Date]

**Environment:**
- Backend: Running ✅ / Not Running ❌
- Database: Seeded ✅ / Empty ❌
- Flutter App: Version _____

**Test Results:**

| Test ID | Test Name | Status | Notes |
|---------|-----------|--------|-------|
| 1.1 | Backend Health | ✅ ⚠️ ❌ | |
| 1.2 | Authentication | ✅ ⚠️ ❌ | |
| 1.3 | Users API | ✅ ⚠️ ❌ | |
| 1.4 | Shops API | ✅ ⚠️ ❌ | |
| 1.5 | Analytics API | ✅ ⚠️ ❌ | |
| 2.1 | App Authentication | ✅ ⚠️ ❌ | |
| 2.2 | Dashboard Screen | ✅ ⚠️ ❌ | |
| 2.3 | Area Manager Screen | ✅ ⚠️ ❌ | |
| 2.4 | Find Executive Screen | ✅ ⚠️ ❌ | |
| 2.5 | Find Dealers Screen | ✅ ⚠️ ❌ | |
| 2.6 | Executive Screen | ✅ ⚠️ ❌ | |
| 2.7 | Orders Screen | ❌ | Expected - no API |
| 3.1 | Large Dataset | ✅ ⚠️ ❌ | |
| 3.2 | Search Performance | ✅ ⚠️ ❌ | |
| 3.3 | Network Conditions | ✅ ⚠️ ❌ | |
| 4.1 | Auth Errors | ✅ ⚠️ ❌ | |
| 4.2 | API Errors | ✅ ⚠️ ❌ | |
| 4.3 | Data Validation | ✅ ⚠️ ❌ | |
| 5.1 | Provider Caching | ✅ ⚠️ ❌ | |
| 5.2 | Provider Invalidation | ✅ ⚠️ ❌ | |
| 5.3 | Multi-Screen State | ✅ ⚠️ ❌ | |

**Summary:**
- Total Tests: 20
- Passed: ___
- Failed: ___
- Warnings: ___

**Known Issues:**
1. Orders screen not updated (expected - no backend API)
2. Some fields show "N/A" (expected - documented in MISSING_BACKEND_APIS.md)

**Recommendations:**
- [ ] Implement missing backend APIs
- [ ] Add server-side search
- [ ] Implement real-time updates
- [ ] Add offline support

---

## Debugging Tips

### Issue: "No data showing"
**Solutions:**
1. Check backend is running: `docker-compose ps`
2. Check database has data: `docker-compose exec mysql mysql -u root -prootpassword aquastar -e "SELECT COUNT(*) FROM users;"`
3. Check authentication token is valid
4. Check browser console / Flutter logs for errors

### Issue: "Authentication failed"
**Solutions:**
1. Clear app storage/cache
2. Re-login with valid credentials
3. Check backend logs: `docker-compose logs backend | grep auth`
4. Verify TENANT_ID header is set correctly

### Issue: "Loading forever"
**Solutions:**
1. Check network connectivity
2. Check API timeout (30s)
3. Check backend logs for errors
4. Verify API endpoint exists

### Issue: "Search not working"
**Solutions:**
1. Verify _searchQuery state is updating
2. Check setState is being called
3. Verify filter logic is correct
4. Check for null values in data

### Issue: "App crashes"
**Solutions:**
1. Check Flutter console for stack trace
2. Verify all required fields in JSON response
3. Check for null safety violations
4. Verify fromJson methods handle missing fields

---

## Performance Benchmarks

### Target Metrics:
- **Initial Load:** < 2 seconds
- **Search Response:** < 100ms
- **List Scroll:** 60 FPS
- **API Response:** < 500ms
- **Error Recovery:** < 1 second

### Monitoring:
```dart
// Add performance logging in providers
final stopwatch = Stopwatch()..start();
// ... fetch data ...
logger.info('Data fetched in ${stopwatch.elapsedMilliseconds}ms');
```

---

## Next Steps After Testing

1. **If tests pass:**
   - ✅ Mark data integration as complete
   - 📝 Update project documentation
   - 🚀 Deploy to staging environment

2. **If tests fail:**
   - 🐛 Debug and fix issues
   - 🔄 Re-run failed tests
   - 📋 Document any workarounds

3. **Known limitations:**
   - 📝 Create JIRA tickets for missing backend APIs
   - 🎯 Prioritize: Orders API, Shop-Executive Assignment, Visit Tracking
   - 📅 Plan implementation timeline

---

**Test Document Version:** 1.0  
**Last Updated:** 2024  
**Status:** Ready for Testing
