class UserProfile {
  final String gender; // 'Male', 'Female', 'Other'
  final int age;
  final double height; // in cm
  final double weight; // in kg
  final String activityLevel; // 'Light', 'Moderate', 'Active'
  final String goal; // 'Lose fat', 'Maintain', 'Build muscle'
  final String pace; // 'Mild', 'Moderate', 'Intense', 'Extreme'

  const UserProfile({
    this.gender = 'Male',
    this.age = 26,
    this.height = 172.0,
    this.weight = 68.0,
    this.activityLevel = 'Moderate',
    this.goal = 'Lose fat',
    this.pace = 'Moderate',
  });

  UserProfile copyWith({
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? activityLevel,
    String? goal,
    String? pace,
  }) {
    return UserProfile(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      pace: pace ?? this.pace,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
      'goal': goal,
      'pace': pace,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      gender: map['gender'] as String? ?? 'Male',
      age: (map['age'] as num?)?.toInt() ?? 26,
      height: (map['height'] as num?)?.toDouble() ?? 172.0,
      weight: (map['weight'] as num?)?.toDouble() ?? 68.0,
      activityLevel: map['activityLevel'] as String? ?? 'Moderate',
      goal: map['goal'] as String? ?? 'Lose fat',
      pace: map['pace'] as String? ?? 'Moderate',
    );
  }
}
