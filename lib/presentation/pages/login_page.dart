import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!context.mounted) return;

      if (success) {
        SuccessSnackbar.show(context, AppStrings.loginSuccess);
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
      } else {
        ErrorSnackbar.show(context, authProvider.error ?? 'Login failed');
        authProvider.clearError();
      }
    }
  }

  Widget _glassCard({required Widget child}) {
    final isDark = AppPalette.isDark(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF162033) : Colors.white).withValues(
              alpha: 0.88,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF263245)
                  : Colors.white.withValues(alpha: 0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppPalette.isDark(context)
                ? const [
                    Color(0xFF08101E),
                    Color(0xFF10203B),
                    Color(0xFF0F172A),
                  ]
                : const [
                    Color(0xFF0A6CFF),
                    Color(0xFF5DA8FF),
                    Color(0xFF9ED0FF),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'lib/assets/images/Logo Presenta.png',
                          width: 38,
                          height: 38,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Presenta',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue using Presenta.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppStrings.login,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppPalette.textPrimaryFor(context),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: AppStrings.email,
                          hint: 'yourname@gmail.com',
                          controller: _emailController,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return AppStrings.emailRequired;
                            }
                            if (!RegExp(
                              r'^[A-Za-z0-9._%+-]+@gmail\.com$',
                            ).hasMatch(email)) {
                              return 'Email harus menggunakan @gmail.com';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: AppStrings.password,
                          hint: 'Enter your password',
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.passwordRequired;
                            }
                            if (value.length < 6) {
                              return 'Password tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return GradientButton(
                              label: AppStrings.login,
                              isLoading: authProvider.isLoading,
                              onPressed: () => _handleLogin(context),
                              startColor: const Color(0xFF0A6CFF),
                              endColor: const Color(0xFF5DA8FF),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppStrings.noAccount,
                                style: GoogleFonts.inter(
                                  color: AppPalette.textSecondaryFor(context),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(56, 28),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('/register');
                                },
                                child: Text(
                                  ' Register',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0A6CFF),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
