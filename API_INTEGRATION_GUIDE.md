# API Integration Documentation

## Overview
This document outlines the complete API integration for the ABSENSI PPKD application using the Postman collection provided.

**Base URL:** `https://appabsensi.mobileprojp.com`

---

## Architecture Overview

### Layered Architecture
```
Presentation Layer (Pages & Widgets)
         ↓
  Provider Layer (State Management)
         ↓
   Service Layer (Business Logic)
         ↓
  API Service (HTTP Requests)
         ↓
   Local Storage (SharedPreferences)
```

---

## API Endpoints Integrated

### 1. Authentication
| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/register` | POST | No | User registration |
| `/api/login` | POST | No | User login |
| `/forgot-password` | POST | No | Request OTP for password reset |
| `/reset-password` | POST | No | Reset password with OTP |
| `/api/profile` | GET | Yes | Get authenticated user profile |

#### Register
```dart
// Parameters
{
  "name": "Budi",
  "email": "budi@example.com",
  "password": "password123",
  "jenis_kelamin": "male",
  "profile_photo": "base64_string",
  "batch_id": 1,
  "training_id": 1
}

// Response
{
  "message": "Registrasi berhasil",
  "data": {
    "token": "eyJ0eXAiO...",
    "user": {
      "id": 4,
      "name": "Budi",
      "email": "budi@examspless.com",
      "created_at": "2025-04-11T01:14:55.000000Z"
    }
  }
}
```

#### Login
```dart
// Parameters
{
  "email": "budi@example.com",
  "password": "password123"
}

// Response
{
  "message": "Login berhasil",
  "data": {
    "token": "14|zzUM9ra1heamxdO6EcQqmWXEb9eQsqE67NuNWPbV15f2e48d",
    "user": {
      "id": 1,
      "name": "budianduks",
      "email": "budi@example.com",
      "created_at": "2025-04-10T07:01:59.000000Z"
    }
  }
}
```

### 2. Attendance
| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/absen-check-in` | POST | Yes | Check-in attendance |
| `/api/absen-check-out` | POST | Yes | Check-out attendance |
| `/api/izin` | POST | Yes | Submit leave/permission |
| `/api/absen-today` | GET | Yes | Get today's attendance |
| `/api/absen-stats` | GET | Yes | Get attendance statistics |
| `/api/history-absen` | GET | Yes | Get attendance history |
| `/api/delete-absen` | DELETE | Yes | Delete attendance record |

#### Check-In
```dart
// Parameters
{
  "latitude": -6.123456,
  "longitude": 106.123456,
  "status": "masuk",  // or "izin sakit", "izin lainnya"
  "alasan_izin": "Reason if izin"
}

// Response
{
  "message": "Absen masuk berhasil",
  "data": {
    "id": 351,
    "attendance_date": "2025-07-16",
    "check_in_time": "08:10",
    "check_in_lat": -6.123456,
    "check_in_lng": 106.123456,
    "check_in_address": "Jakarta",
    "status": "masuk"
  }
}
```

#### Check-Out
```dart
// Parameters
{
  "latitude": -6.123456,
  "longitude": 106.123456
}

// Response
{
  "message": "Absen keluar berhasil",
  "data": {
    "check_out_time": "14:14",
    "check_out_address": "Jakarta"
  }
}
```

#### Submit Leave (Izin)
```dart
// Parameters
{
  "attendance_date": "2025-07-20",
  "alasan_izin": "Sakit",
  "status": "izin"  // "izin sakit" or "izin lainnya"
}
```

### 3. Profile Management
| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/profile` | GET | Yes | Get profile |
| `/api/profile` | PUT | Yes | Update profile (name, email) |
| `/api/profile/photo` | PUT | Yes | Update profile photo |
| `/api/device-token` | POST | Yes | Register device token |

#### Update Profile
```dart
// Parameters
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

