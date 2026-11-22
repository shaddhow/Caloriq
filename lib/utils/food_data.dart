import '../models/food_item.dart';

class FoodSuggestionData {
  final String title;
  final String subtitle;
  final int kcal;
  final int protein;
  final String swapTip;
  final int savingsKcal;

  const FoodSuggestionData({
    required this.title,
    required this.subtitle,
    required this.kcal,
    required this.protein,
    required this.swapTip,
    this.savingsKcal = 0,
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
        FoodItem(name: '2 Dim Sheddho (Boiled)', kcal: 140, carbs: 1, protein: 13, fat: 9, cuisine: 'Bangladeshi'),
        FoodItem(name: '2 Ruti', kcal: 200, carbs: 40, protein: 6, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Dim Sheddho', kcal: 70, carbs: 0.5, protein: 6.5, fat: 4.5, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Mixed Sabji (Low Oil)', kcal: 85, carbs: 12, protein: 3, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Oats Khichuri', kcal: 260, carbs: 38, protein: 10, fat: 6, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Dim Bhaji', kcal: 120, carbs: 1, protein: 7, fat: 9, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Paratha', kcal: 260, carbs: 32, protein: 5, fat: 12, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Rong Cha / Green Tea', kcal: 5, carbs: 1, protein: 0, fat: 0, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Cup Cha (Dudh-Chini)', kcal: 70, carbs: 10, protein: 2, fat: 2, cuisine: 'Bangladeshi'),
      ],
      'Lunch': [
        FoodItem(name: 'Half Plate Bhat', kcal: 130, carbs: 28, protein: 2, fat: 0.5, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Chicken Curry', kcal: 210, carbs: 4, protein: 22, fat: 12, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Grilled Chicken (150g)', kcal: 220, carbs: 0, protein: 36, fat: 5, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Cucumber & Tomato Salad', kcal: 35, carbs: 7, protein: 1, fat: 0, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Veg Bhaji', kcal: 90, carbs: 10, protein: 3, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Plate Bhat', kcal: 240, carbs: 52, protein: 4, fat: 1, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Hilsa Fish Curry', kcal: 280, carbs: 3, protein: 24, fat: 18, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Rui Fish Bhaja', kcal: 190, carbs: 2, protein: 22, fat: 10, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Beef Bhuna', kcal: 320, carbs: 2, protein: 26, fat: 22, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Begun Bhorta', kcal: 85, carbs: 8, protein: 2, fat: 5, cuisine: 'Bangladeshi'),
      ],
      'Snacks': [
        FoodItem(name: 'Boiled Chola & Shosa', kcal: 120, carbs: 18, protein: 6, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Banana', kcal: 105, carbs: 27, protein: 1, fat: 0, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Green Apple', kcal: 80, carbs: 20, protein: 0, fat: 0, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Muri with Chola', kcal: 110, carbs: 22, protein: 4, fat: 1, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Rong Cha / Green Tea', kcal: 5, carbs: 1, protein: 0, fat: 0, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Jhalmuri (1 thonga)', kcal: 130, carbs: 22, protein: 3, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Chanachur (50g)', kcal: 150, carbs: 14, protein: 4, fat: 9, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Singara', kcal: 180, carbs: 22, protein: 3, fat: 10, cuisine: 'Bangladeshi'),
      ],
      'Dinner': [
        FoodItem(name: '1-2 Lal Ruti', kcal: 160, carbs: 32, protein: 5, fat: 1, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Rui Fish Grilled/Curry', kcal: 180, carbs: 3, protein: 22, fat: 8, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Mixed Sabji', kcal: 85, carbs: 12, protein: 3, fat: 2, cuisine: 'Bangladeshi'),
        FoodItem(name: '1 Bowl Dal', kcal: 150, carbs: 20, protein: 9, fat: 4, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Chicken Roast', kcal: 290, carbs: 6, protein: 28, fat: 16, cuisine: 'Bangladeshi'),
        FoodItem(name: 'Half Plate Bhat', kcal: 130, carbs: 28, protein: 2, fat: 0.5, cuisine: 'Bangladeshi'),
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
            title: '2 Steamed Idli, Sambhar & Cucumber',
            subtitle: '190 kcal · 8g protein · 0g oil',
            swapTip: 'Swap fried poori or paratha for steamed idli & sambhar — saves 180 kcal of cooking oil!',
            savingsKcal: 180,
            kcal: 190,
            protein: 8,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: '2 Phulka, Dal Tadka & Cucumber Raita',
            subtitle: '360 kcal · 18g protein · High fiber',
            swapTip: 'Swap butter paneer for yellow dal & cucumber raita — maximizes volume while slashing saturated fat.',
            savingsKcal: 160,
            kcal: 360,
            protein: 18,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: 'Roasted Makhana & Spiced Black Tea',
            subtitle: '110 kcal · 4g protein · 0g sugar',
            swapTip: 'Swap fried snacks for roasted makhana — curbs cravings with 0g added sugar or trans fat.',
            savingsKcal: 140,
            kcal: 110,
            protein: 4,
          );
        case 'Dinner':
          return const FoodSuggestionData(
            title: '2 Phulka, Palak Paneer & Mixed Salad',
            subtitle: '340 kcal · 18g protein · Low carb',
            swapTip: 'Swap heavy naan for 2 phulkas with palak paneer to keep carbs low before bedtime.',
            savingsKcal: 150,
            kcal: 340,
            protein: 18,
          );
        case 'Recovery':
        default:
          return const FoodSuggestionData(
            title: 'Warm Jeera / Chamomile Water',
            subtitle: '0 kcal · Rest & hydration mode',
            swapTip: 'All meals completed! Hydrate with warm water to support metabolism and restful sleep.',
            savingsKcal: 0,
            kcal: 0,
            protein: 0,
          );
      }
    } else if (c == 'Western') {
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: 'Oatmeal, 2 Boiled Egg Whites & Berries',
            subtitle: '240 kcal · 16g protein · 0g oil',
            swapTip: 'Swap sugary pancakes for oats & egg whites — sustained energy with zero blood sugar crash!',
            savingsKcal: 220,
            kcal: 240,
            protein: 16,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: 'Grilled Chicken Breast & Big Greens Salad',
            subtitle: '360 kcal · 42g protein · Lean meal',
            swapTip: 'Swap heavy mayonnaise for olive oil & lemon on a massive bed of fresh greens.',
            savingsKcal: 180,
            kcal: 360,
            protein: 42,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: 'Apple Slices & 1 Boiled Egg',
            subtitle: '140 kcal · 7g protein · High fiber',
            swapTip: 'Swap packaged cookies for whole fresh apple slices — rich in pectin fiber to suppress hunger.',
            savingsKcal: 130,
            kcal: 140,
            protein: 7,
          );
        case 'Dinner':
          return const FoodSuggestionData(
            title: 'Baked Salmon, Steamed Asparagus & Veggies',
            subtitle: '380 kcal · 36g protein · Heart healthy',
            swapTip: 'Swap creamy pasta for baked salmon & steamed asparagus — packed with omega-3s for fast fat loss.',
            savingsKcal: 210,
            kcal: 380,
            protein: 36,
          );
        case 'Recovery':
        default:
          return const FoodSuggestionData(
            title: 'Chamomile Herbal Tea & 1 Glass Water',
            subtitle: '0 kcal · Overnight cellular recovery',
            swapTip: 'All daily meals logged! Stay hydrated with herbal tea for optimal overnight recovery.',
            savingsKcal: 0,
            kcal: 0,
            protein: 0,
          );
      }
    } else if (c == 'Middle Eastern') {
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: 'Shakshuka (Low Oil) with Whole Wheat Pita',
            subtitle: '250 kcal · 16g protein · Clean start',
            swapTip: 'Poach eggs directly in tomato-bell pepper stew instead of deep frying to save 120 kcal!',
            savingsKcal: 120,
            kcal: 250,
            protein: 16,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: 'Shish Tawook with Fattoush Salad & Hummus',
            subtitle: '410 kcal · 38g protein · High volume',
            swapTip: 'Swap extra white rice for a mountain of crunchy fattoush salad with sumac.',
            savingsKcal: 150,
            kcal: 410,
            protein: 38,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: '2 Medjool Dates, Arabic Coffee & Walnuts',
            subtitle: '130 kcal · 3g protein · Natural energy',
            swapTip: 'Swap sugary baklava for fresh medjool dates & walnuts for natural sustained energy.',
            savingsKcal: 140,
            kcal: 130,
            protein: 3,
          );
        case 'Dinner':
          return const FoodSuggestionData(
            title: 'Lentil Soup with Lemon & Grilled Chicken Skewer',
            subtitle: '360 kcal · 38g protein · Low calorie',
            swapTip: 'Swap thick pita bread for warm spiced lentil soup with fresh lemon.',
            savingsKcal: 160,
            kcal: 360,
            protein: 38,
          );
        case 'Recovery':
        default:
          return const FoodSuggestionData(
            title: 'Warm Anise / Cardamom Herbal Tea',
            subtitle: '0 kcal · Rest & hydration mode',
            swapTip: 'All meals recorded! Unwind with warm cardamom or anise tea for effortless digestion.',
            savingsKcal: 0,
            kcal: 0,
            protein: 0,
          );
      }
    } else {
      // Bangladeshi default: Clean, Healthy, High-Volume Meals!
      switch (mealType) {
        case 'Breakfast':
          return const FoodSuggestionData(
            title: '2 Boiled Eggs, Mixed Sabji & Lal Ruti',
            subtitle: '260 kcal · 18g clean protein · 0g oil',
            swapTip: 'Swap fried eggs & paratha for 2 boiled eggs & sabji — doubles food volume with 0g cooking oil and saves 280 kcal!',
            savingsKcal: 280,
            kcal: 260,
            protein: 18,
          );
        case 'Lunch':
          return const FoodSuggestionData(
            title: 'Half Plate Bhat, Chicken & Big Bowl Dal',
            subtitle: '410 kcal · 34g protein · High volume',
            swapTip: 'Keep rice to half plate (150g) and double your dal & salad volume — cuts 200 kcal without feeling hungry.',
            savingsKcal: 200,
            kcal: 410,
            protein: 34,
          );
        case 'Snacks':
          return const FoodSuggestionData(
            title: 'Boiled Chola, Cucumber Salad & Green Tea',
            subtitle: '120 kcal · 7g protein · 0g oil',
            swapTip: 'Swap fried singara or chanachur for boiled chola & cucumber — zero unhealthy fat and saves 180 kcal.',
            savingsKcal: 180,
            kcal: 120,
            protein: 7,
          );
        case 'Dinner':
          return const FoodSuggestionData(
            title: 'Half Plate Bhat or 2 Lal Ruti, Rui Fish & Sabji',
            subtitle: '330 kcal · 26g protein · Balanced plate',
            swapTip: 'Both half plate rice (150g) or 2 ruti fit comfortably! Pair with high-volume dal & sabji to stay full without surplus calories.',
            savingsKcal: 190,
            kcal: 330,
            protein: 26,
          );
        case 'Recovery':
        default:
          return const FoodSuggestionData(
            title: 'Warm Rong Cha / Green Tea & Water',
            subtitle: '0 kcal · Overnight hydration & recovery',
            swapTip: 'All meals logged today! Drink 1 glass of water or green tea to aid metabolism and restful sleep.',
            savingsKcal: 0,
            kcal: 0,
            protein: 0,
          );
      }
    }
  }
}
