<<<<<<< HEAD
import 'package:http/http.dart' as http;
import 'dart:async';
=======
>>>>>>> 77a89f6 (All done but not UI)
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:presenta_app/core/constants/app_constants.dart';
<<<<<<< HEAD
import 'package:presenta_app/core/utils/exceptions.dart';
=======
import 'package:presenta_app/core/services/api_payload_builder.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/auth_session_model.dart';
>>>>>>> 77a89f6 (All done but not UI)

class ApiService {
  ApiService._internal();

<<<<<<< HEAD
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final LocalStorageService _storage = LocalStorageService();
  final http.Client _client = http.Client();

  dynamic _handleResponse(
    http.Response response, {
    bool allowEmptyBody = false,
  }) {
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RAW BODY: ${response.body}');

    if (allowEmptyBody && response.body.trim().isEmpty) {
      return <String, dynamic>{};
    }

    dynamic data;
    try {
      data = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
    } catch (e) {
      throw ServerException(
        statusCode: response.statusCode,
        message: 'Response API tidak valid.',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else if (response.statusCode == 401) {
      throw AuthException(
        message: data is Map<String, dynamic>
            ? (data['message']?.toString() ?? AppStrings.tokenExpired)
            : AppStrings.tokenExpired,
      );
    } else if (response.statusCode == 422) {
      throw ValidationException(
        message: _extractMessage(data) ?? 'Data yang dikirim tidak valid.',
      );
    } else {
      throw ServerException(
        statusCode: response.statusCode,
        message: _extractMessage(data) ?? AppStrings.serverError,
=======
  dynamic _handleResponse(
    http.Response response, {
    bool allowConflict = false,
  }) {
    debugPrint('STATUS CODE: ${response.statusCode}');
    debugPrint('RAW BODY: ${response.body}');

    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {
      throw ServerException(
        statusCode: response.statusCode,
        message: 'Response bukan JSON',
>>>>>>> 77a89f6 (All done but not UI)
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300 ||
        (allowConflict && response.statusCode == 409)) {
      return data;
    }

    final message = data is Map<String, dynamic>
        ? (data['message'] ?? 'Request failed').toString()
        : 'Request failed';

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
<<<<<<< HEAD
      throw AuthException(
        message: 'Token tidak ditemukan. Silakan login ulang.',
      );
=======
      throw AuthException(message: 'Token not found');
>>>>>>> 77a89f6 (All done but not UI)
    }

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

<<<<<<< HEAD
  Future<dynamic> get(
    String endpoint, {
    bool requireAuth = false,
    Map<String, dynamic>? queryParameters,
  }) async {
=======
  Future<AuthSessionModel> login(String email, String password) async {
>>>>>>> 77a89f6 (All done but not UI)
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await _client
          .get(
            uri,
            headers: requireAuth ? await _headersWithAuth() : _headers(),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

<<<<<<< HEAD
      return _handleResponse(response);
    } catch (e) {
      throw _mapException(e);
=======
      final data = _handleResponse(response);
      final session = AuthSessionModel.fromJson(
        data is Map<String, dynamic> ? data : <String, dynamic>{},
      );
      await _storage.saveToken(session.token);
      return session;
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      rethrow;
>>>>>>> 77a89f6 (All done but not UI)
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = false,
  }) async {
    try {
      final response = await _client
          .post(
<<<<<<< HEAD
            Uri.parse('${AppConstants.baseUrl}$endpoint'),
            headers: requireAuth ? await _headersWithAuth() : _headers(),
            body: jsonEncode(body ?? <String, dynamic>{}),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } catch (e) {
      throw _mapException(e);
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
=======
            Uri.parse(
              '${AppConstants.baseUrl}${AppConstants.registerEndpoint}',
            ),
            headers: _headers(),
>>>>>>> 77a89f6 (All done but not UI)
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
<<<<<<< HEAD
      throw _mapException(e);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    bool requireAuth = false,
    Map<String, dynamic>? queryParameters,
  }) async {
=======
      debugPrint('REGISTER ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
>>>>>>> 77a89f6 (All done but not UI)
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint').replace(
        queryParameters: queryParameters?.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

<<<<<<< HEAD
      final response = await _client
          .delete(
            uri,
            headers: requireAuth ? await _headersWithAuth() : _headers(),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response, allowEmptyBody: true);
    } catch (e) {
      throw _mapException(e);
=======
      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('GET PROFILE ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> editProfile(Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.editProfileEndpoint}'),
        headers: await _headersWithAuth(),
        body: jsonEncode(body),
      );

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('EDIT PROFILE ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfilePhoto(String base64Photo) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.editProfilePhotoEndpoint}',
        ),
        headers: await _headersWithAuth(),
        body: jsonEncode({'profile_photo': base64Photo}),
      );

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('EDIT PROFILE PHOTO ERROR: $e');
      rethrow;
    }
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

      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.checkInEndpoint}'),
        headers: await _headersWithAuth(),
        body: jsonEncode(body),
      );

      final data = _handleResponse(response, allowConflict: true);
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
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.checkOutEndpoint}'),
        headers: await _headersWithAuth(),
        body: jsonEncode({
          'attendance_date': ApiPayloadBuilder.formatDate(now),
          'check_out': ApiPayloadBuilder.formatTime(now),
          'check_out_lat': latitude,
          'check_out_lng': longitude,
          'check_out_location': coordinate,
          'check_out_address': coordinate,
        }),
      );

      final data = _handleResponse(response, allowConflict: true);
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } catch (e) {
      debugPrint('CHECKOUT ERROR: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getHistoryAbsen() async {
    try {
      final response = await http.get(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.historyAbsenEndpoint}',
        ),
        headers: await _headersWithAuth(),
      );

      final data = _handleResponse(response);
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
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.batchesEndpoint}'),
        headers: _headers(),
      );

      final data = _handleResponse(response);
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
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.trainingsEndpoint}'),
        headers: _headers(),
      );

      final data = _handleResponse(response);
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

  Future<void> deleteAbsen(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '${AppConstants.baseUrl}${AppConstants.deleteAbsenEndpoint}?id=$id',
        ),
        headers: await _headersWithAuth(),
      );

      _handleResponse(response);
    } catch (e) {
      debugPrint('DELETE ERROR: $e');
      rethrow;
>>>>>>> 77a89f6 (All done but not UI)
    }
  }

  Future<void> logout() async {
<<<<<<< HEAD
    await _storage.clearToken();
    await _storage.clearProfileImagePath();
  }

  Exception _mapException(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is TimeoutException) {
      return NetworkException(message: 'Koneksi ke server timeout.');
    }
    if (error is http.ClientException) {
      return NetworkException(message: 'Gagal terhubung ke server.');
    }
    if (error is FormatException) {
      return ServerException(
        statusCode: 500,
        message: 'Format response server tidak valid.',
      );
    }
    return AppException(
      message: error.toString().replaceAll('Exception: ', ''),
    );
=======
    await _storage.clear();
>>>>>>> 77a89f6 (All done but not UI)
  }
}
