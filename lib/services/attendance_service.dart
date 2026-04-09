import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/models/attendance_model.dart';

class AttendanceService {
  AttendanceService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<void> checkIn({
    required double latitude,
    required double longitude,
    required String status,
    required String note,
  }) async {
    final body = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };

    if (note.trim().isNotEmpty) {
      body['alasan_izin'] = note.trim();
      body['note'] = note.trim();
    }

    await _apiService.post(
      AppConstants.checkInEndpoint,
      body: body,
      requireAuth: true,
    );
  }

  Future<void> checkOut({
    required double latitude,
    required double longitude,
    String note = '',
  }) async {
    final body = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
    };

    if (note.trim().isNotEmpty) {
      body['note'] = note.trim();
    }

    await _apiService.post(
      AppConstants.checkOutEndpoint,
      body: body,
      requireAuth: true,
    );
  }

  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final response = await _apiService.get(
      AppConstants.historyAbsenEndpoint,
      requireAuth: true,
    );

    final responseMap = response as Map<String, dynamic>;
    final data = responseMap['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(AttendanceModel.fromJson)
        .toList();
  }

  Future<void> deleteAttendance(int id) async {
    await _apiService.delete(
      '${AppConstants.deleteAbsenEndpoint}/$id',
      requireAuth: true,
    );
  }

  Future<void> submitIzin({
    required String date,
    required String reason,
    required String type,
  }) async {
    final body = <String, dynamic>{
      'attendance_date': date,
      'alasan_izin': reason,
      'status': type,
    };

    await _apiService.post(
      AppConstants.izinEndpoint,
      body: body,
      requireAuth: true,
    );
  }

  Future<AttendanceModel?> getTodayAttendance() async {
    try {
      final response = await _apiService.get(
        AppConstants.absenTodayEndpoint,
        requireAuth: true,
      );

      final responseMap = response as Map<String, dynamic>;
      final data = responseMap['data'];
      if (data is Map<String, dynamic>) {
        return AttendanceModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getAttendanceStats() async {
    try {
      final response = await _apiService.get(
        AppConstants.absenStatsEndpoint,
        requireAuth: true,
      );

      final responseMap = response as Map<String, dynamic>;
      final data = responseMap['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
