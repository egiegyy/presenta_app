import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/core/constants/app_constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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

      if (success) {
        SuccessSnackbar.show(context, AppStrings.loginSuccess);
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      } else {
        ErrorSnackbar.show(context, authProvider.error ?? 'Login failed');
        authProvider.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A6CFF), Color(0xFF92C7FF), Color(0xFFF5FAFF)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Sign in to continue using Presenta.',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Color(0xFFE7F2FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    GlassmorphicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            AppStrings.login,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0A6CFF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use your registered account to access attendance features.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7C93),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 30),

                          CustomTextField(
                            label: AppStrings.email,
                            hint: 'user@example.com',
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.emailRequired;
                              }
                              if (!value.contains('@')) {
                                return AppStrings.invalidEmail;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          CustomTextField(
                            label: AppStrings.password,
                            hint: 'Enter your password',
                            controller: _passwordController,
                            obscureText: true,
                            prefixIcon: Icons.lock_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.passwordRequired;
                              }
                              if (value.length < 6) {
                                return AppStrings.passwordTooShort;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  label: AppStrings.login,
                                  isLoading: authProvider.isLoading,
                                  onPressed: () => _handleLogin(context),
                                  startColor: const Color(0xFF0A6CFF),
                                  endColor: const Color(0xFF5DA8FF),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  AppStrings.noAccount,
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pushNamed('/register');
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Color(0xFF0A6CFF),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
