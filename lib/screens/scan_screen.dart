import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/mock_food_api_service.dart';
import '../models/manual_food_item.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isProcessing = false;
  String? _error;
  FlashMode _flashMode = FlashMode.off;
  String _scanMode = 'single'; // 'single' or 'full'

  // Colors from design
  static const primaryColor = Color(0xFF13ec5b);

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    if (widget.cameras.isEmpty) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _error = 'No camera found on this device.';
        });
      }
      return;
    }

    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      await _controller!.setFlashMode(_flashMode);
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _error = 'Failed to initialize camera.';
        });
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final newMode = _flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    try {
      await _controller!.setFlashMode(newMode);
      setState(() => _flashMode = newMode);
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    try {
      final picture = await _controller!.takePicture();
      // In a real app, we might crop based on the reticle here.

      // Mock Analysis
      final result = await MockFoodApiService().analyzeFood(picture.path);
      if (!mounted) return;

      // Turn off flash before navigating if it was on torch mode
      if (_flashMode == FlashMode.torch) {
        await _controller!.setFlashMode(FlashMode.off);
        setState(() => _flashMode = FlashMode.off);
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            foodName: result.foodName,
            calories: result.estimatedCalories,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan failed. Try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showManualEntrySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant_menu, color: primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        'Manual Food Entry',
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0d1b12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // List
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildFoodCategory('Malaysian Favorites', [
                        ManualFoodItem(
                          'Nasi Lemak',
                          644,
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuM0h-L_g5UqYtG5-0c7f1_e1M2G9N0xLw0_Z5a2_J7t1_h9_K0r5_Z0q_X8J5_V4_R3_T6_Y9_U0_I2_O5_P8_L3_M1',
                        ),
                        ManualFoodItem(
                          'Roti Canai',
                          300,
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuP9_Q4_R5_S1_T7_U2_V5_W8_X3_Y6_Z9_A2_B5_C8_D1_E4_F7_G0_H3_I6_J9_K2_L5_M8_N1_O4_P7',
                        ),
                        ManualFoodItem('Teh Tarik', 90, ''),
                        ManualFoodItem('Fried Rice (Kampung)', 500, ''),
                        ManualFoodItem('Curry Mee', 450, ''),
                      ]),
                      const SizedBox(height: 24),
                      _buildFoodCategory('Staples & Basics', [
                        ManualFoodItem('White Rice (1 cup)', 200, ''),
                        ManualFoodItem('Fried Chicken (1 pc)', 260, ''),
                        ManualFoodItem('Bread (White/Wholemeal)', 80, ''),
                        ManualFoodItem('Milk (1 glass)', 150, ''),
                        ManualFoodItem('Boiled Egg', 70, ''),
                      ]),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFoodCategory(String title, List<ManualFoodItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        ...items.map((item) => _buildFoodItemTile(item)),
      ],
    );
  }

  Widget _buildFoodItemTile(ManualFoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pop(context); // Close sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                foodName: item.name,
                calories: item.calories,
                imageUrl: item.imageUrl.isNotEmpty ? item.imageUrl : null,
              ),
            ),
          );
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: primaryColor, size: 20),
        ),
        title: Text(
          item.name,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0d1b12),
          ),
        ),
        trailing: Text(
          '${item.calories} kcal',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(_error!, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    if (_isInitializing || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera Preview
          CameraPreview(_controller!),

          // 2. Gradient Overlays for Readability
          // Top Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ),
          // Bottom Gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
          ),

          // 3. Top Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCircleButton(
                      icon: Icons.close,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildCircleButton(
                      icon: _flashMode == FlashMode.off
                          ? Icons.flash_off
                          : Icons.flash_on,
                      onTap: _toggleFlash,
                      isActive: _flashMode != FlashMode.off,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Center Reticle & Instructions
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reticle Box
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    children: [
                      // Corner Brackets
                      Positioned(
                        top: 0,
                        left: 0,
                        child: _buildCorner(isTop: true, isLeft: true),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: _buildCorner(isTop: true, isLeft: false),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: _buildCorner(isTop: false, isLeft: true),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: _buildCorner(isTop: false, isLeft: false),
                      ),
                      // Center Focus Point
                      Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Instructions
                Text(
                  'Point at your meal',
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Align food within the frame',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                    shadows: [
                      const Shadow(
                        blurRadius: 2,
                        color: Colors.black54,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 5. Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Mode Selector
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildModeChip('Single Item', 'single'),
                          _buildModeChip('Full Meal', 'full'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Actions Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Gallery Button
                          _buildBottomActionButton(
                            label: 'History',
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  // Placeholder image
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCj3Ru18d53PPXAfoR5OeiVvCVVEAG3uXzY8KgzeE7IAwCRL8hDsD_yP-cPLa_c2Ijx53kDran0hbioFtR2YLNEmOwOLt0nI1xbq6YG9q8DT-eeS05Pj2lMcl6hevOWDtoLaThmXferFUn6EkpBnC9b7V2FstJH2WUtvuYH8MUiuSpnaaA0WEPb7FjpWcfSLG64cQTeZpZl0A7GFMndue61ZnBuzAjo0jcQ19T0MibMKxKeGyvU5wspU5UDhnL1guLDv4RQXOCrzs8',
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.8,
                                ),
                              ),
                            ),
                            onTap: () {
                              // TODO: Gallery navigation
                            },
                          ),

                          // Shutter Button
                          GestureDetector(
                            onTap: _isProcessing ? null : _captureAndAnalyze,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: _isProcessing
                                    ? const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          // Manual Input Button
                          _buildBottomActionButton(
                            label: 'Manual',
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: const Icon(
                                Icons.keyboard,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            onTap: _showManualEntrySheet,
                          ),
                        ],
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

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive
                ? primaryColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? primaryColor : Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    const double size = 32;
    const double thickness = 4;
    const radius = Radius.circular(16);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          top: isTop
              ? const BorderSide(color: primaryColor, width: thickness)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: primaryColor, width: thickness)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: primaryColor, width: thickness)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: primaryColor, width: thickness)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? radius : Radius.zero,
          topRight: isTop && !isLeft ? radius : Radius.zero,
          bottomLeft: !isTop && isLeft ? radius : Radius.zero,
          bottomRight: !isTop && !isLeft ? radius : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildModeChip(String label, String value) {
    final isSelected = _scanMode == value;
    return GestureDetector(
      onTap: () => setState(() => _scanMode = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        height: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionButton({
    required String label,
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
