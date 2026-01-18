import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of screens to display.
    // Note: We create them here. For better performance/state preservation,
    // we might want to use IndexedStack, but for now simple switching is fine.
    // List of screens to display.
    // Note: We create them here. For better performance/state preservation,
    // we might want to use IndexedStack, but for now simple switching is fine.
    // final List<Widget> screens = [
    //   HomeScreen(cameras: widget.cameras),
    //   ScanScreen(cameras: widget.cameras), // Direct access to Scan tab
    //   const ProfileScreen(),
    // ];

    // Since HomeScreen now handles navigation internally, we just return it directly.
    return HomeScreen(cameras: widget.cameras);
  }
}
