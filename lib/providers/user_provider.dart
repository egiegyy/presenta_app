import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/user_model.dart';
import 'package:presenta_app/models/dropdown_models.dart';
import 'package:presenta_app/services/profile_service.dart';

class UserProvider extends ChangeNotifier {
  UserProvider({
    ProfileService? profileService,
    LocalStorageService? localStorageService,
  }) : _profileService = profileService ?? ProfileService(),
       _storage = localStorageService ?? LocalStorageService();

  final ProfileService _profileService;
  final LocalStorageService _storage;

  UserModel? _user;
  String? _localImagePath;
  List<BatchModel> _batches = [];
  List<TrainingModel> _trainings = [];
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  String? get localImagePath => _localImagePath;
  List<BatchModel> get batches => _batches;
  List<TrainingModel> get trainings => _trainings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> getProfile() async {
    try {
      _setLoading(true);
      _error = null;

      _user = await _profileService.getProfile();

      // Load local image path if no server photo
      if (_user?.photo == null) {
        _localImagePath = await _storage.getProfileImagePath();
      } else {
        _localImagePath = null;
      }
    } on Exception catch (e) {
      debugPrint('ERROR PROFILE: $e');
      _error = getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _error = null;

      final updatedUser = await _profileService.updateProfile(
        name: data['name']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
      );
      _user = updatedUser;

      // Only upload photo if provided
      final photo = data['photo']?.toString();
      if (photo != null && photo.isNotEmpty) {
        final remotePhoto = await _profileService.updateProfilePhoto(photo);
        if (remotePhoto != null && _user != null) {
          _user = UserModel(
            id: _user!.id,
            name: _user!.name,
            email: _user!.email,
            phone: _user!.phone,
            photo: remotePhoto,
            gender: _user!.gender,
            batch: _user!.batch,
            training: _user!.training,
            createdAt: _user!.createdAt,
          );
          _localImagePath = null;
        }
      }

      return true;
    } on Exception catch (e) {
      debugPrint('ERROR UPDATE PROFILE: $e');
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveLocalImagePath(String path) async {
    await _storage.saveProfileImagePath(path);
    _localImagePath = path;
    notifyListeners();
  }

  Future<void> getBatches() async {
    try {
      _error = null;
      _batches = await _profileService.getBatches();
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      _batches = [];
    }
    notifyListeners();
  }

  Future<void> getTrainings() async {
    try {
      _error = null;
      _trainings = await _profileService.getTrainings();
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      _trainings = [];
    }
    notifyListeners();
  }

  Future<TrainingModel?> getTrainingDetail(int trainingId) async {
    try {
      _error = null;
      return await _profileService.getTrainingDetail(trainingId);
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      return null;
    }
  }

  Future<bool> sendDeviceToken(String token) async {
    try {
      _error = null;
      await _profileService.sendDeviceToken(token);
      return true;
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
