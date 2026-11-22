import 'food_item.dart';

class ScannedMealResult {
  final String mealName;
  final int totalKcal;
  final double totalCarbs;
  final double totalProtein;
  final double totalFat;
  final List<FoodItem> items;
  final String omitAdvice;
  final int omitSavingsKcal;
  final String volumeSwapAdvice;
  final String healthInsight;
  final double confidence;

  const ScannedMealResult({
    required this.mealName,
    required this.totalKcal,
    required this.totalCarbs,
    required this.totalProtein,
    required this.totalFat,
    required this.items,
    required this.omitAdvice,
    required this.omitSavingsKcal,
    required this.volumeSwapAdvice,
    required this.healthInsight,
    this.confidence = 0.92,
  });

  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'totalKcal': totalKcal,
      'totalCarbs': totalCarbs,
      'totalProtein': totalProtein,
      'totalFat': totalFat,
      'items': items.map((i) => i.toMap()).toList(),
      'omitAdvice': omitAdvice,
      'omitSavingsKcal': omitSavingsKcal,
      'volumeSwapAdvice': volumeSwapAdvice,
      'healthInsight': healthInsight,
      'confidence': confidence,
    };
  }

  factory ScannedMealResult.fromMap(Map<String, dynamic> map) {
    return ScannedMealResult(
      mealName: map['mealName'] ?? 'Detected Meal',
      totalKcal: (map['totalKcal'] as num?)?.toInt() ?? 0,
      totalCarbs: (map['totalCarbs'] as num?)?.toDouble() ?? 0.0,
      totalProtein: (map['totalProtein'] as num?)?.toDouble() ?? 0.0,
      totalFat: (map['totalFat'] as num?)?.toDouble() ?? 0.0,
      items: (map['items'] as List<dynamic>?)
              ?.map((i) => FoodItem.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
      omitAdvice: map['omitAdvice'] ?? '',
      omitSavingsKcal: (map['omitSavingsKcal'] as num?)?.toInt() ?? 0,
      volumeSwapAdvice: map['volumeSwapAdvice'] ?? '',
      healthInsight: map['healthInsight'] ?? '',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.90,
    );
  }
}
