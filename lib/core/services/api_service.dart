import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/api_payload_builder.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/auth_session_model.dart';

class ApiService {
  ApiService({http.Client? client, LocalStorageService? storage})
    : _client = client ?? http.Client(),
      _storage = storage ?? LocalStorageService();

  final http.Client _client;
  final LocalStorageService _storage;

  dynamic _handleResponse(
    http.Response response, {
    bool allowConflict = false,
  }) {
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RAW BODY: ${response.body}');

    dynamic data;
    try {
      data = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
    } catch (_) {
      throw ServerException(
        statusCode: response.statusCode,
        message: 'Response bukan JSON',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300 ||
        (allowConflict && response.statusCode == 409)) {
      return data;
    }

    final message = _extractMessage(data) ?? 'Request failed';

    if (response.statusCode == 401) {
      throw AuthException(message: message);
    }

    if (response.statusCode == 422) {
      throw ValidationException(message: message);
    }

    throw ServerException(statusCode: response.statusCode, message: message);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
          if (value is String && value.trim().isNotEmpty) {
            return value.trim();
          }
        }
      }
    }

    return null;
  }

  Map<String, String> _headers() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  Future<Map<String, String>> _headersWithAuth() async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      throw AuthException(message: 'Token not found');
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<dynamic> get(
    String endpoint, {
    bool requireAuth = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await _client
          .get(uri, headers: requireAuth ? await _headersWithAuth() : _headers())
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException(
        message: 'Server terlalu lama merespons. Silakan coba lagi.',
      );
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
    bool allowConflict = false,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: requireAuth ? await _headersWithAuth() : _headers(),
            body: jsonEncode(body ?? <String, dynamic>{}),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response, allowConflict: allowConflict);
    } on TimeoutException {
      throw NetworkException(
        message: 'Server terlalu lama merespons. Silakan coba lagi.',
      );
    }
  }

  Future<dynamic> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requireAuth = false,
  }) async {
    try {
      final response = await _client
          .put(
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: requireAuth ? await _headersWithAuth() : _headers(),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException(
        message: 'Server terlalu lama merespons. Silakan coba lagi.',
      );
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    bool requireAuth = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await _client
          .delete(
            uri,
            headers: requireAuth ? await _headersWithAuth() : _headers(),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException(
        message: 'Server terlalu lama merespons. Silakan coba lagi.',
      );
    }
  }

  Future<AuthSessionModel> login(String email, String password) async {
    final data = await post(
      AppConstants.loginEndpoint,
      body: {'email': email, 'password': password},
    );

    final session = AuthSessionModel.fromJson(
      data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    if (session.token.isNotEmpty) {
      await _storage.saveToken(session.token);
    }

    return session;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    final data = await post(AppConstants.registerEndpoint, body: body);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getProfile() async {
    final data = await get(AppConstants.profileEndpoint, requireAuth: true);
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> editProfile(Map<String, dynamic> body) async {
    final data = await put(
      AppConstants.editProfileEndpoint,
      body: body,
      requireAuth: true,
    );
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateProfilePhoto(String base64Photo) async {
    final data = await put(
      AppConstants.editProfilePhotoEndpoint,
      body: {'profile_photo': base64Photo},
      requireAuth: true,
    );
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
    required String status,
    String? note,
  }) async {
    try {
      final now = DateTime.now();
      final coordinate = ApiPayloadBuilder.formatCoordinate(
        latitude,
        longitude,
      );
      final body = <String, dynamic>{
        'attendance_date': ApiPayloadBuilder.formatDate(now),
        'check_in': ApiPayloadBuilder.formatTime(now),
        'check_in_lat': latitude,
        'check_in_lng': longitude,
        'check_in_location': coordinate,
        'check_in_address': coordinate,
        'status': status,
      };

      if (status == AppConstants.attendanceStatusPermission &&
          (note?.trim().isNotEmpty ?? false)) {
        body['alasan_izin'] = note!.trim();
      }

      final data = await post(
        AppConstants.checkInEndpoint,
        body: body,
        requireAuth: true,
        allowConflict: true,
      );
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('CHECKIN ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final now = DateTime.now();
      final coordinate = ApiPayloadBuilder.formatCoordinate(
        latitude,
        longitude,
      );

      final data = await post(
        AppConstants.checkOutEndpoint,
        requireAuth: true,
        allowConflict: true,
        body: {
          'attendance_date': ApiPayloadBuilder.formatDate(now),
          'check_out': ApiPayloadBuilder.formatTime(now),
          'check_out_lat': latitude,
          'check_out_lng': longitude,
          'check_out_location': coordinate,
          'check_out_address': coordinate,
        },
      );

      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('CHECKOUT ERROR: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getHistoryAbsen() async {
    try {
      final data = await get(
        AppConstants.historyAbsenEndpoint,
        requireAuth: true,
      );

      if (data is Map<String, dynamic> && data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
      if (data is List<dynamic>) {
        return data;
      }
      return [];
    } catch (e) {
      debugPrint('HISTORY ERROR: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getBatches() async {
    try {
      final data = await get(AppConstants.batchesEndpoint);

      if (data is Map<String, dynamic> && data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
      if (data is List<dynamic>) {
        return data;
      }
      return [];
    } catch (e) {
      debugPrint('GET BATCHES ERROR: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getTrainings() async {
    try {
      final data = await get(AppConstants.trainingsEndpoint);

      if (data is Map<String, dynamic> && data['data'] is List) {
        return data['data'] as List<dynamic>;
      }
      if (data is List<dynamic>) {
        return data;
      }
      return [];
    } catch (e) {
      debugPrint('GET TRAININGS ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteAbsen(int id) async {
    try {
      final data = await delete(
        '${AppConstants.deleteAbsenEndpoint}/$id',
        requireAuth: true,
      );
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('DELETE ERROR: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.clearAuthSession();
  }
}
