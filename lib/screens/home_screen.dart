import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/food_log.dart';
import '../models/user_model.dart';
import 'profile_screen.dart';
import 'result_screen.dart';
import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Default to Home
  String _selectedFilter = 'All';
  DateTime _selectedDate = DateTime.now();

  final List<String> _filters = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // Profile tapped
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF13ec5b), // Primary color
              onPrimary: Color(0xFF0d1b12), // Text on primary
              onSurface: Color(0xFF0d1b12), // Body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF13ec5b), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const primaryColor = Color(0xFF13ec5b);
    const backgroundLight = Color(0xFFffffff);
    const cardLight = Color(0xFFF7F9F8);
    const textColor = Color(0xFF0d1b12);
    // const backgroundDark = Color(0xFF102216); // Keeping light mode focus for now

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: backgroundLight.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'History',
                            style: GoogleFonts.manrope(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Your nutritional timeline',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: textColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  if (filter != 'All') ...[
                                    Icon(
                                      _getFilterIcon(filter),
                                      size: 18,
                                      color: isSelected
                                          ? textColor
                                          : textColor.withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    filter,
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isSelected
                                          ? textColor
                                          : textColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: StreamBuilder<UserModel?>(
                stream: FirebaseService().getUser(
                  FirebaseAuth.instance.currentUser?.uid ?? '',
                ),
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  final targetCalories = user?.targetCalories ?? 2000;
                  final goal = user?.goal ?? 'maintain';

                  String goalText;
                  if (goal == 'lose') {
                    goalText = 'Deficit Goal';
                  } else if (goal == 'gain') {
                    goalText = 'Surplus Goal';
                  } else {
                    goalText = 'Maintenance';
                  }

                  return StreamBuilder<List<FoodLog>>(
                    stream: FirebaseService().getFoodLogsStream(
                      FirebaseAuth.instance.currentUser?.uid ?? '',
                    ),
                    builder: (context, logSnapshot) {
                      if (logSnapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Error loading data: ${logSnapshot.error}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (logSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final logs = logSnapshot.data ?? [];

                      // Filter by selected date
                      final selectedLogs = logs.where((log) {
                        return log.timestamp.year == _selectedDate.year &&
                            log.timestamp.month == _selectedDate.month &&
                            log.timestamp.day == _selectedDate.day;
                      }).toList();

                      // Calculate total calories
                      final totalCalories = selectedLogs.fold<int>(
                        0,
                        (sum, item) => sum + item.calories,
                      );

                      // Categorize Logs
                      final Map<String, List<FoodLog>> categorizedLogs = {
                        'Breakfast': [],
                        'Lunch': [],
                        'Dinner': [],
                        'Snack': [],
                        'Supper': [],
                      };

                      for (var log in selectedLogs) {
                        if (categorizedLogs.containsKey(log.mealType)) {
                          categorizedLogs[log.mealType]!.add(log);
                        } else if (log.mealType == 'Evening Tea') {
                          categorizedLogs['Snack']!.add(log);
                        } else {
                          // Default to Snack if unknown
                          categorizedLogs['Snack']!.add(log);
                        }
                      }

                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        children: [
                          // Goal Header
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Daily Target',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        color: textColor.withOpacity(0.6),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      goalText,
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$targetCalories',
                                      style: GoogleFonts.manrope(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        'kcal',
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: textColor.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Today Summary
                          _buildSectionHeader(
                            'Total Intake',
                            '$totalCalories / $targetCalories kcal',
                            primaryColor,
                          ),
                          const SizedBox(height: 24),

                          // Meal Categories
                          ...categorizedLogs.entries.map((entry) {
                            if (entry.value.isEmpty)
                              return const SizedBox.shrink();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(
                                    entry.key.toUpperCase(),
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[500],
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                ...entry.value.map(
                                  (log) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildMealCard(
                                      title: log.foodName,
                                      category: entry.key,
                                      imageUri:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCj3Ru18d53PPXAfoR5OeiVvCVVEAG3uXzY8KgzeE7IAwCRL8hDsD_yP-cPLa_c2Ijx53kDran0hbioFtR2YLNEmOwOLt0nI1xbq6YG9q8DT-eeS05Pj2lMcl6hevOWDtoLaThmXferFUn6EkpBnC9b7V2FstJH2WUtvuYH8MUiuSpnaaA0WEPb7FjpWcfSLG64cQTeZpZl0A7GFMndue61ZnBuzAjo0jcQ19T0MibMKxKeGyvU5wspU5UDhnL1guLDv4RQXOCrzs8', // Placeholder or add image to FoodLog
                                      calories: log.calories,
                                      protein:
                                          0, // TODO: Add macro support to FoodLog
                                      fat: 0,
                                      healthType: HealthScoreType
                                          .good, // Dynamic logic needed later
                                      primaryColor: primaryColor,
                                      cardColor: cardLight,
                                      textColor: textColor,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultScreen(
                                            foodName: log.foodName,
                                            calories: log.calories,
                                            isViewOnly: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),

                          if (selectedLogs.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'No meals logged for this day',
                                  style: GoogleFonts.manrope(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 24),
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ScanScreen(cameras: widget.cameras),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor,
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.filter_center_focus, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Scan New Meal',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 24,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: backgroundLight.withOpacity(0.95),
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_filled, 'Home', 0),
            const SizedBox(width: 140), // Large spacer for FAB
            _buildNavItem(Icons.person_outline, 'Profile', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String kCal, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0d1b12),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color == Colors.grey
                ? Colors.transparent
                : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            kCal,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color == Colors.grey ? color : color.withOpacity(1.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard({
    required String title,
    required String category,
    required String imageUri,
    required int calories,
    required int protein,
    required int fat,
    required HealthScoreType healthType,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    VoidCallback? onTap,
  }) {
    Color healthColor;
    switch (healthType) {
      case HealthScoreType.good:
        healthColor = primaryColor;
        break;
      case HealthScoreType.moderate:
        healthColor = Colors.yellow[700]!;
        break;
      case HealthScoreType.bad:
        healthColor = Colors.red[500]!;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUri,
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 96,
                      height: 96,
                      color: Colors.grey[300],
                      child: const Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.toUpperCase(),
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: textColor.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                          // Health Dot
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: healthColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: healthColor.withOpacity(0.6),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Stats
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 16,
                            color: textColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$calories kcal',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildDot(),
                          const SizedBox(width: 8),
                          Text(
                            '${protein}g Pro',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildDot(),
                          const SizedBox(width: 8),
                          Text(
                            fat > 0 ? '${fat}g Fat' : 'High Carb',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    const primaryColor = Color(0xFF13ec5b);
    final color = isSelected ? primaryColor : Colors.grey[400];

    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'Breakfast':
        return Icons.wb_sunny_outlined;
      case 'Lunch':
        return Icons.light_mode_outlined;
      case 'Dinner':
        return Icons.dark_mode_outlined;
      case 'Snack':
        return Icons.cookie_outlined;
      default:
        return Icons.grid_view;
    }
  }
}

enum HealthScoreType { good, moderate, bad }
