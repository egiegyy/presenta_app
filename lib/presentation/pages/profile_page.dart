import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  File? _selectedImage;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  void _loadProfile() {
    final userProvider = context.read<UserProvider>();
    userProvider.getProfile().then((_) {
      if (!mounted || userProvider.user == null) {
        return;
      }

      _nameController.text = userProvider.user!.name;
      _emailController.text = userProvider.user!.email;
    });
    userProvider.getBatches();
    userProvider.getTrainings();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null && mounted) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _isEditing = true;
      });

      await context.read<UserProvider>().saveLocalImagePath(pickedFile.path);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5E3FF),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                tileColor: AppPalette.backgroundTint,
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppPalette.brandBlueDark,
                ),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                tileColor: AppPalette.backgroundTint,
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: AppPalette.brandBlueDark,
                ),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _imageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null;
    }
  }

  Future<void> _handleSaveProfile() async {
    final userProvider = context.read<UserProvider>();
    String? base64Photo;
    if (_selectedImage != null) {
      base64Photo = await _imageToBase64(_selectedImage!);
    }

    final success = await userProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      base64Photo: base64Photo,
    );
    if (success) {
      SuccessSnackbar.show(context, 'Profil berhasil diupdate');
      setState(() => _isEditing = false);
    } else {
      ErrorSnackbar.show(context, userProvider.error ?? 'Gagal update profil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading && userProvider.user == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppPalette.brandBlueDark),
            ),
          );
        }

        final user = userProvider.user;
        if (user == null) {
          return const Center(child: Text('No user data'));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassmorphicCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.profile,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppPalette.brandBlueDark,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Kelola informasi akun Anda dengan tampilan yang lebih rapi dan fokus.',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: AppPalette.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                    if (!_isEditing) {
                                      _selectedImage = null;
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppPalette.brandBlueDark,
                                  side: const BorderSide(
                                    color: Color(0xFFD0E1FF),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                                icon: Icon(
                                  _isEditing
                                      ? Icons.close_rounded
                                      : Icons.edit_rounded,
                                  size: 18,
                                ),
                                label: Text(_isEditing ? 'Batal' : 'Edit'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppPalette.brandBlueDark,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPalette.brandBlue.withValues(
                                    alpha: 0.18,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: const Color(0xFFF0F9FF),
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (userProvider.localImagePath != null
                                            ? FileImage(
                                                File(
                                                  userProvider.localImagePath!,
                                                ),
                                              )
                                            : (user.photo != null
                                                  ? NetworkImage(user.photo!)
                                                  : null))
                                        as ImageProvider?,
                              child:
                                  (_selectedImage == null &&
                                      userProvider.localImagePath == null &&
                                      user.photo == null)
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 58,
                                      color: AppPalette.brandBlueDark,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            right: -4,
                            bottom: -2,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _showImagePicker,
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppPalette.brandBlueDark,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppPalette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _infoField(
                      AppStrings.name,
                      user.name,
                      _nameController,
                      _isEditing,
                    ),
                    _infoField(
                      AppStrings.email,
                      user.email,
                      _emailController,
                      _isEditing,
                    ),
                    if (user.gender != null)
                      _infoField(
                        AppStrings.gender,
                        user.gender == 'L' ? 'Laki-laki' : 'Perempuan',
                        null,
                        false,
                        readOnly: true,
                      ),
                    if (user.batch != null)
                      _infoField(
                        AppStrings.batch,
                        'Batch ${user.batch!}',
                        null,
                        false,
                        readOnly: true,
                      ),
                    if (user.training != null)
                      _infoField(
                        AppStrings.training,
                        user.training!,
                        null,
                        false,
                        readOnly: true,
                      ),
                    if (_isEditing) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSaveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPalette.brandBlueDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text(
                            AppStrings.save,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoField(
    String label,
    String value,
    TextEditingController? controller,
    bool editable, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppPalette.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          editable
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFDCE7FF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFDCE7FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: AppPalette.brandBlueDark,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: readOnly
                        ? const Color(0xFFF8FBFF)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFDCE7FF)),
                  ),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.textPrimary,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
