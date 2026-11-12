import '../models/user_profile.dart';

/// Calculates Body Mass Index (BMI).
/// Formula: weight (kg) / ((height (cm) / 100) ^ 2)
double calcBMI(double weightKg, double heightCm) {
  if (heightCm <= 0) return 0.0;
  final heightM = heightCm / 100.0;
  return weightKg / (heightM * heightM);
}

/// Returns the BMI category: Underweight (<18.5), Healthy (<25), Overweight (<30), Obese (>=30).
String getBMICategory(double bmi) {
  if (bmi < 18.5) {
    return 'Underweight';
  } else if (bmi < 25.0) {
    return 'Healthy';
  } else if (bmi < 30.0) {
    return 'Overweight';
  } else {
    return 'Obese';
  }
}

/// Returns the indicator slider position between 0.0 and 1.0 for the BMI gauge UI.
/// Formula: Math.max(0, Math.min(1, (bmi - 15) / 20))
double getBMIPosition(double bmi) {
  final pos = (bmi - 15.0) / 20.0;
  return pos.clamp(0.0, 1.0);
}

/// Calculates Total Daily Energy Expenditure (TDEE).
/// BMR = 10 * weight + 6.25 * height - 5 * age + (female ? -161 : 5)
/// Multiplier: Light = 1.375, Moderate = 1.55, Active = 1.725
int calcTDEE({
  required double weightKg,
  required double heightCm,
  required int age,
  required String gender,
  required String activityLevel,
}) {
  final double activityMultiplier;
  switch (activityLevel) {
    case 'Light':
      activityMultiplier = 1.375;
      break;
    case 'Active':
      activityMultiplier = 1.725;
      break;
    case 'Moderate':
    default:
      activityMultiplier = 1.55;
      break;
  }

  final genderOffset = gender.toLowerCase() == 'female' ? -161 : 5;
  final bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + genderOffset;
  return (bmr * activityMultiplier).round();
}

/// Returns calorie offset based on goal and weight loss pace.
int getPaceOffset(String goal, String pace) {
  if (goal == 'Lose fat') {
    switch (pace) {
      case 'Mild':
        return -300;
      case 'Intense':
        return -750;
      case 'Extreme':
        return -1000;
      case 'Moderate':
      default:
        return -500;
    }
  } else if (goal == 'Build muscle') {
    return 250;
  }
  return 0;
}

/// Calculates daily target calorie budget based on TDEE, goal, pace, and gender.
/// Includes minimum safety floor (1200 kcal female, 1500 kcal male).
int calcBudget({
  required int tdee,
  required String goal,
  String pace = 'Moderate',
  String gender = 'Male',
}) {
  final offset = getPaceOffset(goal, pace);
  final rawBudget = tdee + offset;
  final minFloor = gender.toLowerCase() == 'female' ? 1200 : 1500;
  return rawBudget < minFloor ? minFloor : rawBudget;
}

/// Convenient container class for all calculated profile metrics.
class ProfileMetrics {
  final double bmi;
  final String bmiCategory;
  final double bmiPosition;
  final int tdee;
  final int budget;
  final int offset;

  const ProfileMetrics({
    required this.bmi,
    required this.bmiCategory,
    required this.bmiPosition,
    required this.tdee,
    required this.budget,
    required this.offset,
  });

  factory ProfileMetrics.fromProfile(UserProfile profile) {
    final bmiVal = calcBMI(profile.weight, profile.height);
    final category = getBMICategory(bmiVal);
    final position = getBMIPosition(bmiVal);
    final tdeeVal = calcTDEE(
      weightKg: profile.weight,
      heightCm: profile.height,
      age: profile.age,
      gender: profile.gender,
      activityLevel: profile.activityLevel,
    );
    final offsetVal = getPaceOffset(profile.goal, profile.pace);
    final budgetVal = calcBudget(
      tdee: tdeeVal,
      goal: profile.goal,
      pace: profile.pace,
      gender: profile.gender,
    );

    return ProfileMetrics(
      bmi: double.parse(bmiVal.toStringAsFixed(1)),
      bmiCategory: category,
      bmiPosition: position,
      tdee: tdeeVal,
      budget: budgetVal,
      offset: offsetVal,
    );
  }
}
