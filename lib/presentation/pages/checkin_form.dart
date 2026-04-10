import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/core/services/location_service.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/services/attendance_service.dart';
import 'package:geolocator/geolocator.dart';

class CheckinFormPage extends StatefulWidget {
  const CheckinFormPage({super.key});

  @override
  State<CheckinFormPage> createState() => _CheckinFormPageState();
}

class _CheckinFormPageState extends State<CheckinFormPage> {
  final _reasonController = TextEditingController();
  String? _selectedStatus;
  Position? _currentLocation;
  bool _isLoading = false;
  GoogleMapController? _mapController;

  final List<String> _statuses = AppConstants.attendanceStatuses;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      // Use LocationService to handle permissions properly before getting position
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      if (mounted) {
        setState(() {
          _currentLocation = position;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorSnackbar.show(
          context,
          'Gagal mendapatkan lokasi: ${e.toString().replaceAll('Exception: ', '')}',
        );
      }
    }
  }

  Future<void> _submit() async {
    if (_selectedStatus == null) {
      if (mounted) {
        ErrorSnackbar.show(context, 'Status harus dipilih');
      }
      return;
    }
    if (_selectedStatus == 'Izin Lainnya' &&
        _reasonController.text.trim().isEmpty) {
      if (mounted) {
        ErrorSnackbar.show(context, 'Alasan harus diisi');
      }
      return;
    }

    setState(() => _isLoading = true);

    final attendanceProvider = context.read<AttendanceProvider>();
    final result = await attendanceProvider.checkIn(
      _selectedStatus!,
      _reasonController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);

      if (!result.isError) {
        Navigator.pop(context);
      }

      switch (result.type) {
        case AttendanceActionType.success:
          SuccessSnackbar.show(context, result.message);
          break;
        case AttendanceActionType.error:
          ErrorSnackbar.show(context, result.message);
          break;
        case AttendanceActionType.info:
          AppSnackbar.show(context, result.message);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.user?.name ?? '';
    final isDark = AppPalette.isDark(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check In',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF0A6CFF),
        foregroundColor: Colors.white,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: GlassmorphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Check In',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.textPrimaryFor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pastikan data dan lokasi Anda sudah sesuai sebelum mengirim presensi masuk.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.5,
                    color: AppPalette.textSecondaryFor(context),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: userName,
                  decoration: const InputDecoration(
                    labelText: AppStrings.name,
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: AppStrings.status,
                    border: OutlineInputBorder(),
                  ),
                  items: _statuses
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedStatus = value;
                    if (value != 'Izin Lainnya') _reasonController.clear();
                  }),
                ),
                const SizedBox(height: 16),
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
                Text(
                  'Lokasi:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textPrimaryFor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppPalette.borderFor(context)),
                    borderRadius: BorderRadius.circular(12),
                    color: isDark ? const Color(0xFF111827) : Colors.white,
                  ),
                  child: _currentLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          onMapCreated: _onMapCreated,
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
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}
