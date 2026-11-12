import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../utils/calculators.dart';

class UserProfileProvider extends ChangeNotifier {
  static const String _userProfileKey = 'user_profile_data';
  static const String _isOnboardedKey = 'is_onboarded';

  UserProfile _profile = const UserProfile();
  bool _isOnboarded = false;
  bool _isLoading = true;

  UserProfile get profile => _profile;
  bool get isOnboarded => _isOnboarded;
  bool get isLoading => _isLoading;

  // Metric calculation getters
  ProfileMetrics get metrics => ProfileMetrics.fromProfile(_profile);
  double get bmi => metrics.bmi;
  String get bmiCategory => metrics.bmiCategory;
  double get bmiPosition => metrics.bmiPosition;
  int get tdee => metrics.tdee;
  int get budget => metrics.budget;

  UserProfileProvider() {
    loadUserFromPrefs();
  }

  Future<void> loadUserFromPrefs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _isOnboarded = prefs.getBool(_isOnboardedKey) ?? false;
      final profileJson = prefs.getString(_userProfileKey);
      if (profileJson != null) {
        final Map<String, dynamic> map = jsonDecode(profileJson);
        _profile = UserProfile.fromMap(map);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserProfile(UserProfile newProfile) async {
    _profile = newProfile;
    _isOnboarded = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isOnboardedKey, true);
      await prefs.setString(_userProfileKey, jsonEncode(_profile.toMap()));
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  Future<void> resetOnboarding() async {
    _isOnboarded = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isOnboardedKey, false);
  }
}

typedef UserProvider = UserProfileProvider;
