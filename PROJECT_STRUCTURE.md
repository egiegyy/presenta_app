# 📁 Project Structure & File Guide

## Complete File Tree

```
presenta_app/
├── lib/                                    # Main application code
│   ├── core/                               # Core functionality
│   │   ├── constants/
│   │   │   └── app_constants.dart         # Constants & localized strings
│   │   ├── services/
│   │   │   ├── api_service.dart          # HTTP calls & API integration
│   │   │   ├── local_storage_service.dart# SharedPreferences wrapper
│   │   │   └── location_service.dart     # Geolocator wrapper
│   │   └── utils/
│   │       ├── exceptions.dart           # Custom exception classes
│   │       └── extensions.dart           # Extension methods
│   │
│   ├── data/                               # Data layer (models)
│   │   ├── models/
│   │   │   ├── user_model.dart           # User data class
│   │   │   ├── attendance_model.dart     # Attendance record class
│   │   │   └── dropdown_models.dart      # Batch & Training classes
│   │   ├── sources/                      # Data sources (future use)
│   │   └── repositories/                 # Repositories (future use)
│   │
│   ├── providers/                         # State management (Provider)
│   │   ├── auth_provider.dart            # Authentication logic
│   │   ├── attendance_provider.dart      # Attendance logic
│   │   ├── user_provider.dart            # User profile logic
│   │   └── theme_provider.dart           # Dark mode logic
│   │
│   ├── presentation/                      # UI layer
│   │   ├── pages/
│   │   │   ├── auth_wrapper.dart         # Auth routing logic
│   │   │   ├── login_page.dart           # Login screen
│   │   │   ├── register_page.dart        # Registration screen
│   │   │   ├── dashboard_page.dart       # Main dashboard with map
│   │   │   ├── history_page.dart         # Attendance history
│   │   │   └── profile_page.dart         # User profile
│   │   └── widgets/
│   │       └── custom_widgets.dart       # Reusable UI components
│   │
│   ├── config/                            # Configuration
│   │   ├── app_config.dart               # Colors, dimensions, gradients
│   │   └── localization_config.dart      # Localization setup
│   │
│   └── main.dart                          # App entry point & routing
│
├── android/                                # Android platform code
│   ├── app/
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── AndroidManifest.xml   # App permissions & Google Maps key
│   │   │   │   ├── res/
│   │   │   │   └── kotlin/
│   │   │   └── debug/
│   │   └── build.gradle.kts
│   ├── gradle/
│   ├── settings.gradle.kts
│   └── build.gradle.kts
│
├── ios/                                    # iOS platform code
│   ├── Runner/
│   │   ├── Info.plist                    # App info & permissions
│   │   ├── Assets.xcassets/
│   │   └── AppDelegate.swift
│   ├── Runner.xcodeproj/
│   ├── Runner.xcworkspace/
│   └── Podfile
│
├── web/                                    # Web platform (future)
├── windows/                                # Windows platform (future)
├── macos/                                  # macOS platform (future)
├── linux/                                  # Linux platform (future)
│
├── pubspec.yaml                            # Flutter dependencies
├── analysis_options.yaml                   # Dart analysis rules
│
├── SETUP_GUIDE.md                          # Comprehensive setup guide
├── ANDROID_SETUP.md                        # Android configuration
├── IOS_SETUP.md                            # iOS configuration
├── INSTALLATION_CHECKLIST.md               # Step-by-step checklist
├── PROJECT_STRUCTURE.md                    # This file
├── README.md                               # Project overview
└── TROUBLESHOOT_ERROR.md                   # Error troubleshooting

```

---

## 📄 File Descriptions

### Core Layer (`lib/core/`)

#### Services
| File | Purpose | Key Methods |
|------|---------|-------------|
| `api_service.dart` | API communication | `login()`, `register()`, `getProfile()`, `checkIn()`, `checkOut()`, `getHistoryAbsen()`, `deleteAbsen()` |
| `local_storage_service.dart` | Local data storage | `saveToken()`, `getToken()`, `clearToken()`, `isLoggedIn()`, `saveDarkMode()` |
| `location_service.dart` | Geolocation | `getCurrentLocation()`, `hasLocationPermission()`, `openLocationSettings()` |

