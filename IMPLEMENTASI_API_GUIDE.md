# Implementasi API - Panduan Cepat

## Quick Reference untuk Implementasi di Pages

### 1. Login Page Implementation

```dart
// Build submit handler
void _handleLogin(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } else {
      ErrorSnackbar.show(context, authProvider.error ?? 'Login gagal');
      authProvider.clearError();
    }
  }
}
```

### 2. Register Page Implementation

```dart
void _handleRegister(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    if (_selectedGender == null || _selectedBatchId == null || _selectedTrainingId == null) {
      ErrorSnackbar.show(context, 'Pilih semua dropdown');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ErrorSnackbar.show(context, AppStrings.passwordNotMatch);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _selectedGender!,
      _selectedBatchId,
      _selectedTrainingId,
      null, // profilePhotoBase64 - opsional
    );

    if (success) {
      SuccessSnackbar.show(context, 'Registrasi berhasil! Silahkan login.');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      ErrorSnackbar.show(context, authProvider.error ?? 'Registrasi gagal');
      authProvider.clearError();
    }
  }
}
```

### 3. Check-In Implementation

```dart
void _handleCheckIn(BuildContext context) async {
  final attendanceProvider = context.read<AttendanceProvider>();
  
  // Validasi status dipilih
  if (_selectedStatus == null) {
    ErrorSnackbar.show(context, 'Pilih status kehadiran');
    return;
  }

  // Untuk izin, validasi alasan
  if (_selectedStatus != 'Hadir' && _reasonController.text.trim().isEmpty) {
    ErrorSnackbar.show(context, 'Alasan harus diisi');
    return;
  }

  // Lakukan check-in dengan location
  final success = await attendanceProvider.checkIn(
    _selectedStatus!,
    _reasonController.text.trim(),
  );

  if (success) {
    SuccessSnackbar.show(context, 'Check-in berhasil!');
    if (mounted) {
      Navigator.of(context).pop();
    }
  } else {
    ErrorSnackbar.show(context, attendanceProvider.error ?? 'Check-in gagal');
  }
}
```

### 4. Check-Out Implementation

```dart
void _handleCheckOut(BuildContext context) async {
  final attendanceProvider = context.read<AttendanceProvider>();
  
  final success = await attendanceProvider.checkOut('');

  if (success) {
    SuccessSnackbar.show(context, 'Check-out berhasil!');
    if (mounted) {
      Navigator.of(context).pop();
    }
  } else {
    ErrorSnackbar.show(context, attendanceProvider.error ?? 'Check-out gagal');
  }
}
```

### 5. History Display

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<AttendanceProvider>().getAttendanceHistory();
  });
}

@override
Widget build(BuildContext context) {
  return Consumer<AttendanceProvider>(
    builder: (context, attendanceProvider, _) {
      if (attendanceProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (attendanceProvider.attendanceHistory.isEmpty) {
        return Center(child: Text(AppStrings.noData));
      }

      return ListView.builder(
        itemCount: attendanceProvider.attendanceHistory.length,
        itemBuilder: (context, index) {
          final attendance = attendanceProvider.attendanceHistory[index];
          return ListTile(
            title: Text('${AppStrings.date}: ${attendance.date}'),
            subtitle: Text('${AppStrings.checkInTime}: ${attendance.checkInTime}\n${AppStrings.checkOutTime}: ${attendance.checkOutTime}'),
          );
        },
      );
    },
  );
}
```

### 6. Profile Page Implementation

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<UserProvider>().getProfile();
  });
}

Future<void> _handleUpdateProfile(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final userProvider = context.read<UserProvider>();
    
    final success = await userProvider.updateProfile({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'photo': _base64Photo, // opsional
    });

    if (success) {
      SuccessSnackbar.show(context, 'Profil berhasil diperbarui');
    } else {
      ErrorSnackbar.show(context, userProvider.error ?? 'Update gagal');
    }
  }
}
```

### 7. Forgot Password Flow

```dart
// Step 1: Request OTP
Future<void> _requestOtp() async {
  final authProvider = context.read<AuthProvider>();
  final success = await authProvider.requestForgotPasswordOtp('email@example.com');
  
  if (success) {
    SuccessSnackbar.show(context, 'OTP telah dikirim ke email Anda');
    // Navigate to OTP input screen
  }
}

// Step 2: Reset Password with OTP
Future<void> _resetPassword() async {
  final authProvider = context.read<AuthProvider>();
  final success = await authProvider.resetPasswordWithOtp(
    email: 'email@example.com',
    otp: _otpController.text,
    password: _passwordController.text,
  );
  
  if (success) {
    SuccessSnackbar.show(context, 'Password berhasil direset');
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
```

### 8. Dropdown Data Loading (Register)

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final userProvider = context.read<UserProvider>();
    userProvider.getBatches();
    userProvider.getTrainings();
  });
}

