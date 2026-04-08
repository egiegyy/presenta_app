import 'package:shared_preferences/shared_preferences.dart';
import 'package:presenta_app/core/constants/app_constants.dart';

class LocalStorageService {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await _preferences.setString(AppConstants.tokenKey, token);
    await _preferences.setBool(AppConstants.loginStatusKey, true);
  }

  Future<String?> getToken() async {
    return _preferences.getString(AppConstants.tokenKey);
  }

  Future<void> clearToken() async {
    await _preferences.remove(AppConstants.tokenKey);
    await _preferences.setBool(AppConstants.loginStatusKey, false);
  }

  Future<bool> isLoggedIn() async {
    return _preferences.getBool(AppConstants.loginStatusKey) ?? false;
  }

  Future<void> saveDarkMode(bool isDarkMode) async {
    await _preferences.setBool(AppConstants.darkModeKey, isDarkMode);
  }

  Future<bool> isDarkMode() async {
    return _preferences.getBool(AppConstants.darkModeKey) ?? false;
  }

  Future<void> clear() async {
    await _preferences.clear();
  }

  // Profile image path
  static const String _profileImagePathKey = 'profile_image_path';

  Future<void> saveProfileImagePath(String path) async {
    await _preferences.setString(_profileImagePathKey, path);
  }

  Future<String?> getProfileImagePath() async {
    return _preferences.getString(_profileImagePathKey);
  }

  Future<void> clearProfileImagePath() async {
    await _preferences.remove(_profileImagePathKey);
  }
}
