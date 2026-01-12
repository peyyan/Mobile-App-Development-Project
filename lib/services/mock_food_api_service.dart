import 'dart:convert';

import 'package:http/http.dart' as http;

class FoodResult {
  final String foodName;
  final int estimatedCalories;

  FoodResult({
    required this.foodName,
    required this.estimatedCalories,
  });
}

class MockFoodApiService {
  Future<FoodResult> analyzeFood(String imagePath) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mocked HTTP response to simulate an API call.
    final mockResponse = http.Response(
      jsonEncode({
        'foodName': 'Grilled Chicken Bowl',
        'estimatedCalories': 520,
      }),
      200,
    );

    final data = jsonDecode(mockResponse.body) as Map<String, dynamic>;
    return FoodResult(
      foodName: data['foodName'] as String? ?? 'Unknown',
      estimatedCalories: (data['estimatedCalories'] as num?)?.toInt() ?? 0,
    );
  }
}
