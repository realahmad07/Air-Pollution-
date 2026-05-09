# API Integration - Testing & Verification Checklist

## 🚀 Pre-Launch Verification

### Step 1: Dependencies Check ✅

Run this command:
```bash
flutter pub get
```

Expected output:
```
Running "flutter pub get" in Air-Pollution-...
Process finished with exit code 0
```

Check pubspec.lock has these packages:
```bash
# Should contain:
http: ^1.1.0
shared_preferences: ^2.2.2
```

### Step 2: Code Analysis ✅

Run this command:
```bash
flutter analyze
# or
dart analyze lib/
```

Expected output:
```
0 issues found!
```

If there are issues:
```bash
flutter clean
flutter pub get
flutter analyze
```

### Step 3: App Build ✅

Run this command:
```bash
flutter run
```

Expected output:
```
Running lib/main.dart on [Device]...
✓ Built [app]
✓ Synced [time]ms
```

## 📱 Functional Testing

### Test 1: Initial Launch (Network Available)

**Steps:**
1. Ensure device has internet
2. Run `flutter run`
3. Wait for splash screen
4. See login screen
5. Login (any email/password)
6. Wait for home screen

**Expected Results:**
- ✓ Splash shows for 3 seconds
- ✓ Login form appears
- ✓ Home screen shows "Loading..." indicator
- ✓ After 3-5 seconds, real air quality data appears
- ✓ Shows actual PM2.5 values from API
- ✓ Shows "Now" as last updated time
- ✓ Data is cached locally

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 2: Pull-to-Refresh (Network Available)

**Steps:**
1. App showing data
2. Scroll to top of list
3. Swipe downward (pull-to-refresh gesture)
4. Wait for refresh

**Expected Results:**
- ✓ Shows refresh indicator (spinning circle)
- ✓ Data fetches from API (1-3 seconds)
- ✓ Values may change (live data)
- ✓ Timestamp updates to "Now"
- ✓ Smooth refresh animation

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 3: Offline Mode (No Network)

**Steps:**
1. App showing data
2. Disconnect device from internet
3. Pull to refresh
4. Observe behavior

**Expected Results:**
- ✓ Shows error state OR cached data
- ✓ If cached: shows "Cached" label
- ✓ If no cache: shows retry button
- ✓ Shows user-friendly error message
- ✓ Doesn't crash

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 4: Error Handling (Simulate API Failure)

**Steps:**
1. Disable internet on device
2. Logout and login again (clears cache or not)
3. Try to refresh with no internet
4. See error UI
5. Tap "Retry" button
6. Enable internet
7. Tap "Retry" again

**Expected Results:**
- ✓ Shows error state with message
- ✓ Shows "Retry" button
- ✓ Retry button enables/disables correctly
- ✓ After enabling internet, data loads
- ✓ No crashes or exceptions

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 5: City Details Modal

**Steps:**
1. App showing cities list
2. Tap any city card
3. Modal appears from bottom
4. Scroll in modal

**Expected Results:**
- ✓ City name appears
- ✓ Country shows "Pakistan"
- ✓ Shows AQI value
- ✓ Shows pollution status
- ✓ Shows temperature
- ✓ Shows humidity
- ✓ **Shows PM2.5 value**
- ✓ **Shows PM10 value**
- ✓ Shows latitude/longitude
- ✓ Modal scrollable
- ✓ Close by swiping down

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 6: All 5 Cities Load

**Steps:**
1. Home screen loaded
2. Observe cities in list
3. Tap each city

**Expected Results:**
- ✓ Lahore loads with real data
- ✓ Karachi loads with real data
- ✓ Islamabad loads with real data
- ✓ Rawalpindi loads with real data
- ✓ Peshawar loads with real data
- ✓ All have PM2.5/PM10 values
- ✓ All have temperature/humidity

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 7: Cache Duration (Advanced)

**Steps:**
1. Load app with internet
2. Note the time
3. Wait 1+ hour
4. Reopen app
5. Note if data refreshes

**Expected Results:**
- ✓ After 1 hour, app fetches fresh data
- ✓ Shows loading briefly
- ✓ Updates with new values
- ✓ Cache automatically expires

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 8: Screen Rotation

**Steps:**
1. App showing data
2. Rotate device (portrait ↔ landscape)
3. Check data still visible

**Expected Results:**
- ✓ Data preserved
- ✓ Layout adjusts
- ✓ No API re-fetch
- ✓ Smooth rotation

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 9: App Lifecycle

**Steps:**
1. Open app
2. Load data
3. Close app
4. Reopen app

**Expected Results:**
- ✓ Data loads instantly from cache
- ✓ No loading indicator (or very brief)
- ✓ Shows cached data immediately
- ✓ Background apps don't interfere

**Actual Results:**
```
[Test yourself and note the results]
```

---

### Test 10: Bottom Navigation

**Steps:**
1. Home tab visible
2. Tap Search tab
3. Tap Alerts tab
4. Tap Settings tab
5. Tap Home tab

