import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/core/constants/app_constants.dart';

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

      // All UI operations after async gap
      if (success) {
        SuccessSnackbar.show(context, AppStrings.loginSuccess);
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        ErrorSnackbar.show(context, authProvider.error ?? 'Login failed');
        authProvider.clearError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.backgroundTint,
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 12),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to continue using Presenta.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Color(0xFFE7F2FF),
                            ),
                          ),
                          const SizedBox(height: 32),
                          GlassmorphicCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  AppStrings.login,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppPalette.brandBlueDark,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Use your registered account to access attendance features.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppPalette.textSecondary,
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
                                        startColor: AppPalette.brandBlueDark,
                                        endColor: AppPalette.brandBlue,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      AppStrings.noAccount,
                                      style: TextStyle(
                                        color: AppPalette.textSecondary,
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
                                          color: AppPalette.brandBlueDark,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
