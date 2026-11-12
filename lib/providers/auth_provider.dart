import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static const String _isGuestKey = 'is_guest_mode';

  final AuthService _authService = AuthService();
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isGuest = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isGuest => _isGuest;

  bool get isAuthenticated => _user != null || _isGuest;

  String get userDisplayName {
    if (_user?.displayName != null && _user!.displayName!.isNotEmpty) {
      return _user!.displayName!;
    }
    if (_user?.email != null && _user!.email!.isNotEmpty) {
      return _user!.email!.split('@').first;
    }
    if (_isGuest) {
      return 'Guest User';
    }
    return 'User';
  }

  String get userEmail {
    return _user?.email ?? (_isGuest ? 'guest@caloriq.app' : '');
  }

  AuthProvider() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      _user = _authService.currentUser;
    } catch (e) {
      debugPrint('Error getting currentUser: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _isGuest = prefs.getBool(_isGuestKey) ?? false;
    } catch (e) {
      debugPrint('Error loading guest key: $e');
    }
    notifyListeners();

    try {
      _authSubscription =
          _authService.authStateChanges.listen((User? newUser) {
        _user = newUser;
        if (newUser != null) {
          _setGuestMode(false);
        }
        notifyListeners();
      }, onError: (e) {
        debugPrint('Auth state listener error: $e');
      });
    } catch (e) {
      debugPrint('Error setting up auth stream: $e');
    }
  }

  Future<void> _setGuestMode(bool value) async {
    _isGuest = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestKey, value);
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sign In with Email & Password
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _setGuestMode(false);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign Up with Email, Password & Name
  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: name,
      );
      await _setGuestMode(false);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Continue as Guest
  Future<void> continueAsGuest() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signInAnonymously();
    } catch (e) {
      debugPrint('Anonymous sign-in exception: $e');
    } finally {
      await _setGuestMode(true);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset Password
  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    await _setGuestMode(false);

    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
