import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutriscan/utils/color_ext.dart';

import '../models/food_log.dart';
import '../services/firebase_service.dart';
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
  bool _isLoading = true;
  List<FoodLog> _logs = [];

  final List<String> _filters = ['All'];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final logs = await FirebaseService().fetchFoodLogs(user.uid);
      if (mounted) {
        setState(() {
          _logs = logs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load history')));
        setState(() => _isLoading = false);
      }
    }
  }

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

  List<FoodLog> _filteredLogs() {
    final logsForDate = _logs.where((log) {
      return log.timestamp.year == _selectedDate.year &&
          log.timestamp.month == _selectedDate.month &&
          log.timestamp.day == _selectedDate.day;
    }).toList();

    return logsForDate;
  }

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const primaryColor = Color(0xFF13ec5b);
    const backgroundLight = Color(0xFFffffff);
    const cardLight = Color(0xFFF7F9F8);
    const textColor = Color(0xFF0d1b12);

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
                color: backgroundLight.o(0.9),
                border: Border(bottom: BorderSide(color: Colors.black.o(0.05))),
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
                              color: textColor.o(0.5),
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
                                          color: primaryColor.o(0.2),
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
                                          : textColor.o(0.5),
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
                                          : textColor.o(0.6),
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : _filteredLogs().isEmpty
                  ? Center(
                      child: Text(
                        'No history yet.',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor.o(0.6),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      itemCount: _filteredLogs().length,
                      itemBuilder: (context, index) {
                        final log = _filteredLogs()[index];
                        final healthType = log.calories <= 400
                            ? HealthScoreType.good
                            : log.calories <= 700
                            ? HealthScoreType.moderate
                            : HealthScoreType.bad;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildMealCard(
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
                            title: log.foodName,
                            category: 'Logged',
                            imageUri:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuBtf0sbyZ6NQ2hwzR-3IKuY-Ws7EC5Z895meiDc-HpNhYVjyj3_KvwB4FsAGy7dZVvuYih7KMd7om0fvyph4V5WfrfgsQqlLgpRxM5ZtSjqapYmD1UPTzQ2DNGyVeXX5A9LeNs5R54zcCqM8Ha8-0JUQ7oPeT_1C_PqytAXS8uKfzNArK07hWVcoewNuvzU5jlNR5o6s0djdWUlsf3UEYP6N-KWhmGqobU_8MtxKls9DBwk8kJOyB0zmCqjF-ss7JU_fYkuQRhOe2M',
                            calories: log.calories,
                            protein: 0,
                            fat: 0,
                            healthType: healthType,
                            primaryColor: primaryColor,
                            cardColor: cardLight,
                            textColor: textColor,
                          ),
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
            shadowColor: primaryColor.o(0.4),
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
                  color: Colors.black.o(0.1),
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
          color: backgroundLight.o(0.95),
          border: Border(top: BorderSide(color: Colors.black.o(0.05))),
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
                                  color: textColor.o(0.4),
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
                                  color: healthColor.o(0.6),
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
                            color: textColor.o(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$calories kcal',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textColor.o(0.5),
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
                              color: textColor.o(0.5),
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
                              color: textColor.o(0.5),
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
