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

  List<AttendanceModel> get attendanceHistory => _attendanceHistory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasCheckedInToday => _hasCheckedInToday;
  bool get hasCheckedOutToday => _hasCheckedOutToday;
  Position? get currentLocation => _currentLocation;

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

  Future<bool> checkIn(String status, String note) async {
    try {
      _error = null;

      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      await _attendanceService.checkIn(
        latitude: location.latitude,
        longitude: location.longitude,
        status: _mapStatusForApi(status),
        note: note,
      );

      await getAttendanceHistory();
      return true;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkOut(String note) async {
    try {
      _error = null;

      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      await _attendanceService.checkOut(
        latitude: location.latitude,
        longitude: location.longitude,
        note: note,
      );

      await getAttendanceHistory();
      return true;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAttendance(int id) async {
    try {
      _setLoading(true);
      _error = null;

      await _attendanceService.deleteAttendance(id);
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
}
