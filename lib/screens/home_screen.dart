import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                children: [
                  // Today Section
                  _buildSectionHeader('Today', '1240 kcal', primaryColor),
                  const SizedBox(height: 16),
                  _buildMealCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultScreen(
                          foodName: 'Avocado Toast',
                          calories: 350,
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDXrzaAaY5DRV_A0zpW-XljYGDxyoZZ9TLlej4q-43_QoRP4CnAqfe7CoGA86vP0_3Ra4JLNpjSSSL8e4w846YMbS071EC48k8t0r7JzMJBy5kuVDcgBwjNS52kDsKukzrRN_5VC4WAhjFbldrPyAMXE7DOHB3X_AkV8YdP3OhOeQm_BoZ_0cQoEOpMiGD0bhi7DyY8pbjrMxwOiCyevDzkRH8dDn5y_4rcmxS_kGG28Ib7XRLnrwGU8OLyZmNKTOAet_8aArPHIjU',
                          protein: 12,
                          fat: 18,
                          carbs: 45,
                          isViewOnly: true,
                        ),
                      ),
                    ),
                    title: 'Avocado Toast',
                    category: 'Breakfast',
                    imageUri:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDXrzaAaY5DRV_A0zpW-XljYGDxyoZZ9TLlej4q-43_QoRP4CnAqfe7CoGA86vP0_3Ra4JLNpjSSSL8e4w846YMbS071EC48k8t0r7JzMJBy5kuVDcgBwjNS52kDsKukzrRN_5VC4WAhjFbldrPyAMXE7DOHB3X_AkV8YdP3OhOeQm_BoZ_0cQoEOpMiGD0bhi7DyY8pbjrMxwOiCyevDzkRH8dDn5y_4rcmxS_kGG28Ib7XRLnrwGU8OLyZmNKTOAet_8aArPHIjU',
                    calories: 350,
                    protein: 12,
                    fat: 18,
                    healthType: HealthScoreType.good,
                    primaryColor: primaryColor,
                    cardColor: cardLight,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultScreen(
                          foodName: 'Chicken Caesar Wrap',
                          calories: 520,
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBi38-Bk6Kxn0f3cIeZREjDguJYQb6DE1mDBpDxEOJO0mmhRwM6G-0_HsSMRnWniHEwhjbKDLk2Ad2HztX3q79_AGtMq-MjZlRW8DzCSSXpXR-iH2ExabzvxikaOMLv69_MaZJzZ6IyYIbatVpfgKyb2WfLWmF6NOTN3wBubY6y1AK-R0oU6VO7RiAnJitppEUzGZV-wqf4sPThOi5V83S-enBgv58IbI9mcKM54PwmoRBLxWIbaBied4JHz4cHN8YAuz-_iZrNzts',
                          protein: 35,
                          fat: 22,
                          carbs: 40,
                          isViewOnly: true,
                        ),
                      ),
                    ),
                    title: 'Chicken Caesar Wrap',
                    category: 'Lunch',
                    imageUri:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBi38-Bk6Kxn0f3cIeZREjDguJYQb6DE1mDBpDxEOJO0mmhRwM6G-0_HsSMRnWniHEwhjbKDLk2Ad2HztX3q79_AGtMq-MjZlRW8DzCSSXpXR-iH2ExabzvxikaOMLv69_MaZJzZ6IyYIbatVpfgKyb2WfLWmF6NOTN3wBubY6y1AK-R0oU6VO7RiAnJitppEUzGZV-wqf4sPThOi5V83S-enBgv58IbI9mcKM54PwmoRBLxWIbaBied4JHz4cHN8YAuz-_iZrNzts',
                    calories: 520,
                    protein: 35,
                    fat: 22,
                    healthType: HealthScoreType.moderate,
                    primaryColor: primaryColor,
                    cardColor: cardLight,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultScreen(
                          foodName: 'Greek Yogurt & Berries',
                          calories: 180,
                          imageUrl:
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBUbX6ej0crAM7b6bRXMfcLcdPvzMQB10Awio7urPMIh01xmncMIWowzUXe2hrlUWiiUzdSHnAk8j5-GllafamDJBMCFaEnkwGSg1RodXCpUS-ddQlHtok-V7geKYRIhMIbtxVYrPvREInPWVfmvCYsu4IXJcMO0K2C13yfxV64NbKKa81GPfAfmH1Xm7xHmSb316mcQ-o4OX5GE_dDIoRB0aw17_3FsIC-lt8Z7RT8qFYu7lYoi16wMb8reZrjyssxZ1GEht2K-wA',
                          protein: 15,
                          fat: 0,
                          carbs: 25,
                          isViewOnly: true,
                        ),
                      ),
                    ),
                    title: 'Greek Yogurt & Berries',
                    category: 'Snack',
                    imageUri:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBUbX6ej0crAM7b6bRXMfcLcdPvzMQB10Awio7urPMIh01xmncMIWowzUXe2hrlUWiiUzdSHnAk8j5-GllafamDJBMCFaEnkwGSg1RodXCpUS-ddQlHtok-V7geKYRIhMIbtxVYrPvREInPWVfmvCYsu4IXJcMO0K2C13yfxV64NbKKa81GPfAfmH1Xm7xHmSb316mcQ-o4OX5GE_dDIoRB0aw17_3FsIC-lt8Z7RT8qFYu7lYoi16wMb8reZrjyssxZ1GEht2K-wA',
                    calories: 180,
                    protein: 15,
                    fat: 0,
                    healthType: HealthScoreType.good,
                    primaryColor: primaryColor,
                    cardColor: cardLight,
                    textColor: textColor,
                  ),

                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[200]),
                  const SizedBox(height: 24),

                  // Yesterday Section
                  _buildSectionHeader('Yesterday', '2100 kcal', Colors.grey),
                  const SizedBox(height: 16),
                  Opacity(
                    opacity: 0.8,
                    child: _buildMealCard(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultScreen(
                            foodName: 'Spaghetti Carbonara',
                            calories: 800,
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCvEgt4xcVRbkP14UQNqVhA07lUDoDi8wfPD--lMB9IluN5wWIrHdLXtP2Lt3JDAOfrgCMdmwVZg-QRyuI5dDEWnFVcHj9ftK-oOFve9vydlrufmEUAOrcoROEXifP5L1aQ_Dh0N7nqR-3bPNQ4QrK97p9Qf4H8hn729pRRZFozOv7eewjLTdrWI6okJEPZ3DSQh20UHRdznjGBLNwcrH5mE-3AYxSgWMSYYa5PAy8m_7OJaXjPRg8rB7hjCChG3aiPO1L7rmmGS64',
                            protein: 25,
                            fat: 40,
                            carbs: 85,
                            isViewOnly: true,
                          ),
                        ),
                      ),
                      title: 'Spaghetti Carbonara',
                      category: 'Dinner',
                      imageUri:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCvEgt4xcVRbkP14UQNqVhA07lUDoDi8wfPD--lMB9IluN5wWIrHdLXtP2Lt3JDAOfrgCMdmwVZg-QRyuI5dDEWnFVcHj9ftK-oOFve9vydlrufmEUAOrcoROEXifP5L1aQ_Dh0N7nqR-3bPNQ4QrK97p9Qf4H8hn729pRRZFozOv7eewjLTdrWI6okJEPZ3DSQh20UHRdznjGBLNwcrH5mE-3AYxSgWMSYYa5PAy8m_7OJaXjPRg8rB7hjCChG3aiPO1L7rmmGS64',
                      calories: 800,
                      protein: 25,
                      fat: 40, // High carb implied by calories/context
                      healthType: HealthScoreType.bad,
                      primaryColor: primaryColor,
                      cardColor: cardLight,
                      textColor: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Opacity(
                    opacity: 0.8,
                    child: _buildMealCard(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResultScreen(
                            foodName: 'Chocolate Protein Shake',
                            calories: 140,
                            imageUrl:
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDBobsYuWoUCCdrU9I30LnrxSZHHoZ53syxDSYMUyp_wpxbRa0mI4PE-_SNxfw3qsrAz77HKlYTT3hL5a8lj8zly2sJ-eAzAJHZVQqaUZlLy9ke6Js4W8PihsEv9pg5Din6J9kwhJFBPpYMgM8kRqADiFgmiJe88sF2Pw0tsiXhsPbqCLXey0oW2Usr6dfyHLMtIisMYhoLoCpajy32u5qJwucyX5UfmpxCyPKFyP9FGmwzVwArKHOwnETp1dimJOiltWup61JbRzA',
                            protein: 24,
                            fat: 2,
                            carbs: 8,
                            isViewOnly: true,
                          ),
                        ),
                      ),
                      title: 'Chocolate Protein Shake',
                      category: 'Snack',
                      imageUri:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDBobsYuWoUCCdrU9I30LnrxSZHHoZ53syxDSYMUyp_wpxbRa0mI4PE-_SNxfw3qsrAz77HKlYTT3hL5a8lj8zly2sJ-eAzAJHZVQqaUZlLy9ke6Js4W8PihsEv9pg5Din6J9kwhJFBPpYMgM8kRqADiFgmiJe88sF2Pw0tsiXhsPbqCLXey0oW2Usr6dfyHLMtIisMYhoLoCpajy32u5qJwucyX5UfmpxCyPKFyP9FGmwzVwArKHOwnETp1dimJOiltWup61JbRzA',
                      calories: 140,
                      protein: 24,
                      fat: 2,
                      healthType: HealthScoreType.good,
                      primaryColor: primaryColor,
                      cardColor: cardLight,
                      textColor: textColor,
                    ),
                  ),
                ],
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
