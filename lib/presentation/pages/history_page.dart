import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/core/constants/app_constants.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          AppStrings.history,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A6CFF), Color(0xFF92C7FF), Color(0xFFF5FAFF)],
          ),
        ),
        child: SafeArea(
          child: Consumer<AttendanceProvider>(
            builder: (context, attendanceProvider, _) {
              if (attendanceProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (attendanceProvider.attendanceHistory.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.noData,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: attendanceProvider.attendanceHistory.length,
                itemBuilder: (context, index) {
                  final attendance =
                      attendanceProvider.attendanceHistory[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassmorphicCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.date,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      attendance.date,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0A4ED2),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: attendance
                                        .getStatusBackgroundColor(),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: attendance.getStatusBorderColor(),
                                    ),
                                  ),
                                  child: Text(
                                    attendance.getAttendanceStatus(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: attendance.getStatusColor(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            if (attendance.checkInTime != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    AppStrings.checkInTime,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Color(0xFF0A4ED2),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        attendance.checkInTime ?? '-',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (attendance.checkInTime != null)
                              const SizedBox(height: 12),

                            if (attendance.checkOutTime != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    AppStrings.checkOutTime,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Color(0xFFEF4444),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        attendance.checkOutTime ?? '-',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFEF4444),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            if (attendance.checkOutTime != null)
                              const SizedBox(height: 12),

                            if (attendance.checkInLocation != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    AppStrings.location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Color(0xFF0A4ED2),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          attendance.checkInLocation ?? '-',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF475569),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
