import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:presenta_app/core/services/api_service.dart';
import 'package:presenta_app/core/services/local_storage_service.dart';
>>>>>>> 77a89f6 (All done but not UI)
import 'package:presenta_app/core/utils/exceptions.dart';
import 'package:presenta_app/models/user_model.dart';
import 'package:presenta_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    try {
<<<<<<< HEAD
      _setLoading(true);
      _error = null;

      _currentUser = await _authService.login(email: email, password: password);
      _isLoggedIn = true;
      notifyListeners(); // explicitly rebuild Consumers after state change
      return true;
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      _currentUser = null;
      _isLoggedIn = false;
      return false;
    } finally {
      _setLoading(false);
=======
      final session = await _apiService.login(email, password);
      _isLoggedIn = true;
      _currentUser = session.user;
      return true;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
>>>>>>> 77a89f6 (All done but not UI)
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String gender,
    int? batchId,
    int? trainingId,
    String? profilePhotoBase64,
  ) async {
    try {
<<<<<<< HEAD
      _setLoading(true);
      _error = null;

      await _authService.register(
        name: name,
        email: email,
        password: password,
        gender: gender,
        profilePhotoBase64: profilePhotoBase64,
        batchId: batchId,
        trainingId: trainingId,
      );
      return true;
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
=======
      await _apiService.register({
        'name': name,
        'email': email,
        'password': password,
        'jenis_kelamin': gender,
        'batch_id': int.tryParse(batch),
        'training_id': int.tryParse(training),
      });

      return true;
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
>>>>>>> 77a89f6 (All done but not UI)
    }
  }

  Future<void> checkLoginStatus() async {
<<<<<<< HEAD
    try {
      final hasSession = await _authService.hasValidSession();
      if (!hasSession) {
        _isLoggedIn = false;
        _currentUser = null;
        notifyListeners();
        return;
      }

      _currentUser = await _authService.getAuthenticatedUser();
      _isLoggedIn = true;
    } on Exception {
      _isLoggedIn = false;
      _currentUser = null;
      _error = null;
=======
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) {
      _isLoggedIn = false;
      _currentUser = null;
      notifyListeners();
      return;
>>>>>>> 77a89f6 (All done but not UI)
    }

    try {
      final profileResponse = await _apiService.getProfile();
      _currentUser = UserModel.fromJson(
        profileResponse['data'] ?? profileResponse,
      );
      _isLoggedIn = true;
    } catch (_) {
      _isLoggedIn = false;
      _currentUser = null;
      await _storage.clearToken();
    }

    notifyListeners();
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await _authService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      _error = null;
<<<<<<< HEAD
      notifyListeners(); // rebuild so AuthWrapper routes to login
    } on Exception catch (e) {
      _error = getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> requestForgotPasswordOtp(String email) async {
    try {
      _setLoading(true);
      _error = null;
      await _authService.requestForgotPasswordOtp(email);
      return true;
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _error = null;
      await _authService.resetPasswordWithOtp(
        email: email,
        otp: otp,
        password: password,
      );
      return true;
    } on Exception catch (e) {
      _error = getErrorMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
=======
    } catch (e) {
      _error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
>>>>>>> 77a89f6 (All done but not UI)
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
