import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/presentation/pages/history_page.dart';
import 'package:presenta_app/presentation/pages/profile_page.dart';
import 'package:presenta_app/presentation/pages/home_content.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  final List<String> _titles = ['Home', 'Riwayat Absensi', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      backgroundColor: AppPalette.backgroundTintFor(context),
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppPalette.brandBlueDark,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: AppPalette.brandBlueDark,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: AppBackground(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 104),
              child: IndexedStack(index: _currentIndex, children: _pages),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _FloatingNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppPalette.surfaceFor(context),
        surfaceTintColor: AppPalette.surfaceFor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppPalette.textPrimaryFor(context),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin logout?',
          style: TextStyle(color: AppPalette.textSecondaryFor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: AppPalette.textSecondaryFor(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () => _handleLogout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.brandBlueDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    Navigator.of(context).pop(); // Close dialog
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    if (!mounted) return;
    // Clear entire nav stack so back button can't return to dashboard
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

class _FloatingNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppPalette.isDark(context);
    final items = const [
      (icon: Icons.home_rounded, label: 'Home'),
      (icon: Icons.history_rounded, label: 'Riwayat'),
      (icon: Icons.person_rounded, label: 'Profil'),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF162033) : Colors.white).withValues(
          alpha: 0.98,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppPalette.borderFor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.14),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;

          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              borderRadius: BorderRadius.circular(26),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppPalette.brandBlueDark
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      color: isSelected
                          ? Colors.white
                          : AppPalette.textSecondaryFor(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppPalette.textSecondaryFor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
