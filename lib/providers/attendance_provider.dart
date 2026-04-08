import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  // =======================
  // GET HISTORY
  // =======================
  Future<void> getAttendanceHistory() async {
    try {
      _setLoading(true);
      _error = null;

      _attendanceHistory = await _attendanceService.getAttendanceHistory();

      _checkTodayStatus();
    } catch (e) {
      _error = getErrorMessage(e as Exception);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // =======================
  // CHECK STATUS HARI INI
  // =======================
  void _checkTodayStatus() {
    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final todayAttendance = _attendanceHistory
        .where(
          (attendance) =>
              attendance.date.startsWith(todayString),
        )
        .toList();

    if (todayAttendance.isNotEmpty) {
      final attendance = todayAttendance.last;
      _hasCheckedInToday = attendance.checkInTime != null;
      _hasCheckedOutToday = attendance.checkOutTime != null;
    } else {
      _hasCheckedInToday = false;
      _hasCheckedOutToday = false;
    }

    notifyListeners();
  }

  // =======================
  // CHECK IN
  // =======================
  Future<bool> checkIn(String status, String note) async {
    try {
      _error = null;

      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      await _attendanceService.checkIn(
        latitude: location.latitude,
        longitude: location.longitude,
        status: status,
        note: note,
      );

      await getAttendanceHistory(); // handle loading di dalam
      return true;
    } catch (e) {
      _error = getErrorMessage(e as Exception);
      notifyListeners();
      return false;
    }
  }

  // =======================
  // CHECK OUT
  // =======================
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
      _error = getErrorMessage(e as Exception);
      notifyListeners();
      return false;
    }
  }

  // =======================
  // DELETE
  // =======================
  Future<bool> deleteAttendance(int id) async {
    try {
      _setLoading(true);
      _error = null;

      await _attendanceService.deleteAttendance(id);
      await getAttendanceHistory();

      return true;
    } catch (e) {
      _error = getErrorMessage(e as Exception);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =======================
  // LOCATION
  // =======================
  Future<void> getCurrentLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;
      notifyListeners();
    } catch (e) {
      _error = getErrorMessage(e as Exception);
      notifyListeners();
    }
  }

  // =======================
  // IZIN
  // =======================
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
      _error = getErrorMessage(e as Exception);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =======================
  // TODAY
  // =======================
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
      _error = getErrorMessage(e as Exception);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // =======================
  // STATS
  // =======================
  Future<Map<String, dynamic>> getStats() async {
    try {
      _setLoading(true);
      _error = null;

      return await _attendanceService.getAttendanceStats();
    } catch (e) {
      _error = getErrorMessage(e as Exception);
      notifyListeners();
      return {};
    } finally {
      _setLoading(false);
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
