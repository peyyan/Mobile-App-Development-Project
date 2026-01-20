import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutriscan/utils/color_ext.dart';

import '../models/food_log.dart';
import '../services/firebase_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.foodName,
    required this.calories,
    this.imageUrl,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    this.sugar,
    this.sodium,
    this.isViewOnly = false,
  });

  final String foodName;
  final int calories;
  final String? imageUrl;
  final int? protein;
  final int? carbs;
  final int? fat;
  final int? fiber;
  final int? sugar;
  final int? sodium;
  final bool isViewOnly;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;
  String _selectedMealType = 'Breakfast';

  final List<String> _mealTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Supper',
    'Snack',
  ];

  // Colors from design
  static const primaryColor = Color(0xFF13ec5b);
  static const backgroundColor = Color(0xFFf6f8f6);
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF0d1b12);

  Future<void> _saveResult() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You must be logged in.')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      final log = FoodLog(
        id: '',
        userId: user.uid,
        foodName: widget.foodName,
        calories: widget.calories,
        timestamp: DateTime.now(),
        mealType: _selectedMealType,
      );
      await FirebaseService().saveFoodLog(log);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Saved to history.')));
        // Navigate back to home after saving
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save.')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fiberValue = widget.fiber ?? 5;
    final sugarValue = widget.sugar ?? 2;
    final sodiumValue = widget.sodium ?? 120;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 1. Header Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 320,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.imageUrl ??
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBtf0sbyZ6NQ2hwzR-3IKuY-Ws7EC5Z895meiDc-HpNhYVjyj3_KvwB4FsAGy7dZVvuYih7KMd7om0fvyph4V5WfrfgsQqlLgpRxM5ZtSjqapYmD1UPTzQ2DNGyVeXX5A9LeNs5R54zcCqM8Ha8-0JUQ7oPeT_1C_PqytAXS8uKfzNArK07hWVcoewNuvzU5jlNR5o6s0djdWUlsf3UEYP6N-KWhmGqobU_8MtxKls9DBwk8kJOyB0zmCqjF-ss7JU_fYkuQRhOe2M',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.o(0.5), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),

          // 2. Navigation Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconBtn(
                      Icons.arrow_back_ios_new,
                      () => Navigator.of(context).pop(),
                    ),
                    Row(
                      children: [
                        _buildIconBtn(Icons.favorite_border, () {}),
                        const SizedBox(width: 12),
                        _buildIconBtn(Icons.ios_share, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Scrollable Content Sheet
          Positioned.fill(
            top: 280,
            child: Container(
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 40,
                    offset: Offset(0, -10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Meta Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 18, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          'Select Meal Type',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      widget.foodName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Meal Type Selector
                    if (!widget.isViewOnly) ...[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _mealTypes.map((type) {
                            final isSelected = _selectedMealType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _selectedMealType = type),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Text(
                                    type,
                                    style: GoogleFonts.manrope(
                                      color: isSelected
                                          ? textColor
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Calories
                    Column(
                      children: [
                        Text(
                          '${widget.calories}',
                          style: GoogleFonts.manrope(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                            height: 1.0,
                            letterSpacing: -1.0,
                          ),
                        ),
                        Text(
                          'KCAL',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Chips
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildChip(
                          Icons.verified,
                          'High Protein',
                          primaryColor.o(0.1),
                          primaryColor,
                          textColor,
                        ),
                        _buildChip(
                          Icons.eco,
                          'Low Carb',
                          Colors.grey[100]!,
                          Colors.grey[500]!,
                          Colors.grey[700]!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Macros Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildMacroCard(
                            'Protein',
                            '${widget.protein ?? 35}g',
                            0.75,
                            primaryColor,
                            Icons.fitness_center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMacroCard(
                            'Carbs',
                            '${widget.carbs ?? 12}g',
                            0.30,
                            Colors.orange[400]!,
                            Icons.bakery_dining,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMacroCard(
                            'Fats',
                            '${widget.fat ?? 18}g',
                            0.45,
                            Colors.yellow[600]!,
                            Icons.water_drop,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Micronutrients
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Micronutrients',
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _buildMicroRow(
                            Icons.grass,
                            Colors.green,
                            'Fiber',
                            '${fiberValue}g',
                            true,
                          ),
                          _buildMicroRow(
                            Icons.icecream,
                            Colors.pink,
                            'Sugar',
                            '${sugarValue}g',
                            true,
                          ),
                          _buildMicroRow(
                            Icons.grain,
                            Colors.blue,
                            'Sodium',
                            '${sodiumValue}mg',
                            false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // AI Insight
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF102216), Color(0xFF0A160E)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.o(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Analysis',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'This meal is well-balanced for your post-workout recovery. The protein content helps muscle repair, while fats are within your daily limit.',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Log Meal Button
          if (!widget.isViewOnly)
            Positioned(
              bottom: 32,
              left: 24,
              right: 24,
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: const Color(0xFF0d1b12),
                    elevation: 8,
                    shadowColor: primaryColor.o(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                          color: Color(0xFF0d1b12),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_circle, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Log Meal',
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIconBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.o(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildChip(
    IconData icon,
    String label,
    Color bg,
    Color iconColor,
    Color txtColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.o(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: txtColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(
    String label,
    String value,
    double progress,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.o(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[100],
              color: color,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroRow(
    IconData icon,
    MaterialColor color,
    String label,
    String value,
    bool showDivider,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color[50], // Light shade
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: color[600],
                    ), // Dark shade
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.grey[100]),
      ],
    );
  }
}
