import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/models/user_model.dart';
import 'package:presenta_app/models/dropdown_models.dart';

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storage = LocalStorageService();

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
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.getProfile();
      debugPrint("PROFILE RESPONSE: $response");

      final data = response['data'] ?? response;
      _user = UserModel.fromJson(data);

      // Load local image path if no server photo
      if (_user?.photo == null) {
        _localImagePath = await _storage.getProfileImagePath();
      }
    } catch (e) {
      debugPrint("ERROR PROFILE: $e");
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.editProfile(data);
      debugPrint("UPDATE PROFILE RESPONSE: $response");

      final resData = response['data'] ?? response;
      _user = UserModel.fromJson(resData);

      return true;
    } catch (e) {
      debugPrint("ERROR UPDATE PROFILE: $e");
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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
      final response = await _apiService.getBatches();
      _batches = response
          .whereType<Map<String, dynamic>>()
          .map((item) => BatchModel.fromJson(item))
          .where((e) => e.name.isNotEmpty)
          .toList();
    } catch (e) {
      _error = e.toString();
      _batches = [];
    }
    notifyListeners();
  }

  Future<void> getTrainings() async {
    try {
      _error = null;
      final response = await _apiService.getTrainings();
      _trainings = response
          .whereType<Map<String, dynamic>>()
          .map((item) => TrainingModel.fromJson(item))
          .where((e) => e.name.isNotEmpty)
          .toList();
    } catch (e) {
      _error = e.toString();
      _trainings = [];
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
