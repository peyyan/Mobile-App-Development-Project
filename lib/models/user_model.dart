class UserModel {
  final String uid;
  final int age;
  final double height;
  final double weight;
  final String gender;
  final String activityLevel;
  final String goal;
  final int targetCalories;
  final String email;

  UserModel({
    required this.uid,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.targetCalories,
    required this.email,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      age: data['age'] ?? 0,
      height: (data['height'] ?? 0).toDouble(),
      weight: (data['weight'] ?? 0).toDouble(),
      gender: data['gender'] ?? 'male',
      activityLevel: data['activityLevel'] ?? 'moderate',
      goal: data['goal'] ?? 'maintain',
      targetCalories: data['targetCalories'] ?? 2000,
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'height': height,
      'weight': weight,
      'gender': gender,
      'activityLevel': activityLevel,
      'goal': goal,
      'targetCalories': targetCalories,
      'email': email,
    };
  }
}
