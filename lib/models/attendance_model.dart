import 'package:flutter/material.dart';

class AttendanceModel {
  final int id;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final String? checkInLocation;
  final String? checkOutLocation;
  final String? status;
  final String? note; // Add note/reason field

  AttendanceModel({
    required this.id,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLocation,
    this.checkOutLocation,
    this.status,
    this.note,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    String? status = json['status'];
    // Normalize status from API
    if (status == null || status.isEmpty) {
      status = 'Present'; // Fallback
    } else if (status.toLowerCase().contains('hadir')) {
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
      date: json['date'] ?? json['created_at'] ?? '',
      checkInTime: json['check_in_time'] ?? json['jam_masuk'],
      checkOutTime: json['check_out_time'] ?? json['jam_keluar'],
      checkInLocation: json['check_in_location'],
      checkOutLocation: json['check_out_location'],
      status: status,
      note: json['note'] ?? json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'check_in_location': checkInLocation,
      'check_out_location': checkOutLocation,
      'status': status,
      'note': note,
    };
  }

  // Primary status from API or computed
  String getAttendanceStatus() {
    if (status != null && status!.isNotEmpty) {
      return status!;
    }
    // Fallback: no check-in = Tanpa Keterangan
    if (checkInTime == null) {
      return 'Tanpa Keterangan';
    }
    return 'Hadir'; // Default if checked in
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