#### Constants
| File | Purpose | Key Exports |
|------|---------|------------|
| `app_constants.dart` | String constants | `AppConstants` (API endpoints, keys), `AppStrings` (UI text) |

#### Utils
| File | Purpose | Key Exports |
|------|---------|------------|
| `exceptions.dart` | Custom exceptions | `NetworkException`, `AuthException`, `LocationException`, `ServerException` |
| `extensions.dart` | Extension methods | `String.isValidEmail()`, `DateTime.isToday()`, `Double.toLatLngString()` |

---

### Data Layer (`lib/data/`)

#### Models
| File | Class | Purpose |
|------|-------|---------|
| `user_model.dart` | `UserModel` | Represents user profile data |
| `attendance_model.dart` | `AttendanceModel` | Represents single attendance record |
| `dropdown_models.dart` | `BatchModel`, `TrainingModel` | Dropdown options for registration |

---

### State Management (`lib/providers/`)

| File | Class | Purpose | Key Properties |
|------|-------|---------|-----------------|
| `auth_provider.dart` | `AuthProvider` | Auth state | `isLoggedIn`, `currentUser`, `isLoading`, `error` |
| `attendance_provider.dart` | `AttendanceProvider` | Attendance state | `attendanceHistory`, `currentLocation`, `hasCheckedInToday` |
| `user_provider.dart` | `UserProvider` | User profile state | `user`, `batches`, `trainings` |
| `theme_provider.dart` | `ThemeProvider` | Theme state | `isDarkMode`, `themeData` |

---

### Presentation Layer (`lib/presentation/`)

#### Pages
| File | Widget | Purpose |
|------|--------|---------|
| `login_page.dart` | `LoginPage` | Login screen with email/password |
| `register_page.dart` | `RegisterPage` | Registration with gender, batch, training |
| `dashboard_page.dart` | `DashboardPage` | Main screen with map & check-in buttons |
| `history_page.dart` | `HistoryPage` | List of attendance records |
| `profile_page.dart` | `ProfilePage` | User profile with edit mode |
| `auth_wrapper.dart` | `AuthWrapper` | Conditional routing based on auth state |

#### Widgets
| File | Widgets | Purpose |
|------|---------|---------|
| `custom_widgets.dart` | `GradientButton`, `CustomTextField`, `GlassmorphicCard`, `LoadingDialog`, `ErrorSnackbar`, `SuccessSnackbar` | Reusable UI components |

---

### Configuration (`lib/config/`)

| File | Purpose | Key Classes |
|------|---------|-----------|
| `app_config.dart` | Design tokens | `AppColors`, `AppDimensions`, `AppGradients` |
| `localization_config.dart` | Multilingual setup | `LocalizationConfig`, `idLocalization` |

---

### Entry Point

| File | Purpose | Key Functions |
|------|---------|--------------|
| `main.dart` | App initialization | `main()`, `MyApp`, `_AuthenticationWrapper` |

---

## 🔄 Data Flow

```
┌─────────────────────────────────────────────┐
│          User Interaction (UI)              │
│        (Pages in lib/presentation)          │
└────────────────┬────────────────────────────┘
                 │
                 ▼
         ┌───────────────────┐
         │   Providers       │
         │  (lib/providers)  │
         └────────┬──────────┘
                  │
                  ▼
         ┌────────────────────┐
         │   Services         │
         │  (lib/core/services)
         └────────┬───────────┘
                  │
     ┌────────────┼────────────┐
     ▼            ▼            ▼
 ┌────────┐  ┌───────────┐  ┌───────────┐
 │ API    │  │ Storage   │  │ Location  │
 │ Server │  │ Provider  │  │ Services  │
 └────────┘  └───────────┘  └───────────┘
```