**Expected Results:**
- ✓ Shows "Coming soon" messages
- ✓ Home tab works normally
- ✓ Navigation doesn't affect data
- ✓ Data persists between tabs

**Actual Results:**
```
[Test yourself and note the results]
```

---

## 🔍 Code Verification

### Verify Service File Exists
```bash
# Command
ls -la lib/services/air_quality_service.dart

# Expected output
-rw-r--r--  1 user  staff  12345 May 09 12:00 lib/services/air_quality_service.dart
```

### Verify PollutionData Model Updated
```bash
# Command
grep -n "pm25\|pm10" lib/models/pollution_data.dart

# Expected output
10:  final double pm25;
11:  final double pm10;
[and more matches]
```

### Verify Home Screen Updated
```bash
# Command
grep -n "FutureBuilder\|RefreshIndicator\|AirQualityService" lib/screens/home_screen.dart

# Expected output
[multiple matches showing API integration]
```

### Verify Pubspec Updated
```bash
# Command
grep -n "http:\|shared_preferences:" pubspec.yaml

# Expected output
15:  http: ^1.1.0
16:  shared_preferences: ^2.2.2
```

## 📊 Performance Testing

### Load Time Measurement

**Test 1: Cold Start (First Launch)**
```
Start time: [Note your time]
App shows splash: [Duration]
Login screen appears: [Duration]
After login, show home: [Duration]
Data finishes loading: [Duration]
Total time: [___] seconds

Expected: 8-10 seconds
```

**Test 2: Warm Start (Re-open)**
```
Start time: [Note your time]
App shows splash: [Duration]
Login screen appears: [Duration]
After login, show home: [Duration]
Data shows from cache: [Duration]
Total time: [___] seconds

Expected: 3-5 seconds
```

**Test 3: Pull-to-Refresh Time**
```
Start refresh: [Note your time]
Show loading indicator: [Duration]
API responds: [Duration]
Data updates: [Duration]
Total time: [___] seconds

Expected: 1-3 seconds
```

## 🐛 Debugging Tips

### Check Network Logs
```bash
flutter run -v | grep -i "http\|network\|request"
```

### Check Cache Contents
```dart
// Add this to home_screen.dart temporarily
import 'package:shared_preferences/shared_preferences.dart';

// In build method:
final prefs = await SharedPreferences.getInstance();
final keys = prefs.getKeys();
print('Cache keys: $keys');
keys.forEach((key) {
  if (key.startsWith('aqi_cache_')) {
    print('$key: ${prefs.getString(key)}');
  }
});
```

### Enable Debug Prints
```bash
# In terminal
flutter run -v | grep -i "debug\|print"
```

### Test API Directly
```bash
# Replace with your latitude/longitude
curl "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=31.5204&longitude=74.3587&current=pm2_5,pm10,nitrogen_dioxide,temperature&timezone=auto"

# Should return JSON like:
# {"current":{"pm2_5":45.5,"pm10":60.2,...}}
```

## ✅ Checklist Template

Print this and check off as you complete tests:

```
[ ] Dependencies installed (flutter pub get)
[ ] No compile errors (flutter analyze)
[ ] App launches without crashes
[ ] Initial data loads in 3-5 seconds
[ ] Shows real PM2.5/PM10 values
[ ] Pull-to-refresh works
[ ] Offline mode shows cached data
[ ] Error UI shows on no internet
[ ] Retry button works
[ ] All 5 cities load data
[ ] City details show PM values
[ ] Screen rotation works
[ ] App lifecycle works
[ ] Navigation doesn't break data
[ ] Cache expires after 1 hour
[ ] Load time < 10 seconds (first)
[ ] Load time < 5 seconds (warm)
[ ] Refresh time < 3 seconds
```

## 🎯 Sign-Off

**When all tests pass, you can:**
- ✅ Deploy to Play Store
- ✅ Share with beta testers
- ✅ Merge to main branch
- ✅ Create release build

**Before deploying:**
1. ✅ All tests pass
2. ✅ No error logs
3. ✅ Performance acceptable
4. ✅ UI looks good
5. ✅ No hardcoded test data

## 📝 Test Results Template

```markdown
# Test Results - [Date]

## Functional Tests
- Initial Launch: PASS / FAIL
- Pull-to-Refresh: PASS / FAIL
- Offline Mode: PASS / FAIL
- Error Handling: PASS / FAIL
- City Details: PASS / FAIL
- All Cities: PASS / FAIL

## Performance Tests
- Cold Start: ___ seconds
- Warm Start: ___ seconds
- Refresh Time: ___ seconds

## Code Verification
- Service file exists: YES / NO
- Model updated: YES / NO
- Home screen updated: YES / NO
- Pubspec updated: YES / NO

## Issues Found
[List any issues here]

## Sign-Off
Date: ___
Tester: ___
Status: READY / NOT READY
```

---

**You're all set!** 🎉

Go ahead and run the tests. If you encounter any issues, check **API_INTEGRATION.md** for detailed troubleshooting.

Happy testing! 🚀
