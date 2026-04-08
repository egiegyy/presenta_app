import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/location_service.dart';
import 'package:presenta_app/models/attendance_model.dart';

class AttendanceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getHistoryAbsen();
      _attendanceHistory = response
          .map((item) => AttendanceModel.fromJson(item))
          .toList();

      _checkTodayStatus();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void _checkTodayStatus() {
    final today = DateTime.now();
    final todayString =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final todayAttendance = _attendanceHistory
        .where((attendance) => attendance.date == todayString)
        .toList();

    if (todayAttendance.isNotEmpty) {
      final attendance = todayAttendance.first;
      _hasCheckedInToday = attendance.checkInTime != null;
      _hasCheckedOutToday = attendance.checkOutTime != null;
    } else {
      _hasCheckedInToday = false;
      _hasCheckedOutToday = false;
    }

    // Auto Tanpa Keterangan if past 15:00 and no check-in
    final currentTime = DateTime.now();
    final cutoffTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      15,
      0,
    );

    if (currentTime.isAfter(cutoffTime) && !_hasCheckedInToday) {
      final tanpaKeterangan = AttendanceModel(
        id: -1,
        date: todayString,
        status: 'Tanpa Keterangan',
      );
      final existing = _attendanceHistory
          .where((a) => a.id == -1 && a.date == todayString)
          .toList();
      if (existing.isEmpty) {
        _attendanceHistory.insert(0, tanpaKeterangan);
      }
    }
  }

  Future<bool> checkIn(String status, String note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      await _apiService.checkIn(
        location.latitude,
        location.longitude,
        status,
        note,
      );

      _hasCheckedInToday = true;
      _isLoading = false;
      notifyListeners();

      // Refresh
      await getAttendanceHistory();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkOut(String note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;

      await _apiService.checkOut(location.latitude, location.longitude, note);

      _hasCheckedOutToday = true;
      _isLoading = false;
      notifyListeners();

      await getAttendanceHistory();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAttendance(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteAbsen(id);
      _isLoading = false;
      await getAttendanceHistory();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
