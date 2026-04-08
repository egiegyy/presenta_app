import 'package:flutter/material.dart';
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
import 'package:presenta_app/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storage = LocalStorageService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.login(email, password);
      _isLoggedIn = true;

      // Fetch user profile after login
      final profileResponse = await _apiService.getProfile();
      _currentUser = UserModel.fromJson(
        profileResponse['data'] ?? profileResponse,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String gender,
    String batch,
    String training,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.register({
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
        'batch': batch,
        'training': training,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkLoginStatus() async {
    final token = await _storage.getToken();
    if (token != null) {
      try {
        final profileResponse = await _apiService.getProfile();
        _currentUser = UserModel.fromJson(
          profileResponse['data'] ?? profileResponse,
        );
        _isLoggedIn = true;
      } catch (e) {
        _isLoggedIn = false;
        _currentUser = null;
      }
    } else {
      _isLoggedIn = false;
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
