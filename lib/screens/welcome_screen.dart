import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure google_fonts is in pubspec, otherwise fallback
import 'package:nutriscan/utils/color_ext.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const primaryColor = Color(0xFF13ec5b);
    const backgroundLight = Color(0xFFf6f8f6);
    // const backgroundDark = Color(0xFF102216); // For dark mode support later

    return Scaffold(
      backgroundColor: backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.filter_center_focus,
                    color: primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'NutriScan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0d1b12),
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Hero Visual
                    Container(
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.o(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          // Main Image
                          Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCAwiajLagzr2th1P_i1Q0h4zrdV5FyRW8dRzMaRpV91_ua9WZoB97ByZkCQ6bASQ_E01J1xyPUvcx_j6RGj5dqJ7G2CYs9doytRUSEPvOrVBKIff-f0_kq3zNoiXPBqkq6NmezrLPsJnLZzucz786hpkoVE7LmBXCRbMv_GY5bE9twCd2XbJ1IVWcyspz3Ec3yUtizn-XqJgQsp4OYyvp8SyBYXNmw9WIBKj6lr6kdlmGwMQzWLy7VBT6WCsuBNkRW1mvwDPLNaWs',
                            fit: BoxFit.cover,
                            height: 400,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 400,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 400,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  ),
                                ),
                          ),

                          // Dark Overlay
                          Positioned.fill(
                            child: Container(color: Colors.black.o(0.1)),
                          ),

                          // Scanning UI Overlay
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildCorner(true, true, primaryColor),
                                      _buildCorner(true, false, primaryColor),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildCorner(false, true, primaryColor),
                                      _buildCorner(false, false, primaryColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Scan Line Animation
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Positioned(
                                top:
                                    100 +
                                    (_controller.value *
                                        200), // Animate between top and bottom
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.o(0),
                                        primaryColor,
                                        Colors.white.o(0),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.o(0.6),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Floating Info Tag
                          Positioned(
                            bottom: 24,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.o(0.9),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.o(0.2),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.o(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildMacroBubble('P', Colors.green),
                                    const SizedBox(
                                      width: 4,
                                    ), // Negative spacing handled by overlapping if needed, but simple gap is fine here
                                    _buildMacroBubble('C', Colors.orange),
                                    const SizedBox(width: 4),
                                    _buildMacroBubble('F', Colors.blue),
                                    const SizedBox(width: 12),
                                    Text(
                                      'ANALYSIS READY',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: const Color(0xFF0d1b12),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 8,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.o(0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Text Content
                    Text(
                      'Nutrition in a Snap',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0d1b12),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Instantly analyze calories, macros, and ingredients with our smart AI scanner.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48), // Spacer
                  ],
                ),
              ),
            ),

            // Bottom Action Area
            Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    backgroundLight,
                    backgroundLight.o(0.8),
                    backgroundLight.o(0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: const Color(0xFF0d1b12),
                        elevation: 0,
                        shadowColor: primaryColor.o(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(0xFF0d1b12),
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildCorner(bool isTop, bool isLeft, Color color) {
    const double size = 40;
    const double thickness = 4;
    const double radius = 12;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: isTop
              ? BorderSide(color: color, width: thickness)
              : BorderSide.none,
          bottom: isTop
              ? BorderSide.none
              : BorderSide(color: color, width: thickness),
          left: isLeft
              ? BorderSide(color: color, width: thickness)
              : BorderSide.none,
          right: isLeft
              ? BorderSide.none
              : BorderSide(color: color, width: thickness),
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft
              ? const Radius.circular(radius)
              : Radius.zero,
          topRight: isTop && !isLeft
              ? const Radius.circular(radius)
              : Radius.zero,
          bottomLeft: !isTop && isLeft
              ? const Radius.circular(radius)
              : Radius.zero,
          bottomRight: !isTop && !isLeft
              ? const Radius.circular(radius)
              : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildMacroBubble(String text, Color baseColor) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: baseColor.o(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: baseColor.o(0.8),
            fontWeight: FontWeight.w900,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
