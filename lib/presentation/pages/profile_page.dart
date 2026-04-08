import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presenta_app/providers/user_provider.dart';
import 'package:presenta_app/presentation/widgets/custom_widgets.dart';
import 'package:presenta_app/core/constants/app_constants.dart';
import 'dart:io';
import 'dart:convert';

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
      // Populate controllers once after data is fetched (not on every build)
      if (mounted && !_isEditing) {
        final user = context.read<UserProvider>().user;
        if (user != null) {
          _nameController.text = user.name;
          _emailController.text = user.email;
        }
      }
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
      });
      await context.read<UserProvider>().saveLocalImagePath(pickedFile.path);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
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
    final updateData = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    };

    // Upload selected image as base64
    if (_selectedImage != null) {
      final base64Photo = await _imageToBase64(_selectedImage!);
      if (base64Photo != null) {
        updateData['photo'] = base64Photo;
      }
    }

    final success = await userProvider.updateProfile(updateData);
    if (!mounted) return;

    if (success) {
      SuccessSnackbar.show(context, 'Profil berhasil diupdate');
      setState(() => _isEditing = false);
    } else {
      ErrorSnackbar.show(context, userProvider.error ?? 'Gagal update profil');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          AppStrings.profile,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _selectedImage = null;
                  // Re-sync controllers to server data after cancelling edit
                  final user = context.read<UserProvider>().user;
                  if (user != null) {
                    _nameController.text = user.name;
                    _emailController.text = user.email;
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A6CFF), Color(0xFF92C7FF), Color(0xFFF5FAFF)],
          ),
        ),
        child: SafeArea(
          child: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              if (userProvider.isLoading && userProvider.user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = userProvider.user;
              if (user == null) {
                return const Center(child: Text('No user data'));
              }

              // Only sync controllers when switching from edit→view mode
              // (do NOT set in build — it overwrites user input mid-edit)
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Photo
                    GestureDetector(
                      onTap: _isEditing ? _showImagePicker : null,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0A4ED2),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0A4ED2,
                                  ).withValues(alpha: 0.18),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 80,
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
                                      Icons.person,
                                      size: 64,
                                      color: Color(0xFF0A4ED2),
                                    )
                                  : null,
                            ),
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0A6CFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Card
                    GlassmorphicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              user.gender!,
                              null,
                              false,
                              readOnly: true,
                            ),
                          if (user.batch != null)
                            _infoField(
                              AppStrings.batch,
                              user.batch!,
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
                          const SizedBox(height: 24),
                          if (_isEditing)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleSaveProfile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A6CFF),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  AppStrings.save,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoField(
    String label,
    String value,
    TextEditingController? controller,
    bool editable, {
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        editable
            ? TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A4ED2),
                ),
              ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
