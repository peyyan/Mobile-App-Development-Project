import 'package:cloud_firestore/cloud_firestore.dart';

class FoodLog {
  final String id;
  final String userId;
  final String foodName;
  final int calories;
  final DateTime timestamp;
  final String mealType;

  FoodLog({
    required this.id,
    required this.userId,
    required this.foodName,
    required this.calories,
    required this.timestamp,
    required this.mealType,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'foodName': foodName,
      'calories': calories,
      'timestamp': Timestamp.fromDate(timestamp),
      'mealType': mealType,
    };
  }

  factory FoodLog.fromMap(String id, Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];
    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp =
          DateTime.tryParse(rawTimestamp)?.toLocal() ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    String mealType = map['mealType'] as String? ?? '';
    if (mealType.isEmpty) {
      final hour = parsedTimestamp.hour;
      if (hour >= 4 && hour < 12) {
        mealType = 'Breakfast';
      } else if (hour >= 12 && hour < 16) {
        mealType = 'Lunch';
      } else if (hour >= 16 && hour < 19) {
        mealType = 'Evening Tea';
      } else if (hour >= 19) {
        mealType = 'Dinner';
      } else {
        mealType = 'Supper';
      }
    }

    return FoodLog(
      id: id,
      userId: map['userId'] as String? ?? '',
      foodName: map['foodName'] as String? ?? 'Unknown',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      timestamp: parsedTimestamp,
      mealType: mealType,
    );
  }
}