---

## 📦 Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | 3.11+ | Flutter SDK |
| `provider` | 6.1.5 | State management |
| `http` | 1.2.2 | HTTP client |
| `shared_preferences` | 2.3.2 | Local storage |
| `geolocator` | 13.0.2 | GPS location |
| `google_maps_flutter` | 2.9.0 | Google Maps |
| `image_picker` | 0.8.7+ | Photo selection |
| `intl` | 0.19.0 | Localization |
| `google_fonts` | 6.2.1 | Custom fonts |

---

## 🎨 Theme System

### Light Theme
- Primary: Blue (`#1E3A8A`)
- Accent: Light Blue (`#3B82F6`)
- Background: White (`#FFFFFF`)

### Dark Theme
- Primary: Light Blue (`#60A5FA`)
- Accent: Lighter Blue (`#BFDBFE`)
- Background: Dark Blue (`#0F172A`)

---

## 📱 Screen Hierarchy

```
App
├── WarmupPage (conditional routing)
│
├── Auth Flow
│   ├── LoginPage
│   │   └── → Dashboard (on success)
│   └── RegisterPage
│       ├── Fetch Batches
│       ├── Fetch Trainings
│       └── → LoginPage (on success)
│
└── Main Flow
    ├── DashboardPage
    │   ├── Google Map
    │   ├── Check-In Button → LocationService
    │   ├── Check-Out Button → LocationService
    │   └── Quick Links
    │       ├── → HistoryPage
    │       └── → ProfilePage
    │
    ├── HistoryPage
    │   ├── List AttendanceModel
    │   └── Delete Functionality
    │
    └── ProfilePage
        ├── View Mode
        ├── Edit Mode
        ├── Upload Photo
        └── Dark Mode Toggle
```

---

## 🔐 Security Features

1. **Token-based Authentication**
   - Token saved to SharedPreferences
   - Token included in all API calls
   - Auto logout on token expiration

2. **Local Storage**
   - Login status persisted
   - Token persisted securely
   - User preference (dark mode) persisted

3. **Permission Handling**
   - Location permission requested before access
   - Camera permission requested before photo picker
   - Error handling for denied permissions

4. **Error Handling**
   - Network errors caught and shown
   - API errors handled gracefully
   - Validation errors shown to user

---

## 🧪 Testing Points

### Unit Tests (Future)
- Model serialization/deserialization
- Extension methods
- Exception handling

### Widget Tests (Future)
- Custom widgets rendering
- User interactions
- State changes

### Integration Tests (Future)
- End-to-end user flows
- API integration
- Navigation flow

---

## 🚀 Performance Tips

1. **Use `const` constructors** when possible
2. **Lazy load** images with fade-in
3. **Batch API calls** when possible
4. **Use `RepaintBoundary`** for complex widgets
5. **Profile with DevTools**
6. **Remove debug logging** before release

---

## 📋 Modification Guide

### Adding New Page
1. Create file in `lib/presentation/pages/`
2. Create corresponding provider if needed
3. Add route in `main.dart`
4. Add navigation in relevant pages

### Adding New API Endpoint
1. Add method in `api_service.dart`
2. Create/update model if needed
3. Add provider method
4. Call from page/widget

### Adding New Provider
1. Create file in `lib/providers/`
2. Extend `ChangeNotifier`
3. Add to MultiProvider in `main.dart`
4. Use with `Consumer` or `context.read()`

---

## 🔗 Related Documentation

- [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Complete setup instructions
- [ANDROID_SETUP.md](./ANDROID_SETUP.md) - Android-specific configuration
- [IOS_SETUP.md](./IOS_SETUP.md) - iOS-specific configuration
- [INSTALLATION_CHECKLIST.md](./INSTALLATION_CHECKLIST.md) - Step-by-step checklist
- [README.md](./README.md) - Project overview

---

**Last Updated**: April 2026
**Project Version**: 1.0.0

