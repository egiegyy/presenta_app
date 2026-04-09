import 'package:flutter/material.dart';

class AttendanceModel {
  final int id;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final double? checkInLatitude;
  final double? checkInLongitude;
  final double? checkOutLatitude;
  final double? checkOutLongitude;
  final String? checkInAddress;
  final String? checkOutAddress;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? status;
  final String? note;

  AttendanceModel({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLatitude,
    this.checkInLongitude,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkInAddress,
    this.checkOutAddress,
    this.checkInLocation,
    this.checkOutLocation,
    this.status,
    this.note,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
<<<<<<< HEAD
    String? status = json['status']?.toString();
    // Normalize status from API
    if (status == null || status.isEmpty) {
      status = (json['check_in_time'] ?? json['jam_masuk']) != null
          ? 'Hadir'
          : 'Tanpa Keterangan';
    } else if (status.toLowerCase().contains('masuk') ||
        status.toLowerCase().contains('hadir')) {
      status = 'Hadir';
    } else if (status.toLowerCase().contains('sakit') ||
        status.toLowerCase().contains('izin sakit')) {
      status = 'Izin Sakit';
    } else if (status.toLowerCase().contains('izin')) {
      status = 'Izin';
    } else if (status.toLowerCase().contains('tanpa') ||
        status.toLowerCase().contains('keterangan')) {
      status = 'Tanpa Keterangan';
    }

    return AttendanceModel(
      id: json['id'] ?? 0,
      date:
          json['attendance_date']?.toString() ??
          json['date']?.toString() ??
          json['created_at']?.toString() ??
          '',
      checkInTime: json['check_in_time'] ?? json['jam_masuk'],
      checkOutTime: json['check_out_time'] ?? json['jam_keluar'],
      checkInLocation:
          json['check_in_address']?.toString() ??
          json['check_in_location']?.toString() ??
          json['check_out_address']?.toString() ??
          json['check_out_location']?.toString(),
      checkOutLocation:
          json['check_out_address']?.toString() ??
          json['check_out_location']?.toString(),
      status: status,
      note:
          json['alasan_izin']?.toString() ??
          json['note']?.toString() ??
          json['reason']?.toString(),
=======
    final normalizedStatus = _normalizeStatus(
      json['status']?.toString(),
      json['alasan_izin']?.toString(),
    );

    return AttendanceModel(
      id: _parseInt(json['id']),
      date: (json['attendance_date'] ?? json['date'] ?? '').toString(),
      checkInTime: _parseNullableString(
        json['check_in_time'] ?? _extractTime(json['check_in']),
      ),
      checkOutTime: _parseNullableString(
        json['check_out_time'] ?? _extractTime(json['check_out']),
      ),
      checkInLatitude: _parseNullableDouble(json['check_in_lat']),
      checkInLongitude: _parseNullableDouble(json['check_in_lng']),
      checkOutLatitude: _parseNullableDouble(json['check_out_lat']),
      checkOutLongitude: _parseNullableDouble(json['check_out_lng']),
      checkInAddress: _parseNullableString(json['check_in_address']),
      checkOutAddress: _parseNullableString(json['check_out_address']),
      checkInLocation: _parseNullableString(json['check_in_location']),
      checkOutLocation: _parseNullableString(json['check_out_location']),
      status: normalizedStatus,
      note: _parseNullableString(json['alasan_izin'] ?? json['note']),
>>>>>>> 77a89f6 (All done but not UI)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendance_date': date,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_lat': checkInLatitude,
      'check_in_lng': checkInLongitude,
      'check_out_lat': checkOutLatitude,
      'check_out_lng': checkOutLongitude,
      'check_in_address': checkInAddress,
      'check_out_address': checkOutAddress,
      'check_in_location': checkInLocation,
      'check_out_location': checkOutLocation,
      'status': status,
      'alasan_izin': note,
    };
  }

  // Primary status from API or computed
  String getAttendanceStatus() {
    if (status != null && status!.isNotEmpty) {
      return status!;
    }
    if (checkInTime == null) {
      return 'Tanpa Keterangan';
    }
    return 'Hadir';
  }

  Color getStatusColor() {
    switch (getAttendanceStatus()) {
      case 'Hadir':
        return const Color(0xFF10B981); // Green
      case 'Izin Sakit':
      case 'Izin':
        return const Color(0xFFF59E0B); // Yellow
      case 'Tanpa Keterangan':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getStatusBackgroundColor() {
    switch (getAttendanceStatus()) {
      case 'Hadir':
        return const Color(0xFFF0FDF4);
      case 'Izin Sakit':
      case 'Izin':
        return const Color(0xFFFFF7ED);
      case 'Tanpa Keterangan':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF9FAFB);
    }
  }

  Color getStatusBorderColor() {
    switch (getAttendanceStatus()) {
      case 'Hadir':
        return const Color(0xFFDCFCE7);
      case 'Izin Sakit':
      case 'Izin':
        return const Color(0xFFFEF3C7);
      case 'Tanpa Keterangan':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFE5E7EB);
    }
  }
}

String _normalizeStatus(String? status, String? reason) {
  final value = (status ?? '').toLowerCase();
  final normalizedReason = (reason ?? '').toLowerCase();

  if (value.contains('masuk') || value.contains('hadir')) {
    return 'Hadir';
  }

  if (value.contains('izin')) {
    if (normalizedReason.contains('sakit')) {
      return 'Izin Sakit';
    }
    return 'Izin';
  }

  if (value.contains('tanpa') || value.contains('keterangan')) {
    return 'Tanpa Keterangan';
  }

  return 'Hadir';
}

String? _extractTime(dynamic value) {
  final rawValue = value?.toString();
  if (rawValue == null || rawValue.trim().isEmpty) {
    return null;
  }

  if (rawValue.length >= 16 && rawValue.contains(' ')) {
    return rawValue.split(' ').last.substring(0, 5);
  }

  return rawValue.length >= 5 ? rawValue.substring(0, 5) : rawValue;
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double? _parseNullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }

  return double.tryParse(value.toString());
}

String? _parseNullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalizedValue = value.toString().trim();
  return normalizedValue.isEmpty ? null : normalizedValue;
}
