import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/presentation/pages/checkin_form.dart'; // Temp

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  GoogleMapController? _mapController;
  Timer? _clockTimer;

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
        (int) => DateTime.now(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('--:--:--');
        final now = snapshot.data!;
        return Column(
          children: [
            Text(
              DateFormat('HH:mm:ss').format(now),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0A4ED2),
              ),
            ),
            Text(
              DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(now),
              style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Consumer3<AuthProvider, UserProvider, AttendanceProvider>(
              builder:
                  (context, authProvider, userProvider, attendanceProvider, _) {
                    final user = userProvider.user ?? authProvider.currentUser;
                    return GlassmorphicCard(
                      child: Column(
                        children: [
                          // Profile Photo
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0A4ED2),
                                width: 3,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                              backgroundImage: user?.photo != null
                                  ? NetworkImage(user!.photo!)
                                  : null,
                              child: user?.photo == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 45,
                                      color: Color(0xFF0A4ED2),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_getGreeting()}, ${user?.name ?? ''}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0A4ED2),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (user?.batch != null ||
                              user?.training != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${user?.batch ?? ''} | ${user?.training ?? ''}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 12),
                          _realTimeClock(),
                        ],
                      ),
                    );
                  },
            ),
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
                );
              },
            ),
            const SizedBox(height: 24),
            Consumer<AttendanceProvider>(
              builder: (context, attendanceProvider, _) {
                final hasCheckedIn = attendanceProvider.hasCheckedInToday;
                final hasCheckedOut = attendanceProvider.hasCheckedOutToday;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GradientButton(
                            label: hasCheckedIn ? 'Sudah Check In' : 'Check In',
                            isLoading: attendanceProvider.isLoading,
                            enabled: !hasCheckedIn,
                            onPressed: () => _handleCheckIn(context),
                            startColor: hasCheckedIn
                                ? Colors.grey
                                : const Color(0xFF10B981),
                            endColor: hasCheckedIn
                                ? Colors.grey
                                : const Color(0xFF34D399),
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
                                : const Color(0xFFEF4444),
                            endColor: hasCheckedOut
                                ? Colors.grey
                                : const Color(0xFFF87171),
                          ),
                        ),
                      ],
                    ),
                    if (hasCheckedIn || hasCheckedOut)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: GlassmorphicCard(
                          child: Column(
                            children: [
                              const Text(
                                'Status Hari Ini',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0A4ED2),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (hasCheckedIn)
                                    const StatusPill(
                                      label: '✓ Check In',
                                      color: Color(0xFF10B981),
                                    ),
                                  if (hasCheckedOut) ...[
                                    const SizedBox(width: 8),
                                    const StatusPill(
                                      label: '✓ Check Out',
                                      color: Color(0xFF10B981),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _statCard('Total Hadir', Icons.check_circle, context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard('Status Hari Ini', Icons.today, context),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, IconData icon, BuildContext context) {
    return GlassmorphicCard(
      child: Consumer<AttendanceProvider>(
        builder: (context, provider, _) {
          final status = provider.hasCheckedInToday
              ? 'Sudah Masuk'
              : 'Belum Masuk';
          return Column(
            children: [
              Icon(icon, size: 32, color: const Color(0xFF0A4ED2)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              Text(
                title == 'Total Hadir'
                    ? '${provider.attendanceHistory.length}'
                    : status,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: provider.hasCheckedInToday
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
            ],
          );
        },
      ),
    );
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
      builder: (ctx) => AlertDialog(
        title: const Text('Check Out'),
        content: TextFormField(
          controller: noteController,
          decoration: const InputDecoration(hintText: 'Catatan (opsional)'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final attendanceProvider = context.read<AttendanceProvider>();
              final success = await attendanceProvider.checkOut(
                noteController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'Check Out berhasil' : 'Gagal'),
                ),
              );
            },
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

  const StatusPill({Key? key, required this.label, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