@override
Widget build(BuildContext context) {
  return Consumer<UserProvider>(
    builder: (context, userProvider, _) {
      return DropdownButton<BatchModel>(
        value: _selectedBatch,
        items: userProvider.batches.map((batch) {
          return DropdownMenuItem(
            value: batch,
            child: Text(batch.name),
          );
        }).toList(),
        onChanged: (batch) {
          setState(() {
            _selectedBatch = batch;
            _selectedBatchId = batch?.id;
            // Update training options based on batch
            _availableTrainings = batch?.trainings ?? userProvider.trainings;
          });
        },
      );
    },
  );
}
```

### 9. View Attendance Statistics

```dart
Future<void> _loadStats() async {
  final attendanceProvider = context.read<AttendanceProvider>();
  final stats = await attendanceProvider.getStats();
  
  // stats contains:
  // - total_absen: total attendance records
  // - total_masuk: total presents
  // - total_izin: total leaves
  // - sudah_absen_hari_ini: whether checked in today
}
```

### 10. Delete Attendance Record

```dart
Future<void> _deleteAttendance(int attendanceId) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Hapus Absensi'),
      content: Text('Yakin ingin menghapus absensi ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            final attendanceProvider = context.read<AttendanceProvider>();
            final success = await attendanceProvider.deleteAttendance(attendanceId);
            
            if (success) {
              SuccessSnackbar.show(context, 'Absensi berhasil dihapus');
              if (mounted) Navigator.of(context).pop();
            }
          },
          child: Text('Hapus'),
        ),
      ],
    ),
  );
}
```

---

## API Response Handling Pattern

```dart
// Pattern yang konsisten digunakan di semua service
Future<UserModel> getUser() async {
  final response = await _apiService.get(
    AppConstants.profileEndpoint,
    requireAuth: true,  // Akan otomatis attach token
  );

  // Response sudah di-parse dari JSON
  final responseMap = response as Map<String, dynamic>;
  
  // Data ada dalam field 'data'
  return UserModel.fromJson(
    (responseMap['data'] as Map<String, dynamic>?) ?? responseMap,
  );
}
```

---

## Error Handling Pattern

```dart
// Pattern yang konsisten di semua provider
Future<bool> doSomething() async {
  try {
    _setLoading(true);
    _error = null;  // Clear previous errors
    
    // Do API call
    await _service.doSomething();
    
    return true;
  } on Exception catch (e) {
    _error = getErrorMessage(e);  // Convert exception to user message
    return false;
  } finally {
    _setLoading(false);
    notifyListeners();  // Update UI
  }
}
```

---

## Loading States

```dart
// Show loading indicator
if (provider.isLoading) {
  return Center(
    child: CircularProgressIndicator(),
  );
}

// Show error
if (provider.error != null) {
  return Center(
    child: Text(provider.error!),
  );
}

// Show success state
return SizedBox(); // actual content
```

---

## Key Implementation Checklist

- ✅ All endpoints integrated
- ✅ Token management automatic
- ✅ Error handling with user messages (Indonesian)
- ✅ Loading states for all async operations
- ✅ Location services integrated for attendance
- ✅ Dropdown data loading for registration
- ✅ Profile photo upload (base64 encoded)
- ✅ Password recovery flow (OTP)
- ✅ Statistics and history endpoints ready

---

## Common Issues & Solutions

### Issue: Token not staying after app restart
**Solution:** Make sure `LocalStorageService.init()` is called in main.dart before app runs

### Issue: 401 Unauthorized on every request
**Solution:** Check that token is being returned from login endpoint and saved correctly

### Issue: Location permission denied
**Solution:** Add permissions to AndroidManifest.xml and request at runtime on Android 6+

### Issue: Image upload fails
**Solution:** Ensure image is compressed and properly base64 encoded before sending

### Issue: Dropdown showing empty
**Solution:** Check that `getBatches()` and `getTrainings()` are called in initState
