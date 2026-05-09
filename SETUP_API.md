# Quick Setup Guide - API Integration

## ⚡ 5-Minute Setup

### Step 1: Update Dependencies
```bash
cd "Air Pr\Air-Pollution-"
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

### Step 3: Test API Integration
1. Wait for data to load (3-5 seconds)
2. See real air quality data
3. Swipe down to refresh
4. Check details modal

Done! ✅

## 🔍 What You Need to Know

### New Packages Added
- `http: ^1.1.0` - For API calls
- `shared_preferences: ^2.2.2` - For caching

### New File Created
- `lib/services/air_quality_service.dart` - API service

### Files Modified
- `pubspec.yaml` - Dependencies
- `lib/models/pollution_data.dart` - Added pm25, pm10 fields
- `lib/screens/home_screen.dart` - API integration with FutureBuilder

### Internet Permission
Already configured:
- ✅ Android: AndroidManifest.xml
- ✅ iOS: Info.plist

## 📱 Features to Test

### 1. Initial Load
```
Expected: Loading → Real data
Actual: [Test yourself]
```

### 2. Pull-to-Refresh
```
Steps:
1. Open app
2. Scroll to top
3. Swipe down
4. Wait for refresh

Expected: Data updates with new values
Actual: [Test yourself]
```

### 3. Offline Mode
```
Steps:
1. Load data once
2. Disable internet
3. Reopen app

Expected: Shows cached data with "Cached" label
Actual: [Test yourself]
```

### 4. Error Handling
```
Steps:
1. Disable internet
2. Tap refresh button
3. Tap retry button

Expected: Shows error UI with retry option
Actual: [Test yourself]
```

### 5. City Details
```
Steps:
1. Tap any city card
2. Scroll in modal

Expected: Shows PM2.5 and PM10 values
Actual: [Test yourself]
```

## 🛠️ Troubleshooting

### Issue: "Unresolved reference to http"
**Solution:**
```bash
flutter pub get
# If still not resolved:
rm -rf .dart_tool pubspec.lock
flutter pub get
```

### Issue: "Android error: Requires `android:usesCleartextTraffic`"
**Solution:** Already handled, ensure API uses HTTPS

### Issue: App crashes on data fetch
**Solution:** Check `flutter run -v` for error logs

### Issue: No internet but app shows sample data
**Solution:** This is correct behavior! Fallback working as intended

## 📊 Expected Behavior

### First Launch (with Internet)
```
Time: 0s    → Show splash & login screen
Time: 5s    → Show home with "Loading..." indicator  
Time: 8s    → Display real data from API
Time: 10s   → Cache data locally
```

### Second Launch (with Internet)
```
Time: 0s    → Show splash & login screen
Time: 5s    → Show home with cached data instantly
Time: 7s    → Check if cache expired
Time: 10s   → Update with fresh API data if cache old
```

### Pull-to-Refresh
```
Swipe down  → Show refresh indicator
Wait...     → API fetching
1-3 sec     → Data updates
            → Cache updates
            → Shows "Now" timestamp
```

## 🔐 No Changes to Auth

- ✅ Login screen unchanged
- ✅ Signup screen unchanged
- ✅ Navigation unchanged
- ✅ UI design unchanged
- ✅ Theme unchanged

Only the data source changed from static to API!

## ✅ Verification Steps

### 1. Verify HTTP Package
```bash
flutter pub get
# Output should show: http ^1.1.0
```

### 2. Verify SharedPreferences
```bash
flutter pub get
# Output should show: shared_preferences ^2.2.2
```

### 3. Verify Service File
```bash
# Check file exists
ls lib/services/air_quality_service.dart
# Should return the file path
```

### 4. Verify No Compile Errors
```bash
flutter analyze
# Should show 0 errors
```

### 5. Verify App Runs
```bash
flutter run
# App should launch without crashes
```

## 🌐 API Testing

### Test API Directly (Optional)
```bash
# Open a browser or terminal
curl "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=31.5204&longitude=74.3587&current=pm2_5,pm10,nitrogen_dioxide,temperature&timezone=auto"

