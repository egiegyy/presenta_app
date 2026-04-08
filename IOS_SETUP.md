# 🍎 iOS Configuration Guide

## Google Maps Setup

### Step 1: Get Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project or select existing
3. Enable **Maps SDK for iOS**
4. Create **API Key** (Restriction: iOS)
5. Add your app's iOS bundle ID

### Step 2: Update Info.plist

Edit `ios/Runner/Info.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... existing entries ... -->

    <!-- Location Permissions -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Aplikasi ini membutuhkan akses lokasi untuk menampilkan posisi Anda di peta.</string>
    
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Aplikasi ini membutuhkan akses lokasi untuk mencatat absensi dengan lokasi.</string>

    <!-- Camera Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>Aplikasi ini membutuhkan akses kamera untuk upload foto profil.</string>

    <!-- Photo Library Permissions -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Aplikasi ini membutuhkan akses galeri untuk upload foto profil.</string>

    <!-- Google Maps API Key -->
    <key>com.google.ios.maps.api_key</key>
    <string>YOUR_GOOGLE_MAPS_API_KEY_HERE</string>

    <!-- App Transport Security -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>appabsensi.mobileprojp.com</key>
            <dict>
                <key>NSIncludesSubdomains</key>
                <true/>
                <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
                <true/>
            </dict>
        </dict>
    </key>NSAppTransportSecurity>
</dict>
</plist>
```

### Step 3: Update Podfile

Edit `ios/Podfile` to ensure CocoaPods is configured:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_LOCATION=1',
        'PERMISSION_CAMERA=1',
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

### Step 4: Install Dependencies

```bash
cd ios
rm -rf Pods
rm Podfile.lock
pod install --repo-update
pod update
cd ..
```

### Step 5: Open Xcode and Configure (Optional)

If you need to configure signing:

```bash
open ios/Runner.xcworkspace
```

- Go to Xcode project settings
- Select Runner target
- Go to Signing & Capabilities
- Add your development team

### Step 6: Build & Test

```bash
flutter clean
flutter pub get
flutter run -i
```

---

## Permissions Configuration

The app needs these permissions:

### Location Permissions
- **NSLocationWhenInUseUsageDescription** - When in use
- **NSLocationAlwaysAndWhenInUseUsageDescription** - Always + when in use

### Camera & Photo Permissions
- **NSCameraUsageDescription** - Camera access
- **NSPhotoLibraryUsageDescription** - Photo library access

### Network Security
- Configure ATS (App Transport Security) for API domain

---

## iOS Deployment Target

Ensure deployment target is at least iOS 11.0:

Edit `ios/Podfile`:
```ruby
platform :ios, '11.0'
```

---

## Troubleshooting

### Issue: "Application already running"
**Solution**:
```bash
flutter clean
killall -9 com.apple.CoreSimulator.CoreSimulatorService
flutter run -i
```

### Issue: Pod install fails
**Solution**:
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks/ Flutter/Flutter.framework
pod install --repo-update
cd ..
```

### Issue: Map shows blank/gray
**Solution**:
- Check API key is correct
- Verify bundle ID matches Google Cloud
- Check network connectivity
- Wait for map to initialize

### Issue: Location permission denied
**Solution**:
- Grant permission in Settings > Privacy
- Restart app
- Check NSLocationWhenInUseUsageDescription is set

### Issue: Xcode build fails
**Solution**:
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install --repo-update
cd ..
flutter pub get
flutter run -i
```

---

## API Key Security

⚠️ **IMPORTANT**: Never commit API key to version control
- Add to `.gitignore`
- Use environment variables in CI/CD
- Restrict key in Google Cloud Console to iOS Bundle ID

---

## Testing on Physical Device

1. Connect iPhone via USB
2. Run:
   ```bash
   flutter run -d <device_id>
   ```
3. Trust the app in Settings
4. Grant permissions when prompted

---

## Building for App Store

```bash
flutter build ios --release
```

Then upload to App Store Connect following Apple's process.
