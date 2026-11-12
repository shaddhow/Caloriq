import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';
import '../utils/food_data.dart';

class MealLogProvider extends ChangeNotifier {
  static const String _todayMealsKey = 'today_meals_data';
  static const String _lastLogDateKey = 'last_log_date';
  static const String _waterKey = 'today_water_ml';
  static const String _weightKey = 'today_weight_log';

  final Map<String, List<FoodItem>> _foodDatabase =
      FoodData.defaultFoodDatabase;

  List<FoodItem> _loggedToday = [];
  final int _streakDays = 6;
  final int _caloriesBurned = 310;
  int _waterMl = 1250;
  final int _waterTargetMl = 2500;
  double? _todayWeight;
  bool _isLoading = true;

  Map<String, List<FoodItem>> get foodDatabase => _foodDatabase;
  List<FoodItem> get loggedToday => _loggedToday;
  int get streakDays => _streakDays;
  int get caloriesBurned => _caloriesBurned;
  int get waterMl => _waterMl;
  int get waterTargetMl => _waterTargetMl;
  double? get todayWeight => _todayWeight;
  bool get isLoading => _isLoading;

  // Total Kcal
  int get totalKcal =>
      _loggedToday.fold(0, (sum, item) => sum + item.kcal);

  // Macro Totals
  double get totalCarbs =>
      _loggedToday.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalProtein =>
      _loggedToday.fold(0.0, (sum, item) => sum + item.protein);
  double get totalFat =>
      _loggedToday.fold(0.0, (sum, item) => sum + item.fat);

  // Legacy helper
  int get totalEatenKcal => totalKcal;

  MealLogProvider() {
    _loadFromPrefs();
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  List<FoodItem> _getDefaultInitialMeals() {
    return [
      FoodItem(
        name: '2 Ruti',
        kcal: 200,
        carbs: 40,
        protein: 6,
        fat: 2,
        mealType: 'Breakfast',
      ),
      FoodItem(
        name: '1 Dim Bhaji',
        kcal: 120,
        carbs: 1,
        protein: 7,
        fat: 9,
        mealType: 'Breakfast',
      ),
      FoodItem(
        name: '1 Bowl Dal',
        kcal: 150,
        carbs: 20,
        protein: 9,
        fat: 4,
        mealType: 'Breakfast',
      ),
      FoodItem(
        name: '1 Plate Bhat',
        kcal: 240,
        carbs: 52,
        protein: 4,
        fat: 1,
        mealType: 'Lunch',
      ),
      FoodItem(
        name: 'Chicken Curry',
        kcal: 210,
        carbs: 4,
        protein: 22,
        fat: 12,
        mealType: 'Lunch',
      ),
      FoodItem(
        name: '1 Bowl Dal',
        kcal: 150,
        carbs: 20,
        protein: 9,
        fat: 4,
        mealType: 'Lunch',
      ),
      FoodItem(
        name: 'Veg Bhaji',
        kcal: 100,
        carbs: 10,
        protein: 3,
        fat: 5,
        mealType: 'Lunch',
      ),
      FoodItem(
        name: '1 Cup Cha',
        kcal: 70,
        carbs: 10,
        protein: 2,
        fat: 2,
        mealType: 'Snacks',
      ),
    ];
  }

  Future<void> _loadFromPrefs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastDate = prefs.getString(_lastLogDateKey);
      final todayDate = _getTodayDateString();

      // Reset at midnight if saved date is not today
      if (lastDate != null && lastDate != todayDate) {
        _loggedToday = _getDefaultInitialMeals();
        _waterMl = 0;
        await prefs.remove(_todayMealsKey);
        await prefs.remove(_waterKey);
        await prefs.setString(_lastLogDateKey, todayDate);
      } else {
        final jsonString = prefs.getString(_todayMealsKey);
        if (jsonString != null) {
          final List<dynamic> list = jsonDecode(jsonString);
          _loggedToday = list
              .map((item) => FoodItem.fromMap(item as Map<String, dynamic>))
              .toList();
        } else {
          _loggedToday = _getDefaultInitialMeals();
        }

        _waterMl = prefs.getInt(_waterKey) ?? 1250;
        _todayWeight = prefs.getDouble(_weightKey);
      }
    } catch (e) {
      debugPrint('Error loading meal logs: $e');
      _loggedToday = _getDefaultInitialMeals();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todayDate = _getTodayDateString();
      await prefs.setString(_lastLogDateKey, todayDate);

      final jsonList = _loggedToday.map((item) => item.toMap()).toList();
      await prefs.setString(_todayMealsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving meal logs: $e');
    }
  }

  Future<void> _saveWaterToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_waterKey, _waterMl);
    } catch (e) {
      debugPrint('Error saving water log: $e');
    }
  }

  Future<void> _saveWeightToPrefs() async {
    try {
      if (_todayWeight != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_weightKey, _todayWeight!);
      }
    } catch (e) {
      debugPrint('Error saving weight log: $e');
    }
  }

  void addLoggedItem(FoodItem item) {
    _loggedToday.add(item);
    notifyListeners();
    _saveToPrefs();
  }

  void removeLoggedItem(FoodItem item) {
    _loggedToday.remove(item);
    notifyListeners();
    _saveToPrefs();
  }

  void clearTodayLogs() {
    _loggedToday.clear();
    notifyListeners();
    _saveToPrefs();
  }

  void addWater(int ml) {
    _waterMl = (_waterMl + ml).clamp(0, 5000);
    notifyListeners();
    _saveWaterToPrefs();
  }

  void removeWater(int ml) {
    _waterMl = (_waterMl - ml).clamp(0, 5000);
    notifyListeners();
    _saveWaterToPrefs();
  }

  void setTodayWeight(double weight) {
    _todayWeight = weight;
    notifyListeners();
    _saveWeightToPrefs();
  }

  List<FoodItem> getItemsForMeal(String mealType) {
    return _loggedToday
        .where((item) => item.mealType?.toLowerCase() == mealType.toLowerCase())
        .toList();
  }

  int getCaloriesForMeal(String mealType) {
    return getItemsForMeal(mealType).fold(0, (sum, item) => sum + item.kcal);
  }
}

typedef MealProvider = MealLogProvider;
