import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/presentation/pages/login_page.dart';
import 'package:presenta_app/presentation/pages/dashboard_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoggedIn) {
          return const DashboardPage();
        }
        return const LoginPage();
      },
    );
  }
}
