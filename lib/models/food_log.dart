import 'package:cloud_firestore/cloud_firestore.dart';

class FoodLog {
  final String id;
  final String userId;
  final String foodName;
  final int calories;
  final DateTime timestamp;

  FoodLog({
    required this.id,
    required this.userId,
    required this.foodName,
    required this.calories,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'foodName': foodName,
      'calories': calories,
      'timestamp': Timestamp.fromDate(timestamp),
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

    return FoodLog(
      id: id,
      userId: map['userId'] as String? ?? '',
      foodName: map['foodName'] as String? ?? 'Unknown',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      timestamp: parsedTimestamp,
    );
  }
}
