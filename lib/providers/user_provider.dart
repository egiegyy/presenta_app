import 'package:flutter/foundation.dart';
<<<<<<< HEAD
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/user_model.dart';
import 'package:presenta_app/models/dropdown_models.dart';
import 'package:presenta_app/services/profile_service.dart';
=======
import 'package:flutter/material.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/dropdown_models.dart';
import 'package:presenta_app/models/user_model.dart';
>>>>>>> 77a89f6 (All done but not UI)

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

<<<<<<< HEAD
      _user = await _profileService.getProfile();
=======
      final response = await _apiService.getProfile();
      debugPrint('PROFILE RESPONSE: $response');

      final data = response['data'] ?? response;
      _user = UserModel.fromJson(data);
>>>>>>> 77a89f6 (All done but not UI)

      if (_user?.photo == null) {
        _localImagePath = await _storage.getProfileImagePath();
      } else {
        _localImagePath = null;
      }
<<<<<<< HEAD
    } on Exception catch (e) {
      debugPrint('ERROR PROFILE: $e');
      _error = getErrorMessage(e);
=======
    } catch (e) {
      debugPrint('ERROR PROFILE: $e');
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
>>>>>>> 77a89f6 (All done but not UI)
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    String? base64Photo,
  }) async {
    try {
      _setLoading(true);
      _error = null;

<<<<<<< HEAD
      final updatedUser = await _profileService.updateProfile(
        name: data['name']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
      );
      _user = updatedUser;
=======
      final response = await _apiService.editProfile({
        'name': name,
        'email': email,
      });
      debugPrint('UPDATE PROFILE RESPONSE: $response');
>>>>>>> 77a89f6 (All done but not UI)

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

      if (base64Photo != null && base64Photo.isNotEmpty) {
        final photoResponse = await _apiService.updateProfilePhoto(base64Photo);
        final photoData = photoResponse['data'];
        if (photoData is Map<String, dynamic>) {
          _user = UserModel(
            id: _user?.id ?? 0,
            name: _user?.name ?? '',
            email: _user?.email ?? '',
            phone: _user?.phone,
            photo: photoData['profile_photo']?.toString() ?? _user?.photo,
            gender: _user?.gender,
            batchId: _user?.batchId,
            trainingId: _user?.trainingId,
            batch: _user?.batch,
            training: _user?.training,
            createdAt: _user?.createdAt ?? '',
          );
        }
      }

      return true;
<<<<<<< HEAD
    } on Exception catch (e) {
      debugPrint('ERROR UPDATE PROFILE: $e');
      _error = getErrorMessage(e);
=======
    } catch (e) {
      debugPrint('ERROR UPDATE PROFILE: $e');
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
>>>>>>> 77a89f6 (All done but not UI)
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
<<<<<<< HEAD
      _batches = await _profileService.getBatches();
    } on Exception catch (e) {
      _error = getErrorMessage(e);
=======
      final response = await _apiService.getBatches();
      _batches = response
          .whereType<Map<String, dynamic>>()
          .map(BatchModel.fromJson)
          .where((e) => e.name.isNotEmpty)
          .toList();
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
>>>>>>> 77a89f6 (All done but not UI)
      _batches = [];
    }
    notifyListeners();
  }

  Future<void> getTrainings() async {
    try {
      _error = null;
<<<<<<< HEAD
      _trainings = await _profileService.getTrainings();
    } on Exception catch (e) {
      _error = getErrorMessage(e);
=======
      final response = await _apiService.getTrainings();
      _trainings = response
          .whereType<Map<String, dynamic>>()
          .map(TrainingModel.fromJson)
          .where((e) => e.name.isNotEmpty)
          .toList();
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
>>>>>>> 77a89f6 (All done but not UI)
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
