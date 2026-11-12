import 'package:uuid/uuid.dart';
import 'food_item.dart';

class MealLog {
  final String id;
  final String mealType; // 'Breakfast', 'Lunch', 'Snacks', 'Dinner'
  final List<FoodItem> items;
  final DateTime date;

  MealLog({
    String? id,
    required this.mealType,
    List<FoodItem>? items,
    DateTime? date,
  })  : id = id ?? const Uuid().v4(),
        items = items ?? [],
        date = date ?? DateTime.now();

  int get totalKcal => items.fold(0, (sum, item) => sum + item.kcal);
  double get totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0.0, (sum, item) => sum + item.fat);

  MealLog copyWith({
    String? id,
    String? mealType,
    List<FoodItem>? items,
    DateTime? date,
  }) {
    return MealLog(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      items: items ?? List.from(this.items),
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mealType': mealType,
      'items': items.map((x) => x.toMap()).toList(),
      'date': date.toIso8601String(),
    };
  }

  factory MealLog.fromMap(Map<String, dynamic> map) {
    return MealLog(
      id: map['id'] as String? ?? const Uuid().v4(),
      mealType: map['mealType'] as String? ?? 'Breakfast',
      items: (map['items'] as List<dynamic>?)
              ?.map((x) => FoodItem.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      date: map['date'] != null
          ? DateTime.parse(map['date'] as String)
          : DateTime.now(),
    );
  }
}
