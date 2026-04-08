import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/utils/exceptions.dart';

class ApiService {
  ApiService._internal();

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
      );
    }
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
      throw AuthException(
        message: 'Token tidak ditemukan. Silakan login ulang.',
      );
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
          .get(
            uri,
            headers: requireAuth ? await _headersWithAuth() : _headers(),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } catch (e) {
      throw _mapException(e);
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
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } catch (e) {
      throw _mapException(e);
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

      return _handleResponse(response, allowEmptyBody: true);
    } catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> logout() async {
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
  }
}
