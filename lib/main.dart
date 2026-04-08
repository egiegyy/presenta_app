import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/providers/theme_provider.dart';
import 'package:presenta_app/presentation/pages/login_page.dart';
import 'package:presenta_app/presentation/pages/register_page.dart';
import 'package:presenta_app/presentation/pages/dashboard_page.dart';
import 'package:presenta_app/presentation/pages/history_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'PRESENTA',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const AuthenticationWrapper(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/dashboard': (context) => const DashboardPage(),
              '/history': (context) => const HistoryPage(),
            },
          );
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAuth();
    });
  }

  Future<void> _initAuth() async {
    final authProvider = context.read<AuthProvider>();

    await authProvider.checkLoginStatus();

    if (!mounted) return;

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // 🔥 LOADING STATE (FIX BUG)
        if (!_isInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isLoggedIn) {
          return const DashboardPage();
        }

        return const LoginPage();
      },
    );
  }
}
