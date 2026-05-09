# Development & Debugging Guide

## 🔧 Development Setup

### Initial Setup
```bash
# 1. Verify Flutter installation
flutter doctor

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run
```

### IDE Setup

#### VS Code
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    }
  ]
}
```

#### Android Studio
- File → Open → Select project folder
- Wait for indexing to complete
- Run button → Select device → Run

## 🐛 Debugging Tips

### Enable Debug Logging
```dart
debugPrint('Message: $variable');
```

### Inspect Widget Tree
```bash
flutter run -v  # Verbose mode
```

### Check Device Logs
```bash
adb logcat  # Android
# or
flutter logs
```

### Performance Profiling
```bash
# Run with performance tracking
flutter run --profile

# Check frame rate and jank
# Use DevTools: http://localhost:9100
```

### Enable Null Safety Strict Mode
Add to `pubspec.yaml`:
```yaml
environment:
  sdk: '>=3.0.0 <4.0.0'
```

## 📋 Common Issues & Solutions

### Issue 1: App Won't Start
**Error:** "Exception: Unable to locate Dart executable"

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### Issue 2: Widget Not Updating
**Problem:** `setState()` called but widget not rebuilding

**Solution:**
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _buildBody(),  // Call method to rebuild
  );
}

void _buildBody() {
  return Column(
    children: [/* Updated content */],
  );
}
```

### Issue 3: Hot Reload Not Working
**Error:** "Hot reload triggered but not applied"

**Solution:**
```bash
# Press 'r' for hot reload
# Press 'R' for full restart
# Or manually restart:
flutter run
```

### Issue 4: Form Validation Not Working
**Check:**
```dart
// Ensure form key is assigned
Form(
  key: _formKey,  // Must not be null
  child: Column(
    children: [/* fields */],
  ),
)
```

### Issue 5: Navigator Errors
**Error:** "NavigatorObserver didPush called"

**Solution:**
```dart
// Check route names in main.dart
routes: {
  '/home': (context) => const HomeScreen(),
  // Add all routes
}
```

### Issue 6: Widget Build Performance
**Issue:** Excessive rebuilds causing jank

**Solution:**
```dart
// Use const constructors
const MyWidget()

// Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// Avoid building expensive widgets in build()
// Extract to separate methods or classes
```

### Issue 7: Memory Issues
**Symptom:** App crashes on large data sets

**Solution:**
```dart
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// Use ListView.builder instead of ListView
// Unload unused resources
```

### Issue 8: Text Field Overflow
**Error:** "A RenderFlex overflowed"

**Solution:**
```dart
// Wrap in Expanded
Row(
  children: [
    Expanded(
      child: TextField(),
    ),
  ],
)

// Or use SingleChildScrollView
SingleChildScrollView(
  child: Column(
    children: [/* content */],
  ),
)
```

## 🔍 Debugging Features

### Flutter DevTools
```bash
# Start DevTools
flutter pub global activate devtools
devtools

# Or use VS Code debugger (auto-launches)
# F5 to start debugging
```

### Device Inspector
```bash
# Open DevTools when app is running
# Use the Widget Inspector to:
# - Inspect widget tree
# - View layout constraints
# - Check widget properties
# - Track widget rebuilds
```

### Performance Profiler
In DevTools:
1. Open "Performance" tab
2. Record a frame
3. Check for jank (frame rate dips)
4. Identify expensive widgets

### Memory Profiler
In DevTools:
1. Open "Memory" tab
2. Trigger garbage collection
3. Look for memory leaks
4. Check heap size

## 🧪 Testing

### Run Unit Tests
```bash
flutter test test/unit_test.dart
flutter test --coverage  # With coverage
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Test a Single Screen
```dart
testWidgets('Login screen test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Verify widgets exist
  expect(find.text('Welcome Back'), findsOneWidget);
  expect(find.byType(TextField), findsWidgets);
  
  // Interact
  await tester.enterText(find.byType(TextField).first, 'test@email.com');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  // Verify
  expect(find.byType(HomeScreen), findsOneWidget);
});
```

## 📊 Monitoring Performance

### Frame Rate Analysis
```bash
# Expected: 60 FPS (16.67ms per frame)

# Check in DevTools:
# - Frame time
# - Rendering time
# - Rasterizing time
```

### CPU Usage
```bash
# Monitor with:
adb shell top | grep flutter
```

### Battery Usage
```bash
# Monitor with:
adb shell dumpsys batterystats
```

## 🔐 Security Checklist

- [ ] No hardcoded credentials
- [ ] No API keys in code
- [ ] Validate all user inputs
- [ ] Use HTTPS for API calls
- [ ] Implement proper error handling
- [ ] Don't log sensitive data
- [ ] Use SecureStorage for tokens
- [ ] Implement certificate pinning

## 📱 Device Testing

### Android Testing
```bash
# List devices
adb devices

# Install APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Uninstall
adb uninstall com.example.app

# Clear app data
adb shell pm clear com.example.app

# View logs
adb logcat | grep flutter
```

### iOS Testing
```bash
# List devices
xcrun instruments -s devices

# Run on device
open -a Simulator
flutter run -d <device-id>

# View logs
log stream --predicate 'process == "Flutter"'
```

## 🎯 Optimization Tips

### Reduce Build Time
```bash
flutter run --split-per-abi  # Android
flutter run --no-codesign    # iOS (dev)
```

### Optimize App Size
```bash
# Build APK with optimization
flutter build apk --split-per-abi

# Check build output
flutter build apk --analyze-size

# Enable code shrinking (ProGuard/R8)
# In android/app/build.gradle:
buildTypes {
  release {
    shrinkResources true
    minifyEnabled true
  }
}
```

### Improve Runtime Performance
```dart
// Use const constructors
const MyWidget()

// Use const lists/maps
const items = [1, 2, 3];

// Avoid rebuilds with const
const SizedBox(height: 16)

// Use with Expanded and Flexible
Expanded(child: widget)
Flexible(child: widget)

// Cache expensive operations
late final expensive = computeExpensive();
```

## 🚀 Release Checklist

### Before Building for Release
- [ ] Update version in `pubspec.yaml`
- [ ] Update app icons
- [ ] Update splash screen
- [ ] Run all tests
- [ ] Check performance
- [ ] Remove debug prints
- [ ] Review all strings (i18n ready)
- [ ] Check permissions (AndroidManifest.xml)
- [ ] Sign release keystore (Android)
- [ ] Create release certificate (iOS)

### Build Commands
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📝 Log Levels

```dart
// Info
debugPrint('Info: App started');

// Warning
print('Warning: High memory usage');

// Error
print('Error: Failed to load data');

// Debug
debugPrint('Debug: Variable value = $value');
```

## 🎓 Best Practices

### Code Organization
- Group related functionality
- Keep methods under 50 lines
- Extract reusable widgets
- Use meaningful names
- Add documentation comments

### Error Handling
```dart
try {
  // Try operation
} catch (e) {
  debugPrint('Error: $e');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${e.toString()}')),
  );
} finally {
  // Cleanup
}
```

### Loading States
```dart
// Show loading
if (isLoading) {
  return LoadingAnimation();
}

// Show error
if (hasError) {
  return ErrorWidget(error: error);
}

// Show content
return ContentWidget();
```

---

**Debug smarter, code faster! 🚀**

For more help: [Flutter Debugging](https://flutter.dev/docs/testing/debugging)
