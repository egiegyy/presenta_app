import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/config/localization_config.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/services/location_service.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/providers/attendance_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/providers/theme_provider.dart';
import 'package:presenta_app/presentation/pages/login_page.dart';
import 'package:presenta_app/presentation/pages/register_page.dart';
import 'package:presenta_app/presentation/pages/dashboard_page.dart';
import 'package:presenta_app/presentation/pages/history_page.dart';
import 'package:presenta_app/presentation/pages/splash_page.dart';
import 'package:presenta_app/services/attendance_service.dart';
import 'package:presenta_app/services/auth_service.dart';
import 'package:presenta_app/services/profile_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(LocalizationConfig.dateLocale);
  Intl.defaultLocale = LocalizationConfig.dateLocale;
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final localStorageService = LocalStorageService();
    final authService = AuthService(
      apiService: apiService,
      localStorageService: localStorageService,
    );
    final profileService = ProfileService(apiService: apiService);
    final attendanceService = AttendanceService(apiService: apiService);
    final locationService = LocationService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            profileService: profileService,
            localStorageService: localStorageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider(
            attendanceService: attendanceService,
            locationService: locationService,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'PRESENTA',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            locale: LocalizationConfig.defaultLocale,
            supportedLocales: LocalizationConfig.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashPage(),
            routes: {
              '/splash': (context) => const SplashPage(),
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
        // ðŸ”¥ LOADING STATE (FIX BUG)
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
