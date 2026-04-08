# 🤖 Android Configuration Guide

## Google Maps Setup

### Step 1: Get Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create new project or select existing
3. Enable **Maps SDK for Android**
4. Create **API Key** (Restriction: Android)
5. Add your app's package name & SHA-1 fingerprint

### Step 2: Get SHA-1 Fingerprint
```bash
# Debug key
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release key
keytool -list -v -keystore /path/to/key.jks -alias <alias_name> -storepass <storepass> -keypass <keypass>
```

### Step 3: Update AndroidManifest.xml

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.presenta_app">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.CAMERA" />

    <application
        android:label="@string/app_name"
        android:icon="@mipmap/ic_launcher"
        android:debuggable="false"
        android:usesCleartextTraffic="false">

        <!-- Google Maps API Key -->
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### Step 4: Build Properties (Optional)

Edit `android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
android.useAndroidX=true
android.enableJetifier=true
```

### Step 5: Build & Test
```bash
flutter clean
flutter pub get
flutter run
```

---

## Permissions Configuration

The app needs these permissions:

### Location Permissions
- `ACCESS_FINE_LOCATION` - Precise location (GPS)
- `ACCESS_COARSE_LOCATION` - Network-based location

### Storage Permissions
- `READ_EXTERNAL_STORAGE` - Read images
- `WRITE_EXTERNAL_STORAGE` - Write images

### Camera Permissions
- `CAMERA` - Camera for photo capture

### Internet
- `INTERNET` - API calls

---

## Troubleshooting

### Issue: "Failed to find Google Maps API Key"
**Solution**: 
- Check API key is correct
- Verify SHA-1 fingerprint is added
- Check package name matches

### Issue: Map shows blank/gray
**Solution**:
- Wait for map to initialize
- Check network connectivity
- Verify API key has proper quotas

### Issue: Crash on location permission
**Solution**:
- Grant permission through system settings
- Check geolocator plugin is latest version
- Try on physical device

---

## API Key Security

⚠️ **IMPORTANT**: Never commit API key to version control
- Add to `.gitignore`
- Use environment variables in CI/CD
- Restrict key in Google Cloud Console
