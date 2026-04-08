# 🎯 PRESENTA - Attendance Management System

Aplikasi Flutter untuk manajemen absensi dengan arsitektur clean, scalable, dan production-ready.

## ✨ Fitur

### 1. **Autentikasi** 🔐
- Login dengan email & password
- Register dengan data lengkap (nama, email, password, jenis kelamin, batch, training)
- Simpan token ke SharedPreferences
- Token-based authentication

### 2. **Absensi** 📍
- Check-in dengan geolocation
- Check-out dengan geolocation
- Note optional untuk setiap absensi
- Riwayat absensi lengkap

### 3. **Google Maps** 🗺️
- Tampilkan posisi user real-time
- Integrasi dengan geolocator
- Interactive map dengan marker

### 4. **Dashboard** 📊
- Greeting dinamis (Pagi/Siang/Sore/Malam)
- Tampilkan nama user dari API
- Status absensi hari ini
- Statistik total hadir
- Quick access ke History & Profile

### 5. **Riwayat Absensi** 📜
- List semua absensi
- Tampilkan tanggal, jam masuk, jam keluar
- Lokasi check-in
- Delete attendance
- No data state

### 6. **Profil Pengguna** 👤
- Lihat data profil
- Edit nama & email
- Upload foto profil (auto convert ke base64)
- Lihat batch & training

### 7. **Dark Mode** 🌙
- Toggle dark/light theme
- Simpan preference ke SharedPreferences

### 8. **Error Handling** 🚨
- Network error
- Server error (401, 500, etc)
- Location permission
- Token expired handling
- User-friendly error messages

---

## 🏗️ Arsitektur Clean

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # Constants & localized strings
│   ├── services/
│   │   ├── api_service.dart            # HTTP client untuk API calls
│   │   ├── local_storage_service.dart  # SharedPreferences wrapper
│   │   └── location_service.dart       # Geolocator wrapper
│   └── utils/
├── data/
│   ├── models/
│   │   ├── user_model.dart            # User data model
│   │   ├── attendance_model.dart       # Attendance data model
│   │   └── dropdown_models.dart       # Batch & Training models
│   ├── sources/                        # Data sources (future use)
│   └── repositories/                   # Repositories (future use)
├── providers/
│   ├── auth_provider.dart              # Authentication state
│   ├── attendance_provider.dart        # Attendance state
│   ├── user_provider.dart              # User profile state
│   └── theme_provider.dart             # Theme state
├── presentation/
│   ├── pages/
│   │   ├── auth_wrapper.dart           # Auth routing
│   │   ├── login_page.dart             # Login UI
│   │   ├── register_page.dart          # Register UI
│   │   ├── dashboard_page.dart         # Dashboard UI
│   │   ├── history_page.dart           # History UI
│   │   └── profile_page.dart           # Profile UI
│   └── widgets/
│       └── custom_widgets.dart         # Reusable widgets
├── config/
│   ├── app_config.dart                 # Colors, dimensions, gradients
│   └── localization_config.dart        # Localization setup
└── main.dart                           # App entry point
```

---

## 🎨 UI Design

### Theme Colors
- **Primary**: Biru Gradient (`#1E3A8A` → `#3B82F6`)
- **Success**: Hijau (`#10B981`)
- **Error**: Merah (`#EF4444`)
- **Background**: Putih/Abu-abu cerah

### Design Elements
- ✅ Rounded corners (radius 12-20)
- ✅ Glassmorphic cards
- ✅ Gradient buttons dengan shadow
- ✅ Smooth animations
- ✅ Modern minimalist style

---

## 📦 Dependencies

```yaml
http: ^1.2.2                    # HTTP client
provider: ^6.1.5                # State management
shared_preferences: ^2.3.2      # Local storage
geolocator: ^13.0.2            # Geolocation
google_maps_flutter: ^2.9.0    # Google Maps
image_picker: ^0.8.7+5         # Image picker
intl: ^0.19.0                  # Internationalization
google_fonts: ^6.2.1           # Custom fonts
```

---

## 🚀 Setup & Installation

### Prerequisites
- Flutter SDK >= 3.11.0
- Dart >= 3.11.0
- Android SDK >= 21
- iOS deployment target >= 11.0
- Google Maps API Key

### 1. Clone Project
```bash
cd /path/to/presenta_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Google Maps API

#### Android Setup
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest ...>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    
    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_GOOGLE_MAPS_API_KEY" />
    </application>
</manifest>
```

#### iOS Setup
Edit `ios/Runner/Info.plist`:
```xml
<dict>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs your location to show it on the map</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs your location to show it on the map</string>
    <key>com.google.ios.maps.api_key</key>
    <string>YOUR_GOOGLE_MAPS_API_KEY</string>
</dict>
```

### 4. Run Application

#### On Android Emulator
```bash
flutter run
```

#### On Android Device
```bash
flutter run -d <device_id>
```

#### On iOS Simulator
```bash
flutter run -d iOS
```

#### On iOS Device
```bash
# First, update pods
cd ios
pod install --repo-update
cd ..
flutter run -i
```

### 5. Build Release

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

---

## 🔑 API Integration

### Base URL
```
https://appabsensi.mobileprojp.com/api
```

### Endpoints

