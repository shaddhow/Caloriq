import 'package:uuid/uuid.dart';

class FoodItem {
  final String id;
  final String name;
  final int kcal;
  final double protein; // in grams
  final double carbs; // in grams
  final double fat; // in grams
  final String? mealType; // 'Breakfast', 'Lunch', 'Snacks', 'Dinner'

  FoodItem({
    String? id,
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.mealType,
  }) : id = id ?? const Uuid().v4();

  FoodItem copyWith({
    String? id,
    String? name,
    int? kcal,
    double? protein,
    double? carbs,
    double? fat,
    String? mealType,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      kcal: kcal ?? this.kcal,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      mealType: mealType ?? this.mealType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'kcal': kcal,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'mealType': mealType,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String? ?? const Uuid().v4(),
      name: map['name'] as String? ?? '',
      kcal: (map['kcal'] as num?)?.toInt() ?? 0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0.0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0.0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0.0,
      mealType: map['mealType'] as String?,
    );
  }
}
