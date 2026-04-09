import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/config/localization_config.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/presentation/pages/checkin_form.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
<<<<<<< HEAD
  Timer? _clockTimer;
  GoogleMapController? _mapController;

=======
>>>>>>> 77a89f6 (All done but not UI)
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final attendanceProvider = context.read<AttendanceProvider>();
    final userProvider = context.read<UserProvider>();
    attendanceProvider.getAttendanceHistory();
    attendanceProvider.getCurrentLocation();
    userProvider.getProfile();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Widget _realTimeClock() {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('--:--:--');
        }

        final now = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('HH:mm:ss').format(now),
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppPalette.brandBlueDark,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              DateFormat(
                'EEEE, dd MMMM yyyy',
                LocalizationConfig.dateLocale,
              ).format(now),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppPalette.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer3<AuthProvider, UserProvider, AttendanceProvider>(
              builder:
                  (context, authProvider, userProvider, attendanceProvider, _) {
                    final user = userProvider.user ?? authProvider.currentUser;

                    return GlassmorphicCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppPalette.brandBlueDark,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  user?.name ?? '-',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppPalette.textSecondary,
                                  ),
                                ),
                                if (user?.batch != null ||
                                    user?.training != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppPalette.backgroundTint,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      '${user?.batch ?? '-'} | ${user?.training ?? '-'}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppPalette.brandBlueDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppPalette.brandBlueDark,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPalette.brandBlue.withValues(
                                    alpha: 0.18,
                                  ),
                                  blurRadius: 22,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 34,
                              backgroundColor: Colors.white,
                              backgroundImage: user?.photo != null
                                  ? NetworkImage(user!.photo!)
                                  : null,
                              child: user?.photo == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 34,
                                      color: AppPalette.brandBlueDark,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
            ),
<<<<<<< HEAD
            const SizedBox(height: 24),
            Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, _) {
                final location = attendanceProvider.currentLocation;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 250,
                    child: location == null
                        ? const Center(child: CircularProgressIndicator())
                        : GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                location.latitude,
                                location.longitude,
                              ),
                              zoom: AppConstants.defaultMapZoom,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            markers: {
                              Marker(
                                markerId: const MarkerId('current'),
                                position: LatLng(
                                  location.latitude,
                                  location.longitude,
                                ),
                                infoWindow: const InfoWindow(
                                  title: 'Lokasi Anda',
                                ),
                              ),
                            },
                          ),
=======
            const SizedBox(height: 18),
            GlassmorphicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Waktu Sekarang',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.textSecondary,
                    ),