# Should return JSON with air quality data
```

### Test Cache (Advanced)
```dart
// In home_screen.dart or anywhere, add:
import 'package:shared_preferences/shared_preferences.dart';

final prefs = await SharedPreferences.getInstance();
final keys = prefs.getKeys();
print('Cached keys: $keys');
for (var key in keys) {
  print('$key: ${prefs.getString(key)}');
}
```

## 📝 Important Notes

### ⚠️ No Breaking Changes
- All existing code still works
- UI remains the same
- Login flow unchanged
- Database not affected

### ⚠️ API Key Not Required
- Open-Meteo is completely free
- No authentication needed
- No secret keys to manage
- Public API, no private data

### ⚠️ Cache Duration
- Data cached for 1 hour
- After 1 hour, app fetches fresh data
- Cache can be manually cleared

### ⚠️ Network Timeout
- 10-second timeout per request
- Shows error if API takes too long
- Fallback to cached data automatic

### ⚠️ Fallback Chain
If API fails:
1. Uses cached data (if available)
2. Falls back to sample data (if no cache)
3. Shows error UI with retry option

## 🎯 Next Steps

### Immediate (Now)
1. ✅ Run `flutter pub get`
2. ✅ Run `flutter run`
3. ✅ Test all features above

### Short Term (This Week)
1. Test on physical device
2. Test on both Android/iOS
3. Test with slow internet
4. Test offline mode

### Long Term (Next Updates)
1. Add real location detection
2. Add auto-refresh
3. Add weather data
4. Add notifications

## 🎓 Code Review

If you want to understand the code:

### Service File Structure
```
air_quality_service.dart
├── fetchCityAirQuality()        ← Main public method
├── fetchAllCitiesAirQuality()   ← Convenience method
├── _fetchFromAPI()              ← Private API call
├── _parseAirQualityResponse()   ← Private parsing
├── _calculateAQI()              ← Private calculation
├── _getCachedData()             ← Private cache read
├── _cacheData()                 ← Private cache write
└── clearCache()                 ← Public cache clear
```

### Home Screen Changes
```
home_screen.dart
├── Added: import '../services/air_quality_service.dart'
├── Changed: _pollutionDataFuture instead of static data
├── Added: FutureBuilder for async data
├── Added: _buildErrorState() for error UI
├── Added: _buildEmptyState() for empty state
├── Updated: PM2.5, PM10 in detail grid
└── Added: RefreshIndicator for pull-to-refresh
```

## 🚀 Common Commands

```bash
# Clean and reinstall
flutter clean
flutter pub get
flutter run

# Run with verbose output
flutter run -v

# Run on specific device
flutter devices
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Analyze code
flutter analyze
dart analyze lib/

# Format code
dart format lib/

# Check for issues
flutter doctor
```

## 📚 Documentation

For detailed information, read:

1. **API_INTEGRATION.md**
   - Complete integration guide
   - Code examples
   - Troubleshooting

2. **UPGRADE_SUMMARY.md**
   - What changed
   - Architecture overview
   - Testing checklist

3. **QUICK_REFERENCE.md**
   - Code patterns
   - Navigation guide
   - Useful snippets

## ✨ Summary

**What's new:**
- ✅ Real API integration
- ✅ Live data fetching
- ✅ Smart caching
- ✅ Pull-to-refresh
- ✅ Error handling
- ✅ PM2.5/PM10 data

**What's unchanged:**
- ✅ UI design
- ✅ Theme colors
- ✅ Navigation
- ✅ Auth flow
- ✅ Static data (fallback)

**Get started:**
```bash
flutter pub get
flutter run
```

**That's it!** 🎉

Your app now has real-time air quality data powered by a free API.

Happy coding! 🚀
