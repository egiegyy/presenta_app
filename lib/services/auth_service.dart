import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/models/user_model.dart';

class AuthService {
  AuthService({
    ApiService? apiService,
    LocalStorageService? localStorageService,
  }) : _apiService = apiService ?? ApiService(),
       _localStorageService = localStorageService ?? LocalStorageService();

  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      AppConstants.loginEndpoint,
      body: {'email': email, 'password': password},
    );

    final responseMap = response as Map<String, dynamic>;

    // Extract token — supports multiple response shapes
    final token =
        responseMap['token']?.toString() ??
        responseMap['access_token']?.toString() ??
        (responseMap['data'] is Map<String, dynamic>
            ? (responseMap['data']['token']?.toString() ??
                  responseMap['data']['access_token']?.toString())
            : null);

    if (token == null || token.isEmpty) {
      throw Exception('Token login tidak ditemukan pada response server.');
    }

    // Persist token FIRST so subsequent authenticated calls work
    await _localStorageService.saveToken(token);

    // Try to get full profile; fall back to parsing from login response
    try {
      final user = await getAuthenticatedUser();
      await _localStorageService.saveUserId(user.id);
      return user;
    } catch (_) {
      // If profile fetch fails (e.g. network hiccup), build from login data
      final userData =
          responseMap['user'] is Map<String, dynamic>
              ? responseMap['user'] as Map<String, dynamic>
              : (responseMap['data'] is Map<String, dynamic>
                  ? responseMap['data'] as Map<String, dynamic>
                  : <String, dynamic>{});
      final user = UserModel.fromJson({...userData, 'email': email});
      if (user.id != 0) {
        await _localStorageService.saveUserId(user.id);
      }
      return user;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    String? profilePhotoBase64,
    int? batchId,
    int? trainingId,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'jenis_kelamin': gender,
      'profile_photo': profilePhotoBase64 ?? '',
    };

    if (batchId != null) {
      body['batch_id'] = batchId;
    }
    if (trainingId != null) {
      body['training_id'] = trainingId;
    }

    await _apiService.post(AppConstants.registerEndpoint, body: body);
  }

  Future<UserModel> getAuthenticatedUser() async {
    final response = await _apiService.get(
      AppConstants.profileEndpoint,
      requireAuth: true,
    );

    final responseMap = response as Map<String, dynamic>;
    return UserModel.fromJson(
      (responseMap['data'] as Map<String, dynamic>?) ?? responseMap,
    );
  }

  Future<bool> hasValidSession() async {
    final isLoggedIn = await _localStorageService.isLoggedIn();
    if (!isLoggedIn) {
      return false;
    }

    final token = await _localStorageService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _apiService.logout();
  }

  Future<void> requestForgotPasswordOtp(String email) async {
    await _apiService.post(
      AppConstants.forgotPasswordEndpoint,
      body: {'email': email},
    );
  }

  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    await _apiService.post(
      AppConstants.resetPasswordEndpoint,
      body: {'email': email, 'otp': otp, 'password': password},
    );
  }
}
