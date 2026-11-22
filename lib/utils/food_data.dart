import '../models/food_item.dart';

class FoodSuggestionData {
  final String title;
  final String subtitle;
  final int kcal;
  final int protein;

  const FoodSuggestionData({
    required this.title,
    required this.subtitle,
    required this.kcal,
    required this.protein,
  });
}

class FoodData {
  static const List<String> supportedCuisines = [
    'Bangladeshi',
    'Indian',
    'Western',
    'Middle Eastern',
  ];

  static const Map<String, String> cuisineFlags = {
    'Bangladeshi': '🇧🇩',
    'Indian': '🇮🇳',
    'Western': '🇺🇸',
    'Middle Eastern': '🇦🇪',
  };

  static const Map<String, String> cuisineLabels = {
    'Bangladeshi': 'Bangladeshi 🇧🇩',
    'Indian': 'Indian 🇮🇳',
    'Western': 'Western 🇺🇸',
    'Middle Eastern': 'Middle Eastern 🇦🇪',
  };

  // 1. Multi-Cuisine Food Catalog
  static final Map<String, Map<String, List<FoodItem>>> foodsByCuisine = {
    'Bangladeshi': {
      'Breakfast': [
        FoodItem(name: '2 Ruti', kcal: 200, carbs: 40, protein: 6, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Dim Bhaji', kcal: 120, carbs: 1, protein: 7, fat: 9, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Paratha', kcal: 260, carbs: 32, protein: 5, fat: 12, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Cup Cha (Dudh-Chini)', kcal: 70, carbs: 10, protein: 2, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Khichuri with Egg', kcal: 380, carbs: 55, protein: 14, fat: 12, cuisine: 'Bangladeshi'),
      ],
      'Lunch': [
        FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Chicken Curry', kcal: 210, carbs: 4, protein: 22, fat: 12, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Veg Bhaji', kcal: 90, carbs: 10, protein: 3, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Hilsa Fish Curry', kcal: 280, carbs: 3, protein: 24, fat: 18, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Beef Bhuna', kcal: 320, carbs: 2, protein: 26, fat: 22, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Rui Fish Bhaja', kcal: 190, carbs: 2, protein: 22, fat: 10, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Begun Bhorta', kcal: 85, carbs: 8, protein: 2, fat: 5, cuisine: 'Bangladeshi'),
      ],
      'Snacks': [
        FoodItem(name: '1 Banana', kcal: 105, carbs: 27, protein: 1, fat: 0, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Chanachur (50g)', kcal: 150, carbs: 14, protein: 4, fat: 9, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Cup Cha', kcal: 70, carbs: 10, protein: 2, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Singara', kcal: 180, carbs: 22, protein: 3, fat: 10, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Samosa', kcal: 160, carbs: 19, protein: 3, fat: 9, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Jhalmuri (1 thonga)', kcal: 130, carbs: 22, protein: 3, fat: 4, cuisine: 'Bangladeshi'),
      ],
      'Dinner': [
        FoodItem(name: '2 Ruti', kcal: 200, carbs: 40, protein: 6, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Fish Curry', kcal: 180, carbs: 3, protein: 20, fat: 10, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Chicken Roast', kcal: 290, carbs: 6, protein: 28, fat: 16, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Mixed Sabji', kcal: 95, carbs: 12, protein: 3, fat: 4, cuisine: 'Bangladeshi'),
      ],
    },
    'Indian': {
      'Breakfast': [
        FoodItem(name: '2 Idli with Sambar', kcal: 180, carbs: 36, protein: 6, fat: 1, cuisine: 'Indian'),
        FoodItem(name: '1 Plain Dosa', kcal: 170, carbs: 28, protein: 4, fat: 5, cuisine: 'Indian'),
        FoodItem(name: 'Poha with Peanuts', kcal: 250, carbs: 42, protein: 6, fat: 7, cuisine: 'Indian'),
        FoodItem(name: '1 Aloo Paratha with Curd', kcal: 310, carbs: 40, protein: 8, fat: 14, cuisine: 'Indian'),
        FoodItem(name: 'Upma (1 bowl)', kcal: 210, carbs: 34, protein: 5, fat: 6, cuisine: 'Indian'),
        FoodItem(name: 'Masala Chai', kcal: 80, carbs: 12, protein: 2, fat: 2, cuisine: 'Indian'),
      ],
      'Lunch': [
        FoodItem(name: '2 Chapati / Phulka', kcal: 180, carbs: 36, protein: 6, fat: 1, cuisine: 'Indian'),
        FoodItem(name: 'Dal Tadka (1 bowl)', kcal: 160, carbs: 22, protein: 9, fat: 4, cuisine: 'Indian'),
        FoodItem(name: 'Paneer Butter Masala', kcal: 340, carbs: 12, protein: 14, fat: 26, cuisine: 'Indian'),
        FoodItem(name: 'Chicken Tikka Masala', kcal: 290, carbs: 8, protein: 26, fat: 17, cuisine: 'Indian'),
        FoodItem(name: 'Jeera Rice (1 plate)', kcal: 230, carbs: 48, protein: 4, fat: 3, cuisine: 'Indian'),
        FoodItem(name: 'Chana Masala', kcal: 220, carbs: 32, protein: 10, fat: 6, cuisine: 'Indian'),
        FoodItem(name: 'Palak Paneer', kcal: 260, carbs: 9, protein: 12, fat: 20, cuisine: 'Indian'),
      ],
      'Snacks': [
        FoodItem(name: 'Roasted Makhana (30g)', kcal: 110, carbs: 22, protein: 3, fat: 1, cuisine: 'Indian'),
        FoodItem(name: 'Dhokla (2 pcs)', kcal: 150, carbs: 24, protein: 5, fat: 4, cuisine: 'Indian'),
        FoodItem(name: 'Bhel Puri (1 plate)', kcal: 190, carbs: 36, protein: 5, fat: 3, cuisine: 'Indian'),
        FoodItem(name: 'Masala Chai', kcal: 80, carbs: 12, protein: 2, fat: 2, cuisine: 'Indian'),
        FoodItem(name: '1 Veg Cutlet', kcal: 140, carbs: 18, protein: 3, fat: 7, cuisine: 'Indian'),
      ],
      'Dinner': [
        FoodItem(name: '2 Phulka', kcal: 180, carbs: 36, protein: 6, fat: 1, cuisine: 'Indian'),
        FoodItem(name: 'Dal Makhani (1 bowl)', kcal: 260, carbs: 26, protein: 11, fat: 13, cuisine: 'Indian'),
        FoodItem(name: 'Mixed Veg Curry', kcal: 140, carbs: 16, protein: 4, fat: 7, cuisine: 'Indian'),
        FoodItem(name: 'Tandoori Chicken (2 pcs)', kcal: 260, carbs: 3, protein: 34, fat: 12, cuisine: 'Indian'),
        FoodItem(name: 'Cucumber Raita', kcal: 80, carbs: 6, protein: 4, fat: 4, cuisine: 'Indian'),
      ],
    },
    'Western': {
      'Breakfast': [
        FoodItem(name: 'Oatmeal with Blueberries', kcal: 220, carbs: 42, protein: 6, fat: 3, cuisine: 'Western'),
        FoodItem(name: '2 Scrambled Eggs & Toast', kcal: 280, carbs: 22, protein: 16, fat: 14, cuisine: 'Western'),
        FoodItem(name: 'Greek Yogurt & Honey', kcal: 180, carbs: 20, protein: 17, fat: 3, cuisine: 'Western'),
        FoodItem(name: 'Avocado Toast with Egg', kcal: 320, carbs: 24, protein: 12, fat: 20, cuisine: 'Western'),
        FoodItem(name: 'Black Coffee / Latte', kcal: 45, carbs: 4, protein: 3, fat: 2, cuisine: 'Western'),
      ],
      'Lunch': [
        FoodItem(name: 'Grilled Chicken & Quinoa', kcal: 420, carbs: 38, protein: 42, fat: 11, cuisine: 'Western'),
        FoodItem(name: 'Tuna Salad Sandwich', kcal: 360, carbs: 32, protein: 28, fat: 13, cuisine: 'Western'),
        FoodItem(name: 'Chicken Caesar Salad', kcal: 380, carbs: 12, protein: 32, fat: 22, cuisine: 'Western'),
        FoodItem(name: 'Baked Salmon & Brown Rice', kcal: 460, carbs: 40, protein: 36, fat: 16, cuisine: 'Western'),
        FoodItem(name: 'Turkey Whole Wheat Wrap', kcal: 340, carbs: 30, protein: 26, fat: 11, cuisine: 'Western'),
      ],
      'Snacks': [
        FoodItem(name: 'Apple & Peanut Butter', kcal: 210, carbs: 26, protein: 5, fat: 11, cuisine: 'Western'),
        FoodItem(name: 'Mixed Almonds (30g)', kcal: 170, carbs: 6, protein: 6, fat: 15, cuisine: 'Western'),
        FoodItem(name: 'Whey Protein Shake', kcal: 140, carbs: 3, protein: 25, fat: 2, cuisine: 'Western'),
        FoodItem(name: 'Protein Bar', kcal: 210, carbs: 22, protein: 20, fat: 7, cuisine: 'Western'),
        FoodItem(name: 'Baby Carrots & Hummus', kcal: 120, carbs: 14, protein: 4, fat: 6, cuisine: 'Western'),
      ],
      'Dinner': [
        FoodItem(name: 'Grilled Steak & Broccoli', kcal: 440, carbs: 8, protein: 46, fat: 24, cuisine: 'Western'),
        FoodItem(name: 'Baked Chicken & Sweet Potato', kcal: 390, carbs: 34, protein: 38, fat: 10, cuisine: 'Western'),
        FoodItem(name: 'Salmon Fillet & Asparagus', kcal: 380, carbs: 6, protein: 35, fat: 24, cuisine: 'Western'),
        FoodItem(name: 'Whole Wheat Pasta Marinara', kcal: 350, carbs: 62, protein: 12, fat: 6, cuisine: 'Western'),
      ],
    },
    'Middle Eastern': {
      'Breakfast': [
        FoodItem(name: 'Shakshuka with Pita', kcal: 320, carbs: 28, protein: 15, fat: 16, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Labneh with Olive Oil & Zaatar', kcal: 210, carbs: 8, protein: 9, fat: 16, cuisine: 'Middle Eastern'),
        FoodItem(name: '3 Falafel with Tahini', kcal: 240, carbs: 20, protein: 7, fat: 15, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Foul Mudammas (Fava Beans)', kcal: 230, carbs: 32, protein: 12, fat: 6, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Grilled Halloumi (3 slices)', kcal: 220, carbs: 2, protein: 14, fat: 18, cuisine: 'Middle Eastern'),
      ],
      'Lunch': [
        FoodItem(name: 'Chicken Shawarma Bowl', kcal: 480, carbs: 36, protein: 38, fat: 21, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Shish Tawook with Rice', kcal: 450, carbs: 42, protein: 36, fat: 14, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Hummus with Beef & Pita', kcal: 420, carbs: 38, protein: 22, fat: 20, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Lamb Kebab (2 skewers)', kcal: 340, carbs: 4, protein: 28, fat: 24, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Fattoush Salad with Sumac', kcal: 160, carbs: 18, protein: 4, fat: 8, cuisine: 'Middle Eastern'),
      ],
      'Snacks': [
        FoodItem(name: '3 Medjool Dates & Walnuts', kcal: 210, carbs: 42, protein: 4, fat: 6, cuisine: 'Middle Eastern'),
        FoodItem(name: '1 Baklava', kcal: 190, carbs: 22, protein: 3, fat: 11, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Arabic Coffee with Cardamom', kcal: 20, carbs: 4, protein: 1, fat: 0, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Mutabbal & Pita Chips', kcal: 180, carbs: 20, protein: 4, fat: 10, cuisine: 'Middle Eastern'),
      ],
      'Dinner': [
        FoodItem(name: 'Mixed Grill (Chicken & Lamb)', kcal: 460, carbs: 6, protein: 48, fat: 28, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Lentil Soup with Lemon & Cumin', kcal: 190, carbs: 28, protein: 11, fat: 4, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Roasted Cauliflower with Tahini', kcal: 180, carbs: 14, protein: 6, fat: 12, cuisine: 'Middle Eastern'),
        FoodItem(name: 'Sayadieh (Spiced Fish & Rice)', kcal: 430, carbs: 48, protein: 32, fat: 12, cuisine: 'Middle Eastern'),
      ],
    },
  };

  // Default database fallback for backwards-compatibility
  static Map<String, List<FoodItem>> get defaultFoodDatabase =>
      foodsByCuisine['Bangladeshi']!;

  // Dynamic database for any selected cuisine
  static Map<String, List<FoodItem>> getFoodDatabaseForCuisine(String cuisine) {
    return foodsByCuisine[cuisine] ?? defaultFoodDatabase;
  }

  // Smart suggestions tailored to cuisine and meal type
  static FoodSuggestionData getSuggestion({
    required String mealType,
    required String cuisine,
  }) {
    final c = foodsByCuisine.containsKey(cuisine) ? cuisine : 'Bangladeshi';

    if (c == 'Indian') {
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: '2 Idli, Sambhar & Chutney',
            subtitle: '240 kcal · 8g protein',
            kcal: 240,
            protein: 8,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: '2 Chapati, Dal Tadka & Paneer',
            subtitle: '540 kcal · 26g protein',
            kcal: 540,
            protein: 26,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: 'Roasted Makhana & Masala Chai',
            subtitle: '190 kcal · 5g protein',
            kcal: 190,
            protein: 5,
          );
        case 'Dinner':
        default:
          return const FoodSuggestionData(
            title: '2 Phulka, Dal Makhani & Raita',
            subtitle: '480 kcal · 20g protein',
            kcal: 480,
            protein: 20,
          );
      }
    } else if (c == 'Western') {
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: 'Oatmeal, Greek yogurt & berries',
            subtitle: '320 kcal · 22g protein',
            kcal: 320,
            protein: 22,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: 'Grilled chicken breast & quinoa',
            subtitle: '460 kcal · 44g protein',
            kcal: 460,
            protein: 44,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: 'Apple slices & peanut butter',
            subtitle: '210 kcal · 5g protein',
            kcal: 210,
            protein: 5,
          );
        case 'Dinner':
        default:
          return const FoodSuggestionData(
            title: 'Baked salmon, asparagus & potato',
            subtitle: '480 kcal · 38g protein',
            kcal: 480,
            protein: 38,
          );
      }
    } else if (c == 'Middle Eastern') {
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: 'Shakshuka with whole wheat pita',
            subtitle: '320 kcal · 15g protein',
            kcal: 320,
            protein: 15,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: 'Shish Tawook with rice & hummus',
            subtitle: '520 kcal · 40g protein',
            kcal: 520,
            protein: 40,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: '3 Medjool dates & Arabic coffee',
            subtitle: '210 kcal · 4g protein',
            kcal: 210,
            protein: 4,
          );
        case 'Dinner':
        default:
          return const FoodSuggestionData(
            title: 'Mixed grill skewers & lentil soup',
            subtitle: '490 kcal · 46g protein',
            kcal: 490,
            protein: 46,
          );
      }
    } else {
      // Bangladeshi default
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: '2 Ruti, 1 Dim Bhaji & Cha',
            subtitle: '390 kcal · 15g protein',
            kcal: 390,
            protein: 15,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: '1 Plate Bhat, Chicken & Dal',
            subtitle: '600 kcal · 35g protein',
            kcal: 600,
            protein: 35,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: 'Chanachur & 1 Cup Cha',
            subtitle: '220 kcal · 6g protein',
            kcal: 220,
            protein: 6,
          );
        case 'Dinner':
        default:
          return const FoodSuggestionData(
            title: '2 Ruti, fish curry & veg bhaji',
            subtitle: '470 kcal · 29g protein',
            kcal: 470,
            protein: 29,
          );
      }
    }
  }
}
