import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/api_payload_builder.dart';
import 'package:presenta_app/core/services/location_service.dart';
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/attendance_model.dart';
import 'package:presenta_app/services/attendance_service.dart';

class AttendanceProvider extends ChangeNotifier {
  AttendanceProvider({
    AttendanceService? attendanceService,
    LocationService? locationService,
  }) : _attendanceService = attendanceService ?? AttendanceService(),
       _locationService = locationService ?? LocationService();

  final AttendanceService _attendanceService;
  final LocationService _locationService;

  List<AttendanceModel> _attendanceHistory = [];
  bool _isLoading = false;
  String? _error;
  bool _hasCheckedInToday = false;
  bool _hasCheckedOutToday = false;
  Position? _currentLocation;
  String? _lastActionMessage;
  AttendanceActionType? _lastActionType;

  List<AttendanceModel> get attendanceHistory => _attendanceHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCheckedInToday => _hasCheckedInToday;
  bool get hasCheckedOutToday => _hasCheckedOutToday;
  Position? get currentLocation => _currentLocation;
  String? get lastActionMessage => _lastActionMessage;
  AttendanceActionType? get lastActionType => _lastActionType;

  Future<void> getAttendanceHistory() async {
    try {
      _setLoading(true);
      _error = null;

      _attendanceHistory = await _attendanceService.getAttendanceHistory();
      _checkTodayStatus();
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _checkTodayStatus() {
    final todayString = ApiPayloadBuilder.formatDate(DateTime.now());
    final todayAttendance = _attendanceHistory
        .where((attendance) => attendance.date.startsWith(todayString))
        .toList();

    if (todayAttendance.isEmpty) {
      _hasCheckedInToday = false;
      _hasCheckedOutToday = false;
      return;
    }

    final attendance = todayAttendance.first;
    _hasCheckedInToday = attendance.checkInTime != null;
    _hasCheckedOutToday = attendance.checkOutTime != null;
  }

  Future<AttendanceActionResult> checkIn(String status, String note) async {
    try {
      _setLoading(true);
      _error = null;
      _lastActionMessage = null;
      _lastActionType = null;

      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      final result = await _attendanceService.checkIn(
        latitude: location.latitude,
        longitude: location.longitude,
        status: _mapStatusForApi(status),
        note: note,
      );

      _lastActionMessage = result.message;
      _lastActionType = result.type;
      _applyAttendanceResult(result);
      await _refreshHistorySilently();
      return result;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      _lastActionMessage = _error;
      _lastActionType = AttendanceActionType.error;
      notifyListeners();
      return AttendanceActionResult(
        message: _error ?? 'Gagal check in',
        type: AttendanceActionType.error,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<AttendanceActionResult> checkOut(String note) async {
    try {
      _setLoading(true);
      _error = null;
      _lastActionMessage = null;
      _lastActionType = null;

      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      final result = await _attendanceService.checkOut(
        latitude: location.latitude,
        longitude: location.longitude,
        note: note,
      );

      _lastActionMessage = result.message;
      _lastActionType = result.type;

      _applyAttendanceResult(result);
      await _refreshHistorySilently();

      return result;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      _lastActionMessage = _error;
      _lastActionType = AttendanceActionType.error;
      notifyListeners();
      return AttendanceActionResult(
        message: _error ?? 'Gagal check out',
        type: AttendanceActionType.error,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<AttendanceActionResult> deleteAttendance(int id) async {
    try {
      _setLoading(true);
      _error = null;
      _lastActionMessage = null;
      _lastActionType = null;

      final result = await _attendanceService.deleteAttendance(id);
      _lastActionMessage = result.message;
      _lastActionType = result.type;

      if (result.isSuccess) {
        _attendanceHistory.removeWhere((item) => item.id == id);
        _checkTodayStatus();
      } else {
        await _refreshHistorySilently();
      }

      notifyListeners();

      return result;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      _lastActionMessage = _error;
      _lastActionType = AttendanceActionType.error;
      notifyListeners();
      return AttendanceActionResult(
        message: _error ?? 'Gagal menghapus absensi',
        type: AttendanceActionType.error,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;
      notifyListeners();
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
    }
  }

  Future<bool> submitIzin({
    required String date,
    required String reason,
    required String type,
  }) async {
    try {
      _setLoading(true);
      _error = null;

      await _attendanceService.submitIzin(
        date: date,
        reason: reason,
        type: type,
      );

      await getAttendanceHistory();
      return true;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTodayAttendance() async {
    try {
      _setLoading(true);
      _error = null;

      final today = await _attendanceService.getTodayAttendance();
      if (today != null) {
        _hasCheckedInToday = today.checkInTime != null;
        _hasCheckedOutToday = today.checkOutTime != null;
      }

      notifyListeners();
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      _setLoading(true);
      _error = null;

      return await _attendanceService.getAttendanceStats();
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
      return {};
    } finally {
      _setLoading(false);
    }
  }

  String _mapStatusForApi(String status) {
    switch (status) {
      case AppStrings.hadir:
        return AppConstants.attendanceStatusPresent;
      case AppStrings.izinSakit:
      case AppStrings.izinLainnya:
        return AppConstants.attendanceStatusPermission;
      default:
        return AppConstants.attendanceStatusPresent;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _applyAttendanceResult(AttendanceActionResult result) {
    final attendance = result.attendance;
    if (attendance == null) {
      notifyListeners();
      return;
    }

    final todayString = ApiPayloadBuilder.formatDate(DateTime.now());
    final index = _attendanceHistory.indexWhere(
      (item) => item.id == attendance.id || item.date.startsWith(todayString),
    );

    if (index >= 0) {
      _attendanceHistory[index] = attendance;
    } else {
      _attendanceHistory.insert(0, attendance);
    }

    _hasCheckedInToday = attendance.checkInTime != null;
    _hasCheckedOutToday = attendance.checkOutTime != null;
    notifyListeners();
  }

  Future<void> _refreshHistorySilently() async {
    try {
      final history = await _attendanceService.getAttendanceHistory();
      _attendanceHistory = history;
      _checkTodayStatus();
      notifyListeners();
    } catch (_) {
      // Keep the successful action result on screen even if history refresh is slow.
    }
  }
}
