import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:geolocator/geolocator.dart';

class CheckinFormPage extends StatefulWidget {
  const CheckinFormPage({Key? key}) : super(key: key);

  @override
  State<CheckinFormPage> createState() => _CheckinFormPageState();
}

class _CheckinFormPageState extends State<CheckinFormPage> {
  final _reasonController = TextEditingController();
  String? _selectedStatus;
  Position? _currentLocation;
  GoogleMapController? _mapController;
  bool _isLoading = false;

  final List<String> _statuses = AppConstants.attendanceStatuses;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = location;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal mendapatkan lokasi: $e')));
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedStatus == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Status harus dipilih')));
      }
      return;
    }
    if (_selectedStatus == 'Izin Lainnya' &&
        _reasonController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Alasan harus diisi')));
      }
      return;
    }

    setState(() => _isLoading = true);

    final attendanceProvider = context.read<AttendanceProvider>();
    final success = await attendanceProvider.checkIn(
      _selectedStatus!,
      _reasonController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? AppStrings.checkInSuccess : 'Gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.user?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check In'),
        backgroundColor: const Color(0xFF0A6CFF),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name (read-only)
            TextFormField(
              initialValue: userName,
              decoration: const InputDecoration(
                labelText: AppStrings.name,
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: AppStrings.status,
                border: OutlineInputBorder(),
              ),
              items: _statuses
                  .map(
                    (status) =>
                        DropdownMenuItem(value: status, child: Text(status)),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedStatus = value;
                if (value != 'Izin Lainnya') _reasonController.clear();
              }),
            ),
            const SizedBox(height: 16),

            // Reason TextField (conditional)
            if (_selectedStatus == 'Izin Lainnya') ...[
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: AppStrings.reason,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
            ],

            // Location Map Preview
            const Text(
              'Lokasi:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _currentLocation == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _currentLocation!.latitude,
                          _currentLocation!.longitude,
                        ),
                        zoom: AppConstants.defaultMapZoom,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('current'),
                          position: LatLng(
                            _currentLocation!.latitude,
                            _currentLocation!.longitude,
                          ),
                        ),
                      },
                    ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Submit Check In',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
