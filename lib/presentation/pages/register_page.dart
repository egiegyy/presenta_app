import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/providers/auth_provider.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/models/dropdown_models.dart';

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

  void _onBatchChanged(BatchModel? batch) {
    final userProvider = context.read<UserProvider>();
    setState(() {
      _selectedBatchId = batch?.id;
      _selectedTrainingId = null;
<<<<<<< HEAD
      _availableTrainings = (batch?.trainings.isNotEmpty ?? false)
          ? batch!.trainings
          : userProvider.trainings;
=======
      _availableTrainings = batch?.trainings.isNotEmpty == true
          ? batch!.trainings
          : context.read<UserProvider>().trainings;
>>>>>>> 77a89f6 (All done but not UI)
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Only gender is required by the API; batch/training are optional
      if (_selectedGender == null) {
        ErrorSnackbar.show(context, 'Pilih jenis kelamin');
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
        _selectedBatchId,     // optional
        _selectedTrainingId,  // optional
        null,                 // profile_photo — optional at registration
      );

      if (!context.mounted) return;

      // All UI operations after async gap
      if (success) {
        SuccessSnackbar.show(context, 'Registrasi berhasil! Silahkan login.');
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        ErrorSnackbar.show(
          context,
          authProvider.error ?? 'Registration failed',
        );
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
                      vertical: 24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Sign up to start using Presenta with a fresh new UI.',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: Color(0xFFE3F0FF),
                            ),
                          ),
                          const SizedBox(height: 28),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
<<<<<<< HEAD
                          ),
                          const SizedBox(height: 18),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppStrings.gender,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedGender,
                                isExpanded: true,
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
                                  fillColor: const Color(0xFFF3F8FF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Pilih jenis kelamin';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppStrings.batch,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Consumer<UserProvider>(
                                builder: (context, userProvider, _) {
                                  return DropdownButtonFormField<int>(
                                    initialValue: _selectedBatchId,
                                    isExpanded: true,
                                    items: userProvider.batches.map((batch) {
                                      return DropdownMenuItem(
                                        value: batch.id,
                                        child: Text(
                                          batch.name.isEmpty
                                              ? 'Batch ${batch.id}'
                                              : batch.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      final batch = userProvider.batches
                                          .firstWhere(
                                            (item) => item.id == value,
                                            orElse: () =>
                                                BatchModel(id: 0, name: ''),
                                          );
                                      _onBatchChanged(
                                        batch.id != 0 ? batch : null,
                                      );
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFF3F8FF),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null) return 'Pilih batch';
                                      return null;
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppStrings.training,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<int>(
                                initialValue: _selectedTrainingId,
                                isExpanded: true,
                                items: _availableTrainings.map((training) {
                                  return DropdownMenuItem(
                                    value: training.id,
                                    child: Text(
                                      training.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTrainingId = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF3F8FF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null) return 'Pilih training';
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          CustomTextField(
                            label: AppStrings.password,
                            hint: 'Min. 6 characters',
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
                          const SizedBox(height: 18),

                          CustomTextField(
                            label: AppStrings.confirmPassword,
                            hint: 'Confirm password',
                            controller: _confirmPasswordController,
                            obscureText: true,
                            prefixIcon: Icons.lock_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm password required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 26),

                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              return SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  label: AppStrings.register,
                                  isLoading: authProvider.isLoading,
                                  onPressed: () => _handleRegister(context),
                                  startColor: const Color(0xFF0A6CFF),
                                  endColor: const Color(0xFF5DA8FF),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),

                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
=======
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
>>>>>>> 77a89f6 (All done but not UI)
                              children: [
                                const Text(
                                  'Personal Info',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                CustomTextField(
                                  label: AppStrings.name,
                                  hint: 'Full Name',
                                  controller: _nameController,
                                  prefixIcon: Icons.person_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppStrings.nameRequired;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),

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
                                const SizedBox(height: 24),

                                const Text(
                                  'Account Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.gender,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    DropdownButtonFormField<String>(
                                      value: _selectedGender,
                                      isExpanded: true,
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
                                        fillColor: const Color(0xFFF3F8FF),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null)
                                          return 'Pilih jenis kelamin';
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.batch,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Consumer<UserProvider>(
                                      builder: (context, userProvider, _) {
                                        return DropdownButtonFormField<int>(
                                          value: _selectedBatchId,
                                          isExpanded: true,
                                          items: userProvider.batches.map((
                                            batch,
                                          ) {
                                            return DropdownMenuItem(
                                              value: batch.id,
                                              child: Text(
                                                batch.batchNumber != null
                                                    ? 'Batch ${batch.batchNumber}'
                                                    : (batch.name.isEmpty
                                                          ? 'Batch ${batch.id}'
                                                          : batch.name),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            final batch = userProvider.batches
                                                .firstWhere(
                                                  (item) => item.id == value,
                                                  orElse: () => BatchModel(
                                                    id: 0,
                                                    name: '',
                                                  ),
                                                );
                                            _onBatchChanged(
                                              batch.id != 0 ? batch : null,
                                            );
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF3F8FF),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null)
                                              return 'Pilih batch';
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      AppStrings.training,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Consumer<UserProvider>(
                                      builder: (context, userProvider, _) {
                                        final trainings =
                                            _availableTrainings.isEmpty
                                            ? userProvider.trainings
                                            : _availableTrainings;

                                        return DropdownButtonFormField<int>(
                                          value: _selectedTrainingId,
                                          isExpanded: true,
                                          items: trainings.map((training) {
                                            return DropdownMenuItem(
                                              value: training.id,
                                              child: Text(
                                                training.name,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedTrainingId = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFFF3F8FF),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Pilih training';
                                            }
                                            return null;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                CustomTextField(
                                  label: AppStrings.password,
                                  hint: 'Min. 6 characters',
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
                                const SizedBox(height: 18),

                                CustomTextField(
                                  label: AppStrings.confirmPassword,
                                  hint: 'Confirm password',
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  prefixIcon: Icons.lock_outlined,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Confirm password required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 26),

                                Consumer<AuthProvider>(
                                  builder: (context, authProvider, _) {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: GradientButton(
                                        label: AppStrings.register,
                                        isLoading: authProvider.isLoading,
                                        onPressed: () =>
                                            _handleRegister(context),
                                        startColor: const Color(0xFF0A6CFF),
                                        endColor: const Color(0xFF5DA8FF),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 18),

                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        AppStrings.haveAccount,
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pushReplacementNamed('/login');
                                        },
                                        child: const Text(
                                          'Login',
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
                          const SizedBox(height: 32),
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
