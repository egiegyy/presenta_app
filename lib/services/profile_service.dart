import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/models/dropdown_models.dart';
import 'package:presenta_app/models/user_model.dart';

class ProfileService {
  ProfileService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<UserModel> getProfile() async {
    final responseMap = await _apiService.getProfile();
    return UserModel.fromJson(
      (responseMap['data'] as Map<String, dynamic>?) ?? responseMap,
    );
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final responseMap = await _apiService.editProfile({
      'name': name,
      'email': email,
    });

    return UserModel.fromJson(
      (responseMap['data'] as Map<String, dynamic>?) ?? responseMap,
    );
  }

  Future<String?> updateProfilePhoto(String base64Photo) async {
    final responseMap = await _apiService.updateProfilePhoto(base64Photo);
    final data = responseMap['data'];
    if (data is! Map<String, dynamic>) {
      return null;
    }

    return _normalizePhotoUrl(data['profile_photo']?.toString());
  }

  String? _normalizePhotoUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return null;
    }

    final normalizedUrl = url.trim();
    final parsed = Uri.tryParse(normalizedUrl);
    final baseUri = Uri.parse(AppConstants.baseUrl);

    if (parsed == null) {
      return normalizedUrl;
    }

    if (!parsed.hasScheme) {
      final relativePath = normalizedUrl.startsWith('/')
          ? normalizedUrl
          : '/$normalizedUrl';
      return '${AppConstants.baseUrl}$relativePath';
    }

    final localhostHosts = {'127.0.0.1', 'localhost'};
    if (localhostHosts.contains(parsed.host)) {
      return parsed.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.hasPort ? baseUri.port : parsed.port,
      ).toString();
    }

    return normalizedUrl;
  }

  Future<List<BatchModel>> getBatches() async {
    final response = await _apiService.get(AppConstants.batchesEndpoint);
    final responseMap = response as Map<String, dynamic>;
    final data = responseMap['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(BatchModel.fromJson)
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  Future<List<TrainingModel>> getTrainings() async {
    final response = await _apiService.get(AppConstants.trainingsEndpoint);
    final responseMap = response as Map<String, dynamic>;
    final data = responseMap['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(TrainingModel.fromJson)
        .where((item) => item.name.isNotEmpty)
        .toList();
  }

  Future<TrainingModel?> getTrainingDetail(int trainingId) async {
    try {
      final response = await _apiService.get(
        '${AppConstants.trainingsEndpoint.replaceAll('/api', '')}/training/$trainingId',
      );
      final responseMap = response as Map<String, dynamic>;
      final data = responseMap['data'];
      if (data is Map<String, dynamic>) {
        return TrainingModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> sendDeviceToken(String token) async {
    await _apiService.post(
      AppConstants.deviceTokenEndpoint,
      requireAuth: true,
      body: {'device_token': token},
    );
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
