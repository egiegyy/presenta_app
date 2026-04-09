class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://appabsensi.mobileprojp.com';
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String loginStatusKey = 'is_logged_in';
  static const String darkModeKey = 'dark_mode';
  static const String profileImagePathKey = 'profile_image_path';

  // API Endpoints
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String profileEndpoint = '/api/profile';
  static const String editProfileEndpoint = '/api/profile';
<<<<<<< HEAD
  static const String profilePhotoEndpoint = '/api/profile/photo';
  static const String checkInEndpoint = '/api/absen-check-in';
  static const String checkOutEndpoint = '/api/absen-check-out';
  static const String izinEndpoint = '/api/izin';
  static const String historyAbsenEndpoint = '/api/history-absen';
=======
  static const String editProfilePhotoEndpoint = '/api/profile/photo';
  static const String checkInEndpoint = '/api/absen/check-in';
  static const String checkOutEndpoint = '/api/absen/check-out';
  static const String historyAbsenEndpoint = '/api/absen/history';
>>>>>>> 77a89f6 (All done but not UI)
  static const String batchesEndpoint = '/api/batches';
  static const String trainingsEndpoint = '/api/trainings';
  static const String deleteAbsenEndpoint = '/api/delete-absen';
  static const String absenTodayEndpoint = '/api/absen-today';
  static const String absenStatsEndpoint = '/api/absen-stats';
  static const String deviceTokenEndpoint = '/api/device-token';
  static const String forgotPasswordEndpoint = '/forgot-password';
  static const String resetPasswordEndpoint = '/reset-password';

  // Timeouts
  static const int apiTimeoutSeconds = 30;

  // Geometry
  static const double defaultMapZoom = 15.0;

  // Status options for check-in
  static const List<String> attendanceStatuses = [
    'Hadir',
    'Izin Sakit',
    'Izin Lainnya',
  ];

  static const String attendanceStatusPresent = 'masuk';
  static const String attendanceStatusPermission = 'izin';
}

class AppStrings {
  // Auth
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String name = 'Full Name';
  static const String gender = 'Gender';
  static const String batch = 'Batch';
  static const String training = 'Training';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String logout = 'Logout';
  static const String noAccount = 'Don\'t have an account?';
  static const String haveAccount = 'Already have an account?';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String checkIn = 'Check In';
  static const String checkOut = 'Check Out';
  static const String greeting = 'Halo';
  static const String today = 'Hari Ini';
  static const String present = 'Hadir';
  static const String checkInTime = 'Waktu Masuk';
  static const String checkOutTime = 'Waktu Keluar';

  // History
  static const String history = 'Riwayat Absensi';
  static const String date = 'Tanggal';
  static const String location = 'Lokasi';
  static const String noData = 'Tidak ada data';

  // Profile
  static const String profile = 'Profil';
  static const String editProfile = 'Edit Profil';
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String uploadPhoto = 'Upload Foto';

  // Checkin Form
  static const String status = 'Status';
  static const String hadir = 'Hadir';
  static const String izinSakit = 'Izin Sakit';
  static const String izinLainnya = 'Izin Lainnya';
  static const String reason = 'Alasan';
  static const String reasonRequired = 'Alasan harus diisi';

  // Error Messages
  static const String emailRequired = 'Email harus diisi';
  static const String invalidEmail = 'Email tidak valid';
  static const String passwordRequired = 'Password harus diisi';
  static const String passwordTooShort = 'Password minimal 6 karakter';
  static const String nameRequired = 'Nama harus diisi';
  static const String passwordNotMatch = 'Password tidak cocok';
  static const String serverError = 'Terjadi kesalahan server';
  static const String networkError = 'Kesalahan jaringan';
  static const String locationError = 'Tidak dapat mengambil lokasi';
  static const String permissionDenied = 'Izin ditolak';
  static const String tokenExpired =
      'Sesi Anda expired, silahkan login kembali';
  static const String unknownError = 'Terjadi kesalahan yang tidak diketahui';

  // Success Messages
  static const String loginSuccess = 'Login berhasil';
  static const String registerSuccess = 'Registrasi berhasil';
  static const String checkInSuccess = 'Check in berhasil';
  static const String checkOutSuccess = 'Check out berhasil';
  static const String deleteSuccess = 'Berhasil dihapus';
}
