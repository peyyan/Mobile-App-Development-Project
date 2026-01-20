import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class FoodResult {
  final String foodName;
  final int estimatedCalories;

  FoodResult({required this.foodName, required this.estimatedCalories});
}

class FoodAnalysisService {
  static const String _apiKey = 'AIzaSyCeXGmp0PK0g_4sO3XPuO5vs4UMKE6DpC4';
  static const String _modelId = 'gemini-pro-vision';

  Future<FoodResult> analyzeFood(String imagePath) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Missing GEMINI_API_KEY. Run: '
        'flutter run --dart-define=GEMINI_API_KEY=YOUR_KEY',
      );
    }

    try {
      final model = GenerativeModel(model: _modelId, apiKey: _apiKey);

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception("Image file not found");
      }

      final imageBytes = await imageFile.readAsBytes();

      final prompt = TextPart(
        "Analyze this food image. Identify the main food item and estimate its calories. "
        "Return strictly a JSON object with keys: 'foodName' (string) and 'estimatedCalories' (integer). "
        "Do not include Markdown formatting or explanations.",
      );

      final content = [
        Content.multi([prompt, DataPart('image/jpeg', imageBytes)]),
      ];

      final response = await model.generateContent(content);
      final text = response.text;

      if (text == null || text.isEmpty) {
        throw Exception("Empty response from AI");
      }

      // Clean the response of any potential markdown code blocks
      final cleanJson = text.replaceAll(RegExp(r'```json|```'), '').trim();

      final Map<String, dynamic> data = jsonDecode(cleanJson);

      return FoodResult(
        foodName: data['foodName']?.toString() ?? 'Unknown Food',
        estimatedCalories: (data['estimatedCalories'] as num?)?.toInt() ?? 0,
      );
    } catch (e) {
      debugPrint('Error analyzing food: $e');
      // Re-throw to be handled by UI
      rethrow;
    }
  }
}
