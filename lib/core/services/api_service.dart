import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/constants/app_constants.dart';

class ApiService {
  final LocalStorageService _storage = LocalStorageService();

  // ================= COMMON =================
  dynamic _handleResponse(http.Response response) {
    debugPrint("STATUS CODE: ${response.statusCode}");
    debugPrint("RAW BODY: ${response.body}");

    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw Exception("Response bukan JSON: ${response.body}");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(
        data is Map ? data['message'] ?? 'Request failed' : 'Request failed',
      );
    }
  }

  Map<String, String> _headers() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  Future<Map<String, String>> _headersWithAuth() async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // ================= AUTH =================
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.baseUrl}${AppConstants.loginEndpoint}'),
            headers: _headers(),
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      final data = _handleResponse(response);

      if (data is Map && data['token'] != null) {
        await _storage.saveToken(data['token']);
      }

      return data;
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConstants.baseUrl}${AppConstants.registerEndpoint}'),
            headers: _headers(),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      return _handleResponse(response);
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
      rethrow;
    }
  }

  // ================= PROFILE =================
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.profileEndpoint}'),
        headers: await _headersWithAuth(),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint("GET PROFILE ERROR: $e");
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

      return _handleResponse(response);
    } catch (e) {
      debugPrint("EDIT PROFILE ERROR: $e");
      rethrow;
    }
  }

  // ================= ATTENDANCE =================
  Future<Map<String, dynamic>> checkIn(
    double latitude,
    double longitude,
    String status,
    String note,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.checkInEndpoint}'),
        headers: await _headersWithAuth(),
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'status': status,
          'note': note,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint("CHECKIN ERROR: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkOut(
    double latitude,
    double longitude,
    String note,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.checkOutEndpoint}'),
        headers: await _headersWithAuth(),
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'note': note,
        }),
      );

      return _handleResponse(response);
    } catch (e) {
      debugPrint("CHECKOUT ERROR: $e");
      rethrow;
    }
  }

  // ================= HISTORY =================
  Future<List<dynamic>> getHistoryAbsen() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.historyAbsenEndpoint}'),
        headers: await _headersWithAuth(),
      );

      final data = _handleResponse(response);

      if (data is Map && data['data'] is List) {
        return data['data'];
      }

      if (data is List) return data;

      return [];
    } catch (e) {
      debugPrint("HISTORY ERROR: $e");
      rethrow;
    }
  }

  // ================= DROPDOWN =================
  Future<List<dynamic>> getBatches() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.batchesEndpoint}'),
        headers: _headers(),
      );

      final data = _handleResponse(response);

      if (data is Map && data['data'] is List) {
        return data['data'];
      }

      if (data is List) return data;

      return [];
    } catch (e) {
      debugPrint("GET BATCHES ERROR: $e");
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

      if (data is Map && data['data'] is List) {
        return data['data'];
      }

      if (data is List) return data;

      return [];
    } catch (e) {
      debugPrint("GET TRAININGS ERROR: $e");
      rethrow;
    }
  }

  // ================= DELETE =================
  Future<void> deleteAbsen(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.deleteAbsenEndpoint}?id=$id'),
        headers: await _headersWithAuth(),
      );

      _handleResponse(response);
    } catch (e) {
      debugPrint("DELETE ERROR: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.clearToken();
  }
}