>>>>>>> 77a89f6 (All done but not UI)
                  ),
                  const SizedBox(height: 10),
                  _realTimeClock(),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, _) {
                final presentCount = _countStatuses(attendanceProvider, const [
                  'Hadir',
                ]);
                final permissionCount = _countStatuses(
                  attendanceProvider,
                  const ['Izin', 'Izin Sakit'],
                );
                final absentCount = _countStatuses(attendanceProvider, const [
                  'Tanpa Keterangan',
                ]);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Kehadiran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AttendanceSummaryCard(
                            label: 'Hadir',
                            value: '$presentCount',
                            icon: Icons.check_circle_rounded,
                            backgroundColor: AppPalette.pastelGreen,
                            borderColor: AppPalette.pastelGreenBorder,
                            textColor: AppPalette.pastelGreenText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AttendanceSummaryCard(
                            label: 'Izin',
                            value: '$permissionCount',
                            icon: Icons.assignment_turned_in_rounded,
                            backgroundColor: AppPalette.pastelYellow,
                            borderColor: AppPalette.pastelYellowBorder,
                            textColor: AppPalette.pastelYellowText,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AttendanceSummaryCard(
                            label: 'Tidak hadir',
                            value: '$absentCount',
                            icon: Icons.cancel_rounded,
                            backgroundColor: AppPalette.pastelRed,
                            borderColor: AppPalette.pastelRedBorder,
                            textColor: AppPalette.pastelRedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, _) {
                final location = attendanceProvider.currentLocation;
                final hasCheckedIn = attendanceProvider.hasCheckedInToday;
                final hasCheckedOut = attendanceProvider.hasCheckedOutToday;

                return GlassmorphicCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Presensi Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppPalette.brandBlueDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Lihat posisi Anda dan lakukan check in atau check out dari section yang sama.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 240,
                          child: location == null
                              ? Container(
                                  color: AppPalette.backgroundTint,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        AppPalette.brandBlueDark,
                                      ),
                                    ),
                                  ),
                                )
                              : GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      location.latitude,
                                      location.longitude,
                                    ),
                                    zoom: AppConstants.defaultMapZoom,
                                  ),
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('current'),
                                      position: LatLng(
                                        location.latitude,
                                        location.longitude,
                                      ),
                                      infoWindow: const InfoWindow(
                                        title: 'Lokasi Anda',
                                      ),
                                    ),
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: GradientButton(
                              label: hasCheckedIn
                                  ? 'Sudah Check In'
                                  : 'Check In',
                              isLoading: attendanceProvider.isLoading,
                              enabled: !hasCheckedIn,
                              onPressed: () => _handleCheckIn(context),
                              startColor: hasCheckedIn
                                  ? Colors.grey
                                  : const Color(0xFF20B26B),
                              endColor: hasCheckedIn
                                  ? Colors.grey
                                  : const Color(0xFF59D59B),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GradientButton(
                              label: hasCheckedOut
                                  ? 'Sudah Check Out'
                                  : 'Check Out',
                              isLoading: attendanceProvider.isLoading,
                              enabled: !hasCheckedOut,
                              onPressed: () => _handleCheckOut(context),
                              startColor: hasCheckedOut
                                  ? Colors.grey
                                  : const Color(0xFFD94A4A),
                              endColor: hasCheckedOut
                                  ? Colors.grey
                                  : const Color(0xFFF27C7C),
                            ),
                          ),
                        ],
                      ),
                      if (hasCheckedIn || hasCheckedOut) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            if (hasCheckedIn)
                              const StatusPill(
                                label: 'Check In aktif',
                                color: AppPalette.pastelGreenText,
                                backgroundColor: AppPalette.pastelGreen,
                                borderColor: AppPalette.pastelGreenBorder,
                              ),
                            if (hasCheckedOut)
                              const StatusPill(
                                label: 'Check Out aktif',
                                color: AppPalette.pastelRedText,
                                backgroundColor: AppPalette.pastelRed,
                                borderColor: AppPalette.pastelRedBorder,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  int _countStatuses(AttendanceProvider provider, List<String> statuses) {
    return provider.attendanceHistory
        .where(
          (attendance) => statuses.contains(attendance.getAttendanceStatus()),
        )
        .length;
  }

  void _handleCheckIn(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CheckinFormPage()));
  }

  void _handleCheckOut(BuildContext context) async {
    final noteController = TextEditingController();
    showDialog(
      context: context,
<<<<<<< HEAD
      builder: (dialogContext) => AlertDialog(
        title: const Text('Check Out'),
=======
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Check Out',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppPalette.brandBlueDark,
          ),
        ),
>>>>>>> 77a89f6 (All done but not UI)
        content: TextFormField(
          controller: noteController,
          decoration: InputDecoration(
            hintText: 'Catatan (opsional)',
            filled: true,
            fillColor: AppPalette.backgroundTint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
<<<<<<< HEAD
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
=======
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppPalette.textSecondary),
            ),
>>>>>>> 77a89f6 (All done but not UI)
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext); // close dialog first
              final attendanceProvider = context.read<AttendanceProvider>();
              final success = await attendanceProvider.checkOut(
                noteController.text.trim(),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? AppStrings.checkOutSuccess
                          : (attendanceProvider.error ?? 'Gagal check out'),
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlueDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Check Out'),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

<<<<<<< HEAD
  const StatusPill({super.key, required this.label, required this.color});
=======
  const StatusPill({
    Key? key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  }) : super(key: key);
>>>>>>> 77a89f6 (All done but not UI)

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
