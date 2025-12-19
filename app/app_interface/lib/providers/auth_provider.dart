import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart' as app_user;

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  app_user.User? _currentUser;
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _errorMessage;

  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  bool get isSeller => _currentUser?.role == 'seller';
  bool get isBuyer => _currentUser?.role == 'buyer';

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userDetails = await _authService.getCurrentUserDetails();
      if (userDetails != null) {
        _currentUser = app_user.User.fromJson(userDetails);
        _isAuthenticated = true;
      }
    } catch (e) {
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String phone,
    required String password,
    required String universityId,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.register(
        name: name,
        phone: phone,
        password: password,
        universityId: universityId,
        role: role,
      );

      await _checkAuthStatus();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(phone: phone, password: password);
      await _checkAuthStatus();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Invalid phone number or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateUniversity(String universityId) async {
    await _authService.updateUniversity(universityId);
    await _checkAuthStatus();
  }
}