#### Authentication
```
POST /login
Body: { "email": "", "password": "" }
Response: { "token": "", "user": {...} }

POST /register
Body: { 
    "name": "", 
    "email": "", 
    "password": "",
    "gender": "L/P",
    "batch": "",
    "training": ""
}

GET /batches (for dropdown)
Response: [{ "id": 1, "name": "" }, ...]

GET /trainings (for dropdown)
Response: [{ "id": 1, "name": "" }, ...]
```

#### User
```
GET /profile
Headers: { "Authorization": "Bearer TOKEN" }
Response: { "data": { "id": 1, "name": "", "email": "", ... } }

PUT /edit-profile
Headers: { "Authorization": "Bearer TOKEN" }
Body: { "name": "", "email": "", "photo": "base64" }
```

#### Attendance
```
POST /absen-check-in
Headers: { "Authorization": "Bearer TOKEN" }
Body: { "latitude": 0.0, "longitude": 0.0, "note": "" }

POST /absen-check-out
Headers: { "Authorization": "Bearer TOKEN" }
Body: { "latitude": 0.0, "longitude": 0.0, "note": "" }

GET /history-absen
Headers: { "Authorization": "Bearer TOKEN" }
Response: [{ "id": 1, "date": "", "check_in_time": "", ... }, ...]

DELETE /delete-absen?id=1
Headers: { "Authorization": "Bearer TOKEN" }
```

---

## 🔒 Local Storage

Data yang disimpan di SharedPreferences:
```
auth_token          # JWT Token
is_logged_in        # Boolean status
dark_mode           # Theme preference
```

---

## ⚠️ Error Handling

### Network Errors
- Cek koneksi internet
- Retry dengan exponential backoff
- Show snackbar dengan pesan error

### Token Expired
- Automatic redirect ke login
- Clear token dari storage
- User perlu login kembali

### Location Permission
- Request permission jika belum granted
- Guide user ke settings jika denied
- Handle location service disabled

### Server Errors
- 400: Bad request - validasi input
- 401: Unauthorized - token invalid/expired
- 500: Server error - retry later

---

## 📝 Testing

### Manual Testing Checklist
- [ ] Login berhasil & token disimpan
- [ ] Register berhasil dengan semua field
- [ ] Dashboard menampilkan nama user
- [ ] Check-in dengan location
- [ ] Check-out dengan location
- [ ] History menampilkan semua record
- [ ] Delete record dari history
- [ ] Edit profile & upload foto
- [ ] Dark mode toggle
- [ ] Logout cleared token
- [ ] Token expired redirect to login
- [ ] Location permission denied handled
- [ ] Network error handled

---

## 🚨 Common Issues & Solutions

### Issue: Google Maps tidak muncul
**Solution**: 
- Pastikan API key sudah benar di AndroidManifest.xml & Info.plist
- Restart emulator/run `flutter clean && flutter pub get`

### Issue: Geolocator tidak mendapat location
**Solution**:
- Pastikan permission sudah di request
- Aktifkan location services di device
- Emulator: set location melalui emulator settings

### Issue: Image picker crash
**Solution**:
- Pastikan photo picker permission di manifest
- Use latest geolocator package

### Issue: SharedPreferences kosong
**Solution**:
- Call `LocalStorageService.init()` di main() sebelum runApp()
- Check di DevTools menggunakan `shared_preferences_flutter`

---

## 📚 Code Structure Best Practices

### Provider Usage
```dart
// Reading
final auth = context.read<AuthProvider>();

// Listening
Consumer<AuthProvider>(
  builder: (context, auth, _) => ...,
)

// Multiple providers
Consumer2<Provider1, Provider2>(
  builder: (context, p1, p2, _) => ...,
)
```

### Error Handling
```dart
try {
  await apiService.login(...);
} catch (e) {
  final message = e.toString().replaceAll('Exception: ', '');
  ErrorSnackbar.show(context, message);
}
```

### Navigation
```dart
// Named route
Navigator.of(context).pushNamed('/dashboard');

// Replacement (tidak bisa back)
Navigator.of(context).pushReplacementNamed('/login');

// Pop
Navigator.pop(context);
```

---

## 🎯 Future Enhancements

- [ ] Biometric authentication
- [ ] Offline mode dengan local database
- [ ] Attendance statistics & charts
- [ ] Multiple language support (i18n)
- [ ] App update notification
- [ ] Push notifications
- [ ] Export attendance to PDF
- [ ] QR code check-in
- [ ] Admin dashboard
- [ ] Real-time attendance sync

---

## 📄 File Structure

```
presenta_app/
├── lib/
│   ├── core/
│   ├── data/
│   ├── providers/
│   ├── presentation/
│   ├── config/
│   └── main.dart
├── android/
├── ios/
├── web/
├── windows/
├── macos/
├── linux/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## 🤝 Contributing

Untuk kontribusi:
1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📧 Support

Untuk masalah atau pertanyaan, silahkan generate issue dengan detail lengkap.

---

## 📄 License

Project ini adalah proprietary. Penggunaan hanya untuk internal company.

---

## 👨‍💻 Author

Created with ❤️ using Flutter & Dart

---

**Last Updated**: April 2026
**Version**: 1.0.0

---

## 🎉 Happy Coding!

Jangan lupa untuk:
- ✅ Ganti `YOUR_GOOGLE_MAPS_API_KEY` dengan key asli
- ✅ Update base URL API jika berbeda
- ✅ Test di beberapa device
- ✅ Read flutter docs untuk advanced features
