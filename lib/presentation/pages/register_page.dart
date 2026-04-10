import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/models/dropdown_models.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;
  int? _selectedBatchId;
  int? _selectedTrainingId;
  List<TrainingModel> _availableTrainings = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDropdownData();
    });
  }

  void _loadDropdownData() {
    final userProvider = context.read<UserProvider>();
    userProvider.getBatches();
    userProvider.getTrainings();
  }

  void _onBatchChanged(BatchModel? batch, UserProvider userProvider) {
    setState(() {
      _selectedBatchId = batch?.id;
      _selectedTrainingId = null;
      _availableTrainings = batch != null && batch.trainings.isNotEmpty
          ? batch.trainings
          : userProvider.trainings;
    });
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_selectedGender == null) {
        ErrorSnackbar.show(context, 'Pilih jenis kelamin');
        return;
      }
      if (_selectedBatchId == null) {
        ErrorSnackbar.show(context, 'Pilih batch');
        return;
      }
      if (_selectedTrainingId == null) {
        ErrorSnackbar.show(context, 'Pilih training');
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        ErrorSnackbar.show(context, AppStrings.passwordNotMatch);
        return;
      }

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _selectedGender!,
        _selectedBatchId,
        _selectedTrainingId,
        null,
      );

      if (!context.mounted) return;

      if (success) {
        SuccessSnackbar.show(context, 'Registrasi berhasil! Silakan login.');
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        ErrorSnackbar.show(context, authProvider.error ?? 'Registration failed');
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

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppPalette.textPrimaryFor(context),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushReplacementNamed('/login');
      },
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
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
                  const SizedBox(height: 20),
                  Text(
                    'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Join Presenta and manage your attendance smarter.',
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 28),
                  _glassCard(
                    child: Consumer<UserProvider>(
                      builder: (context, userProvider, _) {
                        final trainings = _availableTrainings.isNotEmpty
                            ? _availableTrainings
                            : userProvider.trainings;

                        BatchModel? selectedBatch;
                        for (final batch in userProvider.batches) {
                          if (batch.id == _selectedBatchId) {
                            selectedBatch = batch;
                            break;
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _sectionTitle('Personal Information'),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: AppStrings.name,
                              hint: 'Full Name',
                              controller: _nameController,
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.nameRequired;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: AppStrings.email,
                              hint: 'yourname@gmail.com',
                              controller: _emailController,
                              prefixIcon: Icons.email_outlined,
                              inputType: TextInputType.emailAddress,
                              validator: (value) {
                                final email = value?.trim() ?? '';
                                if (email.isEmpty) return AppStrings.emailRequired;
                                if (!RegExp(
                                  r'^[A-Za-z0-9._%+-]+@gmail\.com$',
                                ).hasMatch(email)) {
                                  return 'Email harus menggunakan @gmail.com';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedGender,
                              isExpanded: true,
                              hint: Text(
                                AppStrings.gender,
                                style: GoogleFonts.inter(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'L',
                                  child: Text('Laki-laki'),
                                ),
                                DropdownMenuItem(
                                  value: 'P',
                                  child: Text('Perempuan'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedGender = value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppPalette.isDark(context)
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFF3F8FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _sectionTitle('Batch & Training'),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<int>(
                              initialValue: _selectedBatchId,
                              isExpanded: true,
                              hint: Text(
                                'Pilih Batch',
                                style: GoogleFonts.inter(),
                              ),
                              items: userProvider.batches.map((batch) {
                                final batchLabel =
                                    batch.batchNumber?.isNotEmpty == true
                                    ? 'Batch ${batch.batchNumber}'
                                    : (batch.name.isNotEmpty
                                          ? batch.name
                                          : 'Batch ${batch.id}');
                                return DropdownMenuItem<int>(
                                  value: batch.id,
                                  child: Text(
                                    batchLabel,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                BatchModel? batch;
                                for (final item in userProvider.batches) {
                                  if (item.id == value) {
                                    batch = item;
                                    break;
                                  }
                                }
                                _onBatchChanged(batch, userProvider);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppPalette.isDark(context)
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFF3F8FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            if (selectedBatch?.description != null &&
                                selectedBatch!.description!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                selectedBatch.description!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppPalette.textSecondaryFor(context),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            DropdownButtonFormField<int>(
                              initialValue: _selectedTrainingId,
                              isExpanded: true,
                              hint: Text(
                                'Pilih Training',
                                style: GoogleFonts.inter(),
                              ),
                              items: trainings.map((training) {
                                return DropdownMenuItem<int>(
                                  value: training.id,
                                  child: Text(
                                    training.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedTrainingId = value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppPalette.isDark(context)
                                    ? const Color(0xFF111827)
                                    : const Color(0xFFF3F8FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _sectionTitle('Security'),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: AppStrings.password,
                              hint: 'Password',
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
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: AppStrings.confirmPassword,
                              hint: 'Confirm Password',
                              controller: _confirmPasswordController,
                              obscureText: true,
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Consumer<AuthProvider>(
                              builder: (context, auth, _) {
                                return GradientButton(
                                  label: AppStrings.register,
                                  isLoading: auth.isLoading,
                                  onPressed: () => _handleRegister(context),
                                  startColor: const Color(0xFF0A6CFF),
                                  endColor: const Color(0xFF5DA8FF),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppStrings.haveAccount,
                                    style: GoogleFonts.inter(
                                      color: AppPalette.textSecondaryFor(context),
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(48, 28),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed('/login');
                                    },
                                    child: Text(
                                      'Login',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0A6CFF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
