import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/services/attendance_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttendanceProvider>().getAttendanceHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, _) {
        if (attendanceProvider.isLoading &&
            attendanceProvider.attendanceHistory.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppPalette.brandBlueDark),
            ),
          );
        }

        final presentCount = _countStatuses(attendanceProvider, const [
          'Hadir',
        ]);
        final permissionCount = _countStatuses(attendanceProvider, const [
          'Izin',
          'Izin Sakit',
        ]);
        final absentCount = _countStatuses(attendanceProvider, const [
          'Tanpa Keterangan',
        ]);

        return RefreshIndicator(
          onRefresh: () =>
              context.read<AttendanceProvider>().getAttendanceHistory(),
          child: attendanceProvider.attendanceHistory.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
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
                    const SizedBox(height: 28),
                    GlassmorphicCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Icon(
                                Icons.event_busy_rounded,
                                size: 40,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              AppStrings.noData,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Riwayat absensi Anda akan tampil di sini setelah data tersedia.',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                height: 1.5,
                                color: AppPalette.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  itemCount: attendanceProvider.attendanceHistory.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
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
                      );
                    }

                    final attendance =
                        attendanceProvider.attendanceHistory[index - 1];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassmorphicCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.date,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppPalette.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        attendance.date,
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: AppPalette.brandBlueDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: attendance
                                        .getStatusBackgroundColor(),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: attendance.getStatusBorderColor(),
                                    ),
                                  ),
                                  child: Text(
                                    attendance.getAttendanceStatus(),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: attendance.getStatusColor(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: attendanceProvider.isLoading
                                      ? null
                                      : () => _confirmDelete(
                                          context,
                                          attendance.id,
                                        ),
                                  tooltip: 'Hapus absensi',
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppPalette.pastelRedText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              runSpacing: 12,
                              children: [
                                if (attendance.checkInTime != null)
                                  _HistoryDetailTile(
                                    label: AppStrings.checkInTime,
                                    value: attendance.checkInTime ?? '-',
                                    icon: Icons.login_rounded,
                                    color: AppPalette.pastelGreenText,
                                  ),
                                if (attendance.checkOutTime != null)
                                  _HistoryDetailTile(
                                    label: AppStrings.checkOutTime,
                                    value: attendance.checkOutTime ?? '-',
                                    icon: Icons.logout_rounded,
                                    color: AppPalette.pastelRedText,
                                  ),
                                if (attendance.checkInLocation != null)
                                  _HistoryDetailTile(
                                    label: AppStrings.location,
                                    value: attendance.checkInLocation ?? '-',
                                    icon: Icons.location_on_rounded,
                                    color: AppPalette.brandBlueDark,
                                  ),
                                if (attendance.note != null)
                                  _HistoryDetailTile(
                                    label: 'Catatan',
                                    value: attendance.note ?? '-',
                                    icon: Icons.sticky_note_2_rounded,
                                    color: AppPalette.pastelYellowText,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  int _countStatuses(AttendanceProvider provider, List<String> statuses) {
    return provider.attendanceHistory
        .where(
          (attendance) => statuses.contains(attendance.getAttendanceStatus()),
        )
        .length;
  }

  Future<void> _confirmDelete(BuildContext context, int id) async {
    final isDark = AppPalette.isDark(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppPalette.surfaceFor(context),
        surfaceTintColor: AppPalette.surfaceFor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Hapus Absensi',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimaryFor(context),
          ),
        ),
        content: Text(
          'Data absensi ini akan dihapus permanen. Lanjutkan?',
          style: GoogleFonts.inter(
            color: AppPalette.textSecondaryFor(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(color: AppPalette.textSecondaryFor(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final result = await context.read<AttendanceProvider>()
                  .deleteAttendance(id);
              if (!context.mounted) return;

              switch (result.type) {
                case AttendanceActionType.success:
                  SuccessSnackbar.show(context, result.message);
                  break;
                case AttendanceActionType.info:
                  AppSnackbar.show(context, result.message);
                  break;
                case AttendanceActionType.error:
                  ErrorSnackbar.show(context, result.message);
                  break;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFFEF4444)
                  : AppPalette.pastelRedText,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _HistoryDetailTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _HistoryDetailTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppPalette.isDark(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.textSecondaryFor(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.textPrimaryFor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