### 4. Data & Dropdowns
| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/batches` | GET | No | Get all batches for registration |
| `/api/trainings` | GET | No | Get all trainings for registration |
| `/api/training/{id}` | GET | No | Get specific training details |

---

## Services Implementation

### AuthService
Handles authentication operations:
- `login()` - Login user and save token
- `register()` - Register new user
- `getAuthenticatedUser()` - Get current user profile
- `hasValidSession()` - Check if user is still logged in
- `logout()` - Logout and clear token
- `requestForgotPasswordOtp()` - Request OTP for password reset
- `resetPasswordWithOtp()` - Reset password using OTP

### AttendanceService
Handles attendance operations:
- `checkIn()` - Submit check-in with location
- `checkOut()` - Submit check-out with location
- `submitIzin()` - Submit leave request
- `getAttendanceHistory()` - Fetch attendance records
- `getTodayAttendance()` - Get today's attendance
- `getAttendanceStats()` - Get attendance statistics
- `deleteAttendance()` - Delete attendance record

### ProfileService
Handles profile and user management:
- `getProfile()` - Get user profile
- `updateProfile()` - Update name and email
- `updateProfilePhoto()` - Upload profile photo
- `getBatches()` - Get batch list for dropdown
- `getTrainings()` - Get training list for dropdown
- `getTrainingDetail()` - Get training details
- `sendDeviceToken()` - Register FCM token

---

## Providers (State Management)

### AuthProvider
Manages authentication state:
- `currentUser` - Current logged-in user
- `isLoggedIn` - Login status
- `isLoading` - Loading state
- `error` - Error messages

**Methods:**
- `login(email, password)` - Authenticate user
- `register(...)` - Create new account
- `checkLoginStatus()` - Check if user session is valid
- `logout()` - Logout user
- `requestForgotPasswordOtp(email)` - Request OTP
- `resetPasswordWithOtp(email, otp, password)` - Reset password

### AttendanceProvider
Manages attendance state:
- `attendanceHistory` - List of attendance records
- `hasCheckedInToday` - Today's check-in status
- `hasCheckedOutToday` - Today's check-out status
- `currentLocation` - Current GPS coordinates
- `isLoading` - Loading state
- `error` - Error messages

**Methods:**
- `getAttendanceHistory()` - Fetch attendance records
- `checkIn(status, note)` - Submit check-in
- `checkOut(note)` - Submit check-out
- `submitIzin(date, reason, type)` - Submit leave
- `deleteAttendance(id)` - Delete record
- `loadTodayAttendance()` - Load today's attendance
- `getStats()` - Get attendance statistics

### UserProvider
Manages user profile state:
- `user` - Current user data
- `batches` - List of batches
- `trainings` - List of trainings
- `isLoading` - Loading state
- `error` - Error messages

**Methods:**
- `getProfile()` - Fetch user profile
- `updateProfile(data)` - Update profile
- `getBatches()` - Fetch batch list
- `getTrainings()` - Fetch training list
- `getTrainingDetail(id)` - Get training details
- `sendDeviceToken(token)` - Register FCM token

---

## Token Management

### Flow
1. **Login/Register** → Token received from API
2. **SaveToken** → Stored in SharedPreferences
3. **API Requests** → Token added to Authorization header: `Bearer <token>`
4. **Token Expiry** → 401 response → AuthException thrown
5. **Logout** → Token cleared from storage

### Code Example
```dart
// Automatic token attachment in ApiService
Future<Map<String, String>> _headersWithAuth() async {
  final token = await _storage.getToken();
  if (token == null || token.isEmpty) {
    throw AuthException(message: 'Token tidak ditemukan. Silakan login ulang.');
  }
  return {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
```

---

## Error Handling

### Exception Types
- **AppException** - Base exception
- **AuthException** - Authentication errors (401)
- **ServerException** - Server errors (5xx)
- **ValidationException** - Validation errors (422)
- **NetworkException** - Network connectivity errors
- **LocationException** - GPS/location errors

### Response Handling
```dart
// All API responses follow this pattern
{
  "message": "Success or error message",
  "data": { ... }  // or null
}

// Error responses
{
  "message": "Error description",
  "errors": {
    "field_name": ["Error details"]
  }
}
```

---

## Usage Examples

### Login Flow
```dart
final authProvider = context.read<AuthProvider>();
final success = await authProvider.login('user@example.com', 'password');

if (success) {
  Navigator.of(context).pushReplacementNamed('/dashboard');
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.error ?? 'Login failed')),
  );
}
```

### Check-In with Location
```dart
final attendanceProvider = context.read<AttendanceProvider>();
final success = await attendanceProvider.checkIn('Hadir', '');

if (success) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(title: Text('Check-in berhasil!')),
  );
}
```

### Update Profile
```dart
final userProvider = context.read<UserProvider>();
final success = await userProvider.updateProfile({
  'name': 'New Name',
  'email': 'newemail@example.com',
  'photo': base64EncodedPhoto,
});
```

### Get Attendance History
```dart
final attendanceProvider = context.read<AttendanceProvider>();
await attendanceProvider.getAttendanceHistory();

// Access data
List<AttendanceModel> history = attendanceProvider.attendanceHistory;
```

---

## API Response Models

### UserModel
```dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photo;
  final String? gender;
  final String? batch;
  final String? training;
  final String createdAt;
}
```

### AttendanceModel
```dart
class AttendanceModel {
  final int id;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? status;  // 'Hadir', 'Izin', 'Tanpa Keterangan'
  final String? note;
}
```

### BatchModel & TrainingModel
```dart
class BatchModel {
  final int id;
  final String name;
  final List<TrainingModel> trainings;
}

class TrainingModel {
  final int id;
  final String name;
  final String? description;
}
```

---

## Important Notes

1. **Token Management**: Tokens are automatically managed by ApiService and LocalStorageService
2. **Location Permission**: Android and iOS permissions must be properly configured
3. **Base64 Photos**: Profile photos should be Base64 encoded before sending
4. **Pagination**: Some endpoints support pagination with limit/offset parameters
5. **Error Messages**: All Indonesian messages are in AppStrings class
6. **Timeout**: Default API timeout is 30 seconds

---

## Testing Endpoints with Postman

The Postman collection includes all endpoints with sample requests and responses.
Import the collection:
`ABSENSI PPKD B4.postman_collection.json`

**Base URL Variable:** `https://appabsensi.mobileprojp.com`
**Token Variable:** Automatically set after login

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Token not saving | Check LocalStorageService initialization |
| 401 Unauthorized | Token expired, user needs to login again |
| CORS errors | Verify base URL is correct |
| Location not working | Check Android/iOS permissions in manifest |
| Image upload fails | Ensure image is properly Base64 encoded |

---

## Files Modified

- ✅ `lib/core/constants/app_constants.dart` - Added all endpoints
- ✅ `lib/services/auth_service.dart` - Added password recovery methods
- ✅ `lib/services/attendance_service.dart` - Added izin, today, stats endpoints
- ✅ `lib/services/profile_service.dart` - Added device token and training detail
- ✅ `lib/providers/auth_provider.dart` - Added password recovery providers
- ✅ `lib/providers/attendance_provider.dart` - Added new attendance methods
- ✅ `lib/providers/user_provider.dart` - Added device token provider
