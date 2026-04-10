import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/models/attendance_model.dart';

enum AttendanceActionType { success, info, error }

class AttendanceActionResult {
  const AttendanceActionResult({
    required this.message,
    required this.type,
    this.attendance,
  });

  final String message;
  final AttendanceActionType type;
  final AttendanceModel? attendance;

  bool get isSuccess => type == AttendanceActionType.success;
  bool get isInfo => type == AttendanceActionType.info;
  bool get isError => type == AttendanceActionType.error;
}

class AttendanceService {
  AttendanceService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<AttendanceActionResult> checkIn({
    required double latitude,
    required double longitude,
    required String status,
    required String note,
  }) async {
    final response = await _apiService.checkIn(
      latitude: latitude,
      longitude: longitude,
      status: status,
      note: note,
    );

    return _mapActionResult(response, isCheckOut: false);
  }

  Future<AttendanceActionResult> checkOut({
    required double latitude,
    required double longitude,
    String note = '',
  }) async {
    final response = await _apiService.checkOut(
      latitude: latitude,
      longitude: longitude,
    );

    return _mapActionResult(response, isCheckOut: true);
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

  Future<AttendanceActionResult> deleteAttendance(int id) async {
    final response = await _apiService.deleteAbsen(id);
    final message =
        (response['message']?.toString().trim().isNotEmpty ?? false)
        ? response['message'].toString().trim()
        : AppStrings.deleteSuccess;

    return AttendanceActionResult(
      message: message,
      type: _classifyDeleteMessage(message),
      attendance: null,
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

  AttendanceActionResult _mapActionResult(
    Map<String, dynamic> response, {
    required bool isCheckOut,
  }) {
    final message =
        (response['message']?.toString().trim().isNotEmpty ?? false)
        ? response['message'].toString().trim()
        : isCheckOut
        ? AppStrings.checkOutSuccess
        : AppStrings.checkInSuccess;
    final data = response['data'];

    return AttendanceActionResult(
      message: message,
      type: _classifyMessage(message, isCheckOut: isCheckOut),
      attendance: data is Map<String, dynamic>
          ? AttendanceModel.fromJson(data)
          : null,
    );
  }

  AttendanceActionType _classifyMessage(
    String message, {
    required bool isCheckOut,
  }) {
    final normalized = message.toLowerCase();

    if (normalized.contains('berhasil')) {
      return AttendanceActionType.success;
    }

    if (normalized.contains('sudah melakukan absen')) {
      return AttendanceActionType.info;
    }

    if (isCheckOut && normalized.contains('belum melakukan absen masuk')) {
      return AttendanceActionType.error;
    }

    return AttendanceActionType.info;
  }

  AttendanceActionType _classifyDeleteMessage(String message) {
    final normalized = message.toLowerCase();

    if (normalized.contains('berhasil')) {
      return AttendanceActionType.success;
    }

    if (normalized.contains('tidak ditemukan') ||
        normalized.contains('bukan milik anda')) {
      return AttendanceActionType.info;
    }

    return AttendanceActionType.error;
  }
}
