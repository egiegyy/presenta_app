# ✅ PRESENTA Installation Checklist

> Pastikan semua langkah selesai sebelum menjalankan aplikasi

## 📋 Pre-Installation

- [ ] Flutter SDK installed (v3.11+)
- [ ] Dart SDK installed (v3.11+)
- [ ] Android SDK installed (API 21+)
- [ ] Xcode installed (for iOS)
- [ ] Git installed
- [ ] VS Code or Android Studio installed

## 🛠️ Project Setup

- [ ] Clone repository: `git clone ...`
- [ ] Navigate to project: `cd presenta_app`
- [ ] Get dependencies: `flutter pub get`
- [ ] Clean build: `flutter clean`

## 🔑 Google Maps Configuration

### Android
- [ ] Go to [Google Cloud Console](https://console.cloud.google.com/)
- [ ] Create/Select project
- [ ] Enable Maps SDK for Android
- [ ] Create API Key (Android restriction)
- [ ] Get SHA-1 fingerprint: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey`
- [ ] Add fingerprint to API Key in Cloud Console
- [ ] Copy API Key to `android/app/src/main/AndroidManifest.xml`
  ```xml
  <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_API_KEY_HERE" />
  ```

### iOS
- [ ] Enable Maps SDK for iOS in Cloud Console
- [ ] Create API Key (iOS restriction)
- [ ] Add Bundle ID: `com.example.presenta_app`
- [ ] Copy API Key to `ios/Runner/Info.plist`
  ```xml
  <key>com.google.ios.maps.api_key</key>
  <string>YOUR_API_KEY_HERE</string>
  ```
- [ ] Update permissions in Info.plist:
  - NSLocationWhenInUseUsageDescription
  - NSLocationAlwaysAndWhenInUseUsageDescription
  - NSCameraUsageDescription
  - NSPhotoLibraryUsageDescription

## 📦 Dependencies Installation

- [ ] Run: `flutter pub get`
- [ ] Verify all packages installed: `flutter pub upgrade`

### Android-Specific
- [ ] Navigate: `cd android`
- [ ] Sync: `./gradlew --version` (check gradle works)
- [ ] Navigate back: `cd ..`

### iOS-Specific
- [ ] Navigate: `cd ios`
- [ ] Pod install: `pod install --repo-update`
- [ ] Navigate back: `cd ..`

## 🧪 Emulator/Device Setup

### Android Emulator
- [ ] Open Android Studio
- [ ] Launch emulator: `emulator -avd <avd_name>`
- [ ] Or: `flutter emulators --launch <avd_id>`

### Android Device
- [ ] Enable USB Debugging in Developer Options
- [ ] Connect device via USB
- [ ] Run: `flutter devices` (verify device detected)
- [ ] Grant permissions when prompted

### iOS Simulator
- [ ] Run: `open -a Simulator`
- [ ] Select device from Hardware > Device

### iOS Physical Device
- [ ] Connect via USB
- [ ] Trust device when prompted
- [ ] Run: `flutter devices` (verify device detected)

## 🚀 First Run

- [ ] Run: `flutter run` (or `flutter run -i` for iOS)
- [ ] Wait for build to complete
- [ ] App should launch on emulator/device

### If build fails:
- [ ] Run: `flutter clean && flutter pub get`
- [ ] Try again: `flutter run`

## 🧪 Functionality Testing

### Authentication
- [ ] Test Login (use valid credentials from your API)
- [ ] Test Register with all fields
- [ ] Verify token is saved to SharedPreferences
- [ ] Test Logout clears token

### Dashboard
- [ ] Greeting displays correct name
- [ ] Current date displays
- [ ] Map shows current location
- [ ] Check-in button works
- [ ] Check-out button works

### Absensi
- [ ] Check-in accepts location
- [ ] Check-out accepts location
- [ ] Optional note field works
- [ ] Success message shows

### History
- [ ] List displays all records
- [ ] Date, time, location display correctly
- [ ] Delete button works
- [ ] No data state shows when empty

### Profile
- [ ] Profile data displays correctly
- [ ] Edit button enables edit mode
- [ ] Name/Email can be edited
- [ ] Image picker works
- [ ] Save updates profile
- [ ] Dark mode toggle works

### Error Handling
- [ ] Network error shows snackbar
- [ ] Server error handled gracefully
- [ ] Location permission denied handled
- [ ] Token expired redirects to login

## 🔧 Build Configuration

### Android Build
- [ ] Run: `flutter build apk --release`
- [ ] APK created in: `build/app/outputs/apk/release/`
- [ ] Or: `flutter build appbundle --release` (for Play Store)

### iOS Build
- [ ] Run: `flutter build ios --release`
- [ ] App ready for App Store upload

## 📱 Device Permissions

- [ ] Location: Allow access (GPS)
- [ ] Camera: Allow access
- [ ] Photos: Allow access
- [ ] Storage: Allow access (Android)

## 🐛 Debugging

- [ ] Enable debug logging in main.dart (optional)
- [ ] Use DevTools: `flutter pub global activate devtools`
- [ ] Open DevTools: `devtools`
- [ ] Check logs for errors: `flutter logs`

## 📝 Documentation Review

- [ ] Read [SETUP_GUIDE.md](./SETUP_GUIDE.md)
- [ ] Read [ANDROID_SETUP.md](./ANDROID_SETUP.md) (for Android)
- [ ] Read [IOS_SETUP.md](./IOS_SETUP.md) (for iOS)
- [ ] Review [README.md](./README.md)

## 🎯 Optional Enhancements

- [ ] Setup CI/CD pipeline
- [ ] Add unit tests
- [ ] Add widget tests
- [ ] Add integration tests
- [ ] Setup crash reporting (Firebase)
- [ ] Setup analytics (Firebase)

## ✨ Final Checks

- [ ] No console errors
- [ ] All pages load correctly
- [ ] All API calls work
- [ ] UI looks modern and polished
- [ ] No hardcoded values
- [ ] Comments added where needed
- [ ] Code follows clean architecture

## 🚀 Ready to Deploy

- [ ] All tests passing
- [ ] No warnings in console
- [ ] Build successful (both APK & AAB for Android, or IPA for iOS)
- [ ] Tested on multiple devices
- [ ] Google Play/App Store submission prepared

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| `flutter pub get` fails | Run `flutter clean` first |
| Emulator won't start | Check Android SDK tools updated |
| Map shows blank | Verify API key correct & network online |
| Location not working | Check permissions granted in settings |
| Build fails | Try `flutter clean && flutter pub get` |
| iOS build fails | Run `cd ios && pod install --repo-update && cd ..` |

---

## 📞 Support

If you encounter issues not listed above:
1. Check Flutter [documentation](https://flutter.dev/docs)
2. Check [GitHub Issues](https://github.com/flutter/flutter/issues)
3. Post detailed error message with:
   - Flutter version: `flutter --version`
   - Device info: `flutter devices`
   - Error logs: `flutter logs`

---

**Status**: ✅ Ready to Code!

Next step: Read [SETUP_GUIDE.md](./SETUP_GUIDE.md) for detailed configuration.
