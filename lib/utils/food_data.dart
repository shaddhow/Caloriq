import '../models/food_item.dart';

class FoodData {
  static final Map<String, List<FoodItem>> defaultFoodDatabase = {
    'Breakfast': [
      FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1),
      FoodItem(name: '2 Ruti', kcal: 200, carbs: 40, protein: 6, fat: 2),
      FoodItem(name: '1 Dim Bhaji', kcal: 120, carbs: 1, protein: 7, fat: 9),
      FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4),
      FoodItem(name: '1 Paratha', kcal: 260, carbs: 32, protein: 5, fat: 12),
      FoodItem(name: '1 Cup Cha', kcal: 70, carbs: 10, protein: 2, fat: 2),
    ],
    'Lunch': [
      FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1),
      FoodItem(name: 'Chicken Curry', kcal: 210, carbs: 4, protein: 22, fat: 12),
      FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4),
      FoodItem(name: 'Veg Bhaji', kcal: 90, carbs: 10, protein: 3, fat: 4),
      FoodItem(name: 'Hilsa Fish Curry', kcal: 280, carbs: 3, protein: 24, fat: 18),
      FoodItem(name: 'Beef Bhuna', kcal: 320, carbs: 2, protein: 26, fat: 22),
    ],
    'Snacks': [
      FoodItem(name: '1 Banana', kcal: 105, carbs: 27, protein: 1, fat: 0),
      FoodItem(name: 'Chanachur', kcal: 150, carbs: 14, protein: 4, fat: 9),
      FoodItem(name: '1 Cup Cha', kcal: 70, carbs: 10, protein: 2, fat: 2),
      FoodItem(name: '1 Singara', kcal: 180, carbs: 22, protein: 3, fat: 10),
      FoodItem(name: '1 Samosa', kcal: 160, carbs: 19, protein: 3, fat: 9),
    ],
    'Dinner': [
      FoodItem(name: '2 Ruti', kcal: 200, carbs: 40, protein: 6, fat: 2),
      FoodItem(name: 'Fish Curry', kcal: 180, carbs: 3, protein: 20, fat: 10),
      FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4),
      FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1),
      FoodItem(name: 'Chicken Roast', kcal: 290, carbs: 6, protein: 28, fat: 16),
    ],
  };
}
