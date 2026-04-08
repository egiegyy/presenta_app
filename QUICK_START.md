# 🚀 Quick Start Guide

Get **PRESENTA** running in minutes!

---

## ⚡ 5-Minute Setup

### Prerequisites
```bash
flutter --version  # Should be 3.11+
dart --version     # Should be 3.11+
```

### 1️⃣ Get Code & Dependencies
```bash
cd /path/to/presenta_app
flutter pub get
```

### 2️⃣ Setup Google Maps Key
Get key from [Google Cloud Console](https://console.cloud.google.com/):

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_KEY_HERE" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>com.google.ios.maps.api_key</key>
<string>YOUR_KEY_HERE</string>
```

### 3️⃣ Run!
```bash
flutter run
```

---

## 🧪 Test Credentials

Use these for login testing:

```
Email: test@example.com
Password: password123
```

Or create new account via Register page.

---

## 📱 First Time Running

1. App starts at Login screen
2. Enter credentials or Register
3. On first run, grant permissions:
   - ✅ Location access
   - ✅ Camera access
   - ✅ Photos access
4. Dashboard should show with map
5. Try Check-In button

---

## 🗺️ Common Tasks

### View User Location
```dart
// In any page
final location = context.read<AttendanceProvider>().currentLocation;
print('Lat: ${location?.latitude}, Lng: ${location?.longitude}');
```

### Make API Call
```dart
final apiService = ApiService();
final profile = await apiService.getProfile();
```

### Save Data Locally
```dart
final storage = LocalStorageService();
await storage.saveToken('my_token');
```

### Toggle Dark Mode
```dart
final themeProvider = context.read<ThemeProvider>();
await themeProvider.toggleTheme();
```

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Build fails | `flutter clean && flutter pub get` |
| Map shows blank | Check Google Maps API key |
| Location not working | Grant location permission in settings |
| Can't login | Check API server is running |
| Hot reload fail | Full restart with `flutter run` |

---

## 📁 Key Files to Edit

```
Core Logic:
├── lib/providers/              # Change state logic here
├── lib/core/services/          # Change API calls here
└── lib/core/constants/         # Change API URL/strings here

UI:
├── lib/presentation/pages/     # Modify screens here
└── lib/presentation/widgets/   # Create widgets here

Config:
└── pubspec.yaml               # Add dependencies here
```

---

## 🔐 First Time Security Setup

1. **Change API URL** in `lib/core/constants/app_constants.dart`
2. **Update colors** in `lib/config/app_config.dart`
3. **Add your strings** in `lib/core/constants/app_constants.dart`

---

## 🎨 Customize UI

### Change Primary Color
Edit `lib/config/app_config.dart`:
```dart
static const Color primaryDark = Color(0xFF1E3A8A); // Change this
```

### Change App Name
Edit `pubspec.yaml`:
```yaml
name: presenta_app    # App package name
```

### Change Button Text
Edit `lib/core/constants/app_constants.dart`:
```dart
static const String login = 'Login'; // Change this
```

---

## 📦 Add New Dependency

```bash
flutter pub add package_name
# or
flutter pub add package_name:^version
```

Import in your file:
```dart
import 'package:package_name/package_name.dart';
```

---

## 🚀 Build for Release

### Android APK
```bash
flutter build apk --release
# Find: build/app/outputs/flutter-apk/app-release.apk
```

### iOS App
```bash
flutter build ios --release
# Upload to App Store Connect
```

---

## 📊 Project Stats

- **Files**: 20+ Dart files
- **Lines of Code**: 2000+ (clean structure)
- **Pages**: 6 fully functional
- **Widgets**: 10+ reusable components
- **Providers**: 4 state managers
- **Services**: 3 service layers

---

## ✅ Feature Checklist

- ✅ Authentication (Login/Register)
- ✅ Dashboard with Map
- ✅ Attendance Check-In/Out
- ✅ Attendance History
- ✅ User Profile
- ✅ Dark Mode
- ✅ Error Handling
- ✅ Location Services
- ✅ Image Upload
- ✅ Clean Architecture

---

## 📚 Full Documentation

- Read [SETUP_GUIDE.md](./SETUP_GUIDE.md) for complete setup
- Read [PROJECT_STRUCTURE.md](./PROJECT_STRUCTURE.md) for architecture
- Read [API_REFERENCE.md](./API_REFERENCE.md) for API docs
- Read [ANDROID_SETUP.md](./ANDROID_SETUP.md) for Android config
- Read [IOS_SETUP.md](./IOS_SETUP.md) for iOS config

---

## 💡 Pro Tips

1. **Use DevTools** for debugging:
   ```bash
   flutter pub global activate devtools
   devtools
   ```

2. **Profile Performance**:
   ```bash
   flutter run --profile
   ```

3. **Check Dependencies**:
   ```bash
   flutter pub outdated
   ```

4. **Format Code**:
   ```bash
   dart format lib/
   ```

5. **Analyze Code**:
   ```bash
   flutter analyze
   ```

---

## 🎯 Next Steps

1. ✅ Get app running
2. ✅ Test all features
3. ✅ Update API URL to your server
4. ✅ Customize colors & strings
5. ✅ Add your company logo
6. ✅ Build APK/AAB for release
7. ✅ Submit to Play Store/App Store

---

## 🆘 Get Help

1. **Check logs**: `flutter logs`
2. **Read docs**: [flutter.dev](https://flutter.dev/docs)
3. **Search issues**: [GitHub Issues](https://github.com/flutter/flutter/issues)
4. **Ask community**: [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)

---

## 🎉 Ready to Code!

```
┌─────────────────────────────────────┐
│  Welcome to PRESENTA Development!   │
│                                     │
│  Your app is ready to customize!    │
└─────────────────────────────────────┘
```

Now go build something amazing! 🚀

---

**Version**: 1.0.0  
**Last Updated**: April 2026  
**Status**: ✅ Production Ready

