# Quick Reference Guide

## 🚀 Quick Commands

```bash
# Setup
flutter pub get                    # Install dependencies
flutter clean                      # Clean build files

# Running
flutter run                        # Debug mode
flutter run --release             # Release mode
flutter run -d <device-id>        # Specific device

# Building
flutter build apk                 # Android APK
flutter build ios                 # iOS app
flutter build web                 # Web app

# Development
dart format lib/                  # Format code
dart analyze lib/                 # Analyze code
flutter test                      # Run tests
flutter pub outdated              # Check package updates
```

## 📱 Navigation Routes

```dart
/splash  → SplashScreen    (Auto, 3 sec)
/login   → LoginScreen     (Start point)
/signup  → SignupScreen    (From login)
/home    → HomeScreen      (Main app)
```

## 🎨 Theme Customization

### Change Primary Color
Edit `lib/utils/theme.dart`:
```dart
static const Color primaryColor = Color(0xFF1B5E20); // Your color
```

### Add New Screen
1. Create file in `lib/screens/`
2. Add route in `lib/main.dart`
3. Update navigation in other screens

### Modify AQI Colors
Edit `lib/widgets/aqi_card.dart`:
```dart
Color _getAQIColor() {
  if (data.aqiValue <= 50) return AppTheme.goodAqi;
  // Add more conditions...
}
```

## 📊 Sample Data Management

### Add New City
Edit `lib/models/pollution_data.dart`:
```dart
static List<PollutionData> sampleCities = [
  PollutionData(
    cityName: 'New City',
    aqiValue: 120.0,
    pollutionStatus: 'Unhealthy',
    temperature: 25.0,
    humidity: 60.0,
    lastUpdated: 'Now',
    country: 'Country',
    latitude: 0.0,
    longitude: 0.0,
  ),
];
```

### Modify Sample Data
Change values in:
- `PollutionData.sample()` - Current location
- `PollutionData.sampleCities` - List of cities

## 🎯 Key Classes

### Models
- `PollutionData` - Main data structure

### Screens
- `SplashScreen` - 3-sec splash
- `LoginScreen` - Auth page
- `SignupScreen` - Registration
- `HomeScreen` - Main dashboard

### Widgets
- `AQICard` - Display pollution data
- `CustomTextField` - Input field
- `LoadingAnimation` - Loader
- `PollutionIndicator` - Circular AQI

### Utils
- `AppTheme` - Colors & styling
- `AppStrings` - Text constants
- `AppConstants` - App constants

## 🔐 Form Validation

Email validation:
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter email';
  }
  if (!value.contains('@')) {
    return 'Please enter valid email';
  }
  return null;
}
```

Password validation:
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter password';
  }
  if (value.length < 6) {
    return 'Password must be 6+ chars';
  }
  return null;
}
```

## 🎭 Animation Patterns

### Fade Animation
```dart
FadeTransition(
  opacity: fadeAnimation,
  child: widget,
)
```

### Slide Animation
```dart
SlideTransition(
  position: slideAnimation,
  child: widget,
)
```

### Circular Progress
```dart
CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(color),
  strokeWidth: 3,
)
```

## 📐 Layout Patterns

### Column + MainAxisAlignment
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [/* widgets */],
)
```

### Row + MainAxisAlignment
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [/* widgets */],
)
```

### GridView
```dart
GridView.count(
  crossAxisCount: 2,
  children: itemList,
)
```

## 🔄 State Management Pattern

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize
  }

  @override
  void dispose() {
    // Cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## 🎨 Styling Patterns

### Container with Gradient
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color1, Color2],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

### Card Style
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppTheme.cardBg,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: AppTheme.primaryColor,
      width: 1,
    ),
  ),
)
```

### Text Styling
```dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    color: AppTheme.primaryColor,
    fontWeight: FontWeight.bold,
  ),
)
```

## 🔗 Navigation Patterns

### Push Named
```dart
Navigator.of(context).pushNamed('/home');
```

### Push Replacement
```dart
Navigator.of(context).pushReplacementNamed('/login');
```

### Pop
```dart
Navigator.of(context).pop();
```

### Show Modal
```dart
showModalBottomSheet(
  context: context,
  backgroundColor: AppTheme.cardBg,
  builder: (context) => widget,
)
```

### Show SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
)
```

## 📝 Code Style

### Imports Order
```dart
import 'package:flutter/material.dart';
import 'package:project/models/...';
import 'package:project/widgets/...';
import 'package:project/utils/...';
```

### Class Structure
```dart
class MyWidget extends StatelessWidget {
  // Properties
  final String prop;

  // Constructor
  const MyWidget({required this.prop});

  // Methods
  void _privateMethod() {}

  // Build
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## 🐛 Common Fixes

### Widget not updating
```dart
setState(() {
  // Update state here
});
```

### Hot reload not working
```bash
# Full restart needed for:
# - Adding new files
# - Adding new routes
# - Changing main.dart
Press 'R' in terminal for full restart
```

### Build cache issues
```bash
flutter clean
flutter pub get
flutter run
```

### Device not detected
```bash
flutter devices
flutter emulators --launch <name>
```

## 📚 File Locations

- **Models:** `lib/models/pollution_data.dart`
- **Screens:** `lib/screens/*.dart`
- **Widgets:** `lib/widgets/*.dart`
- **Theme:** `lib/utils/theme.dart`
- **Strings:** `lib/utils/constants.dart`
- **Main:** `lib/main.dart`

## 🎯 Best Practices

✅ Use `const` constructors
✅ Use `final` for immutable properties
✅ Add null safety (`?` and `!`)
✅ Use meaningful variable names
✅ Extract widgets into separate classes
✅ Use theme for colors (not hardcoded)
✅ Dispose controllers in `dispose()`
✅ Use `ListView.builder` for long lists
✅ Use `SingleChildScrollView` for overflow
✅ Add loading states for async operations

❌ Don't use BuildContext across async gap
❌ Don't call `setState()` in `dispose()`
❌ Don't hardcode strings (use constants)
❌ Don't hardcode colors (use theme)
❌ Don't nest deep widget hierarchies
❌ Don't ignore null safety warnings
❌ Don't forget to dispose resources

## 📱 Testing Checklist

- [ ] Test on Android device/emulator
- [ ] Test on iOS device/emulator (if available)
- [ ] Test form validation
- [ ] Test navigation flow
- [ ] Test responsive design (portrait/landscape)
- [ ] Test loading states
- [ ] Test error scenarios
- [ ] Test performance (frame rate 60 FPS)

---

**Save this file for quick reference!** 🚀
