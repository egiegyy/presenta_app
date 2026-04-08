import 'package:flutter/material.dart';

// Localization configuration
// To use Indonesian localization, make sure to:
// 1. Add intl_utils or use this setup manually
// 2. In main.dart, import and use:
//    - import 'package:intl/intl.dart';
//    - Intl.defaultLocale = 'id_ID';

final Map<String, String> idLocalization = {
  // Common
  'welcome': 'Selamat Datang',
  'loading': 'Memuat...',
  'error': 'Kesalahan',
  'success': 'Berhasil',
  'cancel': 'Batal',
  'save': 'Simpan',
  'delete': 'Hapus',
  'edit': 'Edit',
  'logout': 'Keluar',

  // Auth
  'login': 'Login',
  'register': 'Daftar',
  'email': 'Email',
  'password': 'Kata Sandi',
  'confirm_password': 'Konfirmasi Kata Sandi',
  'name': 'Nama Lengkap',
  'gender': 'Jenis Kelamin',
  'batch': 'Batch',
  'training': 'Pelatihan',

  // Dashboard
  'dashboard': 'Dasbor',
  'check_in': 'Masuk',
  'check_out': 'Keluar',
  'greeting_morning': 'Selamat Pagi',
  'greeting_afternoon': 'Selamat Siang',
  'greeting_evening': 'Selamat Sore',
  'greeting_night': 'Selamat Malam',

  // History
  'history': 'Riwayat',
  'date': 'Tanggal',
  'time': 'Waktu',
  'location': 'Lokasi',
  'no_data': 'Tidak ada data',

  // Profile
  'profile': 'Profil',
  'edit_profile': 'Edit Profil',
  'upload_photo': 'Upload Foto',

  // Errors
  'network_error': 'Kesalahan Jaringan',
  'server_error': 'Kesalahan Server',
  'permission_denied': 'Izin Ditolak',
  'location_error': 'Tidak dapat mengambil lokasi',
};

class LocalizationConfig {
  // Supported locales
  static const supportedLocales = [Locale('en', 'US'), Locale('id', 'ID')];

  static const defaultLocale = Locale('en', 'US');
}
