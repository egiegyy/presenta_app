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

  Future<void> saveUserId(int userId) async {
    await _preferences.setInt(AppConstants.userIdKey, userId);
  }

  Future<int?> getUserId() async {
    return _preferences.getInt(AppConstants.userIdKey);
  }

  Future<bool> isLoggedIn() async {
    final token = _preferences.getString(AppConstants.tokenKey);
    return token != null &&
        token.isNotEmpty &&
        (_preferences.getBool(AppConstants.loginStatusKey) ?? false);
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

  Future<void> clearAuthSession() async {
    await _preferences.remove(AppConstants.tokenKey);
    await _preferences.remove(AppConstants.userIdKey);
    await _preferences.setBool(AppConstants.loginStatusKey, false);
  }

  Future<void> saveProfileImagePath(String path) async {
    await _preferences.setString(AppConstants.profileImagePathKey, path);
  }

  Future<String?> getProfileImagePath() async {
    return _preferences.getString(AppConstants.profileImagePathKey);
  }

  Future<void> clearProfileImagePath() async {
    await _preferences.remove(AppConstants.profileImagePathKey);
  }

  Future<void> saveProfileIdentity({
    required String name,
    required String email,
    String? batch,
    String? training,
  }) async {
    await _preferences.setString(AppConstants.profileNameKey, name);
    await _preferences.setString(AppConstants.profileEmailKey, email);

    if (batch == null || batch.trim().isEmpty) {
      await _preferences.remove(AppConstants.profileBatchKey);
    } else {
      await _preferences.setString(AppConstants.profileBatchKey, batch);
    }

    if (training == null || training.trim().isEmpty) {
      await _preferences.remove(AppConstants.profileTrainingKey);
    } else {
      await _preferences.setString(AppConstants.profileTrainingKey, training);
    }
  }

  Future<Map<String, String?>> getProfileIdentity() async {
    return {
      'name': _preferences.getString(AppConstants.profileNameKey),
      'email': _preferences.getString(AppConstants.profileEmailKey),
      'batch': _preferences.getString(AppConstants.profileBatchKey),
      'training': _preferences.getString(AppConstants.profileTrainingKey),
    };
  }
}
