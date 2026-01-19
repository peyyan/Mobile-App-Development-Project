import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalorieIntakeForm extends StatefulWidget {
  const CalorieIntakeForm({super.key});

  @override
  State<CalorieIntakeForm> createState() => _CalorieIntakeFormState();
}

class _CalorieIntakeFormState extends State<CalorieIntakeForm> {
  final PageController _pageController = PageController();

  // State variables
  int _currentPage = 0;
  bool _isLoading = false;

  // Form Data
  String _gender = 'male';
  int _age = 25;
  double _height = 170; // cm
  double _weight = 70; // kg
  String _activityLevel = 'moderate';
  String _goal = 'maintain';

  final int _totalPages = 3;

  // Configuration Maps
  final Map<String, double> _activityMultipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'very_active': 1.9,
  };

  final Map<String, int> _goalAdjustments = {
    'lose': -500,
    'maintain': 0,
    'gain': 500,
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveUserProfile();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Calculations
  double _calculateBMR() {
    if (_gender == 'male') {
      return (10 * _weight) + (6.25 * _height) - (5 * _age) + 5;
    } else {
      return (10 * _weight) + (6.25 * _height) - (5 * _age) - 161;
    }
  }

  int _calculateTDEE() {
    final bmr = _calculateBMR();
    final tdee = bmr * (_activityMultipliers[_activityLevel] ?? 1.2);
    return (tdee + (_goalAdjustments[_goal] ?? 0)).round();
  }

  Future<void> _saveUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'age': _age,
        'height': _height,
        'weight': _weight,
        'gender': _gender,
        'activityLevel': _activityLevel,
        'goal': _goal,
        'targetCalories': _calculateTDEE(),
        'createdAt': FieldValue.serverTimestamp(),
        'email': user.email,
        'profileCompleted': true,
      });

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with Progress
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 20),
                      onPressed: _previousPage,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  else
                    const SizedBox(width: 24),
                  const Spacer(),
                  // Progress Indicators
                  Row(
                    children: List.generate(_totalPages, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(left: 8),
                        height: 4,
                        width: index == _currentPage ? 24 : 12,
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? const Color(0xFF00D563)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              ),
            ),

            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D563),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          _currentPage == _totalPages - 1
                              ? 'Calculate My Plan'
                              : 'Next Step',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Basic Info (Gender & Age)
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tell us about\nyourself',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'To give you a better experience we need to know your gender and age.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),

          // Gender Selection
          const Text(
            'Gender',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildGenderCard('Male', 'male', Icons.male)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderCard('Female', 'female', Icons.female),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Age Selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Age',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '$_age years',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00D563),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF00D563),
              inactiveTrackColor: const Color(0xFF00D563).withOpacity(0.2),
              thumbColor: const Color(0xFF00D563),
              overlayColor: const Color(0xFF00D563).withOpacity(0.1),
              trackHeight: 6,
            ),
            child: Slider(
              value: _age.toDouble(),
              min: 10,
              max: 100,
              divisions: 90,
              onChanged: (value) => setState(() => _age = value.round()),
            ),
          ),
        ],
      ),
    );
  }

  // Step 2: Body Stats (Height & Weight)
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Body Measurements',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us calculate your Body Mass Index (BMI).',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),

          const SizedBox(height: 40),

          // Height Slider
          _buildMeasurementSlider(
            title: 'Height',
            value: _height,
            unit: 'cm',
            min: 100,
            max: 250,
            onChanged: (v) => setState(() => _height = v),
          ),

          const SizedBox(height: 40),

          // Weight Slider
          _buildMeasurementSlider(
            title: 'Weight',
            value: _weight,
            unit: 'kg',
            min: 30,
            max: 200,
            onChanged: (v) => setState(() => _weight = v),
          ),
        ],
      ),
    );
  }

  // Step 3: Lifestyle (Activity & Goal)
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Lifestyle',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 40),

          // Activity Level
          const Text(
            'How active are you?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _activityLevel,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF00D563),
                ),
                items: [
                  _buildDropdownItem(
                    'sedentary',
                    'Sedentary',
                    'Little or no exercise',
                  ),
                  _buildDropdownItem(
                    'light',
                    'Lightly Active',
                    'Exercise 1-3 days/week',
                  ),
                  _buildDropdownItem(
                    'moderate',
                    'Moderately Active',
                    'Exercise 3-5 days/week',
                  ),
                  _buildDropdownItem(
                    'active',
                    'Very Active',
                    'Exercise 6-7 days/week',
                  ),
                  _buildDropdownItem(
                    'very_active',
                    'Extra Active',
                    'Physical job + exercise',
                  ),
                ],
                onChanged: (v) => setState(() => _activityLevel = v!),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Goal
          const Text(
            'What is your goal?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGoalCard(
                  'Lose',
                  'lose',
                  Icons.trending_down,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGoalCard(
                  'Maintain',
                  'maintain',
                  Icons.trending_flat,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGoalCard(
                  'Gain',
                  'gain',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildGenderCard(String label, String value, IconData icon) {
    bool isSelected = _gender == value;
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00D563) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF00D563) : Colors.grey[200]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00D563).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementSlider({
    required String title,
    required double value,
    required String unit,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value.round().toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00D563),
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF00D563),
            inactiveTrackColor: const Color(0xFF00D563).withOpacity(0.2),
            thumbColor: const Color(0xFF00D563),
            overlayColor: const Color(0xFF00D563).withOpacity(0.1),
            trackHeight: 6,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    String value,
    String title,
    String subtitle,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    bool isSelected = _goal == value;
    return GestureDetector(
      onTap: () => setState(() => _goal = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              // Icon circle
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
